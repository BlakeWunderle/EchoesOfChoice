---
name: travel-events
description: Add random travel events to the overworld map in EchoesOfChoiceTactical. Use when designing or implementing events that fire between nodes — ambushes, merchants, rest stops, story beats, and rumors — to make the world feel alive between battles.
---

# Travel Events

Use this skill when adding events that can trigger on the overworld map as the player moves between nodes. Travel events add texture and surprise to the journey, making the space between battles feel meaningful rather than just a loading screen.

## Event Types

| Type | What happens | Uses |
|------|-------------|------|
| `ambush` | A small surprise battle loads | `BattleMap` with a lightweight config |
| `merchant` | A traveling vendor appears | `ShopUI` with limited random stock |
| `rest` | Party recovers partial HP/MP | Stat restore + 1–2 lines of flavour text |
| `story` | Dialogue-only scene | `DialogueBox` → advances a story flag |
| `rumor` | A character shares intel | `DialogueBox` → reveals a locked node or hints at enemy type |

## Data Structure

**Resource class:** `TravelEvent` (in [travel_event.gd](../../../EchoesOfChoiceTactical/scripts/data/travel_event.gd))

```gdscript
class_name TravelEvent
extends Resource

@export var event_type: String = "story"       # ambush / merchant / rest / story / rumor
@export var title: String = ""                  # short label shown in the popup header
@export var dialogue: Array[Dictionary] = []    # [{speaker, text}, ...] — shown via DialogueBox
@export var trigger_chance: float = 0.25        # 0.0–1.0; roll on each node transition
@export var node_range: Array[String] = []      # battle/town IDs where this event can fire
                                                # empty = fires anywhere
@export var battle_id: String = ""              # for ambush type: which config to load
@export var rest_hp_pct: float = 0.25          # for rest type: fraction of max HP restored
@export var rest_mp_pct: float = 0.25          # for rest type: fraction of max MP restored
@export var reveals_node: String = ""           # for rumor type: node ID to unlock
```

## Balance Rules

- **Max 1 event per node transition** — once an event fires on a transition, no second roll that trip.
- **Ambush cap**: `trigger_chance` for `ambush` events should never exceed **0.20** (20%).
- **No repeats on backtrack**: Store the last node the player traveled from; skip rolling if they're retracing the same edge.
- **Cooldown**: After any event fires, skip the next transition's roll entirely (prevents event spam).
- **Node range**: Use `node_range` to keep events contextually appropriate — a pirate merchant shouldn't appear near the ruins.

## Writing Travel Dialogue

- **Story/rumor**: 1–3 lines. A named traveler, scout, or mysterious figure. Reference something in the world — a battle just completed, an enemy type ahead.
- **Rest**: 1 line of description ("You find a sheltered clearing and make camp briefly.") — no speaker needed.
- **Merchant**: No dialogue needed; the ShopUI opens directly with a short header ("A merchant flags you down from the roadside.").
- **Ambush**: 1–2 pre-battle lines via `dialogue` before the battle loads ("Someone's been following us since the village...").

## Implementation

### 1. Create travel_event.gd

New file: `EchoesOfChoiceTactical/scripts/data/travel_event.gd`

Define the `TravelEvent` resource class with the fields above.

### 2. Create TravelEvent scene

New scene: `EchoesOfChoiceTactical/scenes/story/TravelEvent.tscn` + `TravelEvent.gd`

The scene is a simple popup with:
- A header label (event `title`)
- A `DialogueBox` child (for story/rumor/ambush pre-text)
- A "Continue" button that emits `event_handled` signal

Script logic by type:
- `story` / `rumor`: show dialogue, emit signal on finish; set story flag or reveal node in `GameState`
- `rest`: show one-liner, restore HP/MP via `GameState` party data, emit signal
- `merchant`: show header, then load `ShopUI` as a sub-scene; emit signal when shop closes
- `ambush`: show pre-battle dialogue, then call `SceneManager.go_to_battle(battle_id)`

### 3. Wire into OverworldMap.gd

In [OverworldMap.gd](../../../EchoesOfChoiceTactical/scenes/overworld/OverworldMap.gd), on node confirmed (before scene switch):

```gdscript
func _on_node_confirmed(node_id: String) -> void:
    var event = _roll_travel_event(node_id)
    if event:
        var popup = TRAVEL_EVENT_SCENE.instantiate()
        popup.setup(event)
        add_child(popup)
        await popup.event_handled
        popup.queue_free()
    SceneManager.go_to_node(node_id)

func _roll_travel_event(node_id: String) -> TravelEvent:
    if _last_event_fired:          # cooldown — skip after any event
        _last_event_fired = false
        return null
    if node_id == _last_travel_from:   # no backtrack repeats
        return null
    for event in _travel_events:
        if event.node_range.is_empty() or node_id in event.node_range:
            if randf() < event.trigger_chance:
                _last_event_fired = true
                return event
    return null
```

Store `_last_travel_from` and `_last_event_fired` as member vars in `OverworldMap.gd`.

### 4. Define event instances

Create event instances as constants or a preloaded array in `OverworldMap.gd` (or as `.tres` resources under `resources/travel_events/`). Start with 4–6 events covering the main arcs:

| Event | Type | node_range | chance |
|-------|------|-----------|--------|
| "Roadside Ambush" | ambush | forest, smoke, deep_forest | 0.15 |
| "Traveling Merchant" | merchant | (anywhere) | 0.20 |
| "Sheltered Rest" | rest | clearing, cave, ruins | 0.25 |
| "Survivor's Warning" | story | shore, beach, cemetery | 0.20 |
| "Smuggler's Rumor" | rumor | crossroads_inn → post_inn | 0.30 |

## References

- [travel_event.gd](../../../EchoesOfChoiceTactical/scripts/data/travel_event.gd) — resource class (to be created)
- [OverworldMap.gd](../../../EchoesOfChoiceTactical/scenes/overworld/OverworldMap.gd) — add event roll logic
- [game_state.gd](../../../EchoesOfChoiceTactical/scripts/autoload/game_state.gd) — `has_flag()`, `set_flag()`, party HP/MP
- [scene_manager.gd](../../../EchoesOfChoiceTactical/scripts/autoload/scene_manager.gd) — `go_to_battle()`, `go_to_node()`
- [DialogueBox.gd](../../../EchoesOfChoiceTactical/scenes/ui/DialogueBox.gd) — dialogue display
- [ShopUI.gd](../../../EchoesOfChoiceTactical/scenes/town/ShopUI.gd) — reuse for merchant event
- [story-hooks](../story-hooks/SKILL.md) — writing tone, act structure, story flags
