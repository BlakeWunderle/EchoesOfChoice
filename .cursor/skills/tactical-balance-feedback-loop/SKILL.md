---
name: tactical-balance-feedback-loop
description: Full balance feedback loop for the Godot tactical game (EchoesOfChoiceTactical). Iterates enemy tuning, player power curve validation, and per-class win rate banding until all stages pass. Use for complete balance passes on the 5-member tactical party system. Excludes Elemental battles (Progression 7).
---

# Tactical Balance Feedback Loop

All paths are relative to the workspace root. The Godot project lives at `EchoesOfChoiceTactical/`.

Iterative balancing process for the tactical game's Progressions 0-6. The tactical game uses a **5-member party** on a grid-based battlefield, which fundamentally changes balance dynamics from the C# 3-member text-based game.

> **STATUS: Simulator Not Yet Built.** Until the tactical battle simulator is implemented, Steps 1-3 must be done through manual playtesting or by adapting the loop to use observational data. The process below describes the full automated workflow for when the simulator exists.

## The Loop

**Work one progression at a time, lowest to highest.** Each progression completes all three phases before moving on.

```
FOR each progression 0 -> 6, in order:
  +-------------------------------------------------+
  |  STEP 1: Enemy Tuning                           |
  |  Stage hits gradient win rate?                   |
  |  NO -> adjust enemy .tres stats -> re-test      |
  |  YES v                                          |
  +-------------------------------------------------+
  |  STEP 2: Power Curve Check                      |
  |  Archetype ranking correct for this stage?       |
  |  NO -> adjust player growth -> restart this prog |
  |  YES v                                          |
  +-------------------------------------------------+
  |  STEP 3: Class Win Rate Band                    |
  |  Every class between 57% and 93%?               |
  |  NO -> buff/nerf outliers -> restart this prog   |
  |  YES -> LOCK this progression, move to next      |
  +-------------------------------------------------+
```

### Tactical-Specific Considerations

The 5-member party changes balance dynamics compared to 3-member:
- **More composition variance**: 56 base compositions vs 20 in the C# game
- **Positional strategy matters**: Grid placement, movement, and facing affect outcomes beyond raw stats
- **Mixed encounter types**: Some fights are 5v5 (mob fights), others are 5v4 (mini-boss). The mob-vs-boss ratio affects how archetype strengths play out
- **XP catch-up**: Units that fall behind in XP gain more, keeping the party level-compressed

### Cascade Scope

| Change Type | Affects | Restart From |
|-------------|---------|-------------|
| Enemy .tres base stats | The battle using that enemy | Re-test that battle |
| Enemy ability .tres modifier | All battles using enemies with that ability | Earliest battle using it |
| Player class .tres base stats | ALL stages | Prog 0 |
| Player class .tres growth rates | Stages where growth has compounded | Prog where growth matters |
| Ability .tres changes | All stages using that ability | Earliest stage with a class/enemy that has it |

## Step 1: Enemy Tuning

**Goal:** This stage's overall win rate falls within its target +/- 3%.

### Tactical Difficulty Gradient

| Stage | Target | Range | Battles | Format |
|-------|--------|-------|---------|--------|
| 0 | 90% | 87-93% | City Street | 5v5 mob |
| 1 | 86% | 83-89% | Forest | 5v5 mob |
| 2 | 81% | 78-84% | Smoke, Deep Forest, Clearing, Ruins | 5v5 mixed |
| 3 | 77% | 74-80% | Cave, Portal | 5v4 mini-boss |
| 4 | 73% | 70-76% | Box, Cemetery, Lab, Army | TBD |
| 5 | 69% | 66-72% | Mirror | TBD |
| 6 | 64% | 61-67% | Return to City 1-4 | TBD |

### Tuning Levers (enemy .tres files)

All enemy stats live in `EchoesOfChoiceTactical/resources/enemies/<enemy>.tres`. Key stats to adjust:

- `base_max_health` -- survivability
- `base_physical_attack` / `base_magic_attack` -- damage output
- `base_physical_defense` / `base_magic_defense` -- damage reduction
- `base_speed` -- turn frequency
- `movement` -- grid reach (affects positioning pressure)

Ability tuning lives in `EchoesOfChoiceTactical/resources/abilities/<ability>.tres`:
- `modifier` -- damage/heal/buff power
- `mana_cost` -- usage frequency
- `ability_range` -- threat zone
- `aoe_shape` / `aoe_size` -- multi-target potential

### Mob vs Boss Tuning

| Encounter Type | Tuning Approach |
|---------------|-----------------|
| **Mob fight** (5v5) | Adjust count and stat spread. Weaker enemies with one strong leader. |
| **Mini-boss** (5v4) | Bosses have high stats; adds are fragile. Reduce boss stats to lower difficulty. |
| **Boss fight** (5v3-4) | Single dominant threat + weak adds. Very stat-sensitive. |

## Step 2: Power Curve Check

**Goal:** Archetype win rate ranking roughly follows the expected power curve.

### Expected Tactical Power Curve

| Archetype | Peak Window | Behavior |
|-----------|-------------|----------|
| **Fighter (Squire)** | Prog 0-1 | Highest early. Strong base stats, physical damage dominates mob fights. |
| **Mage** | Prog 2-4 | AoE abilities shine against multi-enemy encounters. Ramps with Tier 1. |
| **Scholar** | Prog 5-6 | Weakest early but highest growth. Utility abilities pay off in complex fights. |
| **Entertainer** | Throughout | Consistently viable. Debuffs scale well against bosses. Never flagged WEAK. |

### Tactical Nuances

Grid-based combat creates matchup dynamics the C# game doesn't have:
- **Fighters** benefit from tight formations (flanking bonuses, reaction attacks)
- **Mages** benefit from open maps with range advantages
- **Entertainers** benefit from boss fights where debuffs have high per-target value
- **Scholars** benefit from mixed encounters where utility has varied targets

## Step 3: Class Win Rate Band

**Goal:** Every class's win rate at this stage falls between **57% and 93%**.

Same band reasoning as the C# game -- no class should feel unwinnable or trivially easy.

### Fixing Outliers in the Tactical Game

**Class below 57%:**
1. Check the class's `.tres` file for base stats relative to its archetype guidelines (see character-stat-tuning skill)
2. Check its abilities -- does it have at least one damage ability?
3. Check if its abilities have viable range/AoE for the map sizes used
4. For melee-only classes on large maps, movement stat may be the issue

**Class above 93%:**
1. Check for self-heal + damage combo (overperforms in tactical where survivability compounds)
2. Check if AoE abilities are hitting too many enemies on typical grid layouts
3. Reduce growth rates or ability modifiers

## Iteration Checklist

```
PROGRESSION 0 (City Street, target 87-93%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Fighter leads
- [ ] Step 3: All classes 57-93%
- [ ] LOCKED

PROGRESSION 1 (Forest, target 83-89%):
- [ ] Step 1: Enemy tuning PASS
- [ ] Step 2: Fighter leads
- [ ] Step 3: All classes 57-93%
- [ ] LOCKED

PROGRESSION 2 (Smoke/DeepForest/Clearing/Ruins, target 78-84%):
- [ ] Step 1: All 4 battles PASS
- [ ] Step 2: Mage leads (or close)
- [ ] Step 3: All classes 57-93%
- [ ] LOCKED

PROGRESSION 3 (Cave/Portal, target 74-80%):
- [ ] Step 1: Both battles PASS
- [ ] Step 2: Mage leads (or close)
- [ ] Step 3: All classes 57-93%
- [ ] LOCKED

PROGRESSION 4-6: (TBD -- enemy .tres files not yet created for these stages)
```

## Key Files

| File | Purpose |
|------|---------|
| `EchoesOfChoiceTactical/resources/enemies/*.tres` | Primary tuning lever -- enemy stats |
| `EchoesOfChoiceTactical/resources/abilities/*.tres` | Ability power, range, AoE |
| `EchoesOfChoiceTactical/scripts/data/battle_config.gd` | Enemy composition per battle |
| `EchoesOfChoiceTactical/resources/classes/*.tres` | Player class base stats and growth |
| `EchoesOfChoiceTactical/scripts/data/map_data.gd` | Progression stages and node connections |
| `EchoesOfChoiceTactical/scripts/data/xp_config.gd` | XP scaling (affects expected levels) |

## Related Skills

| Skill | When to Use |
|-------|-------------|
| **tactical-battle-simulator** | Running simulations and interpreting output |
| **tactical-elemental-balance** | Dedicated tuning pass for Prog 7 |
| **tactical-party-comp-balance** | Composition-level balance analysis |
| **character-stat-tuning** | Detailed stat/ability adjustment guidance |
