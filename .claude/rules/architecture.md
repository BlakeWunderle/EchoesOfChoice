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

### Progression Data (`scripts/data/` continued)
- `xp_config.gd` -- XP/JP constants, level curve (xp_to_next_level), catchup multiplier, JP calculation and class identity actions
- `map_data.gd` -- Map node definitions including `gold_reward`, `npcs` (Array[Dictionary] of town NPCs with name/role/lines), per battle node
- `travel_event.gd` -- TravelEvent resource: event_type (ambush/merchant/rest/story/rumor), title, dialogue Array[Dictionary], trigger_chance, node_range

### Battle Configuration (`scripts/data/` continued)
- `battle_config.gd` -- Base battle configuration class
- `battle_config_prog_01.gd` -- Progression 0-1 battle configs (tutorial, city_street, forest, village_raid)
- `battle_config_prog_23.gd` -- Progression 2-3 battle configs (smoke, deep_forest, clearing, ruins, cave, portal, inn_ambush)
- `battle_config_prog_45.gd` -- Progression 4-5 battle configs (shore, beach, cemetery, carnival, encampment, lab, mirror, gate_ambush)
- `battle_config_prog_67.gd` -- Progression 6-7 battle configs (city_gate, return_city battles, elemental shrines, final_castle)
- `terrain_overrides.gd` -- Per-battle terrain customization

### Systems (`scripts/systems/`)
- `grid.gd` -- Grid engine: BFS movement with elevation+jump, A* pathfinding, range/AoE calculation, line-of-sight (Bresenham), dynamic terrain placement/removal
- `combat.gd` -- All damage formulas, crit/dodge rolls, reaction damage calculations (flanking 50%, snap shot 50%, reactive heal 35%, mitigation 25%, bodyguard 45%)
- `reaction_system.gd` -- All 6 reaction types with trigger logic, defensive reaction chaining (bodyguard then mitigation before damage applies)
- `battle_ai.gd` -- Enemy AI: target scoring, ability selection, movement positioning, trap avoidance
- `ability_executor.gd` -- Ability execution: damage/heal/buff/debuff/terrain application

### Autoload (`scripts/autoload/`)
- `game_state.gd` -- Singleton: party data, progression stage, story flags, gold, inventory, equipment, unlocked classes
- `equipment_manager.gd` -- Equipment slot management, tier-based slot limits (tier+1), item unlock checks
- `save_load_manager.gd` -- JSON save/load with 3 slots
- `scene_manager.gd` -- Scene transitions, new game / continue / load routing

### Battle (`scenes/battle/`)
- `BattleMap.gd/.tscn` -- Main battle scene: grid rendering, turn flow (act-then-move), targeting with AoE preview, facing chooser, AI, reaction integration
- `TurnManager.gd` -- ATB system (speed -> 100 threshold), turn order preview, battle end detection
- `ActionMenuController.gd` -- Battle action menu (Attack, Ability, Item, Move, Wait, Facing selection)
- `GridOverlay.gd` -- Colored tile overlays (movement=blue, attack=red, AoE=orange, threatened=red border, path=cyan)
- `GridCursor.gd/.tscn` -- Keyboard cursor (WASD/arrows, Enter/Z=select, Esc/X=cancel)
- `PartySelect.gd/.tscn` -- Pre-battle party composition screen
- `BattleSummary.gd/.tscn` -- Post-battle XP/JP/loot/promotion results

### Story (`scenes/story/`)
- `TitleScreen.gd/.tscn` -- Title screen (new game / continue / load / quit) with save slot selection
- `CharacterCreation.gd/.tscn` -- Player name/gender selection
- `ClassSelection.gd/.tscn` -- Class picker UI
- `Barracks.gd/.tscn` -- Initial party recruitment (4-guard flow with class/gender/name selection)
- `ThroneRoom.gd/.tscn` -- Opening story cutscene
- `TravelEvent.gd/.tscn` -- Overworld travel event popup (ambush/merchant/rest/story/rumor)

### Overworld (`scenes/overworld/`)
- `OverworldMap.gd/.tscn` -- Overworld map with node traversal, fog-of-war, progression gating
- `terrain_drawer.gd` -- Overworld terrain visualization

### Town (`scenes/town/`)
- `Town.gd/.tscn` -- Town hub: shop, recruit, promote, NPC conversations, rest, story flag gating, optional battles
- `RecruitUI.gd/.tscn` -- Class recruitment list with gender/name selection
- `PromoteUI.gd/.tscn` -- Class promotion UI: JP-based tier upgrades with stat comparison

### UI (`scenes/ui/`)
- `DialogueBox.gd/.tscn` -- Dialogue display system
- `ShopUI.gd/.tscn` -- Buy/sell items and equipment
- `ItemsUI.gd/.tscn` -- Inventory management
- `RewardChoiceUI.gd/.tscn` -- Post-battle reward selection
- `GameOver.gd/.tscn` -- Game over screen

### Units (`scenes/units/`)
- `Unit.gd/.tscn` -- Unit node: all stats, facing, reaction tracking, animated grid movement, stat modification, health bar

### Resources (`resources/`)
- `classes/` -- 54 FighterData .tres files (4 base + 16 T1 + 32 T2 + 2 royal)
- `abilities/` -- 170+ AbilityData .tres files
- `enemies/` -- 67 FighterData .tres files
- `items/` -- 59 item .tres files (consumables + equipment across 3 progression tiers)
- `tilesets/` -- TileSet resources for terrain

### Tools (`tools/`)
- `balance_check.gd` -- Headless battle simulator for enemy vs. party damage analysis per progression
- `item_check.gd` -- Equipment balance verification via mirror-fight static analysis

## Build Progress

Phases 1-7 COMPLETE (project setup, grid, units, movement, turns, abilities, combat).

| Phase | Status | Scope |
|-------|--------|-------|
| 8 | COMPLETE | Tactical AI — enemy decision-making, ability scoring, movement positioning |
| 9 | MOSTLY COMPLETE | UI — health bars, action menu, turn order, battle summary; missing: combat animations, audio |
| 10 | COMPLETE | Class porting — all 54 player classes, 170+ abilities, 67 enemies, 59 items as .tres |
| 11 | MOSTLY COMPLETE | Story/world — battle configs, NPC conversations, travel events; missing: some dialogue polish |
| 12 | PENDING | Final balance pass — all battles tuned; XP/JP curve verified; win-rate targets met |

## Reference Codebase

The original C# console RPG at `EchoesOfChoice/` contains all stat values, ability definitions, damage formulas, class upgrade trees, enemy definitions, and story text. Key reference files:
- `EchoesOfChoice/CharacterClasses/Common/BaseFighter.cs` -- stat model
- `EchoesOfChoice/CharacterClasses/Common/Ability.cs` -- ability model
- `EchoesOfChoice/Battles/Battle.cs` -- damage formulas, ATB system, AI
- `EchoesOfChoice/CharacterClasses/Fighter/`, `Mage/`, `Entertainer/`, `Scholar/` -- all 52 classes
- `EchoesOfChoice/CharacterClasses/Enemies/` -- all enemy types
- `EchoesOfChoice/Echoes of Choice/Program.cs` -- story flow, party creation
