#!/usr/bin/env python3
"""Batch rename enemy .tres files to match their sprite appearances."""
import os
import re
import shutil

ENEMIES_DIR = os.path.join(os.path.dirname(__file__), "..", "resources", "enemies")

# ── Rename map: old_id → (new_id, new_display_name, ability_changes) ──
# ability_changes: None = keep same, or dict of {old_ability: new_ability} or "replace_all" with full list
RENAMES = {
    # Prog 0-1
    "wolf": ("gnoll_raider", "Gnoll Raider", "replace_all", ["gnoll_strike", "war_howl"]),
    "wild_boar": ("minotaur", "Minotaur", {"gore": "horn_charge"}, None),
    "bear": ("forest_guardian", "Forest Guardian", {"slash": "vine_lash"}, None),
    "bear_cub": ("grove_sprite", "Grove Sprite", "replace_all", ["nature_ward"]),
    "hex_peddler": ("bone_peddler", "Bone Peddler", None, None),
    "goblin_shaman": ("orc_shaman", "Orc Shaman", None, None),
    "hobgoblin": ("orc_warrior", "Orc Warrior", None, None),

    # Prog 2-3
    "imp": ("goblin_firestarter", "Goblin Firestarter", None, None),
    "fire_spirit": ("blood_fiend", "Blood Fiend", None, None),
    "fiendling": ("blood_imp", "Blood Imp", None, None),
    "cave_bat": ("orc_scout", "Orc Scout", {"bite": "lunge"}, None),
    "fire_wyrmling": ("demon_archer", "Demon Archer", None, None),
    "frost_wyrmling": ("frost_demon", "Frost Demon", None, None),
    "gloom_stalker": ("shadow_demon", "Shadow Demon", None, None),
    "shadow_hound": ("skeleton_hunter", "Skeleton Hunter", None, None),
    "night_prowler": ("dark_elf_assassin", "Dark Elf Assassin", None, None),
    "nymph": ("elf_ranger", "Elf Ranger", {"undertow": "arrow_shot"}, None),

    # Prog 4-5
    "siren": ("medusa", "Medusa", {"undertow": "stone_gaze"}, None),
    "tide_nymph": ("sea_elf", "Sea Elf", {"natures_embrace": "arrow_shot"}, None),
    "kraken": ("ogre", "Ogre", "replace_all", ["smash", "cleave"]),
    "chanteuse": ("elf_enchantress", "Elf Enchantress", None, None),
    "dusk_moth": ("fallen_seraph", "Fallen Seraph", None, None),
    "twilight_moth": ("dark_seraph", "Dark Seraph", None, None),
    "android": ("frost_sentinel", "Frost Sentinel", {"chain_lightning": "frost_strike"}, None),
    "machinist": ("skeleton_crusader", "Skeleton Crusader", {"servo_strike": "smash"}, None),
    "draconian": ("shadow_fiend", "Shadow Fiend", None, None),
    "chaplain": ("orc_warchanter", "Orc Warchanter", None, None),
    "dusk_prowler": ("dark_elf_blade", "Dark Elf Blade", None, None),
    "cursed_peddler": ("bone_sorcerer", "Bone Sorcerer", None, None),
    "void_watcher": ("gorgon", "Gorgon", "add", ["stone_gaze"]),
    "mirror_stalker": ("ghost_corsair", "Ghost Corsair", None, None),
    "watcher_lord": ("gorgon_queen", "Gorgon Queen", "add", ["stone_gaze"]),
    "dread_stalker": ("dark_elf_warlord", "Dark Elf Warlord", None, None),
}

# Ogre stat overrides (was Kraken - shift from magic to physical)
OGRE_STAT_OVERRIDES = {
    "base_physical_attack": 42,
    "base_magic_attack": 8,
    "base_physical_defense": 24,
    "base_magic_defense": 12,
}


def parse_tres(filepath):
    """Parse a .tres file into header, ext_resources, and resource block."""
    with open(filepath, "r") as f:
        content = f.read()
    return content


def get_ability_name_from_path(path):
    """Extract ability name from res:// path."""
    # "res://resources/abilities/bite.tres" -> "bite"
    m = re.search(r'abilities/(\w+)\.tres', path)
    return m.group(1) if m else None


def build_ext_resource_line(ability_name, ext_id):
    """Build an ext_resource line for an ability."""
    return f'[ext_resource type="Resource" path="res://resources/abilities/{ability_name}.tres" id="{ext_id}"]'


def transform_file(old_path, old_id, new_id, new_display, ability_mode, ability_list):
    """Transform a .tres file with new id, display name, and abilities."""
    content = parse_tres(old_path)

    # Update class_id and class_display_name
    content = re.sub(
        r'class_id = ".*?"',
        f'class_id = "{new_id}"',
        content
    )
    content = re.sub(
        r'class_display_name = ".*?"',
        f'class_display_name = "{new_display}"',
        content
    )

    # Handle ability changes
    if ability_mode is None:
        # No ability changes
        pass
    elif ability_mode == "replace_all":
        # Complete ability replacement
        # Remove all existing ability ext_resources (keep script ext_resource)
        lines = content.split("\n")
        new_lines = []
        ability_ext_ids = []

        for line in lines:
            if 'type="Resource" path="res://resources/abilities/' in line:
                # Extract the id for tracking
                m = re.search(r'id="(\d+)"', line)
                if m:
                    ability_ext_ids.append(m.group(1))
                continue  # Skip old ability ext_resources
            new_lines.append(line)

        content = "\n".join(new_lines)

        # Add new ability ext_resources after the script ext_resource
        new_ext_lines = []
        for i, ability_name in enumerate(ability_list):
            ext_id = str(i + 2)  # Start at 2 (1 is script)
            new_ext_lines.append(build_ext_resource_line(ability_name, ext_id))

        # Insert after [ext_resource type="Script"...] line
        script_pattern = r'(\[ext_resource type="Script"[^\]]*\])'
        m = re.search(script_pattern, content)
        if m:
            insert_pos = m.end()
            insert_text = "\n" + "\n".join(new_ext_lines)
            content = content[:insert_pos] + insert_text + content[insert_pos:]

        # Update load_steps
        load_steps = len(ability_list) + 1  # +1 for script
        content = re.sub(r'load_steps=\d+', f'load_steps={load_steps + 1}', content)

        # Update abilities array
        ext_refs = ", ".join([f'ExtResource("{i + 2}")' for i in range(len(ability_list))])
        content = re.sub(r'abilities = \[.*?\]', f'abilities = [{ext_refs}]', content)

    elif ability_mode == "add":
        # Add abilities without removing existing ones
        # Find highest existing ext_resource id
        ext_ids = [int(m.group(1)) for m in re.finditer(r'\[ext_resource[^\]]*id="(\d+)"', content)]
        max_id = max(ext_ids) if ext_ids else 1

        # Add new ext_resources
        new_ext_lines = []
        new_ext_refs = []
        for i, ability_name in enumerate(ability_list):
            ext_id = str(max_id + 1 + i)
            new_ext_lines.append(build_ext_resource_line(ability_name, ext_id))
            new_ext_refs.append(f'ExtResource("{ext_id}")')

        # Find last ext_resource line and insert after it
        last_ext_pos = 0
        for m in re.finditer(r'\[ext_resource[^\]]*\]', content):
            last_ext_pos = m.end()

        if last_ext_pos > 0:
            insert_text = "\n" + "\n".join(new_ext_lines)
            content = content[:last_ext_pos] + insert_text + content[last_ext_pos:]

        # Update load_steps
        old_steps = int(re.search(r'load_steps=(\d+)', content).group(1))
        content = re.sub(r'load_steps=\d+', f'load_steps={old_steps + len(ability_list)}', content)

        # Update abilities array - append new refs
        m = re.search(r'abilities = \[(.*?)\]', content)
        if m:
            old_abilities = m.group(1)
            if old_abilities.strip():
                new_abilities = old_abilities + ", " + ", ".join(new_ext_refs)
            else:
                new_abilities = ", ".join(new_ext_refs)
            content = re.sub(r'abilities = \[.*?\]', f'abilities = [{new_abilities}]', content)

    elif isinstance(ability_mode, dict):
        # Swap specific abilities
        for old_ability, new_ability in ability_mode.items():
            content = content.replace(
                f'path="res://resources/abilities/{old_ability}.tres"',
                f'path="res://resources/abilities/{new_ability}.tres"'
            )

    # Apply stat overrides for ogre
    if new_id == "ogre":
        for stat_name, value in OGRE_STAT_OVERRIDES.items():
            content = re.sub(
                rf'{stat_name} = \d+',
                f'{stat_name} = {value}',
                content
            )

    return content


def main():
    renamed = 0
    errors = []

    for old_id, (new_id, new_display, ability_mode, ability_list) in RENAMES.items():
        old_path = os.path.join(ENEMIES_DIR, f"{old_id}.tres")
        new_path = os.path.join(ENEMIES_DIR, f"{new_id}.tres")

        if not os.path.exists(old_path):
            errors.append(f"MISSING: {old_path}")
            continue

        if os.path.exists(new_path):
            errors.append(f"ALREADY EXISTS: {new_path}")
            continue

        try:
            new_content = transform_file(old_path, old_id, new_id, new_display, ability_mode, ability_list)
            with open(new_path, "w") as f:
                f.write(new_content)
            os.remove(old_path)
            renamed += 1
            print(f"  {old_id}.tres -> {new_id}.tres ({new_display})")
        except Exception as e:
            errors.append(f"ERROR on {old_id}: {e}")

    print(f"\nRenamed {renamed}/{len(RENAMES)} enemies")
    if errors:
        print("\nErrors:")
        for e in errors:
            print(f"  {e}")


if __name__ == "__main__":
    main()
