---
name: progression-balance-check
description: Combined balance check for a single progression stage. Runs enemy damage analysis (balance_check.gd), then equipment mirror fights (item_check.gd), then cross-checks. Use when balancing a progression stage end-to-end, after tuning enemies or items, or when you want to verify a progression is clean.
---

# Progression Balance Check

All paths relative to workspace root. Godot project at `EchoesOfChoiceTactical/`.

Run this skill **once per progression stage**, lowest to highest. Each progression must pass all three steps before moving on.

---

## Balance Philosophy

Balance is measured through **damage numbers and TTK**, not win rates.

The core relationship: **attack growth outpaces defense growth**, so damage-per-hit increases each progression. HP growth compensates — keeping TTK in the 2-10 range even as raw damage climbs.

| Concept | How It Works |
|---------|-------------|
| Damage scaling | Enemy attack stats should exceed the weakest party defense at each prog, producing positive damage. Higher prog = higher damage numbers. |
| HP as the buffer | HP growth absorbs increasing damage. An enemy dealing 12p at Prog 3 isn't a problem if the target has 80+ HP (TTK=7). |
| TTK is the metric | Squire hits-to-kill stays in 2-10 regardless of prog. If damage and HP both scale but TTK drifts outside this range, one side grew too fast. |
| Threat coverage | Every base class should take damage from at least one enemy. T1/T2 extreme defenders (Warden, Bastion, Acolyte, Priest) may be immune to some enemies — that's by design, but the battle roster should still threaten them via mixed damage types. |
| Items amplify, not dominate | Equipment should improve TTK by 1-3 hits, not halve it. Mirror-fight deltas (ΔKill, ΔSurv) catch items that break this. |

---

## Godot Executable

```
"/c/Users/blake/AppData/Local/Microsoft/WinGet/Packages/GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe/Godot_v4.6.1-stable_win64_console.exe"
```

Shorthand below: `<godot>`.

---

## Battle Roster by Progression

| Prog | Battles |
|------|---------|
| 0 | `city_street` |
| 1 | `forest`, `village_raid` |
| 2 | `smoke`, `deep_forest`, `clearing`, `ruins` |
| 3 | `cave`, `portal`, `inn_ambush` |
| 4 | `shore`, `beach`, `cemetery_battle`, `box_battle`, `army_battle`, `lab_battle` |
| 5 | `mirror_battle`, `gate_ambush` |
| 6 | `city_gate_ambush`, `return_city_1`, `return_city_2`, `return_city_3`, `return_city_4` |

---

## Progression-to-Shop Mapping

| Prog | Shop Available | Equipment Tier | Item Slots | Classes to Test |
|------|---------------|----------------|------------|-----------------|
| 0 | None (pre-shop) | -- | 1 | squire, mage, scholar (story items only) |
| 1 | Forest Village | T0 | 1 | squire, mage, scholar at T0 |
| 2 | (same as Prog 1) | T0 | 1 | squire, mage, scholar at T0 |
| 3 | Crossroads Inn | T0 + T1 | 2 | squire, mage, scholar at T0+T1; ranger, firebrand, dervish at T1 |
| 4 | (same as Prog 3) | T0 + T1 | 2 | same as Prog 3 |
| 5 | Gate Town | T0 + T1 + T2 | 2-3 | all 10 classes at appropriate tiers |
| 6 | (same as Prog 5) | T0 + T1 + T2 | 3 | all 10 classes |

---

## STEP 1 -- Enemy Balance (balance_check.gd)

### Run

```bash
<godot> --path EchoesOfChoiceTactical --headless --script res://tools/balance_check.gd -- <battle_id>
```

Run once per battle at this progression. Read the full output.

### Pass Criteria

**Base classes (all progs):**
- No `⚠ZERO` -- unless the enemy is an intentional support unit (healer/buffer with no DAMAGE ability)
- No `⚠SPIKE` -- enemy kills a class in <3 hits
- No `⚠SLOW` -- Squire TTK > 10
- No `⚠EASY` -- Squire one-shots (TTK = 1)

**T1 defenders (Prog 1+):**
- All 6 T1 reps (Warden, Acolyte, Ranger, Firebrand, Dervish, Martial Artist) threatened by at least 1 enemy
- Per-enemy `--` on a single T1 class is OK if another enemy covers it
- `⚠T1ZERO — no enemy threatens: <list>` means those T1 classes are immune to all enemies in the battle -- check design-intent exceptions before fixing

**T2 defenders (Prog 3+):**
- All 8 T2 reps (Bastion, Paladin, Ninja, Cavalry, Pyromancer, Priest, Mercenary, Illusionist) threatened by at least 1 enemy
- Same logic: per-enemy `--` OK if another enemy covers it
- `⚠T2ZERO — no enemy threatens: <list>` — same as T1, check exceptions

### Fix Recipes

| Flag | Fix |
|------|-----|
| `⚠ZERO` (attack too low) | Raise `base_physical_attack` or `base_magic_attack` in enemy .tres. Target: `scholar_phys_def + 3` for phys, `squire_mag_def - ability_modifier + 3` for magic. |
| `⚠ZERO` (no DAMAGE ability) | Enemy only has DEBUFF/HEAL abilities. Add a DAMAGE ability (e.g. `spirit_touch.tres`, `slash.tres`). |
| `⚠SPIKE` | Reduce `base_physical_attack` or `base_magic_attack` by 3-5 until party_HP/damage >= 3.0. |
| `⚠SLOW` | Reduce `base_max_health` until TTK <= 10. |
| `⚠EASY` | Raise `base_max_health` until TTK >= 2. Min HP = `(squire_dmg * 2) - 1`. |
| `⚠T1ZERO`/`⚠T2ZERO` for phys tanks (Ward, Bast) | Add or strengthen a magic enemy. Warden/Bastion have extreme P.Def -- only magic threats penetrate. |
| `⚠T1ZERO`/`⚠T2ZERO` for mag tanks (Aco, Prie) | Add or strengthen a physical enemy. Acolyte/Priest have extreme M.Def -- only physical threats penetrate. |

### Design-Intent Exceptions

These flags are expected and should NOT be fixed:

| Flag | Battle | Why OK |
|------|--------|--------|
| `⚠ZERO` | `Goblin Shaman` in `village_raid` (P1) | Pure healer/support design. Intentional. |
| `⚠T1ZERO` for Ward | `forest`, `village_raid` (P1) | Pure-physical battles; Warden PD=27 blocks all. Players extremely unlikely to have promoted by Prog 1. |
| `⚠T1ZERO` for Aco, Fire | `smoke` (P2) | Pure-magic battle. Acolyte (MD 29) and Firebrand (MD 24) block all magic. Raising magic to threaten them would spike base Squire. |
| `⚠T1ZERO` for Aco | `deep_forest` (P2) | Pure-magic battle. Acolyte (MD 29) blocks all. Witch threatens Firebrand (0/5), but not Acolyte. Same reasoning as smoke. |

---

## STEP 2 -- Item Balance (item_check.gd)

### Which classes and tiers to test

Use the Progression-to-Shop Mapping table above. Only test tiers the player has access to at this progression.

### Run

```bash
<godot> --path EchoesOfChoiceTactical --headless --script res://tools/item_check.gd -- <class> <tier>
```

Examples:
```bash
# Prog 0: story items only (T0 baseline)
<godot> --path ... --script res://tools/item_check.gd -- squire 0
<godot> --path ... --script res://tools/item_check.gd -- mage 0
<godot> --path ... --script res://tools/item_check.gd -- scholar 0

# Prog 3: T0+T1 for base classes, T1 for T1 classes
<godot> --path ... --script res://tools/item_check.gd -- squire 1
<godot> --path ... --script res://tools/item_check.gd -- ranger 1
<godot> --path ... --script res://tools/item_check.gd -- firebrand 1

# Prog 5+: all classes at all available tiers
<godot> --path ... --script res://tools/item_check.gd
```

### Pass Criteria

**Per-class per-tier:**
- No `⚠IMMUNE` -- defensive item makes unit immune to mirror opponent
- No `⚠SPIKE` -- offensive item kills 2.5x faster than baseline

**Combo section (T2):**
- No `⚠IMMUNE` -- full defense stacking breaks the game
- No `⚠SPIKE` with TTK < 5 -- 3-slot stacking too strong

**Story items:**
- No outliers: ΔKill and ΔSurv within +/-2 of tier-appropriate items
- Village Charm (+1/+1/+1/+1) should show modest deltas, no SPIKE

### Fix Recipes

| Problem | Fix |
|---------|-----|
| `⚠IMMUNE` on single-stat defense item | Reduce `stat_bonuses[1]` (P.Def) or `stat_bonuses[3]` (M.Def) by 1-2 |
| `⚠SPIKE` on single-stat offense item | Reduce `stat_bonuses[0]` (P.Atk) or `stat_bonuses[2]` (M.Atk) by 2-3 |
| Story item too strong | Lower dominant stat bonus; split into two smaller bonuses |
| `⚠IMMUNE` combo only | Reduce T2 defense stat bonuses slightly |
| `⚠SPIKE` combo only (TTK < 5) | Reduce individual item stats or increase prices |

---

## STEP 3 -- Cross-Check

After fixing enemies or items in Steps 1-2, verify the other side hasn't regressed.

1. If you changed any **enemy .tres** in Step 1:
   - Re-run `item_check.gd` for all classes at this prog's tier -- items haven't changed but the skill's enemy-awareness gives confidence nothing was broken indirectly.
   - Actually: item_check.gd is mirror-fight (class vs class), so enemy changes don't affect it. **Skip re-run.**

2. If you changed any **item .tres** in Step 2:
   - Re-run `balance_check.gd` for all battles at this prog.
   - Why: balance_check.gd bakes in equipment PD bonuses per prog. If you changed a PD item's value, the defense profiles in the tool's constants may need updating. Check whether the item you changed is in the "equipment bonus" assumption.
   - If the defense profiles need updating, edit the `PARTY` dict in `balance_check.gd`, then re-run.

3. If you changed **player class .tres** (growth rates, base stats):
   - **Full restart from Prog 0.** Player stat changes cascade to every progression.
   - Update both tools' constants: `PARTY` in balance_check.gd, `CLASS_PROFILES` in item_check.gd.
   - Re-run all battles, all items.

### Convergence

The cross-check passes when:
- All battles at this prog show no unexpected flags in balance_check.gd
- All classes at this prog's tier show no unexpected flags in item_check.gd
- No changes were made in the cross-check step (stable)

Mark this progression as **LOCKED** and move to the next.

---

## Iteration Checklist Template

Copy and fill per progression:

```
PROGRESSION <N> (battles: <list>):
  STEP 1 -- Enemy Balance:
  - [ ] Run balance_check.gd for each battle
  - [ ] Damage numbers positive vs weakest class, scaling from prior prog
  - [ ] TTK 2-10 for all enemies
  - [ ] All flags either clean or in design-intent exceptions
  - [ ] Fix applied + re-run clean
  STEP 2 -- Item Balance:
  - [ ] Determine which classes/tiers to test (use shop mapping)
  - [ ] Run item_check.gd for each class x tier
  - [ ] All flags clean (no IMMUNE, no SPIKE)
  - [ ] Fix applied + re-run clean
  STEP 3 -- Cross-Check:
  - [ ] If items changed: re-run balance_check.gd -- still clean
  - [ ] If enemies changed: no item re-run needed (mirror fight)
  - [ ] Stable (no new changes needed)
  LOCKED: [ ]
```

---

## Worked Example: Prog 0

### Step 1 -- Enemy Balance

```bash
<godot> --path EchoesOfChoiceTactical --headless --script res://tools/balance_check.gd -- city_street
```

**Actual output:**
```
═══ city_street            [Prog 0 | Party Lv1 | Sq.Atk 21] ═══
Enemy                    HP │ vs Squire     vs Mage       vs Scholar    vs Ent       │ TTK
──────────────────────────────────────────────────────────────────────────────────────────────
Thug (x2)                40 │ 6p/0m         10p/0m        9p/0m         9p/0m        │   4
Street Tough (x2)        48 │ 8p/0m         12p/0m        11p/0m        11p/0m       │   6
Hex Peddler              34 │ 0p/8m         0p/1m         0p/0m         0p/1m        │   3

  ✓ All clear — damage present, no spikes, TTK 2–10
```

**Analysis:**
- Thug: 6-10p damage, TTK=4 (standard)
- Street Tough: 8-12p damage, TTK=6 (standard). HP=48 gives TTK=6, well within range.
- Hex Peddler: 8m to Squire (magic threat), 0m to Scholar (Scholar MD=20 absorbs it). TTK=3 (fodder).
- No SPIKE, no EASY, no ZERO, no SLOW. Clean pass.
- No T1/T2 check at Prog 0 (T1 starts at Prog 1, T2 at Prog 3).
- **STEP 1: PASS**

### Step 2 -- Item Balance

Prog 0 has no shop. Test T0 base classes to check story items and preview shop items:

```bash
<godot> --path EchoesOfChoiceTactical --headless --script res://tools/item_check.gd -- squire 0
<godot> --path EchoesOfChoiceTactical --headless --script res://tools/item_check.gd -- mage 0
<godot> --path EchoesOfChoiceTactical --headless --script res://tools/item_check.gd -- scholar 0
```

**Key results (Squire Lv2, baseline Dmg=6, TTK=11, TTS=11):**
- Iron Band (+3 PA): ΔKill=+4 (TTK 11→7) -- strong but ratio 1.57x, below SPIKE threshold
- Guardian's Torc (+4 PD/+4 MD/+8 HP): ΔSurv=+25 -- big survival boost, no SPIKE (doesn't increase damage)
- Battlemage Stone (+4 PA/+4 MA): ΔKill=+4 (TTK 11→7) -- same ratio, no SPIKE
- Shadow Cloak (+15 Dodge/+5 Spd): no mirror effect (dodge is probabilistic, not modeled)

**Key results (Mage Lv2, baseline Dmg=5, TTK=11, TTS=11):**
- Focus Shard (+3 MA): ΔKill=+4 (TTK 11→7) -- good for magic builds
- Guardian's Torc: ΔSurv=+52 on Mage -- Mage has lowest PD (13), so +4 PD is proportionally huge. Not SPIKE since offense unchanged.
- Warding Amulet (+3 MD): ΔSurv=+17 -- meaningful for Mage mirror

**Key results (Scholar Lv2, 0-dmg baseline):**
- Battlemage Stone, Focus Shard: ✓BREAK (breaks 0-dmg mirror, expected)
- All defense items: ⚠WEAK (expected -- Scholar can't penetrate its own defenses)

**No IMMUNE, no SPIKE flags across any class. STEP 2: PASS**

### Step 3 -- Cross-Check

No changes made in Steps 1-2. Nothing to cross-check. **STEP 3: PASS**

### Result

```
PROGRESSION 0 (battles: city_street):
  STEP 1 -- Enemy Balance:
  - [x] Run balance_check.gd for city_street
  - [x] All flags clean (✓ All clear)
  - [x] No fixes needed
  STEP 2 -- Item Balance:
  - [x] Classes: squire, mage, scholar at T0
  - [x] Run item_check.gd for each class
  - [x] No IMMUNE or SPIKE flags
  - [x] No fixes needed
  STEP 3 -- Cross-Check:
  - [x] No changes made — stable
  LOCKED: [x]
```

**Prog 0: LOCKED.**

---

## Key Files

| File | Purpose |
|------|---------|
| `EchoesOfChoiceTactical/tools/balance_check.gd` | Enemy damage analysis tool |
| `EchoesOfChoiceTactical/tools/item_check.gd` | Equipment mirror-fight tool |
| `EchoesOfChoiceTactical/resources/enemies/*.tres` | Enemy stat files (tuning lever) |
| `EchoesOfChoiceTactical/resources/items/*.tres` | Equipment item files (tuning lever) |
| `EchoesOfChoiceTactical/resources/classes/*.tres` | Player class files (cascade lever) |

## Related Skills

| Skill | When |
|-------|------|
| `balance-thresholds` | Interpreting flag values, defense profiles, TTK targets |
| `item-balance` | Detailed item_check.gd output interpretation, best-fit class table |
| `character-stat-tuning` | When adjusting player class stats (triggers full restart) |
| `equipment-items` | When creating or modifying equipment .tres files |
| `enemy-progression-variants` | When an enemy needs different stats at different progs |
