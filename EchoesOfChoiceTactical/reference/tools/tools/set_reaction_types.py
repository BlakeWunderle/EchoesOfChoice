#!/usr/bin/env python3
"""Assign reaction_types to all player class and enemy .tres files.

ReactionType enum values (from enums.gd):
  0 = OPPORTUNITY_ATTACK  (melee: enemy leaves adjacent tile)
  1 = FLANKING_STRIKE     (universal: ally attacks enemy this unit is adjacent to)
  2 = SNAP_SHOT           (ranged: enemy enters adjacent tile from front facing)
  3 = REACTIVE_HEAL       (healer: ally within 3 tiles takes damage)
  4 = DAMAGE_MITIGATION   (support: ally within 3 tiles takes damage -> reduce 25%)
  5 = BODYGUARD           (tank: adjacent ally takes damage -> absorb 40-50%)

Design: FLANKING_STRIKE (1) is universal for all units. Role-specific reactions
are layered on top.
"""

import os
import re
import sys

OPP = 0   # OPPORTUNITY_ATTACK
FLANK = 1 # FLANKING_STRIKE
SNAP = 2  # SNAP_SHOT
HEAL = 3  # REACTIVE_HEAL
MIT = 4   # DAMAGE_MITIGATION
GUARD = 5 # BODYGUARD

# --- Player Classes (54) ---
CLASS_REACTIONS = {
    # Squire tree -- melee fighters
    "squire":         [FLANK, OPP],
    "duelist":        [FLANK, OPP],
    "cavalry":        [FLANK, OPP],
    "dragoon":        [FLANK, OPP],
    "martial_artist": [FLANK, OPP],
    "ninja":          [FLANK, OPP],
    "monk":           [FLANK, OPP],

    # Ranger branch -- ranged
    "ranger":         [FLANK, SNAP],
    "mercenary":      [FLANK, OPP, SNAP],
    "hunter":         [FLANK, SNAP],

    # Warden branch -- tanks
    "warden":         [FLANK, OPP, GUARD],
    "knight":         [FLANK, OPP, GUARD],
    "bastion":        [FLANK, GUARD, MIT],

    # Mage tree -- ranged casters
    "mage":           [FLANK, SNAP],
    "mistweaver":     [FLANK, SNAP],
    "firebrand":      [FLANK, SNAP],
    "stormcaller":    [FLANK, SNAP],
    "cryomancer":     [FLANK, SNAP],
    "hydromancer":    [FLANK, HEAL],
    "pyromancer":     [FLANK, SNAP],
    "geomancer":      [FLANK, SNAP],
    "electromancer":  [FLANK, SNAP],
    "tempest":        [FLANK, OPP, SNAP],

    # Acolyte branch -- healers
    "acolyte":        [FLANK, HEAL],
    "paladin":        [FLANK, OPP, HEAL],
    "priest":         [FLANK, HEAL],

    # Entertainer tree -- support
    "entertainer":    [FLANK, MIT],
    "bard":           [FLANK, MIT],
    "warcrier":       [FLANK, OPP, MIT],
    "minstrel":       [FLANK, MIT],
    "dervish":        [FLANK, OPP, MIT],
    "illusionist":    [FLANK, MIT],
    "mime":           [FLANK, OPP],
    "orator":         [FLANK, MIT],
    "laureate":       [FLANK, MIT],
    "elegist":        [FLANK, MIT],
    "chorister":      [FLANK, HEAL],
    "herald":         [FLANK, MIT],
    "muse":           [FLANK, HEAL, MIT],

    # Scholar tree -- support/ranged
    "scholar":        [FLANK, MIT],
    "artificer":      [FLANK, MIT],
    "alchemist":      [FLANK, HEAL, MIT],
    "thaumaturge":    [FLANK, SNAP],
    "tinker":         [FLANK, MIT],
    "bombardier":     [FLANK, SNAP],
    "siegemaster":    [FLANK, GUARD],
    "cosmologist":    [FLANK, MIT],
    "astronomer":     [FLANK, SNAP],
    "chronomancer":   [FLANK, MIT],
    "arithmancer":    [FLANK, MIT],
    "automaton":      [FLANK, OPP, GUARD],
    "technomancer":   [FLANK, SNAP, MIT],

    # Royal
    "prince":         [FLANK, OPP, GUARD],
    "princess":       [FLANK, OPP],
}

# --- Enemies (81) ---
ENEMY_REACTIONS = {
    # Melee enemies
    "goblin":              [FLANK, OPP],
    "thug":                [FLANK, OPP],
    "street_tough":        [FLANK, OPP],
    "orc_warrior":         [FLANK, OPP],
    "gnoll_raider":        [FLANK, OPP],
    "minotaur":            [FLANK, OPP],
    "ogre":                [FLANK, OPP],
    "zombie":              [FLANK, OPP],
    "bone_sentry":         [FLANK, OPP],
    "skeleton_crusader":   [FLANK, OPP, GUARD],
    "dark_elf_blade":      [FLANK, OPP],
    "dark_elf_assassin":   [FLANK, OPP],
    "dark_elf_warlord":    [FLANK, OPP, GUARD],
    "ironclad":            [FLANK, OPP, GUARD],
    "blood_fiend":         [FLANK, OPP],
    "hellion":             [FLANK, OPP],
    "arch_hellion":        [FLANK, OPP, GUARD],
    "commander":           [FLANK, OPP, GUARD],
    "captain":             [FLANK, OPP],
    "city_militia":        [FLANK, OPP],
    "guard_squire":        [FLANK, OPP],
    "elite_guard_squire":  [FLANK, OPP, GUARD],
    "pirate":              [FLANK, OPP],
    "ghost_corsair":       [FLANK, OPP],
    "phantom_prowler":     [FLANK, OPP],
    "frost_sentinel":      [FLANK, OPP, GUARD],
    "shadow_fiend":        [FLANK, OPP],
    "ringmaster":          [FLANK, OPP],
    "harlequin":           [FLANK, OPP],
    "forest_guardian":     [FLANK, OPP, GUARD],
    "satyr":               [FLANK, OPP],

    # Ranged enemies
    "goblin_archer":       [FLANK, SNAP],
    "orc_scout":           [FLANK, SNAP],
    "skeleton_hunter":     [FLANK, SNAP],
    "demon_archer":        [FLANK, SNAP],
    "frost_demon":         [FLANK, SNAP],
    "shadow_demon":        [FLANK, SNAP],
    "elf_ranger":          [FLANK, SNAP],
    "sea_elf":             [FLANK, SNAP],
    "wild_huntsman":       [FLANK, SNAP],

    # Caster enemies
    "hedge_mage":          [FLANK, SNAP],
    "witch":               [FLANK, SNAP],
    "elder_witch":         [FLANK, SNAP],
    "goblin_firestarter":  [FLANK, SNAP],
    "orc_shaman":          [FLANK, HEAL],
    "orc_warchanter":      [FLANK, MIT],
    "shaman":              [FLANK, HEAL],
    "necromancer":         [FLANK, MIT],
    "warlock":             [FLANK, SNAP],
    "psion":               [FLANK, MIT],
    "runewright":          [FLANK, MIT],
    "bone_sorcerer":       [FLANK, SNAP],
    "elf_enchantress":     [FLANK, MIT],
    "guard_mage":          [FLANK, SNAP],
    "elite_guard_mage":    [FLANK, SNAP],
    "guard_scholar":       [FLANK, MIT],
    "guard_entertainer":   [FLANK, MIT],
    "sea_shaman":          [FLANK, HEAL],

    # Tank enemies
    "arc_golem":           [FLANK, GUARD],

    # Spirit/undead enemies
    "shade":               [FLANK, OPP],
    "dire_shade":          [FLANK, OPP],
    "wraith":              [FLANK, OPP],
    "grave_wraith":        [FLANK, OPP],
    "dread_wraith":        [FLANK, OPP],
    "specter":             [FLANK, OPP],
    "blood_imp":           [FLANK, OPP],
    "pixie":               [FLANK, HEAL],
    "sprite":              [FLANK, MIT],
    "wisp":                [FLANK, HEAL],
    "grove_sprite":        [FLANK, HEAL],
    "medusa":              [FLANK, SNAP],
    "gorgon":              [FLANK, SNAP, MIT],
    "gorgon_queen":        [FLANK, SNAP, MIT],
    "seraph":              [FLANK, HEAL, MIT],
    "dark_seraph":         [FLANK, OPP, MIT],
    "fallen_seraph":       [FLANK, OPP, GUARD],

    # Elementals
    "fire_elemental":      [FLANK, OPP],
    "water_elemental":     [FLANK, HEAL],
    "air_elemental":       [FLANK, SNAP],
    "earth_elemental":     [FLANK, OPP, GUARD],

    # Boss
    "the_stranger":        [FLANK, OPP, MIT, GUARD],
}


def format_reaction_array(reactions: list[int]) -> str:
    """Format reaction types as a Godot .tres array."""
    sorted_vals = sorted(set(reactions))
    return "[" + ", ".join(str(v) for v in sorted_vals) + "]"


def update_tres_file(filepath: str, reactions: list[int]) -> bool:
    """Update reaction_types in a .tres file. Returns True if changed."""
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    new_value = format_reaction_array(reactions)
    new_line = f"reaction_types = {new_value}"

    pattern = r"reaction_types = \[.*?\]"
    if not re.search(pattern, content):
        print(f"  WARNING: no reaction_types line found in {filepath}")
        return False

    new_content = re.sub(pattern, new_line, content)
    if new_content == content:
        return False

    with open(filepath, "w", encoding="utf-8") as f:
        f.write(new_content)
    return True


def main():
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    classes_dir = os.path.join(base_dir, "resources", "classes")
    enemies_dir = os.path.join(base_dir, "resources", "enemies")

    changed = 0
    missing = 0

    print("=== Player Classes ===")
    for class_id, reactions in sorted(CLASS_REACTIONS.items()):
        filepath = os.path.join(classes_dir, f"{class_id}.tres")
        if not os.path.exists(filepath):
            print(f"  MISSING: {filepath}")
            missing += 1
            continue
        if update_tres_file(filepath, reactions):
            print(f"  Updated: {class_id} -> {format_reaction_array(reactions)}")
            changed += 1
        else:
            print(f"  Unchanged: {class_id}")

    print(f"\n=== Enemies ===")
    for enemy_id, reactions in sorted(ENEMY_REACTIONS.items()):
        filepath = os.path.join(enemies_dir, f"{enemy_id}.tres")
        if not os.path.exists(filepath):
            print(f"  MISSING: {filepath}")
            missing += 1
            continue
        if update_tres_file(filepath, reactions):
            print(f"  Updated: {enemy_id} -> {format_reaction_array(reactions)}")
            changed += 1
        else:
            print(f"  Unchanged: {enemy_id}")

    # Check for files not in our mapping
    print(f"\n=== Coverage Check ===")
    for fname in sorted(os.listdir(classes_dir)):
        if fname.endswith(".tres"):
            class_id = fname[:-5]
            if class_id not in CLASS_REACTIONS:
                print(f"  Class not mapped: {class_id}")

    for fname in sorted(os.listdir(enemies_dir)):
        if fname.endswith(".tres"):
            enemy_id = fname[:-5]
            if enemy_id not in ENEMY_REACTIONS:
                print(f"  Enemy not mapped: {enemy_id}")

    print(f"\n=== Summary ===")
    print(f"  Changed: {changed}")
    print(f"  Missing files: {missing}")


if __name__ == "__main__":
    main()
