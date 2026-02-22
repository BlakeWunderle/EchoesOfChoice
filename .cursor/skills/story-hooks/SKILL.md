---
name: story-hooks
description: Create logical narrative hooks for map transitions in EchoesOfChoiceTactical. Use when writing or editing map node descriptions, transition reasons between battles and towns, branch choices, or story flow. Ensures each step has a clear reason; adjusts battle themes when needed; uses branches and next_nodes for replay variety.
---

# Story Hooks

Use this skill when writing or editing map node descriptions, transition reasons, branch choices, or story flow between battles and towns for the Godot tactical game at `EchoesOfChoiceTactical/`. Hooks give the party a **logical reason** to go from one place to the next (e.g. rumor + storm driving them to the cave; leaving the castle and being jumped by thugs).

## Data

[EchoesOfChoiceTactical/scripts/data/map_data.gd](EchoesOfChoiceTactical/scripts/data/map_data.gd): `MapData.NODES` — each node has:

- **description**: The hook text shown in the overworld when the node is selected. Use it to explain **why the party is here** and/or **why they would go to next_nodes**.
- **prev_nodes** / **next_nodes**: Flow. A → B means B is in A’s `next_nodes` and A is in B’s `prev_nodes`.
- **branch_group**: When one node in the group is chosen, the **others are locked** for that run ([get_branch_siblings](EchoesOfChoiceTactical/scripts/data/map_data.gd)). Use for replay variety (e.g. forest_village → smoke, deep_forest, clearing, ruins; picking one locks the rest).

[OverworldMap.gd](EchoesOfChoiceTactical/scenes/overworld/OverworldMap.gd) shows `display_name` and `description` when a node is selected (lines 120–121).

## Hook Types

For each transition A → B, the **reason** to go to B should appear in (1) A’s `description` (rumor, road, event), or (2) B’s `description` (what the party finds).

| Type | Example | Where it lives |
|------|---------|----------------|
| **Leaving safety → immediate threat** | “Leaving the castle, you’re set upon by thugs on the city streets.” | castle → city_street: city_street’s description (or castle’s) |
| **Rumor + event → destination** | “Villagers speak of a cave in the hills. A storm drives the party toward it for shelter.” | forest_village description + clearing “storm drives the party toward the cave” |
| **Rest stop then choice** | “Three roads lead out: the coast, the cemetery, the encampment.” | crossroads_inn description; next_nodes = shore, cemetery_battle, army_battle |

If a battle has **no natural hook**, **change the theme or description**: reframe the encounter or add one sentence so the transition makes sense. If needed, align the battle’s enemies with the new framing using [making-battle-configs](.cursor/skills/making-battle-configs/SKILL.md).

## Logical Flow

- For each step A → B: the reason to go to B must appear in A’s `description` (rumor, road, storm) or B’s `description` (what the party finds).
- Towns and rest stops (e.g. forest_village, crossroads_inn) are good places to **foreshadow** next_nodes: “Villagers speak of a cave…”, “Three roads lead out…”.
- Battle nodes can describe the **immediate encounter** (“Thugs roam the streets”, “Shades cling to the crumbling stonework”) so the player knows why they’re fighting.

## Replay Variety

- **Branches**: Use `branch_group` so that from one node (e.g. forest_village), multiple nodes (smoke, deep_forest, clearing, ruins) are options; **choosing one locks the others** for that run. Same `prev_nodes` and shared `branch_group` = mutually exclusive choices.
- **Multiple next_nodes from towns**: Give towns 2–4 `next_nodes` so the player effectively “chooses” direction (e.g. forest_village → 4 options; crossroads_inn → 3 options). Different playthroughs can take different paths.
- Optional: If the game later supports multiple description variants or flavor text per node, use them to increase freshness.

## Implementation

1. Edit **MapData.NODES** in [map_data.gd](EchoesOfChoiceTactical/scripts/data/map_data.gd).
2. For each node, set **description** to include the hook for **reaching** this node and/or **leaving** to `next_nodes`.
3. Ensure **prev_nodes** / **next_nodes** and **branch_group** are consistent. Nodes in the same `branch_group` must share at least one `prev_node` and list each other as siblings via `get_branch_siblings`.
4. If a battle’s theme doesn’t fit the hook, update that node’s **description** and, if needed, the battle config (making-battle-configs) so enemies and names match the story.

See [reference.md](reference.md) for a checklist and node review list.

## References

- [map_data.gd](EchoesOfChoiceTactical/scripts/data/map_data.gd): NODES, get_branch_siblings.
- [OverworldMap.gd](EchoesOfChoiceTactical/scenes/overworld/OverworldMap.gd): How description and branch locking are used.
- [making-battle-configs/SKILL.md](.cursor/skills/making-battle-configs/SKILL.md): Aligning battle theme with hook.
