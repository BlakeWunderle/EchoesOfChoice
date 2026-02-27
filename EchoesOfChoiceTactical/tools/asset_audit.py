#!/usr/bin/env python3
"""
Asset audit tool for EchoesOfChoiceTactical.

Verifies asset organization:
1. All res://assets/ paths referenced in code exist on disk
2. No referenced path lives inside a .gdignore'd directory
3. Reports project asset size, library size, and excluded size
4. Lists unreferenced directories that could be cleaned up
5. Can place .gdignore files in known-unused directories

Usage:
    python tools/asset_audit.py           # Full audit
    python tools/asset_audit.py --fix     # Audit + place .gdignore files
    python tools/asset_audit.py --sizes   # Just report sizes
"""

import argparse
import os
import re
import sys
from pathlib import Path

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent
REPO_DIR = PROJECT_DIR.parent
LIBRARY_DIR = REPO_DIR / "assets_library"
ASSETS_DIR = PROJECT_DIR / "assets"

CODE_EXTS = {".gd", ".tres", ".tscn"}

# Directories that are confirmed unused by runtime code.
# .gdignore prevents Godot from importing/exporting their contents.
GDIGNORE_DIRS = [
    "assets/art/tilesets/battle/dungeon_free",
    "assets/art/tilesets/battle/dungeon_roguelike",
    "assets/art/tilesets/battle/farm",
    "assets/art/tilesets/battle/flying_islands",
    "assets/art/tilesets/battle/seabed",
    "assets/art/tilesets/battle/tavern",
    "assets/art/tilesets/battle/training_arena",
    "assets/art/tilesets/battle/winter",
    "assets/art/tilesets/buildings",
    "assets/art/gui",
    "assets/art/icons",
    "assets/art/objects",
    "assets/art/ui/Sprites",
]


def dir_size_mb(path: Path) -> float:
    """Get total size of a directory in MB."""
    total = 0
    if not path.is_dir():
        return 0.0
    for f in path.rglob("*"):
        if f.is_file():
            total += f.stat().st_size
    return total / (1024 * 1024)


def find_gdignore_dirs() -> set[Path]:
    """Find all directories containing .gdignore files (excluding .godot/)."""
    ignored = set()
    for gi in PROJECT_DIR.rglob(".gdignore"):
        parent = gi.parent
        # Skip .godot/ (Godot's internal cache, not our managed exclusions)
        if ".godot" in parent.parts:
            continue
        ignored.add(parent)
    return ignored


def is_under_gdignore(filepath: Path, ignored_dirs: set[Path]) -> bool:
    """Check if a file path is under a .gdignore'd directory."""
    for d in ignored_dirs:
        try:
            filepath.relative_to(d)
            return True
        except ValueError:
            continue
    return False


def find_asset_references() -> set[str]:
    """Scan all .gd/.tres/.tscn files for res://assets/ path references."""
    pattern = re.compile(r'res://assets/[^\s"\')\]]+')
    refs = set()
    for ext in CODE_EXTS:
        for f in PROJECT_DIR.rglob(f"*{ext}"):
            # Skip .godot directory
            if ".godot" in f.parts:
                continue
            try:
                text = f.read_text(encoding="utf-8", errors="replace")
            except OSError:
                continue
            for match in pattern.finditer(text):
                refs.add(match.group())
    return refs


def res_to_disk(res_path: str) -> Path:
    """Convert res:// path to disk path."""
    return PROJECT_DIR / res_path.removeprefix("res://")


def res_to_library(res_path: str) -> Path:
    """Check if a res:// asset path exists in assets_library/."""
    # Map res://assets/art/sprites/{characters,enemies,npcs,animals}/...
    # to assets_library/sprites/{characters,enemies,npcs,animals}/...
    rel = res_path.removeprefix("res://assets/art/sprites/")
    if rel != res_path.removeprefix("res://"):
        candidate = LIBRARY_DIR / "sprites" / rel
        if candidate.exists():
            return candidate
    return Path()  # non-existent


def audit_references(ignored_dirs: set[Path]) -> list[str]:
    """Check that all referenced asset paths exist and aren't gdignored."""
    warnings = []
    refs = find_asset_references()

    # Filter out format strings (e.g. %s.tres) and other non-literal paths
    literal_refs = {r for r in refs if "%" not in r}
    skipped = len(refs) - len(literal_refs)

    print(f"\nFound {len(refs)} unique res://assets/ references in code", end="")
    if skipped:
        print(f" ({skipped} format strings skipped)", end="")
    print(".\n")

    missing = []
    in_library = []
    gdignored = []
    ok = 0

    for ref in sorted(literal_refs):
        disk_path = res_to_disk(ref)
        if disk_path.exists():
            if is_under_gdignore(disk_path, ignored_dirs):
                gdignored.append(ref)
            else:
                ok += 1
        elif res_to_library(ref).exists():
            in_library.append(ref)
        else:
            missing.append(ref)

    print(f"  {ok} references OK (exist in project)")

    if in_library:
        print(f"  {len(in_library)} references point to assets moved to library (expected)")

    if missing:
        warnings.append(f"{len(missing)} referenced assets MISSING from disk and library")
        print(f"\n  MISSING ({len(missing)}):")
        for r in missing:
            print(f"    {r}")
    else:
        print(f"  0 truly missing references.")

    if gdignored:
        warnings.append(f"{len(gdignored)} referenced assets inside .gdignore'd dirs")
        print(f"\n  GDIGNORED (referenced but excluded!) ({len(gdignored)}):")
        for r in gdignored:
            print(f"    {r}")
    else:
        print("  No referenced assets are inside .gdignore'd directories.")

    return warnings


def report_sizes() -> None:
    """Report size breakdown."""
    print("\n=== Size Report ===\n")

    # Project assets
    project_size = dir_size_mb(ASSETS_DIR)
    print(f"Project assets (assets/):        {project_size:>8.1f} MB")

    # Library
    library_size = dir_size_mb(LIBRARY_DIR)
    print(f"Asset library (assets_library/): {library_size:>8.1f} MB")

    # Gdignored
    ignored_dirs = find_gdignore_dirs()
    ignored_size = 0.0
    for d in ignored_dirs:
        ignored_size += dir_size_mb(d)
    print(f"Excluded by .gdignore:           {ignored_size:>8.1f} MB")

    # Effective project size
    effective = project_size - ignored_size
    print(f"Effective project assets:         {effective:>8.1f} MB")
    print(f"Total (all locations):           {project_size + library_size:>8.1f} MB")


def place_gdignore(dry_run: bool = False) -> int:
    """Place .gdignore files in known-unused directories."""
    placed = 0
    for rel in GDIGNORE_DIRS:
        d = PROJECT_DIR / rel
        gi = d / ".gdignore"
        if not d.is_dir():
            continue
        if gi.exists():
            continue
        if dry_run:
            print(f"  Would create: {rel}/.gdignore")
        else:
            gi.touch()
            print(f"  Created: {rel}/.gdignore")
        placed += 1
    return placed


def main() -> None:
    parser = argparse.ArgumentParser(description="Audit asset organization")
    parser.add_argument("--fix", action="store_true",
                        help="Place .gdignore files in unused directories")
    parser.add_argument("--sizes", action="store_true",
                        help="Only report sizes, skip reference audit")
    args = parser.parse_args()

    print("=== Asset Audit ===")

    if args.fix:
        print("\nPlacing .gdignore files...")
        placed = place_gdignore()
        if placed == 0:
            print("  All .gdignore files already in place.")
        else:
            print(f"  Placed {placed} .gdignore files.")

    ignored_dirs = find_gdignore_dirs()
    if ignored_dirs:
        print(f"\n{len(ignored_dirs)} directories excluded by .gdignore")

    if not args.sizes:
        warnings = audit_references(ignored_dirs)

    report_sizes()

    if not args.sizes and warnings:
        print(f"\n{'='*40}")
        print(f"WARNINGS: {len(warnings)}")
        for w in warnings:
            print(f"  - {w}")
        sys.exit(1)
    else:
        print("\nAudit passed.")


if __name__ == "__main__":
    main()
