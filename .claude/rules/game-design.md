# Echoes of Choice -- Design Reference

This file documents the design decisions from the original tactical RPG implementation. It is kept as reference for building the new visual version. The tactical game code is preserved in `EchoesOfChoiceTactical/reference/`.

The new project is a visual RPG built in Godot 4 with GDScript at `EchoesOfChoiceTactical/`, based on the C# console RPG at `EchoesOfChoice/`.

## Class System

51 player classes. 5 base -> 14 Tier 1 -> 30 Tier 2 + 2 Royal via upgrades. See `class-trees.md` for the full tree structure. The C# codebase at `EchoesOfChoice/CharacterClasses/` is the authoritative source for stat values and ability definitions.

## Combat Formulas (from C# version)

- Physical: `attacker.phys_atk - defender.phys_def` (min 0)
- Magic: `ability.modifier + attacker.mag_atk - defender.mag_def`
- Mixed: `ability.modifier + avg(phys+mag atk) - avg(phys+mag def)`
- Crit: roll 1-10, crit if > (10 - crit_chance), adds crit_damage
- Dodge: roll 1-10, dodge if <= dodge_chance

## Previous Tactical Design (reference only)

The following systems were implemented in the tactical version and are preserved in `reference/`:

- **ATB turn system**: Speed accumulates to 100 threshold, act-then-move, facing selection
- **Grid movement**: BFS flood fill, A* pathfinding, elevation with jump stats
- **Reactions**: 6 types (opportunity attack, flanking strike, snap shot, reactive heal, damage mitigation, bodyguard)
- **Abilities**: 5 types (damage, heal, buff, debuff, terrain), AoE shapes, elevation-aware range
- **Progression**: XP/JP economy, class unlock/upgrade via JP thresholds, gold economy, equipment tiers
