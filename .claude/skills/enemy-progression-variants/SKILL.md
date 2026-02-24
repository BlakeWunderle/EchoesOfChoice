---
name: enemy-progression-variants
description: Create progression-specific enemy variants in EchoesOfChoiceTactical. Use when an enemy needs to appear in fights more than ~2 progressions apart, when balance_check.gd flags a ZERO/SPIKE/SLOW on an enemy that also appears early-game, or when an enemy's stats can't satisfy two distant battles at once.
---

# Enemy Progression Variants

An enemy `.tres` file has a single set of base stats. When the **same enemy** appears in battles
that are **more than ~2 progressions apart**, it cannot be balanced for both:

- Stats low enough for the early fight → ⚠ZERO or ⚠EASY in the late fight
- Stats high enough for the late fight → ⚠SPIKE or enemy feels unfair early

**The fix:** create a **new `.tres`** that shares the theme and abilities of the original but has
stats tuned to the target progression. The original stays untouched for its early appearances.

---

## When to Split

| Situation | Action |
|-----------|--------|
| Same enemy in fights ≤ 2 progs apart | One `.tres` is fine — adjust stats to midpoint or earliest fight |
| Same enemy in fights 3+ progs apart | **Split into two `.tres` files** |
| balance_check.gd flags ZERO/SPIKE on an early enemy that also appears late-game | Split rather than raising/lowering the shared stats |
| You're about to reuse a Prog 0–1 tutorial enemy in a Prog 4–6 fight | Always split |

---

## Naming Convention

```
<original_name>.tres          # original, stays at its first-appearance progression
<adjective>_<original>.tres   # variant, for the later progression
```

**Real examples:**

| Original | Prog | Variant | Variant Prog | Adjective rationale |
|----------|------|---------|--------------|---------------------|
| `hex_peddler.tres` | 0 | `cursed_peddler.tres` | 5 | "cursed" = darker, more dangerous |
| `goblin.tres` | 1 | `goblin_veteran.tres` | 4 | "veteran" = experienced survivor |
| `wolf.tres` | 1 | `dire_wolf.tres` | 3 | "dire" = larger, more fearsome |

Adjective options (pick what fits the thematic escalation):

- **Darker/corrupted:** cursed, shadow, void, blighted, corrupted, withered
- **Stronger/evolved:** veteran, elder, ancient, greater, superior, alpha
- **Named/unique:** add a proper name suffix (e.g. `peddler_nale.tres`)

---

## How to Create the Variant

### 1. Copy the original `.tres` and rename it

```
cp EchoesOfChoiceTactical/resources/enemies/hex_peddler.tres \
   EchoesOfChoiceTactical/resources/enemies/cursed_peddler.tres
```

### 2. Change `class_id` and `class_display_name`

```gdscript
# original
class_id = "hex_peddler"
class_display_name = "Hex Peddler"

# variant
class_id = "cursed_peddler"
class_display_name = "Cursed Peddler"
```

`class_id` must be unique — it's used by `battle_config.gd` and any recruitment logic.

### 3. Scale stats to the target progression

Use the **balance-thresholds** skill to look up the target progression's defense profiles and
damage targets. Key stats to scale up:

| Stat | How to scale |
|------|-------------|
| `base_magic_attack` / `base_physical_attack` | Raise until damage vs weakest class hits the target range (2–5 at Prog 1, 5–9 at Prog 5) |
| `base_max_health` | Raise to keep TTK in the 2–10 range vs Squire at the new progression |
| `base_speed` | Optionally raise by 1–2 to feel more threatening |
| `base_physical_defense` / `base_magic_defense` | Optionally raise slightly for tankier feel |

**Quick formula (from balance-thresholds skill):**

```
# Magic attack to deal N damage to Squire (lowest M.Def) with ability modifier M:
mag_atk = squire_mag_def - M + N

# Example: Prog 5 (Squire M.Def=21), hex_bolt modifier=3, want 6 damage:
mag_atk = 21 - 3 + 6 = 24
```

### 4. Keep the same abilities (or escalate them)

The variant usually keeps the same abilities — they define the unit's identity and theme.
If you want the variant to feel more dangerous, you can:
- Swap one ability for a stronger version (e.g. `hex_bolt.tres` → `dark_hex.tres`)
- Add one extra ability (bring 2 abilities up to 3)

Do **not** give the variant completely different abilities — it should still feel like a
recognizable evolution of the original.

### 5. Update `battle_config.gd`

Replace the original enemy reference in the late-game battle with the new variant:

```gdscript
# Before (in gate_ambush — Prog 5):
var peddler := load("res://resources/enemies/hex_peddler.tres")

# After:
var peddler := load("res://resources/enemies/cursed_peddler.tres")
```

### 6. Update `balance_check.gd` BATTLES dict

The BATTLES dictionary in `tools/balance_check.gd` mirrors `battle_config.gd`. Update the
matching battle entry:

```gdscript
# Before:
{"res": "res://resources/enemies/hex_peddler.tres", "name": "Hex Peddler", "count": 1, "level": 5},

# After:
{"res": "res://resources/enemies/cursed_peddler.tres", "name": "Cursed Peddler", "count": 1, "level": 5},
```

### 7. Run balance_check.gd and verify both battles

```
Godot_v4.6.1-stable_win64_console.exe --path EchoesOfChoiceTactical --headless --script res://tools/balance_check.gd
```

Both the **original battle** (early prog) and the **new battle** (late prog) should pass with
no ⚠ZERO / ⚠SPIKE / ⚠SLOW flags.

---

## What NOT to Do

- **Don't raise the original's stats** to fix the late-game fight — this breaks the early fight.
- **Don't lower the original's stats** to fix early-game — this makes the late fight feel empty.
- **Don't reuse tutorial enemies** (Prog 0–1 guards, goblins, wolves) in Prog 4–6 rosters.
  Those units exist to be easy. Replace them with shadow/dark/elite variants or entirely
  different themed enemies.
- **Don't create variants for fights only 1–2 progs apart** — a small stat tweak on the
  original is cleaner than a new file.

---

## Real Example: hex_peddler → cursed_peddler

**Problem:** `hex_peddler.tres` (Prog 0, city_street) also appeared in `gate_ambush` (Prog 5).
- At Prog 0: mag_atk=16 is appropriate (6 magic damage to Squire). ✓
- At Prog 5: mag_atk=16 → ⚠ZERO (Squire M.Def=21 > 16+3=19 → 0 damage).
- Raising to mag_atk=22 fixed Prog 5 but caused ⚠SPIKE at Prog 0 (12 damage, Squire HP≈33 → 2.75 hits → spike).

**Fix:**
1. Reverted `hex_peddler.tres` to `base_magic_attack = 16` (Prog 0 correct).
2. Created `cursed_peddler.tres` with `base_magic_attack = 24`, `base_max_health = 44`.
   - hex_bolt: 24+3=27 vs Squire M.Def=21 = 6 damage ✓ at Prog 5
   - TTK: Squire dmg=26-8=18, ceil(44/18)=3 ✓
3. Updated gate_ambush in `battle_config.gd` and `balance_check.gd`.
4. Both battles verified clean.

---

## Related Skills

| Skill | When to use |
|-------|-------------|
| **balance-thresholds** | Look up defense profiles and damage targets per progression |
| **setting-enemy-abilities** | Choose abilities and verify at least one is `ability_type=0` DAMAGE |
| **making-battle-configs** | Add the variant to a battle composition |
| **tactical-balance-feedback-loop** | Full balance pass after adding variants |
