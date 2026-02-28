---
name: new-gdscript-files
description: Checklist for adding new GDScript files with class_name to EchoesOfChoiceTactical. Prevents "Could not find type" errors from Godot 4's class_name resolution. Use whenever creating a new .gd file that will be referenced by other scripts.
---

# New GDScript File Checklist

Godot 4's `class_name` global registration is unreliable for newly added files. Scripts that reference a new class by its `class_name` will fail with:

```
Parse Error: Could not find type "MyNewClass" in the current scope.
```

**Always use `preload()` when referencing a new class from another script.** Do not rely on `class_name` alone for cross-file references.

---

## The Rule

When script A needs to use class B (a new `.gd` file):

### DO: preload + const

```gdscript
# In the file that USES the new class:
const _MyNewClass = preload("res://path/to/my_new_class.gd")

# Instantiate via the const:
var instance = _MyNewClass.new()
```

### DON'T: bare class_name reference

```gdscript
# This WILL fail for newly added files:
var instance = MyNewClass.new()
var thing: MyNewClass  # type annotation also fails
```

### Type annotations

Use the base Godot type instead of the new class name for variable declarations:

```gdscript
# Instead of:
var _panel: MyNewPanel  # fails

# Use:
const _MyNewPanel = preload("res://scenes/ui/MyNewPanel.gd")
var _panel: PanelContainer  # base type for declaration
# ...
_panel = _MyNewPanel.new()  # preloaded const for instantiation
```

---

## When This Applies

| Situation | Needs preload? |
|-----------|---------------|
| New `.gd` file with `class_name`, referenced by another script | YES |
| Existing `.gd` file already in the project | Usually no (already registered) |
| Autoload scripts referencing any class at declaration time | YES (autoloads load before registration) |
| `.tres` resources referencing classes | No (resources use `ExtResource` paths) |
| Scripts in `tools/` run via `--script` | YES (use `preload()` or `const` pattern) |

---

## Full Example

Creating a new `CursorInfoPanel.gd` used by `BattleMap.gd`:

```gdscript
# scenes/battle/CursorInfoPanel.gd (new file)
class_name CursorInfoPanel extends PanelContainer

func show_unit(unit: Unit) -> void:
    # ...
```

```gdscript
# scenes/battle/BattleMap.gd (existing file that uses it)
const _CursorInfoPanelScript = preload("res://scenes/battle/CursorInfoPanel.gd")

var _cursor_info_panel: PanelContainer  # base type, not CursorInfoPanel

func _setup_hud() -> void:
    _cursor_info_panel = _CursorInfoPanelScript.new()
    hud.add_child(_cursor_info_panel)
```

---

## Naming Convention

- Preload const: `const _ClassName = preload("res://path/to/file.gd")`
- Prefix with underscore if private to the file
- Use the class name as the const name (optionally suffixed with `Script` to distinguish from instances)

---

## Related

- **file-size-limits** skill — covers the autoload-specific preload gotcha
- `.claude/rules/coding-conventions.md` — general GDScript conventions
- `.claude/rules/build-environment.md` — build commands to verify no errors
