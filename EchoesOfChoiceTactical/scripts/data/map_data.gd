class_name MapData

enum Terrain {
	CASTLE,
	CITY,
	FOREST,
	SMOKE,
	DEEP_FOREST,
	CLEARING,
	SHORE,
	RUINS,
	CAVE,
	BEACH,
	PORTAL,
	CIRCUS,
	CEMETERY,
	LAB,
	ARMY_CAMP,
	MIRROR,
	CITY_GATE,
	SHRINE,
	VILLAGE,
	INN,
}

# branch_group: when a node in this group is chosen, all OTHER nodes in the
# same group get locked. Empty string means no branch competition.
# prev_nodes: which node(s) must be completed before this one is available.

const NODES: Dictionary = {
	"castle": {
		"display_name": "The Castle",
		"description": "Home of the royal family. Your journey begins here. Beyond the gates, the city streets await—and not everyone there wishes you well.",
		"pos": Vector2(120, 360),
		"terrain": Terrain.CASTLE,
		"prev_nodes": [],
		"next_nodes": ["city_street"],
		"branch_group": "",
		"progression": -1,
		"is_battle": false,
		"gold_reward": 0,
	},
	"city_street": {
		"display_name": "City Streets",
		"description": "No sooner have you left the castle than a gang of thugs and their enforcer block your path. The road to the forest lies beyond them.",
		"pos": Vector2(280, 360),
		"terrain": Terrain.CITY,
		"prev_nodes": ["castle"],
		"next_nodes": ["forest"],
		"branch_group": "",
		"progression": 0,
		"is_battle": true,
		"gold_reward": 50,
	},
	"forest": {
		"display_name": "The Forest",
		"description": "A mother bear and her pack guard the forest path. Past them, a village at the forest's edge offers rest and rumors of what lies deeper.",
		"pos": Vector2(400, 360),
		"terrain": Terrain.FOREST,
		"prev_nodes": ["city_street"],
		"next_nodes": ["forest_village"],
		"branch_group": "",
		"progression": 1,
		"is_battle": true,
		"gold_reward": 75,
	},
	"forest_village": {
		"display_name": "Forest Village",
		"description": "A small settlement at the forest's edge. Villagers speak of a cave in the nearby hills for shelter, and of four paths into the wilds: smoldering ruins, the deep woods, a moonlit clearing, or ancient stonework where the dead stir.",
		"pos": Vector2(520, 360),
		"terrain": Terrain.VILLAGE,
		"prev_nodes": ["forest"],
		"next_nodes": ["smoke", "deep_forest", "clearing", "ruins"],
		"branch_group": "",
		"progression": 1,
		"is_battle": false,
		"gold_reward": 0,
	},

	# --- Progression 2: Four-way branch ---
	"smoke": {
		"display_name": "The Smoke",
		"description": "Smoldering embers and imps lurk in the haze. Beyond the smoke, a rift between worlds crackles—the portal leads toward the crossroads.",
		"pos": Vector2(660, 180),
		"terrain": Terrain.SMOKE,
		"prev_nodes": ["forest_village"],
		"next_nodes": ["portal"],
		"branch_group": "forest_branch",
		"progression": 2,
		"is_battle": true,
		"gold_reward": 100,
	},
	"deep_forest": {
		"display_name": "Deep Forest",
		"description": "A witch and her conjured spirits haunt the deep woods. The path through the woods leads to a cave in the hills—shelter, or a nest of wyrms.",
		"pos": Vector2(660, 300),
		"terrain": Terrain.DEEP_FOREST,
		"prev_nodes": ["forest_village"],
		"next_nodes": ["cave"],
		"branch_group": "forest_branch",
		"progression": 2,
		"is_battle": true,
		"gold_reward": 100,
	},
	"clearing": {
		"display_name": "The Clearing",
		"description": "Fae creatures gather in a moonlit glade. A storm rolls in—the party seeks shelter in the cave the villagers spoke of, but the fae have other ideas.",
		"pos": Vector2(660, 420),
		"terrain": Terrain.CLEARING,
		"prev_nodes": ["forest_village"],
		"next_nodes": ["cave"],
		"branch_group": "forest_branch",
		"progression": 2,
		"is_battle": true,
		"gold_reward": 100,
	},
	"ruins": {
		"display_name": "The Ruins",
		"description": "Shades cling to the crumbling stonework. Past the ruins, a rift between worlds awaits—the portal that leads to the crossroads.",
		"pos": Vector2(660, 540),
		"terrain": Terrain.RUINS,
		"prev_nodes": ["forest_village"],
		"next_nodes": ["portal"],
		"branch_group": "forest_branch",
		"progression": 2,
		"is_battle": true,
		"gold_reward": 100,
	},

	# --- Progression 3: Mid-game convergence ---
	"cave": {
		"display_name": "The Cave",
		"description": "Shelter from the storm—but fire and frost wyrmlings nest in the cavern depths. Beyond the cave, an inn at the crossroads offers the first true respite.",
		"pos": Vector2(820, 360),
		"terrain": Terrain.CAVE,
		"prev_nodes": ["deep_forest", "clearing"],
		"next_nodes": ["crossroads_inn"],
		"branch_group": "",
		"progression": 3,
		"is_battle": true,
		"gold_reward": 150,
	},
	"portal": {
		"display_name": "The Portal",
		"description": "A rift between worlds crackles with infernal energy. Survive the onslaught and the road leads to the crossroads inn.",
		"pos": Vector2(820, 260),
		"terrain": Terrain.PORTAL,
		"prev_nodes": ["smoke", "ruins"],
		"next_nodes": ["crossroads_inn"],
		"branch_group": "",
		"progression": 3,
		"is_battle": true,
		"gold_reward": 150,
	},
	"crossroads_inn": {
		"display_name": "Crossroads Inn",
		"description": "A weary inn at a mountain crossroads—the first safe haven since the forest village. Rest here; three roads lead out: the coast, the old cemetery where a carnival has set up, and the encampment at the lab.",
		"pos": Vector2(940, 310),
		"terrain": Terrain.INN,
		"prev_nodes": ["cave", "portal"],
		"next_nodes": ["shore", "cemetery_battle", "army_battle"],
		"branch_group": "",
		"progression": 3,
		"is_battle": false,
		"gold_reward": 0,
	},

	# --- Progression 4: Three paths (two battles each) ---
	"shore": {
		"display_name": "The Shore",
		"description": "The coast road. Salt hangs heavy in the air; sirens and pirates lurk by the water. Past them, the beach and a shipwreck await.",
		"pos": Vector2(1060, 520),
		"terrain": Terrain.SHORE,
		"prev_nodes": ["crossroads_inn"],
		"next_nodes": ["beach"],
		"branch_group": "post_inn",
		"progression": 4,
		"is_battle": true,
		"gold_reward": 150,
	},
	"beach": {
		"display_name": "The Beach",
		"description": "Past the sirens, the coast opens onto a beach. A shipwreck juts from the shallows—and a pirate crew drops down. Beyond the beach, the road converges at the Mirror.",
		"pos": Vector2(1180, 520),
		"terrain": Terrain.BEACH,
		"prev_nodes": ["shore"],
		"next_nodes": ["mirror_battle"],
		"branch_group": "",
		"progression": 4,
		"is_battle": true,
		"gold_reward": 200,
	},
	"box_battle": {
		"display_name": "The Carnival",
		"description": "Past the cemetery, the carnival. The ringmaster and his troupe put on a deadly show. Beyond the tents, the road converges at the Mirror—then Gate Town.",
		"pos": Vector2(1180, 360),
		"terrain": Terrain.CIRCUS,
		"prev_nodes": ["cemetery_battle"],
		"next_nodes": ["mirror_battle"],
		"branch_group": "",
		"progression": 4,
		"is_battle": true,
		"gold_reward": 200,
	},
	"cemetery_battle": {
		"display_name": "The Cemetery",
		"description": "The old cemetery—the dead refuse to stay buried. A carnival has set up nearby; past the graves, the carnival awaits. Then the road leads to the Mirror.",
		"pos": Vector2(1060, 360),
		"terrain": Terrain.CEMETERY,
		"prev_nodes": ["crossroads_inn"],
		"next_nodes": ["box_battle"],
		"branch_group": "post_inn",
		"progression": 4,
		"is_battle": true,
		"gold_reward": 200,
	},
	"lab_battle": {
		"display_name": "The Laboratory",
		"description": "Past the encampment, the laboratory. The head tinker and guards defend the workshop. Beyond the lab, the road leads to the Mirror—then Gate Town.",
		"pos": Vector2(1180, 230),
		"terrain": Terrain.LAB,
		"prev_nodes": ["army_battle"],
		"next_nodes": ["mirror_battle"],
		"branch_group": "",
		"progression": 4,
		"is_battle": true,
		"gold_reward": 200,
	},
	"army_battle": {
		"display_name": "The Encampment",
		"description": "An old army has set up an encampment at the lab. A commander marshals the forces. Past the encampment, the laboratory; past the lab, the Mirror and Gate Town.",
		"pos": Vector2(1060, 230),
		"terrain": Terrain.ARMY_CAMP,
		"prev_nodes": ["crossroads_inn"],
		"next_nodes": ["lab_battle"],
		"branch_group": "post_inn",
		"progression": 4,
		"is_battle": true,
		"gold_reward": 200,
	},

	# --- Progression 5: Mirror ---
	"mirror_battle": {
		"display_name": "The Mirror",
		"description": "All three roads converge here. Shadows and gloom stalk the crossing—face them, and the way leads to Gate Town, the last rest before the city gates.",
		"pos": Vector2(1220, 320),
		"terrain": Terrain.MIRROR,
		"prev_nodes": ["beach", "box_battle", "lab_battle"],
		"next_nodes": ["gate_town"],
		"branch_group": "",
		"progression": 5,
		"is_battle": true,
		"gold_reward": 250,
	},
	"gate_town": {
		"display_name": "Gate Town",
		"description": "The last settlement before the city gates. Rest and resupply before the final push. Four gates lead back to the city—each with its own defenders. Rumors speak of an assault at the gates.",
		"pos": Vector2(1300, 320),
		"terrain": Terrain.CITY,
		"prev_nodes": ["mirror_battle"],
		"next_nodes": ["return_city_1", "return_city_2", "return_city_3", "return_city_4"],
		"branch_group": "",
		"progression": 5,
		"is_battle": false,
		"gold_reward": 0,
	},

	# --- Progression 6: Return to City ---
	"return_city_1": {
		"display_name": "City — East Gate",
		"description": "A seraph and fiend clash at the eastern approach.",
		"pos": Vector2(1380, 200),
		"terrain": Terrain.CITY_GATE,
		"prev_nodes": ["gate_town"],
		"next_nodes": ["elemental_1"],
		"branch_group": "return_branch",
		"progression": 6,
		"is_battle": true,
		"gold_reward": 300,
	},
	"return_city_2": {
		"display_name": "City — North Gate",
		"description": "A druid and necromancer vie for control of the northern road.",
		"pos": Vector2(1380, 300),
		"terrain": Terrain.CITY_GATE,
		"prev_nodes": ["gate_town"],
		"next_nodes": ["elemental_2"],
		"branch_group": "return_branch",
		"progression": 6,
		"is_battle": true,
		"gold_reward": 300,
	},
	"return_city_3": {
		"display_name": "City — West Gate",
		"description": "A psion and runewright guard the western passage.",
		"pos": Vector2(1380, 400),
		"terrain": Terrain.CITY_GATE,
		"prev_nodes": ["gate_town"],
		"next_nodes": ["elemental_3"],
		"branch_group": "return_branch",
		"progression": 6,
		"is_battle": true,
		"gold_reward": 300,
	},
	"return_city_4": {
		"display_name": "City — South Gate",
		"description": "A shaman and warlock hold the southern bridge.",
		"pos": Vector2(1380, 500),
		"terrain": Terrain.CITY_GATE,
		"prev_nodes": ["gate_town"],
		"next_nodes": ["elemental_4"],
		"branch_group": "return_branch",
		"progression": 6,
		"is_battle": true,
		"gold_reward": 300,
	},

	# --- Progression 7: Final Elemental Battles ---
	"elemental_1": {
		"display_name": "Shrine of Storms",
		"description": "Air, water, and fire elementals converge in a final assault.",
		"pos": Vector2(1540, 200),
		"terrain": Terrain.SHRINE,
		"prev_nodes": ["return_city_1"],
		"next_nodes": [],
		"branch_group": "",
		"progression": 7,
		"is_battle": true,
		"gold_reward": 400,
	},
	"elemental_2": {
		"display_name": "Shrine of Tides",
		"description": "Water and fire elementals rise from the deep.",
		"pos": Vector2(1540, 300),
		"terrain": Terrain.SHRINE,
		"prev_nodes": ["return_city_2"],
		"next_nodes": [],
		"branch_group": "",
		"progression": 7,
		"is_battle": true,
		"gold_reward": 400,
	},
	"elemental_3": {
		"display_name": "Shrine of Winds",
		"description": "Air and water elementals swirl in a vortex.",
		"pos": Vector2(1540, 400),
		"terrain": Terrain.SHRINE,
		"prev_nodes": ["return_city_3"],
		"next_nodes": [],
		"branch_group": "",
		"progression": 7,
		"is_battle": true,
		"gold_reward": 400,
	},
	"elemental_4": {
		"display_name": "Shrine of Flames",
		"description": "Air and fire elementals blaze with fury.",
		"pos": Vector2(1540, 500),
		"terrain": Terrain.SHRINE,
		"prev_nodes": ["return_city_4"],
		"next_nodes": [],
		"branch_group": "",
		"progression": 7,
		"is_battle": true,
		"gold_reward": 400,
	},
}


static func get_node(node_id: String) -> Dictionary:
	return NODES.get(node_id, {})


static func get_branch_siblings(node_id: String) -> Array[String]:
	var node: Dictionary = NODES.get(node_id, {})
	var group: String = node.get("branch_group", "")
	if group.is_empty():
		return []
	var siblings: Array[String] = []
	for nid in NODES:
		if nid != node_id and NODES[nid].get("branch_group", "") == group:
			var shares_prev := false
			for prev in node.get("prev_nodes", []):
				if prev in NODES[nid].get("prev_nodes", []):
					shares_prev = true
					break
			if shares_prev:
				siblings.append(nid)
	return siblings


static func is_node_available(node_id: String) -> bool:
	if GameState.is_battle_completed(node_id):
		return false
	if GameState.is_node_locked(node_id):
		return false
	var node: Dictionary = NODES.get(node_id, {})
	var prev_nodes: Array = node.get("prev_nodes", [])
	if prev_nodes.is_empty():
		return true
	for prev_id in prev_nodes:
		if GameState.is_battle_completed(prev_id):
			return true
		if not NODES[prev_id].get("is_battle", true):
			if is_node_available(prev_id) or GameState.is_battle_completed(prev_id):
				return true
	return false


static func is_node_revealed(node_id: String) -> bool:
	if GameState.is_battle_completed(node_id):
		return true
	return is_node_available(node_id)


static func get_all_revealed_nodes() -> Array[String]:
	var revealed: Array[String] = []
	for nid in NODES:
		if is_node_revealed(nid):
			revealed.append(nid)
	return revealed
