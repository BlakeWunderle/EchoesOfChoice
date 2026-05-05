---
name: battle-sim
description: Full balance feedback loop for Parting Shadows. Runs all 3 stories across all tiers by default. Tunes one battle at a time with 20 workers, diagnostics, JSON, and markdown output.
---

# Balance Feedback Loop

## Default Behavior

When invoked with no arguments (or with `--story 1 --story 2 --story 3`), run the **full workflow automatically**:

1. Run all 3 stories sequentially (S1 → S2 → S3), each covering all tiers (base, tier1, tier2)
2. Use standard flags: `--auto --all --diagnostics --compact --jobs 20 --json "$JSON_PATH" --markdown "$MD_PATH"`
3. After each story sim, read `$SIM_OUT` and tune any failing battles one at a time before moving to the next story
4. **No revalidation after tuning.** Once all failing battles in a story are individually tuned to PASS, move to the next story. Do NOT re-run the full story sim to revalidate — it wastes time and base-tier battles have ±3-5pp variance that causes false failures.

If invoked with specific arguments (e.g. `--story 1 --tier tier2`, `--battles BattleName1,BattleName2`), narrow scope accordingly but still use the standard flags (20 workers, diagnostics, JSON, markdown).

---

All paths relative to workspace root. Godot project at `PartingShadows/`.

**Before starting:** Read `C:\Users\blake\.claude\projects\c--Projects-PartingShadows\memory\balance-log.md` to pick up progress from previous sessions. Use `/balance-log` after each sim run to record results and changes.

**Class data is built into every parallel sim run.** Pass `--diagnostics` to any parallel sim command and the coordinator prints the full per-class win rate breakdown after the summary table. No second sim needed.

**After locking a tier:** The `--json "$JSON_PATH"` flag persists all class breakdown data to disk. Read the JSON file in later sessions instead of re-simming.

---

## Multi-Story T2 Enemy Tuning

For a full T2 enemy tuning pass across all three stories, run each story in sequence (one at a time — never run two parallel sims simultaneously).

```bash
GODOT="C:/Users/blake/AppData/Local/Microsoft/WinGet/Packages/GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe/Godot_v4.6.1-stable_win64_console.exe"
NOISE='No loader\|Oswald\|game_theme\|custom project\|Unreferenced static string\|RID allocations.*leaked\|Pages in use exist at exit\|PagedAllocator\|ObjectDB instances leaked\|resources still in use at exit\|OpenGL API\|NVIDIA\|WASAPI\|Cleanup\|Main::'
JSON_PATH="C:/Users/blake/.claude/projects/c--Projects-PartingShadows/memory/class-report-data.json"
MD_PATH="C:/Users/blake/.claude/projects/c--Projects-PartingShadows/memory/class-balance.md"
SIM_OUT="C:/Users/blake/.claude/projects/c--Projects-PartingShadows/memory/sim_output.txt"

# Story 1 T2 -- full tier with class breakdown in one pass
"$GODOT" --path PartingShadows --headless --script res://tools/battle_sim_parallel.gd -- \
  --story 1 --tier tier2 --auto --all --diagnostics --compact --jobs 20 --json "$JSON_PATH" --markdown "$MD_PATH" 2>&1 | grep -v "$NOISE" > "$SIM_OUT"

# Story 2 T2
"$GODOT" --path PartingShadows --headless --script res://tools/battle_sim_parallel.gd -- \
  --story 2 --tier tier2 --auto --all --diagnostics --compact --jobs 20 --json "$JSON_PATH" --markdown "$MD_PATH" 2>&1 | grep -v "$NOISE" > "$SIM_OUT"

# Story 3 T2
"$GODOT" --path PartingShadows --headless --script res://tools/battle_sim_parallel.gd -- \
  --story 3 --tier tier2 --auto --all --diagnostics --compact --jobs 20 --json "$JSON_PATH" --markdown "$MD_PATH" 2>&1 | grep -v "$NOISE" > "$SIM_OUT"
```

**After each story sim:** Read `$SIM_OUT` with the Read tool to check pass/fail. For class breakdown, read `$JSON_PATH`.

Each run produces:
- Pass/fail summary for every T2 battle
- Full per-class win rate breakdown (sorted by win rate)
- Per-class combat stats (avg dealt / taken / mitigated / heals per battle) — always shown
- WEAK class diagnostics (offense/defense ratios + mitigated for classes below 60% of target)
- Persisted JSON for later reference

**Enemy tuning iteration** (changed battles only — much faster):
```bash
"$GODOT" --path PartingShadows --headless --script res://tools/battle_sim_parallel.gd -- \
  --battles BattleA,BattleB --diagnostics --compact --auto --jobs 20 --json "$JSON_PATH" --markdown "$MD_PATH" 2>&1 | grep -v "$NOISE" > "$SIM_OUT"
```
Then read `$SIM_OUT` with the Read tool.

---

## Quick Reference

```bash
GODOT="C:/Users/blake/AppData/Local/Microsoft/WinGet/Packages/GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe/Godot_v4.6.1-stable_win64_console.exe"
NOISE='No loader\|Oswald\|game_theme\|custom project\|Unreferenced static string\|RID allocations.*leaked\|Pages in use exist at exit\|PagedAllocator\|ObjectDB instances leaked\|resources still in use at exit\|OpenGL API\|NVIDIA\|WASAPI\|Cleanup\|Main::'
JSON_PATH="C:/Users/blake/.claude/projects/c--Projects-PartingShadows/memory/class-report-data.json"
MD_PATH="C:/Users/blake/.claude/projects/c--Projects-PartingShadows/memory/class-balance.md"
SIM_OUT="C:/Users/blake/.claude/projects/c--Projects-PartingShadows/memory/sim_output.txt"

# Quick iteration (single progression)
"$GODOT" --path PartingShadows --headless --script res://tools/battle_sim_parallel.gd -- \
  --story <N> --sample 100 --sims 50 --progression <P> --compact --jobs 20 --json "$JSON_PATH" 2>&1 | grep -v "$NOISE" > "$SIM_OUT"

# Tier validation with class data in one pass (recommended)
"$GODOT" --path PartingShadows --headless --script res://tools/battle_sim_parallel.gd -- \
  --story <N> --tier <TIER> --auto --all --diagnostics --compact --jobs 20 --json "$JSON_PATH" --markdown "$MD_PATH" 2>&1 | grep -v "$NOISE" > "$SIM_OUT"

# Targeted battles (specific changed battles only)
"$GODOT" --path PartingShadows --headless --script res://tools/battle_sim_parallel.gd -- \
  --battles S3_DreamShadowChase,S3_DreamLabyrinth --diagnostics --compact --auto --jobs 20 --json "$JSON_PATH" --markdown "$MD_PATH" 2>&1 | grep -v "$NOISE" > "$SIM_OUT"

# Full story validation (all tiers, all battles)
"$GODOT" --path PartingShadows --headless --script res://tools/battle_sim_parallel.gd -- \
  --story <N> --auto --all --diagnostics --compact --jobs 20 --json "$JSON_PATH" --markdown "$MD_PATH" 2>&1 | grep -v "$NOISE" > "$SIM_OUT"
```

**After every sim:** Read `$SIM_OUT` with the Read tool — with `--compact` it's ~1 line per battle. For class win rates or diagnostics, read `$JSON_PATH` directly.

### Parallel Sim Behavior

The parallel coordinator (`battle_sim_parallel.gd`) auto-detects the best split mode:

- **Stage-split** (default): each worker gets a round-robin slice of stages. Used when stages ≥ workers.
- **Combo-split** (auto): when fewer stages than workers (e.g. 3 battles, 8 workers), all workers share party combos. Single-stage and small-batch runs use all workers automatically.

**Worker count guidance:**
- Default on Windows: **20 workers**
- Full tier validation: `--jobs 20` recommended
- Maximum: `--jobs 32` (hard cap); diminishing returns above 20 for most runs
- Sentinel mechanism serializes Godot startup automatically — no manual stagger tuning needed

**IMPORTANT: Never run two sim processes at the same time.** Running two parallel sims simultaneously causes CPU contention (10x+ slower, unreliable results). Always wait for one sim to complete before launching the next.

### Persisted Class Data

The JSON file at `$JSON_PATH` accumulates results across runs. New runs merge into existing data, replacing matching stage names. Structure:

```json
{ "stages": [ { "stage_name": "...", "class_breakdown": { "ClassName": { "win_rate": 0.75, "wins": N, "total": N, "combo_count": N } }, "combat_stats": { "ClassName": { "avg_dealt": 210.3, "avg_taken": 185.2, "avg_mitigated": 42.1, "avg_heals": 8.5, "death_rate": 0.12 } } } ] }
```

**When you need class data** (band checks, outlier analysis, tier handoffs): read the JSON file first. Only re-sim if stats changed since it was written.

### Post-Run Analysis (No Re-Sim Required)

After any sim command that includes `--json "$JSON_PATH"`, the following skills work immediately:

- **`/fight-length`** -- reads `turn_stats` from the JSON to check for slogs and short bosses
- **`/class-report`** -- reads `class_breakdown` from the JSON to generate per-class win rate tables

No refresh or re-sim is needed. The JSON accumulates across runs (new results merge into existing data), so partial runs still leave a complete dataset.

### Resuming a Previous Session

1. Read the balance log. If it has an active pass, find the first non-LOCKED progression.
2. Start from that progression (do not re-validate already LOCKED progs unless a cascade occurred).
3. If the log shows a cascade note, start from the noted progression.
4. Check if `$JSON_PATH` has recent class data — use it for context instead of re-simming.

---

## The Loop

**Work one battle at a time, lowest progression to highest.** Tune each battle to PASS before moving to the next. Enemy-only changes only — do not adjust player stats or growth rates here.

```
FOR each progression 0 -> N, in order:
  FOR each battle in this progression, in order:
    +-----------------------------------------------+
    |  Enemy Tuning (one battle at a time)          |
    |  Run: --battles <ThisBattle> --diagnostics    |
    |  TOO HARD / TOO EASY?                         |
    |  -> adjust enemy stats -> re-sim -> repeat    |
    |  PASS -> move to next battle in progression   |
    +-----------------------------------------------+

  All battles in progression PASS?
  -> LOCK this progression, move to next
```

### Generic Cascade Scope

| Change Type | Affects | Restart From |
|-------------|---------|-------------|
| Enemy stat ranges | The battle using that enemy | Re-sim that battle |
| Enemy ability Modifier | Battles with enemies using that ability | Earliest battle using it |

---

## Enemy Stat Mechanics

Enemy stats use `_es(base_min, base_max, gmin, gmax, level, base_level)`:

```gdscript
f.health = _es(98, 113, 4, 7, 4, 1)
# Result: range from base_min + (lvl-base_level)*gmin to base_max + (lvl-base_level)*(gmax-1)
```

Growth is applied **once at construction time**, not per-turn.

### Tuning Levers (role-based)

**Tune by enemy role.** Look up each enemy's role in `enemy_roles.gd` and buff the stat that matches their combat identity. **Do NOT touch crit chance or dodge chance** — those are already tuned. Speed is a lever for DPS and non-tank Supports only.

| Role | Primary Lever | Secondary Lever | Notes |
|------|--------------|-----------------|-------|
| **TANK** | Favored defensive stat (HP, phys_def, or mag_def) | — | Maintain the 60/40 defense ratio from `compute_defense_type()` |
| **DPS** | Attack stat (phys or mag per damage type) | Speed | If CRIT subtype → buff `crit_damage` instead of attack |
| **BURST** | MP (`max_mana`) for sustained casting | Attack stat | **Never touch speed** — they're meant to be slow and hit hard |
| **FIGHTER** | Balanced (small bumps to attack + defense) | — | Well-rounded, don't skew in one direction |
| **SUPPORT (tank-typed)** | Survivability (HP / favored DEF) | — | Tank supports need to live longer to keep casting |
| **SUPPORT (non-tank)** | Speed | — | More turns = more heals/buffs/debuffs |

**Do NOT touch:**
- Crit chance (already tuned)
- Dodge chance (already tuned)
- Burst speed (intentionally slow)

**Fallback levers** (only when role-based adjustments aren't enough, gap >5%):
1. **Enemy count** — add/remove from battle config (see 3-Enemy Rule)
2. **Abilities** — swap abilities or change Modifiers
3. **Level parameter** — +1 level adds one growth roll to every stat

### 3-Enemy Rule

Every battle after the first must have **at least 3 enemies**, unless it is a boss fight. 3v2 battles give players a 50% action economy advantage, making stat tuning extremely sensitive.

---

## Step 1: Enemy Tuning

**Goal:** Each battle's overall win rate falls within target +/- 3%. Tune one battle at a time — sim only that battle, fix it, move on.

```bash
# Tune one battle at a time
"$GODOT" --path PartingShadows --headless --script res://tools/battle_sim_parallel.gd -- \
  --battles <BattleName> --diagnostics --compact --auto --jobs 20 --json "$JSON_PATH" --markdown "$MD_PATH" 2>&1 | grep -v "$NOISE" > "$SIM_OUT"
```
Then read `$SIM_OUT` with the Read tool to check the result.

- **PASS** -> move to the next battle in this progression
- **TOO HARD** -> weaken enemies by role: reduce TANK def/HP, lower DPS attack, reduce BURST MP, slow down non-tank SUPPORTs. Fallback: remove an enemy (if >3), reduce ability Modifiers
- **TOO EASY** -> strengthen enemies by role: buff TANK favored DEF (maintain 60/40), buff DPS attack (or crit_damage for CRIT subtype), buff BURST MP, speed up DPS/non-tank SUPPORTs, buff FIGHTER attack+defense. Fallback: add enemy, increase ability Modifiers

Once the battle PASSes, move to the next battle. Once all battles in the progression PASS, LOCK it and move on.

### When to Stop

All battles show PASS. Power curve roughly correct. Every class within or near the 57-93% band. **Perfection is not the goal.** Borderline 55-57% is acceptable variance.

---

## Simulator Flags

| Flag | Description |
|------|-------------|
| `--story <n>` | Filter to story 1, 2, or 3 |
| `--progression <n>` | Run all battles in a progression |
| `--progressive` | Run all progs in order, stop on failure |
| `--from <n>` | Start progressive run from prog n |
| `--all` | Run all battles |
| `--battles <a,b,...>` | Run specific battles by name (comma-separated) |
| `--auto` | Auto-calculate sims (200k+ total) |
| `--sims <n>` | Manual sims per combo |
| `--sample <n>` | Stratified sample of n combos |
| `--tier <t>` | Filter by tier (base, tier1, tier2) |
| `--diagnostics` | Show per-class win rate breakdown and WEAK class analysis (works in parallel sim) |
| `--compact` | Minimal stdout (1 line/PASS, 3-5 lines/FAIL) |
| `--json <path>` | Write/merge JSON report |
| `--markdown <path>` | Write markdown class balance report |
| `--jobs <n>` | Worker count (parallel only; default 20 on Windows) |
| `--stagger <ms>` | Delay between worker spawns if sentinel fails (parallel only; default 2000) |
| `--timeout <s>` | Kill workers after N seconds (parallel only; default max(300, jobs×120)) |
| `--no-cache` | Force re-simulation |

---

## Story Reference Files

Before tuning a story, read the story-specific reference file for difficulty gradient, class band table, battle-enemy mapping, cascade scope, power curve, and constraint rules:

- **Story 1:** `.claude/skills/battle-sim/SKILL-story1.md`
- **Story 2:** `.claude/skills/battle-sim/SKILL-story2.md`
- **Story 3:** `.claude/skills/battle-sim/SKILL-story3.md`

---

## Related Skills

| Skill | When to Use |
|-------|-------------|
| `/balance-log` | After each sim run to record results and changes |
| `/class-report` | After all progressions locked. Use `--from-json "$JSON_PATH"` with JSON from the final validation pass. |
| `/update-ability-catalog` | After changing abilities |

## Key Files

| File | Purpose |
|------|---------|
| `scripts/data/fighter_db.gd` | Base (T0) player class factories |
| `scripts/data/fighter_db_t1.gd` | Tier 1 growth |
| `scripts/data/fighter_db_t2.gd`, `fighter_db_t2b.gd` | Tier 2 growth |
| `scripts/data/ability_db.gd`, `ability_db_player.gd` | Player abilities |
| `scripts/tools/simulation_runner.gd` | CLASS BREAKDOWN, WEAK flags |
| `scripts/tools/battle_stage_db.gd` | Target win rates per stage |
| `tools/battle_simulator.gd` | Worker script (invoked by parallel coordinator) |
| `tools/battle_sim_parallel.gd` | Parallel coordinator |

Enemy DBs and battle configs are story-specific -- see the story reference files.
