---
description: GDScript coding conventions for the Echoes of Choice Tactical project
globs: "EchoesOfChoiceTactical/**/*.gd"
alwaysApply: false
---

# GDScript Conventions

- Use static typing everywhere (`var x: int`, `func foo() -> void`)
- Use `class_name` for all classes that need to be referenced elsewhere
- Use Godot Resources (`extends Resource`) for data definitions (classes, abilities, enemies)
- Use signals for event-driven communication between nodes
- Prefix private members with underscore (`_private_var`, `_helper_func()`)
- Use `@export` for inspector-editable properties on Resources
- Use `@onready` for node references
- Constants use `UPPER_SNAKE_CASE`
- Grid positions are always `Vector2i`, world positions are `Vector2`
- Tile size is 64px (constant `TILE_SIZE` in Unit.gd and GridCursor.gd)
