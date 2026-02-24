---
name: file-size-limits
description: Guidelines for keeping GDScript files under 300 lines. Use when creating new files, refactoring large files, or deciding when/how to split a file that has grown too big. Covers Godot-specific patterns (RefCounted, child node scripts, signals) for clean decomposition.
---

# File Size Limits — GDScript

Keep logic files under **300 lines**. Data-heavy files (battle configs, terrain overrides) may stretch to **350 lines**. Scene root scripts that orchestrate multiple subsystems (e.g. BattleMap.gd) are the exception — aim for under **800 lines**.

---

## When to Split

Split a file when:
- It exceeds 300 lines of logic (not counting blank lines or comments)
- It has 2+ clearly distinct responsibilities (e.g. AI + UI + execution)
- A section could be tested or reused independently
- You find yourself scrolling past unrelated code to reach what you need

Do NOT split when:
- The file is under 200 lines
- The code is tightly coupled and splitting would create circular dependencies
- The "sections" are just sequential steps of one algorithm

---

## How to Split — Godot Patterns

### 1. RefCounted for Pure Logic

Use `extends RefCounted` for classes that don't need the scene tree.

**Good for:** AI, combat formulas, ability execution, save/load I/O, equipment management, data validation.

```gdscript
# scripts/systems/battle_ai.gd
class_name BattleAI extends RefCounted

var _grid: Grid
var _reaction_system: ReactionSystem

func _init(p_grid: Grid, p_reaction: ReactionSystem) -> void:
    _grid = p_grid
    _reaction_system = p_reaction

func run_turn(unit: Unit) -> void:
    # AI logic here
```

**Parent instantiates:**
```gdscript
var _ai: BattleAI

func _setup() -> void:
    _ai = BattleAI.new(grid, reaction_system)
```

**When the helper needs async (timers, awaits):** Pass the scene root Node as a constructor arg so it can call `scene_root.get_tree().create_timer()`.

### 2. Child Node Scripts for UI

Attach a script to an existing child node in the `.tscn` file.

**Good for:** Action menus, HUD panels, dialogue boxes, inventory UIs.

```gdscript
# scenes/battle/ActionMenuController.gd
class_name ActionMenuController extends VBoxContainer

signal attack_chosen
signal ability_chosen(ability: AbilityData)

func show_menu(unit: Unit) -> void:
    # Build buttons, show panel
```

**Parent connects signals:**
```gdscript
func _connect_action_menu() -> void:
    action_menu.attack_chosen.connect(_on_attack_chosen)
    action_menu.ability_chosen.connect(_on_ability_chosen)
```

**Update the .tscn:** Add `script = ExtResource("id")` to the node and add the `[ext_resource]` at the top. Increment `load_steps`.

### 3. Static Factory Methods in Separate Files

Split large factory/config files by category (e.g. progression stage).

**Good for:** Battle configs, enemy definitions, item catalogs.

```gdscript
# scripts/data/battle_config_prog_01.gd
class_name BattleConfigProg01 extends RefCounted

static func create_tutorial() -> BattleConfig:
    var config := BattleConfig.new()
    # ...
    return config
```

**Base class keeps shared utilities:**
```gdscript
# scripts/data/battle_config.gd
class_name BattleConfig extends Resource

static func load_class(class_id: String) -> FighterData:
    # shared helper
```

### 4. Delegation with Back-Reference

When the extracted class needs to call back into the parent (e.g. EquipmentManager calling GameState.remove_item):

```gdscript
class_name EquipmentManager extends RefCounted

var _state  # GameState — untyped to avoid circular reference

func _init(state) -> void:
    _state = state

func equip_item(unit_name: String, item_id: String) -> bool:
    if not _state.remove_item(item_id):
        return false
    # ...
```

**Use untyped references** to avoid GDScript circular dependency errors. Add a comment noting the expected type.

---

## Autoload Gotcha

Autoload scripts load before `class_name` registration. Use `preload()` instead of class names for helpers instantiated at declaration time:

```gdscript
# In an autoload (game_state.gd):
var _save_manager = preload("res://scripts/autoload/save_load_manager.gd").new()
```

For helpers that need `self`, initialize in `_ready()`:
```gdscript
var _equipment  # EquipmentManager

func _ready() -> void:
    _equipment = preload("res://scripts/autoload/equipment_manager.gd").new(self)
```

---

## Checklist Before Creating a New File

1. Is the file over 300 lines? If not, don't split yet.
2. Can you identify a cohesive subset of methods (5+) that share a responsibility?
3. Will the new file avoid circular dependencies?
4. Will the parent's public API stay unchanged (delegation wrappers)?
5. Does the split follow one of the four patterns above?

If all yes, split. Otherwise, leave it.
