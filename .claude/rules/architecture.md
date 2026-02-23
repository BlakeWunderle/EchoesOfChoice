---
description: Project architecture and file responsibilities for Echoes of Choice Tactical
---

# Project Architecture

Godot 4 project using GDScript at `EchoesOfChoiceTactical/`. Built alongside (not replacing) the C# console RPG at `EchoesOfChoice/`.

## File Map

All paths below are relative to `EchoesOfChoiceTactical/`.

### Core Data (`scripts/data/`)
- `enums.gd` -- All enums: StatType, AbilityType, AoEShape, TileType, Facing, ReactionType, TurnPhase, Team
- `fighter_data.gd` -- Resource class for class definitions (stats, growth, movement, jump, reactions, abilities, upgrades)
- `ability_data.gd` -- Resource class for abilities (range, AoE, type including Terrain, elevation-aware range calc)
- `modified_stat.gd` -- Buff/debuff with turn countdown
- `terrain_effect.gd` -- Dynamically placed terrain (ice walls, fire tiles) with duration

### Systems (`scripts/systems/`)
- `grid.gd` -- Grid engine: BFS movement with elevation+jump, A* pathfinding, range/AoE calculation, line-of-sight (Bresenham), dynamic terrain placement/removal
- `combat.gd` -- All damage formulas, crit/dodge rolls, reaction damage calculations (flanking 50%, snap shot 50%, reactive heal 35%, mitigation 25%, bodyguard 45%)
- `reaction_system.gd` -- All 6 reaction types with trigger logic, defensive reaction chaining (bodyguard then mitigation before damage applies)

### Autoload (`scripts/autoload/`)
- `game_state.gd` -- Singleton: party data, progression stage, story flags, gold, inventory, equipment, unlocked classes, JSON save/load

### Progression data (`scripts/data/` continued)
- `xp_config.gd` -- XP/JP constants, level curve (xp_to_next_level), catchup multiplier, JP calculation and class identity actions
- `map_data.gd` -- Map node definitions including `gold_reward`, `npcs` (Array[Dictionary] of town NPCs with name/role/lines), per battle node
- `travel_event.gd` -- TravelEvent resource: event_type (ambush/merchant/rest/story/rumor), title, dialogue Array[Dictionary], trigger_chance, node_range

### Battle (`scenes/battle/`)
- `BattleMap.gd/.tscn` -- Main battle scene: grid rendering, turn flow (act-then-move), action menu, targeting with AoE preview, facing chooser, AI, reaction integration
- `TurnManager.gd` -- ATB system (speed -> 100 threshold), turn order preview, battle end detection
- `GridOverlay.gd` -- Colored tile overlays (movement=blue, attack=red, AoE=orange, threatened=red border, path=cyan)
- `GridCursor.gd/.tscn` -- Keyboard cursor (WASD/arrows, Enter/Z=select, Esc/X=cancel)
- `PartySelect.gd/.tscn` -- Pre-battle party composition screen
- `BattleSummary.gd/.tscn` -- Post-battle XP/loot/promotion results

### Story (`scenes/story/`)
- `TitleScreen.gd/.tscn` -- Title screen (new game / continue / quit)
- `CharacterCreation.gd/.tscn` -- Player name/gender/class selection (main scene)
- `ClassSelection.gd/.tscn` -- Class picker UI
- `Barracks.gd/.tscn` -- Party management and class upgrade screen
- `ThroneRoom.gd/.tscn` -- Opening story cutscene
- `TravelEvent.gd/.tscn` -- Overworld travel event popup (ambush/merchant/rest/story/rumor) [PENDING Phase 11]

### Town (`scenes/town/`)
- `Town.gd/.tscn` -- Town hub: shop, recruit, NPC conversations, story flag gating
- `RecruitUI.gd/.tscn` -- Enemy recruitment list and confirmation
- `ShopUI.gd/.tscn` -- Buy/sell items, equipment upgrades

### Units (`scenes/units/`)
- `Unit.gd/.tscn` -- Unit node: all stats, facing, reaction tracking, animated grid movement, stat modification, health bar

### Resources (`resources/`)
- `classes/` -- FighterData .tres files per class (to be populated in Phase 10)
- `abilities/` -- AbilityData .tres files per ability (to be populated in Phase 10)
- `enemies/` -- FighterData .tres files per enemy type
- `tilesets/` -- TileSet resources for terrain

## Build Progress

Phases 1-7 COMPLETE (project setup, grid, units, movement, turns, abilities, combat).

| Phase | Status | Scope |
|-------|--------|-------|
| 8 | PENDING | Tactical AI — enemy decision-making (move toward weakest, use abilities, reactions) |
| 9 | PENDING | UI Polish — health bars, action menu clarity, turn order display, animations |
| 10 | PENDING | Class porting — all 52 player classes as FighterData .tres; full ability .tres set |
| 11 | PENDING | Story/world — pre/post battle dialogue in BattleConfig; NPC conversations in towns; travel events on overworld |
| 12 | PENDING | Final balance pass — all battles tuned; XP/JP curve verified; win-rate targets met |

## Reference Codebase

The original C# console RPG at `EchoesOfChoice/` contains all stat values, ability definitions, damage formulas, class upgrade trees, enemy definitions, and story text. Key reference files:
- `EchoesOfChoice/CharacterClasses/Common/BaseFighter.cs` -- stat model
- `EchoesOfChoice/CharacterClasses/Common/Ability.cs` -- ability model
- `EchoesOfChoice/Battles/Battle.cs` -- damage formulas, ATB system, AI
- `EchoesOfChoice/CharacterClasses/Fighter/`, `Mage/`, `Entertainer/`, `Scholar/` -- all 52 classes
- `EchoesOfChoice/CharacterClasses/Enemies/` -- all enemy types
- `EchoesOfChoice/Echoes of Choice/Program.cs` -- story flow, party creation
