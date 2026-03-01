#!/usr/bin/env python3
"""Cross-reference all player class abilities between C# reference and tactical .tres port.

Parses:
  - C# ability files in EchoesOfChoice/CharacterClasses/Abilities/*.cs
  - Tactical ability files in EchoesOfChoiceTactical/resources/abilities/*.tres
  - Tactical class files in EchoesOfChoiceTactical/resources/classes/*.tres

Reports mismatches in ability_type, modified_stat, and modifier values.
"""

import os
import re
import sys
from pathlib import Path

# Paths
ROOT = Path(__file__).resolve().parent.parent.parent
CS_ABILITIES = ROOT / "EchoesOfChoice" / "CharacterClasses" / "Abilities"
CS_CLASSES = ROOT / "EchoesOfChoice" / "CharacterClasses"
TAC_ABILITIES = ROOT / "EchoesOfChoiceTactical" / "resources" / "abilities"
TAC_CLASSES = ROOT / "EchoesOfChoiceTactical" / "resources" / "classes"

# C# StatEnum string → tactical StatType int
CS_STAT_TO_TAC = {
    "PhysicalAttack": 0,
    "PhysicalDefense": 1,
    "MagicAttack": 2,
    "MagicDefense": 3,
    "Attack": 4,
    "Defense": 5,
    "MixedAttack": 6,
    "Speed": 7,
    "DodgeChance": 8,
    "Taunt": 9,
    "Health": 10,
}

TAC_STAT_NAMES = {
    0: "PHYSICAL_ATTACK", 1: "PHYSICAL_DEFENSE", 2: "MAGIC_ATTACK",
    3: "MAGIC_DEFENSE", 4: "ATTACK", 5: "DEFENSE", 6: "MIXED_ATTACK",
    7: "SPEED", 8: "DODGE_CHANCE", 9: "TAUNT", 10: "MAX_HEALTH",
}

TAC_TYPE_NAMES = {0: "DAMAGE", 1: "HEAL", 2: "BUFF", 3: "DEBUFF", 4: "TERRAIN"}


def infer_cs_type(impacted_turns: int, use_on_enemy: bool) -> int:
    """Infer tactical ability_type from C# fields."""
    if impacted_turns > 0:
        return 3 if use_on_enemy else 2  # DEBUFF or BUFF
    return 0 if use_on_enemy else 1  # DAMAGE or HEAL


def parse_cs_ability(filepath: Path) -> dict | None:
    """Parse a C# ability .cs file."""
    text = filepath.read_text(encoding="utf-8-sig")
    result = {}

    m = re.search(r'Name\s*=\s*"([^"]+)"', text)
    if m:
        result["name"] = m.group(1)
    else:
        return None

    m = re.search(r"ModifiedStat\s*=\s*StatEnum\.(\w+)", text)
    result["stat"] = m.group(1) if m else None

    m = re.search(r"Modifier\s*=\s*(\d+)", text)
    result["modifier"] = int(m.group(1)) if m else 0

    m = re.search(r"impactedTurns\s*=\s*(\d+)", text)
    result["impacted_turns"] = int(m.group(1)) if m else 0

    m = re.search(r"UseOnEnemy\s*=\s*(true|false)", text)
    result["use_on_enemy"] = m.group(1) == "true" if m else False

    m = re.search(r"ManaCost\s*=\s*(\d+)", text)
    result["mana_cost"] = int(m.group(1)) if m else 0

    m = re.search(r"TargetAll\s*=\s*(true|false)", text)
    result["target_all"] = m.group(1) == "true" if m else False

    result["tac_stat"] = CS_STAT_TO_TAC.get(result["stat"], -1)
    result["tac_type"] = infer_cs_type(result["impacted_turns"], result["use_on_enemy"])

    return result


def parse_tres_ability(filepath: Path) -> dict | None:
    """Parse a tactical ability .tres file."""
    text = filepath.read_text(encoding="utf-8-sig")
    result = {"file": filepath.name}

    m = re.search(r'ability_name\s*=\s*"([^"]+)"', text)
    if m:
        result["name"] = m.group(1)
    else:
        return None

    for field in ["modified_stat", "modifier", "impacted_turns", "mana_cost",
                  "ability_range", "aoe_shape", "aoe_size", "ability_type"]:
        m = re.search(rf"{field}\s*=\s*(\d+)", text)
        result[field] = int(m.group(1)) if m else 0

    m = re.search(r"use_on_enemy\s*=\s*(true|false)", text)
    result["use_on_enemy"] = m.group(1) == "true" if m else False

    return result


def normalize_name(name: str) -> str:
    """Normalize ability name for matching."""
    return name.lower().replace(" ", "_").replace("'", "")


def get_class_abilities(class_dir: Path) -> dict:
    """Read tactical class .tres files and return class_id -> [ability_filenames]."""
    classes = {}
    for f in sorted(class_dir.glob("*.tres")):
        text = f.read_text(encoding="utf-8-sig")
        m_id = re.search(r'class_id\s*=\s*"([^"]+)"', text)
        if not m_id:
            continue
        class_id = m_id.group(1)
        # Extract ability resource paths
        ability_files = []
        for m in re.finditer(r'path="res://resources/abilities/([^"]+)"', text):
            ability_files.append(m.group(1))
        classes[class_id] = ability_files
    return classes


def main():
    # Parse all C# abilities
    cs_abilities = {}
    for f in sorted(CS_ABILITIES.glob("*.cs")):
        parsed = parse_cs_ability(f)
        if parsed:
            key = normalize_name(parsed["name"])
            cs_abilities[key] = parsed

    # Parse all tactical abilities
    tac_abilities = {}
    for f in sorted(TAC_ABILITIES.glob("*.tres")):
        parsed = parse_tres_ability(f)
        if parsed:
            key = normalize_name(parsed["name"])
            tac_abilities[key] = parsed

    # Get class -> ability mapping
    class_abilities = get_class_abilities(TAC_CLASSES)

    # Build set of abilities used by player classes (not enemy-only)
    player_ability_files = set()
    for abilities in class_abilities.values():
        player_ability_files.update(abilities)

    print(f"C# abilities: {len(cs_abilities)}")
    print(f"Tactical abilities: {len(tac_abilities)}")
    print(f"Player class abilities: {len(player_ability_files)}")
    print()

    # Compare
    issues = []
    for key, cs in sorted(cs_abilities.items()):
        tac = tac_abilities.get(key)
        if not tac:
            # Check alternate names (e.g., "second_wind" vs "aegis")
            continue

        problems = []

        # Check ability_type
        if tac["ability_type"] != cs["tac_type"]:
            problems.append(
                f"TYPE: C#={TAC_TYPE_NAMES.get(cs['tac_type'], '?')} "
                f"tac={TAC_TYPE_NAMES.get(tac['ability_type'], '?')}"
            )

        # Check modified_stat
        if cs["tac_stat"] >= 0 and tac["modified_stat"] != cs["tac_stat"]:
            problems.append(
                f"STAT: C#={cs['stat']}({cs['tac_stat']}) "
                f"tac={TAC_STAT_NAMES.get(tac['modified_stat'], '?')}({tac['modified_stat']})"
            )

        # Check modifier
        if abs(tac["modifier"] - cs["modifier"]) > 1:
            problems.append(
                f"MOD: C#={cs['modifier']} tac={tac['modifier']} "
                f"(diff={tac['modifier'] - cs['modifier']:+d})"
            )

        # Check mana_cost
        if abs(tac["mana_cost"] - cs["mana_cost"]) > 1:
            problems.append(
                f"MANA: C#={cs['mana_cost']} tac={tac['mana_cost']} "
                f"(diff={tac['mana_cost'] - cs['mana_cost']:+d})"
            )

        if problems:
            is_player = tac.get("file", "") in player_ability_files
            tag = "PLAYER" if is_player else "enemy/shared"
            issues.append((cs["name"], tag, problems))

    # Print report
    if not issues:
        print("No mismatches found!")
        return

    print(f"MISMATCHES FOUND: {len(issues)}")
    print("=" * 70)

    # Sort: player abilities first, then by name
    issues.sort(key=lambda x: (0 if x[1] == "PLAYER" else 1, x[0]))

    for name, tag, problems in issues:
        print(f"\n  {name} [{tag}]")
        for p in problems:
            print(f"    {p}")

    # Summary of missing abilities
    print("\n" + "=" * 70)
    print("ABILITIES IN C# BUT NOT IN TACTICAL:")
    cs_only = set(cs_abilities.keys()) - set(tac_abilities.keys())
    for key in sorted(cs_only):
        print(f"  {cs_abilities[key]['name']}")

    print(f"\nABILITIES IN TACTICAL BUT NOT IN C# ({len(set(tac_abilities.keys()) - set(cs_abilities.keys()))}):")
    tac_only = set(tac_abilities.keys()) - set(cs_abilities.keys())
    for key in sorted(tac_only):
        t = tac_abilities[key]
        print(f"  {t['name']} ({t['file']})")


if __name__ == "__main__":
    main()
