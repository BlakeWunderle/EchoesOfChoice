---
name: tactical-party-comp-balance
description: Test and analyze party composition balance in the Godot tactical game (EchoesOfChoiceTactical). Use when checking if specific 5-member party compositions are too strong or weak, identifying class synergies/anti-synergies, finding outlier compositions, or ensuring no party feels unwinnable or trivial.
---

# Tactical Party Composition Balance

All paths are relative to the workspace root. The Godot project lives at `EchoesOfChoiceTactical/`.

This skill guides analysis of *party-level* balance for the tactical game's 5-member party system. The player chooses 1 class for themselves + 4 guards, each from the 4 base archetypes (duplicates allowed).

> **STATUS: Simulator Not Yet Built.** Until automated simulation exists, composition analysis relies on manual playtesting and theoretical analysis based on stat matchups.

## Composition Space

### Base Tier (4 classes)

5-member party, picking from 4 base classes with replacement: **56 unique multiset compositions**.

Examples:
- 5 Squires (all-Fighter)
- 2 Squire + 2 Mage + 1 Entertainer (balanced)
- 1 of each + 1 extra (4+1 pattern)

### Tier 1 (16 classes)

The space expands dramatically when each archetype has 4 Tier 1 options. With divergence enforced (duplicate archetypes must take different upgrade paths), the combinatorics grow but remain manageable for sampling.

### Tier 2 (32 classes)

Full upgrade permutations create thousands of unique compositions. Stratified sampling (ensuring every class appears in at least N tested compositions) is required for practical coverage.

## What to Analyze

### Per-Battle Composition Spread

| Metric | Healthy Range |
|--------|---------------|
| Overall win rate | Within target +/- 3% |
| Best comp win rate | < target + 20% |
| Worst comp win rate | > target - 25% |
| Spread (best - worst) | < 30% |

### 5-Member Tactical Dynamics

The 5-member party creates balance dynamics absent from the C# 3-member game:

| Dynamic | Impact |
|---------|--------|
| **Redundancy** | Losing 1 of 5 units is less devastating than 1 of 3. Fragile classes are more viable. |
| **Role coverage** | With 5 slots, parties can have dedicated tank + healer + DPS + debuffer + flex. Hard to have a "bad" composition. |
| **AoE value** | More party members = more targets for enemy AoE. AoE-heavy enemies punish clumped parties. |
| **Grid positioning** | 5 units must spread across the grid. Movement-limited classes (movement 3) may struggle to engage. |
| **Action economy** | 5 actions per round vs enemies' 4-5. Numerical advantage in actions should be considered. |

### Composition Categories

| Pattern | Example | Expected Behavior |
|---------|---------|-------------------|
| All different + 1 flex | S/M/E/Sc + 1 any | Most versatile, strong baseline |
| Heavy offense (3+ DPS) | S/S/M/M/E | Fast kills, risky if enemies survive |
| Heavy support (3+ support) | E/E/Sc/Sc/M | Very durable, slow damage |
| Mono-archetype (4-5 same) | 5x Squire | Extreme specialization, matchup-dependent |
| Balanced (2+2+1 or 2+1+1+1) | S/S/M/E/Sc | Well-rounded, few weaknesses |

## Common Imbalance Patterns

### 1. One Class Carries Everything
**Symptom:** Party win rate spikes whenever a specific class is included.
**In tactical context:** A class with self-heal + good damage + high movement dominates because it can operate independently on the grid.
**Fix:** Reduce the overperformer's self-sufficiency (lower healing modifier, reduce movement, or increase mana costs).

### 2. Support Classes Are Dead Weight
**Symptom:** Buff/debuff-only classes contribute nothing in 5v5 mob fights where raw damage wins.
**Tactical nuance:** In the C# game, support in a 3-member party is expensive (1/3 of actions). In a 5-member party, 1 support out of 5 is a smaller investment. Support should be MORE viable in tactical, not less.
**If still weak:** The debuff modifiers may be too small relative to the tactical game's stat scale, or buff durations too short to matter.

### 3. Movement-Limited Classes Can't Engage
**Symptom:** Slow classes (movement 3, jump 1) underperform on larger maps.
**Cause:** They spend too many turns walking and too few turns fighting.
**Fix:** Increase movement stat, give them ranged abilities, or reduce map sizes for relevant battles.

### 4. AoE-Heavy Parties Dominate Mob Fights
**Symptom:** Compositions with multiple AoE classes (Firebrand, Stormcaller) crush mob encounters but are balanced against bosses.
**Cause:** AoE abilities hit 3-5 enemies per cast in mob fights, but only 1-2 in boss fights.
**Fix:** This is expected and healthy -- it creates meaningful composition choices. Only intervene if the spread exceeds 30%.

### 5. Position-Dependent Balance
**Symptom:** The same composition performs very differently depending on starting positions.
**Cause:** Grid placement in `battle_config.gd` may favor certain archetypes (e.g., ranged units starting far from melee enemies).
**Fix:** Vary starting positions in the battle config. Consider randomized spawn zones in the simulator.

## Grid-Specific Analysis

### Movement Budget Analysis

For each battle, estimate whether each class can engage by turn 2:

| Class Movement | Grid Width 10 | Can Engage Turn 2? |
|---------------|---------------|---------------------|
| 3 | Starts at x=0-1, enemies at x=8-9 | No (6 tiles, needs 3 turns) |
| 4 | Starts at x=0-1, enemies at x=8-9 | Barely (8 tiles, 2 turns exactly) |
| 5 | Starts at x=0-1, enemies at x=8-9 | Yes (10 tiles, 2 turns) |

Classes with movement 3 need ranged abilities (range 2+) or they waste early turns. Check this against the class's ability set.

### Ability Range Coverage

Map effective threat zones per class:
- **Melee-only** (range 1, movement 4): 5-tile threat radius
- **Ranged** (range 3, movement 3): 6-tile threat radius
- **Mobile melee** (range 1, movement 5-6): 6-7 tile threat radius

If a party has 5 melee-only units, they may clump and expose themselves to AoE. Mixed-range parties naturally spread.

## Testing Workflow

### Manual Playtest Protocol (Until Simulator Exists)

1. Pick a composition category to test (e.g., all-Fighter, balanced, heavy-support)
2. Play the target battle 3-5 times with each composition
3. Record: win/loss, turns to win, units lost, which unit carried
4. Compare across compositions at the same battle
5. Flag compositions that feel unwinnable or trivially easy

### With Simulator (Future)

1. Run target battle with full composition space (or stratified sample)
2. Check spread between best and worst composition
3. Identify classes that appear in all top-5 and all bottom-5 compositions
4. Cross-reference with the tactical-balance-feedback-loop for stage-level analysis

## Key Files

| File | Purpose |
|------|---------|
| `EchoesOfChoiceTactical/scripts/data/battle_config.gd` | Party generation (`_build_party_units`), enemy composition, grid placement |
| `EchoesOfChoiceTactical/resources/classes/*.tres` | Player class stats (base + growth) |
| `EchoesOfChoiceTactical/resources/enemies/*.tres` | Enemy stats |
| `EchoesOfChoiceTactical/scripts/autoload/game_state.gd` | Party member storage, progression tracking |
| `EchoesOfChoiceTactical/scripts/data/map_data.gd` | Progression stages, battle connections |

## Related Skills

| Skill | When to Use |
|-------|-------------|
| **tactical-balance-feedback-loop** | Full iterative balance pass |
| **tactical-battle-simulator** | Running simulations |
| **character-stat-tuning** | Adjusting individual stats/abilities |
| **class-reference** | Map classes to upgrade trees and archetypes |
