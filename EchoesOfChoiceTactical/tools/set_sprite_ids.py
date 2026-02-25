#!/usr/bin/env python3
"""
Set sprite_id on all FighterData .tres files (classes + enemies).

Reads each .tres file, inserts or updates the sprite_id field, and writes back.
Also prints a coverage report showing which classes need PixelLab sprites.

Usage:
    python tools/set_sprite_ids.py [--dry-run] [--report-only]
"""

import argparse
import re
import sys
from pathlib import Path

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent
CLASSES_DIR = PROJECT_DIR / "resources" / "classes"
ENEMIES_DIR = PROJECT_DIR / "resources" / "enemies"

# ---------------------------------------------------------------------------
# Sprite ID Mappings (from the plan)
# ---------------------------------------------------------------------------

CLASS_SPRITE_IDS: dict[str, str] = {
    # --- Martial Artist tree (unarmed/light fighters) ---
    "martial_artist": "swordsman_2",   # Base: light fighter
    "monk": "swordsman_5",             # T1: disciplined fighter
    "dervish": "bandit_2",             # T1: fast rogue-like (thug)
    "mercenary": "swordsman_4",        # T1: hired sword
    "hunter": "bandit_3",              # T1: tracking/ranged (robber)
    "tempest": "swordsman_6",          # T2: storm warrior
    "ninja": "bandit_1",               # T2: assassin (perfect fit)
    "duelist": "swordsman_3",          # T2: precision swordsman
    "dragoon": "swordsman_8",          # T2: lance/heavy
    "cavalry": "swordsman_9",          # T2: mounted heavy
    "squire": "swordsman_1",           # T2: beginner knight
    "knight": "swordsman_7",           # T2: full plate knight
    "paladin": "swordsman_8",          # T2: holy knight
    "warden": "swordsman_4",           # T2: defensive tank
    "bastion": "swordsman_7",          # T2: ultimate tank
    "ranger": "bandit_3",              # T2: bow/nature (robber)
    "firebrand": "swordsman_6",        # T2: fire sword fighter

    # --- Mage tree (casters) -> vampire now, wizard_* when downloaded ---
    "mage": "vampire_1",               # Base: dark caster
    "acolyte": "vampire_2",            # T1: apprentice healer
    "herald": "vampire_1",             # T1: magical herald
    "priest": "vampire_2",             # T2: holy caster
    "thaumaturge": "vampire_1",        # T2: advanced mage
    "illusionist": "vampire_3",        # T2: trickster mage
    "chronomancer": "vampire_3",       # T2: time mage
    "mistweaver": "vampire_2",         # T2: fog/mist mage
    "pyromancer": "vampire_1",         # T2: fire mage
    "cryomancer": "vampire_3",         # T2: ice mage
    "electromancer": "vampire_1",      # T2: lightning mage
    "hydromancer": "vampire_2",        # T2: water mage
    "geomancer": "vampire_2",          # T2: earth mage
    "stormcaller": "vampire_3",        # T2: storm mage

    # --- Entertainer tree (performers) ---
    "entertainer": "base_male_sword",  # Base: generic performer
    "bard": "base_male_sword",         # T1: musician
    "minstrel": "base_male_sword",     # T1: traveling musician
    "chorister": "base_male_sword",    # T2: choir singer
    "elegist": "base_male_sword",      # T2: mourning poet
    "laureate": "base_male_sword",     # T2: acclaimed poet
    "mime": "bandit_1",                # T2: silent performer (masked)
    "muse": "base_female_sword",       # T2: inspiring artist
    "orator": "base_male_sword",       # T2: speechmaker
    "warcrier": "swordsman_4",         # T2: battle shouter (armored)

    # --- Scholar tree (inventors/academics) ---
    "scholar": "vampire_2",            # Base: robed academic
    "alchemist": "vampire_2",          # T1: potion maker
    "artificer": "vampire_3",          # T1: magical crafter
    "tinker": "base_male_sword",       # T2: mechanical inventor
    "technomancer": "vampire_3",       # T2: tech + magic
    "bombardier": "swordsman_3",       # T2: explosives (light armor)
    "siegemaster": "swordsman_7",      # T2: heavy siege
    "automaton": "vampire_3",          # T2: construct
    "astronomer": "vampire_2",         # T2: stargazer
    "cosmologist": "vampire_3",        # T2: cosmic scholar
    "arithmancer": "vampire_1",        # T2: math mage

    # --- Royal classes ---
    "prince": "swordsman_9",           # Royal: armored prince
    "princess": "base_female_sword",   # Royal: base female
}

ENEMY_SPRITE_IDS: dict[str, str] = {
    # Direct matches
    "goblin": "goblin_1",
    "goblin_shaman": "goblin_2",
    "goblin_archer": "goblin_3",
    "hobgoblin": "goblin_2",
    "zombie": "zombie_1",
    "imp": "imp_1",
    "fiendling": "imp_2",
    "fire_spirit": "imp_3",
    "cave_bat": "imp_2",
    "pixie": "imp_1",
    "sprite": "imp_3",
    "harlequin": "imp_1",
    "bone_sentry": "skeleton_1",
    "cursed_peddler": "skeleton_2",
    "hex_peddler": "skeleton_3",

    # Undead casters -> lich
    "necromancer": "lich_1",
    "warlock": "lich_2",
    "elder_witch": "lich_3",
    "witch": "lich_1",
    "psion": "lich_2",
    "shaman": "lich_1",
    "runewright": "lich_3",
    "chaplain": "lich_2",

    # Spectral -> ghost
    "grave_wraith": "ghost_1",
    "wraith": "ghost_2",
    "dread_wraith": "ghost_3",
    "shade": "ghost_1",
    "dire_shade": "ghost_2",
    "specter": "ghost_3",
    "phantom_prowler": "ghost_2",
    "mirror_stalker": "ghost_3",
    "wisp": "ghost_1",

    # Large constructs -> golem (128x128)
    "arc_golem": "golem_1",
    "ironclad": "golem_2",
    "android": "golem_3",
    "machinist": "golem_2",

    # Demons -> demons (128x128)
    "hellion": "demons_1",
    "arch_hellion": "demons_2",
    "draconian": "demons_3",
    "ringmaster": "demons_3",

    # Fire elemental -> slime_mobs (fluid)
    "fire_elemental": "slime_mobs_1",

    # Water/air/earth elemental -> slime_enemies
    "water_elemental": "slime_enemies_1",
    "air_elemental": "slime_enemies_2",
    "earth_elemental": "slime_enemies_3",

    # Reptiles -> lizardmen
    "frost_wyrmling": "lizardmen_1",
    "fire_wyrmling": "lizardmen_2",
    "gloom_stalker": "lizardmen_3",

    # Beasts -> gnolls
    "wolf": "gnolls_1",
    "shadow_hound": "gnolls_2",
    "wild_boar": "gnolls_3",
    "night_prowler": "gnolls_1",
    "dusk_prowler": "gnolls_2",
    "dread_stalker": "gnolls_3",
    "satyr": "gnolls_2",

    # Large creatures -> ent (128x128)
    "bear": "ent_1",

    # Small creatures -> mushroom
    "bear_cub": "mushroom_1",

    # Nature -> predator_plant
    "nymph": "predator_plant_1",
    "tide_nymph": "predator_plant_2",
    "siren": "predator_plant_3",
    "chanteuse": "predator_plant_2",

    # Boss -> slime_boss (128x128)
    "kraken": "slime_boss_1",

    # Flying/watching -> beholder
    "watcher_lord": "beholder_1",
    "void_watcher": "beholder_2",
    "seraph": "beholder_3",
    "dusk_moth": "beholder_1",
    "twilight_moth": "beholder_2",

    # Humanoid enemies -> swordsman/vampire
    "guard_squire": "swordsman_1",
    "elite_guard_squire": "swordsman_4",
    "guard_mage": "vampire_1",
    "elite_guard_mage": "vampire_3",
    "guard_scholar": "vampire_2",
    "guard_entertainer": "base_male_sword",
    "commander": "swordsman_9",
    "captain": "swordsman_8",
    "street_tough": "swordsman_1",
    "thug": "swordsman_2",
    "pirate": "swordsman_3",

    # Special
    "the_stranger": "vampire_3",
}


# ---------------------------------------------------------------------------
# .tres Editing
# ---------------------------------------------------------------------------

def set_sprite_id_in_tres(filepath: Path, sprite_id: str) -> bool:
    """Set sprite_id in a FighterData .tres file. Returns True if changed."""
    content = filepath.read_text(encoding="utf-8")

    # Check if sprite_id already exists
    if re.search(r'^sprite_id\s*=', content, re.MULTILINE):
        new_content = re.sub(
            r'^sprite_id\s*=\s*"[^"]*"',
            f'sprite_id = "{sprite_id}"',
            content,
            count=1,
            flags=re.MULTILINE,
        )
        if new_content == content:
            return False  # Already set to this value
        filepath.write_text(new_content, encoding="utf-8")
        return True

    # sprite_id doesn't exist in file (default empty string omitted by Godot)
    # Insert after class_display_name or class_id
    for anchor in ["class_display_name", "class_id"]:
        pattern = rf'^({anchor}\s*=\s*"[^"]*")'
        match = re.search(pattern, content, re.MULTILINE)
        if match:
            insert_pos = match.end()
            new_content = (
                content[:insert_pos]
                + f'\nsprite_id = "{sprite_id}"'
                + content[insert_pos:]
            )
            filepath.write_text(new_content, encoding="utf-8")
            return True

    # Fallback: insert after script = ExtResource("1")
    match = re.search(r'^script\s*=\s*ExtResource\("[^"]*"\)', content, re.MULTILINE)
    if match:
        insert_pos = match.end()
        new_content = (
            content[:insert_pos]
            + f'\nsprite_id = "{sprite_id}"'
            + content[insert_pos:]
        )
        filepath.write_text(new_content, encoding="utf-8")
        return True

    return False


def print_coverage_report() -> None:
    """Print sprite coverage by pack type."""
    groups: dict[str, list[str]] = {
        "swordsman": [],
        "bandit": [],
        "vampire": [],
        "base (placeholder)": [],
    }
    for cls, sid in sorted(CLASS_SPRITE_IDS.items()):
        if sid.startswith("swordsman_"):
            groups["swordsman"].append(cls)
        elif sid.startswith("bandit_"):
            groups["bandit"].append(cls)
        elif sid.startswith("vampire_"):
            groups["vampire"].append(cls)
        else:
            groups["base (placeholder)"].append(cls)

    print("\n" + "=" * 60)
    print("SPRITE COVERAGE REPORT")
    print("=" * 60)

    print(f"\nPlayer Classes ({len(CLASS_SPRITE_IDS)} total):")
    for group, classes in groups.items():
        print(f"  {group:20s}: {len(classes):2d} classes")

    print(f"\nEnemies ({len(ENEMY_SPRITE_IDS)} total): all mapped.")

    placeholder_classes = groups["base (placeholder)"]
    if placeholder_classes:
        print(f"\n--- STILL NEED SPRITES ({len(placeholder_classes)}) ---")
        for cls in sorted(placeholder_classes):
            print(f"  {cls}")

    print("\nUpgrade path: wizard_*/archer_* packs will replace vampire_* for mages")
    print("=" * 60)

    # This section is for the future -- no need to list archetypes
    archetypes: dict[str, list[str]] = {}

    print(f"\nNeeded custom archetypes:")
    for archetype, classes in archetypes.items():
        present = [c for c in classes if c in placeholder_classes]
        if present:
            print(f"  {archetype}: {', '.join(present)}")

    print("=" * 60)


def main() -> None:
    parser = argparse.ArgumentParser(description="Set sprite_id on all FighterData .tres files")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be changed without writing")
    parser.add_argument("--report-only", action="store_true", help="Only print coverage report")
    args = parser.parse_args()

    if args.report_only:
        print_coverage_report()
        return

    print("Setting sprite_ids on FighterData .tres files...\n")

    # Process classes
    class_updated = 0
    class_missing = 0
    for class_id, sprite_id in sorted(CLASS_SPRITE_IDS.items()):
        filepath = CLASSES_DIR / f"{class_id}.tres"
        if not filepath.exists():
            print(f"  MISS class/{class_id}.tres (file not found)")
            class_missing += 1
            continue

        if args.dry_run:
            print(f"  [DRY] class/{class_id} -> {sprite_id}")
            class_updated += 1
        else:
            changed = set_sprite_id_in_tres(filepath, sprite_id)
            status = "SET " if changed else "SAME"
            print(f"  {status} class/{class_id} -> {sprite_id}")
            class_updated += 1

    print(f"\nClasses: {class_updated} updated, {class_missing} missing\n")

    # Process enemies
    enemy_updated = 0
    enemy_missing = 0
    for enemy_id, sprite_id in sorted(ENEMY_SPRITE_IDS.items()):
        filepath = ENEMIES_DIR / f"{enemy_id}.tres"
        if not filepath.exists():
            print(f"  MISS enemy/{enemy_id}.tres (file not found)")
            enemy_missing += 1
            continue

        if args.dry_run:
            print(f"  [DRY] enemy/{enemy_id} -> {sprite_id}")
            enemy_updated += 1
        else:
            changed = set_sprite_id_in_tres(filepath, sprite_id)
            status = "SET " if changed else "SAME"
            print(f"  {status} enemy/{enemy_id} -> {sprite_id}")
            enemy_updated += 1

    print(f"\nEnemies: {enemy_updated} updated, {enemy_missing} missing")

    # Check for unmapped files
    all_class_files = {f.stem for f in CLASSES_DIR.glob("*.tres")}
    unmapped_classes = all_class_files - set(CLASS_SPRITE_IDS.keys())
    if unmapped_classes:
        print(f"\nWARNING: {len(unmapped_classes)} class files have no sprite mapping:")
        for c in sorted(unmapped_classes):
            print(f"  {c}")

    all_enemy_files = {f.stem for f in ENEMIES_DIR.glob("*.tres")}
    unmapped_enemies = all_enemy_files - set(ENEMY_SPRITE_IDS.keys())
    if unmapped_enemies:
        print(f"\nWARNING: {len(unmapped_enemies)} enemy files have no sprite mapping:")
        for e in sorted(unmapped_enemies):
            print(f"  {e}")

    print_coverage_report()


if __name__ == "__main__":
    main()
