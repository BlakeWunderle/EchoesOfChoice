---
name: battle-simulator
description: Run battle simulations for Echoes of Choice to test balance across all party compositions. Use when the user wants to simulate battles, check win rates, tune enemy stats, balance combat, or verify the difficulty gradient.
---

# Battle Simulator

Simulates every valid party composition against each battle. Difficulty follows a gradient from 90% player win rate (first battle) to 60% (finale), with +/- 3% tolerance per stage.

## Running Simulations

### Auto Mode (Recommended)

Use `--auto` to dynamically calculate sims per combo based on party tier, targeting a **minimum of 200k total battles** per stage. This ensures statistically equivalent coverage regardless of tier.

```bash
# Auto sims for a progression stage
dotnet run --project BattleSimulator -- --auto --progression 2

# Auto sims for all battles
dotnet run --project BattleSimulator -- --auto --all

# Auto sims for a single battle
dotnet run --project BattleSimulator -- --auto CityStreetBattle
```

### Manual Mode

Override with `--sims` when doing quick iteration or final validation.

```bash
# Quick iteration (50 sims for fast direction)
dotnet run --project BattleSimulator -- --sims 50 --progression 6

# Validation pass (200 sims for confidence at higher tiers)
dotnet run --project BattleSimulator -- --sims 200 --progression 6

# List all battles with targets
dotnet run --project BattleSimulator -- --list

# Interactive menu
dotnet run --project BattleSimulator
```

## Sim Counts by Tier

The `--auto` flag ensures ~200k+ total battles per stage by scaling sims inversely with combo count:

| Tier | Combos | Auto Sims/Combo | Total Battles |
|------|--------|-----------------|---------------|
| Base | 20 | 10,000 | 200,000 |
| Tier 1 | 560 | 358 | ~200,500 |
| Tier 2 | 4,960 | 41 | ~203,400 |
| Tier 2 + Recruit | 9,920 | 40 | ~396,800 |

**For tuning iterations**, start with `--sims 50` at higher tiers to get quick directional results, then validate with `--auto` or `--sims 200` once close to target.

## Difficulty Gradient

| Stage | Target | Range | Battles |
|-------|--------|-------|---------|
| 0 | 90% | 87-93% | CityStreetBattle |
| 1 | 86% | 83-89% | ForestBattle |
| 2 | 81% | 78-84% | Smoke, DeepForest, Clearing, Shore, Ruins |
| 3 | 77% | 74-80% | Cave, Beach, Portal |
| 4 | 73% | 70-76% | Box, Cemetery, Lab, Army |
| 5 | 69% | 66-72% | MirrorBattle |
| 6 | 64% | 61-67% | ReturnToCityBattle 1-4 |
| 7 | 57.5% | 55-60% | ElementalBattle1 (with recruit) |
| 7 | 60% | 57-63% | ElementalBattle 2-4 (with recruit) |

Battles at the same stage are alternate paths — players encounter one, not all. EB1 targets lower because it has 3 elementals vs 2.

## Combo Counts by Tier

Parties are generated as multisets of 3 from the 4 base archetypes (Fighter, Mage, Entertainer, Scholar). Duplicate archetypes are allowed but must take different upgrade paths at Tier 1 and Tier 2.

| Tier | Combos | How |
|------|--------|-----|
| Base | 20 | Multisets of 3 from 4 archetypes |
| Tier 1 | 560 | 20 multisets x upgrade permutations (divergence enforced) |
| Tier 2 | 4,960 | 20 multisets x full upgrade chain permutations |
| Tier 2 + Recruit | 9,920 | 4,960 x 2 recruit variants (per ElementalBattle) |

## Level-Up Distribution

`CreateFighter` distributes total level ups across tiers to match the actual game flow, rather than applying all level ups at the final tier.

| Tier | Level Ups at This Tier | When |
|------|----------------------|------|
| Base | 1 | After CityStreetBattle, before Tier 1 upgrade |
| Tier 1 | 2 | After ForestBattle (with upgrade) + after Stage 2 battle |
| Tier 2 | Remaining | After Stage 3 (with upgrade) through ReturnToCityBattle |

Constants in `PartyComposer`: `LevelsAsBase = 1`, `LevelsAsTier1 = 2`. For a Tier 2 party with 7 total level ups, distribution is 1 base + 2 Tier 1 + 4 Tier 2. This correctly uses each tier's growth rates.

## Recruited Character (Progression 7)

After winning a ReturnToCityBattle (Progression 6), the player recruits one of two NPCs as a 4th party member. MirrorBattle randomly assigns which ReturnToCityBattle (and thus which recruit pair and ElementalBattle) the player gets.

Each ElementalBattle uses `GetTier2PartiesWithRecruits()` with its battle-specific `RecruitSpec[]`, doubling the combo count to 9,920 per battle.

| ElementalBattle | ReturnToCityBattle | Recruit Pair | Base Level |
|---|---|---|---|
| 1 | 1 | Seraph / Fiend | 9 |
| 2 | 2 | Druid / Necromancer | 9 |
| 3 | 3 | Psion / Runewright | 10 |
| 4 | 4 | Shaman / Warlock | 9 |

Recruit stats are static -- their `IncreaseLevel()` only increments Level with no stat gains. `RecruitSpec` has zero adjustments and zero level-ups; `CreateRecruit` just instantiates the class as-is. Recruits are overpowered companions at their full battle power level.

- The CLASS BREAKDOWN output shows each recruit type as a separate entry
- Compare recruit pairs across ElementalBattles to ensure no path is significantly harder
- For detailed elemental tuning (including EB1's tighter 55-60% target), use the **elemental-balance** skill

## Parallel Execution

### Multi-stage parallelism (--all, --progression)

When running multiple stages via `--all` or `--progression`, the simulator uses `SimulateMultipleStages()` which flattens all (stage, combo) pairs into a **single parallel work queue**. This eliminates idle CPU time between sequential stage boundaries and provides better load balancing across stages with different combo counts.

### Single-stage parallelism

Single-stage runs (interactive menu, single battle CLI) use `Parallel.ForEach` across combos within that stage.

### Performance notes

- Console output is suppressed once globally via `Console.SetOut(TextWriter.Null)` rather than per-stage
- Party descriptions are cached at construction time (`PartyDefinition._description`) to avoid creating fighter instances during the hot simulation loop
- `MaxDegreeOfParallelism = Environment.ProcessorCount` prevents thread pool oversubscription

## Tuning Workflow

For the full iterative balance process (enemy tuning → power curve validation → class win rate banding), use the **balance-feedback-loop** skill for Progressions 0-6 and the **elemental-balance** skill for Progression 7. The guidance below covers individual simulation runs.

### Progressive Approach (Important!)

**Always balance one progression stage at a time** to avoid cascade effects from stat adjustments.

1. Start at Progression 0, work forward
2. Within a stage, balance all battles before moving on
3. Prefer adjusting **enemy-specific stats** over player class stats to avoid cross-battle imbalances
4. Use this iteration loop:
   - **Quick scan**: `--sims 50` to get direction
   - **Tune**: Adjust stats, re-run at 50 sims
   - **Validate**: Once close, run `--auto` or `--sims 200` to confirm PASS

### To make a battle easier (TOO HARD)
- Lower enemy base stats in `CharacterClasses/Enemies/<EnemyName>.cs` (Health, PhysicalAttack, MagicAttack)
- Reduce enemy ability Modifier values
- Reduce growth rates in enemy `IncreaseLevel()`
- Remove enemies from the battle

### To make a battle harder (TOO EASY)
- Raise enemy base stats in `CharacterClasses/Enemies/<EnemyName>.cs`
- Increase enemy ability Modifier values
- Increase growth rates in enemy `IncreaseLevel()`
- Add stronger abilities or additional enemies

## Per-Class Breakdown

The simulator reports individual class win rates and flags classes below `TargetWinRate * 0.60` as **WEAK**. Early-game weakness is acceptable for "late bloomer" classes (e.g., Scholar) as long as they strengthen in later progressions.

When interpreting CLASS BREAKDOWN results, use the **class-reference** skill to:
- Map each class name to its archetype and upgrade tree
- Check whether a weak/strong class's sibling (same Tier 1 parent) shows the same pattern — this distinguishes tree-level problems from individual class issues
- Look up class abilities to understand matchup-specific performance (e.g., a class with only physical damage abilities will struggle against high-PhysDef enemies)

For Progression 7, Seraph and Fiend appear in the class breakdown alongside player classes. Because every combo includes exactly one recruit, their win rates reflect overall balance impact rather than composition variance.

## Battle → Enemy Mapping

| Battle | Prog | Enemies | Format |
|---|---|---|---|
| CityStreetBattle | 0 | 3x Thug | 3v3 |
| ForestBattle | 1 | Bear, BearCub | 3v2 |
| SmokeBattle | 2 | 3x Imp | 3v3 |
| DeepForestBattle | 2 | Witch, Wisp, Sprite | 3v3 |
| ClearingBattle | 2 | Satyr, Nymph, Pixie | 3v3 |
| ShoreBattle | 2 | 3x Siren | 3v3 |
| RuinsBattle | 2 | 3x Shade | 3v3 |
| CaveBattle | 3 | FireWyrmling, FrostWyrmling | 3v2 |
| BeachBattle | 3 | Captain, 2x Pirate | 3v3 |
| PortalBattle | 3 | Hellion, Fiendling | 3v2 |
| BoxBattle | 4 | Harlequin, Chanteuse, Ringmaster | 3v3 |
| CemeteryBattle | 4 | 3x Zombie | 3v3 |
| LabBattle | 4 | Android, Machinist, Ironclad | 3v3 |
| ArmyBattle | 4 | Commander, Draconian, Chaplain | 3v3 |
| MirrorBattle | 5 | Nx Shadow clones (98% ATK copies of party) | 3vN |
| ReturnToCityBattle1 | 6 | Seraph, Fiend | 3v2 |
| ReturnToCityBattle2 | 6 | Druid, Necromancer | 3v2 |
| ReturnToCityBattle3 | 6 | Psion, Runewright | 3v2 |
| ReturnToCityBattle4 | 6 | Shaman, Warlock | 3v2 |
| ElementalBattle1 | 7 | AirElemental, WaterElemental, FireElemental | 4v3 |
| ElementalBattle2 | 7 | WaterElemental, FireElemental | 4v2 |
| ElementalBattle3 | 7 | AirElemental, WaterElemental | 4v2 |
| ElementalBattle4 | 7 | AirElemental, FireElemental | 4v2 |

Enemy files are in `CharacterClasses/Enemies/`. When tuning a battle, always check this table first to know which enemy files to modify and avoid name collisions (e.g., Shade is a Prog 2 enemy, not the same as the PortalBattle Fiendling).

## Key Files

| File | Purpose |
|------|---------|
| `BattleSimulator/Program.cs` | CLI with `--auto`, `--sims`, `--progression`, interactive menu |
| `BattleSimulator/SimulationRunner.cs` | Parallel simulation engine with `SimulateStage` (single) and `SimulateMultipleStages` (multi-stage flattened) |
| `BattleSimulator/PartyComposer.cs` | Generates all valid party compositions per tier, including recruit variants |
| `BattleSimulator/BattleStage.cs` | Defines all stages with target win rates and progression |

## How It Works

- Party members run as AI (`IsUserControlled = false`) using same logic as enemies
- `Battle.BeginBattle()` detects which team a unit is on and targets the opposite side
- Console output suppressed via `Console.SetOut(TextWriter.Null)` during simulation
- Multi-stage runs flatten all work into a single `Parallel.ForEach` for maximum CPU utilization
- Single-stage runs use `Parallel.ForEach` across combos
- `--auto` calculates: `sims = max(40, ceil(200000 / partyCount))`

## Related Skills

| Skill | When to Use |
|-------|-------------|
| **class-reference** | Map class names to upgrade trees, archetypes, and abilities; check sibling classes for tree-level analysis |
| **balance-feedback-loop** | Full iterative balance pass for Prog 0-6 (enemy tuning → power curve → class banding) |
| **elemental-balance** | Dedicated tuning pass for Prog 7 ElementalBattles (run after Prog 0-6 is balanced) |
| **character-stat-tuning** | Detailed guidance for adjusting individual class stats, abilities, and growth |
| **party-comp-balance** | Analyzing composition-level balance (spread, synergies, outlier combos) |

## Character Upgrade Tree

See [upgrade-tree.md](upgrade-tree.md) for full class progression paths.
