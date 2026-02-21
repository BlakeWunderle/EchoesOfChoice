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


static func _build_party_units(config: BattleConfig) -> void:
	var class_map := {
		"squire": "res://resources/classes/squire.tres",
		"mage": "res://resources/classes/mage.tres",
		"entertainer": "res://resources/classes/entertainer.tres",
		"scholar": "res://resources/classes/scholar.tres",
		"prince": "res://resources/classes/prince.tres",
		"princess": "res://resources/classes/princess.tres",
	}

	var player_class_path: String = class_map.get(GameState.player_class_id, "")
	if player_class_path.is_empty():
		player_class_path = class_map.get(GameState.player_gender, class_map["squire"])
	var player_data: FighterData = load(player_class_path)

	config.player_units.append(
		{"data": player_data, "name": GameState.player_name, "pos": Vector2i(0, 3), "level": 1}
	)

	var y_slots := [1, 2, 4, 5]
	for i in range(GameState.party_members.size()):
		var member: Dictionary = GameState.party_members[i]
		var cpath: String = class_map.get(member["class_id"], class_map["squire"])
		var mdata: FighterData = load(cpath)
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
	config.enemy_units = [
		{"data": thug, "name": "Street Thug", "pos": Vector2i(8, 2), "level": 1},
		{"data": thug, "name": "Alley Brute", "pos": Vector2i(8, 4), "level": 1},
		{"data": thug, "name": "Ruffian", "pos": Vector2i(9, 3), "level": 1},
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
	config.enemy_units = [
		{"data": bear, "name": "Mother Bear", "pos": Vector2i(8, 3), "level": 1},
		{"data": bear_cub, "name": "Bear Cub", "pos": Vector2i(9, 4), "level": 1},
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
