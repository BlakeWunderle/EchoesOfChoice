#!/usr/bin/env python3
"""
Batch-generate SpriteFrames .tres files for all CraftPix sprites.

Scans sprite source directories, reads PNG dimensions with PIL,
and writes Godot 4 SpriteFrames .tres files directly (no Godot import needed).

Usage:
    python tools/generate_all_sprites.py [--only <sprite_id>] [--dry-run]
"""

import argparse
import re
import sys
from pathlib import Path

from PIL import Image

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent
ASSETS_DIR = PROJECT_DIR / "assets" / "art" / "sprites"
OUTPUT_DIR = ASSETS_DIR / "spriteframes"

# Animation keywords for classifying PNG filenames
ANIM_KEYWORDS = {
    "idle": ["Idle"],
    "walk": ["Walk"],
    "attack": ["attack", "Attack"],
    "hurt": ["Hurt"],
    "death": ["Death"],
}
WALK_FALLBACK = ["Run"]
SKIP_PREFIXES = ["shadow_", "Shadow_", "Shadow."]
SKIP_CONTAINS = ["Run_Attack", "Walk_Attack"]
ANIM_ORDER = ["idle", "walk", "attack", "hurt", "death"]
LOOP_ANIMS = {"idle", "walk"}
ROW_ORDER = ["down", "left", "right", "up"]


# ---------------------------------------------------------------------------
# Sprite Registry: sprite_id -> source config
# ---------------------------------------------------------------------------

SPRITES: dict[str, dict] = {}


def _reg(sprite_id: str, rel_path: str, fw: int = 64, fh: int = 64) -> None:
    """Register a sprite in the global registry."""
    SPRITES[sprite_id] = {"path": rel_path, "fw": fw, "fh": fh}


# --- Characters: Swordsman (9 variants, 64x64) ---
for lvl in range(1, 4):
    _reg(f"swordsman_{lvl}",
         f"characters/swordsman_1_3/PNG/Swordsman_lvl{lvl}/Without_shadow")
for lvl in range(4, 7):
    _reg(f"swordsman_{lvl}",
         f"characters/swordsman_4_6/PNG/Swordsman_lvl{lvl}/Without_shadow")
for lvl in range(7, 10):
    _reg(f"swordsman_{lvl}",
         f"characters/swordsman_7_9/PNG/Swordsman_lvl{lvl}/Without_shadow")

# --- Characters: Vampire (3 variants, 64x64) ---
for i in range(1, 4):
    _reg(f"vampire_{i}",
         f"characters/vampire/PNG/Vampires{i}/Without_shadow")

# --- Characters: Base male/female sword (64x64) ---
_reg("base_male_sword", "characters/base_male/PNG/Sword/Without_shadow")
_reg("base_female_sword", "characters/base_female/PNG/Sword/Without_shadow")

# --- Enemies: Standard 64x64 ---
_enemy_packs_64 = {
    "skeleton": ("Skeleton", 3),
    "goblin": ("Goblin", 3),
    "zombie": ("Zombie", 3),
    "ghost": ("Ghost", 3),
    "imp": ("Imp", 3),
    "lich": ("Lich", 3),
    "gnolls": ("Gnoll", 3),
    "lizardmen": ("Lizardman", 3),
    "mushroom": ("Mushroom", 3),
    "predator_plant": ("Plant", 3),
    "beholder": ("Beholder", 3),
    "slime_mobs": ("Slime", 3),
    "slime_enemies": ("Slime", 3),
}

for pack, (prefix, count) in _enemy_packs_64.items():
    for i in range(1, count + 1):
        sprite_id = f"{pack}_{i}" if pack not in ("slime_mobs", "slime_enemies") else f"{pack}_{i}"
        _reg(sprite_id,
             f"enemies/{pack}/PNG/{prefix}{i}/Without_shadow")

# --- Enemies: Large 128x128 ---
_enemy_packs_128 = {
    "golem": ("Golem", 3),
    "demons": ("Demon", 3),
    "ent": ("Ent", 3),
    "giant_rat": ("Rat", 3),
    "slime_boss": ("Slime_boss", 3),
}

for pack, (prefix, count) in _enemy_packs_128.items():
    for i in range(1, count + 1):
        _reg(f"{pack}_{i}",
             f"enemies/{pack}/PNG/{prefix}{i}/Without_shadow",
             fw=128, fh=128)


# ---------------------------------------------------------------------------
# .tres Generation
# ---------------------------------------------------------------------------

def should_skip(filename: str) -> bool:
    for prefix in SKIP_PREFIXES:
        if filename.startswith(prefix):
            return True
    for pattern in SKIP_CONTAINS:
        if pattern in filename:
            return True
    return False


def classify_file(filename: str) -> str:
    """Map a filename to an animation name based on keywords."""
    for anim_name, keywords in ANIM_KEYWORDS.items():
        for keyword in keywords:
            if keyword in filename:
                return anim_name
    return ""


def discover_anims(dir_path: Path) -> dict[str, Path]:
    """Scan a directory and map animation names to PNG files."""
    anim_files: dict[str, Path] = {}

    png_files = sorted(dir_path.glob("*.png"))
    for png in png_files:
        if should_skip(png.name):
            continue
        anim = classify_file(png.name)
        if anim:
            anim_files[anim] = png

    # Fallback: if no walk, try Run
    if "walk" not in anim_files:
        for png in png_files:
            if should_skip(png.name):
                continue
            for keyword in WALK_FALLBACK:
                if keyword in png.name:
                    anim_files["walk"] = png
                    break
            if "walk" in anim_files:
                break

    return anim_files


def generate_tres(sprite_id: str, anim_files: dict[str, Path],
                  fw: int, fh: int, fps: float = 8.0) -> str:
    """Generate a SpriteFrames .tres file as text."""
    # Collect all ext_resources (one per unique PNG) and sub_resources (AtlasTextures)
    ext_resources: list[tuple[str, str]]  = []  # (id, res_path)
    sub_resources: list[tuple[str, str, str, str]] = []  # (sub_id, ext_id, region_str, sub_id_label)
    animations: list[dict] = []

    ext_id_counter = 1
    sub_id_counter = 1

    for anim_base in ANIM_ORDER:
        if anim_base not in anim_files:
            continue

        png_path = anim_files[anim_base]
        img = Image.open(png_path)
        img_w, img_h = img.size
        cols = img_w // fw
        rows = img_h // fh

        if cols < 1 or rows < 1:
            continue

        # Convert to res:// path
        try:
            rel = png_path.relative_to(PROJECT_DIR)
        except ValueError:
            continue
        res_path = "res://" + str(rel).replace("\\", "/")

        # Add ext_resource for this PNG
        ext_id = str(ext_id_counter)
        ext_resources.append((ext_id, res_path))
        ext_id_counter += 1

        # Create directional animations
        dir_count = min(rows, len(ROW_ORDER))
        for dir_i in range(dir_count):
            direction = ROW_ORDER[dir_i]
            anim_name = f"{anim_base}_{direction}"
            frame_refs = []

            for col in range(cols):
                sub_id = f"AtlasTexture_{sub_id_counter}"
                region = f"Rect2({col * fw}, {dir_i * fh}, {fw}, {fh})"
                sub_resources.append((sub_id, ext_id, region, sub_id))
                frame_refs.append(sub_id)
                sub_id_counter += 1

            animations.append({
                "name": anim_name,
                "speed": fps,
                "loop": anim_base in LOOP_ANIMS,
                "frames": frame_refs,
            })

    if not animations:
        return ""

    # Build the .tres text
    load_steps = len(ext_resources) + len(sub_resources) + 1
    lines = [f'[gd_resource type="SpriteFrames" load_steps={load_steps} format=3]']
    lines.append("")

    # ext_resources
    for ext_id, res_path in ext_resources:
        lines.append(f'[ext_resource type="Texture2D" path="{res_path}" id="{ext_id}"]')

    if ext_resources:
        lines.append("")

    # sub_resources (AtlasTextures)
    for sub_id, ext_id, region, _ in sub_resources:
        lines.append(f'[sub_resource type="AtlasTexture" id="{sub_id}"]')
        lines.append(f'atlas = ExtResource("{ext_id}")')
        lines.append(f"region = {region}")
        lines.append("")

    # resource section
    lines.append("[resource]")

    # Build animations array
    anim_strs = []
    for anim in animations:
        frame_entries = []
        for fref in anim["frames"]:
            frame_entries.append('{{\n"duration": 1.0,\n"texture": SubResource("%s")\n}}' % fref)

        frames_str = "[" + ", ".join(frame_entries) + "]"
        loop_str = "true" if anim["loop"] else "false"
        anim_str = (
            f'{{\n'
            f'"frames": {frames_str},\n'
            f'"loop": {loop_str},\n'
            f'"name": &"{anim["name"]}",\n'
            f'"speed": {anim["speed"]}\n'
            f'}}'
        )
        anim_strs.append(anim_str)

    lines.append("animations = [" + ", ".join(anim_strs) + "]")
    lines.append("")

    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate SpriteFrames .tres for all CraftPix sprites")
    parser.add_argument("--only", type=str, help="Generate only this sprite_id")
    parser.add_argument("--dry-run", action="store_true", help="Print what would be generated without writing")
    args = parser.parse_args()

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    sprites_to_gen = SPRITES
    if args.only:
        if args.only not in SPRITES:
            print(f"ERROR: Unknown sprite_id '{args.only}'")
            print(f"Available: {', '.join(sorted(SPRITES.keys()))}")
            sys.exit(1)
        sprites_to_gen = {args.only: SPRITES[args.only]}

    total = len(sprites_to_gen)
    success = 0
    skipped = 0
    failed = 0

    print(f"Generating {total} SpriteFrames .tres files...")
    print(f"Output: {OUTPUT_DIR}")
    print()

    for sprite_id, config in sorted(sprites_to_gen.items()):
        dir_path = ASSETS_DIR / config["path"]
        fw = config["fw"]
        fh = config["fh"]

        if not dir_path.is_dir():
            print(f"  SKIP {sprite_id}: directory not found ({dir_path})")
            skipped += 1
            continue

        anim_files = discover_anims(dir_path)
        if not anim_files:
            print(f"  SKIP {sprite_id}: no animation PNGs found")
            skipped += 1
            continue

        tres_content = generate_tres(sprite_id, anim_files, fw, fh)
        if not tres_content:
            print(f"  FAIL {sprite_id}: could not generate .tres")
            failed += 1
            continue

        output_path = OUTPUT_DIR / f"{sprite_id}.tres"

        if args.dry_run:
            anim_names = [a for a in ANIM_ORDER if a in anim_files]
            print(f"  [DRY] {sprite_id}: {', '.join(anim_names)} ({fw}x{fh})")
        else:
            output_path.write_text(tres_content, encoding="utf-8")
            # Count animations in output
            anim_count = tres_content.count('"name": &"')
            print(f"  OK   {sprite_id}: {anim_count} animations -> {output_path.name}")

        success += 1

    print()
    print(f"Done: {success} generated, {skipped} skipped, {failed} failed (of {total} total)")


if __name__ == "__main__":
    main()
