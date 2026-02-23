# Map Terrain Reference

## MapData.Terrain → Suggested Terrain Elements

| Terrain | Suggested elements | Elevation range | Destructibles |
|---------|--------------------|-----------------|---------------|
| CASTLE | Walls (courtyard, corridors) | 0–1 | Optional crates |
| CITY | Buildings as walls, rooftops | 0–2 | Optional crates |
| FOREST | Trees (blocking or rough), ridges | 0–2 | — |
| SMOKE | Hazy rough, sparse blocking | 0–1 | — |
| DEEP_FOREST | Dense trees, ridges | 0–2 | — |
| CLEARING | Open; optional central hill | 0–2 | — |
| SHORE | Water edge (blocking), sand (rough) | 0–1 | — |
| RUINS | Crumbling walls, staircases | 0–3 | Rubble |
| CAVE | Corridor walls, chokepoints | 0–1 | Boulders |
| BEACH | Sand (rough), wreckage (blocking) | 0–1 | Optional |
| PORTAL | Rift terrain, blocking edges | 0–1 | — |
| CIRCUS | Tents (walls), stage (elevation) | 0–2 | Props |
| CEMETERY | Tombstones (blocking/rough), mausoleum | 0–2 | — |
| LAB | Walls, machinery (blocking) | 0–1 | Crates |
| ARMY_CAMP | Tents, barricades | 0–1 | Crates |
| MIRROR | Reflective floor, minimal obstacles | 0–1 | — |
| CITY_GATE | Gate walls, ramparts | 0–2 | — |
| SHRINE | Pillars, platforms | 0–3 | — |
| VILLAGE | Buildings, streets | 0–2 | Crates |
| INN | Interior walls, furniture | 0–1 | — |

Use `Grid.set_tile(pos, walkable, cost, elevation, blocks_los, destructible_hp)` for each override. Default floor: `true`, 1, 0.
