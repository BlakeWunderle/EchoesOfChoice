---
name: battle-sim
description: Full balance feedback loop for Echoes of Choice. Iterates enemy tuning, player power curve validation, and per-class win rate banding until all stages pass. Use when the user wants to run the full balance loop, do a complete balance pass, iterate on game balance, or ensure the difficulty gradient and class power curve are correct.
---

# Balance Feedback Loop

All paths are relative to the workspace root. The C# project lives at `EchoesOfChoice/`.

Iterative balancing process for all 14 progression stages. Each cycle has three phases that must all pass before the game is considered balanced.

## The Loop

**Work one progression at a time, lowest to highest.** Each progression completes all three phases before moving on. Player class changes cascade forward — adjusting a Tier 1 growth rate at Prog 3 affects every stage from Prog 3 onward but leaves Prog 0-2 untouched.

```
FOR each progression 0 -> 13, in order:
  +-------------------------------------------------+
  |  STEP 1: Enemy Tuning                           |
  |  Stage hits gradient win rate?                   |
  |  NO -> adjust enemy stats -> re-sim -> repeat   |
  |  YES v                                          |
  +-------------------------------------------------+
  |  STEP 2: Power Curve Check                      |
  |  Archetype ranking correct for this stage?       |
  |  NO -> adjust player growth -> restart this prog |
  |  YES v                                          |
  +-------------------------------------------------+
  |  STEP 3: Class Win Rate Band                    |
  |  Every class between 57% and 93%?               |
  |  NO -> buff/nerf outliers -> restart this prog   |
  |  YES -> LOCK this progression, move to next      |
  +-------------------------------------------------+

AFTER all progressions locked:
  -> Final validation pass (--auto --all)
  -> If any stage broke, restart FROM that progression forward
```

### Why This Order Matters

- **Enemy-only changes** (Step 1) don't affect other stages — safe to iterate freely.
- **Player-side changes** (Steps 2-3) cascade forward through every later stage because growth rates compound with level-ups. A Tier 1 buff applies at Prog 3+ and a base stat change applies everywhere.
- By locking stages low-to-high, earlier work is preserved. A player change at Prog 8 only requires re-validating Prog 8-13, not restarting from Prog 0.

### Cascade Scope

| Change Type | Affects | Restart From |
|-------------|---------|-------------|
| Enemy class base stats | The battle using that enemy | Re-sim that battle |
| Enemy ability Modifier | All battles with enemies using that ability | Earliest battle using that ability |
| Player base stats (Squire/Mage/Entertainer/Tinker/Wildling) | ALL stages | Prog 0 |
| Player Tier 1 growth rates | Prog 3+ (Tier 1 and later) | Prog 3 |
| Player Tier 2 growth rates | Prog 8+ (Tier 2 only) | Prog 8 |
| Ability Modifier changes | All stages using that ability | Earliest stage with a class that has the ability |

---

## Enemy Stat Mechanics

Enemy stats work differently from player stats. Understanding this is critical for effective tuning.

### How Enemy Stats Are Calculated

Each enemy constructor uses `Stat(baseMin, baseMax, growthMin, growthMax, level)`:

```csharp
// Example: Raider at level 4
Health = Stat(98, 113, 4, 7, 4);
// Result: random(98, 113) + (4-1) * random(4, 7) = 98-113 + 12-21 = 110-134
```

- The **level parameter is hardcoded** in each Stat() call — it does NOT use the constructor's level argument
- Doing `new Raider(6)` sets `Level = 6` but the Stat() calls still use their hardcoded level (4)
- Growth is applied **once at construction time**, not per-turn

### IncreaseLevel() Is Dead Code for Balance

The `IncreaseLevel()` method on enemies is **never called during battles**. It exists for potential future use but has zero effect on the simulator. Do not waste time tuning enemy IncreaseLevel() growth rates — only the Stat() constructor values matter.

### Tuning Levers (in order of impact)

1. **Base stat ranges** (1st and 2nd params of Stat) — direct control over the stat floor/ceiling
2. **Growth rates** (3rd and 4th params of Stat) — amplified by the hardcoded level; changing growth by +1 at level 4 adds +3 to the stat range
3. **Hardcoded level** (5th param of Stat) — increasing from 4 to 5 adds one more growth roll to every stat
4. **Enemy count** — adding/removing enemies from the battle file (see 3-Enemy Rule below)
5. **Abilities** — changing which abilities the enemy has or their Modifiers
6. **CritChance / DodgeChance** — percentage-based, small changes have noticeable effects

### 3-Enemy Rule

Every battle after WolfForestBattle (Prog 1) must have **at least 3 enemies**, unless it is a boss fight. Boss fights (StrangerTowerBattle, StrangerFinalBattle) and the special MirrorBattle are exempt.

3v2 battles give players a 50% action economy advantage, making stat tuning extremely sensitive. If a battle has only 2 enemies, add a 3rd by duplicating an existing enemy type with a new character name before tuning stats.

---

## Step 1: Enemy Tuning

**Goal:** This stage's overall win rate falls within its target +/- 3%.

### Run sims for the current progression

For Progressions 0-2 (Base classes, 20 combos):
```bash
dotnet run --project EchoesOfChoice/BattleSimulator -- --sims 50 --progression <N>
```

For Progressions 3-7 (Tier 1 classes, 560 combos), use `--sample 100` for fast iteration:
```bash
dotnet run --project EchoesOfChoice/BattleSimulator -- --sample 100 --sims 50 --progression <N>
```

For Progressions 8-13 (Tier 2 classes, 4960 combos), use `--sample 100` for fast iteration:
```bash
dotnet run --project EchoesOfChoice/BattleSimulator -- --sample 100 --sims 50 --progression <N>
```

### Check each battle's STATUS line

- **PASS** -> move to Step 2
- **TOO HARD** -> weaken enemies (lower Stat() ranges in `EchoesOfChoice/CharacterClasses/Enemies/<EnemyName>.cs`, reduce ability Modifiers, lower CritChance/DodgeChance, remove an enemy from the battle)
- **TOO EASY** -> strengthen enemies (raise Stat() ranges, increase ability Modifiers, raise CritChance/DodgeChance, add an enemy to the battle — see 3-Enemy Rule)

All enemy stats are set in their constructor's Stat() calls — battle files just instantiate enemies. Tune the Stat() base ranges and growth params directly. Do NOT waste time changing IncreaseLevel() — it is never called during battles. Avoid touching player classes in this step.

### Re-sim after each change until all battles at this stage show PASS

Use `--sample 100 --sims 50` for quick iteration. Drop `--sample` for Steps 2-3 and final validation, which need the full party list for accurate class breakdowns.

### Difficulty Gradient

| Prog | Target | Range | Tier | Battles |
|------|--------|-------|------|---------|
| 0 | 90% | 87-93% | Base | CityStreetBattle |
| 1 | 88% | 85-91% | Base | WolfForestBattle |
| 2 | 85% | 82-88% | Base | WaypointDefenseBattle |
| 3 | 83% | 80-86% | T1 | HighlandBattle, DeepForestBattle, ShoreBattle |
| 4 | 81% | 78-84% | T1 | MountainPassBattle, CaveBattle, BeachBattle |
| 5 | 79% | 76-82% | T1 | CircusBattle, LabBattle, ArmyBattle, CemeteryBattle |
| 6 | 77% | 74-80% | T1 | OutpostDefenseBattle |
| 7 | 75% | 72-78% | T1 | MirrorBattle |
| 8 | 80% | 77-83% | T2 | ReturnToCityStreetBattle |
| 9 | 78% | 75-81% | T2 | StrangerTowerBattle |
| 10 | 75% | 72-78% | T2 | CorruptedCityBattle, CorruptedWildsBattle |
| 11 | 72% | 69-75% | T2 | TempleBattle, BlightBattle |
| 12 | 69% | 66-72% | T2 | GateBattle, DepthsBattle |
| 13 | 65% | 62-68% | T2 | StrangerFinalBattle |

---

## Step 2: Power Curve Check

**Goal:** The archetype ranking at this stage roughly follows the expected power curve. This is a guideline, not a hard rule — individual battles will naturally favor certain archetypes based on enemy composition. The concern is persistent, stage-wide deviations, not per-battle variation.

### Expected Power Curve (5 Archetypes)

| Archetype | Peak Window | Behavior |
|-----------|-------------|----------|
| **Squire (Fighter tree)** | Prog 0-2 (early) | Highest class win rate at base tier. Strong physical stats out of the gate. Should taper to middle-of-pack by Prog 5+. |
| **Mage** | Prog 3-7 (mid) | Ramps after Tier 1 upgrade. Peaks during mid-game battles with magic scaling. |
| **Entertainer** | Throughout (flexible) | Consistently strong across all stages. Buffs/debuffs scale well. Can lead individual battles but shouldn't have extreme spikes or troughs. Never flagged WEAK. |
| **Tinker (Scholar tree)** | Prog 8-13 (late) | Weakest early but highest growth rates catch up. Utility and tech abilities pay off in complex late fights. Top performer by endgame. |
| **Wildling** | Prog 2-8 (mid-wide) | Nature-based utility and beast synergies. Competitive across mid-game, shouldn't be dominant at early or late extremes. |

Classes that bridge archetypes (e.g., Paladin from Mage tree, Monk from Squire tree) can deviate — they intentionally live between power spikes.

### How to Check

Group classes by archetype in the CLASS BREAKDOWN and average their win rates for the current stage.

- **Prog 0-2:** Squire classes should lead.
- **Prog 3-7:** Mage classes should lead (or be close). Wildling competitive.
- **Prog 8-13:** Tinker classes should lead.
- **Any stage:** Entertainer should be strong. No extreme spikes (>95%) or troughs (<57%). Wildling should stay mid-pack.

If the ranking is roughly correct (or deviations are explained by matchup) -> move to Step 3.

### Fixing Curve Problems

| Problem | Fix | Where | Cascade |
|---------|-----|-------|---------|
| Squire too weak early | Buff Squire base stats | `CharacterClasses/Fighter/Squire.cs` | Restart from Prog 0 |
| Squire too strong late | Reduce Squire T2 growth | T2 Squire class files | Restart from Prog 8 |
| Mage doesn't spike mid | Buff T1 Mage growth | T1 Mage class files (Invoker, Acolyte) | Restart from Prog 3 |
| Entertainer flagged WEAK | Buff Entertainer base or growth | Entertainer class files (Bard, Dervish, Orator) | Restart from affected prog |
| Tinker still weak late | Buff T2 Tinker growth | T2 Tinker class files | Restart from Prog 8 |
| Wildling too weak mid | Buff T1 Wildling growth | T1 Wildling class files (Herbalist, Shaman, Beastcaller) | Restart from Prog 3 |
| Wildling too strong early | Reduce Wildling base stats | `CharacterClasses/Wildling/Wildling.cs` | Restart from Prog 0 |

**After any player-side change, restart from the earliest affected progression** (see Cascade Scope table).

---

## Step 3: Class Win Rate Band

**Goal:** Every individual class's win rate (from CLASS BREAKDOWN) at this stage falls within `target ± 15%`.

### Class Band Formula

The band tracks the stage target, not a fixed range:

- **Floor:** `target - 15%`
- **Ceiling:** `target + 15%`

| Prog | Target | Class Floor | Class Ceiling |
|------|--------|-------------|---------------|
| 0 | 90% | 75% | 100% |
| 1 | 88% | 73% | 100% |
| 2 | 85% | 70% | 100% |
| 3 | 83% | 68% | 98% |
| 4 | 81% | 66% | 96% |
| 5 | 79% | 64% | 94% |
| 6 | 77% | 62% | 92% |
| 7 | 75% | 60% | 90% |
| 8 | 80% | 65% | 95% |
| 9 | 78% | 63% | 93% |
| 10 | 75% | 60% | 90% |
| 11 | 72% | 57% | 87% |
| 12 | 69% | 54% | 84% |
| 13 | 65% | 50% | 80% |

No class should feel unwinnable or trivially easy relative to the stage difficulty.

### How to Check

From this stage's CLASS BREAKDOWN output:

1. **Flag any class below `target - 15%`** — this class makes parties feel hopeless when drafted.
2. **Flag any class above `target + 15%`** — this class trivializes the content.
3. Classes flagged `** WEAK **` by the simulator (below `TargetWinRate * 0.60`) are most urgent.

If all classes are within band -> **LOCK this progression** and move to the next.

### Fixing Outliers

**Class below 57% (underpowered):**

1. Check if this is expected for the power curve (e.g., Tinker at Prog 0 being 65% is fine — below Squire but above 57%).
2. Check the class's sibling (same Tier 1 parent). If both siblings are weak, the problem is likely the Tier 1 parent's growth rates, not the individual Tier 2 class.
3. If it violates the curve OR is below 57%: buff the class.
   - Offensive class: increase primary attack stat growth in `IncreaseLevel()`
   - Support class: ensure it has at least one damage ability alongside buffs
   - Check if it has dead abilities (e.g., MagDef debuff vs physical-only enemies)

**Class above 93% (overpowered):**

1. Reduce its primary stat growth or ability Modifiers.
2. Check if it has self-healing + damage (this combo tends to overperform).

**After any player-side change, restart from the earliest affected progression.**

---

## Final Validation

After all progressions are locked at `--sims 50`, run a full validation pass:

```bash
dotnet run --project EchoesOfChoice/BattleSimulator -- --auto --all
```

This takes 2-5 minutes. Use a 600000ms timeout.

If any stage flips to TOO HARD / TOO EASY at full sample size, make small adjustments and re-validate **from that stage forward**.

---

## Battle -> Enemy Mapping

| Battle | Prog | Enemies | Format |
|--------|------|---------|--------|
| CityStreetBattle | 0 | Thug, Ruffian, Pickpocket | 3v3 |
| WolfForestBattle | 1 | Wolf, Boar | 3v2 |
| WaypointDefenseBattle | 2 | Bandit, Goblin, Hound | 3v3 |
| HighlandBattle | 3 | 2x Raider, Orc | 3v3 |
| DeepForestBattle | 3 | Witch, Wisp, Sprite | 3v3 |
| ShoreBattle | 3 | Siren, 2x Merfolk | 3v3 |
| MountainPassBattle | 4 | Troll, 2x Harpy | 3v3 |
| CaveBattle | 4 | 2x FireWyrmling, FrostWyrmling | 3v3 |
| BeachBattle | 4 | Captain, 2x Pirate | 3v3 |
| CircusBattle | 5 | Harlequin, Chanteuse, Ringmaster | 3v3 |
| LabBattle | 5 | Android, Machinist, Ironclad | 3v3 |
| ArmyBattle | 5 | Commander, Draconian, Chaplain | 3v3 |
| CemeteryBattle | 5 | 2x Zombie, Ghoul | 3v3 |
| OutpostDefenseBattle | 6 | 2x Shade, Wraith | 3v3 |
| MirrorBattle | 7 | Shadow clones (98% stat copies of party) | 3vN |
| ReturnToCityStreetBattle | 8 | RoyalGuard, GuardSergeant, GuardArcher | 3v3 |
| StrangerTowerBattle | 9 | Stranger | 3v1 (boss) |
| CorruptedCityBattle | 10 | Lich, 2x Ghast | 3v3 |
| CorruptedWildsBattle | 10 | Demon, 2x CorruptedTreant | 3v3 |
| TempleBattle | 11 | Hellion, 2x Fiendling | 3v3 |
| BlightBattle | 11 | Dragon, 2x BlightedStag | 3v3 |
| GateBattle | 12 | DarkKnight, 2x FellHound | 3v3 |
| DepthsBattle | 12 | Imp, 2x CaveSpider | 3v3 |
| StrangerFinalBattle | 13 | StrangerFinal | 3v1 (boss) |

Enemy files are in `EchoesOfChoice/CharacterClasses/Enemies/`. When tuning a battle, check this table to know which enemy files to modify.

---

## Iteration Checklist

Copy and track progress. Each progression is locked only after all three steps pass.

```
PROGRESSION 0 (CityStreetBattle, target 87-93%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Squire leads class breakdown
- [ ] Step 3: All classes within target ± 15%
- [ ] LOCKED

PROGRESSION 1 (WolfForestBattle, target 85-91%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Squire leads class breakdown
- [ ] Step 3: All classes within target ± 15%
- [ ] LOCKED

PROGRESSION 2 (WaypointDefenseBattle, target 82-88%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Squire leads (transitioning)
- [ ] Step 3: All classes within target ± 15%
- [ ] LOCKED

PROGRESSION 3 (Highland/DeepForest/Shore, target 80-86%):
- [ ] Step 1: All 3 battles PASS
- [ ] Step 2: Mage leads (or close)
- [ ] Step 3: All classes within target ± 15%
- [ ] LOCKED

PROGRESSION 4 (MountainPass/Cave/Beach, target 78-84%):
- [ ] Step 1: All 3 battles PASS
- [ ] Step 2: Mage leads (or close)
- [ ] Step 3: All classes within target ± 15%
- [ ] LOCKED

PROGRESSION 5 (Circus/Lab/Army/Cemetery, target 76-82%):
- [ ] Step 1: All 4 battles PASS
- [ ] Step 2: Mage leads (or close)
- [ ] Step 3: All classes within target ± 15%
- [ ] LOCKED

PROGRESSION 6 (OutpostDefenseBattle, target 74-80%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Mage leads
- [ ] Step 3: All classes within target ± 15%
- [ ] LOCKED

PROGRESSION 7 (MirrorBattle, target 72-78%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Power curve check
- [ ] Step 3: All classes within target ± 15%
- [ ] LOCKED

PROGRESSION 8 (ReturnToCityStreetBattle, target 77-83%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Tinker leads (or close)
- [ ] Step 3: All classes within target ± 15%
- [ ] LOCKED

PROGRESSION 9 (StrangerTowerBattle, target 75-81%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Tinker leads
- [ ] Step 3: All classes within target ± 15%
- [ ] LOCKED

PROGRESSION 10 (CorruptedCity/CorruptedWilds, target 72-78%):
- [ ] Step 1: Both battles PASS
- [ ] Step 2: Tinker leads
- [ ] Step 3: All classes within target ± 15%
- [ ] LOCKED

PROGRESSION 11 (Temple/Blight, target 69-75%):
- [ ] Step 1: Both battles PASS
- [ ] Step 2: Tinker leads
- [ ] Step 3: All classes within target ± 15%
- [ ] LOCKED

PROGRESSION 12 (Gate/Depths, target 66-72%):
- [ ] Step 1: Both battles PASS
- [ ] Step 2: Tinker leads
- [ ] Step 3: All classes within target ± 15%
- [ ] LOCKED

PROGRESSION 13 (StrangerFinalBattle, target 62-68%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Power curve check
- [ ] Step 3: All classes within target ± 15%
- [ ] LOCKED

FINAL VALIDATION:
- [ ] All Prog 0-13 validated with --auto --all
- [ ] No stage broke at full sample size

RESULT: [ ] ALL LOCKED -> balanced  |  [ ] Stage broke -> restart from that prog
```

---

## When to Stop

The loop converges when:

1. All 24 battles show PASS at `--auto` sample sizes
2. The archetype power curve roughly follows the expected peaks (per-battle variation is fine)
3. Every class sits within or near the 57-93% band at every stage (borderline 55-57% is acceptable variance)

**Perfection is not the goal.** If a class is at 58% in one stage and 92% in another, that's fine — it's within band. Borderline cases (55-57%) are acceptable variance in individual battles, especially when the class recovers to healthy rates in other battles at the same stage. Focus effort on classes that are clearly outside the band or violating the power curve, not on chasing every decimal.

## Key Files

| File | Purpose |
|------|---------|
| `EchoesOfChoice/CharacterClasses/Enemies/*.cs` | Primary tuning lever for Step 1 — all enemy stats live here |
| `EchoesOfChoice/Battles/*.cs` | Enemy composition (which enemies appear); no stat adjustments |
| `EchoesOfChoice/CharacterClasses/Fighter/Squire.cs` | Squire base stats |
| `EchoesOfChoice/CharacterClasses/Mage/Mage.cs` | Mage base stats |
| `EchoesOfChoice/CharacterClasses/Entertainer/Entertainer.cs` | Entertainer base stats |
| `EchoesOfChoice/CharacterClasses/Scholar/Tinker.cs` | Tinker base stats |
| `EchoesOfChoice/CharacterClasses/Wildling/Wildling.cs` | Wildling base stats |
| `EchoesOfChoice/CharacterClasses/<Archetype>/<Class>.cs` | Tier 1/2 growth rates (IncreaseLevel) |
| `EchoesOfChoice/BattleSimulator/SimulationRunner.cs` | CLASS BREAKDOWN output, WEAK flags |
| `EchoesOfChoice/BattleSimulator/BattleStage.cs` | Target win rates per stage |
| `EchoesOfChoice/BattleSimulator/PartyComposer.cs` | All valid party compositions |
