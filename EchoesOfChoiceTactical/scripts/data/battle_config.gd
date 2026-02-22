class_name BattleConfig extends Resource

@export var battle_id: String
@export var grid_width: int = 10
@export var grid_height: int = 8

@export_group("Units")
@export var player_units: Array[Dictionary] = []
@export var enemy_units: Array[Dictionary] = []


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
		{"data": thug, "name": "Alley Brute", "pos": Vector2i(8, 3), "level": 1},
		{"data": thug, "name": "Ruffian", "pos": Vector2i(8, 5), "level": 1},
		{"data": tough, "name": "Gang Enforcer", "pos": Vector2i(9, 2), "level": 1},
		{"data": peddler, "name": "Hex Peddler", "pos": Vector2i(9, 4), "level": 1},
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
		{"data": imp, "name": "Gror", "pos": Vector2i(8, 3), "level": 2},
		{"data": imp, "name": "Pyx", "pos": Vector2i(8, 5), "level": 2},
		{"data": imp, "name": "Zik", "pos": Vector2i(9, 2), "level": 2},
		{"data": spirit, "name": "Ember", "pos": Vector2i(9, 4), "level": 2},
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
	return config


static func create_clearing() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "clearing"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var satyr := load("res://resources/enemies/satyr.tres")
	var nymph := load("res://resources/enemies/nymph.tres")
	var pixie := load("res://resources/enemies/pixie.tres")
	config.enemy_units = [
		{"data": satyr, "name": "Sylvan", "pos": Vector2i(9, 3), "level": 2},
		{"data": nymph, "name": "Ondine", "pos": Vector2i(8, 2), "level": 2},
		{"data": nymph, "name": "Lirien", "pos": Vector2i(8, 4), "level": 2},
		{"data": pixie, "name": "Jinx", "pos": Vector2i(8, 1), "level": 2},
		{"data": pixie, "name": "Flitz", "pos": Vector2i(8, 5), "level": 2},
	]
	return config


static func create_ruins() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "ruins"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var shade := load("res://resources/enemies/shade.tres")
	var wraith := load("res://resources/enemies/wraith.tres")
	var sentry := load("res://resources/enemies/bone_sentry.tres")
	config.enemy_units = [
		{"data": shade, "name": "Umbra", "pos": Vector2i(8, 1), "level": 2},
		{"data": shade, "name": "Nyx", "pos": Vector2i(8, 3), "level": 2},
		{"data": shade, "name": "Vesper", "pos": Vector2i(8, 5), "level": 2},
		{"data": wraith, "name": "Duskwraith", "pos": Vector2i(9, 2), "level": 2},
		{"data": sentry, "name": "Bone Sentry", "pos": Vector2i(9, 4), "level": 2},
	]
	return config


static func create_cave() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "cave"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var fire_wyrm := load("res://resources/enemies/fire_wyrmling.tres")
	var frost_wyrm := load("res://resources/enemies/frost_wyrmling.tres")
	var bat := load("res://resources/enemies/cave_bat.tres")
	config.enemy_units = [
		{"data": fire_wyrm, "name": "Raysses", "pos": Vector2i(9, 2), "level": 3},
		{"data": frost_wyrm, "name": "Sythara", "pos": Vector2i(9, 4), "level": 3},
		{"data": bat, "name": "Shriek", "pos": Vector2i(8, 1), "level": 3},
		{"data": bat, "name": "Fang", "pos": Vector2i(8, 5), "level": 3},
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
	var imp := load("res://resources/enemies/imp.tres")
	config.enemy_units = [
		{"data": hellion, "name": "Abyzou", "pos": Vector2i(9, 3), "level": 3},
		{"data": fiendling, "name": "Malphas", "pos": Vector2i(8, 2), "level": 3},
		{"data": fiendling, "name": "Bael", "pos": Vector2i(8, 4), "level": 3},
		{"data": imp, "name": "Cinder", "pos": Vector2i(8, 1), "level": 3},
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
