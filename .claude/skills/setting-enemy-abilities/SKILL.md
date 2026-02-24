---
name: setting-enemy-abilities
description: Set abilities and stats for enemy FighterData in EchoesOfChoiceTactical. Use when creating or editing enemy .tres, assigning abilities by role and theme, basing an enemy on a player class, or designing a unique unit (e.g. zombie) as attacker, tank, healer, support, or ranged.
---

# Setting Enemy Abilities

Use this skill when creating or editing enemy `FighterData` (.tres) in `EchoesOfChoiceTactical/resources/enemies/`. Each enemy has an `abilities` array (references to `AbilityData` in `EchoesOfChoiceTactical/resources/abilities/*.tres`). Assign abilities so the unit fills a **role** and matches its **theme**.

**When the enemy is for a specific battle:** Before creating a new .tres, check the `making-battle-configs` skill “C# battle → tactical roster” — use the exact C# class name and mapping (e.g. Harlequin → harlequin.tres, Chanteuse → chanteuse.tres). Create that .tres with stats/abilities from C# `CharacterClasses/Enemies/<Name>.cs` and `Abilities/Enemy/*.cs` so the battle config can use it and the encounter makes sense (e.g. circus = performers only).

## Data

- **FighterData** ([fighter_data.gd](EchoesOfChoiceTactical/scripts/data/fighter_data.gd)): `abilities: Array[AbilityData]`. Stats (base_max_health, base_physical_attack, etc.), movement, jump, reaction_types.
- **AbilityData** ([ability_data.gd](EchoesOfChoiceTactical/scripts/data/ability_data.gd)): ability_name, modified_stat, modifier, ability_range, aoe_shape, ability_type (DAMAGE, HEAL, BUFF, DEBUFF, TERRAIN), mana_cost, use_on_enemy.
- Abilities live in `EchoesOfChoiceTactical/resources/abilities/*.tres`. Use existing .tres that fit the role and theme; create new .tres only when nothing fits.

## If the enemy is based on a player class

Look at the **player class** in the C# project and in the tactical project:

- **C#**: `EchoesOfChoice/CharacterClasses/` — e.g. `Fighter/`, `Mage/`, `Entertainer/`, `Scholar/` and their subclasses. Each class defines `Abilities = new List<Ability>() { ... }`.
- **Tactical**: `EchoesOfChoiceTactical/resources/classes/*.tres` — same classes as FighterData with an `abilities` array.

Pick **similar ability .tres** from `EchoesOfChoiceTactical/resources/abilities/`: match by name or effect (e.g. C# "Smash" → `smash.tres`, "Fire Ball" → `fire_ball.tres`). Give the enemy a subset that fits its role (e.g. an enemy "Squire" might get smash, bulwark, valor). Do not copy the full player kit; 2–4 abilities per enemy is enough.

## For unique units (e.g. zombie, elemental)

1. **Choose a role** so the unit fills a clear job in the fight:
   - **Physical attacker**: melee damage (modified_stat PHYSICAL_ATTACK). Abilities: smash, sweeping_slash, dash, precise_strike, knockdown, etc.
   - **Magical attacker**: spell damage (modified_stat MAGIC_ATTACK). Abilities: fire_ball, blizzard, spirit_attack, shadow_attack, thunderbolt, etc.
   - **Tank**: high physical/magic defense, guard or absorb. Abilities: bulwark, fortify, aegis, shield_slam, wall, etc.
   - **Healer**: restore HP. Abilities: cure, restoration, purify, elixir, etc.
   - **Support**: buff allies or debuff enemies (buffs, debuffs, utility). Abilities: inspire, decree, frustrate, ballad, smoke_bomb, etc.
   - **Ranged**: ability_range >= 2. Abilities: triple_arrow, called_shot, fire_ball, chain_lightning, etc.

2. **Match theme**: Use the **C# enemy** and **C# enemy abilities** as reference for flavor.
   - **C# enemies**: `EchoesOfChoice/CharacterClasses/Enemies/*.cs` (e.g. `Zombie.cs`, `Ringmaster.cs`). Each defines `Abilities = new List<Ability>() { ... }` with names like `Rend`, `Blight`, `Devour` (Zombie) or `WhipCrack`, `Showstopper`, `CenterRing` (Ringmaster).
   - **C# enemy abilities**: `EchoesOfChoice/CharacterClasses/Abilities/Enemy/*.cs` — enemy-only abilities (Rend, Blight, SirenSong, etc.). If a tactical .tres exists with the same or similar name/effect, use it; otherwise pick the closest tactical ability by role and theme (e.g. Rend → slash or spirit_attack; Blight → debuff/damage over time if available).

3. **Assign 2–4 abilities** from `EchoesOfChoiceTactical/resources/abilities/` that fit both **role** and **theme**. Ensure at least one is a reliable damage or heal so the unit does something every turn. Avoid giving every enemy the same ability set; vary by role within the encounter.

## Critical: Only DAMAGE abilities contribute to offense

**`ability_type` values:**
- `0` = DAMAGE — counts toward the damage matrix in balance_check.gd
- `1` = HEAL — restores HP; does NOT deal damage
- `2` = BUFF — improves ally stats; does NOT deal damage
- `3` = DEBUFF — reduces enemy stats; does NOT deal damage
- `4` = TERRAIN — creates/destroys tiles; does NOT deal damage

**The DEBUFF gotcha:** An enemy can have a high `base_magic_attack` but still deal 0 damage to
every party class if ALL its abilities are DEBUFF/HEAL type. `balance_check.gd` will flag
`⚠ZERO` even though `base_magic_attack` looks correct.

**Real examples that hit this bug:**
- **Sprite** — had `bewitch.tres` (DEBUFF) + `dust_cloud.tres` (DEBUFF) + high mag_atk → ⚠ZERO.
  Fix: replaced `dust_cloud` with `spirit_touch.tres` (magic DAMAGE).
- **Dusk Moth** — had only `wing_dust.tres` (DEBUFF, reduces P.Def) + high mag_atk → ⚠ZERO.
  Fix: added `spirit_touch.tres` as a second ability alongside `wing_dust.tres`.

**Rule:** Every offensive enemy must have at least one `ability_type=0` (DAMAGE) ability.
Support-only units (healers, debuffers) may intentionally have zero DAMAGE abilities —
but verify this is intentional and note it in the battle design.

**How to check:** When assigning an ability .tres, always verify `ability_type` in the file:
```
cat resources/abilities/<name>.tres  # look for "ability_type = X"
```
Or use the balance_check.gd tool — a ⚠ZERO flag on an enemy with high attack stats almost
always means its abilities are all DEBUFF/HEAL.

## Implementation

1. Create or open the enemy .tres (FighterData) in `EchoesOfChoiceTactical/resources/enemies/`.
2. Set base stats (base_max_health, base_physical_attack, etc.) and movement/jump so the unit can perform its role (e.g. tank: higher defense; healer: enough mana).
3. Set `abilities` to an array of `AbilityData` references: use `load("res://resources/abilities/<id>.tres")` in code, or in the editor add references to existing .tres. List 2–4 abilities.
4. If basing on a player class: copy or adapt that class’s ability list from C# or tactical class .tres, then trim to 2–4 and match role.
5. If unique: choose role (attacker/tank/healer/support/ranged), check C# Enemies/*.cs and Abilities/Enemy/*.cs for theme, then pick tactical ability .tres that match.
6. **Verify at least one ability has `ability_type=0` (DAMAGE)** unless the unit is intentionally a pure support/healer. If in doubt, add `spirit_touch.tres` (weak magic DAMAGE) as a fallback basic attack.

## References

- [fighter_data.gd](../../../EchoesOfChoiceTactical/scripts/data/fighter_data.gd): FighterData, abilities array.
- [ability_data.gd](../../../EchoesOfChoiceTactical/scripts/data/ability_data.gd): AbilityData fields, ability_type.
- `EchoesOfChoiceTactical/resources/abilities/*.tres`: all tactical abilities.
- `EchoesOfChoice/CharacterClasses/Enemies/*.cs`: C# enemy classes and their ability names.
- `EchoesOfChoice/CharacterClasses/Abilities/Enemy/*.cs`: C# enemy ability definitions (for theme and naming).
- `making-battle-configs` skill: when creating new enemies for a battle, use this skill to set their abilities. See its reference section “C# battle → tactical roster” for which C# enemies map to which tactical .tres (e.g. cemetery: 2 zombies + 2 ghosts + 1 wraith → bone_sentry, shade, wraith).
- [reference.md](reference.md): Role → example abilities table, C# enemy ability names.
