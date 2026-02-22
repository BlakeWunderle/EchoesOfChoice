---
name: tactical-elemental-balance
description: Balance Elemental battles (Progression 7) in the Godot tactical game (EchoesOfChoiceTactical). Use when tuning elemental fights, adjusting elemental enemy stats, balancing recruit impact, or verifying the finale difficulty for the 5-member tactical party. Run only after Progressions 0-6 are balanced.
---

# Tactical Elemental Battle Balance

All paths are relative to the workspace root. The Godot project lives at `EchoesOfChoiceTactical/`.

Dedicated tuning pass for the tactical game's Progression 7 (Elemental Battles 1-4). These are the finale -- parties fight elemental bosses after recruiting a powerful NPC ally. The recruit shifts the power level significantly compared to Prog 0-6.

> **STATUS: Not Yet Implemented.** Progression 7 enemies, recruits, and battles have not been created as Godot resources yet. This skill documents the design targets and tuning process for when they are built.

**Prerequisite:** Progressions 0-6 must be balanced first (use the tactical-balance-feedback-loop skill). Player class stats and growth rates should be locked before starting here.

## Target Win Rates

| Battle | Enemies | Recruit Pair | Target | Range |
|--------|---------|-------------|--------|-------|
| Elemental 1 | Air + Water + Fire (3) | Seraph / Fiend | **57.5%** | **55-60%** |
| Elemental 2 | Water + Fire (2) | Druid / Necromancer | **60%** | **57-63%** |
| Elemental 3 | Air + Water (2) | Psion / Runewright | **60%** | **57-63%** |
| Elemental 4 | Air + Fire (2) | Shaman / Warlock | **60%** | **57-63%** |

Elemental 1 is intentionally harder -- 3 elementals instead of 2. The stat reductions compensate but the fight should still land below Elemental 2-4.

## Tactical-Specific Considerations

### 6-Member Party (5 + Recruit)

At Progression 7, the party grows to 6 members (5 player units + 1 recruit). This changes grid dynamics:
- More units competing for space on the grid
- Greater action economy advantage over bosses
- AoE abilities from elementals hit more targets
- Positioning becomes more critical -- 6 units are harder to spread

### Elemental Bosses on the Grid

Elemental enemies should be designed as large threats that control grid space:
- **High AoE** -- abilities that punish clumped parties (Diamond/Cross AoE shapes)
- **High HP pools** -- must survive multiple rounds against 6 attackers
- **Moderate speed** -- slow enough that the party gets positional setup, fast enough to be threatening
- **Board control** -- terrain abilities (fire tiles, ice walls) that force movement decisions

### Recruit Balance

Each recruit pair should include one offensive and one defensive/support option:

| Battle | Offensive Recruit | Defensive Recruit |
|--------|------------------|-------------------|
| 1 | Fiend (magic glass cannon) | Seraph (balanced tank/healer) |
| 2 | Necromancer (dark magic) | Druid (nature magic + healing) |
| 3 | Psion (psychic burst + debuffs) | Runewright (balanced all-rounder) |
| 4 | Warlock (dark magic offense) | Shaman (tanky support) |

**Balance target:** The gap between the two recruit variants within the same battle should be **< 5%**. If one recruit is strictly better, adjust its stats or the elemental enemy stats.

## Tuning Process

### Step 1: Create elemental enemy .tres files

Each elemental needs a `FighterData` resource in `resources/enemies/` with:
- Very high base stats (boss-tier, significantly above Prog 6 enemies)
- Powerful AoE abilities
- No growth rates (static stats)
- Per-battle stat adjustments applied in `battle_config.gd` methods

### Step 2: Create recruit .tres files

Recruits are special FighterData resources with:
- Static stats (no growth -- they join at fixed power)
- Unique powerful abilities
- Stats balanced to complement (not replace) the player party

### Step 3: Test each battle

Once the simulator exists:
1. Run each elemental battle at 50 sims
2. Check overall win rate against target
3. Check recruit A vs recruit B gap (< 5%)
4. Check cross-battle consistency (all 4 battles similarly balanced)

### Step 4: Tune and validate

Preferred tuning order:
1. **Per-battle stat adjustments** in `battle_config.gd` create methods (best -- battle-specific)
2. **Elemental base stats** in `.tres` files (caution -- affects all 4 battles)
3. **Recruit .tres stats** (secondary lever for recruit-specific balance)

## Checklist

```
ELEMENTAL BALANCE PASS (Tactical)

Prerequisites:
- [ ] Prog 0-6 balanced (all PASS via tactical-balance-feedback-loop)
- [ ] Player class stats locked
- [ ] Elemental enemy .tres files created
- [ ] Recruit .tres files created

Elemental 1 (target 55-60%):
- [ ] Win rate in range
- [ ] Seraph vs Fiend gap < 5%

Elemental 2 (target 57-63%):
- [ ] Win rate in range
- [ ] Druid vs Necromancer gap < 5%

Elemental 3 (target 57-63%):
- [ ] Win rate in range
- [ ] Psion vs Runewright gap < 5%

Elemental 4 (target 57-63%):
- [ ] Win rate in range
- [ ] Shaman vs Warlock gap < 5%

Cross-battle:
- [ ] All 4 battles within target range
- [ ] No path significantly harder than another
- [ ] No class flagged WEAK
```

## Key Files (To Be Created)

| File | Purpose |
|------|---------|
| `EchoesOfChoiceTactical/resources/enemies/air_elemental.tres` | Air elemental boss stats |
| `EchoesOfChoiceTactical/resources/enemies/water_elemental.tres` | Water elemental boss stats |
| `EchoesOfChoiceTactical/resources/enemies/fire_elemental.tres` | Fire elemental boss stats |
| `EchoesOfChoiceTactical/resources/enemies/seraph.tres` | Seraph recruit stats |
| `EchoesOfChoiceTactical/resources/enemies/fiend.tres` | Fiend recruit stats |
| `EchoesOfChoiceTactical/resources/enemies/druid.tres` | Druid recruit stats |
| `EchoesOfChoiceTactical/resources/enemies/necromancer.tres` | Necromancer recruit stats |
| `EchoesOfChoiceTactical/resources/enemies/psion.tres` | Psion recruit stats |
| `EchoesOfChoiceTactical/resources/enemies/runewright.tres` | Runewright recruit stats |
| `EchoesOfChoiceTactical/resources/enemies/shaman.tres` | Shaman recruit stats |
| `EchoesOfChoiceTactical/resources/enemies/warlock.tres` | Warlock recruit stats |
| `EchoesOfChoiceTactical/scripts/data/battle_config.gd` | Elemental battle configs (to be added) |

## Related Skills

| Skill | When to Use |
|-------|-------------|
| **tactical-balance-feedback-loop** | Must complete Prog 0-6 first |
| **tactical-battle-simulator** | Running simulations |
| **tactical-party-comp-balance** | Composition analysis with recruits |
| **character-stat-tuning** | Adjusting stats and abilities |
