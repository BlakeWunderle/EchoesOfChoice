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
		"description": "Home of the royal family. Your journey begins here.",
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
		"description": "Thugs roam the streets outside the castle walls.",
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
		"description": "A wild bear and her pack block the forest path.",
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
		"description": "A small settlement at the forest's edge. Villagers speak of a cave in the nearby hills.",
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
		"description": "Smoldering embers and imps lurk in the haze.",
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
		"description": "A witch and her conjured spirits haunt the deep woods.",
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
		"description": "Fae creatures gather in a moonlit glade. A storm drives the party toward the cave the villagers mentioned.",
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
		"description": "Shades cling to the crumbling stonework.",
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
		"description": "Fire and frost wyrmlings nest in the cavern depths.",
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
		"description": "A rift between worlds crackles with infernal energy.",
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
		"description": "A weary inn at a mountain crossroads. The first safe haven since the forest village. Three roads lead out: the coast, the old cemetery where a carnival has set up, and the encampment at the lab.",
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
		"description": "The coast road. Salt hangs heavy in the air. A strange singing drifts across the water.",
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
		"description": "Past the sirens, the coast opens onto a beach. A shipwreck juts from the shallows. A pirate crew drops down and the ambush begins.",
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
		"description": "Past the cemetery, the carnival. A harlequin, chanteuse, and ringmaster put on a deadly show.",
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
		"description": "The old cemetery. A carnival has set up nearby. The dead refuse to stay buried.",
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
		"description": "Past the encampment, the laboratory. Automatons and their creators defend the workshop.",
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
		"description": "An old army has set up an encampment at the lab. A military commander marshals draconian forces.",
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
		"description": "Face the shadow of your own party. Beyond it, the way leads back toward the city.",
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
		"description": "The last settlement before the city gates. Rest and resupply before the final push. Rumors of an assault at the gate.",
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
