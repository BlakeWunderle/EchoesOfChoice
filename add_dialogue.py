import re

filepath = r"c:/Users/blake/OneDrive/Documents/EchoesOfChoice/EchoesOfChoiceTactical/scripts/data/battle_config.gd"

with open(filepath, "r", encoding="utf-8") as f:
    content = f.read()

BATTLES = {
    "city_street": {
        "marker": '{"data": peddler, "name": "Hex Peddler", "pos": Vector2i(9, 1), "level": 1},\n\t]\n\treturn config',
        "pre": [
            ("", "The city streets are quiet tonight. Too quiet."),
            ("Aldric", "Eyes up. Someone has been watching us since we left the gates."),
            ("", "A gang steps out of the shadows and blocks the road to the forest."),
        ],
        "post": [
            ("Lyris", "Well. Adventure started sooner than expected."),
            ("Aldric", "Keep moving. Whatever is stirring out there is worse than street thugs."),
        ],
    },
    "forest": {
        "marker": '{"data": boar, "name": "Wild Boar", "pos": Vector2i(9, 2), "level": 1},\n\t]\n\treturn config',
        "pre": [
            ("", "The party makes camp in the forest. No one thinks to hang the food."),
            ("Elara", "Something large is moving toward us."),
            ("", "A mother bear and her pack emerge from the tree line."),
        ],
        "post": [
            ("Thane", "An old house, just off the path. Unlocked."),
            ("", "Inside, each chest holds relics of a past adventurer, waiting for someone who needs them."),
        ],
    },
    "village_raid": {
        "marker": '{"data": hobgob, "name": "Hobgoblin Chief", "pos": Vector2i(9, 3), "level": 1},\n\t]\n\treturn config',
        "pre": [
            ("", "The forest village is under attack. Goblins have broken through the fence line."),
            ("Villager", "Please, drive them off! They are taking everything!"),
        ],
        "post": [
            ("", "The goblins scatter. The village catches its breath."),
            ("Aldric", "They were organized. Someone sent them."),
        ],
    },
    "smoke": {
        "marker": '{"data": spirit, "name": "Ember", "pos": Vector2i(9, 3), "level": 2},\n\t]\n\treturn config',
        "pre": [
            ("", "The smoke was a smear on the horizon from the village. Up close it feeds on something big."),
            ("Lyris", "I hear cackling."),
            ("", "Three imps cluster around a growing fire, feeding it everything in reach."),
        ],
        "post": [
            ("", "The fire dies to embers. Behind where it burned brightest, a portal pulses with dark energy."),
            ("Elara", "Nowhere else to go. We step through."),
        ],
    },
    "deep_forest": {
        "marker": '{"data": sprite, "name": "Thorn", "pos": Vector2i(8, 4), "level": 2},\n\t]\n\treturn config',
        "pre": [
            ("", "The trees here are ancient, close-set, their canopy blocking the sky. The path narrows to a trail."),
            ("Thane", "A ritual circle. Fresh."),
            ("", "Lightning splits the sky. A cackle fills the air."),
        ],
        "post": [
            ("", "The witch falls. The forest goes still."),
            ("Aldric", "Storm is coming in fast. That cave mouth up the hill, we make for it."),
        ],
    },
    "clearing": {
        "marker": '{"data": satyr, "name": "Sylvan", "pos": Vector2i(13, 4), "level": 2},\n\t]\n\treturn config',
        "pre": [
            ("", "Music drifts from the clearing. Catchy. A little too catchy."),
            ("Lyris", "My feet are moving on their own. That is not good."),
            ("", "Chains of light snap around the party's wrists. The performers' smiles stretch too wide."),
        ],
        "post": [
            ("", "The enchantment shatters. The clearing flickers and fades like a candle going out."),
            ("", "A path leads downhill into the rocks and a cave mouth, half-hidden by vines."),
        ],
    },
    "ruins": {
        "marker": '{"data": sentry, "name": "Bone Sentry", "pos": Vector2i(11, 2), "level": 2},\n\t]\n\treturn config',
        "pre": [
            ("", "The ruins glow faintly from inside. Every breath comes out as mist."),
            ("Elara", "Shades. The old stonework is full of them."),
        ],
        "post": [
            ("", "The last shade dissolves. The glow at the ruins heart intensifies — a portal, pulsing."),
        ],
    },
    "cave": {
        "marker": '{"data": frost_wyrm, "name": "Sythara", "pos": Vector2i(7, 4), "level": 3},\n\t]\n\treturn config',
        "pre": [
            ("", "Gold everywhere. Coins, goblets, jewels heaped in glittering mounds."),
            ("Thane", "Something very large lives here. These are not decorative, they are a hoard."),
            ("", "A shadow stretches across the walls. A deep voice rumbles a warning."),
        ],
        "post": [
            ("", "Silence. Just the sound of coins sliding off the fallen beasts."),
            ("Elara", "Two wyrmlings. Old ones. They do not nest near nothing — something darker stirred them here."),
        ],
    },
    "portal": {
        "marker": '{"data": hellion, "name": "Purson", "pos": Vector2i(9, 5), "level": 3},\n\t]\n\treturn config',
        "pre": [
            ("", "The rift crackles with infernal energy. Whatever is on the other side wants through."),
            ("Aldric", "Hold the line."),
        ],
        "post": [
            ("", "The last hellion falls. The rift seals shut, but not before something slips through the cracks."),
            ("Thane", "The crossroads cannot be far. We need to regroup."),
        ],
    },
    "inn_ambush": {
        "marker": '{"data": stalker, "name": "Gloom Stalker", "pos": Vector2i(9, 4), "level": 3},\n\t]\n\treturn config',
        "pre": [
            ("", "The inn goes quiet the wrong way. Shadows peel away from the walls."),
            ("Lyris", "We were followed."),
        ],
        "post": [
            ("", "The creatures dissolve into nothing. Whoever sent them knows exactly where you are."),
        ],
    },
    "shore": {
        "marker": '{"data": siren, "name": "Lorelei", "pos": Vector2i(9, 3), "level": lvl},\n\t]\n\treturn config',
        "pre": [
            ("", "Salt hangs heavy in the air. The coast road is beautiful — and something beneath the waves is watching."),
            ("", "Sirens break the surface, their song cutting through the sound of the waves."),
        ],
        "post": [
            ("", "The last siren slips beneath the water. The coast opens ahead."),
            ("Aldric", "The beach. And something on the horizon — a shipwreck."),
        ],
    },
    "beach": {
        "marker": '{"data": kraken, "name": "Abyssal", "pos": Vector2i(9, 3), "level": lvl},\n\t]\n\treturn config',
        "pre": [
            ("", "A shipwreck juts from the shallows. Too intact to have washed in naturally."),
            ("Lyris", "Figures dropping from the rigging. That is a crew."),
        ],
        "post": [
            ("", "The pirates scatter. The coast road converges ahead — a crossing where all three paths meet."),
        ],
    },
    "cemetery_battle": {
        "marker": '{"data": wraith, "name": "Joris", "pos": Vector2i(9, 3), "level": lvl},\n\t]\n\treturn config',
        "pre": [
            ("", "The old cemetery. Headstones lean at wrong angles, names worn away by rain."),
            ("Elara", "The dead here... they are not resting."),
        ],
        "post": [
            ("", "The last revenant crumbles. Beyond the cemetery wall, lantern light from a carnival tent sways in the wind."),
        ],
    },
    "box_battle": {
        "marker": '{"data": ringmaster, "name": "Gaspard", "pos": Vector2i(9, 3), "level": lvl},\n\t]\n\treturn config',
        "pre": [
            ("", "The carnival has set up between the cemetery and the road. Bright colors, loud music."),
            ("Thane", "The ringmaster is watching us. He knows we came through the cemetery."),
            ("Gaspard", "What a perfect addition to tonight's show."),
        ],
        "post": [
            ("", "The troupe collapses. The road beyond the tents converges with the others — the Mirror."),
        ],
    },
    "army_battle": {
        "marker": '{"data": commander, "name": "Varro", "pos": Vector2i(9, 3), "level": lvl},\n\t]\n\treturn config',
        "pre": [
            ("", "An encampment blocks the road. Organized — tents in rows, a command post at center."),
            ("Varro", "This road is closed by order of the Commanders Guild. Turn back."),
            ("Aldric", "We are not turning back."),
        ],
        "post": [
            ("", "The commander falls. The encampment scatters. The laboratory beyond the tree line waits."),
        ],
    },
    "lab_battle": {
        "marker": '{"data": machinist, "name": "Cog", "pos": Vector2i(8, 4), "level": lvl},\n\t]\n\treturn config',
        "pre": [
            ("", "The laboratory. Clean lines and locked doors — and things inside that move without being alive."),
            ("Thane", "Androids. Machinists. Someone built this place for a purpose."),
            ("Deus", "Unauthorized personnel detected. Engaging."),
        ],
        "post": [
            ("", "The constructs power down. The lab is quiet — but its records speak of something the encampment was protecting."),
            ("Elara", "The Mirror crossing is ahead. All three roads meet there."),
        ],
    },
    "mirror_battle": {
        "marker": '{"data": stalker, "name": "Tenebris", "pos": Vector2i(13, 4), "level": lvl},\n\t]\n\treturn config',
        "pre": [
            ("", "All three roads converge at a dark crossing. Shadows move in the space between the lights."),
            ("Lyris", "Those shadows have our shapes."),
        ],
        "post": [
            ("", "The shadow-selves dissolve. The crossing clears."),
            ("Aldric", "Gate Town is ahead. Last chance to rest before we take the city gates."),
        ],
    },
    "gate_ambush": {
        "marker": '{"data": prowler, "name": "Shadow at the Gate", "pos": Vector2i(9, 4), "level": 5},\n\t]\n\treturn config',
        "pre": [
            ("", "Gate Town's outer road. Someone knew you were coming."),
            ("", "Night prowlers drop from the rooftops."),
        ],
        "post": [
            ("", "The last of them flees. Gate Town is secure — for now."),
        ],
    },
    "return_city_1": {
        "marker": '{"data": entertainer, "name": "East Gate Sentinel", "pos": Vector2i(9, 4), "level": 6},\n\t]\n\treturn config',
        "pre": [
            ("", "The eastern approach. Light and dark clash in the streets ahead."),
            ("Aldric", "Push through. We take the gate."),
        ],
        "post": [
            ("", "The gate falls. The road to the shrine opens."),
        ],
    },
    "return_city_2": {
        "marker": '{"data": prowler, "name": "Shadow at North Gate", "pos": Vector2i(9, 4), "level": 6},\n\t]\n\treturn config',
        "pre": [
            ("", "The northern road. Druids and necromancers vie for control of the approach."),
            ("Thane", "They are using the ley lines beneath the street. This is planned."),
        ],
        "post": [
            ("", "The north road is clear. The shrine ahead."),
        ],
    },
    "return_city_3": {
        "marker": '{"data": goblin, "name": "Gate Scout", "pos": Vector2i(9, 4), "level": 6},\n\t]\n\treturn config',
        "pre": [
            ("", "The western passage. Street toughs and shadow-workers block the way."),
            ("Lyris", "More of them than I would like."),
        ],
        "post": [
            ("", "West gate is ours."),
        ],
    },
    "return_city_4": {
        "marker": '{"data": stalker, "name": "Gloom Keeper", "pos": Vector2i(9, 4), "level": 6},\n\t]\n\treturn config',
        "pre": [
            ("", "The southern bridge. A shaman and warlock hold either end."),
            ("Elara", "Coordinated attack. They are expecting us."),
        ],
        "post": [
            ("", "The bridge is clear. The last shrine awaits."),
        ],
    },
}

ELEMENTAL = {
    "elemental_1": {
        "pre": [
            ("", "The Shrine of Storms. Air, water, and fire called here by something that wants the city to burn."),
            ("Elara", "Three at once. We have faced worse. Have we not?"),
        ],
        "post": [
            ("", "The elementals disperse. The shrine goes dark. Whatever called them here is gone."),
            ("Aldric", "It is over. We made it."),
        ],
    },
    "elemental_2": {
        "pre": [
            ("", "The Shrine of Tides. The water rises — something vast stirs beneath."),
            ("Thane", "Fire and water. Opposing forces turned against the city. Intentional."),
        ],
        "post": [
            ("", "The tides recede. The shrine falls silent."),
            ("", "Every choice made along the way echoes here, in this stillness."),
        ],
    },
    "elemental_3": {
        "pre": [
            ("", "The Shrine of Winds. A vortex of air and water fills the chamber."),
            ("Lyris", "We are in the eye of it. No retreating now."),
        ],
        "post": [
            ("", "The vortex dies. The city breathes again."),
        ],
    },
    "elemental_4": {
        "pre": [
            ("", "The Shrine of Flames. Air and fire converge in a blaze that should be impossible to survive."),
            ("Aldric", "If this is how it ends, it ends fighting."),
        ],
        "post": [
            ("", "The flames gutter out. Silence falls across the city."),
            ("", "The darkness has been vanquished. Every choice left an echo — and yours will ring through the ages."),
        ],
    },
}


def fmt_entry(speaker, text):
    return f'\t\t{{"speaker": "{speaker}", "text": "{text}"}}'


def make_block(pre, post):
    pre_lines = ",\n".join(fmt_entry(s, t) for s, t in pre)
    post_lines = ",\n".join(fmt_entry(s, t) for s, t in post)
    return (
        "\n\tconfig.pre_battle_dialogue = [\n"
        + pre_lines + "\n\t]\n"
        + "\tconfig.post_battle_dialogue = [\n"
        + post_lines + "\n\t]\n"
    )


for battle_id, data in BATTLES.items():
    marker = data["marker"]
    tail = "\treturn config"
    block = make_block(data["pre"], data["post"])
    replacement = marker[: -len("return config")] + block + tail
    if marker in content:
        content = content.replace(marker, replacement, 1)
        print(f"OK: {battle_id}")
    else:
        print(f"MISS: {battle_id}")

# Add elemental create_ functions before create_placeholder
elemental_funcs = "\n"
for bid, data in ELEMENTAL.items():
    block = make_block(data["pre"], data["post"])
    num = bid.split("_")[1]
    shrine_names = {"1": "Shrine of Storms", "2": "Shrine of Tides", "3": "Shrine of Winds", "4": "Shrine of Flames"}
    shrine = shrine_names[num]
    func = f"""
static func create_{bid}() -> BattleConfig:
\tvar config := BattleConfig.new()
\tconfig.battle_id = "{bid}"
\tconfig.grid_width = 12
\tconfig.grid_height = 10
\t_build_party_units(config)

\tvar node_data: Dictionary = MapData.get_node("{bid}")
\tvar progression: int = node_data.get("progression", 7)
\tvar lvl: int = maxi(1, progression)

\t# {shrine}: mix of elemental types
\tvar air_elem := load("res://resources/enemies/air_elemental.tres")
\tvar fire_elem := load("res://resources/enemies/fire_elemental.tres")
\tvar water_elem := load("res://resources/enemies/water_elemental.tres")
"""
    # Set up enemy units per shrine
    if bid == "elemental_1":
        func += """\tconfig.enemy_units = [
\t\t{"data": air_elem, "name": "Zephyr", "pos": Vector2i(10, 2), "level": lvl},
\t\t{"data": water_elem, "name": "Tide", "pos": Vector2i(10, 5), "level": lvl},
\t\t{"data": fire_elem, "name": "Inferno", "pos": Vector2i(10, 8), "level": lvl},
\t\t{"data": air_elem, "name": "Gale", "pos": Vector2i(11, 4), "level": lvl},
\t\t{"data": fire_elem, "name": "Pyre", "pos": Vector2i(11, 6), "level": lvl},
\t]
"""
    elif bid == "elemental_2":
        func += """\tconfig.enemy_units = [
\t\t{"data": water_elem, "name": "Deluge", "pos": Vector2i(10, 2), "level": lvl},
\t\t{"data": fire_elem, "name": "Scorch", "pos": Vector2i(10, 5), "level": lvl},
\t\t{"data": water_elem, "name": "Surge", "pos": Vector2i(10, 8), "level": lvl},
\t\t{"data": fire_elem, "name": "Ember Lord", "pos": Vector2i(11, 3), "level": lvl},
\t\t{"data": water_elem, "name": "Maelstrom", "pos": Vector2i(11, 7), "level": lvl},
\t]
"""
    elif bid == "elemental_3":
        func += """\tconfig.enemy_units = [
\t\t{"data": air_elem, "name": "Cyclone", "pos": Vector2i(10, 2), "level": lvl},
\t\t{"data": water_elem, "name": "Torrent", "pos": Vector2i(10, 5), "level": lvl},
\t\t{"data": air_elem, "name": "Squall", "pos": Vector2i(10, 8), "level": lvl},
\t\t{"data": water_elem, "name": "Riptide", "pos": Vector2i(11, 4), "level": lvl},
\t\t{"data": air_elem, "name": "Vortex", "pos": Vector2i(11, 6), "level": lvl},
\t]
"""
    else:  # elemental_4
        func += """\tconfig.enemy_units = [
\t\t{"data": air_elem, "name": "Tempest", "pos": Vector2i(10, 2), "level": lvl},
\t\t{"data": fire_elem, "name": "Blaze", "pos": Vector2i(10, 5), "level": lvl},
\t\t{"data": air_elem, "name": "Sirocco", "pos": Vector2i(10, 8), "level": lvl},
\t\t{"data": fire_elem, "name": "Conflagration", "pos": Vector2i(11, 3), "level": lvl},
\t\t{"data": air_elem, "name": "Whirlwind", "pos": Vector2i(11, 7), "level": lvl},
\t]
"""
    func += block + "\treturn config\n"
    elemental_funcs += func
    print(f"OK: {bid} (new function)")

# Insert elemental functions before create_placeholder
placeholder_marker = "\nstatic func create_placeholder"
content = content.replace(placeholder_marker, elemental_funcs + placeholder_marker, 1)

with open(filepath, "w", encoding="utf-8") as f:
    f.write(content)

print("Done.")
