# Story Hooks Reference

## Checklist

- [ ] **Hook types**: For each transition A → B, the reason is in A’s description (rumor, road, event) or B’s description (what the party finds).
- [ ] **Reason in A or B**: No “dead” transition; every next_node is motivated.
- [ ] **branch_group**: Mutually exclusive options share the same branch_group and at least one prev_node; choosing one locks siblings for that run.
- [ ] **When to change battle theme**: If a battle has no natural hook, reframe the encounter in the description or adjust the battle’s enemies (making-battle-configs) to match.

## Existing Nodes: Strong Hooks vs To Review

**Strong hooks (reason clear in description or flow):**

- **castle** → city_street: “Thugs roam the streets outside the castle walls” (immediate threat).
- **forest_village**: “Villagers speak of a cave in the nearby hills” (rumor for cave).
- **clearing**: “A storm drives the party toward the cave the villagers mentioned” (event + rumor).
- **crossroads_inn**: “Three roads lead out: the coast, the old cemetery…, and the encampment at the lab” (rest stop then choice).
- **city_street**: “Thugs roam…” (encounter clear).
- **ruins**: “Shades cling to the crumbling stonework” (encounter clear).

**To review (ensure hook is explicit or theme matches):**

- Any node whose description doesn’t yet explain why the party goes to its next_nodes, or why they came from prev_nodes.
- Battles that feel disconnected from the previous node’s description — add one sentence or align enemies with the hook.

## branch_group Usage

- **forest_branch**: smoke, deep_forest, clearing, ruins (same prev_nodes: forest_village). Choosing one locks the other three.
- **post_inn**: shore, cemetery_battle, army_battle (same prev_nodes: crossroads_inn). Choosing one locks the other two.
- **return_branch**: return_city_1–4 (same prev_nodes: gate_town). Choosing one gate locks the other three.

Empty `branch_group` means no locking; the player can eventually reach all next_nodes (e.g. cave and portal both lead to crossroads_inn).

---

## Dialogue Porting Progress

Status per battle: **desc** = node description written, **dlg** = pre/post battle dialogue added to config.

| Battle ID | Act | desc | dlg | C# Source |
|-----------|-----|------|-----|-----------|
| city_street | 1 | ✅ | ⬜ | CityStreetBattle.cs |
| forest | 1 | ✅ | ⬜ | ForestBattle.cs |
| village_raid | 1 | ✅ | ⬜ | (town: forest_village) |
| smoke | 2 | ✅ | ⬜ | SmokeBattle.cs |
| deep_forest | 2 | ✅ | ⬜ | DeepForestBattle.cs |
| clearing | 2 | ✅ | ⬜ | ClearingBattle.cs |
| ruins | 2 | ✅ | ⬜ | RuinsBattle.cs |
| cave | 2 | ✅ | ⬜ | CaveBattle.cs |
| inn_ambush | 2 | ✅ | ⬜ | (crossroads_inn ambush) |
| portal | 2→3 | ✅ | ⬜ | PortalBattle.cs |
| shore | 3 | ✅ | ⬜ | ShoreBattle.cs |
| beach | 3 | ✅ | ⬜ | BeachBattle.cs |
| cemetery_battle | 3 | ✅ | ⬜ | CemeteryBattle.cs |
| box_battle | 4 | ✅ | ⬜ | BoxBattle.cs |
| army_battle | 4 | ✅ | ⬜ | ArmyBattle.cs |
| lab_battle | 4 | ✅ | ⬜ | LabBattle.cs |
| mirror_battle | 4 | ✅ | ⬜ | MirrorBattle.cs |
| gate_ambush | 5 | ✅ | ⬜ | (gate_town) |
| return_city_1 | 5 | ✅ | ⬜ | ReturnToCityBattle1.cs |
| return_city_2 | 5 | ✅ | ⬜ | ReturnToCityBattle2.cs |
| return_city_3 | 5 | ✅ | ⬜ | ReturnToCityBattle3.cs |
| return_city_4 | 5 | ✅ | ⬜ | ReturnToCityBattle4.cs |
| elemental_1 | 5 | ⬜ | ⬜ | ElementalBattle1.cs |
| elemental_2 | 5 | ⬜ | ⬜ | ElementalBattle2.cs |
| elemental_3 | 5 | ⬜ | ⬜ | ElementalBattle3.cs |
| elemental_4 | 5 | ⬜ | ⬜ | ElementalBattle4.cs |

Mark ⬜ → ✅ as work is done. Update this table when adding or completing dialogue for a battle.
