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
