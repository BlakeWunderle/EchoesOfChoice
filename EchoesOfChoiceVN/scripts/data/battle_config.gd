class_name BattleConfig

const _Enums = preload("res://scripts/data/enums.gd")


static func load_config(battle_id: String) -> Dictionary:
	match battle_id:
		"city_street": return _city_street()
		"forest": return _forest()
		"village_raid": return _village_raid()
		_: return _default_battle()


static func load_class(class_id: String) -> FighterData:
	var path := "res://resources/classes/%s.tres" % class_id
	if ResourceLoader.exists(path):
		return load(path) as FighterData
	return null


static func load_enemy(enemy_id: String) -> FighterData:
	var path := "res://resources/enemies/%s.tres" % enemy_id
	if ResourceLoader.exists(path):
		return load(path) as FighterData
	return null


static func _city_street() -> Dictionary:
	return {
		"name": "City Street Ambush",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 50,
		"enemies": [
			{"id": "street_tough", "level": 1, "row": _Enums.RowPosition.FRONT},
			{"id": "street_tough", "level": 1, "row": _Enums.RowPosition.FRONT},
			{"id": "thug", "level": 1, "row": _Enums.RowPosition.FRONT},
			{"id": "thug", "level": 1, "row": _Enums.RowPosition.BACK},
		],
	}


static func _forest() -> Dictionary:
	return {
		"name": "Forest Encounter",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 75,
		"enemies": [
			{"id": "forest_guardian", "level": 2, "row": _Enums.RowPosition.FRONT},
			{"id": "forest_guardian", "level": 2, "row": _Enums.RowPosition.FRONT},
			{"id": "elf_enchantress", "level": 2, "row": _Enums.RowPosition.BACK},
		],
	}


static func _village_raid() -> Dictionary:
	return {
		"name": "Village Raid",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 100,
		"enemies": [
			{"id": "thug", "level": 2, "row": _Enums.RowPosition.FRONT},
			{"id": "thug", "level": 2, "row": _Enums.RowPosition.FRONT},
			{"id": "street_tough", "level": 3, "row": _Enums.RowPosition.FRONT},
			{"id": "street_tough", "level": 2, "row": _Enums.RowPosition.BACK},
		],
	}


static func _default_battle() -> Dictionary:
	return {
		"name": "Battle",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 50,
		"enemies": [
			{"id": "thug", "level": 1, "row": _Enums.RowPosition.FRONT},
			{"id": "thug", "level": 1, "row": _Enums.RowPosition.FRONT},
		],
	}
