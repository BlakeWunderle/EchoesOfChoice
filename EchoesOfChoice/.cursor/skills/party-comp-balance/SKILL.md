---
name: party-comp-balance
description: Test and analyze party composition balance in Echoes of Choice. Use when the user wants to check if specific party compositions are too strong or weak, identify class synergies/anti-synergies, find outlier compositions, or ensure no party feels unwinnable or trivial across battles.
---

# Party Composition Balance Testing

This skill guides analysis of *party-level* balance — whether certain 3-class combinations dominate or struggle, rather than individual class win rates (which the battle-simulator skill already tracks).

## Quick Start

### 1. Run a simulation with combo-level output

The simulator already reports the 5 strongest and 5 weakest party compositions per battle. Run with `--auto` for statistically meaningful results:

```bash
dotnet run --project BattleSimulator -- --auto --progression 2
```

### 2. Look for red flags in the output

Check the **WEAKEST COMBOS** and **STRONGEST COMBOS** sections:

```
WEAKEST COMBOS:
  42.0%  Scholar / Scholar / Entertainer    <-- 30+ points below target = problem
  58.0%  Entertainer / Entertainer / Scholar

STRONGEST COMBOS:
  98.0%  Squire / Mage / Squire           <-- Nearly unloseable = problem
  95.0%  Squire / Mage / Mage
```

### 3. Evaluate the spread

The gap between the best and worst composition tells you how balanced the game is:

| Spread | Verdict | Action |
|--------|---------|--------|
| < 15% | Excellent | No action needed |
| 15-25% | Acceptable | Monitor, minor tweaks |
| 25-40% | Concerning | Buff weak classes or add enemy variety |
| > 40% | Critical | Major rebalancing needed |

## What to Analyze

### Per-Battle Composition Spread

For each battle, the simulator outputs `ComboResults` sorted by win rate. Key metrics:

| Metric | How to Get It | Healthy Range |
|--------|--------------|---------------|
| Overall win rate | Reported in summary | Within target +/- 3% |
| Best combo win rate | Top of STRONGEST COMBOS | < target + 20% |
| Worst combo win rate | Bottom of WEAKEST COMBOS | > target - 25% |
| Spread (best - worst) | Subtract | < 30% |
| Std deviation | Mental estimate from class breakdown | Low is better |

### Per-Class Win Rates

The **CLASS BREAKDOWN** section shows each class's average win rate across all compositions it appears in. Flags:

- **WEAK** flag: Class is below `TargetWinRate * 0.60` — severely underperforming
- No flag but 10+ points below average: Underperforming, may need buffs
- 10+ points above average: Overperforming, may carry any party it's in

### Cross-Battle Class Consistency

A class should perform *relatively* consistently across battles at the same progression stage. If a class is top 3 in one battle but bottom 5 in another at the same stage, that indicates a matchup-specific problem (e.g., physical-only class vs magic-immune enemy).

## Common Imbalance Patterns

### 1. One Class Carries Everything
**Symptom:** A single class (e.g., Paladin) has 85%+ win rate while most are 65-70%.
**Cause:** Class has both healing and damage, making it universally strong.
**Fix:** Reduce the overperformer's stats/abilities, NOT buff everything else. Consider:
- Lowering its primary attack stat slightly
- Increasing mana costs on its best ability
- Reducing healing modifier

### 2. Support-Only Classes Are Dead Weight
**Symptom:** Classes with only buff/debuff abilities (no damage) are flagged WEAK.
**Cause:** In a 3v2 or 3v3 fight, spending turns buffing instead of dealing damage loses the DPS race. The AI alternates between support and basic attacks, diluting both.
**Fix:**
- Give the class at least one damage ability alongside support abilities
- Increase the Modifier on buffs/debuffs so the turns aren't wasted
- Increase the class's base attack stats so basic attacks still contribute

### 3. Glass Cannons Dominate Early, Collapse Late
**Symptom:** Offensive classes (high attack, low HP) win 90%+ early but drop to 40% in later progressions.
**Cause:** Enemy damage scales faster than glass cannon survivability. One-shot risk increases.
**Fix:**
- Buff glass cannon HP growth rates (in `IncreaseLevel()`)
- Don't buff base HP — that changes early game balance
- Alternatively, reduce enemy crit stats in late battles

### 4. Tanky Compositions Are Unkillable But Slow
**Symptom:** Triple-defensive parties (e.g., Defender/Priest/Thaumaturge) win 95%+ but battles take many rounds.
**Cause:** High defense + healing outpaces enemy DPS, but the party deals so little damage that fights are grindy.
**Impact:** Not a balance problem per se — they win — but indicates the enemies lack burst or scaling.
**Fix:**
- Give enemies a damage buff ability that scales with fight length
- Add an enemy ability that bypasses defense (e.g., % HP damage)
- Not urgent: the user accepted that slow wins are fine

### 5. Archetype Gaps
**Symptom:** All Fighter-archetype classes cluster at the top; all Scholar classes cluster at the bottom (or vice versa).
**Cause:** Base archetype stats or growth rates systematically favor one archetype.
**Fix:**
- Adjust base class stats (Squire.cs, Mage.cs, etc.)
- Adjust per-level growth rates
- **Caution:** This affects ALL battles at ALL tiers. Test from Progression 0 forward after changes.

## Composition Categories

### By Archetype Mix

Parties are multisets of 3 from the 4 archetypes. Categories:

| Pattern | Example | Expected Behavior |
|---------|---------|-------------------|
| All different | Squire/Mage/Entertainer | Balanced, versatile |
| One duplicate | Squire/Squire/Mage | Specialized toward that archetype's strength |
| Triple | Mage/Mage/Mage | Extreme specialization, should be viable but not dominant |

**Balance goal:** No archetype pattern should be systematically 15+ points above or below average.

### By Role Composition

| Composition | Example | Strengths | Weaknesses |
|------------|---------|-----------|------------|
| 3 Offense | Ninja/Pyromancer/Warcrier | Fast kills | Fragile, one bad RNG = wipe |
| 2 Off + 1 Support | Knight/Cryomancer/Priest | Balanced | None critical |
| 1 Off + 2 Support | Cavalry/Paladin/Laureate | Very durable | Slow damage, long fights |
| 3 Support | Priest/Laureate/Thaumaturge | Nearly unkillable | Minimal damage, grindy |

### Recruited Character (Progression 7 Only)

At Progression 7 (ElementalBattle), parties have 4 members: 3 player characters + 1 recruit. MirrorBattle randomly assigns which ReturnToCityBattle the player gets, which determines both the recruit pair and the ElementalBattle they face.

Each ElementalBattle is tested with its own recruit pair (2 recruits per battle, 9,920 combos each):

| ElementalBattle | Recruit Pair | Role Summary |
|---|---|---|
| 1 | Seraph / Fiend | Seraph: balanced tank/healer. Fiend: magic glass cannon |
| 2 | Druid / Necromancer | Druid: nature magic + healing. Necromancer: dark magic offense |
| 3 | Psion / Runewright | Psion: psychic burst + debuffs. Runewright: balanced all-rounder |
| 4 | Shaman / Warlock | Shaman: tanky support. Warlock: dark magic offense |

**What to look for at Progression 7:**
- Compare the two recruit variants within each ElementalBattle — a gap > 10% indicates one recruit is strictly better for that fight
- Compare win rates ACROSS ElementalBattles — the random path assignment means all 4 should be similarly balanced
- EB1 targets 55-60% (3 elementals); EB2-4 target 57-63% (2 elementals)
- Watch for compositions where the recruit's strengths overlap with the party (e.g., all-magic party + Fiend may be overkill on magic but fragile)

For full elemental tuning, use the **elemental-balance** skill.

## Testing Workflow

### Quick Comp Check (5 minutes)

1. Run the target battle at 50 sims: `dotnet run --project BattleSimulator -- --sims 50 <BattleName>`
2. Scan WEAKEST/STRONGEST COMBOS for spreads > 30%
3. Scan CLASS BREAKDOWN for any class flagged WEAK

### Full Comp Analysis (per progression stage)

1. Run with auto sims: `dotnet run --project BattleSimulator -- --auto --progression <N>`
2. For each battle in the stage:
   - Check that overall win rate is in target range (PASS)
   - Check spread between best and worst combo < 30%
   - Check no class is flagged WEAK
   - Check no class is 20+ points above the next highest
3. If imbalances found, prioritize fixes:
   - Fix WEAK classes first (they make the game feel broken)
   - Then address overperformers (they make the game feel trivial)
   - Then narrow the spread (quality-of-life)

### Cross-Progression Tracking

The **balance-feedback-loop** skill formalizes this into a three-phase loop (enemy tuning → power curve → class banding). Use it for the full iterative process; the tracking below is useful for quick spot-checks.

Track how classes evolve across progressions. A class being WEAK at Prog 0 is acceptable if it becomes strong by Prog 3+. This is the "late bloomer" pattern:

| Class | Prog 0 | Prog 1 | Prog 2 | Prog 3 | Prog 4 | Verdict |
|-------|--------|--------|--------|--------|--------|---------|
| Scholar | 75% | 78% | 82% | 85% | 80% | Late bloomer - OK |
| Monk | 92% | 70% | 55% | 45% | 38% | Falls off hard - needs buff |

## Adjusting for Composition Balance

### Preferred: Adjust the weak/strong class

If one class is the outlier, tune its stats or abilities directly. This is targeted and predictable.

### Alternative: Adjust enemy variety

If the problem is matchup-specific (e.g., all physical parties struggle against a magic-heavy enemy), consider:
- Adding a physical-weak enemy alongside the magic-heavy one
- Reducing the enemy's PhysicalDefense
- Giving the enemy a mix of physical and magic vulnerabilities

### Last resort: Adjust party generation

If a specific composition pattern (like triple-same-archetype) is consistently broken, consider constraining it in `PartyComposer.cs`. But this changes the total combo count and affects all sim results — re-test everything.

## Related Skills

| Skill | When to Use |
|-------|-------------|
| **balance-feedback-loop** | Full iterative balance pass for Prog 0-6 (enemy tuning → power curve → class banding) |
| **elemental-balance** | Dedicated tuning pass for Prog 7 ElementalBattles |
| **battle-simulator** | Running simulations and interpreting output |
| **character-stat-tuning** | Adjusting individual class stats and abilities |

## Key Files

| File | What It Provides |
|------|-----------------|
| `BattleSimulator/SimulationRunner.cs` | Combo results, class breakdown, WEAK flags; `SimulateMultipleStages` for parallel multi-stage runs |
| `BattleSimulator/PartyComposer.cs` | Party generation, tier-aware leveling, `RecruitSpec` definitions, `GetTier2PartiesWithRecruits()` |
| `BattleSimulator/BattleStage.cs` | Target win rates, progression stages; each ElementalBattle has its own recruit pair |
| `CharacterClasses/<Archetype>/<Class>.cs` | Individual class stats and growth rates (differ per tier — affects leveling accuracy) |
| `CharacterClasses/Enemies/<Enemy>.cs` | Enemy stats (primary tuning lever); recruit enemies (Seraph, Fiend, Druid, Necromancer, Psion, Runewright, Shaman, Warlock) |
| `Battles/<BattleName>.cs` | Enemy composition and level-ups per battle |
