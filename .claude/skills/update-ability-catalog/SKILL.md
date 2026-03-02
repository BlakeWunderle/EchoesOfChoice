---
name: update-ability-catalog
description: Sync the ability catalog memory file with the GDScript ability database files. Use after adding, changing, or removing abilities in the GDScript codebase, or after class roster changes.
---

# Update Ability Catalog

Keep `C:\Users\blake\.claude\projects\c--Projects-EchoesOfChoice\memory\abilities.md` in sync with the GDScript ability databases in `EchoesOfChoice/scripts/data/`.

## When to Run

- After adding new ability functions to the ability DB files
- After changing ability properties (modifier, mana_cost, etc.)
- After adding/removing abilities from a class's ability list
- After adding new classes or enemies
- Periodically to verify catalog accuracy

## Procedure

### Step 1: Scan class ability assignments

For each class tier, find which abilities each class uses:

```bash
# Base classes (T0)
grep -n "abilities\s*=" EchoesOfChoice/scripts/data/fighter_db.gd

# Tier 1 classes
grep -n "abilities\s*=" EchoesOfChoice/scripts/data/fighter_db_t1.gd

# Tier 2 classes
grep -n "abilities\s*=" EchoesOfChoice/scripts/data/fighter_db_t2.gd
grep -n "abilities\s*=" EchoesOfChoice/scripts/data/fighter_db_t2b.gd

# Enemies
grep -n "abilities\s*=" EchoesOfChoice/scripts/data/enemy_db.gd
```

### Step 2: Read ability definitions

For each ability function, extract: ability_name, modified_stat, modifier, impacted_turns, use_on_enemy, mana_cost, target_all, damage_per_turn, life_steal_percent, flavor_text.

Ability functions are in:
- `EchoesOfChoice/scripts/data/ability_db.gd` -- base/shared player abilities (T0 classes + shared)
- `EchoesOfChoice/scripts/data/ability_db_player.gd` -- T1 and T2 player abilities
- `EchoesOfChoice/scripts/data/enemy_ability_db.gd` -- enemy-specific abilities

Each ability is a static function returning an AbilityData via the `_make()` helper:
```gdscript
static func slash() -> AbilityData:
    return _make("Slash", "Swing your weapon...",
        Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 2)
```

The `_make()` params are: `(name, flavor, stat, mod, turns, on_enemy, cost, all=false, dot=0, steal=0.0)`

### Step 3: Classify each ability

Apply these rules in order (first match wins):
- **LSTEAL**: life_steal_percent > 0
- **DOT**: damage_per_turn > 0
- **TAUNT**: modified_stat = TAUNT
- **HEAL**: modified_stat = HEALTH AND use_on_enemy = false
- **BUFF**: use_on_enemy = false AND impacted_turns > 0
- **DEBUFF**: use_on_enemy = true AND impacted_turns > 0
- **DMG**: everything else (use_on_enemy = true, instant)

### Step 4: Compare against catalog

Read `abilities.md` and diff against scanned data:
- **New**: ability function exists but no row in catalog
- **Removed**: row in catalog but function deleted or class no longer uses it
- **Changed**: property values differ between GDScript and catalog
- **New class**: class factory with abilities not in catalog
- **Removed class**: class in catalog but factory removed

### Step 5: Update catalog

- Add/remove/update rows to match source
- Update the "Last updated" date at the top
- Preserve the Thematic Misfits section (update if affected abilities changed)

### Step 6: Report

```
ABILITY CATALOG SYNC
  Player classes scanned: N
  Player abilities: N
  Enemy classes scanned: N
  Enemy abilities: N

  Added: [list]
  Removed: [list]
  Modified: [list with old->new]

  RESULT: UP TO DATE / UPDATED (N changes)
```

## Table Format

```markdown
| Ability | Type | Stat | Mod | Dur | Tgt | Mana | DPT | LS% | Notes |
```

- Type: DMG, HEAL, BUFF, DEBUFF, DOT, LSTEAL, TAUNT
- Stat: PA, PD, MA, MD, ATK, DEF, SPD, HP, MIX, TAUNT, DODGE
- Dur: 0=instant, N=N turns
- Tgt: E=enemy, A=ally, AoE=all
- DPT/LS%: only fill if nonzero

## Key Files

- Base/shared abilities: `EchoesOfChoice/scripts/data/ability_db.gd`
- T1/T2 player abilities: `EchoesOfChoice/scripts/data/ability_db_player.gd`
- Enemy abilities: `EchoesOfChoice/scripts/data/enemy_ability_db.gd`
- Ability data model: `EchoesOfChoice/scripts/data/ability_data.gd`
- Stat enums: `EchoesOfChoice/scripts/data/enums.gd`
- Base player classes: `EchoesOfChoice/scripts/data/fighter_db.gd`
- T1 player classes: `EchoesOfChoice/scripts/data/fighter_db_t1.gd`
- T2 player classes: `EchoesOfChoice/scripts/data/fighter_db_t2.gd`, `fighter_db_t2b.gd`
- Enemy factories: `EchoesOfChoice/scripts/data/enemy_db.gd`
- Catalog: `C:\Users\blake\.claude\projects\c--Projects-EchoesOfChoice\memory\abilities.md`

## Related

- `.claude/rules/class-trees.md` -- class upgrade tree structure
- `.claude/rules/game-design.md` -- combat formulas and design reference
