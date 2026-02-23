# Battle Config Reference

## C# battle → tactical roster (check this when building a config)

For each battle, look at `EchoesOfChoice/Battles/<BattleName>.cs` for enemy classes and names, then use this table for a **tactical fit** (4–5 units, variety, lead). Map C# class to tactical .tres; use C# character names or close variants.

| C# battle | C# enemies | Tactical fit (types + count) | Tactical .tres mapping |
|-----------|------------|------------------------------|-------------------------|
| CemeteryBattle | 3 Zombie (Mort--, Rave--, Jori--) | 2 zombies + 2 specters + 1 wraith | zombie → zombie.tres (Mortis, Ravenna); specter → specter.tres (Duskward, Hollow); wraith → wraith.tres (Joris, lead). Corporeal undead + ecto-ranged ghosts — distinct from ruins (ethereal only). |
| ShoreBattle | 3 Siren (Lorelei, Thalassa, Ligeia) | sirens + other aquatic only (no pirates) | siren → siren; add nymph or other aquatic |
| BeachBattle | Captain, 2 Pirate (Greybeard, Flint, Bonny) | captain + 3 pirates + kraken | captain, pirate, kraken |
| BoxBattle | Harlequin (Louis), Chanteuse (Erembour), Ringmaster (Gaspard) | **Circus with ring leader**: 1 ringmaster (lead) + 2 harlequins + 2 chanteuses | Ringmaster → guard_entertainer (Gaspard); Harlequin → harlequin.tres (Louis, Pierrot); Chanteuse → chanteuse.tres (Erembour, Colombine). Use only performer types — no sprite/pixie/wisp. |
| ArmyBattle | Commander (Varro), Draconian (Theron), Chaplain (Cristole) | **Commander and his troops**: 1 commander (lead) + 2 draconians + 2 chaplains | Commander → commander.tres (Varro, lead); Draconian → draconian.tres (Theron, Sentinel); Chaplain → chaplain.tres (Cristole, Vestal). Use only army/C# types — no goblins. |
| LabBattle | Android (Deus), Machinist (Ananiah), Ironclad (Acrid) | **Lab constructs only**: 2 androids + 2 machinists + 1 ironclad (lead) | Android → android.tres (Deus, Unit Seven); Machinist → machinist.tres (Ananiah, Cog); Ironclad → ironclad.tres (Acrid, lead). Use only construct types — no imps or fiendlings. |
| MirrorBattle | shadow clones of party | shadow roster (no fixed C# list) | void_stalker.tres (Tenebris, commanding lead), gloom_stalker.tres (Vesper), night_prowler.tres × 2 (Noctis, Penumbra), dusk_moth.tres (Dusk). No shadow_hound — mirror_battle is the watcher's real force, not a scouting pack (inn_ambush used hounds). |

**Workflow (use every time):** 1) Open the C# battle file; 2) Use the **tactical fit** column for composition (exact types and counts); 3) Use the **.tres mapping** — if a .tres is listed but missing, create it (setting-enemy-abilities skill) before building the config; 4) Use only those types (no unrelated stand-ins, e.g. no fae for circus); 5) Use C# character names; 6) Ensure uniqueness across the stretch (no duplicate enemy types between battles in same stretch).

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
| CEMETERY      | zombie, specter, wraith                     | 10×8–12×10 | zombie (corporeal attacker), specter (ecto-ranged magic), wraith (lead). bone_sentry and shade stay in RUINS only — cemetery uses corporeal undead + higher-tier ghosts so the two fights don't overlap. |
| CIRCUS        | (carnival: use entertainer-style or mix; add .tres if needed) | 10×8–12×10 |
| LAB           | (automatons/creators: add .tres or reuse)    | 10×8       |
| ARMY_CAMP     | (military/draconian: captain or add .tres)   | 10×8–12×10 |
| MIRROR        | (shadow party: special logic)                | 14×10      |
| CITY_GATE     | gloom_stalker, night_prowler, hex_peddler, dusk_moth | 10×8 | By prog 5 the watcher sends shadow agents, not street muscle. Keep hex_peddler for one "hired specialist" flavor; replace street_tough entirely. |
| SHRINE        | (elementals: add .tres or reuse)            | 14×10      |

Enemy files live in `EchoesOfChoiceTactical/resources/enemies/`. Use existing .tres that fit the theme; add new ones if a theme has no match. **Uniqueness**: Prefer enemy types not already used in other battles in the same stretch so each fight feels unique. **Progression**: Pick enemy types and levels that match the node's `progression` (0–7 in map_data.gd) — early (0–2) = basic/street/beast; mid (3–5) = mixed/specialists; late (6–7) = elite/peak so battles feel like the game is advancing.

## Battle ID Registration

**Dedicated config** (in `BattleMap._config_creators`):  
tutorial, city_street, forest, village_raid, smoke, deep_forest, clearing, ruins, cave, portal, inn_ambush, shore, beach, cemetery_battle, box_battle, army_battle, lab_battle, mirror_battle, gate_ambush.

**Placeholder** (use `BattleConfig.create_placeholder(battle_id)` until a dedicated config is added):  
return_city_1, return_city_2, return_city_3, return_city_4, elemental_1, elemental_2, elemental_3, elemental_4.

When adding a dedicated config for a placeholder battle_id, add a `create_<battle_id>` in `battle_config.gd` and register it in `BattleMap._config_creators`.
