---
name: jp-balance
description: Check if JP economy is balanced per class and progression. Use when tuning speed, mana, identity rules, or JP thresholds. Runs a speed-weighted simulation via jp_check.gd.
---

# JP Balance Checker

All paths relative to workspace root. Godot project at `EchoesOfChoiceTactical/`.

## What It Does

`tools/jp_check.gd` runs a **speed-weighted JP accumulation simulation** for all four base classes (Squire, Mage, Entertainer, Scholar). It models ability usage per battle — utility abilities first (capped), damage abilities until OOM, basic attacks for the remainder — and projects JP earned at each town milestone.

Speed weighting: faster classes get proportionally more ability uses per battle. The slowest class at each level gets the base 6 uses; faster classes scale up (e.g. Entertainer at speed 15 vs min 11 = 8 uses).

---

## How to Run

```
"C:/Users/blake/AppData/Local/Microsoft/WinGet/Packages/GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe/Godot_v4.6.1-stable_win64_console.exe" --path EchoesOfChoiceTactical --headless --script res://tools/jp_check.gd
```

Shorthand below: `<godot>`.

**Filter options** (after `--`):

| Command | Effect |
|---------|--------|
| *(no args)* | All four base classes |
| `-- squire` | Squire only |
| `-- mage` | Mage only |
| `-- entertainer` | Entertainer only |
| `-- scholar` | Scholar only |

---

## Output Sections

### 1. Ability Identity Breakdown

Lists each class's abilities with JP per use (identity=5, not identity=1), mana costs, speed, and mana pool. Use this to understand **why** a class earns what it does.

### 2. JP per Battle

Table showing speed-adjusted uses, JP per battle, identity/plain split, and mana usage at level 1. The key summary view.

### 3. JP at Town Milestones

JP accumulated at Forest Village (2 battles), Crossroads Inn (4 battles), Gate Town (7 battles). Shows T1/T2 pass/fail. **This is the primary pass/fail check.**

### 4. Sensitivity Analysis

"What if" table: fixed uses (4-8) across all classes at Crossroads and Gate Town. Useful for deciding if BASE_USES should change.

### 5. Threshold Analysis

Identifies the slowest/fastest class at each milestone and calculates what threshold would let all classes pass.

---

## Pass Criteria

| Milestone | Requirement | Notes |
|-----------|-------------|-------|
| Forest Village (2 battles) | All classes ≥ T1 (50 JP) | Entertainer at 48 is accepted (−2); optional village_raid covers it |
| Crossroads Inn (4 battles) | All classes ≥ T1 (50 JP) | Must pass — this is where most T1 promotions happen |
| Gate Town (7 battles) | All classes ≥ T1 AND T2 (100 JP) | Must pass — T2 promotions gate on this |

**Acceptable gaps:**
- Entertainer 2 short at Forest Village = OK (optional battle covers it)
- Any class 1-3 short at Forest Village = OK (edge case, optional battles exist)
- Any class short at Crossroads = NOT OK (fix needed)

---

## Flag Reference

| Symbol | Meaning |
|--------|---------|
| `✓` | Class meets threshold at this milestone |
| `✗` | Class falls short — see warning detail |
| `⚠` | Warning line with exact shortfall amount |

---

## Fix Recipes

| Problem | Fix | Files |
|---------|-----|-------|
| Class short at FV by 1-3 | Accept — optional battle covers it | — |
| Class short at FV by 4+ | Raise class speed (+1-2) or add a damage ability | `resources/classes/<class>.tres` |
| Class short at Crossroads | Raise speed, add abilities, or lower T1 threshold | `resources/classes/<class>.tres` or `scripts/data/xp_config.gd` |
| Class short at Gate Town T2 | Raise speed, increase mana growth, or lower T2 threshold | Same |
| All classes short at a milestone | Lower threshold in `xp_config.gd` (TIER_1_JP_THRESHOLD / TIER_2_JP_THRESHOLD) | `scripts/data/xp_config.gd` |
| One class way ahead of others | Reduce speed or change identity rules | `resources/classes/<class>.tres` or `scripts/data/xp_config.gd` |
| Speed feels wrong for archetype | Adjust base_speed and/or growth_speed in class .tres | `resources/classes/<class>.tres` |

### Speed Band Reference

When adjusting speed, use these role-based bands:

| Band | Base Speed | Growth | Roles |
|------|-----------|--------|-------|
| Heavy Tank | 11 | 2 | Bastion |
| Tank/Defender | 12 | 2 | Warden, Paladin, Acolyte, Siegemaster |
| Slow Caster | 11 | 2 | Mage, Scholar, Artificer, Tinker, Cosmologist, Arithmancer |
| Support | 12-13 | 3 | Mistweaver, Priest, Hydromancer, Geomancer |
| Medium | 13-14 | 3 | Squire, Firebrand, Stormcaller, Knight, most T2s |
| Mobile | 14-15 | 3-4 | Duelist, Ranger, Entertainer, Bard, Pyromancer |
| Fast | 15-16 | 4 | Martial Artist, Cavalry, Mercenary, Monk, Illusionist |
| Fastest | 17 | 4 | Ninja, Dervish |

**Constraints:** cap base_speed at 17, cap growth at 4.

---

## Worked Example

```bash
<godot> --path EchoesOfChoiceTactical --headless --script res://tools/jp_check.gd
```

**Key output:**
```
── JP per Battle (speed-weighted, base 6 uses @ spd 11) ──

  Class          │ Spd  Uses  JP   Identity  Basic  Mana
  ──────────────────────────────────────────────────────────────
  Squire         │ 13   7     35   7×5      0×1    8/9
  Mage           │ 11   6     30   6×5      0×1    12/19
  Entertainer    │ 15   8     24   4×5      4×1    6/14
  Scholar        │ 11   6     26   5×5      1×1    13/14

── JP at Town Milestones (speed-weighted) ──

                 │ Forest Village (2b) │ Crossroads Inn (4b) │ Gate Town (7b)
  Class          │ JP    T1?           │ JP    T1?           │ JP    T1? T2?
  ──────────────────────────────────────────────────────────────────────────────
  Squire         │ 70    ✓              │ 145   ✓              │ 265   ✓   ✓
  Mage           │ 60    ✓              │ 120   ✓              │ 210   ✓   ✓
  Entertainer    │ 48    ✗              │ 96    ✓              │ 169   ✓   ✓
  Scholar        │ 52    ✓              │ 112   ✓              │ 202   ✓   ✓
```

**Analysis:**
- Squire leads at 35 JP/battle (100% identity rate — all actions match PHYS_ATK). Expected for a physical fighter archetype.
- Mage earns 30 JP/battle (enough mana for all 6 uses as Arcane Bolt = identity). Passes all milestones.
- Entertainer: 4 identity uses (Sing×2, Demoralize×2) + 4 basic attacks. 48 at FV is 2 short — accepted, optional battle covers it. Passes Crossroads and Gate Town.
- Scholar: 5 identity uses (Proof×2, Energy Blast×3 with 14 mana) + 1 basic. Passes all milestones.
- **All classes reach T2 by Gate Town. PASS.**

---

## Integration with Other Balance Tools

| When | Also Run |
|------|----------|
| Changed class speed or mana | Re-run `jp_check.gd` to verify JP projections |
| Changed enemy stats | Run `balance_check.gd` (speed doesn't affect enemy balance directly, but ATB pacing changes feel) |
| Changed equipment items | Run `item_check.gd` (speed items now have different baselines) |
| Changed JP constants or identity rules | Re-run `jp_check.gd` — update constants in jp_check.gd to match xp_config.gd |
| Full balance pass per progression | Use `progression-balance-check` skill, then run `jp_check.gd` as a final cross-check |

---

## Key Files

| File | Purpose |
|------|---------|
| `EchoesOfChoiceTactical/tools/jp_check.gd` | JP accumulation simulation tool |
| `EchoesOfChoiceTactical/scripts/data/xp_config.gd` | JP constants (BASE_JP, IDENTITY_JP, thresholds, CLASS_IDENTITY) |
| `EchoesOfChoiceTactical/resources/classes/*.tres` | Class speed/mana values (tuning lever) |
| `EchoesOfChoiceTactical/scripts/data/map_data.gd` | Battle path structure (how many battles to each town) |

## Related Skills

| Skill | When |
|-------|------|
| `progression-balance-check` | Full balance pass including enemy damage + item balance |
| `character-stat-tuning` | When adjusting any class stat (not just speed) |
| `class-reference` | Quick lookup of class trees, tiers, and abilities |
| `item-balance` | When speed items change the turn-count dynamics |
