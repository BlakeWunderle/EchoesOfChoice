---
name: run-game
description: Run the Godot game or headless build with known harmless errors filtered out. Use when launching the game, running builds, or capturing runtime errors to diagnose issues.
---

# Run Game with Error Filtering

Runs the Godot project with standardized filtering to suppress known harmless errors so only real issues are visible.

## Godot Executable

```
GODOT="C:/Users/blake/AppData/Local/Microsoft/WinGet/Packages/GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe/Godot_v4.6.1-stable_win64_console.exe"
```

## Noise Filter

The following error patterns are **known harmless** and should always be filtered from output:

```bash
NOISE_FILTER='No loader\|Oswald\|game_theme\|custom project\|Unreferenced static string\|RID allocations.*leaked\|Pages in use exist at exit\|PagedAllocator\|ObjectDB instances leaked\|resources still in use at exit\|OpenGL API\|NVIDIA\|WASAPI\|Cleanup\|Main::'
```

### What each filter covers

| Pattern | Category | Why harmless |
|---------|----------|-------------|
| `No loader` | Missing font import | Oswald-Bold.ttf not imported as Godot resource |
| `Oswald` | Font reference | Same font issue, different message form |
| `game_theme` | Theme resource | Theme .tres reference before import |
| `custom project` | Project settings | Godot project config warning |
| `Unreferenced static string` | Engine cleanup | Godot internal string table cleanup at exit |
| `RID allocations.*leaked` | Engine cleanup | NavMesh parser cleanup at exit |
| `Pages in use exist at exit` | Engine cleanup | Paged allocator cleanup at exit |
| `PagedAllocator` | Engine cleanup | Same, alternate message form |
| `ObjectDB instances leaked` | Engine cleanup | Standard headless mode exit warning |
| `resources still in use at exit` | Engine cleanup | Resource cache not fully cleared |
| `OpenGL API\|NVIDIA\|WASAPI` | Driver info | GPU/audio driver identification lines |
| `Cleanup\|Main::` | Engine lifecycle | Godot startup/shutdown messages |

## Commands

### Headless build (verify no compile errors)

```bash
"$GODOT" --path EchoesOfChoiceTactical --headless --quit 2>&1 | grep -v "$NOISE_FILTER"
```

Expected clean output: just the Godot version line.

### Run game with filtered output (timed)

Run for N seconds, capture real errors only:

```bash
"$GODOT" --path EchoesOfChoiceTactical 2>&1 &
GODOT_PID=$!
sleep 20
kill $GODOT_PID 2>/dev/null
wait $GODOT_PID 2>/dev/null
```

Then filter the output with `grep -v "$NOISE_FILTER"`.

### Run game in background

```bash
"$GODOT" --path EchoesOfChoiceTactical 2>&1 &
```

Check output later; stop with `kill %1`.

## Known Pre-existing Errors (not noise, but not new bugs)

These are real errors that exist in the project but are not caused by recent changes. Note them but don't block on them:

| Error | Files | Status |
|-------|-------|--------|
| Missing WAV audio files | `assets/audio/music/menu/*.wav`, `assets/audio/music/battle/*.wav` | Music files not yet sourced/downloaded |
| Corrupt spriteframe .tres | `chibi_armored_knight_medieval_knight_royal.tres`, `chibi_knight_2.tres`, `chibi_magician_1_royal.tres` (Parse Error at line 734) | Need regeneration via `generate_all_sprites.py` |

## Interpreting Output

After filtering, real errors to watch for:
- **`SCRIPT ERROR: Parse Error`** in game scripts (.gd files) — actual code bugs
- **`Failed to load script`** — missing class_name, circular deps, or syntax errors
- **`Null instance`** / **`Invalid call`** — runtime crashes from bad references
- **`Cannot infer the type`** — typing errors in GDScript (may cascade from other errors)

## Run Tool Script

```bash
"$GODOT" --path EchoesOfChoiceTactical --headless --script res://tools/<tool>.gd 2>&1 | grep -v "$NOISE_FILTER"
```

With arguments:
```bash
"$GODOT" --path EchoesOfChoiceTactical --headless --script res://tools/<tool>.gd -- <arg1> <arg2> 2>&1 | grep -v "$NOISE_FILTER"
```
