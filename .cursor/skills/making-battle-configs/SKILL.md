---
name: making-battle-configs
description: Create and tune battle configs for EchoesOfChoiceTactical. Use when adding a new battle, editing enemy composition or map size for a node, or ensuring battles have thematic units (4–5 enemies, variety, lead unit), appropriate grid size, and sensible terrain/environment guidance.
---

# Making Battle Configs

Use this skill when creating or editing battle configs for the Godot tactical game at `EchoesOfChoiceTactical/`. Configs define enemy roster, grid size, and (when supported) terrain; follow the rules below so battles feel thematic and consistent.

## Enemy Units

- **Count**: Use **4 or 5** enemy units per battle.
- **Variety**: **Never more than 3** of the same enemy type. Prefer **at most 2** of any type when possible.
- **Thematic fit**: Pick enemies that match the node’s setting. Use `MapData.get_node(battle_id)` for `terrain` and `description`; choose from `EchoesOfChoiceTactical/resources/enemies/*.tres`. Examples:
  - Cemetery: undead (shade, wraith, bone_sentry)
  - Cave: wyrms, bats (fire_wyrmling, frost_wyrmling, cave_bat)
  - Forest: beasts (bear, bear_cub, wolf, wild_boar)
  - City: thugs, street_tough, hex_peddler
  - Clearing: fae (satyr, nymph, pixie)
  - Ruins: shades, wraith, bone_sentry
  - Infernal/portal: hellion, fiendling, imp, fire_spirit
  - Shore/beach: siren, captain, pirate
  For more theme-to-enemy mapping, see [reference.md](reference.md).
- **Lead unit**: One enemy should feel like the boss — give a **distinct name**, use the **strongest or most iconic type**, and place them **centrally or at rear** (e.g. Hobgoblin Chief, Mother Bear, Morwen the witch). Other units can have simpler or repeated names.

## Map Size

Set `grid_width` and `grid_height` from the node’s setting (cave = small, clearing = large):

| Setting type        | Grid size        | Notes                          |
|---------------------|-------------------|--------------------------------|
| Cave                | 8×6               | Tight, chokepoints             |
| Forest, city, indoor| 10×8              | Default; forest can go 12×10  |
| Clearing / arena    | 14×10 to 14×12    | Open, room for elevation       |
| Ruins               | 12×10             | Multiple height levels         |

Source: [EchoesOfChoiceTactical/DESIGN.md](EchoesOfChoiceTactical/DESIGN.md) (Map Design).

## Environment (when terrain exists)

Today `_setup_from_config()` builds a flat grid only. When the game supports per-battle terrain (walls, elevation, destructibles):

- **Objects that can be moved onto** (walkable tiles, destructible crates/boulders): place on **flat or consistent elevation** so they don’t sit on obvious elevation breaks (e.g. avoid crates on cliff lips).
- **Elevation**: Use intentionally — chokepoints, high ground for ranged — not arbitrary bumps. Keep walkable/destructible object placement consistent with elevation so the environment reads clearly.

## Implementation Steps

1. **Add a config factory** in [EchoesOfChoiceTactical/scripts/data/battle_config.gd](EchoesOfChoiceTactical/scripts/data/battle_config.gd):
   - `static func create_<battle_id>() -> BattleConfig`
   - Set `config.battle_id`, `config.grid_width`, `config.grid_height` from the node/setting.
   - Call `_build_party_units(config)` (fills player side from GameState).
   - Build `config.enemy_units` as an array of 4–5 entries: `{"data": FighterData, "name": String, "pos": Vector2i, "level": int}`. Load FighterData with `load("res://resources/enemies/<id>.tres")`. Respect unit count, variety (max 3 per type, prefer 2), theme, and lead unit.

2. **Register the creator** in [EchoesOfChoiceTactical/scenes/battle/BattleMap.gd](EchoesOfChoiceTactical/scenes/battle/BattleMap.gd): add the `battle_id` → creator to `_config_creators`.

3. **If the node doesn’t exist**: Add it to `MapData.NODES` in [EchoesOfChoiceTactical/scripts/data/map_data.gd](EchoesOfChoiceTactical/scripts/data/map_data.gd) with `terrain`, `progression`, `gold_reward`, `prev_nodes`, `next_nodes`, etc.

## References

- [map_data.gd](EchoesOfChoiceTactical/scripts/data/map_data.gd): `MapData.Terrain` enum, `NODES`, `get_node(battle_id)`.
- [battle_config.gd](EchoesOfChoiceTactical/scripts/data/battle_config.gd): `BattleConfig` fields, `_build_party_units`, existing `create_*` examples.
- [BattleMap.gd](EchoesOfChoiceTactical/scenes/battle/BattleMap.gd): `_config_creators`, `_setup_from_config`.
- [reference.md](reference.md): Terrain → enemy theme and grid size, battle_id registration status.
