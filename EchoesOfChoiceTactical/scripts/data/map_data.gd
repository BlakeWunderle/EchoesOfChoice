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
	},
	"forest": {
		"display_name": "The Forest",
		"description": "A wild bear and her cub block the forest path.",
		"pos": Vector2(440, 360),
		"terrain": Terrain.FOREST,
		"prev_nodes": ["city_street"],
		"next_nodes": ["smoke", "deep_forest", "clearing", "shore", "ruins"],
		"branch_group": "",
		"progression": 1,
		"is_battle": true,
	},

	# --- Progression 2: Five-way branch ---
	"smoke": {
		"display_name": "The Smoke",
		"description": "Smoldering embers and imps lurk in the haze.",
		"pos": Vector2(620, 160),
		"terrain": Terrain.SMOKE,
		"prev_nodes": ["forest"],
		"next_nodes": ["portal"],
		"branch_group": "forest_branch",
		"progression": 2,
		"is_battle": true,
	},
	"deep_forest": {
		"display_name": "Deep Forest",
		"description": "A witch and her conjured spirits haunt the deep woods.",
		"pos": Vector2(620, 260),
		"terrain": Terrain.DEEP_FOREST,
		"prev_nodes": ["forest"],
		"next_nodes": ["cave"],
		"branch_group": "forest_branch",
		"progression": 2,
		"is_battle": true,
	},
	"clearing": {
		"display_name": "The Clearing",
		"description": "Fae creatures gather in a moonlit glade.",
		"pos": Vector2(620, 360),
		"terrain": Terrain.CLEARING,
		"prev_nodes": ["forest"],
		"next_nodes": ["cave"],
		"branch_group": "forest_branch",
		"progression": 2,
		"is_battle": true,
	},
	"shore": {
		"display_name": "The Shore",
		"description": "Sirens sing from the rocky coastline.",
		"pos": Vector2(620, 460),
		"terrain": Terrain.SHORE,
		"prev_nodes": ["forest"],
		"next_nodes": ["beach"],
		"branch_group": "forest_branch",
		"progression": 2,
		"is_battle": true,
	},
	"ruins": {
		"display_name": "The Ruins",
		"description": "Shades cling to the crumbling stonework.",
		"pos": Vector2(620, 560),
		"terrain": Terrain.RUINS,
		"prev_nodes": ["forest"],
		"next_nodes": ["portal"],
		"branch_group": "forest_branch",
		"progression": 2,
		"is_battle": true,
	},

	# --- Progression 3: Mid-game convergence ---
	"cave": {
		"display_name": "The Cave",
		"description": "Fire and frost wyrmlings nest in the cavern depths.",
		"pos": Vector2(800, 310),
		"terrain": Terrain.CAVE,
		"prev_nodes": ["deep_forest", "clearing"],
		"next_nodes": ["box_battle", "lab_battle"],
		"branch_group": "",
		"progression": 3,
		"is_battle": true,
	},
	"beach": {
		"display_name": "The Beach",
		"description": "A pirate captain and his crew have made camp on the sand.",
		"pos": Vector2(800, 460),
		"terrain": Terrain.BEACH,
		"prev_nodes": ["shore"],
		"next_nodes": ["box_battle", "cemetery_battle"],
		"branch_group": "",
		"progression": 3,
		"is_battle": true,
	},
	"portal": {
		"display_name": "The Portal",
		"description": "A rift between worlds crackles with infernal energy.",
		"pos": Vector2(800, 200),
		"terrain": Terrain.PORTAL,
		"prev_nodes": ["smoke", "ruins"],
		"next_nodes": ["lab_battle", "army_battle"],
		"branch_group": "",
		"progression": 3,
		"is_battle": true,
	},

	# --- Progression 4: Pre-mirror ---
	"box_battle": {
		"display_name": "The Carnival",
		"description": "A harlequin, chanteuse, and ringmaster put on a deadly show.",
		"pos": Vector2(960, 360),
		"terrain": Terrain.CIRCUS,
		"prev_nodes": ["cave", "beach"],
		"next_nodes": ["mirror_battle"],
		"branch_group": "pre_mirror",
		"progression": 4,
		"is_battle": true,
	},
	"cemetery_battle": {
		"display_name": "The Cemetery",
		"description": "The dead refuse to stay buried.",
		"pos": Vector2(960, 500),
		"terrain": Terrain.CEMETERY,
		"prev_nodes": ["beach"],
		"next_nodes": ["mirror_battle"],
		"branch_group": "pre_mirror",
		"progression": 4,
		"is_battle": true,
	},
	"lab_battle": {
		"display_name": "The Laboratory",
		"description": "Automatons and their creators defend the workshop.",
		"pos": Vector2(960, 230),
		"terrain": Terrain.LAB,
		"prev_nodes": ["cave", "portal"],
		"next_nodes": ["mirror_battle"],
		"branch_group": "pre_mirror",
		"progression": 4,
		"is_battle": true,
	},
	"army_battle": {
		"display_name": "The Encampment",
		"description": "A military commander marshals draconian forces.",
		"pos": Vector2(960, 120),
		"terrain": Terrain.ARMY_CAMP,
		"prev_nodes": ["portal"],
		"next_nodes": ["mirror_battle"],
		"branch_group": "pre_mirror",
		"progression": 4,
		"is_battle": true,
	},

	# --- Progression 5: Mirror ---
	"mirror_battle": {
		"display_name": "The Mirror",
		"description": "Face the shadow of your own party.",
		"pos": Vector2(1120, 320),
		"terrain": Terrain.MIRROR,
		"prev_nodes": ["box_battle", "cemetery_battle", "lab_battle", "army_battle"],
		"next_nodes": ["return_city_1", "return_city_2", "return_city_3", "return_city_4"],
		"branch_group": "",
		"progression": 5,
		"is_battle": true,
	},

	# --- Progression 6: Return to City ---
	"return_city_1": {
		"display_name": "City — East Gate",
		"description": "A seraph and fiend clash at the eastern approach.",
		"pos": Vector2(1280, 200),
		"terrain": Terrain.CITY_GATE,
		"prev_nodes": ["mirror_battle"],
		"next_nodes": ["elemental_1"],
		"branch_group": "return_branch",
		"progression": 6,
		"is_battle": true,
	},
	"return_city_2": {
		"display_name": "City — North Gate",
		"description": "A druid and necromancer vie for control of the northern road.",
		"pos": Vector2(1280, 300),
		"terrain": Terrain.CITY_GATE,
		"prev_nodes": ["mirror_battle"],
		"next_nodes": ["elemental_2"],
		"branch_group": "return_branch",
		"progression": 6,
		"is_battle": true,
	},
	"return_city_3": {
		"display_name": "City — West Gate",
		"description": "A psion and runewright guard the western passage.",
		"pos": Vector2(1280, 400),
		"terrain": Terrain.CITY_GATE,
		"prev_nodes": ["mirror_battle"],
		"next_nodes": ["elemental_3"],
		"branch_group": "return_branch",
		"progression": 6,
		"is_battle": true,
	},
	"return_city_4": {
		"display_name": "City — South Gate",
		"description": "A shaman and warlock hold the southern bridge.",
		"pos": Vector2(1280, 500),
		"terrain": Terrain.CITY_GATE,
		"prev_nodes": ["mirror_battle"],
		"next_nodes": ["elemental_4"],
		"branch_group": "return_branch",
		"progression": 6,
		"is_battle": true,
	},

	# --- Progression 7: Final Elemental Battles ---
	"elemental_1": {
		"display_name": "Shrine of Storms",
		"description": "Air, water, and fire elementals converge in a final assault.",
		"pos": Vector2(1440, 200),
		"terrain": Terrain.SHRINE,
		"prev_nodes": ["return_city_1"],
		"next_nodes": [],
		"branch_group": "",
		"progression": 7,
		"is_battle": true,
	},
	"elemental_2": {
		"display_name": "Shrine of Tides",
		"description": "Water and fire elementals rise from the deep.",
		"pos": Vector2(1440, 300),
		"terrain": Terrain.SHRINE,
		"prev_nodes": ["return_city_2"],
		"next_nodes": [],
		"branch_group": "",
		"progression": 7,
		"is_battle": true,
	},
	"elemental_3": {
		"display_name": "Shrine of Winds",
		"description": "Air and water elementals swirl in a vortex.",
		"pos": Vector2(1440, 400),
		"terrain": Terrain.SHRINE,
		"prev_nodes": ["return_city_3"],
		"next_nodes": [],
		"branch_group": "",
		"progression": 7,
		"is_battle": true,
	},
	"elemental_4": {
		"display_name": "Shrine of Flames",
		"description": "Air and fire elementals blaze with fury.",
		"pos": Vector2(1440, 500),
		"terrain": Terrain.SHRINE,
		"prev_nodes": ["return_city_4"],
		"next_nodes": [],
		"branch_group": "",
		"progression": 7,
		"is_battle": true,
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
