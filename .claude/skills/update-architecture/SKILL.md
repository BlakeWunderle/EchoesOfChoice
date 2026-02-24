---
name: update-architecture
description: Update the architecture document after adding new files, scenes, systems, or completing a phase. Use when you've created or deleted GDScript/scene files, added autoloads, changed resource counts, or finished a build phase.
---

# Update Architecture Document

Keep `.claude/rules/architecture.md` in sync with the actual project state. Run this after any session that adds, removes, or renames files in `EchoesOfChoiceTactical/`.

## When to Update

- Created or deleted a `.gd` script or `.tscn` scene
- Added or removed an autoload
- Added a new resource directory or significantly changed resource counts
- Completed or progressed a build phase
- Added new tools to `tools/`

## Checklist

Walk through each section of `architecture.md` and verify it matches reality:

### 1. Core Data (`scripts/data/`)
- Every `.gd` file in `scripts/data/` should have an entry
- Description format: `filename.gd` -- One-line summary of purpose

### 2. Systems (`scripts/systems/`)
- Every `.gd` file in `scripts/systems/` should have an entry

### 3. Autoload (`scripts/autoload/`)
- Every `.gd` file in `scripts/autoload/` should have an entry
- Cross-check with `project.godot` autoload section

### 4. Scene sections (Battle, Story, Overworld, Town, UI, Units)
- Every `.gd/.tscn` pair should have an entry in the right section
- Use `Scene.gd/.tscn` format for paired files
- Standalone scripts get just `script.gd`

### 5. Resources (`resources/`)
- Update counts: classes (currently 54), abilities (170+), enemies (67), items (59)
- Add new resource subdirectories if created

### 6. Tools (`tools/`)
- Every `.gd` file in `tools/` should have an entry

### 7. Build Progress table
- Update phase status: PENDING → IN PROGRESS → MOSTLY COMPLETE → COMPLETE
- Add detail to scope column as work progresses
- Note what's missing in MOSTLY COMPLETE phases

## Format Conventions

- Use `--` (double dash) as separator between filename and description
- Keep descriptions to one line
- Group related files under the same subsection header
- Paths are relative to `EchoesOfChoiceTactical/`
- Resource counts use approximate format for large sets (e.g., "170+")

## Quick Verify Command

Run this to list all `.gd` files and compare against the doc:

```bash
find EchoesOfChoiceTactical/scripts -name "*.gd" | sort
find EchoesOfChoiceTactical/scenes -name "*.gd" | sort
find EchoesOfChoiceTactical/tools -name "*.gd" | sort
```
