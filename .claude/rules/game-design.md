---
description: Core design decisions for Echoes of Choice Tactical -- all confirmed game mechanics, systems, and rules
alwaysApply: true
---

# Echoes of Choice Tactical -- Design Decisions

This is a tactical RPG built in Godot 4 with GDScript. It is a reimagining of the console-based RPG "Echoes of Choice" (C# project at `EchoesOfChoice/`) as a grid-based tactical game. The tactical project lives at `EchoesOfChoiceTactical/`.

## Turn System

- **ATB (Active Time Battle)**: Speed stat accumulates each tick. At 100, the unit acts. Same as FFT's Charge Time.
- **Act-then-Move**: On their turn, a unit can Act (attack/ability) and Move in either order. Both are optional. "Wait" ends the turn.
- **Facing**: Units face N/S/E/W. Auto-set by last action/movement. Player chooses facing at end of turn. Affects Snap Shot reaction.

## Elevation

- Maps have integer height levels (0, 1, 2, 3).
- Climbing costs +1 movement per elevation gained. A unit can only climb if height difference <= their `jump` stat.
- Descending is free.
- Ranged abilities (range >= 2) gain +1 range per elevation level above the target.
- Melee can only hit adjacent tiles within 1 elevation difference.

## Movement

- Each class has its own `movement` (horizontal tiles) and `jump` (max climbable height) stats.
- BFS flood fill for reachable tiles, A* for pathfinding.
- Examples: Ranger (5 mov, 3 jump), Warden (3 mov, 1 jump), Cavalry (6-7 mov, 1 jump).

## Reactions (one per round, role-based)

Each unit gets ONE reaction per round. Available reactions depend on class role:

- **Opportunity Attack** (melee): Enemy leaves adjacent tile -> free melee hit.
- **Flanking Strike** (melee): Ally attacks enemy this unit is adjacent to -> ~50% damage bonus hit.
- **Snap Shot** (ranged): Enemy enters adjacent tile FROM unit's front facing -> ~50% ranged shot. Side/rear approach avoids it.
- **Reactive Heal** (healer): Ally within 3 tiles takes damage -> small heal (~30-40%).
- **Damage Mitigation** (support): Ally within 3 tiles takes damage -> reduce damage by ~25%.
- **Bodyguard** (tank): Adjacent ally takes damage -> tank absorbs 40-50% onto themselves.

Classes can have multiple reaction types but only use one per round.

## Abilities

Five types: Damage, Heal, Buff, Debuff, Terrain.
- **Terrain abilities** create/destroy grid tiles (e.g., Cryomancer Ice Wall creates impassable tiles for N turns).
- Each ability has: range, AoE shape (Single/Line/Cross/Diamond/Square/Global), AoE size, mana cost.
- Maps include destructible objects (crates, boulders) with HP.

## Combat Formulas (ported from C# version)

- Physical: `attacker.phys_atk - defender.phys_def` (min 0)
- Magic: `ability.modifier + attacker.mag_atk - defender.mag_def`
- Mixed: `ability.modifier + avg(phys+mag atk) - avg(phys+mag def)`
- Crit: roll 1-10, crit if > (10 - crit_chance), adds crit_damage
- Dodge: roll 1-10, dodge if <= dodge_chance

## Map Sizes (mixed by battle)

- Caves: 8x6 (tight, chokepoints)
- Forests: 10x8-12x10 (obstacles, moderate)
- Clearings/Arenas: 14x10-14x12 (open, elevation features)

## Art Style

Placeholder sprites for now, iterate on art later.

## Class System

52 player classes from the C# version. 4 base -> 16 Tier 1 -> 32 Tier 2 via upgrades. Each class has unique movement/jump/reaction values. The C# codebase at `EchoesOfChoice/CharacterClasses/` is the reference for all stat values.

## Progression & economy (tactical-specific)

These mechanics differ from the C# console version. Reference: `GameState`, `XpConfig`, `Unit` (XP/JP), `map_data` (rewards).

### Gold

- **Earned**: Battle wins grant `gold_reward` per node (see `MapData.NODES`; e.g. 50–400 by progression). Awarded in `BattleMap` and shown in battle summary.
- **Stored**: `GameState.gold` (int). Persisted in save. Reset on new game.
- **Spent**: Shop (buy/sell items), Recruit (hire new party members). Use `GameState.add_gold`, `GameState.spend_gold`, `GameState.can_afford`.

### XP (experience)

- **Per-unit**: Each party member has `xp` and `level` (player in `GameState.player_level`, others in `party_members[i].xp` / `level`). Enemies do not gain XP.
- **Earned in battle**: Using abilities grants XP via `Unit.award_ability_xp_jp` (base + bonuses for basic attack, kill, crit). See `XpConfig`: BASE_ABILITY_XP, BASIC_ATTACK_BONUS_XP, KILL_BONUS_XP, CRIT_BONUS_XP.
- **Catchup**: `XpConfig.get_catchup_multiplier(unit_level, progression_stage)` scales XP (e.g. underleveled units get 1.5–2x, overleveled get 0.5x or 0.1x).
- **Level-up**: Threshold = `XpConfig.xp_to_next_level(level)` = `level * 100`. On level-up, XP is consumed and stats from `FighterData.get_stats_at_level(level)` are applied (HP/MP refill, growths).

### JP (job points)

- **Per-unit**: Stored like XP (`party_members[i].jp`, `Unit.jp`). Used for class progression.
- **Earned in battle**: Same ability use as XP. `XpConfig.calculate_jp(class_id, ability)` — base JP per action, extra for "identity" actions (class-specific ability types / stat types in `XpConfig.CLASS_IDENTITY`). Constants: BASE_JP (1), IDENTITY_JP (5).
- **Thresholds**: `XpConfig.TIER_1_JP_THRESHOLD` (50), `TIER_2_JP_THRESHOLD` (100). Used to gate or cost class upgrades (Tier 0 → 1 → 2).

### Class unlock and upgrade

- **Unlock**: Classes are unlocked by story (e.g. player class choice, story unlocks) or by **recruiting** a unit of that class. Unlocks stored in `GameState.unlocked_classes`.
- **Recruit**: New party members are hired with **gold** in Recruit UI. Cost by class tier: `GameState.RECRUIT_COST_BY_TIER` = [100, 300, 600] (Tier 0, 1, 2). Recruited unit gets `level` 1 and `xp`/`jp` 0; their class is fixed at hire.
- **Upgrade (promotion)**: Each class `FighterData` has `tier` (0/1/2) and `upgrade_options` (array of FighterData for next tier). Progression is Base → Tier 1 → Tier 2 along these options. The **mechanics of performing an upgrade** (e.g. spending JP, where in UI) are defined by JP thresholds above; implementation may live in town/barracks or a dedicated upgrade flow. Do not assume the C# version’s upgrade flow — use JP (and thresholds) and gold/recruit as the tactical source of truth.
- **Equipment slots**: Max slots per unit = `GameState.get_max_slots(unit_name)` = tier + 1 (1 base, 2 at Tier 1, 3 at Tier 2). Equipment and item unlock rules use `GameState.get_unit_tier` and item `unlock_tier` / `unlock_class_ids`.
