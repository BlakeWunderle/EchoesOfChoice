#!/usr/bin/env python3
"""
Palette swap tool for creating recolored sprite variants.

Usage:

  Single recolor (hue shift):
    python palette_swap.py --input sprite.png --output recolored.png \
        --from-hue 270 --to-hue 0

  Batch recolor from a config file:
    python palette_swap.py --batch recolors.json

  Preview hue distribution of a sprite:
    python palette_swap.py --analyze sprite.png

Hue values are 0-360 (red=0, yellow=60, green=120, cyan=180, blue=240, purple=300).
Supports PNG sprite sheets with transparency.
"""

import argparse
import json
import sys
from pathlib import Path

from PIL import Image

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent
ASSETS_DIR = PROJECT_DIR / "assets" / "art"


def rgb_to_hsl(r: int, g: int, b: int) -> tuple[float, float, float]:
    """Convert RGB (0-255) to HSL (0-360, 0-1, 0-1)."""
    r_f, g_f, b_f = r / 255.0, g / 255.0, b / 255.0
    max_c = max(r_f, g_f, b_f)
    min_c = min(r_f, g_f, b_f)
    diff = max_c - min_c
    l = (max_c + min_c) / 2.0

    if diff == 0:
        return (0.0, 0.0, l)

    s = diff / (1.0 - abs(2.0 * l - 1.0)) if l != 0 and l != 1 else 0.0

    if max_c == r_f:
        h = 60.0 * (((g_f - b_f) / diff) % 6)
    elif max_c == g_f:
        h = 60.0 * (((b_f - r_f) / diff) + 2)
    else:
        h = 60.0 * (((r_f - g_f) / diff) + 4)

    if h < 0:
        h += 360.0

    return (h, s, l)


def hsl_to_rgb(h: float, s: float, l: float) -> tuple[int, int, int]:
    """Convert HSL (0-360, 0-1, 0-1) to RGB (0-255)."""
    if s == 0:
        v = int(round(l * 255))
        return (v, v, v)

    c = (1.0 - abs(2.0 * l - 1.0)) * s
    h_prime = h / 60.0
    x = c * (1.0 - abs(h_prime % 2 - 1.0))
    m = l - c / 2.0

    if h_prime < 1:
        r1, g1, b1 = c, x, 0.0
    elif h_prime < 2:
        r1, g1, b1 = x, c, 0.0
    elif h_prime < 3:
        r1, g1, b1 = 0.0, c, x
    elif h_prime < 4:
        r1, g1, b1 = 0.0, x, c
    elif h_prime < 5:
        r1, g1, b1 = x, 0.0, c
    else:
        r1, g1, b1 = c, 0.0, x

    return (
        int(round((r1 + m) * 255)),
        int(round((g1 + m) * 255)),
        int(round((b1 + m) * 255)),
    )


def hue_shift_pixel(r: int, g: int, b: int,
                     from_hue: float, to_hue: float,
                     hue_tolerance: float = 60.0,
                     sat_min: float = 0.15,
                     lightness_shift: float = 0.0,
                     saturation_shift: float = 0.0) -> tuple[int, int, int]:
    """Shift the hue of a pixel if it's within tolerance of from_hue.

    Args:
        r, g, b: Input pixel RGB (0-255).
        from_hue: Source hue to match (0-360).
        to_hue: Target hue to shift to (0-360).
        hue_tolerance: How far from from_hue to still affect (degrees).
        sat_min: Minimum saturation to affect (skip grays).
        lightness_shift: Additional lightness adjustment (-1 to 1).
        saturation_shift: Additional saturation adjustment (-1 to 1).

    Returns:
        New RGB tuple.
    """
    h, s, l = rgb_to_hsl(r, g, b)

    # Skip near-gray pixels (low saturation)
    if s < sat_min:
        return (r, g, b)

    # Calculate hue distance (circular)
    hue_diff = h - from_hue
    if hue_diff > 180:
        hue_diff -= 360
    elif hue_diff < -180:
        hue_diff += 360

    if abs(hue_diff) > hue_tolerance:
        return (r, g, b)

    # Apply shift: preserve the relative hue offset from from_hue
    new_h = (to_hue + hue_diff) % 360

    new_s = max(0.0, min(1.0, s + saturation_shift))
    new_l = max(0.0, min(1.0, l + lightness_shift))

    return hsl_to_rgb(new_h, new_s, new_l)


def recolor_image(img: Image.Image,
                  from_hue: float, to_hue: float,
                  hue_tolerance: float = 60.0,
                  sat_min: float = 0.15,
                  lightness_shift: float = 0.0,
                  saturation_shift: float = 0.0) -> Image.Image:
    """Create a recolored copy of a sprite sheet image."""
    img = img.convert("RGBA")
    pixels = img.load()
    w, h = img.size
    out = Image.new("RGBA", (w, h))
    out_pixels = out.load()

    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if a == 0:
                out_pixels[x, y] = (0, 0, 0, 0)
                continue
            nr, ng, nb = hue_shift_pixel(
                r, g, b, from_hue, to_hue,
                hue_tolerance, sat_min,
                lightness_shift, saturation_shift
            )
            out_pixels[x, y] = (nr, ng, nb, a)

    return out


def analyze_hues(img: Image.Image) -> dict[int, int]:
    """Analyze the hue distribution of non-transparent, non-gray pixels."""
    img = img.convert("RGBA")
    pixels = img.load()
    w, h = img.size
    hue_counts: dict[int, int] = {}

    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if a < 128:
                continue
            hue, sat, _ = rgb_to_hsl(r, g, b)
            if sat < 0.15:
                continue
            bucket = int(hue / 10) * 10  # 10-degree buckets
            hue_counts[bucket] = hue_counts.get(bucket, 0) + 1

    return dict(sorted(hue_counts.items()))


def print_hue_analysis(filepath: Path) -> None:
    """Print a visual hue distribution chart."""
    img = Image.open(filepath)
    hue_counts = analyze_hues(img)

    if not hue_counts:
        print(f"No colored pixels found in {filepath}")
        return

    total = sum(hue_counts.values())
    max_count = max(hue_counts.values())
    bar_width = 40

    hue_names = {
        0: "red", 30: "orange", 60: "yellow", 90: "chartreuse",
        120: "green", 150: "spring", 180: "cyan", 210: "azure",
        240: "blue", 270: "violet", 300: "magenta", 330: "rose",
    }

    print(f"Hue distribution for: {filepath}")
    print(f"Total colored pixels: {total}")
    print()

    for hue_bucket, count in hue_counts.items():
        bar_len = int(count / max_count * bar_width)
        pct = count / total * 100
        name = hue_names.get(hue_bucket, "")
        bar = "#" * bar_len
        print(f"  {hue_bucket:>3}° {bar:<{bar_width}} {pct:5.1f}%  {name}")

    # Suggest dominant hue
    dominant = max(hue_counts, key=hue_counts.get)  # type: ignore[arg-type]
    print(f"\nDominant hue: ~{dominant}° (use as --from-hue)")


def run_batch(config_path: Path) -> None:
    """Run batch recolors from a JSON config file.

    Config format:
    {
        "jobs": [
            {
                "input": "sprites/characters/mage/mage_sheet.png",
                "output": "sprites/characters/mage/pyromancer_sheet.png",
                "from_hue": 270,
                "to_hue": 0,
                "hue_tolerance": 60,
                "lightness_shift": 0,
                "saturation_shift": 0
            }
        ]
    }

    Paths are relative to assets/art/.
    """
    with open(config_path) as f:
        config = json.load(f)

    jobs = config.get("jobs", [])
    print(f"Running {len(jobs)} recolor job(s)...")

    for i, job in enumerate(jobs, 1):
        input_path = ASSETS_DIR / job["input"]
        output_path = ASSETS_DIR / job["output"]

        if not input_path.exists():
            print(f"  [{i}/{len(jobs)}] SKIP: {input_path} not found")
            continue

        print(f"  [{i}/{len(jobs)}] {job['input']} -> {job['output']}")

        img = Image.open(input_path)
        result = recolor_image(
            img,
            from_hue=job["from_hue"],
            to_hue=job["to_hue"],
            hue_tolerance=job.get("hue_tolerance", 60.0),
            sat_min=job.get("sat_min", 0.15),
            lightness_shift=job.get("lightness_shift", 0.0),
            saturation_shift=job.get("saturation_shift", 0.0),
        )

        output_path.parent.mkdir(parents=True, exist_ok=True)
        result.save(output_path)
        print(f"    Saved ({result.size[0]}x{result.size[1]})")

    print(f"\nDone! {len(jobs)} job(s) processed.")


def main() -> None:
    parser = argparse.ArgumentParser(description="Palette swap tool for pixel art sprites.")
    parser.add_argument("--input", type=Path, help="Input sprite sheet PNG")
    parser.add_argument("--output", type=Path, help="Output recolored PNG")
    parser.add_argument("--from-hue", type=float, help="Source hue (0-360)")
    parser.add_argument("--to-hue", type=float, help="Target hue (0-360)")
    parser.add_argument("--hue-tolerance", type=float, default=60.0,
                        help="Hue matching tolerance in degrees (default: 60)")
    parser.add_argument("--sat-min", type=float, default=0.15,
                        help="Minimum saturation to recolor (default: 0.15)")
    parser.add_argument("--lightness-shift", type=float, default=0.0,
                        help="Lightness adjustment (-1 to 1)")
    parser.add_argument("--saturation-shift", type=float, default=0.0,
                        help="Saturation adjustment (-1 to 1)")
    parser.add_argument("--analyze", type=Path, help="Analyze hue distribution of a sprite")
    parser.add_argument("--batch", type=Path, help="Run batch recolors from JSON config")
    args = parser.parse_args()

    if args.analyze:
        print_hue_analysis(args.analyze)
    elif args.batch:
        run_batch(args.batch)
    elif args.input and args.output and args.from_hue is not None and args.to_hue is not None:
        print(f"Recoloring: {args.input} -> {args.output}")
        print(f"  Hue shift: {args.from_hue}° -> {args.to_hue}°")

        img = Image.open(args.input)
        result = recolor_image(
            img,
            from_hue=args.from_hue,
            to_hue=args.to_hue,
            hue_tolerance=args.hue_tolerance,
            sat_min=args.sat_min,
            lightness_shift=args.lightness_shift,
            saturation_shift=args.saturation_shift,
        )

        args.output.parent.mkdir(parents=True, exist_ok=True)
        result.save(args.output)
        print(f"  Saved: {args.output} ({result.size[0]}x{result.size[1]})")
    else:
        parser.print_help()
        print()
        print("Examples:")
        print('  python palette_swap.py --analyze sprite.png')
        print('  python palette_swap.py --input sprite.png --output recolored.png '
              '--from-hue 270 --to-hue 0')
        print('  python palette_swap.py --batch recolors.json')


if __name__ == "__main__":
    main()
