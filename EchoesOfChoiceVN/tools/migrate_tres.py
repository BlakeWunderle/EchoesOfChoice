#!/usr/bin/env python3
"""
Migrate .tres resource files from EchoesOfChoiceTactical to EchoesOfChoiceVN.

Handles:
- FighterData: removes movement, jump, reaction_types, sprite_id, sprite_id_female
                adds preferred_row and portrait_id
- AbilityData: removes ability_range, aoe_shape, aoe_size, terrain fields
                adds target_scope and requires_front_row
"""

import os
import re
import shutil
import sys

TACTICAL_ROOT = os.path.join(os.path.dirname(__file__), "..", "..", "EchoesOfChoiceTactical")
VN_ROOT = os.path.join(os.path.dirname(__file__), "..")

# Role-based row assignment: classes with these IDs get back row
BACK_ROW_CLASS_IDS = {
    # Mage tree
    "mage", "mistweaver", "cryomancer", "hydromancer",
    "firebrand", "pyromancer", "geomancer",
    "stormcaller", "electromancer", "tempest",
    "acolyte", "priest",
    # Scholar tree
    "scholar", "artificer", "alchemist", "thaumaturge",
    "cosmologist", "astronomer", "chronomancer",
    "arithmancer", "technomancer",
    # Entertainer tree (support/ranged)
    "entertainer", "bard", "minstrel",
    "orator", "laureate", "elegist",
    "chorister", "herald", "muse",
    # Ranged fighters
    "ranger", "hunter",
    # Princess (caster royal)
    "princess",
}

# Enemy role detection: enemies with these substrings in class_id get back row
BACK_ROW_ENEMY_PATTERNS = [
    "mage", "caster", "shaman", "priest", "healer", "archer",
    "wizard", "sorcerer", "witch", "necro", "warlock", "sage",
    "scholar", "mystic", "invoker", "oracle", "seer",
]


def should_be_back_row(class_id: str, is_enemy: bool = False) -> bool:
    """Determine preferred row based on class_id."""
    if class_id.lower() in BACK_ROW_CLASS_IDS:
        return True
    if is_enemy:
        lower = class_id.lower()
        for pattern in BACK_ROW_ENEMY_PATTERNS:
            if pattern in lower:
                return True
    return False


def migrate_fighter(content: str, class_id: str, is_enemy: bool) -> str:
    """Migrate a FighterData .tres file."""
    # Remove movement, jump, reaction_types lines
    content = re.sub(r'^movement = \d+\n', '', content, flags=re.MULTILINE)
    content = re.sub(r'^jump = \d+\n', '', content, flags=re.MULTILINE)
    content = re.sub(r'^reaction_types = .*\n', '', content, flags=re.MULTILINE)

    # Rename sprite_id to portrait_id, remove sprite_id_female
    content = re.sub(r'^sprite_id_female = ".*"\n', '', content, flags=re.MULTILINE)
    content = re.sub(r'^sprite_id = "(.*)"', r'portrait_id = "\1"', content, flags=re.MULTILINE)

    # Add preferred_row if not present
    if 'preferred_row' not in content:
        row_val = 1 if should_be_back_row(class_id, is_enemy) else 0
        # Insert before abilities line or at end of properties
        if 'abilities = ' in content:
            content = content.replace('abilities = ', f'preferred_row = {row_val}\nabilities = ')
        else:
            content = content.rstrip() + f'\npreferred_row = {row_val}\n'

    return content


def migrate_ability(content: str) -> str:
    """Migrate an AbilityData .tres file."""
    # Extract ability_range before removing it
    range_match = re.search(r'^ability_range = (\d+)', content, re.MULTILINE)
    ability_range = int(range_match.group(1)) if range_match else 1

    # Extract aoe_shape
    aoe_match = re.search(r'^aoe_shape = (\d+)', content, re.MULTILINE)
    aoe_shape = int(aoe_match.group(1)) if aoe_match else 0  # 0 = SINGLE

    # Extract use_on_enemy
    enemy_match = re.search(r'^use_on_enemy = (true|false)', content, re.MULTILINE)
    use_on_enemy = enemy_match.group(1) == "true" if enemy_match else True

    # Remove spatial and terrain fields
    content = re.sub(r'^ability_range = \d+\n', '', content, flags=re.MULTILINE)
    content = re.sub(r'^aoe_shape = \d+\n', '', content, flags=re.MULTILINE)
    content = re.sub(r'^aoe_size = \d+\n', '', content, flags=re.MULTILINE)
    content = re.sub(r'^terrain_tile = \d+\n', '', content, flags=re.MULTILINE)
    content = re.sub(r'^terrain_duration = \d+\n', '', content, flags=re.MULTILINE)

    # Determine target_scope
    # AoEShape enum: 0=SINGLE, 1=LINE, 2=CROSS, 3=DIAMOND, 4=SQUARE, 5=GLOBAL
    # TargetScope enum: 0=SINGLE, 1=ALL_ENEMIES, 2=ALL_ALLIES, 3=FRONT_ROW, 4=BACK_ROW
    if aoe_shape == 5:  # GLOBAL
        target_scope = 1 if use_on_enemy else 2  # ALL_ENEMIES or ALL_ALLIES
    elif aoe_shape in (2, 3, 4):  # CROSS, DIAMOND, SQUARE (AoE)
        target_scope = 1 if use_on_enemy else 2  # ALL_ENEMIES or ALL_ALLIES
    else:
        target_scope = 0  # SINGLE

    # Determine requires_front_row (melee = range 1)
    requires_front = ability_range <= 1 and use_on_enemy

    # Add new fields if not present
    if 'target_scope' not in content:
        if 'ability_type = ' in content:
            content = content.replace('ability_type = ',
                                      f'target_scope = {target_scope}\nrequires_front_row = {str(requires_front).lower()}\nability_type = ')
        else:
            content = content.rstrip() + f'\ntarget_scope = {target_scope}\nrequires_front_row = {str(requires_front).lower()}\n'

    return content


def get_class_id_from_tres(content: str) -> str:
    """Extract class_id from .tres content."""
    match = re.search(r'^class_id = "(.*)"', content, re.MULTILINE)
    return match.group(1) if match else ""


def update_script_path(content: str, old_prefix: str, new_prefix: str) -> str:
    """Update script resource paths in .tres files."""
    content = content.replace(
        f'path="res://scripts/data/',
        f'path="res://scripts/data/'
    )
    return content


def migrate_file(src_path: str, dst_path: str, resource_type: str) -> None:
    """Migrate a single .tres file."""
    with open(src_path, 'r', encoding='utf-8') as f:
        content = f.read()

    if resource_type == "fighter":
        class_id = get_class_id_from_tres(content)
        is_enemy = "/enemies/" in src_path
        content = migrate_fighter(content, class_id, is_enemy)
    elif resource_type == "ability":
        content = migrate_ability(content)
    # Items: copy as-is (already done)

    os.makedirs(os.path.dirname(dst_path), exist_ok=True)
    with open(dst_path, 'w', encoding='utf-8') as f:
        f.write(content)


def main():
    tactical_res = os.path.join(TACTICAL_ROOT, "resources")
    vn_res = os.path.join(VN_ROOT, "resources")

    counts = {"fighters": 0, "abilities": 0, "skipped": 0}

    # Migrate classes (FighterData)
    classes_dir = os.path.join(tactical_res, "classes")
    if os.path.isdir(classes_dir):
        for fname in os.listdir(classes_dir):
            if fname.endswith(".tres"):
                src = os.path.join(classes_dir, fname)
                dst = os.path.join(vn_res, "classes", fname)
                migrate_file(src, dst, "fighter")
                counts["fighters"] += 1

    # Migrate enemies (FighterData)
    enemies_dir = os.path.join(tactical_res, "enemies")
    if os.path.isdir(enemies_dir):
        for fname in os.listdir(enemies_dir):
            if fname.endswith(".tres"):
                src = os.path.join(enemies_dir, fname)
                dst = os.path.join(vn_res, "enemies", fname)
                migrate_file(src, dst, "fighter")
                counts["fighters"] += 1

    # Migrate abilities (AbilityData)
    abilities_dir = os.path.join(tactical_res, "abilities")
    if os.path.isdir(abilities_dir):
        for fname in os.listdir(abilities_dir):
            if fname.endswith(".tres"):
                src = os.path.join(abilities_dir, fname)
                dst = os.path.join(vn_res, "abilities", fname)
                migrate_file(src, dst, "ability")
                counts["abilities"] += 1

    print(f"Migration complete:")
    print(f"  Fighters (classes + enemies): {counts['fighters']}")
    print(f"  Abilities: {counts['abilities']}")
    print(f"  Items: already copied directly")


if __name__ == "__main__":
    main()
