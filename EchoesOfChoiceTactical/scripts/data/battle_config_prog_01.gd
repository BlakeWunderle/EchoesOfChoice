class_name BattleConfigProg01 extends RefCounted


static func create_tutorial() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "tutorial"
	config.grid_width = 8
	config.grid_height = 6
	config.environment = "city"

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


static func create_city_street() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "city_street"
	config.grid_width = 10
	config.grid_height = 8
	config.environment = "city"
	BattleConfig._build_party_units(config)

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
	config.environment = "forest"
	BattleConfig._build_party_units(config)

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
	config.environment = "village"
	BattleConfig._build_party_units(config)

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

