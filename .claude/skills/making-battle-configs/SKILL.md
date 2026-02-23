---
name: making-battle-configs
description: Create and tune battle configs for EchoesOfChoiceTactical. Use when adding a new battle, editing enemy composition or map size for a node, or ensuring battles feel like progression (enemy types and level scale with game stage), have thematic units (4–5 enemies, variety, lead unit), unique rosters across battles (no duplicate enemy types), appropriate grid size, and sensible terrain/environment guidance.
---

# Making Battle Configs

Use this skill when creating or editing battle configs for the Godot tactical game at `EchoesOfChoiceTactical/`. Configs define enemy roster, grid size, and (when supported) terrain; follow the rules below so battles feel thematic and consistent.

## Workflow (do this first — gets the right outcome sooner)

When adding or editing a battle config, **follow this order**. Skipping steps leads to wrong rosters (e.g. fae in a circus, or wrong composition).

1. **Open the C# battle**  
   `EchoesOfChoice/Battles/<BattleName>.cs` — note enemy **classes** and **character names** (e.g. BoxBattle: Harlequin Louis, Chanteuse Erembour, Ringmaster Gaspard).

2. **Check the reference table**  
   In [reference.md](reference.md), section **“C# battle → tactical roster”**: read the **tactical fit** (e.g. “circus with ring leader: 1 ringmaster + 2 harlequins + 2 chanteuses”) and the **.tres mapping** (e.g. Harlequin → harlequin.tres; Chanteuse → chanteuse.tres; “use only performer types — no sprite/pixie/wisp”).

3. **Create missing .tres before building the config**
   If the mapping says a C# type needs a tactical .tres (e.g. harlequin.tres, commander.tres, android.tres) and it doesn’t exist, **create it now** using [setting-enemy-abilities](../setting-enemy-abilities/SKILL.md) (C# `CharacterClasses/Enemies/*.cs` and `Abilities/Enemy/*.cs` for stats/abilities). **Do not substitute thematically wrong types**: e.g. no goblins for “commander and his troops” (use commander.tres, draconian.tres, chaplain.tres); no imps/fiendlings for a lab (use android.tres, machinist.tres, ironclad.tres); no fae for circus (use harlequin.tres, chanteuse.tres). The battle must read as the C# encounter.

4. **Build the config using only the mapped types and C# names**  
   Use exactly the types from the reference table and C# character names (or close variants). No “thematic stand-ins” that don’t match the battle theme (e.g. no fae for a circus; no pirates on shore).

5. **Uniqueness and progression**
   Scan other `create_*` configs in the same stretch **and in adjacent stretches** — avoid reusing enemy types not just within a stretch but across battles that share a theme or terrain type. For example, RUINS and CEMETERY are different stretches but both draw from "undead" — they must use **different specific types** (ruins: shade, wraith, bone_sentry; cemetery: zombie, specter, wraith). Similarly, inn_ambush and mirror_battle both use shadow family types — mirror_battle should escalate, not repeat the same pack. A player who just cleared a battle with shade/bone_sentry should see different units in the next undead fight. Set level from `MapData.get_node(battle_id).progression`.

6. **Add story dialogue**
   Set `config.pre_battle_dialogue` and `config.post_battle_dialogue` arrays. Read the C# `PreBattleInteraction()` / `PostBattleInteraction()` for tone and key beats, then condense to 2–4 exchanges with speaker names. See [story-hooks](../story-hooks/SKILL.md) for the full writing guide and per-battle porting status.

   Ask: **why is this enemy group here, now?** If they were displaced by a larger threat, driven from their territory, or summoned by an unseen hand — add one line of pre-battle dialogue that hints at it. The answer doesn't need to name the cause; it just needs to signal that something is wrong. E.g. "They never share. Something drove them both here." is stronger than simply establishing the encounter.

## Enemy Units

- **Count**: Use **4 or 5** enemy units per battle.
- **Variety**: **Never more than 3** of the same enemy type. Prefer **at most 2** of any type when possible.
- **Progression**: Battles should feel like the game is advancing. Use the node's **progression** from `MapData.get_node(battle_id).progression` (0–7 in map_data.gd).
  - **Enemy level**: Set each enemy's `level` to scale with progression (e.g. `level = maxi(1, progression)` or `progression + 1` for late nodes). Early nodes (0–2) = lower levels; mid (3–5) and late (6–7) = higher. Never use a fixed level for every battle.
  - **Enemy type by stage**: Pick enemy types that match the **stage** of the game so later battles feel harder and more advanced, not the same as the start.
    - **Early (progression 0–2)**: Basic, street, or beast — thug, street_tough, wolf, wild_boar, bear_cub, goblin. Simpler, lower-threat rosters. Avoid guard elites, shadow elites, or infernal leaders here.
    - **Mid (progression 3–5)**: Mixed and specialists — hex_peddler, guard_squire/guard_mage/guard_entertainer/guard_scholar, siren, pirate, captain, witch, wisp, sprite, shade, wraith, bone_sentry, fire_wyrmling, frost_wyrmling, cave_bat, fiendling, imp, shadow_hound, dusk_moth, gloom_stalker. More variety and tactical challenge.
    - **Late (progression 6–7)**: Elite or peak — guard elites, shadow elites (gloom_stalker, shadow_hound, dusk_moth), hellion, fiendling, or other "boss-tier" types. Lead unit should feel like the climax of that stretch. Don't use early-game-only types (e.g. lone thugs) as the main roster for return-city or elemental gates.
  - When in doubt: **later progression = higher level + more advanced enemy types** so the player feels the difficulty ramp.
- **Thematic fit**: Pick enemies that match the node’s setting. Use `MapData.get_node(battle_id)` for `terrain` and `description`; choose from `EchoesOfChoiceTactical/resources/enemies/*.tres`. Examples:
  - Cemetery: corporeal undead + ecto-ranged ghosts (zombie, specter, wraith) — bone_sentry and shade are ruins-only
  - Cave: wyrms, bats (fire_wyrmling, frost_wyrmling, cave_bat)
  - Forest: beasts (bear, bear_cub, wolf, wild_boar)
  - City: thugs, street_tough, hex_peddler
  - Clearing: fae (satyr, nymph, pixie)
  - Ruins: shades, wraith, bone_sentry
  - Infernal/portal: hellion, fiendling, imp, fire_spirit
  - Shore/beach: siren, captain, pirate
  For more theme-to-enemy mapping, see [reference.md](reference.md).
- **Reference the text-based version**: For each battle, **check [reference.md](reference.md) “C# battle → tactical roster”** for that battle’s recommended composition and .tres mapping. Use **only** those types and C# character names. Do **not** use unrelated types as “stand-ins” (e.g. circus = performer types only, not sprite/pixie/wisp; cemetery = zombie/ghost/wraith mapping per table). If a tactical .tres in the mapping doesn’t exist, **create it first** with [setting-enemy-abilities](../setting-enemy-abilities/SKILL.md), then build the config.
- **Unique names fitting class**: Give every enemy a **unique name that fits their class** — not generic labels like "Spray Nymph", "Deck Hand", "Grave Shade", or "Shadow Hound". Use proper names or evocative titles (e.g. nymphs: Nerida, Coralie; pirates: Flint, Bonny, Redeye; undead: Mortis, Ravenna, Joris; performers: Louis, Erembour, Gaspard; shadow: Vesper, Umbra, Tenebris). When the C# battle defines character names (e.g. `CemeteryBattle` → Mort--, Rave--, Jori--; `BoxBattle` → Louis, Erembour, Gaspard), use those or close variants in the tactical config so the fight feels like the same story beat.
- **Lead unit**: One enemy should feel like the boss — give a **distinct name**, use the **strongest or most iconic type**, and place them **centrally or at rear** (e.g. Hobgoblin Chief, Mother Bear, Morwen the witch). Other units can have simpler or repeated names.
- **Uniqueness across battles**: Make each fight feel unique — **avoid reusing the same enemy types across battles**. When choosing enemies for a battle, prefer .tres that are not already used in other battles in the same stretch (e.g. start→crossroads, crossroads→gate town). **Also check adjacent stretches for shared themes**: RUINS and CEMETERY both draw from "undead" — they must use different specific types (ruins: shade, wraith, bone_sentry; cemetery: zombie, specter, wraith). inn_ambush and mirror_battle both use shadow family — mirror_battle must escalate to a commanding entity (void_stalker) rather than the same pack. If the roster is limited, some reuse is acceptable, but two battles that share a theme should use different specific .tres so the player sees escalation, not repetition. When adding or tuning a battle, scan existing `create_*` configs across the whole campaign (not just the current stretch) and prefer different enemy .tres for same-theme battles.

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

1. **Follow the Workflow** (above): C# battle → reference table → create missing .tres (via [setting-enemy-abilities](../setting-enemy-abilities/SKILL.md)) → then implement.

2. **Add a config factory** in [EchoesOfChoiceTactical/scripts/data/battle_config.gd](EchoesOfChoiceTactical/scripts/data/battle_config.gd):
   - `static func create_<battle_id>() -> BattleConfig`
   - Set `config.battle_id`, `config.grid_width`, `config.grid_height` from the node/setting.
   - Call `_build_party_units(config)` (fills player side from GameState).
   - Build `config.enemy_units` from the **reference table** only: 4–5 entries `{"data": FighterData, "name": String, "pos": Vector2i, "level": int}`. Use the .tres and names from the “C# battle → tactical roster” table. Get `progression` from `MapData.get_node(battle_id).progression` and set each enemy's `level` (e.g. `maxi(1, progression)`). Respect unit count, variety (max 3 per type, prefer 2), lead unit at rear/center, and uniqueness across the stretch.

3. **Register the creator** in [EchoesOfChoiceTactical/scenes/battle/BattleMap.gd](EchoesOfChoiceTactical/scenes/battle/BattleMap.gd): add the `battle_id` → creator to `_config_creators`.

4. **If the node doesn’t exist**: Add it to `MapData.NODES` in [EchoesOfChoiceTactical/scripts/data/map_data.gd](EchoesOfChoiceTactical/scripts/data/map_data.gd) with `terrain`, `progression`, `gold_reward`, `prev_nodes`, `next_nodes`, etc.

## References

- [map_data.gd](EchoesOfChoiceTactical/scripts/data/map_data.gd): `MapData.Terrain` enum, `NODES`, `get_node(battle_id)`.
- [battle_config.gd](EchoesOfChoiceTactical/scripts/data/battle_config.gd): `BattleConfig` fields, `_build_party_units`, existing `create_*` examples.
- [BattleMap.gd](EchoesOfChoiceTactical/scenes/battle/BattleMap.gd): `_config_creators`, `_setup_from_config`.
- [reference.md](reference.md): Terrain → enemy theme and grid size, battle_id registration status.
- **C# battles**: `EchoesOfChoice/Battles/*.cs` — enemy types per battle (e.g. `CemeteryBattle` → Zombie; `BoxBattle` → Harlequin, Chanteuse, Ringmaster). Use when picking or creating tactical enemies.
- **New enemies**: If you create a new enemy .tres, use [setting-enemy-abilities](../setting-enemy-abilities/SKILL.md) to assign abilities by role and theme.
