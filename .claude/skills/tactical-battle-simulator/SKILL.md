---
name: tactical-battle-simulator
description: Run battle simulations for the Godot tactical game (EchoesOfChoiceTactical). Use when the user wants to simulate tactical battles, check win rates, tune enemy stats, balance combat, or verify the difficulty gradient for the 5-member party system.
---

# Tactical Battle Simulator

All paths are relative to the workspace root. The Godot project lives at `EchoesOfChoiceTactical/`.

Simulates party compositions against tactical battles to verify balance. The tactical game uses a **5-member party** (1 player character + 4 recruited guards) and a different combat system than the C# text-based game.

> **STATUS: Simulator Not Yet Built.** The tactical game does not yet have an automated simulator. This skill documents the design and intended workflow so it can be built and used. For now, balance testing is manual (play the battle, observe results).

## Simulator Design (To Be Built)

The tactical simulator needs to be a headless Godot scene (or GDScript tool) that:

1. Instantiates a battle from a `BattleConfig`
2. Runs all units as AI (player units use the same AI as enemies)
3. Resolves the battle to completion
4. Records win/loss and per-unit stats (XP gained, damage dealt, etc.)
5. Repeats N times per party composition
6. Reports aggregate win rates

### Key Differences from C# Simulator

| Aspect | C# Game | Tactical Game |
|--------|---------|---------------|
| Party size | 3 | 5 (player + 4 guards) |
| Party generation | Multisets of 3 from 4 archetypes | Player picks class + 4 guards from 4 base classes |
| Combat system | Turn-based text | Grid-based tactical with movement, facing, elevation |
| Enemy data | C# class constructors | `.tres` FighterData resources |
| Level system | Auto-level per progression | XP-based with catch-up/slowdown |
| Class upgrade | Item-gated | JP-gated at towns |

### Party Composition Space

With a 5-member party where each slot picks from 4 base classes (allowing duplicates), the total compositions are multisets of 5 from 4 = **56 unique compositions**. At Tier 1 (16 classes), this expands significantly. At Tier 2 (32 classes), the space is very large.

For practical simulation, use stratified sampling: ensure every class appears in at least N compositions per run.

## Difficulty Gradient

The tactical game follows a similar gradient to the C# game but adapted for 5v5 and mixed mob/boss encounters:

| Stage | Target | Range | Battles |
|-------|--------|-------|---------|
| 0 | 90% | 87-93% | City Street (5v5) |
| 1 | 86% | 83-89% | Forest (5v5) |
| 1 (opt) | 85% | 82-88% | Village Raid (5v5, optional) |
| 2 | 81% | 78-84% | Smoke, Deep Forest, Clearing, Ruins (5v5) |
| 3 | 77% | 74-80% | Cave (5v4), Portal (5v4) |
| 3 (opt) | 76% | 73-79% | Inn Ambush (5v5, optional) |
| 4 | 73% | 70-76% | Box, Cemetery, Lab, Army |
| 5 | 69% | 66-72% | Mirror |
| 6 | 64% | 61-67% | Return to City 1-4 |
| 7 | ~58% | 55-61% | Elemental battles |

Optional town battles (Village Raid, Inn Ambush) target slightly higher win rates since they reward story flags rather than progression.

## Battle -> Enemy Mapping

| Battle | Prog | Enemies | Format |
|--------|------|---------|--------|
| city_street | 0 | 3 Thug + Street Tough + Hex Peddler | 5v5 |
| forest | 1 | Bear + Bear Cub + 2 Wolf + Wild Boar | 5v5 |
| village_raid | 1 | 2 Goblin + Goblin Archer + Goblin Shaman + Hobgoblin | 5v5 |
| smoke | 2 | 4 Imp + Fire Spirit | 5v5 |
| deep_forest | 2 | Witch + 2 Wisp + 2 Sprite | 5v5 |
| clearing | 2 | Satyr + 2 Nymph + 2 Pixie | 5v5 |
| ruins | 2 | 3 Shade + Wraith + Bone Sentry | 5v5 |
| cave | 3 | Fire Wyrmling + Frost Wyrmling + 2 Cave Bat | 5v4 |
| portal | 3 | Hellion + 2 Fiendling + Imp | 5v4 |
| inn_ambush | 3 | 2 Shadow Hound + Night Prowler + Dusk Moth + Gloom Stalker | 5v5 |

Progression 4+ battles use placeholder enemies (not yet defined with specific .tres files).

## Tuning Workflow

### To make a battle easier (TOO HARD)
- Lower enemy base stats in the `.tres` file (`resources/enemies/<enemy>.tres`)
- Reduce ability `modifier` values in `resources/abilities/<ability>.tres`
- Remove an enemy from the battle config in `scripts/data/battle_config.gd`

### To make a battle harder (TOO EASY)
- Raise enemy base stats in the `.tres` file
- Increase ability `modifier` values
- Add stronger abilities or additional enemies in the battle config

### XP/JP Impact on Balance
The tactical game's XP catch-up/slowdown system (defined in `scripts/data/xp_config.gd`) means unit levels are soft-capped relative to progression. When simulating, units should be initialized at the expected level for the progression stage (defined as `progression_stage + 1`).

## Key Files

| File | Purpose |
|------|---------|
| `EchoesOfChoiceTactical/scripts/data/battle_config.gd` | Battle configurations (enemy composition, placement) |
| `EchoesOfChoiceTactical/scripts/data/map_data.gd` | Progression stages, node connections |
| `EchoesOfChoiceTactical/scripts/data/xp_config.gd` | XP/JP constants, level-up thresholds, catch-up scaling |
| `EchoesOfChoiceTactical/scripts/data/fighter_data.gd` | FighterData resource class (stats, growth, abilities) |
| `EchoesOfChoiceTactical/scripts/data/ability_data.gd` | AbilityData resource class |
| `EchoesOfChoiceTactical/resources/enemies/*.tres` | Enemy stat definitions |
| `EchoesOfChoiceTactical/resources/abilities/*.tres` | Ability definitions |
| `EchoesOfChoiceTactical/resources/classes/*.tres` | Player class definitions |
| `EchoesOfChoiceTactical/scenes/battle/BattleMap.gd` | Battle logic, config routing |

## Related Skills

| Skill | When to Use |
|-------|-------------|
| **tactical-balance-feedback-loop** | Full iterative balance pass for Prog 0-6 |
| **tactical-elemental-balance** | Dedicated tuning pass for Prog 7 |
| **tactical-party-comp-balance** | Analyzing composition-level balance |
| **character-stat-tuning** | Adjusting individual class/enemy stats and abilities |
| **class-reference** | Map class names to upgrade trees and archetypes |

## Character Upgrade Tree

See the [class-reference skill](../class-reference/SKILL.md) for the full upgrade tree (shared between both games).
