---
name: asset-audit
description: Verify asset organization, check for missing references, manage music curation, and place .gdignore files. Use after downloading new asset packs, adding sprites, before export, or when managing which music tracks are included.
---

# Asset Audit & Management

Manages the split between the Godot project (`EchoesOfChoiceTactical/assets/`) and the asset library (`assets_library/`). Verifies no referenced assets are missing, manages music track selection, and maintains `.gdignore` exclusions.

## Architecture

Assets are organized into three tiers:

| Location | Purpose | Size |
|----------|---------|------|
| `EchoesOfChoiceTactical/assets/` | Runtime assets (sprites, music, tilesets, audio) | ~2-3 GB |
| `assets_library/` | Source packs + excess music (not in Godot project) | ~20 GB |
| `.gdignore`'d dirs | Downloaded but unused art packs (excluded from import/export) | ~900 MB |

### What lives where

- **Sprite source packs** (`assets_library/sprites/`): Raw CraftPix downloads. Python tools read from here and write processed outputs + SpriteFrames into the Godot project.
- **Excess music** (`assets_library/music/`): Tracks not selected by the music curation system. Managed by `MUSIC_MANIFEST.json`.
- **Active music** (`assets/audio/music/{context}/`): 5 tracks per context, selected by `curate_music.py`.
- **Unused art packs** (`.gdignore`'d): Downloaded tilesets, GUI art, icons, objects with zero runtime references.

## Tools

### Asset Audit (`tools/asset_audit.py`)

```bash
# Full audit: check references + report sizes
python EchoesOfChoiceTactical/tools/asset_audit.py

# Place .gdignore files in unused directories
python EchoesOfChoiceTactical/tools/asset_audit.py --fix

# Size report only
python EchoesOfChoiceTactical/tools/asset_audit.py --sizes
```

The audit checks:
1. All `res://assets/` paths in `.gd`/`.tres`/`.tscn` files exist on disk or in the library
2. No referenced path is inside a `.gdignore`'d directory
3. Reports project size, library size, and excluded size

### Music Curation (`tools/curate_music.py`)

```bash
# Initial curation — select 5 tracks per context, move rest to library
python EchoesOfChoiceTactical/tools/curate_music.py

# Change tracks per context
python EchoesOfChoiceTactical/tools/curate_music.py --per-context 10

# Sync from existing manifest (restore selections after fresh clone)
python EchoesOfChoiceTactical/tools/curate_music.py --sync

# List current track selections and check for missing files
python EchoesOfChoiceTactical/tools/curate_music.py --list
```

Music contexts: `battle`, `battle_dark`, `battle_scifi`, `boss`, `cutscene`, `exploration`, `menu`, `town`

The manifest at `assets/audio/music/MUSIC_MANIFEST.json` is tracked in git and is the source of truth for which tracks are active.

## Workflows

### After downloading new asset packs

1. Downloads go to `assets_library/` (configured in `tools/download_craftpix.py`)
2. Run sprite generation tools which read from `assets_library/sprites/` and write to the Godot project
3. Run `python EchoesOfChoiceTactical/tools/asset_audit.py` to verify

### Swapping music tracks

1. Edit `assets/audio/music/MUSIC_MANIFEST.json` — replace a track name with one from `assets_library/music/{context}/`
2. Run `python EchoesOfChoiceTactical/tools/curate_music.py --sync` to move files accordingly
3. Commit the updated manifest

### Before export

1. Run `python EchoesOfChoiceTactical/tools/asset_audit.py` — should pass with 0 warnings
2. Run `python EchoesOfChoiceTactical/tools/asset_audit.py --fix` to ensure all `.gdignore` files are placed
3. Build: `"C:/Users/blake/AppData/Local/Microsoft/WinGet/Packages/GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe/Godot_v4.6.1-stable_win64_console.exe" --path EchoesOfChoiceTactical --headless --quit`

### After fresh clone / new machine

1. Download asset packs (or copy `assets_library/` from backup)
2. Run `python EchoesOfChoiceTactical/tools/curate_music.py --sync` to restore music selections
3. Run `python EchoesOfChoiceTactical/tools/asset_audit.py --fix` to place `.gdignore` files

## .gdignore Managed Directories

These directories contain downloaded asset packs with zero runtime references:

| Directory | Content |
|-----------|---------|
| `assets/art/tilesets/battle/dungeon_free/` | Unused tileset |
| `assets/art/tilesets/battle/dungeon_roguelike/` | Unused tileset |
| `assets/art/tilesets/battle/farm/` | Unused tileset |
| `assets/art/tilesets/battle/flying_islands/` | Unused tileset |
| `assets/art/tilesets/battle/seabed/` | Unused tileset |
| `assets/art/tilesets/battle/tavern/` | Unused tileset |
| `assets/art/tilesets/battle/training_arena/` | Unused tileset |
| `assets/art/tilesets/battle/winter/` | Unused tileset |
| `assets/art/tilesets/buildings/` | Unused tileset |
| `assets/art/gui/` | Downloaded GUI art pack |
| `assets/art/icons/` | Downloaded icon pack |
| `assets/art/objects/` | Downloaded objects pack |
| `assets/art/ui/Sprites/` | Downloaded UI sprites |

To add a new exclusion, add the path to `GDIGNORE_DIRS` in `tools/asset_audit.py` and run `--fix`.

## Related Skills

- **sprite-reference** — regenerate sprite reference docs after sprite changes
- **orphan-check** — detect unused `.tres`/`.tscn` resources
- **update-architecture** — update architecture doc after structural changes
