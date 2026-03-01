"""Scale enemy base stats and growth rates by progression to compensate for ability fixes.

Usage: python tools/scale_enemies.py
Run from EchoesOfChoiceTactical/ directory.
"""
import re
import os
import sys

# Scaling multipliers per progression.
# Based on post-ability-fix sim results vs targets:
#   P2: 98.5% avg vs 81% target (-17.5pp needed)
#   P3: 95.0% avg vs 77% target (-18pp needed)
#   P4: 83.9% avg vs 73% target (-11pp needed)
#   P5: 81.4% avg vs 69% target (-12pp needed)
#   P6: 78.7% avg vs 64% target (-15pp needed)
#   P7: 99.3% avg vs 60% target (-39pp needed)
SCALING = {
    2: {"hp": 1.45, "atk": 1.35, "def": 1.30, "speed": 1.0},
    3: {"hp": 1.40, "atk": 1.30, "def": 1.25, "speed": 1.0},
    4: {"hp": 1.25, "atk": 1.20, "def": 1.15, "speed": 1.0},
    5: {"hp": 1.30, "atk": 1.25, "def": 1.20, "speed": 1.0},
    6: {"hp": 1.35, "atk": 1.30, "def": 1.25, "speed": 1.0},
    7: {"hp": 2.50, "atk": 2.00, "def": 1.80, "speed": 1.15},
}

ENEMIES_BY_PROG = {
    2: [
        "goblin_firestarter", "blood_fiend", "witch", "wisp", "sprite",
        "elf_ranger", "pixie", "satyr", "shade", "wraith", "bone_sentry",
    ],
    3: [
        "orc_scout", "demon_archer", "frost_demon", "blood_imp", "hellion",
        "skeleton_hunter", "dark_elf_assassin", "fallen_seraph", "shadow_demon",
    ],
    4: [
        "medusa", "sea_elf", "pirate", "captain", "ogre",
        "zombie", "specter", "grave_wraith",
        "harlequin", "elf_enchantress", "ringmaster",
        "shadow_fiend", "orc_warchanter", "commander",
        "frost_sentinel", "arc_golem", "ironclad", "skeleton_crusader",
    ],
    5: [
        "gorgon", "ghost_corsair", "dark_elf_blade",
        "dark_seraph", "bone_sorcerer",
    ],
    6: [
        "gorgon_queen", "dark_elf_warlord", "city_militia", "dire_shade",
        "phantom_prowler", "seraph", "arch_hellion",
        "necromancer", "elder_witch", "dread_wraith",
        "psion", "runewright", "warlock", "shaman",
    ],
    7: [
        "fire_elemental", "water_elemental", "air_elemental", "earth_elemental",
        "the_stranger", "elite_guard_mage", "elite_guard_squire",
    ],
}

# Map .tres stat fields to scaling categories.
STAT_CATEGORIES = {
    "base_max_health": "hp",
    "growth_health": "hp",
    "base_max_mana": "hp",       # Scale mana with HP so enemies can use abilities more
    "growth_mana": "hp",
    "base_physical_attack": "atk",
    "growth_physical_attack": "atk",
    "base_magic_attack": "atk",
    "growth_magic_attack": "atk",
    "base_physical_defense": "def",
    "growth_physical_defense": "def",
    "base_magic_defense": "def",
    "growth_magic_defense": "def",
    "base_speed": "speed",
    "growth_speed": "speed",
}


def scale_enemy(filepath: str, scaling: dict, dry_run: bool = False) -> dict:
    """Scale an enemy .tres file's stats. Returns dict of changes."""
    with open(filepath, "r") as f:
        content = f.read()

    changes = {}
    for stat_name, category in STAT_CATEGORIES.items():
        multiplier = scaling[category]
        if multiplier == 1.0:
            continue
        pattern = rf"({stat_name}\s*=\s*)(\d+)"
        match = re.search(pattern, content)
        if match:
            old_val = int(match.group(2))
            if old_val == 0:
                continue  # Don't scale zero stats
            new_val = max(1, round(old_val * multiplier))
            if new_val != old_val:
                content = re.sub(pattern, rf"\g<1>{new_val}", content)
                changes[stat_name] = (old_val, new_val)

    if not dry_run and changes:
        with open(filepath, "w") as f:
            f.write(content)

    return changes


def main():
    dry_run = "--dry-run" in sys.argv
    base_dir = os.path.join(os.path.dirname(__file__), "..", "resources", "enemies")
    base_dir = os.path.normpath(base_dir)

    total_files = 0
    total_changes = 0

    for prog in sorted(SCALING.keys()):
        scaling = SCALING[prog]
        enemies = ENEMIES_BY_PROG[prog]
        print(f"\n--- Progression {prog} (HPx{scaling['hp']}, ATKx{scaling['atk']}, "
              f"DEFx{scaling['def']}, SPDx{scaling['speed']}) ---")

        for enemy in enemies:
            filepath = os.path.join(base_dir, f"{enemy}.tres")
            if not os.path.exists(filepath):
                print(f"  WARNING: {enemy}.tres not found!")
                continue

            changes = scale_enemy(filepath, scaling, dry_run=dry_run)
            if changes:
                total_files += 1
                total_changes += len(changes)
                summary = ", ".join(
                    f"{k.replace('base_', '').replace('growth_', 'g_')}: {old}->{new}"
                    for k, (old, new) in sorted(changes.items())
                )
                prefix = "[DRY RUN] " if dry_run else ""
                print(f"  {prefix}{enemy}: {summary}")
            else:
                print(f"  {enemy}: no changes")

    action = "Would scale" if dry_run else "Scaled"
    print(f"\n{action} {total_changes} stats across {total_files} enemy files.")


if __name__ == "__main__":
    main()
