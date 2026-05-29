---
paths:
  - "**/*.gd"
---

# Parting Shadows -- Design Reference

This file documents the design decisions for Parting Shadows.

The project is a visual RPG built in Godot 4 with GDScript at `PartingShadows/`.

## Class System

56 player classes. 6 base (Tier 0) -> 16 Tier 1 -> 34 Tier 2. See `class-trees.md` for the full tree structure. The GDScript data layer at `PartingShadows/scripts/data/` is the authoritative source for stat values and ability definitions.

## Combat Formulas

- Physical: `attacker.phys_atk - defender.phys_def` (min 0)
- Magic: `ability.modifier + attacker.mag_atk - defender.mag_def`
- Mixed: `ability.modifier + avg(phys+mag atk) - avg(phys+mag def)`
- Crit: roll 1-100, crit if <= crit_chance, adds crit_damage
- Dodge: roll 1-100, dodge if <= dodge_chance

## Difficulty Setting

Player-selectable in Settings. Affects enemy stats, not AI (AI is unified score-based for all units).

- **Story**: Enemy HP -40%, ATK (phys+mag) -25%. Shorter fights for story-focused players.
- **Normal**: No stat changes. Default.
- **Hard**: Enemy ATK (phys+mag) +15%, SPD +10%. Harder across all fights including endgame.

Stored in `SettingsManager.difficulty` (0/1/2), applied in `battle.gd _start_battle()` before `engine.start_battle()`.

## Current Battle System

- **ATB turn system**: Speed accumulates to 100 threshold, turn order prediction display
- **Abilities**: 5 types (damage, heal, buff, debuff, terrain), AoE targeting
- **Status effects**: Buff/debuff indicators on fighter bars, stat modification tracking
- **DOT/HOT**: Damage/healing over time ticks are batched into a single message per fighter per turn
- **Progression**: Level-up after battles, class upgrades at town stops (T0 -> T1 -> T2)
