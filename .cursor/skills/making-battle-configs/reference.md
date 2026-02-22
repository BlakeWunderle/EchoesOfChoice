# Battle Config Reference

## Terrain → Enemies and Grid Size

| Terrain       | Suggested enemies (.tres)                    | Grid size   |
|---------------|----------------------------------------------|-------------|
| CASTLE        | guard_squire, guard_mage, guard_entertainer, guard_scholar | 8×6 (tutorial) |
| CITY          | thug, street_tough, hex_peddler              | 10×8       |
| FOREST        | bear, bear_cub, wolf, wild_boar             | 10×8–12×10 |
| SMOKE         | imp, fire_spirit                            | 10×8       |
| DEEP_FOREST   | witch, wisp, sprite                          | 10×8–12×10 |
| CLEARING      | satyr, nymph, pixie                          | 14×10–14×12|
| RUINS         | shade, wraith, bone_sentry                  | 12×10      |
| CAVE          | fire_wyrmling, frost_wyrmling, cave_bat     | 8×6        |
| PORTAL        | hellion, fiendling, imp                     | 10×8       |
| SHORE         | siren                                       | 10×8       |
| BEACH         | captain, pirate                             | 10×8       |
| CEMETERY      | shade, wraith, bone_sentry                  | 10×8–12×10 |
| CIRCUS        | (carnival: use entertainer-style or mix; add .tres if needed) | 10×8–12×10 |
| LAB           | (automatons/creators: add .tres or reuse)    | 10×8       |
| ARMY_CAMP     | (military/draconian: captain or add .tres)   | 10×8–12×10 |
| MIRROR        | (shadow party: special logic)                | 14×10      |
| CITY_GATE     | street_tough, hex_peddler, night_prowler    | 10×8       |
| SHRINE        | (elementals: add .tres or reuse)            | 14×10      |

Enemy files live in `EchoesOfChoiceTactical/resources/enemies/`. Use existing .tres that fit the theme; add new ones if a theme has no match.

## Battle ID Registration

**Dedicated config** (in `BattleMap._config_creators`):  
tutorial, city_street, forest, village_raid, smoke, deep_forest, clearing, ruins, cave, portal, inn_ambush, shore, beach, gate_ambush.

**Placeholder** (use `BattleConfig.create_placeholder(battle_id)` until a dedicated config is added):  
box_battle, cemetery_battle, lab_battle, army_battle, mirror_battle, return_city_1, return_city_2, return_city_3, return_city_4, elemental_1, elemental_2, elemental_3, elemental_4.

When adding a dedicated config for a placeholder battle_id, add a `create_<battle_id>` in `battle_config.gd` and register it in `BattleMap._config_creators`.
