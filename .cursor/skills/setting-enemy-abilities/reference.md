# Enemy Abilities Reference

## Role → Example Abilities (tactical .tres names)

| Role | Example abilities (from resources/abilities/) |
|------|-----------------------------------------------|
| Physical attacker | smash, sweeping_slash, dash, precise_strike, knockdown, shield_slam |
| Magical attacker | fire_ball, blizzard, spirit_attack, shadow_attack, thunderbolt, inferno |
| Tank | bulwark, fortify, aegis, shield_slam, wall |
| Healer | cure, restoration, purify, elixir |
| Support | inspire, decree, frustrate, ballad, smoke_bomb, bewilderment |
| Ranged | triple_arrow, called_shot, fire_ball, chain_lightning, gun_shot |

Mix 2–4 abilities per enemy. Ensure at least one is a reliable damage or heal.

## C# Enemy → Ability Names (for theme lookup)

Use C# `CharacterClasses/Enemies/*.cs` and `Abilities/Enemy/*.cs` to see which ability names belong to which enemy; then map to tactical .tres by name or effect (e.g. C# Rend → tactical rend.tres or sweeping_slash.tres; C# Blight → blight.tres or a debuff).

## New enemy .tres

When creating a new enemy: set class_id, class_display_name, base stats, movement, jump, reaction_types, and abilities (array of AbilityData references). Use this skill to pick abilities by role and theme.
