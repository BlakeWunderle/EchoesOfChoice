---
name: npc-conversations
description: Add named NPCs to town scenes in EchoesOfChoiceTactical. Use when populating towns with characters that give lore, hints, or flavor; writing NPC dialogue; or wiring NPC lists into Town.gd with story-flag gating.
---

# NPC Conversations

Use this skill when adding named characters to town nodes that the player can talk to. NPCs make towns feel inhabited — they react to story events, hint at upcoming dangers, and add world flavor beyond shop/recruit menus.

## Data

NPCs are stored per node in `MapData.NODES` (in [map_data.gd](../../../EchoesOfChoiceTactical/scripts/data/map_data.gd)):

```gdscript
"npcs": [
    {
        "name": "Aldric",
        "role": "Innkeeper",
        "lines": [
            "Rough crowd came through last night. Headed toward the smoke on the horizon.",
            "You'd best be careful out there."
        ],
        "requires_flag": ""       # empty = always visible; set to a story flag to gate
    },
    {
        "name": "Sable",
        "role": "Scout",
        "lines": ["The mirror chamber... I saw something there I can't explain."],
        "requires_flag": "mirror_complete"
    }
]
```

- `name` — character's name, shown as the speaker in `DialogueBox`
- `role` — their job/title, shown below name in the NPC list
- `lines` — array of strings; the DialogueBox displays them sequentially (one advance per line)
- `requires_flag` — optional; if set, NPC only appears when `GameState.has_flag(requires_flag)` is true

## Towns That Get NPCs

| Town node | Setting | Suggested NPC count | Notes |
|-----------|---------|---------------------|-------|
| `forest_village` | Rural inn | 2–3 | Villagers, innkeeper; hint at forest branch dangers |
| `crossroads_inn` | Waypoint inn | 2–3 | Travelers from different routes; foreshadow coast/cemetery/army |
| `gate_town` | City gate market | 2–3 | Merchants, guards; react to army battle outcome |
| `portal_shrine` | Mystical site | 1–2 | Hermit, pilgrim; lore about elemental threats |

## Writing Guide

- **Grounded in events**: NPCs should reference something that just happened or something ahead. An innkeeper at `forest_village` doesn't know about the coast battles yet — they talk about local rumors.
- **React to story flags**: After key battles, NPCs should update. Use `requires_flag` to show new lines after major story beats (e.g. a scout at `crossroads_inn` says nothing until `cave_complete`, then warns about the portal).
- **Keep it short**: 1–3 lines per NPC. Players are between battles; dialogue should feel like a quick overheard conversation, not an exposition dump.
- **Distinct voice per role**: Innkeeper = warm, cautious. Merchant = practical, self-interested. Scout = terse, observational. Guard = official, clipped.
- **Source material**: Check `EchoesOfChoice/Echoes of Choice/Program.cs` (town interludes between battles) and post-battle text in `*Battle.cs` files for lore details worth referencing.

## Implementation

### 1. Add NPCs to map_data.gd

Edit the town's node entry in `MapData.NODES`:

```gdscript
"forest_village": {
    "display_name": "Forest Village",
    "description": "...",
    "terrain": MapData.Terrain.FOREST,
    # ... other fields ...
    "npcs": [
        {"name": "Maret", "role": "Innkeeper", "lines": ["..."], "requires_flag": ""},
        {"name": "Aldric", "role": "Hunter",   "lines": ["..."], "requires_flag": ""}
    ]
}
```

### 2. Wire NPC list into Town.gd

In [Town.gd](../../../EchoesOfChoiceTactical/scenes/town/Town.gd):

- On `_ready()`, read `MapData.get_node(town_id).get("npcs", [])` and filter by `requires_flag`
- For each visible NPC, add a Button to the NPC list container (label = "Name — Role")
- On button press: instantiate `DialogueBox.tscn`, pass `[{"speaker": npc.name, "text": line} for line in npc.lines]`, await `dialogue_finished`

### 3. Story flag gating

Use `GameState.has_flag(flag_name)` (defined in [game_state.gd](../../../EchoesOfChoiceTactical/scripts/autoload/game_state.gd)) to filter NPCs. Set flags at the end of relevant battle post-dialogue.

## References

- [map_data.gd](../../../EchoesOfChoiceTactical/scripts/data/map_data.gd) — NODES structure
- [Town.gd](../../../EchoesOfChoiceTactical/scenes/town/Town.gd) — town UI to extend
- [game_state.gd](../../../EchoesOfChoiceTactical/scripts/autoload/game_state.gd) — `has_flag()`, `set_flag()`
- [DialogueBox.gd](../../../EchoesOfChoiceTactical/scenes/ui/DialogueBox.gd) — typewriter dialogue display, `dialogue_finished` signal
- [story-hooks](../story-hooks/SKILL.md) — writing tone and act structure
- C# source: `EchoesOfChoice/Echoes of Choice/Program.cs` — town interlude text
