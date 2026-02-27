# Build Environment

## Godot Executable

Installed via WinGet. Console executable for headless operations:

```
C:\Users\blake\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.6.1-stable_win64_console.exe
```

## Commands

All commands run from the workspace root (`EchoesOfChoice/`).

### Noise filter (always use when running Godot)
```bash
NOISE='No loader\|Oswald\|game_theme\|custom project\|Unreferenced static string\|RID allocations.*leaked\|Pages in use exist at exit\|PagedAllocator\|ObjectDB instances leaked\|resources still in use at exit\|OpenGL API\|NVIDIA\|WASAPI\|Cleanup\|Main::'
```

### Build (verify no errors)
```bash
"C:/Users/blake/AppData/Local/Microsoft/WinGet/Packages/GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe/Godot_v4.6.1-stable_win64_console.exe" --path EchoesOfChoiceTactical --headless --quit 2>&1 | grep -v "$NOISE"
```

### Run a tool script
```bash
"C:/Users/blake/AppData/Local/Microsoft/WinGet/Packages/GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe/Godot_v4.6.1-stable_win64_console.exe" --path EchoesOfChoiceTactical --headless --script res://tools/<tool>.gd
```

### Run a tool with arguments
```bash
... --script res://tools/<tool>.gd -- <arg1> <arg2>
```
