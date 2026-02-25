class_name BattleConfig extends Resource

@export var battle_id: String
@export var grid_width: int = 10
@export var grid_height: int = 8
@export var environment: String = "grassland"

@export_group("Units")
@export var player_units: Array[Dictionary] = []
@export var enemy_units: Array[Dictionary] = []

@export_group("Audio")
@export var music_context: int = 1  # MusicManager.MusicContext.BATTLE

@export_group("Dialogue")
@export var pre_battle_dialogue: Array[Dictionary] = []   # [{speaker, text}, ...] shown before combat
@export var post_battle_dialogue: Array[Dictionary] = []  # [{speaker, text}, ...] shown after victory



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
		{"data": player_data, "name": GameState.player_name, "pos": Vector2i(2, 3), "level": GameState.player_level}
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
			{"data": mdata, "name": member["name"], "pos": Vector2i(3, y_pos), "level": member.get("level", 1)}
		)


static func create_placeholder(battle_id: String) -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = battle_id
	config.grid_width = 10
	config.grid_height = 8
	config.environment = "grassland"
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
		config.environment = "grassland"
	elif prog <= 5:
		config.environment = "forest"
	else:
		config.environment = "forest"

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
		config.music_context = 4  # MusicManager.MusicContext.BATTLE_DARK
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

