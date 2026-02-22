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
		{"data": thug, "name": "Alley Brute", "pos": Vector2i(8, 5), "level": 1},
		{"data": tough, "name": "Brawler", "pos": Vector2i(8, 3), "level": 1},
		{"data": tough, "name": "Gang Enforcer", "pos": Vector2i(9, 3), "level": 1},
		{"data": peddler, "name": "Hex Peddler", "pos": Vector2i(9, 1), "level": 1},
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
		{"data": imp, "name": "Gror", "pos": Vector2i(8, 5), "level": 2},
		{"data": spirit, "name": "Cinder", "pos": Vector2i(8, 2), "level": 2},
		{"data": spirit, "name": "Flamekin", "pos": Vector2i(8, 4), "level": 2},
		{"data": spirit, "name": "Ember", "pos": Vector2i(9, 3), "level": 2},
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

	# C# CemeteryBattle: 3 Zombies (Mort--, Rave--, Jori--). Tactical fit: 2 zombies + 2 ghosts + 1 wraith → bone_sentry (zombie), shade (ghost), wraith (lead). C# names.
	var bone_sentry := load("res://resources/enemies/bone_sentry.tres")
	var shade := load("res://resources/enemies/shade.tres")
	var wraith := load("res://resources/enemies/wraith.tres")
	config.enemy_units = [
		{"data": bone_sentry, "name": "Mortis", "pos": Vector2i(8, 1), "level": lvl},
		{"data": bone_sentry, "name": "Ravenna", "pos": Vector2i(8, 5), "level": lvl},
		{"data": shade, "name": "Duskward", "pos": Vector2i(8, 2), "level": lvl},
		{"data": shade, "name": "Hollow", "pos": Vector2i(8, 4), "level": lvl},
		{"data": wraith, "name": "Joris", "pos": Vector2i(9, 3), "level": lvl},
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
	var ringmaster := load("res://resources/enemies/guard_entertainer.tres")
	var harlequin := load("res://resources/enemies/harlequin.tres")
	var chanteuse := load("res://resources/enemies/chanteuse.tres")
	config.enemy_units = [
		{"data": harlequin, "name": "Louis", "pos": Vector2i(8, 1), "level": lvl},
		{"data": chanteuse, "name": "Erembour", "pos": Vector2i(8, 2), "level": lvl},
		{"data": chanteuse, "name": "Colombine", "pos": Vector2i(8, 4), "level": lvl},
		{"data": harlequin, "name": "Pierrot", "pos": Vector2i(8, 5), "level": lvl},
		{"data": ringmaster, "name": "Gaspard", "pos": Vector2i(9, 3), "level": lvl},
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

	# C# MirrorBattle: shadow clones of party (no fixed enemy list). Tactical: shadow_hound, night_prowler, gloom_stalker, dusk_moth. Unique names fitting shadow/dark.
	var hound := load("res://resources/enemies/shadow_hound.tres")
	var prowler := load("res://resources/enemies/night_prowler.tres")
	var stalker := load("res://resources/enemies/gloom_stalker.tres")
	var moth := load("res://resources/enemies/dusk_moth.tres")
	config.enemy_units = [
		{"data": hound, "name": "Vesper", "pos": Vector2i(12, 1), "level": lvl},
		{"data": hound, "name": "Umbra", "pos": Vector2i(12, 7), "level": lvl},
		{"data": prowler, "name": "Noctis", "pos": Vector2i(12, 2), "level": lvl},
		{"data": moth, "name": "Dusk", "pos": Vector2i(12, 5), "level": lvl},
		{"data": stalker, "name": "Tenebris", "pos": Vector2i(13, 4), "level": lvl},
	]
	return config


static func create_gate_ambush() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "gate_ambush"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var tough := load("res://resources/enemies/street_tough.tres")
	var peddler := load("res://resources/enemies/hex_peddler.tres")
	var prowler := load("res://resources/enemies/night_prowler.tres")
	config.enemy_units = [
		{"data": tough, "name": "Gate Raider", "pos": Vector2i(8, 1), "level": 5},
		{"data": tough, "name": "Gate Brute", "pos": Vector2i(8, 3), "level": 5},
		{"data": tough, "name": "Gate Thug", "pos": Vector2i(8, 5), "level": 5},
		{"data": peddler, "name": "Cursed Peddler", "pos": Vector2i(9, 2), "level": 5},
		{"data": prowler, "name": "Shadow at the Gate", "pos": Vector2i(9, 4), "level": 5},
	]
	return config


static func create_return_city_1() -> BattleConfig:
	# East Gate — C# Seraph/Fiend; tactical: city defenders (guard types)
	var config := BattleConfig.new()
	config.battle_id = "return_city_1"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var squire := load("res://resources/enemies/guard_squire.tres")
	var mage := load("res://resources/enemies/guard_mage.tres")
	var entertainer := load("res://resources/enemies/guard_entertainer.tres")
	config.enemy_units = [
		{"data": mage, "name": "East Gate Mage", "pos": Vector2i(9, 3), "level": 6},
		{"data": squire, "name": "East Gate Squire", "pos": Vector2i(8, 1), "level": 6},
		{"data": squire, "name": "Gate Guard", "pos": Vector2i(8, 5), "level": 6},
		{"data": mage, "name": "Gate Warden", "pos": Vector2i(8, 3), "level": 6},
		{"data": entertainer, "name": "East Gate Sentinel", "pos": Vector2i(9, 4), "level": 6},
	]
	return config


static func create_return_city_2() -> BattleConfig:
	# North Gate — C# Druid/Necromancer; tactical: scholar/hex/shadow
	var config := BattleConfig.new()
	config.battle_id = "return_city_2"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var scholar := load("res://resources/enemies/guard_scholar.tres")
	var peddler := load("res://resources/enemies/hex_peddler.tres")
	var prowler := load("res://resources/enemies/night_prowler.tres")
	config.enemy_units = [
		{"data": scholar, "name": "North Gate Scholar", "pos": Vector2i(9, 3), "level": 6},
		{"data": scholar, "name": "Gate Keeper", "pos": Vector2i(8, 2), "level": 6},
		{"data": peddler, "name": "Hex Keeper", "pos": Vector2i(8, 4), "level": 6},
		{"data": peddler, "name": "North Gate Cursed", "pos": Vector2i(8, 5), "level": 6},
		{"data": prowler, "name": "Shadow at North Gate", "pos": Vector2i(9, 4), "level": 6},
	]
	return config


static func create_return_city_3() -> BattleConfig:
	# West Gate — C# Psion/Runewright; tactical: street/thug/goblin
	var config := BattleConfig.new()
	config.battle_id = "return_city_3"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var tough := load("res://resources/enemies/street_tough.tres")
	var thug := load("res://resources/enemies/thug.tres")
	var goblin := load("res://resources/enemies/goblin.tres")
	config.enemy_units = [
		{"data": tough, "name": "West Gate Raider", "pos": Vector2i(9, 3), "level": 6},
		{"data": tough, "name": "Gate Brute", "pos": Vector2i(8, 1), "level": 6},
		{"data": thug, "name": "West Gate Thug", "pos": Vector2i(8, 4), "level": 6},
		{"data": thug, "name": "Gate Ruffian", "pos": Vector2i(8, 5), "level": 6},
		{"data": goblin, "name": "Gate Scout", "pos": Vector2i(9, 4), "level": 6},
	]
	return config


static func create_return_city_4() -> BattleConfig:
	# South Gate — C# Shaman/Warlock; tactical: shadow (hound/moth/stalker)
	var config := BattleConfig.new()
	config.battle_id = "return_city_4"
	config.grid_width = 10
	config.grid_height = 8
	_build_party_units(config)

	var hound := load("res://resources/enemies/shadow_hound.tres")
	var moth := load("res://resources/enemies/dusk_moth.tres")
	var stalker := load("res://resources/enemies/gloom_stalker.tres")
	config.enemy_units = [
		{"data": stalker, "name": "South Gate Stalker", "pos": Vector2i(9, 3), "level": 6},
		{"data": hound, "name": "Gate Hound", "pos": Vector2i(8, 1), "level": 6},
		{"data": hound, "name": "South Gate Shadow", "pos": Vector2i(8, 5), "level": 6},
		{"data": moth, "name": "Dusk at the Gate", "pos": Vector2i(8, 3), "level": 6},
		{"data": stalker, "name": "Gloom Keeper", "pos": Vector2i(9, 4), "level": 6},
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
