---
name: difficulty-baseline
description: Normal difficulty baseline for EchoesOfChoiceTactical. Use when adding difficulty modes (Easy/Hard), scaling enemy stats, or verifying that a difficulty tier matches its intended feel. Documents what "Normal" means, how to derive Easy/Hard from it, and how to validate each tier with balance_check.gd.
---

# Difficulty Baseline — Echoes of Choice Tactical

This skill defines the **Normal difficulty** baseline that all current enemy tuning targets,
and documents how to derive Easy and Hard from it without touching .tres files.

---

## What "Normal" Means

All enemy `.tres` files are tuned for Normal difficulty. The balance targets are:

| Metric | Normal Target |
|--------|--------------|
| Win rate (Prog 0) | ~90% |
| Win rate (Prog 3) | ~77% |
| Win rate (Prog 6) | ~60% |
| Damage to most vulnerable class | 3–7 per hit (scales with prog) |
| TTK (Squire hits to kill typical enemy) | 3–7 |
| All `balance_check.gd` flags | ✓ (no unexplained ⚠ flags) |

The `.tres` stat values **are** Normal. Easy and Hard are applied as runtime multipliers — the
source files never change for difficulty.

---

## Normal Difficulty Baseline — balance_check.gd Output Reference

Run the tool to get the live baseline:
```
Godot_v4.6.1-stable_win64_console.exe --path EchoesOfChoiceTactical --headless --script res://tools/balance_check.gd
```

**Expected flags at Normal (all intentional — do not fix):**
| Battle | Flag | Reason |
|--------|------|--------|
| city_street | ⚠SLOW Street Tough (TTK=11) | Known borderline; Prog 0 is forgiving |
| village_raid | ⚠ZERO Goblin Archer | Known bug; deferred |
| village_raid | ⚠ZERO Goblin Shaman | Intentional healer/support design |
| smoke | ⚠T1MAGE | Acolyte = magic counter in magic-only battle; by design |
| forest / village_raid | per-enemy ⚠ vs Warden in T1 section | Warden rare at Prog 1 (50 JP gate) |

Any ⚠ flag not in this list at Normal is a bug to fix before locking the baseline.

---

## Scaling Approach for Easy and Hard

**Core principle:** Enemy stats are the lever. Party stats stay constant across all difficulties
(player skill and class choices don't change). Apply multipliers at runtime in the battle
loading code; never edit `.tres` files for difficulty.

### Recommended Multipliers

| Difficulty | Enemy HP | Enemy ATK (phys + mag) | Enemy DEF | Notes |
|------------|----------|----------------------|-----------|-------|
| Easy       | × 0.80   | × 0.80               | × 0.90    | Forgiving; good for new players |
| Normal     | × 1.00   | × 1.00               | × 1.00    | Baseline (current .tres values) |
| Hard       | × 1.25   | × 1.25               | × 1.10    | Punishing; rewards mastery |

ATK multiplier applies to both `base_physical_attack` and `base_magic_attack`.
DEF multiplier applies to `base_physical_defense` (and `base_magic_defense` if present on enemies).
HP multiplier applies to `base_max_health`.

Growth stats (all enemy growths are 0 currently) are unaffected.

### Expected Metric Shifts

| Difficulty | Win rate shift | Damage shift | TTK shift |
|------------|---------------|-------------|-----------|
| Easy       | +8 to +12%    | −20%        | +20–25% longer |
| Hard       | −8 to −12%    | +25%        | −20–25% shorter |

At Hard, some ⚠SPIKE and ⚠EASY flags may appear when running balance_check.gd. That's
expected and acceptable for Hard mode — the tool baseline is always Normal.

---

## Godot Implementation Sketch

Store the difficulty setting in `GameState` and apply multipliers when spawning enemy Units.

```gdscript
# game_state.gd (add to existing autoload)
var difficulty: String = "normal"  # "easy", "normal", "hard"

func get_enemy_multipliers() -> Dictionary:
    match difficulty:
        "easy":   return {"hp": 0.80, "atk": 0.80, "def": 0.90}
        "hard":   return {"hp": 1.25, "atk": 1.25, "def": 1.10}
        _:        return {"hp": 1.00, "atk": 1.00, "def": 1.00}
```

Apply in the enemy Unit initialization (in `BattleMap.gd` or `Unit.gd` where enemy stats load):
```gdscript
# When spawning an enemy unit from FighterData:
var mults: Dictionary = GameState.get_enemy_multipliers()
unit.base_max_health       = roundi(fighter_data.base_max_health       * mults["hp"])
unit.base_physical_attack  = roundi(fighter_data.base_physical_attack  * mults["atk"])
unit.base_magic_attack     = roundi(fighter_data.base_magic_attack     * mults["atk"])
unit.base_physical_defense = roundi(fighter_data.base_physical_defense * mults["def"])
# (apply before calling unit.initialize() so the multiplied values are used)
```

Keep difficulty selection in the title screen or options menu. Persist in save data.

---

## Validating a Difficulty Tier with balance_check.gd

The tool always reads `.tres` files directly (Normal values). To check Easy/Hard:

1. Temporarily update the `PARTY` and `SQUIRE_PHYS_ATK` constants in `balance_check.gd` to
   reflect the scaled enemy stats — **or** — add a `--difficulty easy` arg to the tool that
   applies multipliers to the loaded enemy stats before printing.

2. **Simpler method:** Run the Normal tool output and mentally apply the multipliers:
   - Easy: all damage values × 0.80, all HP × 0.80 (TTK stays similar since both scale)
   - Hard: all damage values × 1.25, check for new ⚠SPIKE flags

3. The key Hard check: after applying × 1.25 ATK, does any enemy deal more than half a
   party member's HP in one hit? If so, spike risk has appeared — consider raising that
   enemy's hard multiplier only to 1.15 as an exception.

---

## Party Attack Reference (Normal — for manual TTK checks at Easy/Hard)

At Easy (enemy HP × 0.80), TTK drops proportionally — enemies die 20% faster.
At Hard (enemy HP × 1.25), TTK rises — enemies take 25% more hits.

Squire phys_atk at Normal: see `balance-thresholds` skill SQUIRE_PHYS_ATK table.

Since enemies have growth=0, TTK formula is always:
```
ttk = ceil(enemy_hp × hp_mult / max(1, squire_phys_atk - enemy_phys_def × def_mult))
```

---

## When to Revisit This Baseline

- After any new balance pass (Prog 4+, Prog 7 elemental, future content)
- After changing party class stats (Squire/Mage/Scholar/Entertainer base stats)
- After changing the Warden or Acolyte class stats (T1 profiles in balance-thresholds)
- After adding new shop tiers that change party defense profiles
- Before locking a release build — run the full tool, confirm only the known-acceptable flags remain

The baseline is "locked" when `balance_check.gd` produces only the expected design-intent
flags listed above and no unexpected ⚠ flags for any of the ten battles.
