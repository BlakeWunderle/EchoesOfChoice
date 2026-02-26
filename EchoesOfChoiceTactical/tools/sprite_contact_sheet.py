#!/usr/bin/env python3
"""
Generate a contact sheet showing all class sprites (male + female side by side).

Usage:
    python tools/sprite_contact_sheet.py
    python tools/sprite_contact_sheet.py --enemies
    python tools/sprite_contact_sheet.py --all

Outputs PNG files to the project root.
"""

import argparse
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent
PROCESSED_DIR = PROJECT_DIR / "assets" / "art" / "sprites" / "processed"

# Import sprite mappings
sys.path.insert(0, str(SCRIPT_DIR))
from set_sprite_ids import CLASS_SPRITE_IDS, CLASS_SPRITE_IDS_FEMALE, ENEMY_SPRITE_IDS

# Layout constants
FRAME_SIZE = 64       # Each sprite frame is 64x64
CELL_PAD = 8
LABEL_HEIGHT = 20
COLS = 6              # Classes per row
BG_COLOR = (40, 40, 50)
LABEL_COLOR = (220, 220, 220)
BORDER_MALE = (100, 150, 255)
BORDER_FEMALE = (255, 140, 180)
BORDER_ENEMY = (255, 100, 100)


def extract_south_idle_frame(sprite_id: str) -> Image.Image | None:
    """Extract the first south-facing idle frame from a processed sprite."""
    idle_path = PROCESSED_DIR / sprite_id / "idle.png"
    if not idle_path.exists():
        return None
    img = Image.open(idle_path)
    # 3-dir sprites: 3 rows (south/east/north), N columns of 64x64 frames
    # 4-dir sprites: 4 rows, N columns
    row_height = FRAME_SIZE
    # First frame of first row = south-facing idle frame 0
    frame = img.crop((0, 0, FRAME_SIZE, row_height))
    return frame


def try_get_font(size: int = 14) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    """Try to load a readable font, fall back to default."""
    font_paths = [
        "C:/Windows/Fonts/consola.ttf",
        "C:/Windows/Fonts/arial.ttf",
        "C:/Windows/Fonts/segoeui.ttf",
    ]
    for fp in font_paths:
        try:
            return ImageFont.truetype(fp, size)
        except (OSError, IOError):
            continue
    return ImageFont.load_default()


def make_class_contact_sheet(output_path: Path) -> None:
    """Generate contact sheet with male/female variants side by side."""
    # Sort classes by tree grouping
    tree_order = [
        # Martial Artist tree
        "martial_artist", "monk", "dervish", "mercenary", "hunter",
        "tempest", "ninja", "duelist", "dragoon", "ranger",
        # Squire tree
        "squire", "knight", "paladin", "warden", "bastion",
        "cavalry", "firebrand",
        # Mage tree
        "mage", "acolyte", "herald", "mistweaver", "stormcaller",
        "priest", "thaumaturge", "illusionist", "chronomancer",
        "pyromancer", "cryomancer", "electromancer", "hydromancer", "geomancer",
        # Entertainer tree
        "entertainer", "bard", "chorister", "orator",
        "minstrel", "elegist", "laureate", "mime", "muse", "warcrier",
        # Scholar tree
        "scholar", "alchemist", "artificer", "tinker", "technomancer",
        "bombardier", "siegemaster", "automaton", "astronomer", "cosmologist",
        "arithmancer",
        # Royal
        "prince", "princess",
    ]

    classes = [c for c in tree_order if c in CLASS_SPRITE_IDS]

    # Cell size: male sprite + gap + female sprite (or placeholder) + label
    has_female = {c: c in CLASS_SPRITE_IDS_FEMALE for c in classes}
    cell_w = FRAME_SIZE * 2 + CELL_PAD * 3  # male + gap + female + padding
    cell_h = FRAME_SIZE + LABEL_HEIGHT + CELL_PAD * 2

    rows = (len(classes) + COLS - 1) // COLS
    img_w = COLS * cell_w + CELL_PAD
    img_h = rows * cell_h + CELL_PAD

    img = Image.new("RGBA", (img_w, img_h), BG_COLOR)
    draw = ImageDraw.Draw(img)
    font = try_get_font(12)

    for i, cls in enumerate(classes):
        col = i % COLS
        row = i // COLS
        x = col * cell_w + CELL_PAD
        y = row * cell_h + CELL_PAD

        # Draw class label
        label = cls.replace("_", " ").title()
        if has_female[cls]:
            label += " *"
        draw.text((x, y), label, fill=LABEL_COLOR, font=font)

        sprite_y = y + LABEL_HEIGHT

        # Male sprite
        male_id = CLASS_SPRITE_IDS[cls]
        male_frame = extract_south_idle_frame(male_id)
        if male_frame:
            img.paste(male_frame, (x, sprite_y), male_frame)
            # Blue border for male
            draw.rectangle(
                [x - 1, sprite_y - 1, x + FRAME_SIZE, sprite_y + FRAME_SIZE],
                outline=BORDER_MALE, width=1
            )

        # Female sprite (if exists)
        if has_female[cls]:
            fem_x = x + FRAME_SIZE + CELL_PAD
            fem_id = CLASS_SPRITE_IDS_FEMALE[cls]
            fem_frame = extract_south_idle_frame(fem_id)
            if fem_frame:
                img.paste(fem_frame, (fem_x, sprite_y), fem_frame)
                draw.rectangle(
                    [fem_x - 1, sprite_y - 1, fem_x + FRAME_SIZE, sprite_y + FRAME_SIZE],
                    outline=BORDER_FEMALE, width=1
                )

    img.save(output_path)
    print(f"Class contact sheet saved: {output_path}")
    print(f"  {len(classes)} classes, {sum(has_female.values())} with female variants")
    print(f"  Blue border = male, Pink border = female, * = has variant")


def make_enemy_contact_sheet(output_path: Path) -> None:
    """Generate contact sheet for all enemies."""
    enemies = sorted(ENEMY_SPRITE_IDS.keys())

    cell_w = FRAME_SIZE + CELL_PAD * 2
    cell_h = FRAME_SIZE + LABEL_HEIGHT + CELL_PAD * 2
    cols = 10

    rows = (len(enemies) + cols - 1) // cols
    img_w = cols * cell_w + CELL_PAD
    img_h = rows * cell_h + CELL_PAD

    img = Image.new("RGBA", (img_w, img_h), BG_COLOR)
    draw = ImageDraw.Draw(img)
    font = try_get_font(10)

    for i, enemy in enumerate(enemies):
        col = i % cols
        row = i // cols
        x = col * cell_w + CELL_PAD
        y = row * cell_h + CELL_PAD

        label = enemy.replace("_", " ")
        draw.text((x, y), label, fill=LABEL_COLOR, font=font)

        sprite_y = y + LABEL_HEIGHT
        sprite_id = ENEMY_SPRITE_IDS[enemy]
        frame = extract_south_idle_frame(sprite_id)
        if frame:
            img.paste(frame, (x, sprite_y), frame)
            draw.rectangle(
                [x - 1, sprite_y - 1, x + FRAME_SIZE, sprite_y + FRAME_SIZE],
                outline=BORDER_ENEMY, width=1
            )

    img.save(output_path)
    print(f"Enemy contact sheet saved: {output_path}")
    print(f"  {len(enemies)} enemies")


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate sprite contact sheets.")
    parser.add_argument("--enemies", action="store_true", help="Generate enemy sheet")
    parser.add_argument("--all", action="store_true", help="Generate both sheets")
    args = parser.parse_args()

    if args.all or not args.enemies:
        make_class_contact_sheet(PROJECT_DIR / "class_sprites.png")
    if args.all or args.enemies:
        make_enemy_contact_sheet(PROJECT_DIR / "enemy_sprites.png")


if __name__ == "__main__":
    main()
