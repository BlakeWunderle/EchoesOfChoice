#!/usr/bin/env python3
"""Fix SPIKE and SLOW balance flags by adjusting enemy .tres base stats.

Reads enemy .tres files, computes effective damage at battle levels,
and adjusts base stats to satisfy:
  - SPIKE: min(HP_class / max_dmg) >= 3.0 for all classes
  - SLOW: TTK = ceil(HP / max(1, Sq.Atk - phys_def)) <= 10

Usage:
    python tools/fix_balance_flags.py           # apply changes
    python tools/fix_balance_flags.py --dry-run  # preview only
"""

import re
import os
import sys
import math

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ENEMIES_DIR = os.path.join(BASE_DIR, "resources", "enemies")

# ── Party profiles from balance_check.gd: [P.Def, M.Def, HP] ──────────────
PARTY = {
    0: {"level": 1, "squire": [15, 11, 55], "mage": [11, 18, 49], "tinker": [12, 20, 44], "entertainer": [12, 18, 49], "wildling": [14, 16, 50]},
    1: {"level": 2, "squire": [20, 13, 67], "mage": [16, 20, 58], "tinker": [17, 22, 53], "entertainer": [17, 21, 58], "wildling": [19, 19, 58]},
    2: {"level": 3, "squire": [22, 15, 79], "mage": [18, 22, 67], "tinker": [19, 24, 62], "entertainer": [19, 24, 67], "wildling": [21, 22, 66]},
    3: {"level": 4, "squire": [26, 17, 91], "mage": [22, 24, 76], "tinker": [23, 26, 71], "entertainer": [23, 27, 76], "wildling": [25, 25, 74]},
    4: {"level": 4, "squire": [26, 17, 91], "mage": [22, 24, 76], "tinker": [23, 26, 71], "entertainer": [23, 27, 76], "wildling": [25, 25, 74]},
    5: {"level": 5, "squire": [33, 19, 103], "mage": [29, 26, 85], "tinker": [30, 28, 80], "entertainer": [30, 30, 85], "wildling": [32, 28, 82]},
    6: {"level": 6, "squire": [35, 21, 115], "mage": [31, 28, 94], "tinker": [32, 30, 89], "entertainer": [32, 33, 94], "wildling": [34, 31, 90]},
}
SQ_ATK = {0: 21, 1: 23, 2: 25, 3: 27, 4: 27, 5: 29, 6: 31}
CLASS_ORDER = ["squire", "mage", "tinker", "entertainer", "wildling"]

# Ability constants
ABILITY_TYPE_DAMAGE = 0
STAT_PHYS = 0
STAT_MAG = 2
STAT_MIXED = 6

# Target thresholds (with margin above the flag triggers)
SPIKE_TARGET_RATIO = 3.3   # flag triggers at < 3.0
MIN_EFF_DMG = 6            # min effective Squire damage vs enemy (lower phys_def if needed)
MAX_HP_REDUCTION = 0.60    # never cut base_max_health by more than 60%
MAX_GROWTH_HP_REDUCTION = 0.65  # never cut growth_health by more than 65%

# Scaled TTK targets by progression (later fights can be longer)
SLOW_TARGET_TTK = {
    0: 8, 1: 8, 2: 10, 3: 10, 4: 12, 5: 14, 6: 16,
}

# ── Battle roster from balance_check.gd ────────────────────────────────────
BATTLES = {
    "city_street": {
        "prog": 0,
        "enemies": [
            {"res": "thug.tres", "name": "Thug", "count": 2, "level": 1},
            {"res": "street_tough.tres", "name": "Street Tough", "count": 2, "level": 1},
            {"res": "bone_peddler.tres", "name": "Bone Peddler", "count": 1, "level": 1},
        ],
    },
    "forest": {
        "prog": 1,
        "enemies": [
            {"res": "forest_guardian.tres", "name": "Forest Guardian", "count": 1, "level": 1},
            {"res": "grove_sprite.tres", "name": "Grove Sprite", "count": 1, "level": 1},
            {"res": "gnoll_raider.tres", "name": "Gnoll Raider", "count": 2, "level": 1},
            {"res": "minotaur.tres", "name": "Minotaur", "count": 1, "level": 1},
        ],
    },
    "village_raid": {
        "prog": 1,
        "enemies": [
            {"res": "goblin.tres", "name": "Goblin", "count": 2, "level": 1},
            {"res": "goblin_archer.tres", "name": "Goblin Archer", "count": 1, "level": 1},
            {"res": "orc_shaman.tres", "name": "Orc Shaman", "count": 1, "level": 1},
            {"res": "orc_warrior.tres", "name": "Orc Warrior", "count": 1, "level": 1},
        ],
    },
    "smoke": {
        "prog": 2,
        "enemies": [
            {"res": "goblin_firestarter.tres", "name": "Goblin Firestarter", "count": 2, "level": 2},
            {"res": "blood_fiend.tres", "name": "Blood Fiend", "count": 3, "level": 2},
        ],
    },
    "deep_forest": {
        "prog": 2,
        "enemies": [
            {"res": "witch.tres", "name": "Witch", "count": 1, "level": 2},
            {"res": "wisp.tres", "name": "Wisp", "count": 2, "level": 2},
            {"res": "sprite.tres", "name": "Sprite", "count": 2, "level": 2},
        ],
    },
    "clearing": {
        "prog": 2,
        "enemies": [
            {"res": "satyr.tres", "name": "Satyr", "count": 1, "level": 2},
            {"res": "elf_ranger.tres", "name": "Elf Ranger", "count": 2, "level": 2},
            {"res": "pixie.tres", "name": "Pixie", "count": 2, "level": 2},
        ],
    },
    "ruins": {
        "prog": 2,
        "enemies": [
            {"res": "shade.tres", "name": "Shade", "count": 2, "level": 2},
            {"res": "wraith.tres", "name": "Wraith", "count": 2, "level": 2},
            {"res": "bone_sentry.tres", "name": "Bone Sentry", "count": 1, "level": 2},
        ],
    },
    "cave": {
        "prog": 3,
        "enemies": [
            {"res": "orc_scout.tres", "name": "Orc Scout", "count": 2, "level": 3},
            {"res": "demon_archer.tres", "name": "Demon Archer", "count": 1, "level": 3},
            {"res": "frost_demon.tres", "name": "Frost Demon", "count": 1, "level": 3},
        ],
    },
    "portal": {
        "prog": 3,
        "enemies": [
            {"res": "blood_imp.tres", "name": "Blood Imp", "count": 3, "level": 3},
            {"res": "hellion.tres", "name": "Hellion", "count": 2, "level": 3},
        ],
    },
    "inn_ambush": {
        "prog": 3,
        "enemies": [
            {"res": "skeleton_hunter.tres", "name": "Skeleton Hunter", "count": 2, "level": 3},
            {"res": "dark_elf_assassin.tres", "name": "Dark Elf Assassin", "count": 1, "level": 3},
            {"res": "fallen_seraph.tres", "name": "Fallen Seraph", "count": 1, "level": 3},
            {"res": "shadow_demon.tres", "name": "Shadow Demon", "count": 1, "level": 3},
        ],
    },
    "shore": {
        "prog": 4,
        "enemies": [
            {"res": "medusa.tres", "name": "Medusa", "count": 3, "level": 4},
            {"res": "sea_elf.tres", "name": "Sea Elf", "count": 2, "level": 4},
        ],
    },
    "beach": {
        "prog": 4,
        "enemies": [
            {"res": "pirate.tres", "name": "Pirate", "count": 3, "level": 4},
            {"res": "captain.tres", "name": "Captain", "count": 1, "level": 4},
            {"res": "ogre.tres", "name": "Ogre", "count": 1, "level": 4},
        ],
    },
    "cemetery_battle": {
        "prog": 4,
        "enemies": [
            {"res": "zombie.tres", "name": "Zombie", "count": 2, "level": 4},
            {"res": "specter.tres", "name": "Specter", "count": 2, "level": 4},
            {"res": "grave_wraith.tres", "name": "Grave Wraith", "count": 1, "level": 4},
        ],
    },
    "box_battle": {
        "prog": 4,
        "enemies": [
            {"res": "harlequin.tres", "name": "Harlequin", "count": 2, "level": 4},
            {"res": "elf_enchantress.tres", "name": "Elf Enchantress", "count": 2, "level": 4},
            {"res": "ringmaster.tres", "name": "Ringmaster", "count": 1, "level": 4},
        ],
    },
    "army_battle": {
        "prog": 4,
        "enemies": [
            {"res": "shadow_fiend.tres", "name": "Shadow Fiend", "count": 2, "level": 4},
            {"res": "orc_warchanter.tres", "name": "Orc Warchanter", "count": 2, "level": 4},
            {"res": "commander.tres", "name": "Commander", "count": 1, "level": 4},
        ],
    },
    "lab_battle": {
        "prog": 4,
        "enemies": [
            {"res": "frost_sentinel.tres", "name": "Frost Sentinel", "count": 2, "level": 4},
            {"res": "arc_golem.tres", "name": "Arc Golem", "count": 1, "level": 4},
            {"res": "skeleton_crusader.tres", "name": "Skeleton Crusader", "count": 1, "level": 4},
            {"res": "ironclad.tres", "name": "Ironclad", "count": 1, "level": 4},
        ],
    },
    "mirror_battle": {
        "prog": 5,
        "enemies": [
            {"res": "gorgon.tres", "name": "Gorgon", "count": 1, "level": 5},
            {"res": "ghost_corsair.tres", "name": "Ghost Corsair", "count": 1, "level": 5},
            {"res": "dark_elf_blade.tres", "name": "Dark Elf Blade", "count": 2, "level": 5},
            {"res": "dark_seraph.tres", "name": "Dark Seraph", "count": 1, "level": 5},
        ],
    },
    "gate_ambush": {
        "prog": 5,
        "enemies": [
            {"res": "ghost_corsair.tres", "name": "Ghost Corsair", "count": 1, "level": 5},
            {"res": "dark_elf_blade.tres", "name": "Dark Elf Blade", "count": 2, "level": 5},
            {"res": "bone_sorcerer.tres", "name": "Bone Sorcerer", "count": 1, "level": 5},
            {"res": "dark_seraph.tres", "name": "Dark Seraph", "count": 1, "level": 5},
        ],
    },
    "city_gate_ambush": {
        "prog": 6,
        "enemies": [
            {"res": "gorgon_queen.tres", "name": "Gorgon Queen", "count": 1, "level": 6},
            {"res": "dark_elf_warlord.tres", "name": "Dark Elf Warlord", "count": 1, "level": 6},
            {"res": "city_militia.tres", "name": "City Militia", "count": 1, "level": 6},
            {"res": "dire_shade.tres", "name": "Dire Shade", "count": 1, "level": 6},
            {"res": "phantom_prowler.tres", "name": "Phantom Prowler", "count": 1, "level": 6},
        ],
    },
    "return_city_1": {
        "prog": 6,
        "enemies": [
            {"res": "seraph.tres", "name": "Seraph", "count": 1, "level": 6},
            {"res": "arch_hellion.tres", "name": "Arch Hellion", "count": 1, "level": 6},
            {"res": "phantom_prowler.tres", "name": "Phantom Prowler", "count": 2, "level": 6},
            {"res": "dark_elf_warlord.tres", "name": "Dark Elf Warlord", "count": 1, "level": 6},
        ],
    },
    "return_city_2": {
        "prog": 6,
        "enemies": [
            {"res": "necromancer.tres", "name": "Necromancer", "count": 1, "level": 6},
            {"res": "elder_witch.tres", "name": "Elder Witch", "count": 1, "level": 6},
            {"res": "dire_shade.tres", "name": "Dire Shade", "count": 2, "level": 6},
            {"res": "dread_wraith.tres", "name": "Dread Wraith", "count": 1, "level": 6},
        ],
    },
    "return_city_3": {
        "prog": 6,
        "enemies": [
            {"res": "psion.tres", "name": "Psion", "count": 1, "level": 6},
            {"res": "runewright.tres", "name": "Runewright", "count": 1, "level": 6},
            {"res": "phantom_prowler.tres", "name": "Phantom Prowler", "count": 2, "level": 6},
            {"res": "dark_elf_warlord.tres", "name": "Dark Elf Warlord", "count": 1, "level": 6},
        ],
    },
    "return_city_4": {
        "prog": 6,
        "enemies": [
            {"res": "warlock.tres", "name": "Warlock", "count": 1, "level": 6},
            {"res": "shaman.tres", "name": "Shaman", "count": 1, "level": 6},
            {"res": "dire_shade.tres", "name": "Dire Shade", "count": 2, "level": 6},
            {"res": "gorgon_queen.tres", "name": "Gorgon Queen", "count": 1, "level": 6},
        ],
    },
}


# ── .tres parsing ──────────────────────────────────────────────────────────

def parse_tres_stats(filepath):
    """Parse a .tres file and return stat dict + ability file paths."""
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    # Extract ext_resource mappings: id -> path
    ext_res = {}
    for m in re.finditer(r'\[ext_resource[^\]]*path="([^"]+)"[^\]]*id="([^"]+)"', content):
        ext_res[m.group(2)] = m.group(1)
    # Also handle reversed order: id before path
    for m in re.finditer(r'\[ext_resource[^\]]*id="([^"]+)"[^\]]*path="([^"]+)"', content):
        ext_res[m.group(1)] = m.group(2)

    # Extract integer properties from [resource] section
    props = {}
    in_resource = False
    for line in content.split("\n"):
        line = line.strip()
        if line == "[resource]":
            in_resource = True
            continue
        if not in_resource:
            continue
        if line.startswith("[") and line != "[resource]":
            continue
        m = re.match(r"(\w+)\s*=\s*(-?\d+)$", line)
        if m:
            props[m.group(1)] = int(m.group(2))

    # Extract ability ExtResource IDs
    ability_ids = []
    ab_match = re.search(r"abilities\s*=\s*\[([^\]]*)\]", content)
    if ab_match:
        for m in re.finditer(r'ExtResource\("([^"]+)"\)', ab_match.group(1)):
            ability_ids.append(m.group(1))

    # Resolve ability paths
    ability_paths = []
    for aid in ability_ids:
        if aid in ext_res:
            # Convert res:// path to absolute
            res_path = ext_res[aid]
            if res_path.startswith("res://"):
                abs_path = os.path.join(BASE_DIR, res_path[6:].replace("/", os.sep))
                ability_paths.append(abs_path)

    return props, ability_paths


def parse_ability(filepath):
    """Parse an ability .tres and return (ability_type, modified_stat, modifier)."""
    if not os.path.exists(filepath):
        return None
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    props = {}
    in_resource = False
    for line in content.split("\n"):
        line = line.strip()
        if line == "[resource]":
            in_resource = True
            continue
        if not in_resource:
            continue
        m = re.match(r"(\w+)\s*=\s*(-?\d+)$", line)
        if m:
            props[m.group(1)] = int(m.group(2))

    return {
        "ability_type": props.get("ability_type", -1),
        "modified_stat": props.get("modified_stat", -1),
        "modifier": props.get("modifier", 0),
    }


def get_best_mods(ability_paths):
    """Get best physical and magic damage modifiers from abilities."""
    best_phys = 0
    has_mag = False
    best_mag = 0

    for path in ability_paths:
        ab = parse_ability(path)
        if ab is None or ab["ability_type"] != ABILITY_TYPE_DAMAGE:
            continue
        stat = ab["modified_stat"]
        mod = ab["modifier"]
        if stat == STAT_PHYS:
            best_phys = max(best_phys, mod)
        elif stat == STAT_MAG:
            if not has_mag:
                has_mag = True
                best_mag = mod
            else:
                best_mag = max(best_mag, mod)
        elif stat == STAT_MIXED:
            best_phys = max(best_phys, mod)
            if not has_mag:
                has_mag = True
                best_mag = mod
            else:
                best_mag = max(best_mag, mod)

    return best_phys, has_mag, best_mag


# ── Analysis and fix computation ───────────────────────────────────────────

def analyze_enemy(filepath, level, prog):
    """Analyze an enemy and return needed stat adjustments."""
    props, ability_paths = parse_tres_stats(filepath)
    best_phys_mod, has_mag, best_mag_mod = get_best_mods(ability_paths)

    # Effective stats at level
    p_atk = props.get("base_physical_attack", 0) + props.get("growth_physical_attack", 0) * (level - 1)
    m_atk = props.get("base_magic_attack", 0) + props.get("growth_magic_attack", 0) * (level - 1)
    p_def = props.get("base_physical_defense", 0) + props.get("growth_physical_defense", 0) * (level - 1)
    hp = props.get("base_max_health", 0) + props.get("growth_health", 0) * (level - 1)

    party = PARTY[prog]
    sq_atk = SQ_ATK[prog]

    adjustments = {}
    flags = []

    # ── SPIKE check ────────────────────────────────────────────────────────
    # For each class, check if max damage kills in < 3 hits
    worst_phys_need = None  # how much we need to reduce base P.Atk
    worst_mag_need = None

    for cls in CLASS_ORDER:
        cls_pdef, cls_mdef, cls_hp = party[cls]

        phys_dmg = max(0, best_phys_mod + p_atk - cls_pdef)
        mag_dmg = max(0, best_mag_mod + m_atk - cls_mdef) if has_mag else 0
        max_dmg = max(phys_dmg, mag_dmg)

        if max_dmg <= 0:
            continue

        ratio = cls_hp / max_dmg
        if ratio < 3.0:
            # Need to fix: target ratio = SPIKE_TARGET_RATIO
            target_dmg = cls_hp / SPIKE_TARGET_RATIO

            if phys_dmg >= mag_dmg and phys_dmg > target_dmg:
                # Physical damage is the problem
                target_p_atk = target_dmg + cls_pdef - best_phys_mod
                target_base = target_p_atk - props.get("growth_physical_attack", 0) * (level - 1)
                target_base = max(1, int(target_base))
                if worst_phys_need is None or target_base < worst_phys_need:
                    worst_phys_need = target_base

            if mag_dmg >= phys_dmg and mag_dmg > target_dmg:
                # Magic damage is the problem
                target_m_atk = target_dmg + cls_mdef - best_mag_mod
                target_base = target_m_atk - props.get("growth_magic_attack", 0) * (level - 1)
                target_base = max(1, int(target_base))
                if worst_mag_need is None or target_base < worst_mag_need:
                    worst_mag_need = target_base

    if worst_phys_need is not None and worst_phys_need < props.get("base_physical_attack", 0):
        adjustments["base_physical_attack"] = worst_phys_need
        flags.append("SPIKE(phys)")

    if worst_mag_need is not None and worst_mag_need < props.get("base_magic_attack", 0):
        adjustments["base_magic_attack"] = worst_mag_need
        flags.append("SPIKE(mag)")

    # ── SLOW check ─────────────────────────────────────────────────────────
    max_ttk = SLOW_TARGET_TTK[prog]
    eff_dmg = max(1, sq_atk - p_def)
    ttk = math.ceil(hp / eff_dmg)

    if ttk > max_ttk:
        # First ensure effective damage is reasonable
        new_p_def = p_def
        if eff_dmg < MIN_EFF_DMG:
            target_p_def = sq_atk - MIN_EFF_DMG
            # Reduce both base and growth proportionally
            old_base_def = props.get("base_physical_defense", 0)
            old_growth_def = props.get("growth_physical_defense", 0)
            target_base_def = target_p_def - old_growth_def * (level - 1)
            target_base_def = max(0, int(target_base_def))
            if target_base_def < old_base_def:
                adjustments["base_physical_defense"] = target_base_def
                flags.append("SLOW(def)")
            new_p_def = target_base_def + old_growth_def * (level - 1)
            eff_dmg = max(1, sq_atk - new_p_def)

        # Now reduce HP to meet TTK target
        target_hp = max_ttk * eff_dmg
        if target_hp < hp:
            old_base_hp = props.get("base_max_health", 0)
            old_growth_hp = props.get("growth_health", 0)
            growth_component = old_growth_hp * (level - 1)

            # Try reducing base first
            target_base_hp = target_hp - growth_component
            min_base_hp = max(20, int(old_base_hp * (1.0 - MAX_HP_REDUCTION)))

            if target_base_hp >= min_base_hp:
                # Base reduction alone is sufficient
                adjustments["base_max_health"] = int(target_base_hp)
                flags.append("SLOW(hp)")
            else:
                # Also need to reduce growth_health
                adjustments["base_max_health"] = min_base_hp
                if level > 1:
                    # How much growth can we afford?
                    max_growth_for_target = max(0, target_hp - min_base_hp) // (level - 1)
                    min_growth = max(1, int(old_growth_hp * (1.0 - MAX_GROWTH_HP_REDUCTION)))
                    new_growth = max(min_growth, max_growth_for_target)
                    if new_growth < old_growth_hp:
                        adjustments["growth_health"] = new_growth
                flags.append("SLOW(hp+growth)")

    return adjustments, flags, props


def apply_adjustments(filepath, adjustments, dry_run):
    """Modify a .tres file to apply stat adjustments. Returns change descriptions."""
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    changes = []
    for field, new_val in adjustments.items():
        pattern = rf"({field}\s*=\s*)(-?\d+)"
        m = re.search(pattern, content)
        if not m:
            continue
        old_val = int(m.group(2))
        if new_val == old_val:
            continue
        content = content[:m.start()] + f"{m.group(1)}{new_val}" + content[m.end():]
        changes.append(f"    {field}: {old_val} -> {new_val}")

    if changes and not dry_run:
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)

    return changes


# ── Main ───────────────────────────────────────────────────────────────────

def main():
    dry_run = "--dry-run" in sys.argv

    if dry_run:
        print("=== FIX BALANCE FLAGS (DRY RUN) ===\n")
    else:
        print("=== FIX BALANCE FLAGS ===\n")

    # Collect unique enemies and their battle contexts
    enemy_contexts = {}  # filename -> [(prog, level, battle_id)]
    for battle_id, bdata in BATTLES.items():
        prog = bdata["prog"]
        for entry in bdata["enemies"]:
            fname = entry["res"]
            if fname not in enemy_contexts:
                enemy_contexts[fname] = []
            enemy_contexts[fname].append((prog, entry["level"], battle_id))

    total_changes = 0
    total_enemies_changed = 0

    # Group by progression for readability
    prog_enemies = {}  # prog -> [(filename, name, level)]
    for battle_id, bdata in BATTLES.items():
        prog = bdata["prog"]
        if prog not in prog_enemies:
            prog_enemies[prog] = set()
        for entry in bdata["enemies"]:
            prog_enemies[prog].add((entry["res"], entry["name"], entry["level"]))

    for prog in sorted(prog_enemies.keys()):
        print(f"--- Progression {prog} ---")
        enemies = sorted(prog_enemies[prog], key=lambda x: x[1])
        seen = set()

        for fname, name, level in enemies:
            if fname in seen:
                continue
            seen.add(fname)

            filepath = os.path.join(ENEMIES_DIR, fname)
            if not os.path.exists(filepath):
                print(f"  WARNING: {fname} not found!")
                continue

            adjustments, flags, old_props = analyze_enemy(filepath, level, prog)
            if not adjustments:
                continue

            battles = [ctx[2] for ctx in enemy_contexts[fname]]
            print(f"  {name} ({fname}) [L{level}] — {', '.join(flags)}")
            print(f"    Battles: {', '.join(battles)}")

            changes = apply_adjustments(filepath, adjustments, dry_run)
            for c in changes:
                print(c)

            if changes:
                total_changes += len(changes)
                total_enemies_changed += 1

        print()

    action = "would change" if dry_run else "changed"
    print(f"Total: {action} {total_changes} stats across {total_enemies_changed} enemies")


if __name__ == "__main__":
    main()
