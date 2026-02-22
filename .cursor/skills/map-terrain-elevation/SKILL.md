---
name: map-terrain-elevation
description: Add elevation and thematic terrain to battle maps in EchoesOfChoiceTactical. Use when designing or implementing terrain for a battle (forest trees, city buildings, cave chokepoints), editing walls or destructibles, or applying elevation. Works after making-battle-configs has set grid size and unit roster.
---

# Map Terrain and Elevation

Use this skill when adding or editing battle map terrain, elevation, walls, or destructibles for the Godot tactical game at `EchoesOfChoiceTactical/`. Terrain is applied **after** [making-battle-configs](.cursor/skills/making-battle-configs/SKILL.md) has set grid size and enemy roster; use the same dimensions and respect spawn zones.

## Grid API

[EchoesOfChoiceTactical/scripts/systems/grid.gd](EchoesOfChoiceTactical/scripts/systems/grid.gd):

```gdscript
grid.set_tile(pos, walkable, cost, elevation, blocks_los, destructible_hp)
```

- **Default floor**: `true`, 1, 0 — walkable, cost 1, elevation 0.
- **Walls**: `false`, 999, 0, `true` — impassable, block LOS.
- **Destructible**: `false`, 999, 0, `true`, hp — e.g. boulder with HP 20.
- **Rough terrain**: `true`, 2, 0 — walkable but costs 2 movement.
- **Elevation**: 0–3. Climbing costs extra movement per level; ranged abilities gain +1 range per elevation level above target. Use intentionally (chokepoints, high ground).

In-code example of applying walls, elevation, rough, and destructible: [BattleMap.gd](EchoesOfChoiceTactical/scenes/battle/BattleMap.gd) `_setup_test_battle()` (lines 66–84).

## Thematic Rules

Align with [DESIGN.md](EchoesOfChoiceTactical/DESIGN.md) Map Design and making-battle-configs. Place walkable/destructible objects on **flat or consistent elevation** (no crates on cliff lips).

| Setting | Terrain elements | Notes |
|--------|------------------|--------|
| **Forest** | Trees as blocking (`blocks_los` true) or rough (cost 2); optional ridges (elevation 1–2) | Don’t overcrowd; leave paths. Objects on flat elevation. |
| **City / town** | Buildings as walls (impassable, block LOS). Rooftops at elevation 2 where it makes sense | Streets walkable; chokepoints between buildings. |
| **Cave** | Walls for corridors and chokepoints; destructible boulders (`destructible_hp`) | Keep size small (making-battle-configs: 8×6). |
| **Ruins** | Crumbling walls (blocking); staircases = elevation steps (0–3) | Multiple height levels. |
| **Clearing / arena** | Open; optional central hill (elevation 1–2) | Few or no walls. |

See [reference.md](reference.md) for a compact setting → terrain table.

## Concert with making-battle-configs

- Use the **same grid dimensions** (grid_width, grid_height) as the battle config for that node.
- Respect **spawn zones**: don’t place walls or destructibles on player/enemy spawn tiles (positions from config.player_units and config.enemy_units).
- **Elevation**: Use for chokepoints and high ground, not arbitrary bumps. Keep walkable/destructible object placement consistent with elevation so the environment reads clearly.
- Map size by setting (cave small, clearing large) is defined in making-battle-configs; this skill only adds terrain on that grid.

## Implementation Note

Today [BattleMap._setup_from_config()](EchoesOfChoiceTactical/scenes/battle/BattleMap.gd) builds a **flat grid only** (all walkable, elevation 0). To support per-battle terrain:

1. **Data shape**: Define terrain as an array of tile overrides, e.g. `{pos: Vector2i, walkable: bool, cost: int, elevation: int, blocks_los: bool, destructible_hp: int}`. Default: only list non-default tiles. Can be keyed by `battle_id` or `MapData.Terrain` (e.g. in BattleConfig or a separate map-layout resource).
2. **Apply after grid creation**: In `_setup_from_config()`, after building the flat grid and spawning units, iterate the terrain overrides and call `grid.set_tile(pos, ...)` for each. Do not overwrite spawn positions.

Until the game supports this, design terrain in the skill’s terms and implement when BattleConfig or a map resource is extended.

## References

- [grid.gd](EchoesOfChoiceTactical/scripts/systems/grid.gd): `set_tile`, movement cost, elevation, LOS.
- [BattleMap.gd](EchoesOfChoiceTactical/scenes/battle/BattleMap.gd): `_setup_from_config`, `_setup_test_battle`.
- [making-battle-configs/SKILL.md](.cursor/skills/making-battle-configs/SKILL.md): Map size, object placement rules.
- [DESIGN.md](EchoesOfChoiceTactical/DESIGN.md): Map Design section.
