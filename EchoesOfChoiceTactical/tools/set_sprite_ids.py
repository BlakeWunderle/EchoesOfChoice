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
    # --- Martial Artist sub-tree (unarmed/light fighters) ---
    "martial_artist": "chibi_monk_old_warrior_monk_guy",          # T0: unarmed fighter
    "monk": "chibi_spiritual_monk_1",                              # T1: disciplined martial artist
    "dervish": "chibi_persian_arab_warriors_persian_and_arab_warriors_1",  # T1: fast whirling dancer
    "mercenary": "chibi_mercenaries_1",                            # T1: hired sword
    "hunter": "chibi_forest_ranger_1",                             # T1: tracking/ranged
    "tempest": "chibi_samurai_1",                                  # T2: storm warrior
    "ninja": "chibi_ninja_assassin_black_ninja",                   # T2: assassin
    "duelist": "chibi_samurai_2",                                  # T2: precision swordsman
    "dragoon": "chibi_spartan_knight_warrior_spartan_knight_with_spear",  # T2: lance/heavy
    "ranger": "chibi_archer_1",                                    # T2: bow/nature

    # --- Squire sub-tree (armored fighters) ---
    "squire": "chibi_knight_1",                                    # T0: beginner knight
    "knight": "chibi_armored_knight_medieval_knight",              # T2: full plate knight
    "paladin": "chibi_paladin_1",                                  # T2: holy knight
    "warden": "chibi_armored_knight_templar_knight",               # T2: defensive tank
    "bastion": "chibi_king_defender_sergeant_very_heavy_armored_frontier_defender",  # T2: ultimate tank
    "cavalry": "chibi_medieval_warrior_medieval_commander",        # T2: mounted heavy
    "firebrand": "chibi_pyromancer_3",                              # T1: fire mage

    # --- Mage tree (casters) ---
    "mage": "chibi_magician_1",                                    # T0: base caster
    "acolyte": "chibi_priest_1",                                   # T1: apprentice healer
    "herald": "chibi_magician_2",                                  # T1: magical herald
    "mistweaver": "chibi_dark_oracle_1",                           # T1: fog/mist mage
    "stormcaller": "chibi_shaman_of_thunder_1",                    # T1: storm mage
    "priest": "chibi_priest_2",                                    # T2: holy caster
    "thaumaturge": "chibi_magician_3",                             # T2: advanced mage
    "illusionist": "chibi_dark_oracle_2",                          # T2: trickster mage
    "chronomancer": "chibi_time_keeper_1",                         # T2: time mage
    "pyromancer": "chibi_pyromancer_1",                            # T2: fire mage
    "cryomancer": "chibi_shaman_2",                                 # T2: ice mage (male, recolored blue)
    "electromancer": "chibi_shaman_of_thunder_2",                  # T2: lightning mage
    "hydromancer": "chibi_shaman_1",                               # T2: water mage
    "geomancer": "chibi_human_shaman_1",                           # T2: earth mage

    # --- Entertainer tree (performers) ---
    "entertainer": "chibi_villager_1",                             # T0: humble performer
    "bard": "chibi_old_hero_1",                                    # T1: wandering musician
    "chorister": "chibi_priest_3",                                 # T1: choir singer
    "orator": "chibi_citizen_1",                                   # T1: speechmaker
    "minstrel": "chibi_thief_pirate_rogue_rogue",                 # T2: traveling musician
    "elegist": "chibi_fantasy_warrior_black_wizard",                 # T2: melancholic poet (male)
    "laureate": "chibi_citizen_2",                                 # T2: acclaimed poet
    "mime": "chibi_ninja_assassin_white_ninja",                    # T2: silent performer
    "muse": "chibi_villager_2",                                    # T2: inspiring artist (male)
    "warcrier": "chibi_viking_1",                                  # T2: battle shouter

    # --- Scholar tree (inventors/academics) ---
    "scholar": "chibi_old_hero_2",                                 # T0: robed academic
    "alchemist": "chibi_bloody_alchemist_1",                       # T1: potion maker
    "artificer": "chibi_technomage_1",                             # T1: magical crafter
    "tinker": "chibi_gnome_1",                                     # T2: mechanical inventor
    "technomancer": "chibi_technomage_2",                          # T2: tech + magic
    "bombardier": "chibi_mercenaries_2",                           # T2: explosives expert
    "siegemaster": "chibi_king_defender_sergeant_medieval_sergeant",  # T2: heavy siege
    "automaton": "chibi_golem_1",                                  # T2: construct
    "astronomer": "chibi_old_hero_3",                              # T2: stargazer
    "cosmologist": "chibi_dark_oracle_3",                           # T2: cosmic scholar (male, recolored indigo)
    "arithmancer": "chibi_cursed_alchemist_1",                     # T2: math mage

    # --- Royal classes ---
    "prince": "chibi_king_defender_sergeant_medieval_king",        # Royal: armored prince
    "princess": "chibi_valkyrie_1",                                # Royal: warrior princess
}

CLASS_SPRITE_IDS_FEMALE: dict[str, str] = {
    # Male classes -> add female variant (recolored to match male palette)
    "martial_artist": "chibi_amazon_warrior_1",
    "squire": "chibi_medieval_warrior_girl",
    "knight": "chibi_valkyrie_2",
    "paladin": "chibi_valkyrie_3",
    "mercenary": "chibi_amazon_warrior_2",
    "ranger": "chibi_forest_ranger_2",
    "hunter": "chibi_forest_ranger_3",
    "mage": "chibi_magician_girl_2",
    "entertainer": "chibi_citizen_3",
    "firebrand": "chibi_pyromancer_2",
    "prince": "chibi_valkyrie_1",

    # Female classes -> keep current sprite as female variant
    "muse": "chibi_magician_girl_1",
    "elegist": "chibi_magician_girl_3",
    "cryomancer": "chibi_winter_witch_1",
    "cosmologist": "chibi_witch_1",
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


def set_sprite_id_female_in_tres(filepath: Path, sprite_id_female: str) -> bool:
    """Set sprite_id_female in a FighterData .tres file. Returns True if changed."""
    content = filepath.read_text(encoding="utf-8")

    # Check if sprite_id_female already exists
    if re.search(r'^sprite_id_female\s*=', content, re.MULTILINE):
        new_content = re.sub(
            r'^sprite_id_female\s*=\s*"[^"]*"',
            f'sprite_id_female = "{sprite_id_female}"',
            content,
            count=1,
            flags=re.MULTILINE,
        )
        if new_content == content:
            return False
        filepath.write_text(new_content, encoding="utf-8")
        return True

    # Insert after sprite_id line
    match = re.search(r'^(sprite_id\s*=\s*"[^"]*")', content, re.MULTILINE)
    if match:
        insert_pos = match.end()
        new_content = (
            content[:insert_pos]
            + f'\nsprite_id_female = "{sprite_id_female}"'
            + content[insert_pos:]
        )
        filepath.write_text(new_content, encoding="utf-8")
        return True

    return False


def print_coverage_report() -> None:
    """Print sprite coverage by pack collection."""
    chibi_count = sum(1 for sid in CLASS_SPRITE_IDS.values() if sid.startswith("chibi_"))
    other_count = len(CLASS_SPRITE_IDS) - chibi_count

    # Group by Chibi pack
    packs: dict[str, list[str]] = {}
    for cls, sid in sorted(CLASS_SPRITE_IDS.items()):
        # Extract pack name from sprite_id (e.g. chibi_magician_1 -> magician)
        packs.setdefault(sid, []).append(cls)

    print("\n" + "=" * 60)
    print("SPRITE COVERAGE REPORT")
    print("=" * 60)
    print(f"\nPlayer Classes: {len(CLASS_SPRITE_IDS)} total ({chibi_count} chibi, {other_count} other)")
    print(f"Unique sprites: {len(packs)}")
    print(f"\nEnemies: {len(ENEMY_SPRITE_IDS)} total")
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

    # Process female sprite variants
    female_updated = 0
    for class_id, sprite_id_female in sorted(CLASS_SPRITE_IDS_FEMALE.items()):
        filepath = CLASSES_DIR / f"{class_id}.tres"
        if not filepath.exists():
            continue

        if args.dry_run:
            print(f"  [DRY] class/{class_id} female -> {sprite_id_female}")
            female_updated += 1
        else:
            changed = set_sprite_id_female_in_tres(filepath, sprite_id_female)
            status = "SET " if changed else "SAME"
            print(f"  {status} class/{class_id} female -> {sprite_id_female}")
            female_updated += 1

    print(f"\nFemale variants: {female_updated} updated\n")

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
