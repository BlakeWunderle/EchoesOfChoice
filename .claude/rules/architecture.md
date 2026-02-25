---
description: Project architecture and file responsibilities for Echoes of Choice Tactical
---

# Project Architecture

Godot 4 project using GDScript at `EchoesOfChoiceTactical/`. Built alongside (not replacing) the C# console RPG at `EchoesOfChoice/`.

## File Map

All paths below are relative to `EchoesOfChoiceTactical/`.

### Core Data (`scripts/data/`)
- `enums.gd` -- All enums: StatType, AbilityType, AoEShape, TileType, Facing, ReactionType, TurnPhase, Team
- `fighter_data.gd` -- Resource class for class definitions (stats, growth, movement, jump, reactions, abilities, upgrades, sprite_id, sprite_id_female)
- `ability_data.gd` -- Resource class for abilities (range, AoE, type including Terrain, elevation-aware range calc)
- `item_data.gd` -- Resource class for consumable and equipment items (stat bonuses, tier, cost, unlock rules)
- `modified_stat.gd` -- Buff/debuff with turn countdown
- `terrain_effect.gd` -- Dynamically placed terrain (ice walls, fire tiles) with duration

### Progression Data (`scripts/data/` continued)
- `xp_config.gd` -- XP/JP constants, level curve (xp_to_next_level), catchup multiplier, JP calculation and class identity actions
- `map_data.gd` -- Map node definitions including `gold_reward`, `npcs` (Array[Dictionary] of town NPCs with name/role/lines), per battle node
- `travel_event.gd` -- TravelEvent resource: event_type (ambush/merchant/rest/story/rumor), title, dialogue Array[Dictionary], trigger_chance, node_range

### Battle Configuration (`scripts/data/` continued)
- `battle_config.gd` -- Base battle configuration class (includes environment field for terrain rendering)
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
- `ability_executor.gd` -- Ability execution: damage/heal/buff/debuff/terrain application, returns result dictionaries for animation
- `combat_animator.gd` -- Combat visual effects: damage popups, hit flash, screen shake, ability tint, health bar tweening, death sequences
- `battle_terrain_renderer.gd` -- Draws battle terrain with CraftPix tileset textures (17 environments), elevation tinting, wall/destructible sprites, terrain effect overlays
- `tile_texture_cache.gd` -- Caches ground and wall AtlasTextures from CraftPix tileset spritesheets per environment
- `tile_decoration_data.gd` -- Per-environment wall object, destructible, and detail sprite paths with fallback mapping

### Autoload (`scripts/autoload/`)
- `game_state.gd` -- Singleton: party data, progression stage, story flags, gold, inventory, equipment, unlocked classes
- `equipment_manager.gd` -- Equipment slot management, tier-based slot limits (tier+1), item unlock checks
- `save_load_manager.gd` -- JSON save/load with 3 slots
- `scene_manager.gd` -- Scene transitions, new game / continue / load routing
- `music_manager.gd` -- Background music with crossfade, context-based track pools (battle, exploration, town, menu, boss, cutscene)
- `sfx_manager.gd` -- SFX playback: 28 category enum with folder-based pools, 8-player polyphonic pool, per-category cooldown (80ms), voice pack system (per-unit packs × 4 actions), play_ability_sfx() maps ability type/name to SFX category
- `sprite_loader.gd` -- Loads and caches SpriteFrames resources by sprite_id for unit rendering

### Battle (`scenes/battle/`)
- `BattleMap.gd/.tscn` -- Main battle scene: terrain rendering, turn flow (act-then-move), targeting with AoE preview, facing chooser, AI, reaction integration, gender-aware unit spawning
- `TurnManager.gd` -- ATB system (speed -> 100 threshold), turn order preview, battle end detection
- `ActionMenuController.gd` -- Battle action menu (Attack, Ability, Item, Move, Wait, Facing selection)
- `GridOverlay.gd` -- Colored tile overlays (movement=blue, attack=red, AoE=orange, threatened=red border, path=cyan)
- `GridCursor.gd/.tscn` -- Keyboard cursor with animated corner brackets (WASD/arrows, Enter/Z=select, Esc/X=cancel)
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
- `OverworldMap.gd/.tscn` -- Overworld map with node traversal, fog-of-war, terrain-tinted node markers with drop shadows, styled road paths with dashes, info panel with dark/gold styling
- `terrain_drawer.gd` -- Overworld terrain landmark icons (procedural draw per terrain type)

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
- `Unit.gd/.tscn` -- Unit node: AnimatedSprite2D (2x scale for 32px art on 64px tiles), directional animations (idle/walk/attack/hurt/death), gender-aware sprite loading (sprite_id_female for female/princess units) via SpriteLoader, flip_h mirroring fallback (left↔right) for 3-direction sprites, placeholder colored rectangles, all stats, facing, reaction tracking, animated grid movement, stat modification, health bar

### Resources (`resources/`)
- `classes/` -- 54 FighterData .tres files (4 base + 16 T1 + 32 T2 + 2 royal)
- `abilities/` -- 168 AbilityData .tres files
- `enemies/` -- 78 FighterData .tres files
- `items/` -- 58 item .tres files (consumables + equipment across 3 progression tiers)
- `tilesets/` -- TileSet resources for terrain
- `gui/` -- `game_theme.tres` project-wide Theme (dark panels, gold borders, green buttons, Oswald-Bold font)
- `spriteframes/` -- 139 SpriteFrames .tres files (in `assets/art/sprites/spriteframes/`, tracked in git); 68 chibi 3-direction class sprites (54 primary + 14 gender variants) + 71 existing 4-direction/sheet sprites; generated by `generate_all_sprites.py`

### Tools (`tools/`)
- `balance_check.gd` -- Headless battle simulator for enemy vs. party damage analysis per progression
- `item_check.gd` -- Equipment balance verification via mirror-fight static analysis
- `jp_check.gd` -- JP economy balance verification per class and progression
- `create_spriteframes.gd` -- Generates SpriteFrames .tres from sprite sheet PNGs; supports single-sheet and --dir mode for CraftPix multi-file format (per-animation PNGs with 4 direction rows)
- `orphan_check.gd` -- Detects orphaned .tres resources and .tscn scenes with zero external references (full-path + quoted-basename search strategies)
- `generate_theme.gd` -- Generates `resources/gui/game_theme.tres` programmatically with StyleBoxFlat styling for all UI control types
- `download_craftpix.py` -- Python script to download all 231 CraftPix asset packs via cookie auth (two-step URL resolution: product page → download page → files.craftpix.net ZIP); supports Netscape and simple name=value cookie files; covers RPG top-down collection (96), Chibi collection (98), Tiny Fantasy collection (37)
- `palette_swap.py` -- Python hue-based sprite recoloring tool with analyze, single, and batch modes for creating class variants from base archetypes
- `synthesize_directions.py` -- Python tool to generate 3-direction composite sheets from single-facing sprite packs (Chibi/Tiny Fantasy/4dir); south=original, east=original, north=darkened; west handled by Unit.gd flip_h; supports --prefix for collection-prefixed IDs, --batch for full-pack processing; skips __MACOSX metadata
- `generate_all_sprites.py` -- Python batch generator: reads CraftPix PNG sprite sheets, writes SpriteFrames .tres files with correct AtlasTexture regions; supports sheet mode (4-row), 4dir mode (per-direction compositing), and 3dir mode (synthesized 3-direction)
- `set_sprite_ids.py` -- Python tool to set sprite_id and sprite_id_female on all 54 class and 78 enemy .tres files; classes mapped to 54 unique Chibi sprites from 38 packs; 15 gender variant mappings with palette-matched recolors; prints coverage report

## Build Progress

Phases 1-7 COMPLETE (project setup, grid, units, movement, turns, abilities, combat).

| Phase | Status | Scope |
|-------|--------|-------|
| 8 | COMPLETE | Tactical AI — enemy decision-making, ability scoring, movement positioning |
| 9 | COMPLETE | UI — health bars, action menu, turn order, battle summary, cursor, combat animations (damage popups, hit flash, screen shake, health bar tweening) |
| 10 | COMPLETE | Class porting — all 54 player classes, 170+ abilities, 67 enemies, 59 items as .tres |
| 11 | COMPLETE | Story/world — battle configs (31 battles), NPC conversations (3 towns, 9 NPCs), travel events (8 types), all story scenes |
| 12 | IN PROGRESS | Final balance pass — headless battle simulator, win-rate validation, difficulty gradient tuning |
| 13 | MOSTLY COMPLETE | Art integration — 231 CraftPix packs downloaded (96 RPG top-down + 98 Chibi + 37 Tiny Fantasy); direction synthesis pipeline (synthesize_directions.py → generate_all_sprites.py 3dir mode → Unit.gd flip_h fallback); all 54 player classes mapped to unique Chibi sprites from 38 packs; 15 gender variant sprites with palette-matched recolors; 139 SpriteFrames generated; missing: enemy sprite upgrades to Chibi style |

## Reference Codebase

The original C# console RPG at `EchoesOfChoice/` contains all stat values, ability definitions, damage formulas, class upgrade trees, enemy definitions, and story text. Key reference files:
- `EchoesOfChoice/CharacterClasses/Common/BaseFighter.cs` -- stat model
- `EchoesOfChoice/CharacterClasses/Common/Ability.cs` -- ability model
- `EchoesOfChoice/Battles/Battle.cs` -- damage formulas, ATB system, AI
- `EchoesOfChoice/CharacterClasses/Fighter/`, `Mage/`, `Entertainer/`, `Scholar/` -- all 52 classes
- `EchoesOfChoice/CharacterClasses/Enemies/` -- all enemy types
- `EchoesOfChoice/Echoes of Choice/Program.cs` -- story flow, party creation
