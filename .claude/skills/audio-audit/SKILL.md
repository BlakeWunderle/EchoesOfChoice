---
name: audio-audit
description: Audit audio files for orphans and missing references. Use after adding/removing music or SFX, changing battle configs, or modifying scene music assignments. Checks that every audio file is referenced and every reference points to an existing file.
---

# Audio Audit

Validates that the project's audio files and code references are in sync. Catches orphan files (wasting space) and missing references (causing silent scenes).

## Audit Procedure

### Step 1: Collect all music references from code

Search all `.gd` files for audio path references:

```bash
cd c:/Projects/EchoesOfChoice
# Music paths in code (play_music calls + music_track assignments)
grep -roh 'res://assets/audio/music/[^"]*' EchoesOfChoiceTactical/scripts/ EchoesOfChoiceTactical/scenes/ | sort -u
```

### Step 2: Collect all music files on disk

```bash
find EchoesOfChoiceTactical/assets/audio/music/ -type f \( -name "*.wav" -o -name "*.ogg" -o -name "*.mp3" \) | sort
```

### Step 3: Cross-reference music

For each file on disk, verify it appears in the code references list. Report:
- **ORPHAN**: File exists on disk but no code references it → should be deleted or moved to `assets_library/`
- **MISSING**: Code references a path but no file exists → track must be copied from `assets_library/` or the reference is wrong

### Step 4: Validate SFX category folders

Read `SFXManager.CATEGORY_FOLDERS` from `scripts/autoload/sfx_manager.gd`. For each folder path listed:
- Verify the folder exists under `assets/audio/sfx/`
- Verify it contains at least one audio file

Then list all subfolders under `assets/audio/sfx/combat/` and `assets/audio/sfx/ranged/` and check each is mapped in `CATEGORY_FOLDERS`. Report unmapped folders.

### Step 5: Check SFX category usage

For each `Category.X` enum value in sfx_manager.gd, search all `.gd` files for references to `Category.X`, `SFXManager.play(SFXManager.Category.X`, or indirect usage via `play_ability_sfx`/`_resolve_magic_sfx`. Report any categories that are defined but never used.

### Step 6: Report

Output a summary table:

```
MUSIC AUDIT
  Referenced tracks: N
  Files on disk: M
  Orphans: [list]
  Missing: [list]

SFX AUDIT
  Mapped folders: N (all exist: YES/NO)
  Unmapped subfolders: [list]
  Unused categories: [list]

RESULT: PASS / FAIL (N issues)
```

## Fix Actions

- **Orphan music**: `rm "EchoesOfChoiceTactical/assets/audio/music/<path>"` and its `.import` file
- **Missing music**: Copy from `assets_library/music/` or fix the code reference
- **Unmapped SFX folder**: Delete the folder or add it to `CATEGORY_FOLDERS`
- **Unused SFX category**: Remove from the `Category` enum and `CATEGORY_FOLDERS`

## Key Files

- Music paths defined in: `scripts/data/battle_config_prog_*.gd`, `scripts/data/battle_config.gd`, all scene `.gd` files, `scenes/town/Town.gd`
- Music manager: `scripts/autoload/music_manager.gd`
- SFX manager: `scripts/autoload/sfx_manager.gd`
- Asset library backup: `c:\Projects\EchoesOfChoice\assets_library\music\`

## Related

- **asset-audit** skill — broader asset organization (sprites, tilesets, .gdignore)
- **orphan-check** skill — unused .tres/.tscn resources
- `.claude/rules/audio-management.md` — the policy this audit enforces
