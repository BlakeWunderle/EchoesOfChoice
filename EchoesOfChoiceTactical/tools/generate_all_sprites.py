#!/usr/bin/env python3
"""
Batch-generate SpriteFrames .tres files for all CraftPix sprites.

Scans sprite source directories, reads PNG dimensions with PIL,
and writes Godot 4 SpriteFrames .tres files directly (no Godot import needed).

Usage:
    python tools/generate_all_sprites.py [--only <sprite_id>] [--dry-run]
"""

import argparse
import re
import sys
from pathlib import Path

from PIL import Image

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent
ASSETS_DIR = PROJECT_DIR / "assets" / "art" / "sprites"
SOURCE_DIR = PROJECT_DIR.parent / "assets_library" / "sprites"
OUTPUT_DIR = ASSETS_DIR / "spriteframes"
PROCESSED_DIR = ASSETS_DIR / "processed"

# Animation keywords for classifying PNG filenames
ANIM_KEYWORDS = {
    "idle": ["Idle"],
    "walk": ["Walk"],
    "attack": ["attack", "Attack"],
    "hurt": ["Hurt"],
    "death": ["Death"],
}
WALK_FALLBACK = ["Run"]
SKIP_PREFIXES = ["shadow_", "Shadow_", "Shadow."]
SKIP_CONTAINS = ["Run_Attack", "Walk_Attack"]
ANIM_ORDER = ["idle", "walk", "attack", "hurt", "death"]
LOOP_ANIMS = {"idle", "walk"}
ROW_ORDER = ["down", "left", "right", "up"]
ROW_ORDER_3DIR = ["down", "right", "up"]  # 3-dir mode: west handled by flip_h


# ---------------------------------------------------------------------------
# Sprite Registry: sprite_id -> source config
# ---------------------------------------------------------------------------

SPRITES: dict[str, dict] = {}


def _reg(sprite_id: str, rel_path: str, fw: int = 64, fh: int = 64) -> None:
    """Register a pixel-art sprite (single sheet, 4 direction rows)."""
    SPRITES[sprite_id] = {"path": rel_path, "fw": fw, "fh": fh, "mode": "sheet"}


def _reg_4dir(sprite_id: str, rel_path: str, target_size: int = 64) -> None:
    """Register a 4-direction vector sprite (per-direction files, needs compositing)."""
    SPRITES[sprite_id] = {"path": rel_path, "mode": "4dir", "target": target_size}


def _reg_3dir(sprite_id: str, rel_path: str, fw: int = 64, fh: int = 64) -> None:
    """Register a 3-direction synthesized sprite (south/east/north, west=flip).

    Expects pre-processed composites from synthesize_directions.py in
    assets/art/sprites/processed/<sprite_id>/ with 3-row PNGs.
    """
    SPRITES[sprite_id] = {"path": rel_path, "fw": fw, "fh": fh, "mode": "3dir"}


# --- Characters: Swordsman (9 variants, 64x64) ---
for lvl in range(1, 4):
    _reg(f"swordsman_{lvl}",
         f"characters/swordsman_1_3/PNG/Swordsman_lvl{lvl}/Without_shadow")
for lvl in range(4, 7):
    _reg(f"swordsman_{lvl}",
         f"characters/swordsman_4_6/PNG/Swordsman_lvl{lvl}/Without_shadow")
for lvl in range(7, 10):
    _reg(f"swordsman_{lvl}",
         f"characters/swordsman_7_9/PNG/Swordsman_lvl{lvl}/Without_shadow")

# --- Characters: Vampire (3 variants, 64x64) ---
for i in range(1, 4):
    _reg(f"vampire_{i}",
         f"characters/vampire/PNG/Vampires{i}/Without_shadow")

# --- Characters: Base male/female sword (64x64) ---
_reg("base_male_sword", "characters/base_male/PNG/Sword/Without_shadow")
_reg("base_female_sword", "characters/base_female/PNG/Sword/Without_shadow")

# --- Characters: Bandit (3 variants, 4-direction vector -> 64x64) ---
_reg_4dir("bandit_1", "characters/bandit/Assassin/PNG/Spritesheets")
_reg_4dir("bandit_2", "characters/bandit/Thug/PNG/Spritesheets")
_reg_4dir("bandit_3", "characters/bandit/Robber/PNG/Spritesheets")

# --- Characters: Roguelike Kit (pixel art, paths TBD after download) ---
_reg("roguelike_wizard", "characters/roguelike_kit/Wizard/Without_shadow")
_reg("roguelike_archer", "characters/roguelike_kit/Archer/Without_shadow")
_reg("roguelike_knight", "characters/roguelike_kit/Knight/Without_shadow")

# --- Characters: Wizard 4-direction (vector, paths TBD after download) ---
_reg_4dir("wizard_1", "characters/wizard_male/Wizard1/PNG/Spritesheets")
_reg_4dir("wizard_2", "characters/wizard_male/Wizard2/PNG/Spritesheets")
_reg_4dir("wizard_f1", "characters/wizard_female/Wizard1/PNG/Spritesheets")
_reg_4dir("wizard_f2", "characters/wizard_female/Wizard2/PNG/Spritesheets")

# --- Characters: Archer 4-direction (vector, paths TBD after download) ---
_reg_4dir("archer_1", "characters/archer/Archer1/PNG/Spritesheets")
_reg_4dir("archer_2", "characters/archer/Archer2/PNG/Spritesheets")

# --- Characters: Warrior 4-direction (vector, paths TBD after download) ---
_reg_4dir("warrior_1", "characters/warrior_pack/Knight/PNG/Spritesheets")
_reg_4dir("warrior_2", "characters/warrior_pack/Mage/PNG/Spritesheets")
_reg_4dir("warrior_3", "characters/warrior_pack/Archer/PNG/Spritesheets")
_reg_4dir("warrior_free_1", "characters/warrior_free/Warrior1/PNG/Spritesheets")
_reg_4dir("warrior_free_2", "characters/warrior_free/Warrior2/PNG/Spritesheets")

# --- Characters: Chibi 3-direction (synthesized from synthesize_directions.py) ---
# All 54 player classes mapped to Chibi packs for unified art style.
_chibi_3dir_sprites = [
    # Martial Artist sub-tree
    "chibi_monk_old_warrior_monk_guy",
    "chibi_spiritual_monk_1",
    "chibi_persian_arab_warriors_persian_and_arab_warriors_1",
    "chibi_mercenaries_1",
    "chibi_forest_ranger_1",
    "chibi_samurai_1",
    "chibi_ninja_assassin_black_ninja",
    "chibi_samurai_2",
    "chibi_spartan_knight_warrior_spartan_knight_with_spear",
    "chibi_archer_1",
    # Squire sub-tree
    "chibi_knight_1",
    "chibi_armored_knight_medieval_knight",
    "chibi_paladin_1",
    "chibi_armored_knight_templar_knight",
    "chibi_king_defender_sergeant_very_heavy_armored_frontier_defender",
    "chibi_medieval_warrior_medieval_commander",
    "chibi_pyromancer_3",
    # Mage tree
    "chibi_magician_1",
    "chibi_priest_1",
    "chibi_magician_2",
    "chibi_dark_oracle_1",
    "chibi_shaman_of_thunder_1",
    "chibi_priest_2",
    "chibi_magician_3",
    "chibi_dark_oracle_2",
    "chibi_time_keeper_1",
    "chibi_pyromancer_1",
    "chibi_winter_witch_1",
    "chibi_shaman_of_thunder_2",
    "chibi_shaman_1",
    "chibi_human_shaman_1",
    # Entertainer tree
    "chibi_villager_1",
    "chibi_old_hero_1",
    "chibi_priest_3",
    "chibi_citizen_1",
    "chibi_thief_pirate_rogue_rogue",
    "chibi_magician_girl_3",
    "chibi_citizen_2",
    "chibi_ninja_assassin_white_ninja",
    "chibi_magician_girl_1",
    "chibi_viking_1",
    # Scholar tree
    "chibi_old_hero_2",
    "chibi_bloody_alchemist_1",
    "chibi_technomage_1",
    "chibi_gnome_1",
    "chibi_technomage_2",
    "chibi_mercenaries_2",
    "chibi_king_defender_sergeant_medieval_sergeant",
    "chibi_golem_1",
    "chibi_old_hero_3",
    "chibi_witch_1",
    "chibi_cursed_alchemist_1",
    # Royal
    "chibi_king_defender_sergeant_medieval_king",
    "chibi_valkyrie_1",
    # Additional base sprites (newly assigned)
    "chibi_samurai_3",
    "chibi_archer_3",
    "chibi_ninja_assassin_assassin_guy",
    "chibi_amazon_warrior_3",
    "chibi_witch_2",
    "chibi_witch_3",
    "chibi_winter_witch_2",
    "chibi_winter_witch_3",
    "chibi_time_keeper_2",
    "chibi_fantasy_warrior_medieval_hooded_girl",
    # Gender base sprites
    "chibi_amazon_warrior_1",
    "chibi_amazon_warrior_2",
    "chibi_medieval_warrior_girl",
    "chibi_valkyrie_2",
    "chibi_valkyrie_3",
    "chibi_forest_ranger_2",
    "chibi_forest_ranger_3",
    "chibi_magician_girl_2",
    "chibi_citizen_3",
    "chibi_pyromancer_2",
    "chibi_villager_2",
    "chibi_fantasy_warrior_black_wizard",
    "chibi_shaman_2",
    "chibi_dark_oracle_3",
    # Synthesized packs
    "chibi_women_citizen_women_1",
    "chibi_women_citizen_women_2",
    "chibi_women_citizen_women_3",
    "chibi_mimic_1",
    "chibi_mimic_2",
    "chibi_mimic_3",
    # --- Palette swap variants (Squire tree) ---
    "chibi_medieval_warrior_girl_duelist",
    "chibi_amazon_warrior_2_cavalry",
    "chibi_spartan_knight_warrior_spartan_knight_with_spear_f",
    "chibi_elf_archer_archer_2_ranger",
    "chibi_mercenaries_1_f",
    "chibi_forest_ranger_1_hunter",
    "chibi_armored_knight_templar_knight_f",
    "chibi_king_defender_sergeant_very_heavy_armored_frontier_defender_f",
    "chibi_priest_1_martial_artist",
    "chibi_spiritual_monk_1_f",
    # --- Palette swap variants (Royal) ---
    "chibi_armored_knight_medieval_knight_royal",
    "chibi_amazon_warrior_1_royal",
    # --- Palette swap variants (Mage tree) ---
    "chibi_magician_1_blonde",
    "chibi_magician_1_white",
    "chibi_dark_oracle_1_mistweaver",
    "chibi_dark_oracle_1_firebrand",
    "chibi_dark_oracle_1_stormcaller",
    "chibi_pyromancer_2_mistweaver",
    "chibi_pyromancer_2_firebrand",
    "chibi_pyromancer_2_stormcaller",
    "chibi_shaman_of_thunder_2_cryomancer",
    "chibi_shaman_of_thunder_2_hydromancer",
    "chibi_winter_witch_1_cryomancer",
    "chibi_winter_witch_1_hydromancer",
    "chibi_magician_3_pyromancer",
    "chibi_magician_3_geomancer",
    "chibi_fantasy_warrior_medieval_hooded_girl_pyromancer",
    "chibi_fantasy_warrior_medieval_hooded_girl_geomancer",
    "chibi_magician_undead_magician_3_electromancer",
    "chibi_magician_undead_magician_3_tempest",
    "chibi_witch_3_electromancer",
    "chibi_witch_3_tempest",
    "chibi_ghost_knight_2_ghost_knight_3_acolyte",
    "chibi_priest_3_f",
    "chibi_valkyrie_3_paladin",
    # --- Palette swap variants (Entertainer tree) ---
    "chibi_women_citizen_women_3_bard",
    "chibi_valkyrie_3_warcrier",
    "chibi_vampire_hunter_1_minstrel",
    "chibi_witch_1_minstrel",
    "chibi_amazon_warrior_3_dervish",
    "chibi_dark_oracle_2_f",
    "chibi_mimic_2_human",
    "chibi_women_citizen_women_1_orator",
    "chibi_women_citizen_women_3_laureate",
    "chibi_citizen_2_chorister",
    "chibi_magician_girl_2_chorister",
    "chibi_winter_witch_2_herald",
    # --- Palette swap variants (Scholar tree) ---
    "chibi_dark_elves_1_scholar",
    "chibi_winter_witch_3_artificer",
    "chibi_dark_elves_3_alchemist",
    "chibi_dark_oracle_3_f",
    "chibi_women_citizen_women_2_tinker",
    "chibi_vampire_hunter_3_bombardier",
    "chibi_valkyrie_1_siegemaster",
    "chibi_fallen_angel_s_1_chronomancer",
    "chibi_dark_oracle_3_cosmologist_f",
    "chibi_old_hero_3_f",
    "chibi_cursed_alchemist_1_f",
    "chibi_golem_1_f",
    "chibi_technomage_2_f",
    # --- Enemy sprites (Chibi upgrades) ---
    # Goblinoid
    "chibi_goblin_1",
    "chibi_goblin_2",
    "chibi_goblin_3",
    "chibi_orc_shaman_shamans_1",
    "chibi_orc_shaman_shamans_2",
    "chibi_orc_shaman_shamans_3",
    "chibi_orc_ogre_goblin_orc",
    "chibi_orc_ogre_goblin_ogre",
    "chibi_orc_ogre_goblin_goblin",
    "chibi_orc_archer_1",
    "chibi_orc_archer_2",
    "chibi_orc_archer_3",
    # Beasts & prowlers
    "chibi_gnoll_1",
    "chibi_gnoll_2",
    "chibi_gnoll_3",
    "chibi_minotaur_1",
    "chibi_minotaur_2",
    "chibi_minotaur_3",
    "chibi_forest_guardian_1",
    "chibi_forest_guardian_2",
    "chibi_forest_guardian_3",
    "chibi_dark_elves_1",
    "chibi_dark_elves_2",
    "chibi_dark_elves_3",
    "chibi_skeleton_hunter_1",
    "chibi_skeleton_hunter_2",
    "chibi_skeleton_hunter_3",
    # City thugs & guards
    "chibi_4_characters_medieval_thug",
    "chibi_4_characters_blacksmith_guy",
    "chibi_4_characters_chibi_prisoner_guy",
    "chibi_4_characters_romanian_settler",
    "chibi_archer_barbarian_mage_barbarian_warrior",
    "chibi_archer_barbarian_mage_archer_guy",
    "chibi_archer_barbarian_mage_medieval_mage",
    "chibi_frost_knight_1",
    "chibi_frost_knight_2",
    "chibi_frost_knight_3",
    "chibi_warrior_heavy_armored_defender_knight",
    "chibi_warrior_medieval_masked_guy",
    "chibi_warrior_persian_warrior",
    "chibi_vampire_hunter_1",
    "chibi_vampire_hunter_2",
    "chibi_vampire_hunter_3",
    # Royal guard variants (unused player variants + palette swaps)
    "chibi_knight_2",
    "chibi_knight_3",
    "chibi_villager_3",
    "chibi_magician_1_royal",
    "chibi_old_hero_2_royal",
    # Demons & imps
    "chibi_blood_demon_1",
    "chibi_blood_demon_2",
    "chibi_blood_demon_3",
    "chibi_devil_hell_knight_succubus_devil",
    "chibi_devil_hell_knight_succubus_hell_knight",
    "chibi_devil_hell_knight_succubus_succubus",
    "chibi_demon_of_darkness_demons_of_darkness_1",
    "chibi_demon_of_darkness_demons_of_darkness_2",
    "chibi_demon_of_darkness_demons_of_darkness_3",
    "chibi_demon_archer_archer_1",
    "chibi_demon_archer_archer_2",
    "chibi_demon_archer_archer_3",
    # Elementals & spirits
    "chibi_elemental_s_1",
    "chibi_elemental_s_2",
    "chibi_elemental_s_3",
    "chibi_elemental_spirits_1",
    "chibi_elemental_spirits_2",
    "chibi_elemental_spirits_3",
    # Spectral
    "chibi_ghost_knight_1",
    "chibi_ghost_knight_2",
    "chibi_ghost_knight_3",
    "chibi_ghost_knight_2_ghost_knight_1",
    "chibi_ghost_knight_2_ghost_knight_2",
    "chibi_ghost_knight_2_ghost_knight_3",
    "chibi_ghost_pirate_1",
    "chibi_ghost_pirate_2",
    "chibi_ghost_pirate_3",
    # Undead
    "chibi_skeleton_warrior_1",
    "chibi_skeleton_warrior_2",
    "chibi_skeleton_warrior_3",
    "chibi_skeleton_nobleman_1",
    "chibi_skeleton_nobleman_2",
    "chibi_skeleton_nobleman_3",
    "chibi_skeleton_sorcerer_1",
    "chibi_skeleton_sorcerer_2",
    "chibi_skeleton_sorcerer_3",
    "chibi_skeleton_witch_1",
    "chibi_skeleton_witch_2",
    "chibi_skeleton_witch_3",
    "chibi_skeleton_pirate_captain_1",
    "chibi_skeleton_pirate_captain_2",
    "chibi_skeleton_pirate_captain_3",
    "chibi_skeleton_crusader_1",
    "chibi_skeleton_crusader_2",
    "chibi_skeleton_crusader_3",
    "chibi_zombie_villager_1",
    "chibi_zombie_villager_2",
    "chibi_zombie_villager_3",
    "chibi_death_knight_skeleton_zombie_death_knight",
    "chibi_death_knight_skeleton_zombie_skeleton",
    "chibi_death_knight_skeleton_zombie_zombie",
    # Dark casters
    "chibi_necromancer_shadow_necromancer_of_the_shadow_1",
    "chibi_necromancer_shadow_necromancer_of_the_shadow_2",
    "chibi_necromancer_shadow_necromancer_of_the_shadow_3",
    "chibi_magician_demon_magician_1",
    "chibi_magician_demon_magician_2",
    "chibi_magician_demon_magician_3",
    "chibi_magician_undead_magician_1",
    "chibi_magician_undead_magician_2",
    "chibi_magician_undead_magician_3",
    # Nature & fey
    "chibi_satyr_1",
    "chibi_satyr_2",
    "chibi_satyr_3",
    "chibi_elf_archer_archer_1",
    "chibi_elf_archer_archer_2",
    "chibi_elf_archer_archer_3",
    "chibi_medusa_1",
    "chibi_medusa_2",
    "chibi_medusa_3",
    # Watchers & angels
    "chibi_fallen_angel_s_1",
    "chibi_fallen_angel_s_2",
    "chibi_fallen_angel_s_3",
    # Halloween
    "chibi_halloween_pumpkin_head_guy",
    "chibi_halloween_skull_knight",
    "chibi_halloween_vampire",
    # Reapers
    "chibi_black_reaper_1",
    "chibi_black_reaper_1_neutral",
    "chibi_black_reaper_1_brown",
    "chibi_black_reaper_2",
    "chibi_black_reaper_3",
    # Golem extras (already synthesized with player classes)
    "chibi_golem_2",
    "chibi_golem_3",
]
for _sid in _chibi_3dir_sprites:
    _reg_3dir(_sid, f"processed/{_sid}")

# --- Enemies: Standard 64x64 ---
_enemy_packs_64 = {
    "skeleton": ("Skeleton", 3),
    "goblin": ("Goblin", 3),
    "zombie": ("Zombie", 3),
    "ghost": ("Ghost", 3),
    "imp": ("Imp", 3),
    "lich": ("Lich", 3),
    "gnolls": ("Gnoll", 3),
    "lizardmen": ("Lizardman", 3),
    "mushroom": ("Mushroom", 3),
    "predator_plant": ("Plant", 3),
    "beholder": ("Beholder", 3),
    "slime_mobs": ("Slime", 3),
    "slime_enemies": ("Slime", 3),
}

for pack, (prefix, count) in _enemy_packs_64.items():
    for i in range(1, count + 1):
        sprite_id = f"{pack}_{i}" if pack not in ("slime_mobs", "slime_enemies") else f"{pack}_{i}"
        _reg(sprite_id,
             f"enemies/{pack}/PNG/{prefix}{i}/Without_shadow")

# --- Enemies: Large 128x128 ---
_enemy_packs_128 = {
    "golem": ("Golem", 3),
    "demons": ("Demon", 3),
    "ent": ("Ent", 3),
    "giant_rat": ("Rat", 3),
    "slime_boss": ("Slime_boss", 3),
}

for pack, (prefix, count) in _enemy_packs_128.items():
    for i in range(1, count + 1):
        _reg(f"{pack}_{i}",
             f"enemies/{pack}/PNG/{prefix}{i}/Without_shadow",
             fw=128, fh=128)


# ---------------------------------------------------------------------------
# 4-Direction Compositing (vector packs -> pixel-art-style sheets)
# ---------------------------------------------------------------------------

# Maps CraftPix direction prefixes to our row order (down=0, left=1, right=2, up=3)
_DIR_MAP = {"Front": 0, "Left": 1, "Right": 2, "Back": 3}

# Maps CraftPix animation names to our standard names
_4DIR_ANIM_MAP = {
    "Idle": "idle",
    "Walking": "walk",
    "Running": "walk",  # fallback
    "Attacking": "attack",
    "Hurt": "hurt",
    "Dying": "death",
}


def _detect_frame_size(dir_path: Path) -> int:
    """Detect frame size from any single-frame PNG sequence file."""
    seq_dirs = sorted(dir_path.parent.glob("PNG Sequences/*/"))
    if not seq_dirs:
        # Fallback: check if there's a sibling PNG Sequences directory
        parent_png = dir_path.parent
        seq_dirs = sorted(parent_png.glob("../PNG Sequences/*/")) if parent_png.exists() else []
    for seq_dir in seq_dirs:
        frames = sorted(seq_dir.glob("*.png"))
        if frames:
            img = Image.open(frames[0])
            return img.width  # Assume square frames
    return 480  # Default for CraftPix vector packs


def composite_4dir(sprite_id: str, dir_path: Path, target: int) -> Path | None:
    """Composite per-direction spritesheets into single multi-row sheets.

    Reads "Front - Idle.png", "Back - Walking.png" etc., downscales frames
    to `target` size, and writes one composite PNG per animation to PROCESSED_DIR.
    Returns the processed directory path, or None on failure.
    """
    out_dir = PROCESSED_DIR / sprite_id
    out_dir.mkdir(parents=True, exist_ok=True)

    # Discover available per-direction spritesheet files
    png_files = sorted(dir_path.glob("*.png"))
    if not png_files:
        return None

    # Group files by animation: {anim_name: {dir_index: Path}}
    anim_groups: dict[str, dict[int, Path]] = {}
    death_file: Path | None = None

    for png in png_files:
        name = png.stem  # e.g. "Front - Idle" or "Dying"

        # Handle non-directional death animation
        if "Dying" in name or "Death" in name:
            death_file = png
            continue

        # Skip blinking variants
        if "Blinking" in name:
            continue

        # Parse "Direction - Animation"
        parts = name.split(" - ", 1)
        if len(parts) != 2:
            continue

        dir_name, anim_name = parts[0].strip(), parts[1].strip()
        if dir_name not in _DIR_MAP:
            continue

        # Map to standard animation name
        std_anim = _4DIR_ANIM_MAP.get(anim_name)
        if not std_anim:
            continue

        dir_idx = _DIR_MAP[dir_name]
        if std_anim not in anim_groups:
            anim_groups[std_anim] = {}
        anim_groups[std_anim][dir_idx] = png

    if not anim_groups:
        return None

    # Detect source frame size
    frame_size = _detect_frame_size(dir_path)

    # Process each animation into a composite sheet
    generated_any = False
    for anim_name in ANIM_ORDER:
        dir_files = anim_groups.get(anim_name)
        if anim_name == "death" and not dir_files and death_file:
            # Use the non-directional Dying file for all 4 directions
            dir_files = {i: death_file for i in range(4)}
        if not dir_files:
            continue

        # Read one sheet to get frame count
        sample_path = next(iter(dir_files.values()))
        sample_img = Image.open(sample_path)
        src_cols = sample_img.width // frame_size
        src_rows = sample_img.height // frame_size
        frame_count = src_cols * src_rows

        # Cap frames to keep sheet reasonable (max 12 per direction)
        frame_count = min(frame_count, 12)

        # Create composite: 4 rows (directions), frame_count columns
        composite = Image.new("RGBA", (frame_count * target, 4 * target), (0, 0, 0, 0))

        for dir_idx in range(4):
            src_path = dir_files.get(dir_idx)
            if not src_path:
                continue
            src_img = Image.open(src_path)

            for f in range(frame_count):
                col = f % src_cols
                row = f // src_cols
                x = col * frame_size
                y = row * frame_size
                frame = src_img.crop((x, y, x + frame_size, y + frame_size))
                frame = frame.resize((target, target), Image.LANCZOS)
                composite.paste(frame, (f * target, dir_idx * target))

        out_path = out_dir / f"{anim_name}.png"
        composite.save(out_path, "PNG")
        generated_any = True

    return out_dir if generated_any else None


# ---------------------------------------------------------------------------
# .tres Generation
# ---------------------------------------------------------------------------

def should_skip(filename: str) -> bool:
    for prefix in SKIP_PREFIXES:
        if filename.startswith(prefix):
            return True
    for pattern in SKIP_CONTAINS:
        if pattern in filename:
            return True
    return False


def classify_file(filename: str) -> str:
    """Map a filename to an animation name based on keywords."""
    lower = filename.lower()
    for anim_name, keywords in ANIM_KEYWORDS.items():
        for keyword in keywords:
            if keyword.lower() in lower:
                return anim_name
    return ""


def discover_anims(dir_path: Path) -> dict[str, Path]:
    """Scan a directory and map animation names to PNG files."""
    anim_files: dict[str, Path] = {}

    png_files = sorted(dir_path.glob("*.png"))
    for png in png_files:
        if should_skip(png.name):
            continue
        anim = classify_file(png.name)
        if anim:
            anim_files[anim] = png

    # Fallback: if no walk, try Run
    if "walk" not in anim_files:
        for png in png_files:
            if should_skip(png.name):
                continue
            for keyword in WALK_FALLBACK:
                if keyword.lower() in png.name.lower():
                    anim_files["walk"] = png
                    break
            if "walk" in anim_files:
                break

    return anim_files


def generate_tres(sprite_id: str, anim_files: dict[str, Path],
                  fw: int, fh: int, fps: float = 8.0,
                  row_order: list[str] | None = None) -> str:
    """Generate a SpriteFrames .tres file as text."""
    if row_order is None:
        row_order = ROW_ORDER

    # Collect all ext_resources (one per unique PNG) and sub_resources (AtlasTextures)
    ext_resources: list[tuple[str, str]]  = []  # (id, res_path)
    sub_resources: list[tuple[str, str, str, str]] = []  # (sub_id, ext_id, region_str, sub_id_label)
    animations: list[dict] = []

    ext_id_counter = 1
    sub_id_counter = 1

    for anim_base in ANIM_ORDER:
        if anim_base not in anim_files:
            continue

        png_path = anim_files[anim_base]
        img = Image.open(png_path)
        img_w, img_h = img.size
        cols = img_w // fw
        rows = img_h // fh

        if cols < 1 or rows < 1:
            continue

        # Convert to res:// path
        try:
            rel = png_path.relative_to(PROJECT_DIR)
        except ValueError:
            continue
        res_path = "res://" + str(rel).replace("\\", "/")

        # Add ext_resource for this PNG
        ext_id = str(ext_id_counter)
        ext_resources.append((ext_id, res_path))
        ext_id_counter += 1

        # Create directional animations
        dir_count = min(rows, len(row_order))
        for dir_i in range(dir_count):
            direction = row_order[dir_i]
            anim_name = f"{anim_base}_{direction}"
            frame_refs = []

            for col in range(cols):
                sub_id = f"AtlasTexture_{sub_id_counter}"
                region = f"Rect2({col * fw}, {dir_i * fh}, {fw}, {fh})"
                sub_resources.append((sub_id, ext_id, region, sub_id))
                frame_refs.append(sub_id)
                sub_id_counter += 1

            animations.append({
                "name": anim_name,
                "speed": fps,
                "loop": anim_base in LOOP_ANIMS,
                "frames": frame_refs,
            })

    if not animations:
        return ""

    # Build the .tres text
    load_steps = len(ext_resources) + len(sub_resources) + 1
    lines = [f'[gd_resource type="SpriteFrames" load_steps={load_steps} format=3]']
    lines.append("")

    # ext_resources
    for ext_id, res_path in ext_resources:
        lines.append(f'[ext_resource type="Texture2D" path="{res_path}" id="{ext_id}"]')

    if ext_resources:
        lines.append("")

    # sub_resources (AtlasTextures)
    for sub_id, ext_id, region, _ in sub_resources:
        lines.append(f'[sub_resource type="AtlasTexture" id="{sub_id}"]')
        lines.append(f'atlas = ExtResource("{ext_id}")')
        lines.append(f"region = {region}")
        lines.append("")

    # resource section
    lines.append("[resource]")

    # Build animations array
    anim_strs = []
    for anim in animations:
        frame_entries = []
        for fref in anim["frames"]:
            frame_entries.append(f'{{\n"duration": 1.0,\n"texture": SubResource("{fref}")\n}}')

        frames_str = "[" + ", ".join(frame_entries) + "]"
        loop_str = "true" if anim["loop"] else "false"
        anim_str = (
            f'{{\n'
            f'"frames": {frames_str},\n'
            f'"loop": {loop_str},\n'
            f'"name": &"{anim["name"]}",\n'
            f'"speed": {anim["speed"]}\n'
            f'}}'
        )
        anim_strs.append(anim_str)

    lines.append("animations = [" + ", ".join(anim_strs) + "]")
    lines.append("")

    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate SpriteFrames .tres for all CraftPix sprites")
    parser.add_argument("--only", type=str, help="Generate only this sprite_id")
    parser.add_argument("--dry-run", action="store_true", help="Print what would be generated without writing")
    args = parser.parse_args()

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    sprites_to_gen = SPRITES
    if args.only:
        if args.only not in SPRITES:
            print(f"ERROR: Unknown sprite_id '{args.only}'")
            print(f"Available: {', '.join(sorted(SPRITES.keys()))}")
            sys.exit(1)
        sprites_to_gen = {args.only: SPRITES[args.only]}

    total = len(sprites_to_gen)
    success = 0
    skipped = 0
    failed = 0

    print(f"Generating {total} SpriteFrames .tres files...")
    print(f"Output: {OUTPUT_DIR}")
    print()

    PROCESSED_DIR.mkdir(parents=True, exist_ok=True)

    for sprite_id, config in sorted(sprites_to_gen.items()):
        mode = config.get("mode", "sheet")
        dir_path = SOURCE_DIR / config["path"]

        if not dir_path.is_dir():
            print(f"  SKIP {sprite_id}: directory not found")
            skipped += 1
            continue

        if mode == "4dir":
            # Composite per-direction sheets into standard format
            target = config["target"]
            processed = composite_4dir(sprite_id, dir_path, target)
            if not processed:
                print(f"  FAIL {sprite_id}: 4-dir compositing failed")
                failed += 1
                continue
            # Now discover anims from the processed directory
            anim_files = discover_anims(processed)
            fw = fh = target
        elif mode == "3dir":
            # 3-direction synthesized sprites (from synthesize_directions.py)
            fw = config["fw"]
            fh = config["fh"]
            processed_path = PROCESSED_DIR / sprite_id
            if not processed_path.is_dir():
                print(f"  SKIP {sprite_id}: processed dir not found (run synthesize_directions.py first)")
                skipped += 1
                continue
            anim_files = discover_anims(processed_path)
        else:
            fw = config["fw"]
            fh = config["fh"]
            anim_files = discover_anims(dir_path)

        if not anim_files:
            print(f"  SKIP {sprite_id}: no animation PNGs found")
            skipped += 1
            continue

        use_row_order = ROW_ORDER_3DIR if mode == "3dir" else ROW_ORDER
        tres_content = generate_tres(sprite_id, anim_files, fw, fh, row_order=use_row_order)
        if not tres_content:
            print(f"  FAIL {sprite_id}: could not generate .tres")
            failed += 1
            continue

        output_path = OUTPUT_DIR / f"{sprite_id}.tres"

        if args.dry_run:
            anim_names = [a for a in ANIM_ORDER if a in anim_files]
            if mode == "4dir":
                label = f"4dir->{fw}x{fh}"
            elif mode == "3dir":
                label = f"3dir->{fw}x{fh}"
            else:
                label = f"{fw}x{fh}"
            print(f"  [DRY] {sprite_id}: {', '.join(anim_names)} ({label})")
        else:
            output_path.write_text(tres_content, encoding="utf-8")
            anim_count = tres_content.count('"name": &"')
            print(f"  OK   {sprite_id}: {anim_count} animations -> {output_path.name}")

        success += 1

    print()
    print(f"Done: {success} generated, {skipped} skipped, {failed} failed (of {total} total)")


if __name__ == "__main__":
    main()
