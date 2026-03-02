# Echoes of Choice -- Design Reference

This file documents the design decisions for Echoes of Choice.

The project is a visual RPG built in Godot 4 with GDScript at `EchoesOfChoice/`.

## Class System

51 player classes. 5 base -> 14 Tier 1 -> 30 Tier 2 + 2 Royal via upgrades. See `class-trees.md` for the full tree structure. The GDScript data layer at `EchoesOfChoice/scripts/data/` is the authoritative source for stat values and ability definitions.

## Combat Formulas

- Physical: `attacker.phys_atk - defender.phys_def` (min 0)
- Magic: `ability.modifier + attacker.mag_atk - defender.mag_def`
- Mixed: `ability.modifier + avg(phys+mag atk) - avg(phys+mag def)`
- Crit: roll 1-100, crit if <= crit_chance, adds crit_damage
- Dodge: roll 1-100, dodge if <= dodge_chance

## Current Battle System

- **ATB turn system**: Speed accumulates to 100 threshold, turn order prediction display
- **Abilities**: 5 types (damage, heal, buff, debuff, terrain), AoE targeting
- **Status effects**: Buff/debuff indicators on fighter bars, stat modification tracking
- **Progression**: Level-up after battles, class upgrades at town stops (T0 -> T1 -> T2)
