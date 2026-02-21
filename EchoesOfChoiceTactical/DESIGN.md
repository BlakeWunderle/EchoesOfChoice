# Echoes of Choice Tactical -- Design Document

A tactical RPG reimagining of Echoes of Choice, built in Godot 4 with GDScript. The original console-based RPG (C#) lives at `../EchoesOfChoice/` and serves as the reference for all game content (stats, abilities, classes, story).

## Engine

**Godot 4** (MIT License). Free forever, no royalties, no revenue cap. Only obligation: include MIT license notice in credits.

## Project Structure

```
EchoesOfChoiceTactical/
  project.godot
  scenes/
    battle/
      BattleMap.tscn/.gd       -- Main battle scene (grid + units + UI + AI)
      TurnManager.gd           -- ATB turn system
      GridOverlay.gd           -- Tile highlight overlays
      GridCursor.gd/.tscn      -- Player cursor
    units/
      Unit.tscn/.gd            -- Unit node (stats, movement, facing, reactions)
    ui/                        -- (Phase 9: HUD, ability menu, stat panels)
    maps/                      -- (Phase 11: per-battle map scenes)
  resources/
    classes/                   -- FighterData .tres per class (Phase 10)
    abilities/                 -- AbilityData .tres per ability (Phase 10)
    enemies/                   -- FighterData .tres per enemy type
    tilesets/                  -- TileSet resources
  scripts/
    data/
      enums.gd                -- All game enums
      fighter_data.gd          -- Class stat/growth resource
      ability_data.gd          -- Ability definition resource
      modified_stat.gd         -- Buff/debuff tracking
      terrain_effect.gd        -- Dynamic terrain tracking
    systems/
      grid.gd                 -- Grid engine (BFS, pathfinding, LOS, terrain)
      combat.gd                -- Damage formulas, reaction damage calcs
      reaction_system.gd       -- All 6 reaction types
    autoload/
      game_state.gd            -- Global state singleton
```

---

## Core Design Decisions

### Turn System: Act-then-Move

- ATB: Speed accumulates each tick, unit acts at 100. Same model as FFT's Charge Time.
- On their turn, a unit can **Act** (attack/ability) and **Move** in either order. Both are optional.
- "Wait" ends the turn immediately after choosing facing direction.
- This enables hit-and-run (attack then retreat), advance-and-strike (move then attack), or hold position.

### Elevation

- Maps have integer height levels (0, 1, 2, 3).
- **Climbing** costs +1 movement per elevation gained. Can only climb if height diff <= unit's `jump` stat.
- **Descending** is free (no extra cost, no jump check).
- **Ranged bonus**: Ranged abilities (range >= 2) gain +1 range per elevation level above the target. An archer at elevation 2 with base range 4 can hit targets at elevation 0 up to 6 tiles away.
- **Melee constraint**: Can only hit adjacent tiles within 1 elevation difference.

### Movement Stats (Per Class)

Each of the 52 classes has individual `movement` (horizontal tiles) and `jump` (max climbable height) values.

| Role | Example Classes | Movement | Jump |
|------|----------------|----------|------|
| Mobile melee | Ranger, Dervish | 5 | 3 |
| Standard melee | Squire, Duelist | 4-5 | 2 |
| Heavy tank | Warden, Paladin | 3 | 1 |
| Cavalry | (future) | 6-7 | 1 |
| Mage / Scholar | Mage, Artificer | 3 | 1 |
| Support | Bard, Entertainer | 4 | 2 |
| Special | Cosmologist | 3 | 2 |

### Facing

- Units face one of 4 cardinal directions (N/S/E/W).
- Auto-set by last action/movement direction.
- Player can optionally rotate facing at end of turn.
- Affects **Snap Shot** reaction trigger (only fires from front).
- Future: could affect rear-attack damage bonuses.

### Reactions (One Per Round, Role-Based)

Each unit gets **one reaction per round** (refreshes at start of their turn). Available reactions depend on class:

| Reaction | Role | Trigger | Effect |
|----------|------|---------|--------|
| Opportunity Attack | Melee | Enemy leaves adjacent tile | Free melee hit (~100% damage) |
| Flanking Strike | Melee | Ally attacks enemy you're adjacent to | Bonus hit (~50% damage) |
| Snap Shot | Ranged | Enemy enters adjacent tile from front facing | Weak ranged shot (~50% damage) |
| Reactive Heal | Healer | Ally within 3 tiles takes damage | Small heal (~30-40%) |
| Damage Mitigation | Support | Ally within 3 tiles takes damage | Reduce damage by ~25% |
| Bodyguard | Tank | Adjacent ally takes damage | Absorb 40-50% onto self |

**Key tension**: A unit with multiple reaction types must choose which to spend (e.g., tank: opportunity attack vs. bodyguard).

**Defensive reaction chaining**: When damage is dealt, Bodyguard is checked first (adjacent tank absorbs portion), then Damage Mitigation (support reduces remainder), then damage is applied, then Reactive Heal triggers.

### Abilities

Five types:
- **Damage**: Offensive (physical/magic/mixed)
- **Heal**: Restore HP to allies
- **Buff**: Boost ally stats for N turns
- **Debuff**: Reduce enemy stats for N turns
- **Terrain**: Create/destroy grid tiles (e.g., Ice Wall creates impassable tiles for 3 turns)

Each ability has: range, AoE shape (Single/Line/Cross/Diamond/Square/Global), AoE size, mana cost.

### Combat Formulas (from C# version)

- Physical: `phys_atk - phys_def` (min 0)
- Magic: `modifier + mag_atk - mag_def` (min 0)
- Mixed: `modifier + avg(phys+mag atk) - avg(phys+mag def)` (min 0)
- Crit: roll 1-10, crit if > (10 - crit_chance), adds crit_damage flat
- Dodge: roll 1-10, dodge if <= dodge_chance

### Map Design

Mixed sizes based on battle context:
- **Caves**: 8x6 (tight corridors, chokepoints, destructible boulders)
- **Forests**: 10x8 to 12x10 (scattered trees, ridges)
- **Clearings/Arenas**: 14x10 to 14x12 (open, elevation features like central hills)
- **Ruins**: 12x10 (crumbling walls, staircases, multiple height levels 0-3)
- **City**: 10x8 (buildings as walls, rooftops at elevation 2)

Maps include:
- Terrain (walls, floors, water, rough terrain, elevation)
- Destructible objects (crates, boulders) with HP
- Player and enemy spawn points

### Tactical AI

Evaluates every (move_to, action) pair with a scoring function:
- Damage dealt, kill potential, positional safety
- Healer/support positioning within range of allies
- Elevation advantage seeking for ranged units
- Opportunity attack awareness (avoid leaving threatened tiles)
- Snap shot avoidance (approach ranged units from side/rear)
- Bodyguard awareness (try to separate tank from squishy targets)
- Terrain ability usage (block chokepoints, cut off retreat)

---

## Build Progress

| Phase | Description | Status |
|-------|-------------|--------|
| 1 | Godot project setup, folder structure | DONE |
| 2 | Grid system with elevation, tile types | DONE |
| 3 | Unit scene with stats, movement, jump | DONE |
| 4 | BFS movement, pathfinding, animation | DONE |
| 5 | Turn manager, act-then-move, reactions, facing | DONE |
| 6 | Ability system with range, AoE, terrain abilities | DONE |
| 7 | Combat formulas, crits, dodge, buffs/debuffs | DONE |
| 8 | Tactical AI with positional scoring | TODO |
| 9 | Battle UI / HUD (polished) | TODO |
| 10 | Port all 52 classes + abilities + enemies | TODO |
| 11 | Design maps for all battles | TODO |
| 12 | Story flow, progression, save system | TODO |

### Milestones

- **Milestone 1** (Phases 1-5): Test map, units move, turns cycle -- DONE
- **Milestone 2** (Phases 6-7): Combat works with range/AoE -- DONE
- **Milestone 3** (Phases 8-9): AI plays well, UI is polished -- TODO
- **Milestone 4** (Phases 10-12): Full game content, all battles playable -- TODO

---

## Reference: Original C# Codebase

The console RPG at `../EchoesOfChoice/` contains all game content:

- `CharacterClasses/Common/BaseFighter.cs` -- stat model, level-up, upgrades
- `CharacterClasses/Common/Ability.cs` -- ability definition model
- `Battles/Battle.cs` -- damage formulas, ATB loop, buff/debuff, AI
- `CharacterClasses/Fighter/` -- Squire and all Fighter-tree classes
- `CharacterClasses/Mage/` -- Mage and all Mage-tree classes
- `CharacterClasses/Entertainer/` -- Entertainer and all Entertainer-tree classes
- `CharacterClasses/Scholar/` -- Scholar and all Scholar-tree classes
- `CharacterClasses/Enemies/` -- All enemy types
- `CharacterClasses/Abilities/` -- All ability subclasses
- `Echoes of Choice/Program.cs` -- Party creation, story text, game loop
- `BattleSimulator/` -- Headless balance testing

### Class Structure (52 classes)

4 base classes -> 16 Tier 1 (4 per base) -> 32 Tier 2 (2 per Tier 1):
- Squire -> Duelist, Warden, Ranger, Knight -> ... (8 Tier 2)
- Mage -> Mistweaver, Firebrand, Cryomancer, Stormcaller -> ... (8 Tier 2)
- Entertainer -> Bard, Dervish, Jester, Acrobat -> ... (8 Tier 2)
- Scholar -> Artificer, Cosmologist, Alchemist, Tactician -> ... (8 Tier 2)

### Progression

1. Start with 3 party members (choose from 4 base classes)
2. CityStreetBattle (Stage 0)
3. ForestBattle (Stage 1) -> Tier 1 upgrade
4. Branching battles (Stages 2-3)
5. PortalBattle -> Tier 2 upgrade
6. More battles (Stages 4-5)
7. MirrorBattle -> ReturnToCity battles (recruit an enemy)
8. ElementalBattle finale (4-member party: 3 players + recruit)
