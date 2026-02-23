---
name: balance-thresholds
description: Reference for EchoesOfChoiceTactical balance targets per progression stage. Use when interpreting balance_check.gd output, tuning enemy stats, or deciding if a number is acceptable. Contains win-rate targets, damage-per-hit ranges, TTK targets, party defense profiles, and fix recipes for each flag type.
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

| TTK Range | Classification | Notes                              |
|-----------|---------------|------------------------------------|
| 1–3       | Fodder        | Intended to fall quickly           |
| 3–6       | Standard      | Main line — normal effort          |
| 7–10      | Tanky         | Boss/miniboss — focus target       |
| > 10      | ⚠ SLOW        | Review — HP likely too high        |

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

**Cause:** attack stat too low relative to party defense at this progression.

**Fix physical ZERO:** Raise `base_physical_attack` so Scholar takes ≥ 3 damage:
```
new_phys_atk = scholar_phys_def + 3
```

**Fix magic ZERO:** Raise `base_magic_attack` so Squire takes ≥ 3 magic damage:
```
new_mag_atk = squire_mag_def - ability_modifier + 3
```

### ⚠ SPIKE — kills a class in <3 hits

**Cause:** too much damage or class HP too low.

**Fix:** Reduce `base_physical_attack` or `base_magic_attack` by 3–5 points until ratio ≥ 3.0.

### ⚠ SLOW — Squire needs >10 hits to kill

**Cause:** enemy HP too high relative to Squire's attack at this progression.

**Formula:** `ttk = ceil(enemy_hp / max(1, squire_phys_atk - enemy_phys_def))`

**Fix:** Reduce `base_max_health` until TTK ≤ 10.

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
- `✓` = all clear

**Battles tracked:** city_street (P0), forest (P1), village_raid (P1), smoke (P2),
deep_forest (P2), clearing (P2), ruins (P2), cave (P3), portal (P3), inn_ambush (P3)
