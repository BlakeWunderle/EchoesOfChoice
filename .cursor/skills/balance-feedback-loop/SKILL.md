---
name: balance-feedback-loop
description: Full balance feedback loop for Echoes of Choice. Iterates enemy tuning, player power curve validation, and per-class win rate banding until all stages pass. Use when the user wants to run the full balance loop, do a complete balance pass, iterate on game balance, or ensure the difficulty gradient and class power curve are correct. Excludes Elemental battles (Progression 7) — use the elemental-balance skill for those.
---

# Balance Feedback Loop

All paths are relative to the workspace root. The C# project lives at `EchoesOfChoice/`.

Iterative balancing process for Progressions 0-6. Each cycle has three phases that must all pass before the game is considered balanced. Elemental battles (Progression 7) are excluded — recruits shift the power level enough that they need their own dedicated pass.

## The Loop

**Work one progression at a time, lowest to highest.** Each progression completes all three phases before moving on. Player class changes cascade forward — adjusting a Tier 1 growth rate at Prog 2 affects every stage from Prog 2 onward but leaves Prog 0-1 untouched.

```
FOR each progression 0 -> 6, in order:
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
  -> Final validation pass (--auto for all Prog 0-6)
  -> If any stage broke, restart FROM that progression forward
```

### Why This Order Matters

- **Enemy-only changes** (Step 1) don't affect other stages — safe to iterate freely.
- **Player-side changes** (Steps 2-3) cascade forward through every later stage because growth rates compound with level-ups. A Tier 1 buff applies at Prog 2+ and a base stat change applies everywhere.
- By locking stages low-to-high, earlier work is preserved. A player change at Prog 4 only requires re-validating Prog 4-6, not restarting from Prog 0.

### Cascade Scope

| Change Type | Affects | Restart From |
|-------------|---------|-------------|
| Enemy class base stats | The battle using that enemy | Re-sim that battle |
| Enemy ability Modifier | All battles with enemies using that ability | Earliest battle using that ability |
| Player base stats (Squire/Mage/Entertainer/Scholar) | ALL stages | Prog 0 |
| Player Tier 1 growth rates | Prog 2+ (Tier 1 and later) | Prog 2 |
| Player Tier 2 growth rates | Prog 4+ (Tier 2 only) | Prog 4 |
| Ability Modifier changes | All stages using that ability | Earliest stage with a class that has the ability |

---

## Step 1: Enemy Tuning

**Goal:** This stage's overall win rate falls within its target +/- 3%.

### Run sims for the current progression

For Progressions 0-3 (Base and Tier 1 classes):
```bash
dotnet run --project EchoesOfChoice/BattleSimulator -- --sims 50 --progression <N>
```

For Progressions 4-6 (Tier 2 classes — 4,960 combos), use `--sample 500` for fast iteration. This picks a stratified random sample ensuring every class appears, giving a directionally accurate overall win rate in ~1/10th the time:
```bash
dotnet run --project EchoesOfChoice/BattleSimulator -- --sample 500 --sims 50 --progression <N>
```

### Check each battle's STATUS line

- **PASS** -> move to Step 2
- **TOO HARD** -> weaken enemies (lower base stats in `EchoesOfChoice/CharacterClasses/Enemies/<EnemyName>.cs`, reduce ability Modifiers, reduce growth rates)
- **TOO EASY** -> strengthen enemies (raise base stats in `EchoesOfChoice/CharacterClasses/Enemies/<EnemyName>.cs`, increase ability Modifiers, add abilities)

All enemy stats are fully defined in their class files — battle files just instantiate enemies. Tune stats directly in `EchoesOfChoice/CharacterClasses/Enemies/`. Avoid touching player classes in this step.

### Re-sim after each change until all battles at this stage show PASS

Use `--sample 500 --sims 50` for quick iteration at Prog 4+. Drop `--sample` for Steps 2-3 and final validation, which need the full party list for accurate class breakdowns.

### Gradient Reference (Prog 0-6)

| Stage | Target | Range | Battles |
|-------|--------|-------|---------|
| 0 | 90% | 87-93% | CityStreetBattle |
| 1 | 86% | 83-89% | ForestBattle |
| 2 | 81% | 78-84% | Smoke, DeepForest, Clearing, Shore, Ruins |
| 3 | 77% | 74-80% | Cave, Beach, Portal |
| 4 | 73% | 70-76% | Box, Cemetery, Lab, Army |
| 5 | 69% | 66-72% | MirrorBattle |
| 6 | 64% | 61-67% | ReturnToCityBattle 1-4 |

---

## Step 2: Power Curve Check

**Goal:** The archetype ranking at this stage roughly follows the expected power curve. This is a guideline, not a hard rule — individual battles will naturally favor certain archetypes based on enemy composition. The concern is persistent, stage-wide deviations, not per-battle variation.

### Expected Power Curve

| Archetype | Peak Window | Behavior |
|-----------|-------------|----------|
| **Fighter (Squire)** | Prog 0-1 (early) | Highest class win rate at base tier. Should taper to middle-of-pack by Prog 4+. |
| **Mage** | Prog 2-4 (mid) | Ramps after Tier 1 upgrade. Peaks during mid-game battles. |
| **Scholar** | Prog 5-6 (late) | Weakest early but highest growth rates catch up. Top performer by ReturnToCity. |
| **Entertainer** | Throughout (flexible) | Consistently strong across all stages. Can lead individual battles but shouldn't have extreme spikes or troughs. Never flagged WEAK. |

Classes that bridge archetypes (e.g., Paladin from Mage tree, Monk from Fighter tree) can deviate — they intentionally live between power spikes.

### How to Check

Group classes by archetype in the CLASS BREAKDOWN and average their win rates for the current stage. Use the **class-reference** skill to map class names to archetypes and upgrade trees.

- **Prog 0-1:** Fighter classes should lead.
- **Prog 2-4:** Mage classes should lead (or be close).
- **Prog 5-6:** Scholar classes should lead.
- **Any stage:** Entertainer should be strong. It can lead individual battles — the key is no extreme spikes (>95%) or troughs (<57%).

If the ranking is roughly correct (or deviations are explained by matchup) -> move to Step 3.

### Fixing Curve Problems

| Problem | Fix | Where | Cascade |
|---------|-----|-------|---------|
| Fighter too weak early | Buff Squire base stats | `EchoesOfChoice/CharacterClasses/Fighter/Squire.cs` | Restart from Prog 0 |
| Fighter too strong late | Reduce Fighter Tier 2 growth | Tier 2 Fighter class files | Restart from Prog 4 |
| Mage doesn't spike mid | Buff Tier 1 Mage growth | Tier 1 Mage class files | Restart from Prog 2 |
| Scholar still weak late | Buff Tier 2 Scholar growth | Tier 2 Scholar class files | Restart from Prog 4 |
| Entertainer flagged WEAK | Buff Entertainer base or growth | Entertainer class files | Restart from affected prog |

**After any player-side change, restart from the earliest affected progression** (see Cascade Scope table).

---

## Step 3: Class Win Rate Band

**Goal:** Every individual class's win rate (from CLASS BREAKDOWN) at this stage falls between **57% and 93%**.

### Why 57-93%

This band matches the difficulty gradient endpoints. The easiest stage targets 90% (+3% = 93%) and the hardest non-Elemental stage targets 64% (-7% buffer for class variance = 57%). No class should ever feel unwinnable or trivially easy.

### How to Check

From this stage's CLASS BREAKDOWN output:

1. **Flag any class below 57%** — this class makes parties feel hopeless when drafted.
2. **Flag any class above 93%** — this class trivializes the content.
3. Classes flagged `** WEAK **` by the simulator (below `TargetWinRate * 0.60`) are most urgent.

If all classes are within band -> **LOCK this progression** and move to the next.

### Fixing Outliers

**Class below 57% (underpowered):**

1. Check if this is expected for the power curve (e.g., Scholar at Prog 0 being 65% is fine — below Fighter but above 57%).
2. Use the **class-reference** skill to check the class's sibling (same Tier 1 parent). If both siblings are weak, the problem is likely the Tier 1 parent's growth rates or upgrade bonuses, not the individual Tier 2 class. If only one sibling is weak, focus on its specific abilities and stats.
3. If it violates the curve OR is below 57%: buff the class.
   - Offensive class: increase primary attack stat growth in `IncreaseLevel()`
   - Support class: ensure it has at least one damage ability alongside buffs
   - Check if it has dead abilities (e.g., MagDef debuff vs physical-only enemies)
4. Refer to the character-stat-tuning skill for detailed guidance.

**Class above 93% (overpowered):**

1. Reduce its primary stat growth or ability Modifiers.
2. Check if it has self-healing + damage (this combo tends to overperform).
3. Be cautious with dual-use classes — see character-stat-tuning skill for the list.

**After any player-side change, restart from the earliest affected progression.**

---

## Final Validation

After all progressions are locked at `--sims 50`, run a full validation pass. Do NOT use `--sample` here — final validation needs all party compositions:

```bash
dotnet run --project EchoesOfChoice/BattleSimulator -- --auto --progression 0
dotnet run --project EchoesOfChoice/BattleSimulator -- --auto --progression 1
# ... through --progression 6
```

If any stage flips to TOO HARD / TOO EASY at full sample size, make small adjustments and re-validate **from that stage forward**.

---

## Iteration Checklist

Copy and track progress. Each progression is locked only after all three steps pass.

```
PROGRESSION 0 (CityStreetBattle, target 87-93%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Fighter leads class breakdown
- [ ] Step 3: All classes 57-93%
- [ ] LOCKED

PROGRESSION 1 (ForestBattle, target 83-89%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Fighter leads class breakdown
- [ ] Step 3: All classes 57-93%
- [ ] LOCKED

PROGRESSION 2 (Smoke/DeepForest/Clearing/Shore/Ruins, target 78-84%):
- [ ] Step 1: Enemy tuning PASS (all 5 battles)
- [ ] Step 2: Mage leads (or close 2nd)
- [ ] Step 3: All classes 57-93%
- [ ] LOCKED

PROGRESSION 3 (Cave/Beach/Portal, target 74-80%):
- [ ] Step 1: Enemy tuning PASS (all 3 battles)
- [ ] Step 2: Mage leads (or close 2nd)
- [ ] Step 3: All classes 57-93%
- [ ] LOCKED

PROGRESSION 4 (Box/Cemetery/Lab/Army, target 70-76%):
- [ ] Step 1: Enemy tuning PASS (all 4 battles)
- [ ] Step 2: Mage leads (or close 2nd)
- [ ] Step 3: All classes 57-93%
- [ ] LOCKED

PROGRESSION 5 (MirrorBattle, target 66-72%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Scholar leads (or close 2nd)
- [ ] Step 3: All classes 57-93%
- [ ] LOCKED

PROGRESSION 6 (ReturnToCity 1-4, target 61-67%):
- [ ] Step 1: Enemy tuning PASS (all 4 battles)
- [ ] Step 2: Scholar leads
- [ ] Step 3: All classes 57-93%
- [ ] LOCKED

FINAL VALIDATION:
- [ ] All Prog 0-6 validated with --auto
- [ ] No stage broke at full sample size

RESULT: [ ] ALL LOCKED -> balanced  |  [ ] Stage broke -> restart from that prog
```

---

## When to Stop

The loop converges when:

1. All 19 battles in Prog 0-6 show PASS at `--auto` sample sizes
2. The archetype power curve roughly follows the expected peaks (per-battle variation is fine)
3. Every class sits within or near the 57-93% band at every stage (borderline 55-57% is acceptable variance)

**Perfection is not the goal.** If a class is at 58% in one stage and 92% in another, that's fine — it's within band. Borderline cases (55-57%) are acceptable variance in individual battles, especially when the class recovers to healthy rates in other battles at the same stage. Focus effort on classes that are clearly outside the band or violating the power curve, not on chasing every decimal.

## What Comes Next

After Prog 0-6 is balanced, use the **elemental-balance** skill to balance Progression 7 (ElementalBattles 1-4). Recruits add a 4th party member as overpowered companions with static stats (their `IncreaseLevel` only increments Level, no stat gains). EB1 targets 55-60% win rate; EB2-4 target 57-63%. See that skill for the full process.

## Key Files

| File | Purpose |
|------|---------|
| `EchoesOfChoice/CharacterClasses/Enemies/*.cs` | Primary tuning lever for Step 1 — all enemy stats live here |
| `EchoesOfChoice/Battles/*.cs` | Enemy composition (which enemies appear); no stat adjustments |
| `EchoesOfChoice/CharacterClasses/Fighter/Squire.cs` | Fighter base stats |
| `EchoesOfChoice/CharacterClasses/Mage/Mage.cs` | Mage base stats |
| `EchoesOfChoice/CharacterClasses/Entertainer/Entertainer.cs` | Entertainer base stats |
| `EchoesOfChoice/CharacterClasses/Scholar/Scholar.cs` | Scholar base stats |
| `EchoesOfChoice/CharacterClasses/<Archetype>/<Class>.cs` | Tier 1/2 growth rates (IncreaseLevel) |
| `EchoesOfChoice/BattleSimulator/SimulationRunner.cs` | CLASS BREAKDOWN output, WEAK flags |
| `EchoesOfChoice/BattleSimulator/BattleStage.cs` | Target win rates per stage |
