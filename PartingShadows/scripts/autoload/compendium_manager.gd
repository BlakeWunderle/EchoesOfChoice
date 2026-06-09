extends Node

## Cross-session compendium tracking. Records encountered enemies and player
## classes to user://compendium.json so the player can review what they've seen.

const COMPENDIUM_PATH := "user://compendium.json"
const TOTAL_ENEMIES := 189

const STORY_1_BATTLES: Array[String] = [
	"CityStreetBattle", "WolfForestBattle", "WaypointDefenseBattle", "ForestWaypoint",
	"HighlandBattle", "DeepForestBattle", "ShoreBattle", "MountainPassBattle",
	"CaveBattle", "BeachBattle", "WildernessOutpost", "CircusBattle",
	"LabBattle", "ArmyBattle", "CemeteryBattle", "OutpostDefenseBattle",
	"MirrorBattle", "CityOutskirtsStop", "ReturnToCityStreetBattle",
	"StrangerTowerBattle", "CopperMugStop", "CorruptedCityBattle",
	"CorruptedWildsBattle", "DepthsBattle", "GateBattle", "StrangerFinalBattle",
]
const STORY_2_BATTLES: Array[String] = [
	"S2_CaveAwakening", "S2_DeepCavern", "S2_FungalHollow", "S2_TranquilPool",
	"S2_TorchChamber", "S2_CaveMerchant", "S2_CaveExit", "S2_CoastalDescent",
	"S2_FishingVillage", "S2_SmugglersBluff", "S2_HarborTown", "S2_WreckersCove",
	"S2_CoastalRuins", "S2_BlackwaterBay", "S2_LighthouseStorm",
	"S2_BeneathTheLighthouse", "S2_MemoryVault", "S2_EchoGallery",
	"S2_ShatteredSanctum", "S2_GuardiansThreshold", "S2_ForgottenArchive",
	"S2_TheReveal", "S2_DepthsOfRemembrance", "S2_MawOfTheEye",
	"S2_EyeAwakening", "S2_EyeOfOblivion",
]
const STORY_3_BATTLES: Array[String] = [
	"S3_WearyTraveler", "S3_DreamMeadow", "S3_DreamMirrorHall", "S3_DreamFogGarden",
	"S3_TownMorning", "S3_DreamReturn", "S3_DreamLabyrinth", "S3_DreamClockTower",
	"S3_DreamNightmare", "S3_DreamThreads", "S3_DreamDrownedCorridor",
	"S3_DreamShatteredGallery", "S3_DreamShadowChase", "S3_TownInvestigation",
	"S3_MarketConfrontation", "S3_CellarDiscovery", "S3_TownRealization",
	"S3_LucidDream", "S3_DreamTemple", "S3_DreamVoid", "S3_DreamSanctum",
	"S3_CultUnderbelly", "S3_CultCatacombs", "S3_CultRitualChamber", "S3_DreamNexus",
	"S3_B_InnSearch", "S3_B_CultConfrontation", "S3_B_CallumsTruth",
	"S3_B_TunnelBreach", "S3_B_ThornesWard", "S3_B_LoomHeart",
	"S3_B_DreamInvasion", "S3_B_DreamNexus",
	"S3_C_LirasConfession", "S3_C_DreamDescent", "S3_C_CultInterception",
	"S3_C_ThreadmasterLair", "S3_C_DreamNexus",
]

var _seen_enemies: Dictionary = {}  # class_id -> {name, abilities, story_id, timestamp}
var _seen_classes: Dictionary = {}  # class_id -> {display_name, tier, timestamp}
var _battles_completed: Dictionary = {}  # battle_id -> timestamp


func _ready() -> void:
	_load()


func record_enemy(fighter: RefCounted, story_id: String) -> void:
	if _seen_enemies.has(fighter.class_id):
		return
	var ability_names: Array[String] = []
	for a: RefCounted in fighter.abilities:
		ability_names.append(a.ability_name)
	_seen_enemies[fighter.class_id] = {
		"name": fighter.character_type,
		"abilities": ability_names,
		"story_id": story_id,
		"timestamp": Time.get_unix_time_from_system(),
	}
	_save()
	if _seen_enemies.size() >= 50:
		SteamManager.set_achievement("COMPENDIUM_50_ENEMIES")
	if _seen_enemies.size() >= TOTAL_ENEMIES:
		SteamManager.set_achievement("ALL_ENEMIES")


func record_class(class_id: String, display_name: String) -> void:
	if _seen_classes.has(class_id):
		return
	var tier: int = get_tier(class_id)
	_seen_classes[class_id] = {
		"display_name": display_name,
		"tier": tier,
		"timestamp": Time.get_unix_time_from_system(),
	}
	_save()
	# Steam achievements for class collection
	if tier == 2:
		SteamManager.set_achievement("CLASS_TIER_2")
	var t0: Array[String] = ["Squire", "Mage", "Entertainer", "Tinker", "Wildling", "Wanderer"]
	var all_t0: bool = true
	for c: String in t0:
		if not _seen_classes.has(c):
			all_t0 = false
			break
	if all_t0:
		SteamManager.set_achievement("ALL_BASE_CLASSES")
	if _seen_classes.size() >= 56:
		SteamManager.set_achievement("ALL_CLASSES")


func mark_battle_complete(battle_id: String) -> void:
	if _battles_completed.has(battle_id):
		return
	_battles_completed[battle_id] = Time.get_unix_time_from_system()
	_save()
	_check_battle_achievements()


func _check_battle_achievements() -> void:
	if _has_all_battles(STORY_1_BATTLES):
		SteamManager.set_achievement("ALL_BATTLES_S1")
	if _has_all_battles(STORY_2_BATTLES):
		SteamManager.set_achievement("ALL_BATTLES_S2")
	if _has_all_battles(STORY_3_BATTLES):
		SteamManager.set_achievement("ALL_BATTLES_S3")


func _has_all_battles(battle_list: Array[String]) -> bool:
	for bid: String in battle_list:
		if not _battles_completed.has(bid):
			return false
	return true


func get_seen_enemies() -> Dictionary:
	return _seen_enemies


func get_seen_classes() -> Dictionary:
	return _seen_classes


func get_battles_completed() -> Dictionary:
	return _battles_completed


## Get global discoveries merged from all save slots
func get_global_discoveries() -> Dictionary:
	# For now, return current session data
	# TODO: Implement cross-save merging by loading all save files
	return {
		"enemies": _seen_enemies,
		"classes": _seen_classes,
		"battles": _battles_completed,
	}


## Get discoveries for a specific save slot
func get_save_discoveries(save_slot: int) -> Dictionary:
	# For now, return current session data (assumes we're in that save)
	# TODO: Load specific save file and return its compendium data
	return {
		"enemies": _seen_enemies,
		"classes": _seen_classes,
		"battles": _battles_completed,
	}


## Convert battle_id to readable display name.
func format_battle_name(battle_id: String) -> String:
	const NAMES := {
		# Story 1 - Act I
		"CityStreetBattle": "City Streets",
		"WolfForestBattle": "Wolf Forest",
		"WaypointDefenseBattle": "Waypoint Defense",
		"ForestWaypoint": "Forest Waypoint Inn",
		# Story 1 - Act II
		"HighlandBattle": "The Highlands",
		"DeepForestBattle": "Deep Forest",
		"ShoreBattle": "The Shore",
		"MountainPassBattle": "Mountain Pass",
		"CaveBattle": "The Cave",
		"BeachBattle": "The Beach",
		"WildernessOutpost": "Wilderness Outpost",
		"CircusBattle": "The Circus",
		"LabBattle": "The Laboratory",
		"ArmyBattle": "Army Encampment",
		"CemeteryBattle": "The Cemetery",
		"OutpostDefenseBattle": "Outpost Defense",
		"MirrorBattle": "The Mirror",
		# Story 1 - Act III
		"CityOutskirtsStop": "City Outskirts",
		"ReturnToCityStreetBattle": "Return to City Streets",
		"StrangerTowerBattle": "The Stranger's Tower",
		# Story 1 - Acts IV-V
		"CopperMugStop": "The Copper Mug Tavern",
		"CorruptedCityBattle": "Corrupted City",
		"CorruptedWildsBattle": "Corrupted Wilds",
		"DepthsBattle": "The Depths",
		"GateBattle": "The Gate",
		"StrangerFinalBattle": "The Stranger (Final)",
		# Story 2 - Act I
		"S2_CaveAwakening": "Cave Awakening",
		"S2_DeepCavern": "Deep Cavern",
		"S2_FungalHollow": "Fungal Hollow",
		"S2_TranquilPool": "Tranquil Pool",
		"S2_TorchChamber": "Torch Chamber",
		"S2_CaveMerchant": "Cave Merchant Camp",
		"S2_CaveExit": "Cave Exit",
		# Story 2 - Act II
		"S2_CoastalDescent": "Coastal Descent",
		"S2_FishingVillage": "Fishing Village",
		"S2_SmugglersBluff": "Smuggler's Bluff",
		"S2_HarborTown": "Harbor Town",
		"S2_WreckersCove": "Wrecker's Cove",
		"S2_CoastalRuins": "Coastal Ruins",
		"S2_BlackwaterBay": "Blackwater Bay",
		"S2_LighthouseStorm": "Lighthouse Storm",
		# Story 2 - Act III
		"S2_BeneathTheLighthouse": "Beneath the Lighthouse",
		"S2_MemoryVault": "Memory Vault",
		"S2_EchoGallery": "Echo Gallery",
		"S2_ShatteredSanctum": "Shattered Sanctum",
		"S2_GuardiansThreshold": "Guardian's Threshold",
		"S2_ForgottenArchive": "Forgotten Archive",
		"S2_TheReveal": "The Reveal",
		# Story 2 - Act IV
		"S2_DepthsOfRemembrance": "Depths of Remembrance",
		"S2_MawOfTheEye": "Maw of the Eye",
		"S2_EyeAwakening": "Eye Awakening",
		"S2_EyeOfOblivion": "Eye of Oblivion",
		# Story 3 - Acts I-II
		"S3_WearyTraveler": "The Weary Traveler Inn",
		"S3_DreamMeadow": "Dream Meadow",
		"S3_DreamMirrorHall": "Dream Mirror Hall",
		"S3_DreamFogGarden": "Dream Fog Garden",
		"S3_TownMorning": "Town Morning",
		"S3_DreamReturn": "Dream Return",
		"S3_DreamLabyrinth": "Dream Labyrinth",
		"S3_DreamClockTower": "Dream Clock Tower",
		"S3_DreamNightmare": "The Nightmare",
		# Story 3 - Act II expansion
		"S3_DreamThreads": "Dream Threads",
		"S3_DreamDrownedCorridor": "Drowned Corridor",
		"S3_DreamShatteredGallery": "Shattered Gallery",
		"S3_DreamShadowChase": "Shadow Chase",
		"S3_TownInvestigation": "Town Investigation",
		"S3_MarketConfrontation": "Market Confrontation",
		"S3_CellarDiscovery": "Cellar Discovery",
		# Story 3 - Act III
		"S3_TownRealization": "Town Realization",
		"S3_LucidDream": "Lucid Dream",
		"S3_DreamTemple": "Dream Temple",
		"S3_DreamVoid": "Dream Void",
		"S3_DreamSanctum": "Dream Sanctum",
		# Story 3 - Acts IV-V
		"S3_CultUnderbelly": "Cult Underbelly",
		"S3_CultCatacombs": "Cult Catacombs",
		"S3_CultRitualChamber": "Cult Ritual Chamber",
		"S3_DreamNexus": "Dream Nexus",
		# Story 3 - Path B
		"S3_B_InnSearch": "Inn Search",
		"S3_B_CultConfrontation": "Cult Confrontation",
		"S3_B_CallumsTruth": "Callum's Truth",
		"S3_B_TunnelBreach": "Tunnel Breach",
		"S3_B_ThornesWard": "Thorne's Ward",
		"S3_B_LoomHeart": "Loom Heart",
		"S3_B_DreamInvasion": "Dream Invasion",
		"S3_B_DreamNexus": "Dream Nexus (Path B)",
		# Story 3 - Path C
		"S3_C_LirasConfession": "Lira's Confession",
		"S3_C_DreamDescent": "Dream Descent",
		"S3_C_CultInterception": "Cult Interception",
		"S3_C_ThreadmasterLair": "Threadmaster's Lair",
		"S3_C_DreamNexus": "Dream Nexus (Path C)",
	}
	if NAMES.has(battle_id):
		return NAMES[battle_id]
	return battle_id.replace("_", " ").capitalize()


func get_tier(class_id: String) -> int:
	match class_id:
		"Squire", "Mage", "Entertainer", "Tinker", "Wildling", "Wanderer":
			return 0
		"Duelist", "Ranger", "MartialArtist", "Invoker", "Acolyte", \
		"Bard", "Dervish", "Orator", "Artificer", "Philosopher", "Arithmancer", \
		"Herbalist", "Shaman", "Beastcaller", "Sentinel", "Pathfinder":
			return 1
	return 2


func _load() -> void:
	var text: String = ""
	if FileAccess.file_exists(COMPENDIUM_PATH):
		var file := FileAccess.open(COMPENDIUM_PATH, FileAccess.READ)
		if file:
			text = file.get_as_text()
			file.close()
	if text.is_empty():
		return
	var json := JSON.new()
	if json.parse(text) != OK:
		GameLog.warn("CompendiumManager: failed to parse compendium.json: " + json.get_error_message())
		return
	var data: Dictionary = json.data
	_seen_enemies = data.get("enemies", {})
	_seen_classes = data.get("classes", {})
	_battles_completed = data.get("battles", {})


func _save() -> void:
	var data := {
		"enemies": _seen_enemies,
		"classes": _seen_classes,
		"battles": _battles_completed,
	}
	var json_str: String = JSON.stringify(data, "\t")
	var file := FileAccess.open(COMPENDIUM_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_str)
		file.close()
	else:
		GameLog.warn("CompendiumManager: failed to write compendium.json")
