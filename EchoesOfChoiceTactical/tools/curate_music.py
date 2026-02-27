#!/usr/bin/env python3
"""
Curate music tracks for the Godot project.

Selects a configured number of tracks per context and moves the rest
to assets_library/music/ so Godot doesn't bundle unused music.

Usage:
    # Initial curation — select 5 per context, move rest to library
    python tools/curate_music.py

    # Sync from existing manifest (restore/update selections)
    python tools/curate_music.py --sync

    # Change tracks per context
    python tools/curate_music.py --per-context 10

    # List current selections
    python tools/curate_music.py --list
"""

import argparse
import json
import os
import shutil
import sys
from pathlib import Path

if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent
MUSIC_DIR = PROJECT_DIR / "assets" / "audio" / "music"
LIBRARY_DIR = PROJECT_DIR.parent / "assets_library" / "music"
MANIFEST_PATH = MUSIC_DIR / "MUSIC_MANIFEST.json"

AUDIO_EXTS = {".wav", ".ogg", ".mp3"}

CONTEXTS = [
    "battle", "battle_dark", "battle_scifi", "boss",
    "cutscene", "exploration", "menu", "town",
]


def list_tracks(folder: Path) -> list[str]:
    """List audio file names in a folder."""
    if not folder.is_dir():
        return []
    return sorted(
        f.name for f in folder.iterdir()
        if f.is_file() and f.suffix.lower() in AUDIO_EXTS
    )


def select_tracks(tracks: list[str], count: int) -> list[str]:
    """Select tracks with variety in file size (mix of short and long pieces).

    Sorts by name and picks evenly spaced entries to get variety.
    """
    if len(tracks) <= count:
        return tracks
    step = len(tracks) / count
    return [tracks[int(i * step)] for i in range(count)]


def load_manifest() -> dict:
    """Load existing manifest or return empty dict."""
    if MANIFEST_PATH.is_file():
        with open(MANIFEST_PATH, "r") as f:
            return json.load(f)
    return {}


def save_manifest(manifest: dict) -> None:
    """Save manifest to disk."""
    MANIFEST_PATH.parent.mkdir(parents=True, exist_ok=True)
    with open(MANIFEST_PATH, "w") as f:
        json.dump(manifest, f, indent=2, sort_keys=True)
    print(f"Manifest saved: {MANIFEST_PATH}")


def curate(per_context: int = 5) -> None:
    """Select tracks per context, move unselected to library."""
    manifest = {}

    for ctx in CONTEXTS:
        project_folder = MUSIC_DIR / ctx
        library_folder = LIBRARY_DIR / ctx
        library_folder.mkdir(parents=True, exist_ok=True)

        # Gather all tracks from both locations
        project_tracks = list_tracks(project_folder)
        library_tracks = list_tracks(library_folder)
        all_tracks = sorted(set(project_tracks + library_tracks))

        if not all_tracks:
            print(f"  {ctx}: no tracks found")
            continue

        selected = select_tracks(all_tracks, per_context)
        manifest[ctx] = selected

        # Move unselected from project to library
        moved_out = 0
        for name in project_tracks:
            if name not in selected:
                src = project_folder / name
                dst = library_folder / name
                shutil.move(str(src), str(dst))
                moved_out += 1

        # Move selected from library to project (if they were there)
        moved_in = 0
        for name in selected:
            if name in library_tracks and name not in project_tracks:
                src = library_folder / name
                dst = project_folder / name
                shutil.move(str(src), str(dst))
                moved_in += 1

        kept = len(selected)
        total = len(all_tracks)
        print(f"  {ctx}: {kept}/{total} selected, {moved_out} moved to library, {moved_in} restored")

    save_manifest(manifest)


def sync_from_manifest() -> None:
    """Sync files between project and library based on existing manifest."""
    manifest = load_manifest()
    if not manifest:
        print("No manifest found. Run without --sync first.")
        return

    for ctx in CONTEXTS:
        selected = set(manifest.get(ctx, []))
        project_folder = MUSIC_DIR / ctx
        library_folder = LIBRARY_DIR / ctx
        library_folder.mkdir(parents=True, exist_ok=True)

        # Move unselected out of project
        for name in list_tracks(project_folder):
            if name not in selected:
                shutil.move(str(project_folder / name), str(library_folder / name))

        # Move selected into project
        for name in list_tracks(library_folder):
            if name in selected:
                shutil.move(str(library_folder / name), str(project_folder / name))

        in_project = len(list_tracks(project_folder))
        print(f"  {ctx}: {in_project} tracks in project")

    print("Sync complete.")


def list_selections() -> None:
    """Print current manifest selections."""
    manifest = load_manifest()
    if not manifest:
        print("No manifest found.")
        return

    for ctx in CONTEXTS:
        tracks = manifest.get(ctx, [])
        print(f"\n{ctx} ({len(tracks)} tracks):")
        for t in tracks:
            in_project = (MUSIC_DIR / ctx / t).is_file()
            status = "OK" if in_project else "MISSING"
            print(f"  [{status}] {t}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Curate music tracks for export")
    parser.add_argument("--per-context", type=int, default=5,
                        help="Number of tracks to keep per context (default: 5)")
    parser.add_argument("--sync", action="store_true",
                        help="Sync files from existing manifest")
    parser.add_argument("--list", action="store_true",
                        help="List current selections")
    args = parser.parse_args()

    if args.list:
        list_selections()
    elif args.sync:
        sync_from_manifest()
    else:
        print(f"Curating {args.per_context} tracks per context...")
        curate(args.per_context)


if __name__ == "__main__":
    main()
