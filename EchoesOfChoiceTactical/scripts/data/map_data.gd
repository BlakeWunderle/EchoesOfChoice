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
		"npcs": [
			{
				"name": "Maren",
				"role": "Innkeeper",
				"lines": [
					"The cave in the hills? Aye, it's there. Good shelter — unless the wyrmlings have already claimed it.",
					"Word from the east: there's a portal shrine along the smoke road. Old magic. Hard to say what's on the other side.",
				],
			},
			{
				"name": "Corvin",
				"role": "Scout",
				"lines": [
					"I followed tracks three hours into the deep wood before I turned back. Something big. Something old.",
					"Take the clearing path if you fancy dancing. The fae there put on quite a show — last party didn't make it offstage.",
				],
			},
			{
				"name": "Sela",
				"role": "Village Elder",
				"lines": [
					"Four paths out of here. Two lead to the cave, two lead to a portal. All of them lead somewhere dangerous.",
					"We defended this village when the goblins came. Make sure it meant something.",
				],
				"requires_flag": "village_defended",
			},
		],
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
		"npcs": [
			{
				"name": "Bram",
				"role": "Innkeeper",
				"lines": [
					"Three roads from here. The shore has sirens — beautiful, deadly. The cemetery is worse. The encampment is organized trouble.",
					"First safe bed since the forest village. Sleep well. The Mirror is ahead, and nothing is right past it.",
				],
			},
			{
				"name": "Lyra",
				"role": "Merchant",
				"lines": [
					"The army at the encampment is not random — they are guarding something at the laboratory. I have seen the supply lines.",
					"The carnival past the cemetery changes locations. Do not let the music in.",
				],
			},
			{
				"name": "Wyn",
				"role": "Weary Traveler",
				"lines": [
					"I came through the shore road. Lost two companions to the sirens. The beach past them is not much better — pirates waiting at the shipwreck.",
					"The Mirror is where the roads converge. Something lives in that crossing. I did not linger.",
				],
			},
		],
	},

	# --- Progression 4: Three paths (two battles each) ---
	"shore": {
		"display_name": "The Shore",
		"description": "The coast road. Salt hangs heavy in the air; sirens and their kind lurk by the water. Past them, the beach and a shipwreck await.",
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
		"display_name": "The Dark Carnival",
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
		"description": "Past the encampment, the laboratory. Androids and machinists defend the workshop; the ironclad holds the line. Beyond the lab, the road leads to the Mirror—then Gate Town.",
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
		"description": "The last settlement before the city gates. Rest and resupply before the final push. Four gates lead back to the city—each with its own defenders. Choose which gate to assault.",
		"pos": Vector2(1300, 320),
		"terrain": Terrain.CITY,
		"prev_nodes": ["mirror_battle"],
		"next_nodes": ["city_gate_ambush"],
		"branch_group": "",
		"progression": 5,
		"is_battle": false,
		"gold_reward": 0,
		"npcs": [
			{
				"name": "Donal",
				"role": "Gatekeeper",
				"lines": [
					"Four gates into the city. East has a seraph and a fiend clashing — you would be caught in the middle. North is druid versus necromancer. Pick your nightmare.",
					"Beyond the gates, the shrines are active. Elementals. The city has been sealed from the inside.",
				],
			},
			{
				"name": "Petra",
				"role": "Merchant",
				"lines": [
					"I have heard the elemental shrines stirring for weeks. Someone woke them deliberately.",
					"Supplies are short but I still have stock. Last chance before the walls.",
				],
			},
			{
				"name": "Holt",
				"role": "Soldier",
				"lines": [
					"The Mirror crossing — you made it through. Most do not come out the other side intact. What came through with you?",
					"We are the last settlement. Beyond Gate Town, you are on your own.",
				],
			},
		],
	},

	# --- Progression 6: City Gate Ambush (shared) ---
	"city_gate_ambush": {
		"display_name": "The City Gates",
		"description": "Shadow agents have taken position inside the city walls. The Watcher's Hand from the mirror crossing stands at their head — this time with a turned city warden at its side.",
		"pos": Vector2(1360, 320),
		"terrain": Terrain.CITY_GATE,
		"prev_nodes": ["gate_town"],
		"next_nodes": ["return_city_1", "return_city_2", "return_city_3", "return_city_4"],
		"branch_group": "",
		"progression": 6,
		"is_battle": true,
		"gold_reward": 300,
	},

	# --- Progression 6: Return to City ---
	"return_city_1": {
		"display_name": "City — The East Rampart",
		"description": "A divine warrior and a fire lord guard the eastern passage side by side — different powers, same orders.",
		"pos": Vector2(1380, 200),
		"terrain": Terrain.CITY_GATE,
		"prev_nodes": ["city_gate_ambush"],
		"next_nodes": ["elemental_1"],
		"branch_group": "return_branch",
		"progression": 6,
		"is_battle": true,
		"gold_reward": 300,
	},
	"return_city_2": {
		"display_name": "City — The Scholar Quarter",
		"description": "A necromancer and a witch have filled the scholar quarter streets with their workings — dead and nature, tangled together.",
		"pos": Vector2(1380, 300),
		"terrain": Terrain.CITY_GATE,
		"prev_nodes": ["city_gate_ambush"],
		"next_nodes": ["elemental_2"],
		"branch_group": "return_branch",
		"progression": 6,
		"is_battle": true,
		"gold_reward": 300,
	},
	"return_city_3": {
		"display_name": "City — The Forge District",
		"description": "Warding circles on every wall. A psion and a runewright have locked the forge district road down — mind and rune working in concert.",
		"pos": Vector2(1380, 400),
		"terrain": Terrain.CITY_GATE,
		"prev_nodes": ["city_gate_ambush"],
		"next_nodes": ["elemental_3"],
		"branch_group": "return_branch",
		"progression": 6,
		"is_battle": true,
		"gold_reward": 300,
	},
	"return_city_4": {
		"display_name": "City — The Temple Road",
		"description": "A warlock and a shaman hold the temple road crossing — pact and spirit, pulling in the same direction.",
		"pos": Vector2(1380, 500),
		"terrain": Terrain.CITY_GATE,
		"prev_nodes": ["city_gate_ambush"],
		"next_nodes": ["elemental_4"],
		"branch_group": "return_branch",
		"progression": 6,
		"is_battle": true,
		"gold_reward": 300,
	},

	# --- Progression 7: Final Elemental Battles ---
	"elemental_1": {
		"display_name": "Shrine of Flames",
		"description": "A fire elemental towers above the shrine — four lesser flames circle it. The air itself is burning.",
		"pos": Vector2(1540, 200),
		"terrain": Terrain.SHRINE,
		"prev_nodes": ["return_city_1"],
		"next_nodes": ["final_castle"],
		"branch_group": "",
		"progression": 7,
		"is_battle": true,
		"gold_reward": 400,
	},
	"elemental_2": {
		"display_name": "Shrine of Tides",
		"description": "The shrine floods with water. An immense elemental rises — four currents circle it.",
		"pos": Vector2(1540, 300),
		"terrain": Terrain.SHRINE,
		"prev_nodes": ["return_city_2"],
		"next_nodes": ["final_castle"],
		"branch_group": "",
		"progression": 7,
		"is_battle": true,
		"gold_reward": 400,
	},
	"elemental_3": {
		"display_name": "Shrine of Winds",
		"description": "A vortex fills the shrine chamber. The lead elemental is at its center — four lesser winds orbit in a tightening spiral.",
		"pos": Vector2(1540, 400),
		"terrain": Terrain.SHRINE,
		"prev_nodes": ["return_city_3"],
		"next_nodes": ["final_castle"],
		"branch_group": "",
		"progression": 7,
		"is_battle": true,
		"gold_reward": 400,
	},
	"elemental_4": {
		"display_name": "Shrine of Stone",
		"description": "The temple floor has split open. An earth elemental rose from below — and four lesser forms with it.",
		"pos": Vector2(1540, 500),
		"terrain": Terrain.SHRINE,
		"prev_nodes": ["return_city_4"],
		"next_nodes": ["final_castle"],
		"branch_group": "",
		"progression": 7,
		"is_battle": true,
		"gold_reward": 400,
	},

	# --- Finale: Return to the Castle ---
	"final_castle": {
		"display_name": "The Castle — Finale",
		"description": "The party returns to where it all began. The Stranger stands at the throne room door, hood down at last.",
		"pos": Vector2(120, 360),
		"terrain": Terrain.CASTLE,
		"prev_nodes": ["elemental_1", "elemental_2", "elemental_3", "elemental_4"],
		"next_nodes": [],
		"branch_group": "",
		"progression": 8,
		"is_battle": true,
		"gold_reward": 600,
	},

	# --- Optional battle data (launched from towns; not shown on overworld) ---
	"village_raid": {
		"display_name": "Village Raid",
		"description": "Defend the village from goblins.",
		"pos": Vector2.ZERO,
		"terrain": Terrain.VILLAGE,
		"prev_nodes": [],
		"next_nodes": [],
		"branch_group": "",
		"progression": -1,
		"is_battle": true,
		"gold_reward": 75,
		"reward_choices": ["village_charm", "raiders_bracer", "scouts_hood"],
	},
	"inn_ambush": {
		"display_name": "Inn Ambush",
		"description": "Fight off the night ambush at the inn.",
		"pos": Vector2.ZERO,
		"terrain": Terrain.INN,
		"prev_nodes": [],
		"next_nodes": [],
		"branch_group": "",
		"progression": -1,
		"is_battle": true,
		"gold_reward": 100,
		"reward_choices": ["shadow_sigil", "duelist_signet", "scholars_brooch"],
	},
	"gate_ambush": {
		"display_name": "Gate Ambush",
		"description": "Defend the gate against the final assault.",
		"pos": Vector2.ZERO,
		"terrain": Terrain.CITY_GATE,
		"prev_nodes": [],
		"next_nodes": [],
		"branch_group": "",
		"progression": -1,
		"is_battle": true,
		"gold_reward": 150,
		"reward_choices": ["gate_seal", "warlord_crest", "archmage_pendant"],
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
