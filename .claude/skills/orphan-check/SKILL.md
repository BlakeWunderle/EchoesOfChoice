---
name: orphan-check
description: Detect and clean up orphaned .tres resources and .tscn scenes that are no longer referenced by any game code. Use after adding or removing resources, periodic cleanup, or when investigating unused files.
---

# Orphan Resource & Scene Detection

Detects `.tres` resources and `.tscn` scenes in `EchoesOfChoiceTactical/` that have zero external references — meaning no script, resource, or scene file loads or references them.

## Running the Tool

```bash
# Default: show only orphans
"C:/Users/blake/AppData/Local/Microsoft/WinGet/Packages/GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe/Godot_v4.6.1-stable_win64_console.exe" --path EchoesOfChoiceTactical --headless --script res://tools/orphan_check.gd

# Show all files with reference counts
... -- --all

# Filter to one category
... -- abilities
... -- enemies --all
```

## Categories Scanned

| Category | Directory | What to check |
|----------|-----------|---------------|
| Abilities | `resources/abilities/` | Referenced via `ExtResource` in class/enemy `.tres` |
| Classes | `resources/classes/` | Referenced via `load()` in battle configs, `ExtResource` in upgrade_options |
| Enemies | `resources/enemies/` | Referenced via `load()` in `battle_config_prog_*.gd` |
| Items — Consumable | `resources/items/` (flat) | Referenced by string ID in `Town.gd`, `map_data.gd`, `travel_event.gd` |
| Items — Equipment | `resources/items/equipment/` | Referenced as `"equipment/<name>"` in `Town.gd` shops |
| Scenes | `scenes/` (recursive) | Referenced via `change_scene()`, `preload()`, `load()` in scripts |

## How Detection Works

For each resource/scene file, two strategies are used:

1. **Full path match** — searches all `.gd`, `.tres`, `.tscn` files for the exact `res://` path (catches `ExtResource`, `load()`, `preload()`, `change_scene()`)
2. **Quoted basename match** — searches for the filename stem in double quotes, e.g. `"slash"` for `slash.tres` (catches dynamic loading via `load("res://.../%s.tres" % id)` and string ID references in shop/reward arrays). For equipment items, also checks `"equipment/<stem>"`. Skipped for `.tscn` files since scene refs always use full paths.

The tool excludes `res://tools/` from the search corpus — references only in tool scripts do not count as real usage.

## Cleanup Workflow

1. **Run the tool** to identify orphans
2. **Review each orphan** — confirm it's truly unused (check if it was recently added and not yet wired up)
3. **Delete orphaned files** including any `.import` sidecar files
4. **Build** to verify no breakage: `--path EchoesOfChoiceTactical --headless --quit`
5. **Re-run the tool** to confirm 0 orphans
6. **Commit** the deletions

## Edge Cases

- **Newly added resources**: A resource just created but not yet wired into a class/battle config will show as orphaned — don't delete it, wire it up instead
- **Common basenames**: A file like `guard.tres` has stem `"guard"` which may match in unrelated quoted strings, producing a false negative (not flagged when it should be). Full path match catches these correctly
- **Dynamic sprite loading**: `SpriteFrames` `.tres` files are loaded via `sprite_id` strings in `SpriteLoader` — these aren't currently scanned but would be caught by quoted basename match if they lived under `resources/`

## When to Run

- After adding or removing ability/class/enemy/item `.tres` files
- After adding or removing `.tscn` scene files
- During periodic cleanup passes
- Before a major release to trim unused assets

## Related Skills

- **update-architecture** skill — update the architecture doc after cleanup
- **setting-enemy-abilities** skill — when wiring abilities into new enemies
- **making-battle-configs** skill — when wiring enemies into battle configs
