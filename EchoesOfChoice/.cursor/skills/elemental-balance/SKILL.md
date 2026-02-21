---
name: elemental-balance
description: Balance Elemental battles (Progression 7) in Echoes of Choice. Use when the user wants to tune elemental fights, adjust elemental enemy stats, balance recruit impact, or verify the finale difficulty. Run this only after Progressions 0-6 are balanced via the balance-feedback-loop skill.
---

# Elemental Battle Balance

Dedicated tuning pass for Progression 7 (ElementalBattles 1-4). These are the finale — 4-member parties (3 player + 1 recruit) vs elemental bosses. Recruits shift the power level significantly compared to Prog 0-6, which is why these battles get their own skill.

**Prerequisite:** Progressions 0-6 must be balanced first (use the balance-feedback-loop skill). Player class stats and growth rates should be locked before starting here.

## Target Win Rates

| Battle | Enemies | Recruit Pair | Target | Range |
|--------|---------|-------------|--------|-------|
| **ElementalBattle1** | Air + Water + Fire (3) | Seraph / Fiend | **57.5%** | **55-60%** |
| **ElementalBattle2** | Water + Fire (2) | Druid / Necromancer | **60%** | **57-63%** |
| **ElementalBattle3** | Air + Water (2) | Psion / Runewright | **60%** | **57-63%** |
| **ElementalBattle4** | Air + Fire (2) | Shaman / Warlock | **60%** | **57-63%** |

EB1 is intentionally harder — it has 3 elementals instead of 2, and should feel like the toughest path. The stat reductions on its elementals compensate for the extra enemy but the fight should still land below EB2-4.

## Battle Anatomy

### Elemental Enemies

All four battles draw from the same three elemental classes. Stats are set in the constructors with no `IncreaseLevel()` growth:

| Elemental | HP Range | PhysAtk | MagAtk | Speed | Ability | DodgeChance |
|-----------|----------|---------|--------|-------|---------|-------------|
| Air | 255-338 | 30-40 | 30-40 | 30-40 | Hurricane | 4 |
| Water | 330-420 | 38-48 | 47-57 | 20-30 | Tsunami | 2 |
| Fire | 300-390 | 43-53 | 35-44 | 25-35 | FireBall | 1 |

**Shared base stats** — changing an elemental's constructor affects every battle that uses it. Prefer per-battle adjustments in the battle constructor instead.

### Per-Battle Adjustments (Current)

| Battle | Enemies | Constructor Adjustments |
|--------|---------|------------------------|
| EB1 | Air, Water, Fire | All: HP -30, MaxHP -30, PhysAtk -4, MagAtk -4 |
| EB2 | Water, Fire | None |
| EB3 | Air, Water | All: HP -16, MaxHP -16, MagAtk -2 |
| EB4 | Air, Fire | Air: HP -30, MaxHP -30, Dodge -1; Fire: HP -20, MaxHP -20 |

### Recruits

Each battle has a fixed recruit pair. Every combo is tested with both recruits (9,920 combos = 4,960 base x 2 recruits).

| Battle | Recruits | LevelUps | Stat Adjustments |
|--------|----------|----------|------------------|
| EB1 | Seraph / Fiend | 1 | HP -16, MagAtk -6, PhysAtk -3 |
| EB2 | Druid / Necromancer | 2 | None |
| EB3 | Psion / Runewright | 3 | None |
| EB4 | Shaman / Warlock | 2 | None |

## Tuning Process

### Step 1: Sim all four battles

```bash
# Quick scan
dotnet run --project BattleSimulator -- --sims 50 ElementalBattle1
dotnet run --project BattleSimulator -- --sims 50 ElementalBattle2
dotnet run --project BattleSimulator -- --sims 50 ElementalBattle3
dotnet run --project BattleSimulator -- --sims 50 ElementalBattle4
```

### Step 2: Check each battle against its target

| Battle | STATUS check |
|--------|-------------|
| EB1 | Win rate between 55-60%? |
| EB2 | Win rate between 57-63%? |
| EB3 | Win rate between 57-63%? |
| EB4 | Win rate between 57-63%? |

### Step 3: Adjust and re-sim

Tune one battle at a time. Re-sim at `--sims 50` after each change.

### Step 4: Validate with --auto

```bash
dotnet run --project BattleSimulator -- --auto ElementalBattle1
dotnet run --project BattleSimulator -- --auto ElementalBattle2
dotnet run --project BattleSimulator -- --auto ElementalBattle3
dotnet run --project BattleSimulator -- --auto ElementalBattle4
```

### Step 5: Cross-battle recruit comparison

From the CLASS BREAKDOWN of each battle, compare the two recruit variants:

- Gap between recruit A and recruit B win rates within the same battle should be **< 5%**
- If one recruit is strictly better, consider adjusting its `RecruitSpec` stat adjustments or level-ups

## Tuning Levers (Preferred Order)

### 1. Per-battle stat adjustments (best — battle-specific, no cross-contamination)

Each battle constructor applies flat adjustments after creating elementals. Adjust these first.

**To make a battle easier:**
```csharp
// In ElementalBattle<N>.cs constructor
enemy.Health -= 20;
enemy.MaxHealth -= 20;
enemy.MagicAttack -= 3;
```

**To make a battle harder:**
Reduce existing subtractions, or remove them.

### 2. Enemy count (EB1 only)

EB1 is the only battle with 3 elementals. If it's way out of range despite stat adjustments, consider removing one elemental. But this is a drastic change to the narrative — exhaust stat adjustments first.

### 3. Elemental base stats (caution — affects all 4 battles)

Only touch the elemental class constructors (`AirElemental.cs`, `WaterElemental.cs`, `FireElemental.cs`) if all four battles are uniformly too hard or too easy. A base stat change propagates everywhere, so re-sim all four after.

### 4. Recruit tuning (secondary lever)

Recruit stats are defined in `PartyComposer.cs` via `RecruitSpec`. Each spec has:
- `LevelUps`: how many `IncreaseLevel()` calls the recruit gets
- `healthAdj`, `magicAttackAdj`, `physicalAttackAdj`: flat stat tweaks post-creation

If one battle's recruits are making the fight too easy/hard relative to the others, adjust the recruit spec rather than the elemental enemies.

**Do not change recruit class files** (`CharacterClasses/Enemies/Seraph.cs`, etc.) to fix a single battle — those are shared definitions. Use the `RecruitSpec` adjustments instead.

## Checklist

```
ELEMENTAL BALANCE PASS

Prerequisites:
- [ ] Prog 0-6 balanced (all PASS via balance-feedback-loop)
- [ ] Player class stats locked (no further player changes)

EB1 (target 55-60%):
- [ ] Win rate in range at --sims 50
- [ ] Validated with --auto
- [ ] Seraph vs Fiend gap < 5%

EB2 (target 57-63%):
- [ ] Win rate in range at --sims 50
- [ ] Validated with --auto
- [ ] Druid vs Necromancer gap < 5%

EB3 (target 57-63%):
- [ ] Win rate in range at --sims 50
- [ ] Validated with --auto
- [ ] Psion vs Runewright gap < 5%

EB4 (target 57-63%):
- [ ] Win rate in range at --sims 50
- [ ] Validated with --auto
- [ ] Shaman vs Warlock gap < 5%

Cross-battle:
- [ ] All 4 battles within their target range
- [ ] No path feels significantly harder than another
- [ ] No class flagged WEAK across any elemental battle
```

## Key Files

| File | Purpose |
|------|---------|
| `Battles/ElementalBattle1.cs` | 3 elementals + per-battle stat adjustments |
| `Battles/ElementalBattle2.cs` | 2 elementals, no adjustments |
| `Battles/ElementalBattle3.cs` | 2 elementals + per-battle stat adjustments |
| `Battles/ElementalBattle4.cs` | 2 elementals + per-enemy adjustments |
| `CharacterClasses/Enemies/AirElemental.cs` | Air base stats (shared) |
| `CharacterClasses/Enemies/WaterElemental.cs` | Water base stats (shared) |
| `CharacterClasses/Enemies/FireElemental.cs` | Fire base stats (shared) |
| `BattleSimulator/PartyComposer.cs` | RecruitSpec definitions (lines 126-148) |
| `CharacterClasses/Enemies/Seraph.cs` | Seraph recruit class |
| `CharacterClasses/Enemies/Fiend.cs` | Fiend recruit class |
| `CharacterClasses/Enemies/Druid.cs` | Druid recruit class |
| `CharacterClasses/Enemies/Necromancer.cs` | Necromancer recruit class |
| `CharacterClasses/Enemies/Psion.cs` | Psion recruit class |
| `CharacterClasses/Enemies/Runewright.cs` | Runewright recruit class |
| `CharacterClasses/Enemies/Shaman.cs` | Shaman recruit class |
| `CharacterClasses/Enemies/Warlock.cs` | Warlock recruit class |
