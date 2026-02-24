---
name: balance-thresholds
description: Reference for EchoesOfChoiceTactical balance targets per progression stage. Use when interpreting balance_check.gd output, tuning enemy stats, or deciding if a number is acceptable. Contains win-rate targets, damage-per-hit ranges, TTK targets, party defense profiles, Tier 1 extreme defender profiles, and fix recipes for each flag type.
---

# Balance Thresholds — Echoes of Choice Tactical

Single source of truth for what "balanced" looks like at each progression stage.
Use alongside `balance_check.gd` output when deciding if numbers need tuning.

---

## Win-Rate Targets

| Prog | Stage Feel     | Target Win Rate |
|------|----------------|-----------------|
| 0    | Tutorial       | ~90%            |
| 1    | Easy           | ~88%            |
| 2    | Moderate       | ~83%            |
| 3    | Challenge      | ~77%            |
| 4    | Hard           | ~72%            |
| 5    | Very Hard      | ~65%            |
| 6    | Brutal         | ~60%            |
| 7+   | Finale         | ~58%            |

These are for **Normal difficulty**. See `difficulty-baseline` skill for Easy/Hard adjustments.

---

## Corrected Party Defense Profiles

**Equipment assumption:** All classes prioritize P.Def equipment. No M.Def equipment bonus.
M.Def grows only from class level growths.

Equipment bonus to P.Def per progression (no M.Def bonus):
- Prog 0: +0 (no shop)
- Prog 1–2: +3 (Forest Village — Tier 0 Guardian Seal ~60g)
- Prog 3–4: +5 (Crossroads Inn — Tier 1 Guardian Seal ~140g)
- Prog 5–6: +5 P.Def +10 HP (Gate Town — two equipment slots)
- Prog 7–8: +8 P.Def +15 HP (Tier 2 unlocked — two-three slots)

Base class stats (Level 1):

| Class       | P.Def | M.Def | P.Def growth | M.Def growth |
|-------------|-------|-------|--------------|--------------|
| Squire      | 15    | 13    | +2/level     | +2/level     |
| Mage        | 13    | 18    | +2/level     | +2/level     |
| Scholar     | 12    | 18    | +2/level     | +2/level     |
| Entertainer | 13    | 18    | +2/level     | +3/level     |

**Full defense table (the constants used by balance_check.gd):**

| Prog | Lv | Sq P.Def | Sq M.Def | Mg P.Def | Mg M.Def | Sc P.Def | Sc M.Def | En P.Def | En M.Def |
|------|----|----------|----------|----------|----------|----------|----------|----------|----------|
| 0    | 1  | 15       | 13       | 13       | 18       | 12       | 18       | 13       | 18       |
| 1    | 2  | 20       | 15       | 18       | 20       | 17       | 20       | 18       | 21       |
| 2    | 3  | 22       | 17       | 20       | 22       | 19       | 22       | 20       | 24       |
| 3    | 4  | 26       | 19       | 24       | 24       | 23       | 24       | 24       | 27       |
| 4    | 4  | 26       | 19       | 24       | 24       | 23       | 24       | 24       | 27       |
| 5    | 5  | 33       | 21       | 31       | 26       | 30       | 26       | 31       | 30       |
| 6    | 6  | 35       | 23       | 33       | 28       | 32       | 28       | 33       | 33       |
| 7    | 6  | 38       | 23       | 36       | 28       | 35       | 28       | 36       | 33       |
| 8    | 7  | 41       | 25       | 39       | 30       | 38       | 30       | 39       | 36       |

**Key insight:** Squire has the lowest M.Def (no M.Def equipment), Scholar has the lowest P.Def.
Magic enemies hurt Squire most. Physical enemies hurt Scholar most.

---

## Squire Attack Output (for TTK calculation)

Squire base_physical_attack=18, growth=+2/level.

| Prog | Level | Squire Phys Atk |
|------|-------|-----------------|
| 0    | 1     | 18              |
| 1    | 2     | 20              |
| 2    | 3     | 22              |
| 3    | 4     | 24              |
| 4    | 4     | 24              |
| 5    | 5     | 26              |
| 6    | 6     | 28              |
| 7    | 6     | 28              |
| 8    | 7     | 30              |

---

## Tier 1 Extreme Defender Profiles

At ~50 JP (available from Prog 1+), players may have promoted to **Warden** (best physical tank) or
**Acolyte** (best magic tank). `balance_check.gd` checks both after the main damage matrix.

**Class stats (after tuning):**
- Warden: base P.Def=19, growth_phys_def=4, base M.Def=13, growth_mag_def=2
- Acolyte: base P.Def=13, growth_phys_def=2, base M.Def=20, growth_mag_def=3

**Tool uses no-equipment assumption** (T1 class may not have had time to buy gear after promotion).
Values = base + growth×(level−1):

| Prog | Lv | Warden P.Def | Warden M.Def | Acolyte P.Def | Acolyte M.Def |
|------|----|-------------|-------------|--------------|--------------|
| 1    | 2  | 23          | 15          | 15           | 23           |
| 2    | 3  | 27          | 17          | 17           | 26           |
| 3    | 4  | 31          | 19          | 19           | 29           |
| 4    | 4  | 31          | 19          | 19           | 29           |
| 5    | 5  | 35          | 21          | 21           | 32           |
| 6    | 6  | 39          | 23          | 23           | 35           |
| 7    | 6  | 39          | 23          | 23           | 35           |
| 8    | 7  | 43          | 25          | 25           | 38           |

**T1 flags:**
- `⚠T1TANK` — no enemy threatens Warden (physical tank immune to all physical attacks)
- `⚠T1MAGE` — no enemy threatens Acolyte (magic tank immune to all magic attacks)
- `✓T1` — both classes are threatened by at least one enemy

**Design-intent exceptions** — some T1 flags are expected and NOT action items (see below).

---

## Damage-per-Hit Targets

How much should an enemy deal to the **most vulnerable class** per hit?

| Prog | Target Range | Most Vulnerable (phys) | Most Vulnerable (mag) |
|------|-------------|------------------------|----------------------|
| 0    | 2–5         | Scholar (P.Def 12)     | Squire (M.Def 13)    |
| 1    | 2–5         | Scholar (P.Def 17)     | Squire (M.Def 15)    |
| 2    | 3–6         | Scholar (P.Def 19)     | Squire (M.Def 17)    |
| 3    | 4–7         | Scholar (P.Def 23)     | Squire (M.Def 19)    |
| 4    | 4–8         | Scholar (P.Def 23)     | Squire (M.Def 19)    |
| 5    | 5–9         | Scholar (P.Def 30)     | Squire (M.Def 21)    |
| 6    | 5–10        | Scholar (P.Def 32)     | Squire (M.Def 23)    |
| 7    | 6–12        | Scholar (P.Def 35)     | Squire (M.Def 23)    |

It is **OK** for an enemy to deal 0 damage to some classes (e.g., Witch at Prog 2 dealing 0 mag
to Entertainer with M.Def 24 is fine). The floor is: damage ≥ 1 to **at least one class**.

Support units (healers, buffers) may legitimately deal 0 damage to all — that's a design choice,
not a bug. Review the `⚠ZERO` flag in context.

---

## TTK Targets (Squire hits to kill an enemy)

| TTK   | Classification | Flag     | Notes                              |
|-------|---------------|----------|------------------------------------|
| = 1   | Glass cannon  | ⚠ EASY   | Squire one-shots — raise enemy HP  |
| 2–3   | Fodder        | —        | Intended to fall quickly           |
| 4–6   | Standard      | —        | Main line — normal effort          |
| 7–10  | Tanky         | —        | Boss/miniboss — focus target       |
| > 10  | Slugfest      | ⚠ SLOW   | HP likely too high; reduce it      |

---

## Spike Definition

An enemy is a **spike risk** if it kills any class in fewer than 3 hits:

```
spike = (enemy_hp / max_dmg_vs_class) < 3
```

- Any 1-hit kill at Prog 0–4 is always a problem
- A 2-hit kill at Prog 5+ may be acceptable for a named boss
- Fix by reducing attack by 3–5 points or raising target class HP via equipment profile

---

## Required Attack Values (Quick Reference)

**Physical attack to deal N damage:**
```
vs Scholar (lowest P.Def): phys_atk = scholar_phys_def + N
vs Squire:                 phys_atk = squire_phys_def  + N
```

**Magic attack to deal N damage (with ability modifier M):**
```
vs Squire (lowest M.Def):  mag_atk = squire_mag_def - M + N
```

**Examples at Prog 2 (Scholar P.Def=19, Squire M.Def=17, typical ability_modifier=2):**
- 3 phys damage to Scholar: need phys_atk = 22
- 5 phys damage to Scholar: need phys_atk = 24
- 3 mag damage to Squire: need mag_atk = 18
- 5 mag damage to Squire: need mag_atk = 20

**Examples at Prog 3 (Scholar P.Def=23, Squire M.Def=19, typical ability_modifier=2):**
- 4 phys damage to Scholar: need phys_atk = 27
- 7 phys damage to Scholar: need phys_atk = 30
- 4 mag damage to Squire: need mag_atk = 21
- 7 mag damage to Squire: need mag_atk = 24

---

## Fixing Each Flag Type

### ⚠ ZERO — enemy deals 0 to all classes

**Cause A — attack stat too low:** Raise `base_physical_attack` or `base_magic_attack`.
```
Fix phys: new_phys_atk = scholar_phys_def + 3      # Scholar takes 3 damage
Fix mag:  new_mag_atk  = squire_mag_def - ability_modifier + 3   # Squire takes 3 magic
```

**Cause B — only DEBUFF/HEAL abilities, no DAMAGE ability:** Check every ability's `ability_type`.
`0=DAMAGE`, `1=HEAL`, `2=BUFF`, `3=DEBUFF`, `4=TERRAIN`. Only `ability_type=0` contributes to
the damage calculation. If all abilities are DEBUFF/HEAL, add a `spirit_touch.tres` (magic DAMAGE)
or `slash.tres` (physical DAMAGE) as the base attack. This was the root cause for Sprite and
Dusk Moth — both had high `base_magic_attack` but only DEBUFF abilities.

### ⚠ SPIKE — kills a class in <3 hits

**Cause:** too much damage or class HP too low.

**Fix:** Reduce `base_physical_attack` or `base_magic_attack` by 3–5 points until ratio ≥ 3.0.

### ⚠ SLOW — Squire needs >10 hits to kill

**Cause:** enemy HP too high relative to Squire's attack at this progression.

**Formula:** `ttk = ceil(enemy_hp / max(1, squire_phys_atk - enemy_phys_def))`

**Fix:** Reduce `base_max_health` until TTK ≤ 10.

### ⚠ EASY — Squire one-shots (TTK = 1)

**Cause:** enemy HP too low. Squire one-shot means the enemy may not even act before dying.

**Fix:** Raise `base_max_health` until TTK ≥ 2. Target TTK = 2–3 for small/fragile units.
```
min_hp = squire_phys_atk - enemy_phys_def + 1     # at minimum; prefer TTK=2 → min_hp = (sq_dmg * 2) - 1
```

---

## Design-Intent Flags (Acceptable ⚠s)

Some flags are expected and should **not** be fixed:

### ⚠T1MAGE in `smoke` (Prog 2)
Acolyte (M.Def=26) is immune to Imp (fire_spark total=18) and Fire Spirit (flame_wave total=24).
**Why OK:** Acolyte is the magic-counter class. Its entire identity is resisting magic. A pure-magic
battle is exactly where Acolyte shines. Raising magic damage to threaten Acolyte here would
create spike risk for base Squire (M.Def=17).

### ⚠T1TANK in `forest` / `village_raid` (Prog 1)
Bear (cleave total=22) and Wild Boar (basic total=14+?) can't penetrate Warden P.Def=23.
**Why OK:** Tier 1 requires ~50 JP. Players are extremely unlikely to have promoted to Warden
before completing Prog 1. The flag exists as a long-term coverage note, not a day-one problem.

### ⚠ZERO for `Goblin Shaman` in `village_raid`
Pure healer/support design. Intentional — this enemy exists to heal allies, not attack.

### ⚠SLOW for `Street Tough` in `city_street` (TTK=11)
Known borderline case (HP=52, TTK=11). A single-point fix: reduce HP to 48 → TTK=10.
Not treated as urgent since it's the tutorial battle and Prog 0 is intentionally forgiving.

### ⚠ZERO for `Goblin Archer` in `village_raid`
Known bug. arrow_shot mod=2 + low phys_atk barely misses Scholar P.Def=17. Fix: raise
`base_physical_attack` by 2–3 points. Deferred; Prog 1 is already easy enough.

---

## How to Run the Balance Check Tool

```
Godot_v4.6.1-stable_win64_console.exe --path EchoesOfChoiceTactical --headless --script res://tools/balance_check.gd
```

Filter to a single battle:
```
Godot_v4.6.1-stable_win64_console.exe --path EchoesOfChoiceTactical --headless --script res://tools/balance_check.gd -- deep_forest
```

**Output legend:**
- `Xp/Ym` = X phys damage / Y magic damage per hit vs that class
- `TTK` = Squire basic-attack hits to kill the enemy
- `⚠ZERO` = deals 0 to every class (needs fixing unless intentional support unit)
- `⚠SPIKE` = kills a class in <3 hits (review)
- `⚠SLOW` = Squire needs >10 hits to kill (HP may be too high)
- `⚠EASY` = Squire one-shots the enemy (HP too low, enemy may never act)
- `✓` = all clear — damage present, no spikes, TTK 2–10
- T1 section: `Warden Xp/Ym` / `Acolyte Xp/Ym` = damage vs each T1 extreme
- T1 `⚠` per-enemy = that enemy can't threaten this T1 class at all
- `⚠T1TANK` = no enemy in battle threatens Warden
- `⚠T1MAGE` = no enemy in battle threatens Acolyte
- `✓T1` = both T1 extremes are threatened by at least one enemy

**Battles tracked:** city_street (P0), forest (P1), village_raid (P1), smoke (P2),
deep_forest (P2), clearing (P2), ruins (P2), cave (P3), portal (P3), inn_ambush (P3)
