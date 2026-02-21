---
name: character-stat-tuning
description: Guide for adjusting character and enemy stats in Echoes of Choice. Use when the user wants to buff, nerf, rebalance, or tune character stats, abilities, or growth. Covers archetype identity, offensive vs defensive roles, and stat priorities.
---

# Character Stat Tuning

All paths are relative to the workspace root. The C# project lives at `EchoesOfChoice/`.

When adjusting character stats, respect the **archetype identity** and **role** of the class. Every class falls into an archetype (Fighter, Mage, Entertainer, Scholar) and a role (offensive or defensive/support).

## Stat Overview

| Stat | What It Does |
|------|-------------|
| Health / MaxHealth | Hit points; 0 = knocked out |
| Mana / MaxMana | Resource for abilities |
| PhysicalAttack | Damage for physical attacks and PhysicalAttack abilities |
| PhysicalDefense | Reduces incoming physical damage |
| MagicAttack | Damage for magic abilities; healing power for support |
| MagicDefense | Reduces incoming magic damage |
| Speed | Fills turn gauge; higher = act more often |
| CritChance | Chance to crit (rolled against 1-10; hit if roll > 10 - CritChance) |
| CritDamage | Flat bonus damage on crit |
| DodgeChance | Chance to dodge physical attacks (roll 1-10; dodge if roll <= DodgeChance) |

## Archetype Stat Priorities

### Fighter (Physical Bruiser)
**Identity:** High HP, strong physical stats, low magic. Frontline.

| Priority | Stats |
|----------|-------|
| Primary | PhysicalAttack, PhysicalDefense, Health |
| Secondary | Speed, CritChance, CritDamage |
| Dump stats | MagicAttack, MagicDefense, Mana |

**Base ranges:** HP 50-60, PhysAtk 15-20, PhysDef 13-17, MagAtk 7-10, MagDef 10-15, Spd 10-15, Mana 4-13

### Mage (Magic Caster)
**Identity:** High magic stats and mana, fragile physically. Glass cannon or healer.

| Priority | Stats |
|----------|-------|
| Primary | MagicAttack, MagicDefense, Mana |
| Secondary | Speed, Health |
| Dump stats | PhysicalAttack, PhysicalDefense, CritChance |

**Base ranges:** HP 45-52, PhysAtk 10-17, PhysDef 10-15, MagAtk 17-23, MagDef 15-20, Spd 13-17, Mana 15-23

### Entertainer (Agile Hybrid)
**Identity:** Fast, evasive, mixed offense. Debuffs and disruption.

| Priority | Stats |
|----------|-------|
| Primary | Speed, DodgeChance, MagicAttack |
| Secondary | PhysicalAttack, Health, CritChance |
| Dump stats | PhysicalDefense, MagicDefense |

**Base ranges:** HP 45-52, PhysAtk 10-17, PhysDef 10-15, MagAtk 12-20, MagDef 15-20, Spd 15-20, Mana 10-17

### Scholar (Magic Utility)
**Identity:** Highest magic potential, weakest physically. Unique utility abilities.

| Priority | Stats |
|----------|-------|
| Primary | MagicAttack, MagicDefense, Mana |
| Secondary | Speed |
| Dump stats | Health, PhysicalAttack, PhysicalDefense |

**Base ranges:** HP 40-47, PhysAtk 7-10, PhysDef 10-13, MagAtk 15-20, MagDef 15-20, Spd 10-15, Mana 10-17

## Offensive vs Defensive Roles

Within each archetype, classes split into offensive and defensive/support roles. When tuning stats, push in the direction of their role.

### Fighter Roles

| Role | Classes | Stat Emphasis |
|------|---------|---------------|
| **Offensive** | Duelist, Cavalry, Ranger, Mercenary, Hunter, MartialArtist, Ninja | Higher PhysAtk, CritChance, CritDamage, Speed |
| **Defensive** | Warden, Knight, Bastion | Higher PhysDef, Health, lower CritChance. Bastion has Taunt to redirect enemy attacks. |
| **Hybrid** | Dragoon, Monk | Balanced PhysAtk + MagAtk, MixedAttack abilities, high dodge |

### Mage Roles

| Role | Classes | Stat Emphasis |
|------|---------|---------------|
| **Offensive** | Mistweaver, Firebrand, Stormcaller, Cryomancer, Hydromancer, Pyromancer, Geomancer, Electromancer, Tempest | Higher MagAtk, Speed, more damage abilities |
| **Hybrid** | Paladin | Balanced PhysAtk + MagDef, MixedAttack abilities (Smite), healing |
| **Support** | Acolyte, Priest | Higher Mana, MagDef, healing/buff abilities (Cure, Protect, Holy) |

### Entertainer Roles

| Role | Classes | Stat Emphasis |
|------|---------|---------------|
| **Hybrid** | Dervish, Illusionist, Mime, Warcrier | Balanced PhysAtk + MagAtk, MixedAttack abilities, higher Speed/DodgeChance |
| **Support** | Bard, Minstrel, Orator, Laureate, Elegist, Herald, Muse, Chorister | Higher MagAtk (for buff/debuff Modifiers), Mana |

### Scholar Roles

| Role | Classes | Stat Emphasis |
|------|---------|---------------|
| **Offensive** | Artificer, Automaton, Astronomer | Higher MagAtk, damage abilities |
| **Hybrid** | Alchemist, Bombardier | Balanced PhysAtk + MagAtk, MixedAttack abilities |
| **Defensive** | Thaumaturge, Siegemaster | Higher PhysDef, MagDef, protective wards and magic damage |
| **Utility** | Arithmancer, Cosmologist, Technomancer, Chronomancer, Tinker | Mixed stats, unique debuff/utility abilities |

## Enemy Stats

All enemies use dedicated enemy classes in `EchoesOfChoice/CharacterClasses/Enemies/`. Enemy stats are fully self-contained in each class constructor — battle files simply instantiate enemies with no stat adjustments. The only exception is **MirrorBattle**, which clones the player party.

**Recruit enemies** (Seraph, Fiend, Druid, Necromancer, Psion, Runewright, Shaman, Warlock) serve double duty as both battle enemies and recruitable 4th party members. Their stats are static -- `IncreaseLevel()` only increments Level with no stat gains. They are overpowered companions at their full battle power level. `RecruitSpec` in `PartyComposer.cs` has zero adjustments; `CreateRecruit` just instantiates the class as-is.

To adjust a battle's difficulty, tune the enemy class stats directly in `EchoesOfChoice/CharacterClasses/Enemies/<EnemyName>.cs`. No battle file edits are needed.

## After Making Changes

Any player-side stat or ability change can shift overall win rates across multiple battles. After tuning, re-run the **balance-feedback-loop** skill (Prog 0-6) or **elemental-balance** skill (Prog 7) to verify the change didn't break the difficulty gradient or power curve.

## Tuning Rules

### Adjusting Base Stats (in base class constructors: Squire.cs, Mage.cs, Entertainer.cs, Scholar.cs)

Base stats use `random.Next(min, max)`. To tune:
- **Widen the range** for more variance (riskier but more interesting)
- **Shift the range up/down** to buff/nerf the whole archetype
- Keep the archetype identity: don't give Scholars more PhysAtk than Fighters

### Adjusting Tier 1/2 Stats (via IncreaseLevel)

Tier 1 and 2 classes inherit base stats via `KeepStatsOnUpgrade()` and grow via `IncreaseLevel()`. To differentiate classes:
- **Offensive classes:** Higher growth in attack stats, speed
- **Defensive classes:** Higher growth in defense, health
- **Support classes:** Higher growth in mana, magic attack (for heal/buff scaling)

### Adjusting CritChance / CritDamage / DodgeChance

These are set as flat values in each class constructor (not random):
- CritChance 1 = 10% crit rate; 3 = 30% crit rate
- DodgeChance 1 = 10% dodge; 3 = 30% dodge
- Keep CritChance at 1-3 for most classes; only give 4+ to pure glass cannons
- Only Dervishes/Shadows/Ninjas should have DodgeChance > 2

### Adjusting Abilities

Abilities are defined in `EchoesOfChoice/CharacterClasses/Abilities/`. Each ability has these properties:

| Property | Type | What It Controls |
|----------|------|-----------------|
| ModifiedStat | StatEnum | Which stat the ability scales off (damage) or modifies (buff/debuff) |
| Modifier | int | Flat bonus added to the relevant stat calculation |
| impactedTurns | int | 0 = instant effect; >0 = temporary buff/debuff lasting N turns |
| UseOnEnemy | bool | true = targets enemy; false = targets ally |
| ManaCost | int | Mana consumed per use |

#### Ability Types and Damage Formulas

There are four ability types, determined by `UseOnEnemy` and `impactedTurns`:

**1. Instant Damage** (UseOnEnemy=true, impactedTurns=0):
- PhysicalAttack abilities: `damage = Modifier + attacker.PhysicalAttack - target.PhysicalDefense`
- MagicAttack abilities: `damage = Modifier + attacker.MagicAttack - target.MagicDefense`
- MixedAttack abilities: `damage = Modifier + (attacker.PhysicalAttack + attacker.MagicAttack) / 2 - (target.PhysicalDefense + target.MagicDefense) / 2`
- Damage is clamped to minimum 0, then CritDamage is added on crit

**2. Debuffs** (UseOnEnemy=true, impactedTurns>0):
- Deals **zero damage**. Reduces target's stat by Modifier for N turns.
- After N turns, the stat is restored automatically.
- Debuffing a stat the enemy doesn't use is wasted (e.g., lowering MagicDefense vs physical-only enemies).

**3. Instant Heals** (UseOnEnemy=false, impactedTurns=0):
- Heals `Modifier + caster.MagicAttack` HP (capped at MaxHealth).
- MixedAttack heals: `Modifier + (caster.PhysicalAttack + caster.MagicAttack) / 2` HP.

**4. Buffs** (UseOnEnemy=false, impactedTurns>0):
- Increases ally's stat by Modifier for N turns. No direct damage or healing.
- StatEnum.Attack/Defense affect both physical AND magic variants simultaneously.
- StatEnum.MixedAttack buffs/debuffs both PhysicalAttack and MagicAttack simultaneously.

**5. Taunt** (UseOnEnemy=false, ModifiedStat=StatEnum.Taunt):
- Self-buff that forces all opponents to target the taunter for single-target attacks and abilities.
- AoE abilities bypass taunt (they hit all targets regardless).
- If the taunter dies, taunt is removed and normal targeting resumes.
- Works symmetrically: player tanks force AI enemies to attack them; enemy tanks auto-select the player's target.
- AI uses taunt based on a **tankRatio** (`(PhysDef + MagDef) / (PhysDef + MagDef + PhysAtk + MagAtk)`) scaled by enemy count (`targets.Count / 3.0`). Defensive units taunt eagerly; offensive units prefer dealing damage. Fewer enemies also reduce taunt probability since finishing the fight becomes more valuable.
- Duration is 1 turn to balance the high action-economy impact of redirecting all enemy attacks.
- Used by: Bastion, Siegemaster (the defensive tank classes). Can be assigned to enemies too.

#### Modifier Ranges by Tier

| Tier | Damage Modifier | ManaCost | Examples |
|------|----------------|----------|----------|
| Base (starting) | 2-3 | 1-3 | Blast (2), Slash (3), Kick (2), Punch (3) |
| Tier 1 | 3-6 | 2-4 | Fire/Ice/Lightning (3), Charge (3), Pierce (3), DoubleArrow (6), Solo (6) |
| Tier 2 | 5-10 | 3-6 | Charge2 (5), GunShot (5), TripleArrow (9), Lava (10), Explosion (10) |
| Boss / Elemental | 10-12 | 5-6 | Earthquake (12), Hurricane (12), FireBall (12), Tsunami (12) |

| Tier | Debuff Modifier | impactedTurns | Examples |
|------|----------------|---------------|----------|
| Tier 1 | 3 | 2 | Sing (MagDef), Seduce (Defense), Proof (MagDef) |
| Tier 2 | 5 | 2 | Frustrate (Attack), Lullaby (Speed), Knockdown (Speed), Undertow (Speed) |
| High-end | 10 | 3 | VocalSolo (PhysAtk) |

| Tier | Buff Modifier | impactedTurns | Examples |
|------|--------------|---------------|----------|
| Low | 2-3 | 2 | Trap (Defense 2), Block (Defense 3), Encourage (Attack 3), Protect (Defense 3) |
| High | 5 | 2 | Wall (Defense 5), Inspire (Attack 5), Enrage (MagAtk 5), Block2 (Defense 5) |
| Extreme | 10 | 2 | WarpSpeed (Speed 10) |

#### When to Adjust Abilities vs Stats

Use **ability changes** when:
- A class has the right stats but its turns feel wasted (e.g., debuffing a stat the enemy doesn't use)
- A class's damage per turn is too high/low relative to its role despite appropriate stats
- You want to change *how* a class plays (more bursty, more sustained, more supportive)
- A debuff is targeting the wrong stat for the matchup (e.g., MagDef debuff vs physical enemies)
- Mana economy needs adjustment (running dry too fast or never spending mana)

Use **stat changes** when:
- All abilities feel fine but the class is uniformly too strong/weak
- The class is too tanky or too squishy regardless of abilities
- Speed-based turn order issues (acting too often or too rarely)

#### AI Behavior and Abilities

The AI chooses actions based on `magicRatio = MagicAttack / (MagicAttack + PhysicalAttack)`:
- High magic ratio (>0.6): prefers MagicAttack abilities, targets lowest-HP enemy
- Low magic ratio (<0.4): prefers PhysicalAttack abilities, targets highest-HP enemy
- Balanced: mixes randomly
- MixedAttack abilities are always considered preferred regardless of magic ratio

**Critical:** Debuff abilities with `UseOnEnemy=true` count as "offensive" abilities to the AI. A class whose only ability is a debuff will spend a proportional amount of turns debuffing instead of dealing damage. If a class needs to deal damage, it must have at least one instant-damage ability (impactedTurns=0).

**Heal/buff priority:** AI heals wounded allies (<50% HP) before anything else, and occasionally buffs the strongest ally. Classes with both heal and damage abilities will heal reactively.

#### Ability Assignment Rules

- **Offensive classes** should have at least one instant-damage ability. Pairing a damage ability with a debuff is fine (the AI will mix both).
- **Support classes** can have only buff/debuff/heal abilities, but be aware they contribute zero direct damage.
- **Dual-use classes** (used as both player and enemy): changing abilities affects AI behavior on both sides. Test with the simulator after changes.
- **Enemy-only classes** can have abilities tuned freely without player impact.
- Multiple classes can share the same Ability class. Changing an ability's Modifier affects every class that uses it — check which classes reference it before editing.

## IncreaseLevel Growth Guidelines

Per-level stat gains should follow this pattern:

| Archetype | HP | Mana | PhysAtk | PhysDef | MagAtk | MagDef | Speed |
|-----------|-----|------|---------|---------|--------|--------|-------|
| Fighter (off) | +5-10 | +1-3 | **+4-7** | +2-4 | +1-2 | +1-2 | +2-4 |
| Fighter (def) | **+8-14** | +1-3 | +2-4 | **+4-7** | +1-2 | +1-2 | +1-3 |
| Fighter (hybrid) | +5-10 | +2-5 | **+4-7** | +2-4 | **+4-7** | +2-4 | +3-6 |
| Mage (off) | +4-8 | **+4-8** | +1-2 | +1-2 | **+5-9** | +3-5 | +2-4 |
| Mage (hybrid) | +5-10 | +2-7 | **+4-8** | +2-4 | +2-4 | **+4-8** | +2-4 |
| Mage (sup) | +5-10 | **+5-10** | +1-2 | +1-3 | **+4-7** | **+4-7** | +1-3 |
| Entertainer (hybrid) | +4-8 | +2-6 | **+3-6** | +2-4 | **+3-6** | +2-4 | **+3-6** |
| Entertainer (sup) | +4-8 | +3-6 | +1-3 | +1-2 | **+3-6** | +2-4 | +2-4 |
| Scholar (off) | +3-6 | **+4-8** | +1-2 | +1-2 | **+5-9** | +3-5 | +1-3 |
| Scholar (hybrid) | +5-10 | +2-5 | **+4-8** | +2-4 | **+4-8** | +2-4 | +1-3 |
| Scholar (def) | +5-10 | +3-6 | +1-2 | **+3-6** | +3-5 | **+4-7** | +1-3 |

Bold = primary growth stats for that role.

## File Locations

| What | Where |
|------|-------|
| Base class stats | `EchoesOfChoice/CharacterClasses/Fighter/Squire.cs`, `Mage/Mage.cs`, `Entertainer/Entertainer.cs`, `Scholar/Scholar.cs` |
| Tier 1/2 class stats | `EchoesOfChoice/CharacterClasses/<Archetype>/<ClassName>.cs` (in IncreaseLevel and constructor) |
| Enemy stats | `EchoesOfChoice/CharacterClasses/Enemies/<EnemyName>.cs` |
| Abilities | `EchoesOfChoice/CharacterClasses/Abilities/<AbilityName>.cs` |
| Stat enum | `EchoesOfChoice/CharacterClasses/Common/StatEnum.cs` |

## Related Skills

| Skill | When to Use |
|-------|-------------|
| **balance-feedback-loop** | Full iterative balance pass for Prog 0-6 after stat changes |
| **elemental-balance** | Tuning pass for Prog 7 after stat changes |
| **battle-simulator** | Running simulations to measure the impact of changes |
| **party-comp-balance** | Checking if changes created composition-level imbalances |

## Reference

See [class-catalog.md](class-catalog.md) for full stat tables for every class and enemy.
