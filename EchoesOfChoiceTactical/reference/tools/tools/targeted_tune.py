#!/usr/bin/env python3
"""Targeted manual balance pass — set explicit stat targets per enemy.

Unlike batch_tune_enemies.py (formula-based), this script uses exact target
values derived from manual analysis of each battle's composition and comparison
to passing battles at the same progression level.

Usage:
    python tools/targeted_tune.py           # apply changes
    python tools/targeted_tune.py --dry-run  # preview only
"""

import re
import os
import sys

ENEMIES_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
                           "resources", "enemies")

# ---------------------------------------------------------------------------
# Explicit stat targets per enemy.
# Only stats listed here will be changed; unlisted stats are left as-is.
# ---------------------------------------------------------------------------
TARGETS = {
    # === PASS 4: Fix lab overshot + revert wrong-direction P6 changes ===

    # === P4 Lab (63.4% → 70-76%) — midpoint between pass2 and pass3 HP ===
    "android": {
        "base_max_health": 78,        # midpoint of pass2=76, pass3=80
    },
    "arc_golem": {
        "base_max_health": 66,        # midpoint of pass2=63, pass3=68
    },
    "machinist": {
        "base_max_health": 76,        # midpoint of pass2=74, pass3=78
    },
    "ironclad": {
        "base_max_health": 71,        # midpoint of pass2=69, pass3=73
    },

    # === P6 watcher_lord — REVERT pass3 buff (was wrong direction) ===
    # city_gate (50.8%) and rc4 (51.2%) were already too hard;
    # pass3 made watcher_lord STRONGER which made them worse.
    "watcher_lord": {
        "base_max_health": 148,       # revert from 158 to pass2 value
        "base_magic_attack": 32,      # revert from 36 to pass2 value
    },

    # === P6 RC1 (70.7% → 61-67%) — STRENGTHEN unique enemies ===
    "seraph": {
        "base_max_health": 180,       # was 163, +10%
        "base_magic_attack": 36,      # was 31, +16%
    },
    "arch_hellion": {
        "base_max_health": 168,       # was 148, +14%
        "base_physical_attack": 52,   # was 46, +13%
    },

    # === P6 RC3 (73.0% → 61-67%) — STRENGTHEN unique enemies ===
    # Pass3 NERFED these (wrong direction!). Now buffing well above pass2.
    "psion": {
        "base_max_health": 115,       # was 93 (pass3), pass2 was 97
        "base_magic_attack": 36,      # was 29 (pass3), pass2 was 30
    },
    "runewright": {
        "base_max_health": 108,       # was 86 (pass3), pass2 was 90
        "base_magic_attack": 38,      # was 30 (pass3), pass2 was 32
    },

    # === P6 RC4 (51.2% → 61-67%) — REVERT pass3 buff (was wrong direction) ===
    # rc4 was already too hard; pass3 made warlock/shaman STRONGER = worse.
    "warlock": {
        "base_max_health": 117,       # revert from 125 to pass2 value
        "base_magic_attack": 40,      # revert from 43 to pass2 value
    },
    "shaman": {
        "base_max_health": 146,       # revert from 155 to pass2 value
        "base_magic_attack": 37,      # revert from 40 to pass2 value
    },
}


def apply_targets(filepath: str, targets: dict, dry_run: bool) -> list:
    """Set exact stat values in a .tres file. Returns list of change descriptions."""
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    changes = []
    for field, target_val in targets.items():
        pattern = rf"({field}\s*=\s*)(\d+)"
        match = re.search(pattern, content)
        if not match:
            changes.append(f"  WARNING: {field} not found!")
            continue

        old_val = int(match.group(2))
        if old_val == target_val:
            continue

        content = content.replace(match.group(0), f"{match.group(1)}{target_val}", 1)
        delta = target_val - old_val
        sign = "+" if delta > 0 else ""
        pct = (delta / old_val * 100) if old_val != 0 else 0
        changes.append(f"  {field}: {old_val} -> {target_val} ({sign}{delta}, {sign}{pct:.0f}%)")

    if changes and not dry_run:
        # Only write if we actually made changes (not just warnings)
        real_changes = [c for c in changes if "WARNING" not in c]
        if real_changes:
            with open(filepath, "w", encoding="utf-8") as f:
                f.write(content)

    return changes


def main():
    dry_run = "--dry-run" in sys.argv

    if dry_run:
        print("=== TARGETED BALANCE PASS (DRY RUN) ===\n")
    else:
        print("=== TARGETED BALANCE PASS ===\n")

    total_changes = 0
    total_enemies = 0
    warnings = []

    # Group by progression for readability
    prog_groups = [
        ("P4 — lab (midpoint HP)", ["android", "arc_golem", "machinist", "ironclad"]),
        ("P6 — watcher_lord revert (city_gate+rc4)", ["watcher_lord"]),
        ("P6 — rc1 unique strengthen", ["seraph", "arch_hellion"]),
        ("P6 — rc3 unique strengthen", ["psion", "runewright"]),
        ("P6 — rc4 unique revert", ["warlock", "shaman"]),
    ]

    for label, enemies in prog_groups:
        print(f"--- {label} ---")
        for enemy_name in enemies:
            filepath = os.path.join(ENEMIES_DIR, f"{enemy_name}.tres")
            if not os.path.exists(filepath):
                msg = f"  WARNING: {enemy_name}.tres not found!"
                print(msg)
                warnings.append(msg)
                continue

            targets = TARGETS[enemy_name]
            changes = apply_targets(filepath, targets, dry_run)
            if changes:
                print(f"  {enemy_name}:")
                for c in changes:
                    print(f"    {c}")
                    if "WARNING" in c:
                        warnings.append(c)
                    else:
                        total_changes += 1
            else:
                print(f"  {enemy_name}: (no changes needed)")

            total_enemies += 1
        print()

    action = "would change" if dry_run else "changed"
    print(f"Total: {action} {total_changes} stats across {total_enemies} enemies")

    if warnings:
        print(f"\n{len(warnings)} warnings:")
        for w in warnings:
            print(f"  {w}")


if __name__ == "__main__":
    main()
