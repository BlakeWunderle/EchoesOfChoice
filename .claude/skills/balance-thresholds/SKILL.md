---
name: balance-thresholds
description: Reference for EchoesOfChoiceTactical balance targets per progression stage. Use when interpreting balance_check.gd output, tuning enemy stats, or deciding if a number is acceptable. Contains damage scaling philosophy, TTK targets, party defense profiles, T1/T2 defender profiles, and fix recipes for each flag type.
---

# Balance Thresholds — Echoes of Choice Tactical

Single source of truth for what "balanced" looks like at each progression stage.
Use alongside `balance_check.gd` output when deciding if numbers need tuning.

---

## Balance Philosophy — Damage Scaling

Balance is driven by **damage numbers and TTK**, not win rates.

**Attack growth outpaces defense growth.** This is by design — enemy attack stats should exceed party defense stats at each progression, producing positive damage per hit. As progression increases, raw damage numbers go up for both sides.

**HP growth compensates.** Even though enemies hit harder at higher progs, party HP grows to absorb it. The result: TTK stays in the 2-10 range across all progressions. If TTK drifts outside this band, one side's growth rate is wrong.

| Prog | Stage Feel | What Scales Up |
|------|------------|---------------|
| 0 | Tutorial | Low damage (2-12p), low HP. Enemies are fragile (TTK 3-6). |
| 1-2 | Easy/Moderate | Damage climbs, HP keeps pace. First T1 defenders appear. |
| 3-4 | Challenge | T2 defenders join. Extreme tanks (Bastion PD 49, Priest MD 33) start resisting. Enemies need mixed damage types. |
| 5-6 | Hard/Brutal | High damage numbers but high HP. Equipment (+10 PD) narrows the gap — enemies need stronger attacks to stay threatening. |

**What to check at each prog:**
- Damage is positive vs the weakest base class (Mage for phys, Squire for mag)
- Damage numbers are higher than the previous prog (growth is working)
- TTK stays in 2-10 (HP is compensating)
- T1/T2 extreme defenders are threatened by at least one enemy per battle

---

## Party Defense Profiles

**Equipment assumption:** All classes prioritize P.Def equipment. No M.Def equipment bonus.
M.Def grows only from class level growths.

Equipment PD bonus per progression (effective total from available shop + slot count):
- Prog 0: +0 (no shop)
- Prog 1–2: +3 (Forest Village — T0 Guardian Seal, 1 slot)
- Prog 3–4: +5 (Crossroads Inn — T1 Guardian Seal, 2 slots but 1 defense)
- Prog 5–6: +10 (Gate Town — 2 defense slots, T0+T1 or T1×2)
- Prog 7–8: +13/+14 (Tier 2 unlocked — 3 slots, T1+T2 defense mix)

Base class stats (Level 1):

| Class       | P.Def | M.Def | P.Def growth | M.Def growth |
|-------------|-------|-------|--------------|--------------|
| Squire      | 15    | 11    | +2/level     | +2/level     |
| Mage        | 11    | 18    | +2/level     | +2/level     |
| Scholar     | 12    | 20    | +2/level     | +2/level     |
| Entertainer | 12    | 18    | +2/level     | +3/level     |

**Key insight:** Mage has the lowest P.Def (11) — physical enemies hurt Mage most.
Squire has the lowest M.Def (11) — magic enemies hurt Squire most.

**Full defense table (the constants used by balance_check.gd PARTY dict):**

| Prog | Lv | Sq P.Def | Sq M.Def | Mg P.Def | Mg M.Def | Sc P.Def | Sc M.Def | En P.Def | En M.Def |
|------|----|----------|----------|----------|----------|----------|----------|----------|----------|
| 0    | 1  | 15       | 11       | 11       | 18       | 12       | 20       | 12       | 18       |
| 1    | 2  | 20       | 13       | 16       | 20       | 17       | 22       | 17       | 21       |
| 2    | 3  | 22       | 15       | 18       | 22       | 19       | 24       | 19       | 24       |
| 3    | 4  | 26       | 17       | 22       | 24       | 23       | 26       | 23       | 27       |
| 4    | 4  | 26       | 17       | 22       | 24       | 23       | 26       | 23       | 27       |
| 5    | 5  | 33       | 19       | 29       | 26       | 30       | 28       | 30       | 30       |
| 6    | 6  | 35       | 21       | 31       | 28       | 32       | 30       | 32       | 33       |
| 7    | 6  | 38       | 21       | 34       | 28       | 35       | 30       | 35       | 33       |
| 8    | 7  | 41       | 23       | 37       | 30       | 38       | 32       | 38       | 36       |

---

## Squire Attack Output (for TTK calculation)

Squire base_physical_attack=21, growth=+2/level.

| Prog | Level | Squire Phys Atk |
|------|-------|-----------------|
| 0    | 1     | 21              |
| 1    | 2     | 23              |
| 2    | 3     | 25              |
| 3    | 4     | 27              |
| 4    | 4     | 27              |
| 5    | 5     | 29              |
| 6    | 6     | 31              |
| 7    | 6     | 31              |
| 8    | 7     | 33              |

---

## Tier 1 Representative Defender Profiles

At ~50 JP (available from Prog 1+), players may have promoted to Tier 1 classes.
`balance_check.gd` checks 6 T1 representatives after the main damage matrix.

**No equipment bonus assumed** (T1 class may not have had time to buy gear after promotion).
Values = base + growth × (level − 1).

**Class base stats:**

| Class | Role | P.Def | P.Def growth | M.Def | M.Def growth |
|-------|------|-------|-------------|-------|-------------|
| Warden | Phys tank | 23 | +4 | 13 | +2 |
| Acolyte | Mag tank | 13 | +2 | 23 | +3 |
| Ranger | Phys mid | 17 | +2 | 11 | +2 |
| Firebrand | Mag glass | 10 | +2 | 18 | +3 |
| Dervish | Dodge/hybrid | 12 | +2 | 18 | +2 |
| Martial Artist | Phys glass | 14 | +3 | 10 | +2 |

**Full T1 defense table (PARTY_T1 in balance_check.gd):**

| Prog | Lv | Ward PD | Ward MD | Aco PD | Aco MD | Rang PD | Rang MD | Fire PD | Fire MD | Derv PD | Derv MD | MArt PD | MArt MD |
|------|----|---------|---------|--------|--------|---------|---------|---------|---------|---------|---------|---------|---------|
| 1    | 2  | 27      | 15      | 15     | 26     | 19      | 13      | 12      | 21      | 14      | 20      | 17      | 12      |
| 2    | 3  | 31      | 17      | 17     | 29     | 21      | 15      | 14      | 24      | 16      | 22      | 20      | 14      |
| 3    | 4  | 35      | 19      | 19     | 32     | 23      | 17      | 16      | 27      | 18      | 24      | 23      | 16      |
| 4    | 4  | 35      | 19      | 19     | 32     | 23      | 17      | 16      | 27      | 18      | 24      | 23      | 16      |
| 5    | 5  | 39      | 21      | 21     | 35     | 25      | 19      | 18      | 30      | 20      | 26      | 26      | 18      |
| 6    | 6  | 43      | 23      | 23     | 38     | 27      | 21      | 20      | 33      | 22      | 28      | 29      | 20      |
| 7    | 6  | 43      | 23      | 23     | 38     | 27      | 21      | 20      | 33      | 22      | 28      | 29      | 20      |
| 8    | 7  | 47      | 25      | 25     | 41     | 29      | 23      | 22      | 36      | 24      | 30      | 32      | 22      |

**T1 flags:**
- Per-enemy `⚠` = that enemy can't threaten a specific T1 class (OK if another enemy covers it)
- `⚠T1TANK` = no enemy in the battle threatens Warden (phys tank immune to all)
- `⚠T1MAGE` = no enemy in the battle threatens Acolyte (mag tank immune to all)
- `✓T1` = all 6 T1 classes are threatened by at least one enemy

---

## Tier 2 Representative Defender Profiles

At ~100 JP (available from Prog 3+), players may have promoted to Tier 2 classes.
`balance_check.gd` checks 8 T2 representatives.

**No equipment bonus assumed.**

**Class base stats:**

| Class | Role | P.Def | P.Def growth | M.Def | M.Def growth |
|-------|------|-------|-------------|-------|-------------|
| Bastion | Phys extreme | 28 | +7 | 15 | +3 |
| Paladin | Balanced tank | 22 | +5 | 18 | +4 |
| Ninja | Phys glass | 14 | +2 | 10 | +2 |
| Cavalry | Phys attacker | 14 | +3 | 10 | +2 |
| Pyromancer | Mag glass | 10 | +2 | 17 | +3 |
| Priest | Mag extreme | 13 | +2 | 21 | +4 |
| Mercenary | Crit glass | 14 | +2 | 10 | +2 |
| Illusionist | Dodge glass | 10 | +2 | 17 | +3 |

**Full T2 defense table (PARTY_T2 in balance_check.gd):**

| Prog | Lv | Bast PD | Bast MD | Pala PD | Pala MD | Ninj PD | Ninj MD | Cav PD | Cav MD | Pyro PD | Pyro MD | Prie PD | Prie MD | Merc PD | Merc MD | Illu PD | Illu MD |
|------|----|---------|---------|---------|---------|---------|---------|--------|--------|---------|---------|---------|---------|---------|---------|---------|---------|
| 3    | 4  | 49      | 24      | 37      | 30      | 20      | 16      | 23     | 16     | 16      | 26      | 19      | 33      | 20      | 16      | 16      | 26      |
| 4    | 4  | 49      | 24      | 37      | 30      | 20      | 16      | 23     | 16     | 16      | 26      | 19      | 33      | 20      | 16      | 16      | 26      |
| 5    | 5  | 56      | 27      | 42      | 34      | 22      | 18      | 26     | 18     | 18      | 29      | 21      | 37      | 22      | 18      | 18      | 29      |
| 6    | 6  | 63      | 30      | 47      | 38      | 24      | 20      | 29     | 20     | 20      | 32      | 23      | 41      | 24      | 20      | 20      | 32      |
| 7    | 6  | 63      | 30      | 47      | 38      | 24      | 20      | 29     | 20     | 20      | 32      | 23      | 41      | 24      | 20      | 20      | 32      |
| 8    | 7  | 70      | 33      | 52      | 42      | 26      | 22      | 32     | 22     | 22      | 35      | 25      | 45      | 26      | 22      | 22      | 35      |

**T2 flags:**
- Per-enemy `⚠` = that enemy can't threaten a specific T2 class
- `⚠T2TANK` = no enemy threatens Bastion (phys extreme — P.Def 49+ at Prog 3)
- `⚠T2MAGE` = no enemy threatens Priest (mag extreme — M.Def 33+ at Prog 3)
- `✓T2` = all 8 T2 classes are threatened by at least one enemy

---

## Damage-per-Hit Reference

Enemy damage vs the **most vulnerable class** should be positive and scale upward. The table shows the weakest defense at each prog — this is the floor enemies must exceed to deal any damage.

| Prog | Weakest Phys Def | Weakest Mag Def | Expected Damage Range (vs weakest) |
|------|-----------------|-----------------|-----------------------------------|
| 0    | Mage PD 11      | Squire MD 11    | 2-8 (low stats, small numbers)    |
| 1    | Mage PD 16      | Squire MD 13    | 1-8 (slight growth, equip +3 PD) |
| 2    | Mage PD 18      | Squire MD 15    | 3-10 (scaling up)                 |
| 3    | Mage PD 22      | Squire MD 17    | 4-12 (T1 equip, larger numbers)   |
| 4    | Mage PD 22      | Squire MD 17    | 4-12 (same level as P3)           |
| 5    | Mage PD 29      | Squire MD 19    | 5-14 (equip +10 PD, big jump)     |
| 6    | Mage PD 31      | Squire MD 21    | 5-15 (late-game numbers)          |
| 7    | Mage PD 34      | Squire MD 21    | 6-18 (finale)                     |

**Key rule:** Damage must be positive (> 0) vs at least one base class. It's OK for an enemy to deal 0 to some classes — a physical enemy dealing 0 to Entertainer (high M.Def) while hitting Mage for 10p is fine. The flags catch the problems:
- `⚠ZERO` = 0 damage to ALL classes (enemy is toothless)
- `⚠SPIKE` = too MUCH damage (kills a class in <3 hits — HP can't compensate)

Support units (healers, buffers) may legitimately deal 0 damage to all — that's a design choice, not a bug. Review the `⚠ZERO` flag in context.

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
vs Mage (lowest P.Def):    phys_atk = mage_phys_def + N
vs Squire:                  phys_atk = squire_phys_def + N
```

**Magic attack to deal N damage (with ability modifier M):**
```
vs Squire (lowest M.Def):  mag_atk = squire_mag_def - M + N
```

**Examples at Prog 2 (Mage P.Def=18, Squire M.Def=15, typical ability_modifier=2):**
- 3 phys damage to Mage: need phys_atk = 21
- 5 phys damage to Mage: need phys_atk = 23
- 3 mag damage to Squire: need mag_atk = 16
- 5 mag damage to Squire: need mag_atk = 18

**Examples at Prog 3 (Mage P.Def=22, Squire M.Def=17, typical ability_modifier=2):**
- 4 phys damage to Mage: need phys_atk = 26
- 7 phys damage to Mage: need phys_atk = 29
- 4 mag damage to Squire: need mag_atk = 19
- 7 mag damage to Squire: need mag_atk = 22

---

## Fixing Each Flag Type

### ⚠ ZERO — enemy deals 0 to all classes

**Cause A — attack stat too low:** Raise `base_physical_attack` or `base_magic_attack`.
```
Fix phys: new_phys_atk = mage_phys_def + 3         # Mage takes 3 damage
Fix mag:  new_mag_atk  = squire_mag_def - ability_modifier + 3   # Squire takes 3 magic
```

**Cause B — only DEBUFF/HEAL abilities, no DAMAGE ability:** Check every ability's `ability_type`.
`0=DAMAGE`, `1=HEAL`, `2=BUFF`, `3=DEBUFF`, `4=TERRAIN`. Only `ability_type=0` contributes to
the damage calculation. If all abilities are DEBUFF/HEAL, add a `spirit_touch.tres` (magic DAMAGE)
or `slash.tres` (physical DAMAGE) as the base attack. This was the root cause for Sprite and
Dusk Moth — both had high `base_magic_attack` but only DEBUFF abilities.

### ⚠ SPIKE — kills a class in <3 hits

**Cause:** too much damage or class HP too low.

**Fix:** Reduce `base_physical_attack` or `base_magic_attack` by 3–5 points until ratio >= 3.0.

### ⚠ SLOW — Squire needs >10 hits to kill

**Cause:** enemy HP too high relative to Squire's attack at this progression.

**Formula:** `ttk = ceil(enemy_hp / max(1, squire_phys_atk - enemy_phys_def))`

**Fix:** Reduce `base_max_health` until TTK <= 10.

### ⚠ EASY — Squire one-shots (TTK = 1)

**Cause:** enemy HP too low. Squire one-shot means the enemy may not even act before dying.

**Fix:** Raise `base_max_health` until TTK >= 2. Target TTK = 2–3 for small/fragile units.
```
min_hp = squire_phys_atk - enemy_phys_def + 1     # at minimum; prefer TTK=2 → min_hp = (sq_dmg * 2) - 1
```

---

## Design-Intent Flags (Acceptable ⚠s)

Some flags are expected and should **not** be fixed:

### ⚠T1MAGE in `smoke` (Prog 2)
Acolyte (M.Def=29) is immune to Imp and Fire Spirit magic. Pure-magic
battle is exactly where Acolyte shines. Raising magic damage to threaten Acolyte
would create spike risk for base Squire (M.Def=15).

### ⚠T1TANK in `forest` / `village_raid` (Prog 1)
Warden (P.Def=27) is immune to Bear/Wild Boar/Wolf physical attacks.
Tier 1 requires ~50 JP. Players extremely unlikely to have promoted by Prog 1.

### ⚠ZERO for `Goblin Shaman` in `village_raid`
Pure healer/support design. Intentional — this enemy exists to heal allies, not attack.

### ⚠SLOW for `Street Tough` in `city_street` (TTK=11)
Known borderline case. A single-point fix: reduce HP to 48 → TTK=10.
Not treated as urgent since it's the tutorial battle and Prog 0 is intentionally forgiving.

### ⚠ZERO for `Goblin Archer` in `village_raid`
Known bug. arrow_shot mod=2 + low phys_atk barely misses Mage P.Def=16. Fix: raise
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
- `⚠ZERO` = deals 0 to every base class (needs fixing unless intentional support unit)
- `⚠SPIKE` = kills a class in <3 hits (review)
- `⚠SLOW` = Squire needs >10 hits to kill (HP may be too high)
- `⚠EASY` = Squire one-shots the enemy (HP too low, enemy may never act)
- `✓` = all clear — damage present, no spikes, TTK 2–10
- T1 section (Prog 1+): damage vs each of 6 T1 representatives
- T1 per-enemy `⚠` = that enemy can't threaten a specific T1 class
- `⚠T1TANK` = no enemy in battle threatens Warden
- `⚠T1MAGE` = no enemy in battle threatens Acolyte
- `✓T1` = all T1 classes threatened by at least one enemy
- T2 section (Prog 3+): damage vs each of 8 T2 representatives
- `⚠T2TANK` / `⚠T2MAGE` = battle-level T2 extreme flags
- `✓T2` = all T2 classes threatened by at least one enemy

**Battles tracked:** city_street (P0), forest (P1), village_raid (P1), smoke (P2),
deep_forest (P2), clearing (P2), ruins (P2), cave (P3), portal (P3), inn_ambush (P3),
shore (P4), beach (P4), cemetery_battle (P4), box_battle (P4), army_battle (P4), lab_battle (P4),
mirror_battle (P5), gate_ambush (P5), city_gate_ambush (P6), return_city_1-4 (P6)

## Item Stat Reference (Crit/Dodge on 0-100 scale)

Standard tiered items (shop-purchasable):

| Group | T0 (+bonus, price) | T1 (+bonus, price) | T2 (+bonus, price) |
|-------|-------------------|-------------------|-------------------|
| HP | +5, 50 | +10, 120 | +15, 250 |
| Mana | +3, 50 | +5, 120 | +8, 250 |
| P.Atk | +3, 60 | +5, 140 | +8, 280 |
| P.Def | +3, 60 | +5, 140 | +8, 280 |
| M.Atk | +3, 60 | +5, 140 | +8, 280 |
| M.Def | +3, 60 | +5, 140 | +8, 280 |
| Speed | +2, 50 | +3, 120 | +5, 260 |
| Crit% | — | +5, 80 | +10, 200 |
| Dodge% | — | +5, 80 | +10, 200 |
| Move | — | +1, 150 | +2, 300 |
| Jump | — | +1, 150 | +2, 300 |

Crit and Dodge are on a **0-100 percentage scale** (e.g., Squire base crit=15 means 15% crit chance).
