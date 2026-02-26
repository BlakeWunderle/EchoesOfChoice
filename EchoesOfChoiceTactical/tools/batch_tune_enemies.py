#!/usr/bin/env python3
"""Batch-tune enemy .tres stats based on simulator baseline results.

Reads current enemy stats, applies per-battle multipliers calculated from
the gap between actual win rate and target midpoint, writes updated .tres files.

Usage:
    python tools/batch_tune_enemies.py           # apply changes
    python tools/batch_tune_enemies.py --dry-run  # preview only
"""

import re
import os
import sys

ENEMIES_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                           "resources", "enemies")

# ---------------------------------------------------------------------------
# Iteration 3 win rates from post-iter2 simulator run
# ---------------------------------------------------------------------------
BATTLES = {
    # P3 — all still too easy
    "cave":             (94.8, 77.0),
    "portal":           (82.2, 77.0),
    "inn_ambush":       (87.2, 77.0),
    # P4 — shore PASS, cemetery overtuned, rest too easy
    "cemetery_battle":  (56.7, 73.0),
    "beach":            (78.2, 73.0),
    "box_battle":       (80.3, 73.0),
    "army_battle":      (84.5, 73.0),
    "lab_battle":       (90.0, 73.0),
    # P5 — both too easy
    "mirror_battle":    (76.0, 69.0),
    "gate_ambush":      (88.3, 69.0),
    # P6 — all too easy
    "city_gate_ambush": (73.5, 64.0),
    "return_city_1":    (73.5, 64.0),
    "return_city_2":    (78.2, 64.0),
    "return_city_3":    (76.0, 64.0),
    "return_city_4":    (85.5, 64.0),
}

# ---------------------------------------------------------------------------
# Enemy -> list of battle_ids where it appears (only TOO EASY battles)
# ---------------------------------------------------------------------------
ENEMY_BATTLES = {
    # P1 — PASS after iteration 1, removed
    # P2 — PASS after iteration 1, removed

    # P3
    "demon_archer":         ["cave"],
    "frost_demon":          ["cave"],
    "orc_scout":            ["cave"],
    "hellion":              ["portal"],
    "blood_imp":            ["portal"],
    "skeleton_hunter":      ["inn_ambush"],
    "dark_elf_assassin":    ["inn_ambush"],
    "fallen_seraph":        ["inn_ambush"],
    "shadow_demon":         ["inn_ambush"],

    # P4 — shore PASS after iter2, removed medusa/sea_elf
    "captain":              ["beach"],
    "pirate":               ["beach"],
    "ogre":                 ["beach"],
    "zombie":               ["cemetery_battle"],
    "specter":              ["cemetery_battle"],
    "grave_wraith":         ["cemetery_battle"],
    "ringmaster":           ["box_battle"],
    "harlequin":            ["box_battle"],
    "elf_enchantress":      ["box_battle"],
    "commander":            ["army_battle"],
    "shadow_fiend":         ["army_battle"],
    "orc_warchanter":       ["army_battle"],
    "frost_sentinel":       ["lab_battle"],
    "arc_golem":            ["lab_battle"],
    "skeleton_crusader":    ["lab_battle"],
    "ironclad":             ["lab_battle"],

    # P5
    "gorgon":               ["mirror_battle"],
    "ghost_corsair":        ["mirror_battle", "gate_ambush"],
    "dark_elf_blade":       ["mirror_battle", "gate_ambush"],
    "dark_seraph":          ["mirror_battle", "gate_ambush"],
    "bone_sorcerer":        ["gate_ambush"],

    # P6
    "gorgon_queen":         ["city_gate_ambush", "return_city_4"],
    "dark_elf_warlord":     ["city_gate_ambush", "return_city_1", "return_city_3"],
    "dire_shade":           ["city_gate_ambush", "return_city_2", "return_city_4"],
    "phantom_prowler":      ["city_gate_ambush", "return_city_1", "return_city_3"],
    "seraph":               ["return_city_1"],
    "arch_hellion":         ["return_city_1"],
    "necromancer":          ["return_city_2"],
    "elder_witch":          ["return_city_2"],
    "dread_wraith":         ["return_city_2"],
    "psion":                ["return_city_3"],
    "runewright":           ["return_city_3"],
    "warlock":              ["return_city_4"],
    "shaman":               ["return_city_4"],
}

# ---------------------------------------------------------------------------
# Gap-to-multiplier coefficients
# Higher coefficient = that stat type has more impact on difficulty
# ---------------------------------------------------------------------------
# Iteration 3: ultra-conservative coefficients for final convergence
HP_COEFF = 0.6    # HP is the biggest lever (more time to deal damage)
ATK_COEFF = 0.25  # Attack has moderate impact
DEF_COEFF = 0.15  # Defense has least impact

# Stats to scale: field_name -> multiplier_category
BASE_FIELDS = {
    "base_max_health":        "hp",
    "base_physical_attack":   "atk",
    "base_magic_attack":      "atk",
    "base_physical_defense":  "def",
    "base_magic_defense":     "def",
}

GROWTH_FIELDS = {
    "growth_health":            "hp",
    "growth_physical_attack":   "atk",
    "growth_magic_attack":      "atk",
    "growth_physical_defense":  "def",
    "growth_magic_defense":     "def",
}


def get_multipliers(enemy_name: str) -> dict:
    """Calculate HP/ATK/DEF multipliers from average battle gap."""
    battles = ENEMY_BATTLES[enemy_name]
    gaps = []
    for b in battles:
        win_rate, target = BATTLES[b]
        gaps.append((win_rate - target) / 100.0)

    avg_gap = sum(gaps) / len(gaps)

    return {
        "hp":  1.0 + avg_gap * HP_COEFF,
        "atk": 1.0 + avg_gap * ATK_COEFF,
        "def": 1.0 + avg_gap * DEF_COEFF,
        "gap": avg_gap * 100,
    }


def tune_tres(filepath: str, multipliers: dict, dry_run: bool) -> list:
    """Apply multipliers to stat lines in a .tres file. Returns list of change descriptions."""
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    changes = []
    all_fields = {}
    all_fields.update(BASE_FIELDS)
    all_fields.update(GROWTH_FIELDS)

    for field, stat_type in all_fields.items():
        pattern = rf"({field}\s*=\s*)(\d+)"
        match = re.search(pattern, content)
        if not match:
            continue

        old_val = int(match.group(2))
        if old_val == 0:
            continue  # Don't scale zero stats (intentional design)

        new_val = round(old_val * multipliers[stat_type])
        new_val = max(new_val, 1)  # Floor at 1 (never zero)

        if new_val != old_val:
            content = content.replace(match.group(0), f"{match.group(1)}{new_val}", 1)
            changes.append(f"  {field}: {old_val} -> {new_val}")

    if changes and not dry_run:
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)

    return changes


def main():
    dry_run = "--dry-run" in sys.argv

    if dry_run:
        print("=== ENEMY STAT TUNING (DRY RUN) ===\n")
    else:
        print("=== ENEMY STAT TUNING ===\n")

    total_changes = 0
    total_enemies = 0

    # Group by progression for readability
    prog_groups = [
        ("P3", ["demon_archer", "frost_demon", "orc_scout",
                "hellion", "blood_imp",
                "skeleton_hunter", "dark_elf_assassin", "fallen_seraph", "shadow_demon"]),
        ("P4", ["captain", "pirate", "ogre",
                "zombie", "specter", "grave_wraith",
                "ringmaster", "harlequin", "elf_enchantress",
                "commander", "shadow_fiend", "orc_warchanter",
                "frost_sentinel", "arc_golem", "skeleton_crusader", "ironclad"]),
        ("P5", ["gorgon", "ghost_corsair", "dark_elf_blade",
                "dark_seraph", "bone_sorcerer"]),
        ("P6", ["gorgon_queen", "dark_elf_warlord", "dire_shade", "phantom_prowler",
                "seraph", "arch_hellion",
                "necromancer", "elder_witch", "dread_wraith",
                "psion", "runewright",
                "warlock", "shaman"]),
    ]

    for prog_label, enemies in prog_groups:
        print(f"--- {prog_label} ---")
        for enemy_name in enemies:
            mults = get_multipliers(enemy_name)
            filepath = os.path.join(ENEMIES_DIR, f"{enemy_name}.tres")

            if not os.path.exists(filepath):
                print(f"  WARNING: {enemy_name}.tres not found!")
                continue

            battles_str = ", ".join(ENEMY_BATTLES[enemy_name])
            gap_sign = "+" if mults['gap'] >= 0 else ""
            print(f"  {enemy_name} ({battles_str}, gap: {gap_sign}{mults['gap']:.1f}%)")
            print(f"    HP x{mults['hp']:.2f}  ATK x{mults['atk']:.2f}  DEF x{mults['def']:.2f}")

            changes = tune_tres(filepath, mults, dry_run)
            if changes:
                for c in changes:
                    print(c)
                total_changes += len(changes)
            else:
                print("    (no stat changes)")

            total_enemies += 1
        print()

    action = "would change" if dry_run else "changed"
    print(f"Total: {action} {total_changes} stats across {total_enemies} enemies")


if __name__ == "__main__":
    main()
