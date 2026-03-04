---
name: battle-sim
description: Full balance feedback loop for Echoes of Choice. Iterates enemy tuning, player power curve validation, and per-class win rate banding until all stages pass. Supports Story 1 and Story 2 independently via --story flag. Use when the user wants to run the full balance loop, do a complete balance pass, iterate on game balance, or ensure the difficulty gradient and class power curve are correct.
---

# Balance Feedback Loop

All paths are relative to the workspace root. The Godot project lives at `EchoesOfChoice/`.

Iterative balancing process for progression stages. Each cycle has three phases that must all pass before a story is considered balanced. Use `--story 1` or `--story 2` to target a specific story.

## The Loop

**Work one progression at a time, lowest to highest.** Each progression completes all three phases before moving on. Player class changes cascade forward -- adjusting a Tier 1 growth rate at Prog 3 affects every stage from Prog 3 onward but leaves Prog 0-2 untouched.

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
  -> Final validation pass (--story <N> --auto --all)
  -> If any stage broke, restart FROM that progression forward
```

### Why This Order Matters

- **Enemy-only changes** (Step 1) don't affect other stages -- safe to iterate freely.
- **Player-side changes** (Steps 2-3) cascade forward through every later stage because growth rates compound with level-ups. A Tier 1 buff applies at Prog 3+ and a base stat change applies everywhere.
- By locking stages low-to-high, earlier work is preserved. A player change at Prog 8 only requires re-validating Prog 8-13, not restarting from Prog 0.

### Cascade Scope (Story 1)

| Change Type | Affects | Restart From |
|-------------|---------|-------------|
| Enemy stat ranges in `enemy_db.gd` | The battle using that enemy | Re-sim that battle |
| Enemy ability Modifier | All battles with enemies using that ability | Earliest battle using that ability |
| Player base stats (Squire/Mage/Entertainer/Tinker/Wildling/Wanderer) | ALL stages | Prog 0 |
| Player Tier 1 growth rates | Prog 3+ (Tier 1 and later) | Prog 3 |
| Player Tier 2 growth rates | Prog 8+ (Tier 2 only) | Prog 8 |
| Ability Modifier changes | All stages using that ability | Earliest stage with a class that has the ability |

---

## Enemy Stat Mechanics

Enemy stats are defined in `scripts/data/enemy_db.gd`. Each factory function uses `_es(base_min, base_max, gmin, gmax, level, base_level)`:

```gdscript
# Example: create_raider at level 4
f.health = _es(98, 113, 4, 7, 4, 1)
# Result: range from base_min + (lvl-base_level)*gmin to base_max + (lvl-base_level)*(gmax-1)
```

- The **level parameter is passed to the factory** and used in `_es()` calls
- Growth is applied **once at construction time**, not per-turn
- `_es()` produces a random int within the computed range

### Tuning Levers (in order of impact)

1. **Base stat ranges** (1st and 2nd params of `_es()`) -- direct control over the stat floor/ceiling
2. **Growth rates** (3rd and 4th params of `_es()`) -- amplified by level; changing growth by +1 at level 4 adds +3 to the stat range
3. **Level parameter** -- increasing from 4 to 5 adds one more growth roll to every stat
4. **Enemy count** -- adding/removing enemies from the battle config (see 3-Enemy Rule below)
5. **Abilities** -- changing which abilities the enemy has or their Modifiers
6. **CritChance / DodgeChance** -- percentage-based, small changes have noticeable effects

### 3-Enemy Rule

Every battle after the first must have **at least 3 enemies**, unless it is a boss fight. Boss fights and special battles (MirrorBattle) are exempt.

3v2 battles give players a 50% action economy advantage, making stat tuning extremely sensitive. If a battle has only 2 enemies, add a 3rd by duplicating an existing enemy type with a new character name before tuning stats.

---

## Running the Simulator

The Godot battle simulator is the CLI tool at `tools/battle_simulator.gd`:

```bash
GODOT="C:/Users/blake/AppData/Local/Microsoft/WinGet/Packages/GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe/Godot_v4.6.1-stable_win64_console.exe"
NOISE='No loader\|Oswald\|game_theme\|custom project\|Unreferenced static string\|RID allocations.*leaked\|Pages in use exist at exit\|PagedAllocator\|ObjectDB instances leaked\|resources still in use at exit\|OpenGL API\|NVIDIA\|WASAPI\|Cleanup\|Main::'
```

### Story Filtering

Use `--story <n>` to target a specific story's stages:

```bash
# Story 1 only
"$GODOT" --path EchoesOfChoice --headless --script res://tools/battle_simulator.gd -- --story 1 --auto --all 2>&1 | grep -v "$NOISE"

# Story 2 only
"$GODOT" --path EchoesOfChoice --headless --script res://tools/battle_simulator.gd -- --story 2 --auto --all 2>&1 | grep -v "$NOISE"

# All stories (default)
"$GODOT" --path EchoesOfChoice --headless --script res://tools/battle_simulator.gd -- --auto --all 2>&1 | grep -v "$NOISE"
```

---

# Story 1 Balance

Story 1 has 14 progressions (Prog 0-13), 22 battle stages, and uses all 6 base class archetypes (Squire, Mage, Entertainer, Tinker, Wildling, Wanderer).

## Step 1: Enemy Tuning

**Goal:** This stage's overall win rate falls within its target +/- 3%.

### Run sims for the current progression

For Progressions 0-2 (Base classes, 56 combos):
```bash
"$GODOT" --path EchoesOfChoice --headless --script res://tools/battle_simulator.gd -- --story 1 --sims 50 --progression <N> 2>&1 | grep -v "$NOISE"
```

For Progressions 3-7 (Tier 1 classes, ~816 combos), use `--sample 100` for fast iteration:
```bash
"$GODOT" --path EchoesOfChoice --headless --script res://tools/battle_simulator.gd -- --story 1 --sample 100 --sims 50 --progression <N> 2>&1 | grep -v "$NOISE"
```

For Progressions 8-13 (Tier 2 classes, ~8436 combos), use `--sample 100` for fast iteration:
```bash
"$GODOT" --path EchoesOfChoice --headless --script res://tools/battle_simulator.gd -- --story 1 --sample 100 --sims 50 --progression <N> 2>&1 | grep -v "$NOISE"
```

### Check each battle's STATUS line

- **PASS** -> move to Step 2
- **TOO HARD** -> weaken enemies (lower `_es()` ranges in `scripts/data/enemy_db.gd`, reduce ability Modifiers in `scripts/data/enemy_ability_db.gd`, lower CritChance/DodgeChance, remove an enemy from the battle config)
- **TOO EASY** -> strengthen enemies (raise `_es()` ranges, increase ability Modifiers, raise CritChance/DodgeChance, add an enemy to the battle config -- see 3-Enemy Rule)

All enemy stats are set in `scripts/data/enemy_db.gd` factory functions. Battle compositions are defined in `scripts/data/battle_db.gd` (and `battle_db_act2.gd`, `battle_db_act3.gd`, `battle_db_act45.gd`). Tune the `_es()` base ranges and growth params directly. Avoid touching player classes in this step.

### Re-sim after each change until all battles at this stage show PASS

Use `--sample 100 --sims 50` for quick iteration. Drop `--sample` for Steps 2-3 and final validation, which need the full party list for accurate class breakdowns.

### Story 1 Difficulty Gradient

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
| 11 | 72% | 69-75% | T2 | DepthsBattle |
| 12 | 69% | 66-72% | T2 | GateBattle |
| 13 | 65% | 62-68% | T2 | StrangerFinalBattle |

---

## Step 2: Power Curve Check

**Goal:** The archetype ranking at this stage roughly follows the expected power curve. This is a guideline, not a hard rule -- individual battles will naturally favor certain archetypes based on enemy composition. The concern is persistent, stage-wide deviations, not per-battle variation.

### Expected Power Curve (6 Archetypes)

| Archetype | Peak Window | Behavior |
|-----------|-------------|----------|
| **Squire (Fighter tree)** | Prog 0-2 (early) | Highest class win rate at base tier. Strong physical stats out of the gate. Should taper to middle-of-pack by Prog 5+. |
| **Wanderer** | Prog 0-4 (early-mid) | Magic-defense fighter. Strong early alongside Squire, especially vs magic enemies. Tapers to mid-pack by Prog 5+. |
| **Mage** | Prog 3-7 (mid) | Ramps after Tier 1 upgrade. Peaks during mid-game battles with magic scaling. |
| **Entertainer** | Throughout (flexible) | Consistently strong across all stages. Buffs/debuffs scale well. Can lead individual battles but shouldn't have extreme spikes or troughs. Never flagged WEAK. |
| **Tinker (Scholar tree)** | Prog 8-13 (late) | Weakest early but highest growth rates catch up. Utility and tech abilities pay off in complex late fights. Top performer by endgame. |
| **Wildling** | Prog 2-8 (mid-wide) | Nature-based utility and beast synergies. Competitive across mid-game, shouldn't be dominant at early or late extremes. |

Classes that bridge archetypes (e.g., Paladin from Mage tree, Monk from Squire tree) can deviate -- they intentionally live between power spikes.

### How to Check

Group classes by archetype in the CLASS BREAKDOWN and average their win rates for the current stage.

- **Prog 0-2:** Squire and Wanderer classes should lead.
- **Prog 3-7:** Mage classes should lead (or be close). Wildling and Wanderer competitive.
- **Prog 8-13:** Tinker classes should lead.
- **Any stage:** Entertainer should be strong. No extreme spikes (>95%) or troughs (<57%). Wildling should stay mid-pack.

If the ranking is roughly correct (or deviations are explained by matchup) -> move to Step 3.

### Fixing Curve Problems

| Problem | Fix | Where | Cascade |
|---------|-----|-------|---------|
| Squire too weak early | Buff Squire base stats | `fighter_db.gd` (Squire factory) | Restart from Prog 0 |
| Squire too strong late | Reduce Squire T2 growth | `fighter_db_t2.gd` / `fighter_db_t2b.gd` | Restart from Prog 8 |
| Wanderer too weak early | Buff Wanderer base stats | `fighter_db.gd` (Wanderer factory) | Restart from Prog 0 |
| Wanderer too strong mid | Reduce Wanderer T1 growth | `fighter_db_t1.gd` (Sentinel, Pathfinder) | Restart from Prog 3 |
| Mage doesn't spike mid | Buff T1 Mage growth | `fighter_db_t1.gd` (Invoker, Acolyte) | Restart from Prog 3 |
| Entertainer flagged WEAK | Buff Entertainer base or growth | `fighter_db.gd` / `fighter_db_t1.gd` (Bard, Dervish, Orator) | Restart from affected prog |
| Tinker still weak late | Buff T2 Tinker growth | `fighter_db_t2.gd` / `fighter_db_t2b.gd` | Restart from Prog 8 |
| Wildling too weak mid | Buff T1 Wildling growth | `fighter_db_t1.gd` (Herbalist, Shaman, Beastcaller) | Restart from Prog 3 |
| Wildling too strong early | Reduce Wildling base stats | `fighter_db.gd` (Wildling factory) | Restart from Prog 0 |

**After any player-side change, restart from the earliest affected progression** (see Cascade Scope table).

---

## Step 3: Class Win Rate Band

**Goal:** Every individual class's win rate (from CLASS BREAKDOWN) at this stage falls within `target +/- 15%`.

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

1. **Flag any class below `target - 15%`** -- this class makes parties feel hopeless when drafted.
2. **Flag any class above `target + 15%`** -- this class trivializes the content.
3. Classes flagged `** WEAK **` by the simulator (below `TargetWinRate * 0.60`) are most urgent.

If all classes are within band -> **LOCK this progression** and move to the next.

### Fixing Outliers

**Class below 57% (underpowered):**

1. Check if this is expected for the power curve (e.g., Tinker at Prog 0 being 65% is fine -- below Squire but above 57%).
2. Check the class's sibling (same Tier 1 parent). If both siblings are weak, the problem is likely the Tier 1 parent's growth rates, not the individual Tier 2 class.
3. If it violates the curve OR is below 57%: buff the class.
   - Offensive class: increase primary attack stat growth in `increase_level()` in the fighter_db files
   - Support class: ensure it has at least one damage ability alongside buffs
   - Check if it has dead abilities (e.g., MagDef debuff vs physical-only enemies)

**Class above 93% (overpowered):**

1. Reduce its primary stat growth or ability Modifiers.
2. Check if it has self-healing + damage (this combo tends to overperform).

**After any player-side change, restart from the earliest affected progression.**

---

## Final Validation (Story 1)

After all progressions are locked at `--sims 50`, run a full validation pass:

```bash
"$GODOT" --path EchoesOfChoice --headless --script res://tools/battle_simulator.gd -- --story 1 --auto --all 2>&1 | grep -v "$NOISE"
```

This takes 2-5 minutes. Use a 600000ms timeout.

If any stage flips to TOO HARD / TOO EASY at full sample size, make small adjustments and re-validate **from that stage forward**.

---

## Story 1 Battle -> Enemy Mapping

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
| OutpostDefenseBattle | 6 | 2x Shade, 2x Wraith | 3v4 |
| MirrorBattle | 7 | Shadow clones (98% stat copies of party) | 3vN |
| ReturnToCityStreetBattle | 8 | RoyalGuard, GuardSergeant, 2x GuardArcher | 3v4 |
| StrangerTowerBattle | 9 | Stranger | 3v1 (boss) |
| CorruptedCityBattle | 10 | 2x Lich, 2x Ghast | 3v4 |
| CorruptedWildsBattle | 10 | 2x Demon, 2x CorruptedTreant | 3v4 |
| DepthsBattle | 11 | SigilWretch, 2x TunnelLurker | 3v3 |
| GateBattle | 12 | 2x DarkKnight, 2x FellHound | 3v4 |
| StrangerFinalBattle | 13 | StrangerFinal | 3v1 (boss) |

Enemy factories are in `scripts/data/enemy_db.gd`. Battle compositions are in `scripts/data/battle_db.gd` (and act-specific files). When tuning a battle, check this table to know which enemy factories to modify.

---

## Story 1 Iteration Checklist

Copy and track progress. Each progression is locked only after all three steps pass.

```
PROGRESSION 0 (CityStreetBattle, target 87-93%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Squire/Wanderer lead class breakdown
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 1 (WolfForestBattle, target 85-91%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Squire/Wanderer lead class breakdown
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 2 (WaypointDefenseBattle, target 82-88%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Squire/Wanderer lead (transitioning)
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 3 (Highland/DeepForest/Shore, target 80-86%):
- [ ] Step 1: All 3 battles PASS
- [ ] Step 2: Mage leads (or close)
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 4 (MountainPass/Cave/Beach, target 78-84%):
- [ ] Step 1: All 3 battles PASS
- [ ] Step 2: Mage leads (or close)
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 5 (Circus/Lab/Army/Cemetery, target 76-82%):
- [ ] Step 1: All 4 battles PASS
- [ ] Step 2: Mage leads (or close)
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 6 (OutpostDefenseBattle, target 74-80%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Mage leads
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 7 (MirrorBattle, target 72-78%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Power curve check
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 8 (ReturnToCityStreetBattle, target 77-83%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Tinker leads (or close)
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 9 (StrangerTowerBattle, target 75-81%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Tinker leads
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 10 (CorruptedCity/CorruptedWilds, target 72-78%):
- [ ] Step 1: Both battles PASS
- [ ] Step 2: Tinker leads
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 11 (DepthsBattle, target 69-75%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Tinker leads
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 12 (GateBattle, target 66-72%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Tinker leads
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 13 (StrangerFinalBattle, target 62-68%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Power curve check
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

FINAL VALIDATION (Story 1):
- [ ] All Prog 0-13 validated with --story 1 --auto --all
- [ ] No stage broke at full sample size

RESULT: [ ] ALL LOCKED -> balanced  |  [ ] Stage broke -> restart from that prog
```

---

## When to Stop (Story 1)

The loop converges when:

1. All 22 battles show PASS at `--auto` sample sizes
2. The archetype power curve roughly follows the expected peaks (per-battle variation is fine)
3. Every class sits within or near the 57-93% band at every stage (borderline 55-57% is acceptable variance)

**Perfection is not the goal.** If a class is at 58% in one stage and 92% in another, that's fine -- it's within band. Borderline cases (55-57%) are acceptable variance in individual battles, especially when the class recovers to healthy rates in other battles at the same stage. Focus effort on classes that are clearly outside the band or violating the power curve, not on chasing every decimal.

---
---

# Story 2 Balance

Story 2 is a separate adventure with fresh characters. Players create a new party using all 6 base classes (including Wanderer, unlocked by completing Story 1). The same tier transitions and progression structure apply.

## Story 2 Constraint Rule

**Story 1 balance is LOCKED.** When balancing Story 2, ONLY modify:

- **Story 2 enemies**: stats/abilities in `enemy_db.gd` / `enemy_ability_db.gd`, compositions in `battle_db_s2.gd`
- **Wanderer tree**: stats/abilities in `fighter_db.gd` (Wanderer factory), `fighter_db_t1.gd` (Sentinel, Pathfinder), `fighter_db_t2.gd` (Bulwark, Aegis), `fighter_db_t2b.gd` (Trailblazer, Survivalist), `ability_db.gd` (wild_strike, natures_ward), `ability_db_player.gd` (Wanderer tree abilities)

**Do NOT modify** Squire, Mage, Entertainer, Tinker, or Wildling class trees. These are shared with Story 1 and any changes would break Story 1 balance.

### Story 2 Cascade Scope

| Change Type | Affects | Restart From |
|-------------|---------|-------------|
| S2 enemy stat ranges | The S2 battle using that enemy | Re-sim that battle |
| S2 enemy ability Modifier | All S2 battles with enemies using that ability | Earliest S2 battle using it |
| Wanderer base stats (T0) | ALL stages (both stories) | S2 Prog 0 + re-validate S1 |
| Wanderer T1 growth (Sentinel/Pathfinder) | S2 Prog 3+ | S2 Prog 3 + re-validate S1 Prog 3+ |
| Wanderer T2 growth (Bulwark/Aegis/Trailblazer/Survivalist) | S2 Prog 8+ | S2 Prog 8 + re-validate S1 Prog 8+ |
| Wanderer ability Modifier | All stages with Wanderer classes using that ability | Earliest affected stage + re-validate S1 |

**Cross-story validation**: After ANY Wanderer tree change, re-validate Story 1:
```bash
"$GODOT" --path EchoesOfChoice --headless --script res://tools/battle_simulator.gd -- --story 1 --auto --all 2>&1 | grep -v "$NOISE"
```
If any Story 1 stage breaks, revert the Wanderer change and compensate by adjusting Story 2 enemies instead.

---

## Story 2 Power Curve (6 Archetypes)

| Archetype | Peak Window | Behavior | Tunable? |
|-----------|-------------|----------|----------|
| **Squire** | Prog 0-2 | Strong fighter early, tapers mid-game | LOCKED |
| **Wanderer** | Prog 0-4 | Magic-defense fighter, strong early-mid vs magic enemies, tapers late | **YES** |
| **Mage** | Prog 3-7 | Ramps after T1, peaks mid-game | LOCKED |
| **Entertainer** | Throughout | Consistently strong, never WEAK | LOCKED |
| **Tinker** | Prog 8+ | Weakest early, strongest late | LOCKED |
| **Wildling** | Prog 2-8 | Mid-range utility, competitive mid-game | LOCKED |

Wanderer's magic-defense focus means it should perform especially well against magic-heavy enemies but weaker against purely physical enemies. Story 2 enemy compositions can exploit this -- mix physical and magic enemies to create matchup variety. This is a natural matchup variance, not a balance problem.

---

## Story 2 Difficulty Gradient

Story 2 is harder than Story 1. Starts at 85% (vs 90%) and drops to 60% (vs 65%). Same tier transitions and T2 bump structure.

| Prog | Target | Range | Tier | Battles |
|------|--------|-------|------|---------|
| 0 | 85% | 82-88% | Base | S2_CaveAwakening |
| 1 | 83% | 80-86% | Base | S2_DeepCavern |
| 2 | 80% | 77-83% | Base | S2_CaveExit |
| 3 | 78% | 75-81% | T1 | [TBD] |
| 4 | 76% | 73-79% | T1 | [TBD] |
| 5 | 73% | 70-76% | T1 | [TBD] |
| 6 | 71% | 68-74% | T1 | [TBD] |
| 7 | 68% | 65-71% | T1 | [TBD] |
| 8 | 73% | 70-76% | T2 | [TBD] |
| 9 | 71% | 68-74% | T2 | [TBD] |
| 10 | 68% | 65-71% | T2 | [TBD] |
| 11 | 66% | 63-69% | T2 | [TBD] |
| 12 | 63% | 60-66% | T2 | [TBD] |
| 13 | 60% | 57-63% | T2 | [TBD] |

### Story 2 Class Band Formula

Same `target +/- 15%` rule, but the lower targets mean tighter absolute bands at late game:

| Prog | Target | Class Floor | Class Ceiling |
|------|--------|-------------|---------------|
| 0 | 85% | 70% | 100% |
| 1 | 83% | 68% | 98% |
| 2 | 80% | 65% | 95% |
| 3 | 78% | 63% | 93% |
| 4 | 76% | 61% | 91% |
| 5 | 73% | 58% | 88% |
| 6 | 71% | 56% | 86% |
| 7 | 68% | 53% | 83% |
| 8 | 73% | 58% | 88% |
| 9 | 71% | 56% | 86% |
| 10 | 68% | 53% | 83% |
| 11 | 66% | 51% | 81% |
| 12 | 63% | 48% | 78% |
| 13 | 60% | 45% | 75% |

---

## Story 2 Sim Commands

```bash
# All Story 2 stages
"$GODOT" --path EchoesOfChoice --headless --script res://tools/battle_simulator.gd -- --story 2 --auto --all 2>&1 | grep -v "$NOISE"

# Single Story 2 progression
"$GODOT" --path EchoesOfChoice --headless --script res://tools/battle_simulator.gd -- --story 2 --sims 50 --progression <N> 2>&1 | grep -v "$NOISE"

# Validate Story 1 unchanged after Wanderer tweak
"$GODOT" --path EchoesOfChoice --headless --script res://tools/battle_simulator.gd -- --story 1 --auto --all 2>&1 | grep -v "$NOISE"
```

---

## Story 2 Battle -> Enemy Mapping

| Battle | Prog | Enemies | Format |
|--------|------|---------|--------|
| S2_CaveAwakening | 0 | 2x GlowWorm, CrystalSpider | 3v3 |
| S2_DeepCavern | 1 | 2x ShadeCrawler, EchoWisp | 3v3 |
| S2_CaveExit | 2 | CaveMaw, VeinLeech, StoneMoth | 3v3 |

Story 2 enemy factories are in `scripts/data/enemy_db_s2.gd`. Battle compositions are in `scripts/data/battle_db_s2.gd`. Stage definitions are in `scripts/tools/battle_stage_db.gd` (with `story = 2`).

---

## Story 2 Iteration Checklist

Same structure as Story 1 -- each progression locked after all 3 steps pass.

```
PROGRESSION 0 (S2_CaveAwakening, target 82-88%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Squire/Wanderer lead class breakdown
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 1 (S2_DeepCavern, target 80-86%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Squire/Wanderer lead class breakdown
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

PROGRESSION 2 (S2_CaveExit, target 77-83%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Squire/Wanderer lead (transitioning)
- [ ] Step 3: All classes within target +/- 15%
- [ ] LOCKED

[Prog 3-13 TBD -- populate when remaining Story 2 battles are defined]

FINAL VALIDATION (Story 2):
- [ ] All S2 progressions validated with --story 2 --auto --all
- [ ] Story 1 re-validated with --story 1 --auto --all (no regressions)

RESULT: [ ] ALL LOCKED -> balanced  |  [ ] Stage broke -> restart from that prog
```

---
---

# Key Files

| File | Purpose |
|------|---------|
| `EchoesOfChoice/scripts/data/enemy_db.gd` | Primary tuning lever for Step 1 -- all enemy stat factories live here |
| `EchoesOfChoice/scripts/data/enemy_ability_db.gd` | Enemy-specific abilities and their Modifiers |
| `EchoesOfChoice/scripts/data/battle_db.gd` | Story 1 enemy composition (which enemies appear in each battle) |
| `EchoesOfChoice/scripts/data/battle_db_act2.gd` | Story 1 Act 2 battle compositions |
| `EchoesOfChoice/scripts/data/battle_db_act3.gd` | Story 1 Act 3 battle compositions |
| `EchoesOfChoice/scripts/data/battle_db_act45.gd` | Story 1 Act 4-5 battle compositions |
| `EchoesOfChoice/scripts/data/battle_db_s2.gd` | Story 2 battle compositions |
| `EchoesOfChoice/scripts/data/fighter_db.gd` | Base (T0) player class factories and stats |
| `EchoesOfChoice/scripts/data/fighter_db_t1.gd` | Tier 1 player class factories and growth |
| `EchoesOfChoice/scripts/data/fighter_db_t2.gd` | Tier 2 player class factories and growth (part 1) |
| `EchoesOfChoice/scripts/data/fighter_db_t2b.gd` | Tier 2 player class factories and growth (part 2) |
| `EchoesOfChoice/scripts/data/ability_db.gd` | Base player ability definitions (T0 + shared) |
| `EchoesOfChoice/scripts/data/ability_db_player.gd` | T1/T2 player ability definitions |
| `EchoesOfChoice/scripts/tools/simulation_runner.gd` | CLASS BREAKDOWN output, WEAK flags |
| `EchoesOfChoice/scripts/tools/battle_stage_db.gd` | Target win rates per stage (story-aware) |
| `EchoesOfChoice/scripts/tools/party_composer.gd` | All valid party compositions |
| `EchoesOfChoice/tools/battle_simulator.gd` | CLI entry point for the simulator (supports --story flag) |
