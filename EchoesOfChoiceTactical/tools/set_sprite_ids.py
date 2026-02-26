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
    # --- Squire tree (physical fighters) ---
    "squire": "chibi_armored_knight_medieval_knight",              # T0: beginner knight
    "duelist": "chibi_samurai_3",                                  # T1: precision swordsman
    "cavalry": "chibi_medieval_warrior_medieval_commander",        # T2: mounted heavy
    "dragoon": "chibi_spartan_knight_warrior_spartan_knight_with_spear",  # T2: lance/heavy
    "ranger": "chibi_archer_1",                                    # T1: bow/nature
    "mercenary": "chibi_mercenaries_1",                            # T2: hired sword
    "hunter": "chibi_archer_3",                                    # T2: tracking/ranged
    "warden": "chibi_armored_knight_templar_knight",               # T1: defensive tank
    "knight": "chibi_knight_1",                                    # T2: full plate knight
    "bastion": "chibi_king_defender_sergeant_very_heavy_armored_frontier_defender",  # T2: ultimate tank
    "martial_artist": "chibi_monk_old_warrior_monk_guy",           # T1: unarmed fighter
    "ninja": "chibi_ninja_assassin_white_ninja",                   # T2: assassin
    "monk": "chibi_spiritual_monk_1",                              # T2: disciplined fighter

    # --- Mage tree (casters) ---
    "mage": "chibi_magician_1_blonde",                             # T0: base caster (blonde hair)
    "mistweaver": "chibi_dark_oracle_1_mistweaver",                # T1: fog/mist mage (blue)
    "firebrand": "chibi_dark_oracle_1_firebrand",                  # T1: fire hybrid (red)
    "stormcaller": "chibi_dark_oracle_1_stormcaller",              # T1: storm mage (yellow)
    "cryomancer": "chibi_shaman_of_thunder_2_cryomancer",          # T2: ice mage
    "hydromancer": "chibi_shaman_of_thunder_2_hydromancer",        # T2: water mage
    "pyromancer": "chibi_magician_3_pyromancer",                   # T2: fire mage
    "geomancer": "chibi_magician_3_geomancer",                    # T2: earth mage
    "electromancer": "chibi_magician_undead_magician_3_electromancer",  # T2: lightning mage
    "tempest": "chibi_magician_undead_magician_3_tempest",         # T2: wind warrior
    "acolyte": "chibi_priest_1",                                   # T1: apprentice healer
    "paladin": "chibi_paladin_1",                                  # T2: holy knight
    "priest": "chibi_priest_3",                                    # T2: holy caster

    # --- Entertainer tree (performers) ---
    "entertainer": "chibi_villager_1",                             # T0: humble performer
    "bard": "chibi_old_hero_1",                                    # T1: wandering musician
    "warcrier": "chibi_viking_1",                                  # T2: battle shouter
    "minstrel": "chibi_vampire_hunter_1_minstrel",                # T2: traveling musician
    "dervish": "chibi_persian_arab_warriors_persian_and_arab_warriors_1",  # T1: fast dancer
    "illusionist": "chibi_dark_oracle_2",                          # T2: trickster mage
    "mime": "chibi_mimic_2_human",                                 # T2: silent performer
    "orator": "chibi_citizen_1",                                   # T1: speechmaker
    "laureate": "chibi_citizen_2",                                 # T2: acclaimed poet
    "elegist": "chibi_fantasy_warrior_black_wizard",               # T2: melancholic poet
    "chorister": "chibi_citizen_2_chorister",                      # T1: choir singer
    "herald": "chibi_magician_2",                                  # T2: magical herald
    "muse": "chibi_villager_2",                                    # T2: inspiring artist

    # --- Scholar tree (inventors/academics) ---
    "scholar": "chibi_old_hero_2",                                 # T0: robed academic
    "artificer": "chibi_technomage_1",                             # T1: magical crafter
    "alchemist": "chibi_bloody_alchemist_1",                       # T2: potion maker
    "thaumaturge": "chibi_dark_oracle_3",                          # T2: advanced spell research
    "tinker": "chibi_gnome_1",                                     # T1: mechanical inventor
    "bombardier": "chibi_mercenaries_2",                           # T2: explosives expert
    "siegemaster": "chibi_king_defender_sergeant_medieval_sergeant",  # T2: heavy siege
    "cosmologist": "chibi_dark_oracle_3",                          # T1: cosmic scholar
    "astronomer": "chibi_old_hero_3",                              # T2: stargazer
    "chronomancer": "chibi_time_keeper_2",                         # T2: time mage
    "arithmancer": "chibi_cursed_alchemist_1",                     # T1: math mage
    "automaton": "chibi_golem_1",                                  # T2: construct
    "technomancer": "chibi_technomage_2",                          # T2: tech + magic

    # --- Royal classes ---
    "prince": "chibi_armored_knight_medieval_knight_royal",        # Royal: armored prince
    "princess": "chibi_amazon_warrior_1_royal",                    # Royal: warrior princess
}

CLASS_SPRITE_IDS_FEMALE: dict[str, str] = {
    # --- Squire tree ---
    "squire": "chibi_amazon_warrior_1",
    "duelist": "chibi_medieval_warrior_girl_duelist",
    "cavalry": "chibi_amazon_warrior_2_cavalry",
    "dragoon": "chibi_spartan_knight_warrior_spartan_knight_with_spear_f",
    "ranger": "chibi_elf_archer_archer_2_ranger",
    "mercenary": "chibi_mercenaries_1_f",
    "hunter": "chibi_forest_ranger_1_hunter",
    "warden": "chibi_armored_knight_templar_knight_f",
    "knight": "chibi_valkyrie_2",
    "bastion": "chibi_king_defender_sergeant_very_heavy_armored_frontier_defender_f",
    "martial_artist": "chibi_priest_1_martial_artist",
    "ninja": "chibi_ninja_assassin_assassin_guy",
    "monk": "chibi_spiritual_monk_1_f",

    # --- Mage tree ---
    "mage": "chibi_magician_1_white",
    "mistweaver": "chibi_pyromancer_2_mistweaver",
    "firebrand": "chibi_pyromancer_2_firebrand",
    "stormcaller": "chibi_pyromancer_2_stormcaller",
    "cryomancer": "chibi_winter_witch_1_cryomancer",
    "hydromancer": "chibi_winter_witch_1_hydromancer",
    "pyromancer": "chibi_fantasy_warrior_medieval_hooded_girl_pyromancer",
    "geomancer": "chibi_fantasy_warrior_medieval_hooded_girl_geomancer",
    "electromancer": "chibi_witch_3_electromancer",
    "tempest": "chibi_witch_3_tempest",
    "acolyte": "chibi_ghost_knight_2_ghost_knight_3_acolyte",
    "priest": "chibi_priest_3_f",
    "paladin": "chibi_valkyrie_3_paladin",

    # --- Entertainer tree ---
    "entertainer": "chibi_citizen_3",
    "bard": "chibi_women_citizen_women_3_bard",
    "warcrier": "chibi_valkyrie_3_warcrier",
    "minstrel": "chibi_witch_1_minstrel",
    "dervish": "chibi_amazon_warrior_3_dervish",
    "illusionist": "chibi_dark_oracle_2_f",
    "mime": "chibi_mimic_2_human",
    "orator": "chibi_women_citizen_women_1_orator",
    "laureate": "chibi_women_citizen_women_3_laureate",
    "elegist": "chibi_magician_girl_3",
    "chorister": "chibi_magician_girl_2_chorister",
    "herald": "chibi_winter_witch_2_herald",
    "muse": "chibi_magician_girl_1",

    # --- Scholar tree ---
    "scholar": "chibi_dark_elves_1_scholar",
    "artificer": "chibi_winter_witch_3_artificer",
    "alchemist": "chibi_dark_elves_3_alchemist",
    "thaumaturge": "chibi_dark_oracle_3_f",
    "tinker": "chibi_women_citizen_women_2_tinker",
    "bombardier": "chibi_vampire_hunter_3_bombardier",
    "siegemaster": "chibi_valkyrie_1_siegemaster",
    "chronomancer": "chibi_fallen_angel_s_1_chronomancer",
    "cosmologist": "chibi_dark_oracle_3_cosmologist_f",
    "astronomer": "chibi_old_hero_3_f",
    "arithmancer": "chibi_cursed_alchemist_1_f",
    "automaton": "chibi_golem_1_f",
    "technomancer": "chibi_technomage_2_f",

    # --- Royal ---
    "prince": "chibi_amazon_warrior_1_royal",
    "princess": "chibi_amazon_warrior_1_royal",
}

ENEMY_SPRITE_IDS: dict[str, str] = {
    # --- Goblinoid ---
    "goblin": "chibi_goblin_1",
    "goblin_archer": "chibi_goblin_3",
    "goblin_shaman": "chibi_orc_shaman_shamans_1",
    "hobgoblin": "chibi_orc_ogre_goblin_orc",

    # --- Beasts & prowlers ---
    "wolf": "chibi_gnoll_1",
    "shadow_hound": "chibi_skeleton_hunter_1",
    "wild_boar": "chibi_minotaur_1",
    "bear": "chibi_forest_guardian_1",
    "bear_cub": "chibi_forest_guardian_2",
    "night_prowler": "chibi_dark_elves_1",
    "dusk_prowler": "chibi_dark_elves_2",
    "dread_stalker": "chibi_dark_elves_3",

    # --- City thugs ---
    "thug": "chibi_archer_barbarian_mage_barbarian_warrior",
    "street_tough": "chibi_4_characters_medieval_thug",
    "hex_peddler": "chibi_skeleton_nobleman_1",

    # --- Guards & military ---
    "guard_squire": "chibi_knight_2",
    "elite_guard_squire": "chibi_knight_3",
    "guard_mage": "chibi_magician_1_royal",
    "elite_guard_mage": "chibi_magician_demon_magician_2",
    "guard_scholar": "chibi_old_hero_2_royal",
    "guard_entertainer": "chibi_villager_3",
    "commander": "chibi_warrior_heavy_armored_defender_knight",
    "captain": "chibi_skeleton_pirate_captain_1",
    "pirate": "chibi_ghost_pirate_1",

    # --- Imps & small demons ---
    "imp": "chibi_goblin_2",
    "fiendling": "chibi_blood_demon_1",
    "fire_spirit": "chibi_blood_demon_2",
    "cave_bat": "chibi_orc_archer_1",

    # --- Nature spirits ---
    "pixie": "chibi_elemental_spirits_1",
    "sprite": "chibi_elemental_spirits_2",
    "wisp": "chibi_elemental_spirits_3",

    # --- Nature / fey humanoids ---
    "satyr": "chibi_satyr_1",
    "nymph": "chibi_elf_archer_archer_1",
    "tide_nymph": "chibi_elf_archer_archer_2",
    "siren": "chibi_medusa_1",
    "chanteuse": "chibi_elf_archer_archer_3",

    # --- Spectral ---
    "shade": "chibi_ghost_knight_1",
    "dire_shade": "chibi_ghost_knight_2",
    "wraith": "chibi_ghost_knight_3",
    "grave_wraith": "chibi_ghost_knight_2_ghost_knight_1",
    "dread_wraith": "chibi_ghost_knight_2_ghost_knight_2",
    "specter": "chibi_ghost_knight_2_ghost_knight_3",
    "phantom_prowler": "chibi_ghost_pirate_2",
    "mirror_stalker": "chibi_ghost_pirate_3",

    # --- Undead casters ---
    "witch": "chibi_skeleton_witch_1",
    "elder_witch": "chibi_skeleton_witch_2",
    "necromancer": "chibi_necromancer_shadow_necromancer_of_the_shadow_1",
    "warlock": "chibi_magician_undead_magician_2",
    "psion": "chibi_magician_undead_magician_3",
    "chaplain": "chibi_orc_shaman_shamans_2",
    "shaman": "chibi_orc_shaman_shamans_3",
    "runewright": "chibi_skeleton_sorcerer_1",

    # --- Undead melee ---
    "zombie": "chibi_zombie_villager_1",
    "bone_sentry": "chibi_skeleton_warrior_1",
    "cursed_peddler": "chibi_skeleton_nobleman_2",

    # --- Wyrmlings ---
    "fire_wyrmling": "chibi_demon_archer_archer_1",
    "frost_wyrmling": "chibi_demon_archer_archer_2",
    "gloom_stalker": "chibi_demon_archer_archer_3",

    # --- Constructs ---
    "arc_golem": "chibi_golem_2",
    "ironclad": "chibi_golem_3",
    "android": "chibi_frost_knight_3",
    "machinist": "chibi_skeleton_crusader_1",

    # --- Demons ---
    "hellion": "chibi_blood_demon_3",
    "arch_hellion": "chibi_devil_hell_knight_succubus_hell_knight",
    "draconian": "chibi_demon_of_darkness_demons_of_darkness_1",
    "ringmaster": "chibi_halloween_skull_knight",
    "harlequin": "chibi_halloween_pumpkin_head_guy",

    # --- Watchers & moths ---
    "watcher_lord": "chibi_medusa_3",
    "void_watcher": "chibi_medusa_2",
    "seraph": "chibi_fallen_angel_s_1",
    "dusk_moth": "chibi_fallen_angel_s_3",
    "twilight_moth": "chibi_fallen_angel_s_2",

    # --- True elementals (Prog 7) ---
    "fire_elemental": "chibi_elemental_s_1",
    "water_elemental": "chibi_elemental_s_2",
    "air_elemental": "chibi_elemental_s_3",
    "earth_elemental": "chibi_forest_guardian_3",

    # --- Boss ---
    "kraken": "chibi_orc_ogre_goblin_ogre",

    # --- Final boss ---
    "the_stranger": "chibi_black_reaper_1",
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
