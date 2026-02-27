# Audio Management

## Principle: No Orphans, No Missing References

Every audio file in `EchoesOfChoiceTactical/assets/audio/` must be explicitly referenced by game code. Every audio path in game code must point to an existing file. No random fallback — every scene and battle gets a specific, named track.

## Music Rules

- **Every battle** must set `config.music_track` in its battle config function. Do not rely on `play_context()` fallback.
- **Every scene** (title, menus, overworld, towns, credits, game over, battle summary) must call `MusicManager.play_music()` with an explicit path.
- **Every town** must have an entry in `Town.TOWN_TRACKS`. Do not rely on `play_context(TOWN)` fallback.
- **No unused tracks**: If an audio file exists in `assets/audio/music/` but no `.gd` file references its path, it must be deleted or moved to `assets_library/music/`.
- **No missing tracks**: If a `.gd` file references a `res://assets/audio/music/` path, that file must exist on disk.

## SFX Rules

- **Every SFX category** in `SFXManager.Category` must be called somewhere in game code (directly via `play()` or indirectly via `play_ability_sfx()`).
- **Every subfolder** listed in `SFXManager.CATEGORY_FOLDERS` must exist on disk and contain audio files.
- **No unmapped folders**: Subfolders under `assets/audio/sfx/combat/` or `assets/audio/sfx/ranged/` that are not listed in `CATEGORY_FOLDERS` must be deleted.

## When Adding Audio

1. Copy the track from `assets_library/` to the appropriate `assets/audio/music/{context}/` or `assets/audio/sfx/{category}/` folder
2. Add the explicit `play_music()` or `music_track` reference in the relevant `.gd` file
3. Run `/audio-audit` to verify no orphans or missing references

## When Removing Audio

1. Remove all code references first
2. Delete the audio file and its `.import` file
3. Run `/audio-audit` to verify clean state
