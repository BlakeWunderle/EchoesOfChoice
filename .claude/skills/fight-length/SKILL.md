---
name: fight-length
description: Analyze battle fight length from the sim JSON — average actions, player actions per character, and max outliers. Use after any sim run to check for slogs or to see how a class rework shifted fight duration.
---

# Fight Length Analysis

Reads `turn_stats` from the sim JSON and surfaces battles with slog problems and boss
fights that are too short. Does **not** run the simulator -- reads existing data only.

**Runs immediately after any `/battle-sim` run** -- the battle-sim skill always persists `turn_stats` to the JSON file. No refresh or re-sim needed.

## Data Source

```
JSON_PATH="C:/Users/blake/.claude/projects/c--Projects-PartingShadows/memory/class-report-data.json"
```

The JSON has a `stages` array. Each entry contains:

```
turn_stats: {
  avg_player_per_char  -- average actions taken per player character
  avg_all_actions      -- average total actions (players + enemies) per battle
  min_all_actions      -- minimum total actions observed across all sims
  max_all_actions      -- maximum total actions observed across all sims
}
```

`avg_player_per_char` is calculated as `total_player_actions / (party_size * sim_count)`.
A party of 3 each taking ~8-12 actions is healthy. Over 20/char suggests a slog.

## Boss Battles

These battles are named-villain boss encounters and should be among the LONGER fights.
Flag them when they're too short (not just too long):

```
BOSS_BATTLES = {
  "StrangerTowerBattle", "StrangerFinalBattle", "StrangerUndoneBattle",
  "S2_TheReveal", "S2_EyeAwakening", "S2_EyeOfOblivion", "S2_B_EyeUnblinking",
  "S3_DreamShadowChase",
  "S3_DreamNexus", "S3_B_DreamNexus", "S3_C_DreamNexus"
}
```

## Excluded Battles

These battles are excluded from flagging (still shown in table, but no warning flags).
They get an `[EXCLUDED]` label instead of `<<< SLOG` / `<<  long`.

```
EXCLUDED_BATTLES = {
  "MirrorBattle"  -- mirror mechanic causes inherent outlier runs; not tunable
}
```

## Accepted-Short Bosses

These boss battles are intentionally short by narrative design. They skip the
`<<< SHORT` flag and get `[OK SHORT]` instead.

```
ACCEPTED_SHORT_BOSSES = {
  "S2_EyeOfOblivion"  -- intentionally short; Eye is dying after Sera's sacrifice
}
```

## What to Pull

For each stage, extract:
- `stage_name`, `story`, `tier`
- `turn_stats.avg_player_per_char`
- `turn_stats.avg_all_actions`
- `turn_stats.min_all_actions`
- `turn_stats.max_all_actions`
- `turn_stats.stalemate_count` (0 if missing)
- `turn_stats.stalemate_rate` (0.0 if missing)
- `turn_stats._total_battle_count` (for computing rate if needed)
- Whether the stage name is in BOSS_BATTLES

Sort by `avg_all_actions` descending.

## Thresholds

### Regular Battles
| Metric | Healthy | Elevated | Slog |
|--------|---------|----------|------|
| `avg_all_actions` | < 80 | 80–120 | > 120 |
| `max_all_actions` | < 200 | 200–400 | > 400 |
| `avg_player_per_char` | < 15 | 15–22 | > 22 |

Any regular battle exceeding **two or more** thresholds is a priority fix.

### Boss Battles (should be LONGER than regular)
| Metric | Too Short | Healthy | Slog |
|--------|-----------|---------|------|
| `avg_all_actions` | < 60 | 60–200 | > 200 |
| `max_all_actions` | < 100 | 100–800 | > 800 |
| `avg_player_per_char` | < 8 | 8–22 | > 22 |

A boss fight is **too short** if avg_all_actions < 60 OR avg_player_per_char < 8.

High `max_all_actions` with moderate `avg_all_actions` means the fight is fine most of
the time but has catastrophic outlier runs — usually caused by a specific class combo
that can't deal enough damage to close out.

### Stalemate-Aware Slog Assessment

A slog flag alone does not mean the battle needs fixing. Check the **stalemate rate**:

- **stalemate_rate < 3%**: The slog outliers are caused by weak class combos that
  can't close out. This is acceptable — the fight is fine for most parties. Flag as
  `<<< SLOG (stalemate X.XX%)` to show the rate, but do NOT count it as a problem
  in the summary.
- **stalemate_rate >= 3%**: Too many parties are stalling out. The battle likely has
  a fundamental sustain/defense problem that needs tuning. Flag as `<<< SLOG FIX`
  and count it as a problem.
- **No stalemate data**: If `stalemate_count` is missing or 0 and `_total_battle_count`
  is also missing, the battle was simmed before stalemate tracking was added. Flag
  normally as `<<< SLOG` and note "(no stalemate data)" in the summary.

## Output Format

Print a table sorted by `avg_all_actions` descending:

```
Battle                                          S  Tier    AvgPly/Char  AvgAll  MinAll  MaxAll  Stale%
-------------------------------------------------------------------------------------------------------
CircusBattle                                    1  tier1         15.30   90.80      18     978   1.35%  <<< SLOG (1.35%)
CorruptedWildsBattle                            1  tier2         19.25  114.01      31     585          <<< SLOG (no data)
StrangerFinalBattle [BOSS]                      1  tier2         11.42   78.31      32     312
S3_DreamShadowChase [BOSS]                      3  tier1          4.21   31.18      12      89          <<< SHORT
...
```

Flag each row:
- `<<< SLOG (X.XX%)` — max > 400 (regular) or > 800 (boss), stalemate rate < 3%. Acceptable; weak-combo noise.
- `<<< SLOG FIX` — max > 400 (regular) or > 800 (boss), stalemate rate >= 3%. Needs tuning.
- `<<< SLOG (no data)` — max over threshold but no stalemate data available. Needs re-sim with stalemate tracking.
- `<<  long` — max 200–400 (regular battles only, unless in EXCLUDED_BATTLES)
- `<<< SHORT` — boss fight where avg_all_actions < 60 or avg_player_per_char < 8 (unless in ACCEPTED_SHORT_BOSSES)
- `[BOSS]` — label appended to battle name for boss battles
- `[EXCLUDED]` — replaces slog/long flags for battles in EXCLUDED_BATTLES
- `[OK SHORT]` — replaces SHORT flag for bosses in ACCEPTED_SHORT_BOSSES

Show the `Stale%` column for all rows. Display the stalemate_rate as a percentage.
If no stalemate data exists (missing key or `_total_battle_count` is 0/missing), show blank.

After the table, print a summary:

```
FIGHT LENGTH SUMMARY
  Regular battles: N total
    Slogs needing fix (>=3% stalemate): N  [list names]
    Slogs acceptable (<3% stalemate):   N  [list names]
    Slogs no data (need re-sim):        N  [list names]
    Excluded:                           N  [list names]
    Elevated (max 200-400):             N  [list names]
    Healthy:                            N
  Boss battles: N total
    Too short (avg < 60):   N  [list names]
    Accepted short:         N  [list names]
    Healthy:                N
    Slogs needing fix:      N  [list names]
    Slogs acceptable:       N  [list names]
```

## Notes on Interpreting After a Class Rework

After reworking a class's kit (damage, abilities, healing), fight length can shift because:
- **More damage** → shorter fights (lower avg and max)
- **More healing** → longer fights (higher avg and max, especially max)
- **New debuffs/stuns** → can cut enemy actions, lowering all_actions

When comparing before/after a rework, check both `avg_all_actions` (did the typical fight
get shorter?) and `max_all_actions` (did the worst-case outlier improve?). The max is more
sensitive to problem class combos.

For boss reworks specifically: check that avg_all_actions is above 60 and avg_player_per_char
is above 8 after buffing HP/abilities. A boss that dies too fast isn't grand.

## STOP: This Skill Is Read-Only

After printing the summary, **stop**. Do not tune enemies or modify abilities.
Surface any slogs or short bosses to the user and wait for explicit instructions.

## Related Skills

| Skill | When to Use |
|-------|-------------|
| `/battle-sim` | Re-sim after changes to get fresh data |
| `/balance-log` | Record what changed and what fight lengths were before/after |
| `/class-report` | Per-class win rates — pair with fight length to understand full battle health |
