# Project Architecture

Godot 4 project using GDScript at `EchoesOfChoiceTactical/`. Building a visual RPG based on the C# console RPG at `EchoesOfChoice/`.

## File Map

All paths below are relative to `EchoesOfChoiceTactical/`.

### Core Data (`scripts/data/`)
- `enums.gd` -- All enums: StatType, AbilityType, AoEShape, TileType, Facing, ReactionType, TurnPhase, Team

### Autoload (`scripts/autoload/`)
- `scene_manager.gd` -- Scene transitions with fade overlay, threaded preloading, async scene swapping
- `music_manager.gd` -- Background music with crossfade, context-based track pools (battle, exploration, town, menu, boss, cutscene)
- `sfx_manager.gd` -- SFX playback: 28 category enum with folder-based pools, 8-player polyphonic pool, per-category cooldown (80ms), voice pack system (per-unit packs x 4 actions), play_ability_sfx() maps ability type/name to SFX category
- `audio_loader.gd` -- Static utility (class_name AudioLoader, not autoloaded): runtime audio file loading via load_from_file() for WAV/OGG/MP3, headless mode detection, path globalization
- `input_config.gd` -- Input action registration (keyboard mappings)

### Scenes (`scenes/`)
- `Main.tscn` -- Placeholder main scene (empty Control node)

### Resources (`resources/`)
- `gui/` -- `game_theme.tres` project-wide Theme (dark panels, gold borders, green buttons, Oswald-Bold font)

### Assets (`assets/`)
- `audio/music/` -- ~90 music tracks across contexts (menu, battle, boss, exploration, town, cutscene, game_over, victory)
- `audio/sfx/` -- ~600 sound effects in 28 categories + 8 voice packs
- `art/gui/` -- CraftPix RPG GUI elements (reusable UI graphics)

### Reference (`reference/`)

Previous tactical RPG code preserved for reference (excluded from Godot build via `.gdignore`):

- `reference/scenes/` -- All 25 tactical game scenes (.tscn + .gd scripts): battle map, overworld, town, story, UI, units
- `reference/systems/` -- Grid engine, combat formulas, reaction system, battle AI, ability executor, combat animator, terrain renderer
- `reference/data/` -- Data models: fighter_data, ability_data, item_data, battle configs, map data, XP/JP config, travel events
- `reference/autoload/` -- Game state, equipment manager, save/load, sprite loader, battle preloader
- `reference/tools/` -- Build/balance/art tools: battle simulator, sprite generators, palette swap, theme generator, orphan checker

## Reference Codebase

The C# console RPG at `EchoesOfChoice/` is the source of truth for game content:
- `EchoesOfChoice/CharacterClasses/Common/BaseFighter.cs` -- stat model
- `EchoesOfChoice/CharacterClasses/Common/Ability.cs` -- ability model
- `EchoesOfChoice/Battles/Battle.cs` -- damage formulas, ATB system, AI
- `EchoesOfChoice/CharacterClasses/Fighter/`, `Mage/`, `Entertainer/`, `Scholar/`, `Wildling/` -- all 53 classes
- `EchoesOfChoice/CharacterClasses/Enemies/` -- all enemy types
- `EchoesOfChoice/Echoes of Choice/Program.cs` -- story flow, party creation
