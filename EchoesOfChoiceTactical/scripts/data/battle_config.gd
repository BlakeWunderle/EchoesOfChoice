class_name BattleConfig extends Resource

@export var battle_id: String
@export var grid_width: int = 10
@export var grid_height: int = 8

@export_group("Units")
@export var player_units: Array[Dictionary] = []
@export var enemy_units: Array[Dictionary] = []

@export_group("Dialogue")
@export var pre_battle_dialogue: Array[Dictionary] = []   # [{speaker, text}, ...] shown before combat
@export var post_battle_dialogue: Array[Dictionary] = []  # [{speaker, text}, ...] shown after victory


static func create_tutorial() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "tutorial"
	config.grid_width = 8
	config.grid_height = 6

	var prince_data := load("res://resources/classes/prince.tres")
	var princess_data := load("res://resources/classes/princess.tres")
	var squire_data := load("res://resources/classes/squire.tres")
	var mage_data := load("res://resources/classes/mage.tres")
	var entertainer_data := load("res://resources/classes/entertainer.tres")
	var scholar_data := load("res://resources/classes/scholar.tres")

	var royal_data: FighterData
	if GameState.player_gender == "prince":
		royal_data = prince_data
	else:
		royal_data = princess_data

	config.player_units = [
		{"data": royal_data, "name": GameState.player_name, "pos": Vector2i(1, 3), "level": 1},
		{"data": squire_data, "name": "Sir Aldric", "pos": Vector2i(0, 2), "level": 1},
		{"data": mage_data, "name": "Elara", "pos": Vector2i(0, 4), "level": 1},
		{"data": entertainer_data, "name": "Lyris", "pos": Vector2i(1, 2), "level": 1},
		{"data": scholar_data, "name": "Professor Thane", "pos": Vector2i(1, 4), "level": 1},
	]

	var guard_squire := load("res://resources/enemies/guard_squire.tres")
	var guard_mage := load("res://resources/enemies/guard_mage.tres")
	var guard_entertainer := load("res://resources/enemies/guard_entertainer.tres")
	var guard_scholar := load("res://resources/enemies/guard_scholar.tres")

	config.enemy_units = [
		{"data": guard_squire, "name": "Guard Captain", "pos": Vector2i(6, 2), "level": 1},
		{"data": guard_mage, "name": "Court Mage", "pos": Vector2i(7, 3), "level": 1},
		{"data": guard_entertainer, "name": "Herald Guard", "pos": Vector2i(6, 4), "level": 1},
		{"data": guard_scholar, "name": "Royal Advisor", "pos": Vector2i(7, 2), "level": 1},
	]

	return config


static func load_class(class_id: String) -> FighterData:
	var path := "res://resources/classes/%s.tres" % class_id
	if ResourceLoader.exists(path):
		return load(path) as FighterData
	push_warning("Class resource not found: " + class_id)
	return load("res://resources/classes/squire.tres")


static func _build_party_units(config: BattleConfig) -> void:
	var player_class_id: String = GameState.player_class_id
	if player_class_id.is_empty():
		player_class_id = GameState.player_gender if not GameState.player_gender.is_empty() else "squire"
	var player_data: FighterData = load_class(player_class_id)

	config.player_units.append(
		{"data": player_data, "name": GameState.player_name, "pos": Vector2i(0, 3), "level": GameState.player_level}
	)

	var selected: Array[String] = GameState.selected_party
	var members_to_use: Array[Dictionary] = []
	if selected.is_empty():
		members_to_use = GameState.party_members.duplicate()
	else:
		for member in GameState.party_members:
			if member["name"] in selected:
				members_to_use.append(member)

	var y_slots := [1, 2, 4, 5]
	for i in range(members_to_use.size()):
		var member: Dictionary = members_to_use[i]
		var mdata: FighterData = load_class(member["class_id"])
		var y_pos: int = y_slots[i] if i < y_slots.size() else 3 + i
		config.player_units.append(
			{"data": mdata, "name": member["name"], "pos": Vector2i(1, y_pos), "level": member.get("level", 1)}
		)


static func create_city_street() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "city_street"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var thug := load("res://resources/enemies/thug.tres")
	var tough := load("res://resources/enemies/street_tough.tres")
	var peddler := load("res://resources/enemies/hex_peddler.tres")
	config.enemy_units = [
		{"data": thug, "name": "Street Thug", "pos": Vector2i(8, 1), "level": 1},
		{"data": thug, "name": "Alley Brute", "pos": Vector2i(8, 5), "level": 1},
		{"data": tough, "name": "Brawler", "pos": Vector2i(8, 3), "level": 1},
		{"data": tough, "name": "Gang Enforcer", "pos": Vector2i(9, 3), "level": 1},
		{"data": peddler, "name": "Hex Peddler", "pos": Vector2i(9, 1), "level": 1},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The city streets are quiet tonight. Too quiet."},
		{"speaker": "Aldric", "text": "Eyes up. Someone has been watching us since we left the gates."},
		{"speaker": "", "text": "A gang steps out of the shadows and blocks the road to the forest."}
	]
	config.post_battle_dialogue = [
		{"speaker": "Lyris", "text": "Well. Adventure started sooner than expected."},
		{"speaker": "Aldric", "text": "Keep moving. Whatever is stirring out there is worse than street thugs."}
	]
	return config


static func create_forest() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "forest"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var bear := load("res://resources/enemies/bear.tres")
	var bear_cub := load("res://resources/enemies/bear_cub.tres")
	var wolf := load("res://resources/enemies/wolf.tres")
	var boar := load("res://resources/enemies/wild_boar.tres")
	config.enemy_units = [
		{"data": bear, "name": "Mother Bear", "pos": Vector2i(8, 3), "level": 1},
		{"data": bear_cub, "name": "Bear Cub", "pos": Vector2i(9, 4), "level": 1},
		{"data": wolf, "name": "Grey Wolf", "pos": Vector2i(8, 1), "level": 1},
		{"data": wolf, "name": "Timber Wolf", "pos": Vector2i(8, 5), "level": 1},
		{"data": boar, "name": "Wild Boar", "pos": Vector2i(9, 2), "level": 1},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The forest goes still — not the quiet of morning, but the kind before something large has already made its decision."},
		{"speaker": "Elara", "text": "Something drove them from the deeper wood. They are not spooked."},
		{"speaker": "", "text": "A mother bear crashes through the undergrowth. Her cubs flank the path behind her."}
	]
	config.post_battle_dialogue = [
		{"speaker": "Thane", "text": "An old house, just off the path. Unlocked."},
		{"speaker": "", "text": "Something drove them out of the deeper wood. The village ahead — their chimney smoke is still visible through the trees."}
	]
	return config


static func create_village_raid() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "village_raid"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var goblin := load("res://resources/enemies/goblin.tres")
	var archer := load("res://resources/enemies/goblin_archer.tres")
	var shaman := load("res://resources/enemies/goblin_shaman.tres")
	var hobgob := load("res://resources/enemies/hobgoblin.tres")
	config.enemy_units = [
		{"data": goblin, "name": "Goblin Raider", "pos": Vector2i(8, 2), "level": 1},
		{"data": goblin, "name": "Goblin Looter", "pos": Vector2i(8, 4), "level": 1},
		{"data": archer, "name": "Goblin Archer", "pos": Vector2i(9, 1), "level": 1},
		{"data": shaman, "name": "Goblin Shaman", "pos": Vector2i(9, 5), "level": 1},
		{"data": hobgob, "name": "Hobgoblin Chief", "pos": Vector2i(9, 3), "level": 1},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The forest village is under attack. Goblins have broken through the fence line."},
		{"speaker": "Villager", "text": "Please, drive them off! They are taking everything!"}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The goblins scatter. The village catches its breath."},
		{"speaker": "Aldric", "text": "They were organized. Someone sent them."}
	]
	return config


static func create_smoke() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "smoke"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var imp := load("res://resources/enemies/imp.tres")
	var spirit := load("res://resources/enemies/fire_spirit.tres")
	config.enemy_units = [
		{"data": imp, "name": "Vex", "pos": Vector2i(8, 1), "level": 2},
		{"data": imp, "name": "Gror", "pos": Vector2i(8, 5), "level": 2},
		{"data": spirit, "name": "Cinder", "pos": Vector2i(8, 2), "level": 2},
		{"data": spirit, "name": "Flamekin", "pos": Vector2i(8, 4), "level": 2},
		{"data": spirit, "name": "Ember", "pos": Vector2i(9, 3), "level": 2},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The smoke was a smear on the horizon from the village. Up close it feeds on something big."},
		{"speaker": "Lyris", "text": "I hear cackling."},
		{"speaker": "", "text": "Three imps cluster around a growing fire, chanting in rhythm. They are not just feeding it — they are building something, and it is nearly ready."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The fire dies to embers. Behind where it burned brightest, a portal pulses with dark energy."},
		{"speaker": "Elara", "text": "Nowhere else to go. We step through."}
	]
	return config


static func create_deep_forest() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "deep_forest"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var witch := load("res://resources/enemies/witch.tres")
	var wisp := load("res://resources/enemies/wisp.tres")
	var sprite := load("res://resources/enemies/sprite.tres")
	config.enemy_units = [
		{"data": witch, "name": "Morwen", "pos": Vector2i(9, 3), "level": 2},
		{"data": wisp, "name": "Flicker", "pos": Vector2i(8, 1), "level": 2},
		{"data": wisp, "name": "Glimmer", "pos": Vector2i(8, 5), "level": 2},
		{"data": sprite, "name": "Briar", "pos": Vector2i(8, 2), "level": 2},
		{"data": sprite, "name": "Thorn", "pos": Vector2i(8, 4), "level": 2},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The trees here are ancient, close-set, their canopy blocking the sky. The path narrows to a trail."},
		{"speaker": "Thane", "text": "A ritual circle — fresh chalk, recent candles. She is not just living here. She is searching for something."},
		{"speaker": "", "text": "Lightning splits the sky. A cackle fills the air."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The witch falls. The forest goes still."},
		{"speaker": "Aldric", "text": "Storm is coming in fast. That cave mouth up the hill, we make for it."},
		{"speaker": "", "text": "Morwen says nothing as she falls. Her ritual circle was oriented east — toward the ruins. Whatever she was tracking, she was not the only one looking."}
	]
	return config


static func create_clearing() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "clearing"
	config.grid_width = 14
	config.grid_height = 10
	_build_party_units(config)

	var satyr := load("res://resources/enemies/satyr.tres")
	var nymph := load("res://resources/enemies/nymph.tres")
	var pixie := load("res://resources/enemies/pixie.tres")
	config.enemy_units = [
		{"data": nymph, "name": "Ondine", "pos": Vector2i(12, 2), "level": 2},
		{"data": nymph, "name": "Lirien", "pos": Vector2i(12, 5), "level": 2},
		{"data": pixie, "name": "Jinx", "pos": Vector2i(12, 1), "level": 2},
		{"data": pixie, "name": "Flitz", "pos": Vector2i(12, 7), "level": 2},
		{"data": satyr, "name": "Sylvan", "pos": Vector2i(13, 4), "level": 2},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "Music drifts from the clearing. Catchy. A little too catchy."},
		{"speaker": "Lyris", "text": "My feet are moving on their own. That is not good."},
		{"speaker": "", "text": "Chains of light snap around the party's wrists. The performers' smiles stretch too wide."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The enchantment shatters. The clearing flickers and fades like a candle going out."},
		{"speaker": "", "text": "A path leads downhill into the rocks and a cave mouth, half-hidden by vines."},
		{"speaker": "Sylvan", "text": "'We were pushed,' the satyr says, before the fae mist takes him. 'From the old wood. Something older was already there.'"}
	]
	return config


static func create_ruins() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "ruins"
	config.grid_width = 12
	config.grid_height = 10
	_build_party_units(config)

	var shade := load("res://resources/enemies/shade.tres")
	var wraith := load("res://resources/enemies/wraith.tres")
	var sentry := load("res://resources/enemies/bone_sentry.tres")
	config.enemy_units = [
		{"data": shade, "name": "Umbra", "pos": Vector2i(10, 2), "level": 2},
		{"data": shade, "name": "Nyx", "pos": Vector2i(10, 5), "level": 2},
		{"data": wraith, "name": "Duskwraith", "pos": Vector2i(11, 4), "level": 2},
		{"data": wraith, "name": "Shade Wraith", "pos": Vector2i(10, 7), "level": 2},
		{"data": sentry, "name": "Bone Sentry", "pos": Vector2i(11, 2), "level": 2},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The ruins glow faintly from inside. Every breath comes out as mist."},
		{"speaker": "Elara", "text": "Shades — but stirred, active. Old shades do not move without a cause. Something disturbed their rest and pointed them outward."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The last shade dissolves. The glow at the ruins heart intensifies — a portal, pulsing."}
	]
	return config


static func create_cave() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "cave"
	config.grid_width = 8
	config.grid_height = 6
	_build_party_units(config)

	var fire_wyrm := load("res://resources/enemies/fire_wyrmling.tres")
	var frost_wyrm := load("res://resources/enemies/frost_wyrmling.tres")
	var bat := load("res://resources/enemies/cave_bat.tres")
	config.enemy_units = [
		{"data": bat, "name": "Shriek", "pos": Vector2i(6, 1), "level": 3},
		{"data": bat, "name": "Fang", "pos": Vector2i(6, 4), "level": 3},
		{"data": fire_wyrm, "name": "Raysses", "pos": Vector2i(7, 2), "level": 3},
		{"data": frost_wyrm, "name": "Sythara", "pos": Vector2i(7, 4), "level": 3},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "Gold everywhere — but two wyrmlings share this hoard. A fire and a frost, together."},
		{"speaker": "Thane", "text": "They never share. Something drove them both here, something neither of them could face alone."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "Silence. Just the sound of coins sliding off the fallen beasts."},
		{"speaker": "Elara", "text": "Two wyrmlings. Old ones. They do not nest near nothing — something darker stirred them here."}
	]
	return config


static func create_portal() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "portal"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var hellion := load("res://resources/enemies/hellion.tres")
	var fiendling := load("res://resources/enemies/fiendling.tres")
	config.enemy_units = [
		{"data": fiendling, "name": "Malphas", "pos": Vector2i(8, 1), "level": 3},
		{"data": fiendling, "name": "Bael", "pos": Vector2i(8, 4), "level": 3},
		{"data": fiendling, "name": "Dantalion", "pos": Vector2i(8, 7), "level": 3},
		{"data": hellion, "name": "Abyzou", "pos": Vector2i(9, 3), "level": 3},
		{"data": hellion, "name": "Purson", "pos": Vector2i(9, 5), "level": 3},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "A rift, already open. Not breaking through from the other side — held open, from this one, by someone who knew exactly how."},
		{"speaker": "Aldric", "text": "This was not an accident."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The last hellion falls. The rift seals shut, but not before something slips through the cracks."},
		{"speaker": "Thane", "text": "The crossroads cannot be far. We need to regroup."}
	]
	return config


static func create_inn_ambush() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "inn_ambush"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var hound := load("res://resources/enemies/shadow_hound.tres")
	var prowler := load("res://resources/enemies/night_prowler.tres")
	var moth := load("res://resources/enemies/dusk_moth.tres")
	var stalker := load("res://resources/enemies/gloom_stalker.tres")
	config.enemy_units = [
		{"data": hound, "name": "Shadow Hound", "pos": Vector2i(8, 1), "level": 3},
		{"data": hound, "name": "Dark Hound", "pos": Vector2i(8, 5), "level": 3},
		{"data": prowler, "name": "Night Prowler", "pos": Vector2i(8, 3), "level": 3},
		{"data": moth, "name": "Dusk Moth", "pos": Vector2i(9, 2), "level": 3},
		{"data": stalker, "name": "Gloom Stalker", "pos": Vector2i(9, 4), "level": 3},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The inn goes quiet the wrong way. Shadows peel away from the walls."},
		{"speaker": "Lyris", "text": "We were followed."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The creatures dissolve into nothing. Whoever sent them knows exactly where you are."}
	]
	return config


static func create_shore() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "shore"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var node_data: Dictionary = MapData.get_node("shore")
	var progression: int = node_data.get("progression", 4)
	var lvl: int = maxi(1, progression)

	# C# ShoreBattle: 3 Sirens (Lorelei, Thalassa, Ligeia). Sirens + aquatic only; no pirates. Unique names fitting class.
	var siren := load("res://resources/enemies/siren.tres")
	var nymph := load("res://resources/enemies/nymph.tres")
	config.enemy_units = [
		{"data": siren, "name": "Thalassa", "pos": Vector2i(8, 1), "level": lvl},
		{"data": siren, "name": "Ligeia", "pos": Vector2i(8, 5), "level": lvl},
		{"data": nymph, "name": "Nerida", "pos": Vector2i(8, 2), "level": lvl},
		{"data": nymph, "name": "Coralie", "pos": Vector2i(8, 4), "level": lvl},
		{"data": siren, "name": "Lorelei", "pos": Vector2i(9, 3), "level": lvl},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "Salt hangs heavy in the air. The coast road is beautiful — and something beneath the waves is watching."},
		{"speaker": "", "text": "Sirens break the surface, their song cutting through the sound of the waves."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The last siren slips beneath the water. The coast opens ahead."},
		{"speaker": "Aldric", "text": "The beach. And something on the horizon — a shipwreck."}
	]
	return config


static func create_beach() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "beach"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var node_data: Dictionary = MapData.get_node("beach")
	var progression: int = node_data.get("progression", 4)
	var lvl: int = maxi(1, progression)

	# C# BeachBattle: Captain (Greybeard), Pirates (Flint, Bonny). Tactical: captain + 3 pirates + kraken. Unique names fitting class.
	var captain := load("res://resources/enemies/captain.tres")
	var pirate := load("res://resources/enemies/pirate.tres")
	var kraken := load("res://resources/enemies/kraken.tres")
	config.enemy_units = [
		{"data": pirate, "name": "Flint", "pos": Vector2i(8, 1), "level": lvl},
		{"data": pirate, "name": "Bonny", "pos": Vector2i(8, 4), "level": lvl},
		{"data": pirate, "name": "Redeye", "pos": Vector2i(8, 5), "level": lvl},
		{"data": captain, "name": "Greybeard", "pos": Vector2i(9, 2), "level": lvl},
		{"data": kraken, "name": "Abyssal", "pos": Vector2i(9, 3), "level": lvl},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "A shipwreck juts from the shallows. Too intact to have washed in naturally."},
		{"speaker": "Lyris", "text": "Figures dropping from the rigging. That is a crew."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The pirates scatter. The coast road converges ahead — a crossing where all three paths meet."}
	]
	return config


static func create_cemetery_battle() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "cemetery_battle"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var node_data: Dictionary = MapData.get_node("cemetery_battle")
	var progression: int = node_data.get("progression", 4)
	var lvl: int = maxi(1, progression)

	# C# CemeteryBattle: 3 Zombies (Mort--, Rave--, Jori--). Tactical: corporeal zombies + ranged specters + wraith lead. Distinct from ruins (ethereal shades/wraiths only).
	var zombie := load("res://resources/enemies/zombie.tres")
	var specter := load("res://resources/enemies/specter.tres")
	var wraith := load("res://resources/enemies/wraith.tres")
	config.enemy_units = [
		{"data": zombie, "name": "Mortis", "pos": Vector2i(8, 1), "level": lvl},
		{"data": zombie, "name": "Ravenna", "pos": Vector2i(8, 5), "level": lvl},
		{"data": specter, "name": "Duskward", "pos": Vector2i(8, 2), "level": lvl},
		{"data": specter, "name": "Hollow", "pos": Vector2i(8, 4), "level": lvl},
		{"data": wraith, "name": "Joris", "pos": Vector2i(9, 3), "level": lvl},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The old cemetery. Headstones lean at wrong angles, names worn away by rain."},
		{"speaker": "Elara", "text": "These were woken deliberately. Someone prepared this road."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The last revenant crumbles. Beyond the cemetery wall, lantern light from a carnival tent sways in the wind."}
	]
	return config


static func create_box_battle() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "box_battle"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var node_data: Dictionary = MapData.get_node("box_battle")
	var progression: int = node_data.get("progression", 4)
	var lvl: int = maxi(1, progression)

	# C# BoxBattle: circus with ring leader. Ringmaster (Gaspard), Harlequin (Louis, Pierrot), Chanteuse (Erembour, Colombine). All performers — no fae.
	var ringmaster := load("res://resources/enemies/ringmaster.tres")
	var harlequin := load("res://resources/enemies/harlequin.tres")
	var chanteuse := load("res://resources/enemies/chanteuse.tres")
	config.enemy_units = [
		{"data": harlequin, "name": "Louis", "pos": Vector2i(8, 1), "level": lvl},
		{"data": chanteuse, "name": "Erembour", "pos": Vector2i(8, 2), "level": lvl},
		{"data": chanteuse, "name": "Colombine", "pos": Vector2i(8, 4), "level": lvl},
		{"data": harlequin, "name": "Pierrot", "pos": Vector2i(8, 5), "level": lvl},
		{"data": ringmaster, "name": "Gaspard", "pos": Vector2i(9, 3), "level": lvl},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The carnival has set up between the cemetery and the road. Bright colors, loud music."},
		{"speaker": "Thane", "text": "The ringmaster is watching us. He knows we came through the cemetery."},
		{"speaker": "Gaspard", "text": "What a perfect addition to tonight's show."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The troupe collapses. In the ringmaster's coat: a sealed note and a sum of coin — payment for services."},
		{"speaker": "Thane", "text": "Someone placed a trap on every road out of the crossroads."}
	]
	return config


static func create_army_battle() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "army_battle"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var node_data: Dictionary = MapData.get_node("army_battle")
	var progression: int = node_data.get("progression", 4)
	var lvl: int = maxi(1, progression)

	# C# ArmyBattle: Commander (Varro), Draconian (Theron), Chaplain (Cristole). Commander and his troops — use C# types only.
	var commander := load("res://resources/enemies/commander.tres")
	var draconian := load("res://resources/enemies/draconian.tres")
	var chaplain := load("res://resources/enemies/chaplain.tres")
	config.enemy_units = [
		{"data": draconian, "name": "Theron", "pos": Vector2i(8, 1), "level": lvl},
		{"data": chaplain, "name": "Cristole", "pos": Vector2i(8, 2), "level": lvl},
		{"data": draconian, "name": "Sentinel", "pos": Vector2i(8, 5), "level": lvl},
		{"data": chaplain, "name": "Vestal", "pos": Vector2i(9, 2), "level": lvl},
		{"data": commander, "name": "Varro", "pos": Vector2i(9, 3), "level": lvl},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "An encampment blocks the road. Organized — tents in rows, a command post at center."},
		{"speaker": "Varro", "text": "This road is closed by order of the Commanders Guild. Turn back."},
		{"speaker": "Aldric", "text": "We are not turning back."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The commander falls. The encampment scatters. The laboratory beyond the tree line waits."}
	]
	return config


static func create_lab_battle() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "lab_battle"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var node_data: Dictionary = MapData.get_node("lab_battle")
	var progression: int = node_data.get("progression", 4)
	var lvl: int = maxi(1, progression)

	# C# LabBattle: Android (Deus), Machinist (Ananiah), Ironclad (Acrid). Lab = constructs only — no imps/fiendlings.
	var android := load("res://resources/enemies/android.tres")
	var machinist := load("res://resources/enemies/machinist.tres")
	var ironclad := load("res://resources/enemies/ironclad.tres")
	config.enemy_units = [
		{"data": android, "name": "Deus", "pos": Vector2i(8, 1), "level": lvl},
		{"data": machinist, "name": "Ananiah", "pos": Vector2i(8, 2), "level": lvl},
		{"data": ironclad, "name": "Acrid", "pos": Vector2i(9, 3), "level": lvl},
		{"data": android, "name": "Unit Seven", "pos": Vector2i(8, 5), "level": lvl},
		{"data": machinist, "name": "Cog", "pos": Vector2i(8, 4), "level": lvl},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The laboratory. Clean lines and locked doors — and things inside that move without being alive."},
		{"speaker": "Thane", "text": "Androids. Machinists. Someone built this place for a purpose."},
		{"speaker": "Deus", "text": "Unauthorized personnel detected. Engaging."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The constructs power down. The lab's notes are dated years back — these machines were not built for war. Built for custody."},
		{"speaker": "Elara", "text": "Something was being kept here for a very long time. The Guild was paid to make sure it stayed."}
	]
	return config


static func create_mirror_battle() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "mirror_battle"
	config.grid_width = 14
	config.grid_height = 10
	_build_party_units(config)

	var node_data: Dictionary = MapData.get_node("mirror_battle")
	var progression: int = node_data.get("progression", 5)
	var lvl: int = maxi(1, progression)

	# C# MirrorBattle: shadow clones of party (no fixed enemy list). Tactical: void_stalker (commanding lead), gloom_stalker, night_prowler × 2, dusk_moth. No shadow_hound — this is the watcher's real force, not a scouting pack.
	var void_stalker := load("res://resources/enemies/void_stalker.tres")
	var prowler := load("res://resources/enemies/night_prowler.tres")
	var stalker := load("res://resources/enemies/gloom_stalker.tres")
	var moth := load("res://resources/enemies/dusk_moth.tres")
	config.enemy_units = [
		{"data": void_stalker, "name": "Tenebris", "pos": Vector2i(13, 4), "level": lvl},
		{"data": stalker, "name": "Vesper", "pos": Vector2i(12, 2), "level": lvl},
		{"data": prowler, "name": "Noctis", "pos": Vector2i(12, 1), "level": lvl},
		{"data": prowler, "name": "Penumbra", "pos": Vector2i(12, 7), "level": lvl},
		{"data": moth, "name": "Dusk", "pos": Vector2i(12, 5), "level": lvl},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "All three roads converge at a dark crossing. Shadows move in the space between the lights."},
		{"speaker": "Lyris", "text": "Those shadows have our shapes."},
		{"speaker": "Aldric", "text": "The same shadows as the inn. It has been watching us since the crossroads."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The shadow-selves dissolve. The crossing clears."},
		{"speaker": "Aldric", "text": "Gate Town is ahead. Last chance to rest before we take the city gates."}
	]
	return config


static func create_gate_ambush() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "gate_ambush"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	# By gate_town, the watcher deploys shadow agents — not street muscle. gloom_stalker leads with two fast prowlers flanking; cursed_peddler is the one hired specialist (keeps "paid ambush" flavor).
	var stalker := load("res://resources/enemies/gloom_stalker.tres")
	var prowler := load("res://resources/enemies/night_prowler.tres")
	var peddler := load("res://resources/enemies/cursed_peddler.tres")
	var moth := load("res://resources/enemies/dusk_moth.tres")
	config.enemy_units = [
		{"data": stalker, "name": "Shadow at the Gate", "pos": Vector2i(9, 3), "level": 5},
		{"data": prowler, "name": "Gate Prowler", "pos": Vector2i(8, 1), "level": 5},
		{"data": prowler, "name": "Gate Hunter", "pos": Vector2i(8, 5), "level": 5},
		{"data": peddler, "name": "Cursed Peddler", "pos": Vector2i(9, 2), "level": 5},
		{"data": moth, "name": "Gate Moth", "pos": Vector2i(8, 3), "level": 5},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "Gate Town's outer road. Someone knew you were coming."},
		{"speaker": "", "text": "Shadow hunters drop from the rooftops. A cursed peddler steps from the alley."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The last of them flees. Street muscle and a shadow watcher — hired hands and sent creatures, working the same job."},
		{"speaker": "Aldric", "text": "Whoever is behind this is not running low on resources."}
	]
	return config


static func create_city_gate_ambush() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "city_gate_ambush"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var void_stalker := load("res://resources/enemies/void_stalker.tres")
	var gloom_stalker := load("res://resources/enemies/gloom_stalker.tres")
	var void_shade := load("res://resources/enemies/void_shade.tres")
	var void_prowler := load("res://resources/enemies/void_prowler.tres")
	config.enemy_units = [
		{"data": void_stalker, "name": "The Watcher's Hand", "pos": Vector2i(9, 3), "level": 6},
		{"data": gloom_stalker, "name": "Gate Shadow", "pos": Vector2i(8, 1), "level": 6},
		{"data": gloom_stalker, "name": "Gate Shadow", "pos": Vector2i(8, 5), "level": 6},
		{"data": void_shade, "name": "Turned Warden", "pos": Vector2i(9, 2), "level": 6},
		{"data": void_prowler, "name": "City Runner", "pos": Vector2i(8, 4), "level": 6},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "Inside the walls. Shadow agents and a city mage — working together."},
		{"speaker": "Aldric", "text": "The same commander as the mirror crossing. It followed us in."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "They scatter. The city's four districts open ahead — each held by someone who will not let you through."},
	]
	return config


static func create_return_city_1() -> BattleConfig:
	# East Gate — The East Rampart: Seraph + Hellion pair
	var config := BattleConfig.new()
	config.battle_id = "return_city_1"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var seraph := load("res://resources/enemies/seraph.tres")
	var arch_hellion := load("res://resources/enemies/arch_hellion.tres")
	var void_prowler := load("res://resources/enemies/void_prowler.tres")
	var gloom := load("res://resources/enemies/gloom_stalker.tres")
	config.enemy_units = [
		{"data": seraph, "name": "Sera", "pos": Vector2i(9, 3), "level": 6},
		{"data": arch_hellion, "name": "Ares", "pos": Vector2i(9, 5), "level": 6},
		{"data": void_prowler, "name": "Shadow Guard", "pos": Vector2i(8, 1), "level": 6},
		{"data": void_prowler, "name": "Shadow Guard", "pos": Vector2i(8, 5), "level": 6},
		{"data": gloom, "name": "Gloom Warden", "pos": Vector2i(8, 3), "level": 6},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The eastern rampart. A divine warrior and a fire lord guard the passage side by side."},
		{"speaker": "Thane", "text": "Different powers, same orders. Whoever hired them has reach."},
	]
	config.post_battle_dialogue = [
		{"speaker": "Sera", "text": "The gate is yours. What stands at the fire shrine beyond — that was not our doing."},
	]
	return config


static func create_return_city_2() -> BattleConfig:
	# North Gate — The Scholar Quarter: Necromancer + Witch pair
	var config := BattleConfig.new()
	config.battle_id = "return_city_2"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var necromancer := load("res://resources/enemies/necromancer.tres")
	var elder_witch := load("res://resources/enemies/elder_witch.tres")
	var void_shade := load("res://resources/enemies/void_shade.tres")
	var dread_wraith := load("res://resources/enemies/dread_wraith.tres")
	config.enemy_units = [
		{"data": necromancer, "name": "Arin", "pos": Vector2i(9, 3), "level": 6},
		{"data": elder_witch, "name": "Nira", "pos": Vector2i(9, 5), "level": 6},
		{"data": void_shade, "name": "Pale Shade", "pos": Vector2i(8, 1), "level": 6},
		{"data": void_shade, "name": "Pale Shade", "pos": Vector2i(8, 5), "level": 6},
		{"data": dread_wraith, "name": "Street Shade", "pos": Vector2i(8, 3), "level": 6},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The scholar quarter. A necromancer and a witch have filled the streets with their workings — dead and nature, tangled together."},
		{"speaker": "Elara", "text": "The tides shrine lies beyond. We have to break through."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "Nature and death both go silent. The north road is open."},
	]
	return config


static func create_return_city_3() -> BattleConfig:
	# West Gate — The Forge District: Psion + Runewright (guard_scholar) pair
	var config := BattleConfig.new()
	config.battle_id = "return_city_3"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var psion := load("res://resources/enemies/psion.tres")
	var scholar := load("res://resources/enemies/guard_scholar.tres")
	var void_prowler := load("res://resources/enemies/void_prowler.tres")
	var gloom := load("res://resources/enemies/gloom_stalker.tres")
	config.enemy_units = [
		{"data": psion, "name": "Elan", "pos": Vector2i(9, 3), "level": 6},
		{"data": scholar, "name": "Nale", "pos": Vector2i(9, 5), "level": 6},
		{"data": void_prowler, "name": "Shadow Guard", "pos": Vector2i(8, 1), "level": 6},
		{"data": void_prowler, "name": "Shadow Guard", "pos": Vector2i(8, 5), "level": 6},
		{"data": gloom, "name": "Gloom Warden", "pos": Vector2i(8, 3), "level": 6},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The forge district. Warding circles on every wall — a psion and a runewright have locked the road down."},
		{"speaker": "Lyris", "text": "Mind and rune. Do not stand still."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The wards collapse. West road clear."},
	]
	return config


static func create_return_city_4() -> BattleConfig:
	# South Gate — The Temple Road: Warlock + Shaman pair
	var config := BattleConfig.new()
	config.battle_id = "return_city_4"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var warlock := load("res://resources/enemies/warlock.tres")
	var shaman := load("res://resources/enemies/shaman.tres")
	var void_shade := load("res://resources/enemies/void_shade.tres")
	var void_s := load("res://resources/enemies/void_stalker.tres")
	config.enemy_units = [
		{"data": warlock, "name": "Alis", "pos": Vector2i(9, 3), "level": 6},
		{"data": shaman, "name": "Sila", "pos": Vector2i(9, 5), "level": 6},
		{"data": void_shade, "name": "Shadow Pact", "pos": Vector2i(8, 1), "level": 6},
		{"data": void_shade, "name": "Shadow Pact", "pos": Vector2i(8, 5), "level": 6},
		{"data": void_s, "name": "Void Gate", "pos": Vector2i(8, 3), "level": 6},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The temple road. A warlock and a shaman hold the crossing — pact and spirit, pulling in the same direction."},
		{"speaker": "Aldric", "text": "The stone shrine lies under the temple. We go through them."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The pact unravels. The temple road is ours."},
	]
	return config



static func create_elemental_1() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "elemental_1"
	config.grid_width = 12
	config.grid_height = 10
	_build_party_units(config)

	# Shrine of Flames: mono-fire (1 lead lvl 8 + 4 lesser lvl 7)
	var fire_elem := load("res://resources/enemies/fire_elemental.tres")
	config.enemy_units = [
		{"data": fire_elem, "name": "Pyraxis", "pos": Vector2i(11, 5), "level": 8},
		{"data": fire_elem, "name": "Ember", "pos": Vector2i(10, 2), "level": 7},
		{"data": fire_elem, "name": "Cinder", "pos": Vector2i(10, 5), "level": 7},
		{"data": fire_elem, "name": "Flicker", "pos": Vector2i(10, 8), "level": 7},
		{"data": fire_elem, "name": "Ash", "pos": Vector2i(11, 3), "level": 7},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "A fire elemental towers above the shrine — four lesser flames circle it. The air itself is burning."},
		{"speaker": "Elara", "text": "We end this."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "Pyraxis crashes down. Sunlight breaks through smoke."},
		{"speaker": "", "text": "On a rooftop above — a figure. Watching. A single nod. Then gone."},
		{"speaker": "Aldric", "text": "Every step. That same presence."},
	]
	return config

static func create_elemental_2() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "elemental_2"
	config.grid_width = 12
	config.grid_height = 10
	_build_party_units(config)

	# Shrine of Tides: mono-water (1 lead lvl 8 + 4 lesser lvl 7)
	var water_elem := load("res://resources/enemies/water_elemental.tres")
	config.enemy_units = [
		{"data": water_elem, "name": "Undine the Deep", "pos": Vector2i(11, 5), "level": 8},
		{"data": water_elem, "name": "Ripple", "pos": Vector2i(10, 2), "level": 7},
		{"data": water_elem, "name": "Surge", "pos": Vector2i(10, 5), "level": 7},
		{"data": water_elem, "name": "Torrent", "pos": Vector2i(10, 8), "level": 7},
		{"data": water_elem, "name": "Tide", "pos": Vector2i(11, 3), "level": 7},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The shrine floods with water. An immense elemental rises — four currents circle it."},
		{"speaker": "Thane", "text": "Someone pulled every elemental in the city to the same purpose."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The tides recede. Water drains away."},
		{"speaker": "", "text": "On the rooftop — a nod. The same one."},
	]
	return config

static func create_elemental_3() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "elemental_3"
	config.grid_width = 12
	config.grid_height = 10
	_build_party_units(config)

	# Shrine of Winds: mono-air (1 lead lvl 8 + 4 lesser lvl 7)
	var air_elem := load("res://resources/enemies/air_elemental.tres")
	config.enemy_units = [
		{"data": air_elem, "name": "Gale Lord", "pos": Vector2i(11, 5), "level": 8},
		{"data": air_elem, "name": "Gust", "pos": Vector2i(10, 2), "level": 7},
		{"data": air_elem, "name": "Squall", "pos": Vector2i(10, 5), "level": 7},
		{"data": air_elem, "name": "Zephyr", "pos": Vector2i(10, 8), "level": 7},
		{"data": air_elem, "name": "Drift", "pos": Vector2i(11, 3), "level": 7},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "A vortex fills the shrine chamber. The lead elemental is at its center — four lesser winds orbit in a tightening spiral."},
		{"speaker": "Lyris", "text": "We are in the eye of it. No retreating."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The vortex dies. Wind fades. The city breathes."},
		{"speaker": "", "text": "A figure on the rooftop gives one nod — then disappears."},
	]
	return config

static func create_elemental_4() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "elemental_4"
	config.grid_width = 12
	config.grid_height = 10
	_build_party_units(config)

	# Shrine of Stone: mono-earth (1 lead lvl 8 + 4 lesser lvl 7)
	var earth_elem := load("res://resources/enemies/earth_elemental.tres")
	config.enemy_units = [
		{"data": earth_elem, "name": "Terrath", "pos": Vector2i(11, 5), "level": 8},
		{"data": earth_elem, "name": "Rubble", "pos": Vector2i(10, 2), "level": 7},
		{"data": earth_elem, "name": "Gravel", "pos": Vector2i(10, 5), "level": 7},
		{"data": earth_elem, "name": "Shard", "pos": Vector2i(10, 8), "level": 7},
		{"data": earth_elem, "name": "Stone", "pos": Vector2i(11, 3), "level": 7},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The temple floor has split open. An earth elemental rose from below — and four lesser forms with it."},
		{"speaker": "Aldric", "text": "If this is how it ends —"},
		{"speaker": "Thane", "text": "It is not."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "Terrath crumbles. The ground goes still."},
		{"speaker": "", "text": "The figure that has been watching since the crossroads — always the same rooftop, always the same nod — is gone."},
		{"speaker": "Elara", "text": "The castle."},
	]
	return config

static func create_final_castle() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "final_castle"
	config.grid_width = 14
	config.grid_height = 12
	_build_party_units(config)

	# The Stranger — final boss — plus elite castle guard. Level 8.
	var stranger := load("res://resources/enemies/the_stranger.tres")
	var guard_mage := load("res://resources/enemies/guard_mage.tres")
	var guard_squire := load("res://resources/enemies/guard_squire.tres")
	config.enemy_units = [
		{"data": stranger, "name": "The Stranger", "pos": Vector2i(12, 5), "level": 8},
		{"data": guard_mage, "name": "Valdris", "pos": Vector2i(12, 2), "level": 8},
		{"data": guard_mage, "name": "Valdris", "pos": Vector2i(12, 8), "level": 8},
		{"data": guard_squire, "name": "Aldous", "pos": Vector2i(11, 3), "level": 8},
		{"data": guard_squire, "name": "Edmund", "pos": Vector2i(11, 7), "level": 8},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The throne room. The Stranger stands at its center, hood down at last. A face you have not seen before — but a voice you recognize from the note in the forest."},
		{"speaker": "The Stranger", "text": "You made it. All of you. The forest, the shrines, the Mirror. I watched every step."},
		{"speaker": "Aldric", "text": "You set those elementals loose. You built the encampment. Why?"},
		{"speaker": "The Stranger", "text": "Because the city needed defenders, not mourners. I built the trials. You passed them. Now comes the final test — whether you can stop me."},
		{"speaker": "", "text": "He raises his staff. The royal guard falls into formation."},
	]
	config.post_battle_dialogue = [
		{"speaker": "The Stranger", "text": "...Good. That is the answer I needed."},
		{"speaker": "", "text": "He lowers his staff. The corruption fades from his eyes — whatever drove him to this, it is over."},
		{"speaker": "The Stranger", "text": "The city is safe. You have proven that. Whatever comes next — you are ready for it."},
		{"speaker": "", "text": "The throne room is quiet. Outside, the city breathes."},
		{"speaker": "", "text": "Every choice left an echo. Yours will ring through the ages."},
	]
	return config


static func create_placeholder(battle_id: String) -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = battle_id
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var node_data: Dictionary = MapData.get_node(battle_id)
	var progression: int = node_data.get("progression", 1)

	var thug := load("res://resources/enemies/thug.tres")
	var enemy_count := clampi(2 + progression, 2, 5)
	var names := ["Foe Alpha", "Foe Beta", "Foe Gamma", "Foe Delta", "Foe Epsilon"]
	for i in range(enemy_count):
		config.enemy_units.append(
			{"data": thug, "name": names[i], "pos": Vector2i(8, 1 + i * 2), "level": maxi(1, progression)}
		)
	return config


static func create_travel_ambush() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "travel_ambush"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var prog: int = GameState.progression_stage

	if prog <= 2:
		var thug: FighterData = load("res://resources/enemies/thug.tres")
		var tough: FighterData = load("res://resources/enemies/street_tough.tres")
		var lvl: int = clampi(prog + 1, 1, 3)
		config.enemy_units = [
			{"data": thug, "name": "Road Bandit", "pos": Vector2i(8, 1), "level": lvl},
			{"data": thug, "name": "Cutthroat", "pos": Vector2i(8, 5), "level": lvl},
			{"data": tough, "name": "Enforcer", "pos": Vector2i(8, 3), "level": lvl},
			{"data": tough, "name": "Gang Lieutenant", "pos": Vector2i(9, 3), "level": lvl},
		]
		config.pre_battle_dialogue = [
			{"speaker": "", "text": "They came from the shadows — blades drawn, faces covered."},
			{"speaker": "Aldric", "text": "Bandits. Four of them. Block the exit."},
		]
		config.post_battle_dialogue = [
			{"speaker": "Lyris", "text": "Well. That was bracing. Let's keep moving."},
		]
	elif prog <= 5:
		var goblin: FighterData = load("res://resources/enemies/goblin.tres")
		var hobgob: FighterData = load("res://resources/enemies/hobgoblin.tres")
		var archer: FighterData = load("res://resources/enemies/goblin_archer.tres")
		var lvl: int = clampi(prog, 3, 5)
		config.enemy_units = [
			{"data": goblin, "name": "Raider", "pos": Vector2i(8, 1), "level": lvl},
			{"data": goblin, "name": "Looter", "pos": Vector2i(8, 5), "level": lvl},
			{"data": archer, "name": "Skirmisher", "pos": Vector2i(9, 2), "level": lvl},
			{"data": hobgob, "name": "War Chief", "pos": Vector2i(9, 4), "level": lvl},
		]
		config.pre_battle_dialogue = [
			{"speaker": "", "text": "A war party steps across the road. They have been tracking you for some time."},
			{"speaker": "Elara", "text": "The archer on the right — take him first or we'll be bleeding before we close."},
		]
		config.post_battle_dialogue = [
			{"speaker": "Thane", "text": "Someone sent them. These were not random opportunists."},
		]
	else:
		var prowler: FighterData = load("res://resources/enemies/night_prowler.tres")
		var hound: FighterData = load("res://resources/enemies/shadow_hound.tres")
		var stalker: FighterData = load("res://resources/enemies/gloom_stalker.tres")
		var lvl: int = clampi(prog, 6, 10)
		config.enemy_units = [
			{"data": prowler, "name": "Night Prowler", "pos": Vector2i(8, 1), "level": lvl},
			{"data": prowler, "name": "Night Prowler", "pos": Vector2i(8, 5), "level": lvl},
			{"data": hound, "name": "Shadow Hound", "pos": Vector2i(8, 3), "level": lvl},
			{"data": stalker, "name": "Gloom Stalker", "pos": Vector2i(9, 3), "level": lvl},
		]
		config.pre_battle_dialogue = [
			{"speaker": "", "text": "No warning. They were waiting — and they know exactly how you move."},
			{"speaker": "Aldric", "text": "This is not an ambush. This is an execution order."},
		]
		config.post_battle_dialogue = [
			{"speaker": "", "text": "The shadows thin. Something is directing these creatures — and it is watching."},
		]

	return config


## Returns array of terrain overrides: {pos: Vector2i, walkable: bool, cost: int, elevation: int, blocks_los: bool, destructible_hp: int}.
## Only includes tiles that are not unit spawn positions.
static func get_terrain_overrides(config: BattleConfig) -> Array:
	var occupied: Dictionary = {}
	for entry in config.player_units:
		occupied[entry["pos"]] = true
	for entry in config.enemy_units:
		occupied[entry["pos"]] = true

	var w: int = config.grid_width
	var h: int = config.grid_height
	var out: Array = []

	match config.battle_id:
		"city_street":
			# Buildings as walls (middle of map), avoid spawns at x 0-1 and 8-9
			for x in range(3, 7):
				for y in [2, 3, 4]:
					var pos := Vector2i(x, y)
					if not occupied.get(pos, false):
						out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"forest":
			# Scattered trees (blocking), leave paths
			var trees: Array[Vector2i] = [Vector2i(4, 2), Vector2i(5, 4), Vector2i(6, 1), Vector2i(6, 6), Vector2i(3, 5)]
			for pos in trees:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"smoke":
			# Sparse blocking (haze)
			var blocks: Array[Vector2i] = [Vector2i(4, 3), Vector2i(6, 4), Vector2i(5, 5)]
			for pos in blocks:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"deep_forest":
			# Dense trees and a ridge (elevation 1)
			var trees: Array[Vector2i] = [Vector2i(3, 2), Vector2i(4, 4), Vector2i(5, 1), Vector2i(5, 5), Vector2i(6, 3)]
			for pos in trees:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
			for pos in [Vector2i(4, 3), Vector2i(5, 3)]:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": true, "cost": 1, "elevation": 1, "blocks_los": false, "destructible_hp": 0})
		"clearing":
			# Central hill (elevation 1-2), 14x10
			for dx in range(5, 9):
				for dy in range(3, 7):
					var pos := Vector2i(dx, dy)
					if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
						var elev: int = 2 if dx >= 6 and dx <= 7 and dy >= 4 and dy <= 5 else 1
						out.append({"pos": pos, "walkable": true, "cost": 1, "elevation": elev, "blocks_los": false, "destructible_hp": 0})
		"ruins":
			# Crumbling walls and elevation steps, 12x10
			var walls: Array[Vector2i] = [Vector2i(4, 2), Vector2i(4, 3), Vector2i(5, 2), Vector2i(5, 3), Vector2i(6, 5), Vector2i(6, 6), Vector2i(7, 5), Vector2i(7, 6)]
			for pos in walls:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
			for pos in [Vector2i(7, 2), Vector2i(7, 3), Vector2i(8, 2), Vector2i(8, 3)]:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": true, "cost": 1, "elevation": 1, "blocks_los": false, "destructible_hp": 0})
		"cave":
			# Corridor walls and destructible boulder, 8x6
			var walls: Array[Vector2i] = [Vector2i(2, 0), Vector2i(2, 1), Vector2i(3, 5), Vector2i(4, 0), Vector2i(4, 5)]
			for pos in walls:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
			var boulder := Vector2i(4, 3)
			if not occupied.get(boulder, false):
				out.append({"pos": boulder, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 20})
		"portal":
			# Rift edges (blocking)
			var edges: Array[Vector2i] = [Vector2i(4, 1), Vector2i(4, 6), Vector2i(5, 0), Vector2i(5, 7), Vector2i(6, 2), Vector2i(6, 5)]
			for pos in edges:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"shore":
			# Water edge (blocking), sand (rough)
			var water: Array[Vector2i] = [Vector2i(5, 0), Vector2i(6, 0), Vector2i(7, 0)]
			for pos in water:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
			for pos in [Vector2i(4, 4), Vector2i(5, 5), Vector2i(6, 4)]:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": true, "cost": 2, "elevation": 0, "blocks_los": false, "destructible_hp": 0})
		"beach":
			# Sand (rough), wreckage (blocking)
			for dx in range(4, 7):
				for dy in [3, 4]:
					var pos := Vector2i(dx, dy)
					if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
						out.append({"pos": pos, "walkable": true, "cost": 2, "elevation": 0, "blocks_los": false, "destructible_hp": 0})
			var wreck: Array[Vector2i] = [Vector2i(5, 1), Vector2i(6, 6)]
			for pos in wreck:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"cemetery_battle":
			# Tombstones (blocking/rough), mausoleum
			var stones: Array[Vector2i] = [Vector2i(3, 2), Vector2i(4, 5), Vector2i(5, 1), Vector2i(6, 4), Vector2i(4, 3)]
			for pos in stones:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"box_battle":
			# Tents (walls), stage (elevation)
			var tents: Array[Vector2i] = [Vector2i(3, 2), Vector2i(4, 2), Vector2i(5, 5), Vector2i(6, 5)]
			for pos in tents:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
			for pos in [Vector2i(5, 3), Vector2i(6, 3)]:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": true, "cost": 1, "elevation": 1, "blocks_los": false, "destructible_hp": 0})
		"army_battle":
			# Barricades (blocking)
			var barricades: Array[Vector2i] = [Vector2i(4, 2), Vector2i(5, 2), Vector2i(4, 5), Vector2i(5, 5)]
			for pos in barricades:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"lab_battle":
			# Walls, machinery (blocking), crates
			var walls: Array[Vector2i] = [Vector2i(3, 2), Vector2i(4, 2), Vector2i(5, 4), Vector2i(6, 4)]
			for pos in walls:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
			var crate := Vector2i(5, 3)
			if not occupied.get(crate, false):
				out.append({"pos": crate, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 15})
		"mirror_battle":
			# Reflective floor, minimal obstacles (arena), 14x10
			var pillars: Array[Vector2i] = [Vector2i(6, 2), Vector2i(6, 7), Vector2i(7, 4), Vector2i(8, 2), Vector2i(8, 7)]
			for pos in pillars:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"return_city_1", "return_city_2", "return_city_3", "return_city_4":
			# City gate: gatehouse walls (blocking), gate platform (elevation), 10x8
			var gate_walls: Array[Vector2i] = [Vector2i(6, 0), Vector2i(6, 7), Vector2i(7, 0), Vector2i(7, 7)]
			for pos in gate_walls:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
			for pos in [Vector2i(7, 3), Vector2i(7, 4)]:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": true, "cost": 1, "elevation": 1, "blocks_los": false, "destructible_hp": 0})

	return out
