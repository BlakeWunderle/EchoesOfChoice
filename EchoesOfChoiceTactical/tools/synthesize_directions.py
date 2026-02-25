#!/usr/bin/env python3
"""
Synthesize 3-direction sprite sheets from single-facing frame sequences.

Takes front-facing PNG frame sequences (Chibi, Tiny Fantasy, or 4-Direction
packs) and generates composite sheets with 3 rows:
  Row 0 (south/down) = original frames
  Row 1 (east/right) = original frames (reused for 3/4 view)
  Row 2 (north/up)   = darkened frames (40% brightness, slight desaturation)

West/left is handled at runtime by Unit.gd's flip_h mirroring.

Usage:
    # Single sprite from Chibi collection
    python tools/synthesize_directions.py \\
        --input assets/art/sprites/characters/chibi/dark_oracle/Dark_Oracle_1/PNG/PNG\\ Sequences \\
        --sprite-id chibi_dark_oracle_1 --collection chibi

    # Batch: process all variants in a pack
    python tools/synthesize_directions.py \\
        --batch assets/art/sprites/characters/chibi/dark_oracle \\
        --collection chibi

    # Process an existing 4-direction pack (extract front only)
    python tools/synthesize_directions.py \\
        --input assets/art/sprites/characters/bandit/Assassin/PNG/Spritesheets \\
        --sprite-id bandit_front_1 --collection 4dir
"""

import argparse
import sys
from pathlib import Path

from PIL import Image, ImageEnhance

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent
ASSETS_DIR = PROJECT_DIR / "assets" / "art" / "sprites"
OUTPUT_DIR = ASSETS_DIR / "processed"

TARGET_SIZE = 64
NORTH_BRIGHTNESS = 0.6  # 40% dimmer
NORTH_SATURATION = 0.8  # 20% less saturated
MAX_FRAMES = 12

# Animation name mapping per collection
ANIM_MAP: dict[str, dict[str, str]] = {
    "chibi": {
        "Idle": "idle",
        "Walking": "walk",
        "Running": "walk",
        "Slashing": "attack",
        "Kicking": "attack",
        "Throwing": "attack",
        "Attacking": "attack",
        "Hurt": "hurt",
        "Dying": "death",
    },
    "tiny": {
        "Idle": "idle",
        "Walking": "walk",
        "Attacking": "attack",
        "Casting Spells": "attack",
        "Hurt": "hurt",
        "Dying": "death",
        "Taunt": "idle",
    },
    "4dir": {
        # For 4-direction packs, we extract Front- prefixed spritesheets
    },
}

# Priority order: prefer these when multiple folders map to the same anim
ANIM_PRIORITY = {
    "idle": ["Idle"],
    "walk": ["Walking", "Running"],
    "attack": ["Slashing", "Attacking", "Kicking", "Throwing", "Casting Spells"],
    "hurt": ["Hurt"],
    "death": ["Dying"],
}

ANIM_ORDER = ["idle", "walk", "attack", "hurt", "death"]


def darken_frame(img: Image.Image) -> Image.Image:
    """Create a darkened/desaturated version for north-facing."""
    darkened = ImageEnhance.Brightness(img).enhance(NORTH_BRIGHTNESS)
    darkened = ImageEnhance.Color(darkened).enhance(NORTH_SATURATION)
    return darkened


def load_frames_from_sequence(seq_dir: Path, max_frames: int = MAX_FRAMES) -> list[Image.Image]:
    """Load individual PNG frames from a sequence directory."""
    frames = sorted(seq_dir.glob("*.png"))
    if not frames:
        return []
    images = []
    for f in frames[:max_frames]:
        images.append(Image.open(f).convert("RGBA"))
    return images


def load_frames_from_spritesheet(sheet_path: Path, frame_size: int,
                                  max_frames: int = MAX_FRAMES) -> list[Image.Image]:
    """Load frames from a spritesheet PNG (single row or grid)."""
    img = Image.open(sheet_path).convert("RGBA")
    cols = img.width // frame_size
    rows = img.height // frame_size
    frames = []
    for r in range(rows):
        for c in range(cols):
            if len(frames) >= max_frames:
                break
            x, y = c * frame_size, r * frame_size
            frame = img.crop((x, y, x + frame_size, y + frame_size))
            # Skip fully transparent frames
            if frame.getextrema()[3][1] > 0:
                frames.append(frame)
    return frames


def discover_sequence_anims(seq_root: Path, collection: str) -> dict[str, list[Image.Image]]:
    """Discover animations from PNG Sequences directory structure."""
    anim_map = ANIM_MAP.get(collection, {})
    if not anim_map:
        return {}

    # Map folder names to standard animation names
    found: dict[str, tuple[str, list[Image.Image]]] = {}  # std_anim -> (folder_name, frames)

    for folder in sorted(seq_root.iterdir()):
        if not folder.is_dir():
            continue
        folder_name = folder.name

        # Skip blinking/idle blink variants
        if "Blink" in folder_name:
            continue
        # Skip side-view-only animations
        skip_patterns = ["Jump", "Falling", "Sliding", "in The Air", "Run Slashing", "Run Throwing"]
        if any(pat in folder_name for pat in skip_patterns):
            continue

        std_anim = anim_map.get(folder_name)
        if not std_anim:
            continue

        frames = load_frames_from_sequence(folder)
        if not frames:
            continue

        # Use priority: prefer the first match in ANIM_PRIORITY
        if std_anim in found:
            # Check if this folder has higher priority
            priority_list = ANIM_PRIORITY.get(std_anim, [])
            existing_name = found[std_anim][0]
            try:
                existing_pri = priority_list.index(existing_name)
            except ValueError:
                existing_pri = 999
            try:
                new_pri = priority_list.index(folder_name)
            except ValueError:
                new_pri = 999
            if new_pri >= existing_pri:
                continue  # existing has equal or better priority

        found[std_anim] = (folder_name, frames)

    return {k: v[1] for k, v in found.items()}


def discover_4dir_front_anims(sheet_dir: Path) -> dict[str, list[Image.Image]]:
    """Extract front-facing frames from a 4-direction spritesheet pack."""
    from PIL import Image as PILImage

    # 4-direction packs have files like "Front - Idle.png", "Front - Walking.png"
    anim_4dir_map = {
        "Idle": "idle",
        "Walking": "walk",
        "Running": "walk",
        "Attacking": "attack",
        "Hurt": "hurt",
        "Dying": "death",
    }

    found: dict[str, list[Image.Image]] = {}
    frame_size = None

    # First detect frame size from PNG Sequences
    parent = sheet_dir.parent
    seq_dirs = sorted(parent.glob("PNG Sequences/*/"))
    for seq_dir in seq_dirs:
        frame_files = sorted(seq_dir.glob("*.png"))
        if frame_files:
            test = PILImage.open(frame_files[0])
            frame_size = test.width
            break

    if frame_size is None:
        frame_size = 480  # Default for CraftPix vector packs

    for png in sorted(sheet_dir.glob("*.png")):
        name = png.stem

        # Handle non-directional Dying
        if "Dying" in name and " - " not in name:
            frames = load_frames_from_spritesheet(png, frame_size)
            if frames:
                found["death"] = frames
            continue

        # Only extract Front- prefixed files
        if not name.startswith("Front"):
            continue

        parts = name.split(" - ", 1)
        if len(parts) != 2:
            continue

        anim_name = parts[1].strip()
        if "Blinking" in anim_name:
            continue

        std_anim = anim_4dir_map.get(anim_name)
        if not std_anim:
            continue

        if std_anim in found:
            continue  # Keep first match

        # Load only the first row (front direction) from the spritesheet
        img = PILImage.open(png).convert("RGBA")
        cols = img.width // frame_size
        frames = []
        for c in range(min(cols, MAX_FRAMES)):
            x = c * frame_size
            frame = img.crop((x, 0, x + frame_size, frame_size))
            if frame.getextrema()[3][1] > 0:
                frames.append(frame)

        if frames:
            found[std_anim] = frames

    return found


def synthesize_sprite(sprite_id: str, anims: dict[str, list[Image.Image]],
                      target_size: int = TARGET_SIZE) -> Path | None:
    """Generate 3-direction composite sheets from single-facing frames.

    Returns the output directory, or None on failure.
    """
    out_dir = OUTPUT_DIR / sprite_id
    out_dir.mkdir(parents=True, exist_ok=True)

    generated = False

    for anim_name in ANIM_ORDER:
        frames = anims.get(anim_name)
        if not frames:
            continue

        frame_count = min(len(frames), MAX_FRAMES)

        # Create composite: 3 rows (down/right/up), frame_count columns
        composite = Image.new("RGBA", (frame_count * target_size, 3 * target_size), (0, 0, 0, 0))

        for i in range(frame_count):
            frame = frames[i].resize((target_size, target_size), Image.LANCZOS)
            dark_frame = darken_frame(frame)

            # Row 0: south (down) = original
            composite.paste(frame, (i * target_size, 0 * target_size))
            # Row 1: east (right) = original (reused)
            composite.paste(frame, (i * target_size, 1 * target_size))
            # Row 2: north (up) = darkened
            composite.paste(dark_frame, (i * target_size, 2 * target_size))

        out_path = out_dir / f"{anim_name}.png"
        composite.save(out_path, "PNG")
        generated = True

    return out_dir if generated else None


def find_png_sequences(pack_dir: Path) -> list[tuple[str, Path]]:
    """Find all PNG Sequences directories in a pack, returning (variant_name, path) pairs."""
    results = []
    # Look for */PNG/PNG Sequences/ pattern
    for seq_dir in sorted(pack_dir.rglob("PNG Sequences")):
        if not seq_dir.is_dir():
            continue
        # Extract variant name from parent structure
        # e.g. Dark_Oracle_1/PNG/PNG Sequences -> Dark_Oracle_1
        rel = seq_dir.relative_to(pack_dir)
        parts = list(rel.parts)
        variant = parts[0] if parts else "default"
        results.append((variant, seq_dir))
    return results


def find_spritesheets(pack_dir: Path) -> list[tuple[str, Path]]:
    """Find all Spritesheets directories in a 4-direction pack."""
    results = []
    for sheet_dir in sorted(pack_dir.rglob("Spritesheets")):
        if not sheet_dir.is_dir():
            continue
        rel = sheet_dir.relative_to(pack_dir)
        parts = list(rel.parts)
        variant = parts[0] if parts else "default"
        results.append((variant, sheet_dir))
    return results


def make_sprite_id(base_name: str, variant: str) -> str:
    """Generate a clean sprite_id from pack name and variant."""
    # Clean up variant name: "Dark_Oracle_1" -> "dark_oracle_1"
    clean = variant.lower().replace(" ", "_").replace("-", "_")
    # Remove duplicate pack name from variant
    if clean.startswith(base_name.lower().replace("-", "_")):
        suffix = clean[len(base_name):]
        suffix = suffix.lstrip("_")
        if suffix:
            return f"{base_name}_{suffix}"
    return f"{base_name}_{clean}"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Synthesize 3-direction sprites from single-facing frame sequences.")
    parser.add_argument("--input", type=Path,
                        help="Path to PNG Sequences directory (single sprite mode)")
    parser.add_argument("--batch", type=Path,
                        help="Path to pack directory (batch mode - process all variants)")
    parser.add_argument("--sprite-id", type=str,
                        help="Sprite ID for output (single mode only)")
    parser.add_argument("--collection", type=str, default="chibi",
                        choices=["chibi", "tiny", "4dir"],
                        help="Collection type for animation mapping")
    parser.add_argument("--target-size", type=int, default=TARGET_SIZE,
                        help="Target frame size in pixels (default: 64)")
    parser.add_argument("--dry-run", action="store_true",
                        help="Print what would be generated")
    args = parser.parse_args()

    if not args.input and not args.batch:
        parser.error("Either --input or --batch is required")

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    success = 0
    failed = 0

    if args.input:
        # Single sprite mode
        sprite_id = args.sprite_id
        if not sprite_id:
            parser.error("--sprite-id is required in single mode")

        if not args.input.is_dir():
            print(f"ERROR: Input directory not found: {args.input}")
            sys.exit(1)

        if args.collection == "4dir":
            anims = discover_4dir_front_anims(args.input)
        else:
            anims = discover_sequence_anims(args.input, args.collection)

        if not anims:
            print(f"ERROR: No animations found in {args.input}")
            sys.exit(1)

        if args.dry_run:
            print(f"[DRY] {sprite_id}: {', '.join(sorted(anims.keys()))}")
        else:
            out = synthesize_sprite(sprite_id, anims, args.target_size)
            if out:
                print(f"OK  {sprite_id}: {', '.join(sorted(anims.keys()))} -> {out}")
                success += 1
            else:
                print(f"FAIL {sprite_id}")
                failed += 1

    elif args.batch:
        # Batch mode: find all variants in the pack directory
        if not args.batch.is_dir():
            print(f"ERROR: Batch directory not found: {args.batch}")
            sys.exit(1)

        pack_name = args.batch.name

        if args.collection == "4dir":
            variants = find_spritesheets(args.batch)
        else:
            variants = find_png_sequences(args.batch)

        if not variants:
            print(f"No variants found in {args.batch}")
            sys.exit(1)

        print(f"Found {len(variants)} variant(s) in {pack_name}")

        for variant_name, variant_path in variants:
            sprite_id = make_sprite_id(pack_name, variant_name)

            if args.collection == "4dir":
                anims = discover_4dir_front_anims(variant_path)
            else:
                anims = discover_sequence_anims(variant_path, args.collection)

            if not anims:
                print(f"  SKIP {sprite_id}: no animations found")
                continue

            if args.dry_run:
                print(f"  [DRY] {sprite_id}: {', '.join(sorted(anims.keys()))}")
                success += 1
            else:
                out = synthesize_sprite(sprite_id, anims, args.target_size)
                if out:
                    print(f"  OK   {sprite_id}: {', '.join(sorted(anims.keys()))}")
                    success += 1
                else:
                    print(f"  FAIL {sprite_id}")
                    failed += 1

    print()
    print(f"Done: {success} generated, {failed} failed")


if __name__ == "__main__":
    main()
