class_name BattleDB

## Static factory for battle configurations.
## Narrative text copied from C# battle classes.

const BattleData := preload("res://scripts/data/battle_data.gd")
const EnemyDB := preload("res://scripts/data/enemy_db.gd")
const Act2 := preload("res://scripts/data/battle_db_act2.gd")
const Act3 := preload("res://scripts/data/battle_db_act3.gd")
const Act45 := preload("res://scripts/data/battle_db_act45.gd")
const S2 := preload("res://scripts/data/battle_db_s2.gd")
const S2Act2 := preload("res://scripts/data/battle_db_s2_act2.gd")


static func create_battle(battle_id: String) -> BattleData:
	match battle_id:
		# Act I
		"CityStreetBattle": return city_street_battle()
		"WolfForestBattle": return wolf_forest_battle()
		"WaypointDefenseBattle": return waypoint_defense_battle()
		"ForestWaypoint": return forest_waypoint()
		# Act II
		"HighlandBattle": return Act2.highland_battle()
		"DeepForestBattle": return Act2.deep_forest_battle()
		"ShoreBattle": return Act2.shore_battle()
		"MountainPassBattle": return Act2.mountain_pass_battle()
		"CaveBattle": return Act2.cave_battle()
		"BeachBattle": return Act2.beach_battle()
		"WildernessOutpost": return Act2.wilderness_outpost()
		"CircusBattle": return Act2.circus_battle()
		"LabBattle": return Act2.lab_battle()
		"ArmyBattle": return Act2.army_battle()
		"CemeteryBattle": return Act2.cemetery_battle()
		"OutpostDefenseBattle": return Act2.outpost_defense_battle()
		"MirrorBattle": return Act2.mirror_battle()
		# Act III
		"CityOutskirtsStop": return Act3.city_outskirts_stop()
		"ReturnToCityStreetBattle": return Act3.return_to_city_street_battle()
		"StrangerTowerBattle": return Act3.stranger_tower_battle()
		# Act IV-V
		"CopperMugStop": return Act45.copper_mug_stop()
		"CorruptedCityBattle": return Act45.corrupted_city_battle()
		"CorruptedWildsBattle": return Act45.corrupted_wilds_battle()
		"DepthsBattle": return Act45.depths_battle()
		"GateBattle": return Act45.gate_battle()
		"StrangerFinalBattle": return Act45.stranger_final_battle()
		# Story 2
		"S2_CaveAwakening", "S2_DeepCavern", "S2_FungalHollow", \
		"S2_TranquilPool", "S2_TorchChamber", "S2_CaveMerchant", \
		"S2_CaveExit":
			return S2.create_battle(battle_id)
		"S2_CoastalDescent", "S2_FishingVillage", "S2_SmugglersBluff", \
		"S2_HarborTown", "S2_WreckersCove", "S2_CoastalRuins", \
		"S2_BlackwaterBay", "S2_LighthouseStorm":
			return S2Act2.create_battle(battle_id)
		_:
			push_error("Unknown battle: %s" % battle_id)
			return city_street_battle()


# =============================================================================
# Act I (Battles 1-3 + ForestWaypoint town)
# =============================================================================

static func city_street_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "CityStreetBattle"
	b.scene_image = "res://assets/art/battles/city_streets.png"
	b.enemies = [
		EnemyDB.create_thug("Alexander"),
		EnemyDB.create_ruffian("Jenna"),
		EnemyDB.create_pickpocket("Ella"),
	]
	b.pre_battle_text = [
		"Our newly formed party leaves the tavern happy and full of drink and food, ready to set out on an adventure.",
		"The city streets are quiet this late at night. Lanterns flicker along the cobblestone road toward the forest gate.",
		"A little too quiet. After walking a few blocks a handful of street urchins step out of the shadows and surround the party.",
		"Looks like the adventure is starting early.",
	]
	b.post_battle_text = [
		"The street gang scatters into the alleyways and the party dusts themselves off.",
		"The stranger nods approvingly. 'See? The darkness is already here, in the city itself. Imagine what waits beyond the walls.'",
		"They push through the city gate and the tree line swallows the road ahead.",
	]
	b.next_battle_id = "WolfForestBattle"
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Weeping Walls.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/#2.wav"
	return b


static func wolf_forest_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "WolfForestBattle"
	b.scene_image = "res://assets/art/battles/dark_forest.png"
	b.enemies = [
		EnemyDB.create_wolf("Greyfang"),
		EnemyDB.create_boar("Tusker"),
	]
	b.pre_battle_text = [
		"The party follows the road deeper into the forest. The canopy thickens overhead until only slivers of moonlight reach the ground.",
		"As night falls they make camp near an abandoned house set back from the road. The door hangs open, the inside dark and still.",
		"Someone notices a strange sigil carved into a chest inside, a circle with a slash through it, but there's no time to investigate.",
		"During the night, growling and snorting wake the camp. A wolf and a boar emerge from the treeline, territorial and aggressive.",
		"No choice but to fight.",
	]
	b.post_battle_text = [
		"The wolf limps away into the underbrush and the boar crashes off through the trees. Silence settles back over the camp.",
		"Inside the abandoned house the party finds the sigil they noticed earlier, a circle with a single slash through it, carved into the lid of a wooden chest.",
		"The wood around it is still warm to the touch, as though someone traced it minutes ago.",
		"The stranger glances at it but says nothing. If they recognize it, they aren't sharing.",
		"The road continues north. According to the stranger, a waypoint inn lies not far ahead.",
	]
	b.next_battle_id = "WaypointDefenseBattle"
	b.music_track = "res://assets/audio/music/battle/Duel Drums Only LOOP.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/#3.wav"
	return b


static func waypoint_defense_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "WaypointDefenseBattle"
	b.scene_image = "res://assets/art/battles/wanderers_rest.png"
	b.enemies = [
		EnemyDB.create_bandit("Riggs"),
		EnemyDB.create_goblin("Snitch"),
		EnemyDB.create_hound("Fang"),
	]
	b.pre_battle_text = [
		"The party reaches a waypoint inn called 'The Wanderer's Rest' but something is wrong.",
		"The front door is smashed open. Inside, a bandit has the innkeeper cornered behind the counter while his goblin accomplice rifles through the shelves.",
		"A hound snarls at the doorway, hackles raised, blocking the exit.",
		"The party draws weapons. Time to clear the inn.",
	]
	b.post_battle_text = [
		"The bandit scrambles out the back window and his goblin accomplice follows. The hound whimpers and bolts after them.",
		"The innkeeper steps out from behind the counter, shaken but unhurt. She thanks the party profusely.",
		"'You saved my life. Least I can do is open the storeroom.'",
		"Inside are supplies that seem almost too useful. Rations, bandages, a few weapons in good condition, as though someone knew help would arrive.",
		"The stranger mentions quietly that they've been here before. They don't elaborate.",
	]
	b.next_battle_id = "ForestWaypoint"
	b.music_track = "res://assets/audio/music/battle/Pillage LOOP.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/#4.wav"
	return b


static func forest_waypoint() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "ForestWaypoint"
	b.scene_image = "res://assets/art/battles/forest_waypoint.png"
	b.is_town_stop = true
	b.pre_battle_text = [
		"The innkeeper unlocks a heavy door behind the bar and pulls it open. The storeroom is larger than it looks from outside.",
		"Racks of gear line the walls, mismatched but well-maintained. More than a roadside inn should have.",
		"'Take what speaks to you,' she says. 'Folks leave things here all the time. I've learned not to ask why.'",
	]
	b.post_battle_text = [
		"The innkeeper leans on the counter. 'Three roads lead out from here. None of them are safe.'",
		"'West, the highlands. Raiders and worse up in those rocks.'",
		"'North, the old growth forest. Witch work. Circles of stones and sticks. The trees don't feel right.'",
		"'East, the rocky shore. The singing from the water isn't safe. Never was.'",
		"She refills her cup. 'A stranger passed through last week. Paid in gold that turned out to be blank on one side. Said the source of it all was out here somewhere.'",
	]
	b.choices = [
		{"label": "West: The trail climbs into wind-battered highlands.", "battle_id": "HighlandBattle"},
		{"label": "North: The trees grow older and darker.", "battle_id": "DeepForestBattle"},
		{"label": "East: Salt in the air and the sound of surf.", "battle_id": "ShoreBattle"},
	]
	b.music_track = "res://assets/audio/music/town/Medieval Celtic 01(L).wav"
	return b
