class_name BattleConfigProg23 extends RefCounted


static func create_smoke() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "smoke"
	config.grid_width = 10
	config.grid_height = 8
	config.environment = "scorched"
	BattleConfig._build_party_units(config)

	var firestarter := load("res://resources/enemies/goblin_firestarter.tres")
	var fiend := load("res://resources/enemies/blood_fiend.tres")
	var ogre := load("res://resources/enemies/ogre.tres")
	config.enemy_units = [
		{"data": firestarter, "name": "Vex", "pos": Vector2i(8, 1), "level": 2},
		{"data": firestarter, "name": "Gror", "pos": Vector2i(8, 5), "level": 2},
		{"data": fiend, "name": "Cinder", "pos": Vector2i(8, 2), "level": 2},
		{"data": fiend, "name": "Flamekin", "pos": Vector2i(8, 4), "level": 2},
		{"data": ogre, "name": "Bonecrusher", "pos": Vector2i(9, 3), "level": 2},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The smoke was a smear on the horizon from the village. Up close it feeds on something big."},
		{"speaker": "Lyris", "text": "I hear cackling."},
		{"speaker": "", "text": "Goblin firestarters cluster around a growing blaze, blood fiends drawn to the flames. They are building something, and it is nearly ready."}
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
	config.environment = "forest"
	BattleConfig._build_party_units(config)

	var witch := load("res://resources/enemies/witch.tres")
	var wisp := load("res://resources/enemies/wisp.tres")
	var sprite := load("res://resources/enemies/sprite.tres")
	var huntsman := load("res://resources/enemies/wild_huntsman.tres")
	config.enemy_units = [
		{"data": witch, "name": "Morwen", "pos": Vector2i(9, 3), "level": 2},
		{"data": wisp, "name": "Flicker", "pos": Vector2i(8, 1), "level": 2},
		{"data": wisp, "name": "Glimmer", "pos": Vector2i(8, 5), "level": 2},
		{"data": sprite, "name": "Briar", "pos": Vector2i(8, 2), "level": 2},
		{"data": huntsman, "name": "Thorn", "pos": Vector2i(8, 4), "level": 2},
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
	config.environment = "grassland"
	BattleConfig._build_party_units(config)

	var satyr := load("res://resources/enemies/satyr.tres")
	var elf := load("res://resources/enemies/elf_ranger.tres")
	var pixie := load("res://resources/enemies/pixie.tres")
	config.enemy_units = [
		{"data": elf, "name": "Ondine", "pos": Vector2i(12, 2), "level": 2},
		{"data": elf, "name": "Lirien", "pos": Vector2i(12, 5), "level": 2},
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
	config.environment = "ruins"
	BattleConfig._build_party_units(config)

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
	config.environment = "cave"
	BattleConfig._build_party_units(config)

	var demon_archer := load("res://resources/enemies/demon_archer.tres")
	var frost_demon := load("res://resources/enemies/frost_demon.tres")
	var orc_scout := load("res://resources/enemies/orc_scout.tres")
	config.enemy_units = [
		{"data": orc_scout, "name": "Orc Scout", "pos": Vector2i(6, 1), "level": 3},
		{"data": orc_scout, "name": "Orc Sentry", "pos": Vector2i(6, 4), "level": 3},
		{"data": demon_archer, "name": "Demon Archer", "pos": Vector2i(7, 2), "level": 3},
		{"data": frost_demon, "name": "Frost Demon", "pos": Vector2i(7, 4), "level": 3},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The cave reeks of sulfur. Orc sentries stand guard at the entrance. Deeper in, demon archers draw flaming arrows."},
		{"speaker": "Thane", "text": "Orcs serving demons. Whatever bargain was struck here, it was not made lightly."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "Silence. The orc sentries lie still, and the demons' flames gutter out."},
		{"speaker": "Elara", "text": "Whatever drove the orcs to serve the demons, the bargain is over now."}
	]
	return config


static func create_portal() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "portal"
	config.grid_width = 10
	config.grid_height = 8
	config.environment = "portal"
	config.music_context = 4  # MusicManager.MusicContext.BATTLE_DARK
	BattleConfig._build_party_units(config)

	var hellion := load("res://resources/enemies/hellion.tres")
	var blood_imp := load("res://resources/enemies/blood_imp.tres")
	config.enemy_units = [
		{"data": blood_imp, "name": "Malphas", "pos": Vector2i(8, 1), "level": 3},
		{"data": blood_imp, "name": "Bael", "pos": Vector2i(8, 4), "level": 3},
		{"data": blood_imp, "name": "Dantalion", "pos": Vector2i(8, 7), "level": 3},
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
	config.environment = "inn"
	BattleConfig._build_party_units(config)

	var hunter := load("res://resources/enemies/skeleton_hunter.tres")
	var assassin := load("res://resources/enemies/dark_elf_assassin.tres")
	var seraph := load("res://resources/enemies/fallen_seraph.tres")
	var demon := load("res://resources/enemies/shadow_demon.tres")
	config.enemy_units = [
		{"data": hunter, "name": "Bone Tracker", "pos": Vector2i(8, 1), "level": 3},
		{"data": hunter, "name": "Bone Stalker", "pos": Vector2i(8, 5), "level": 3},
		{"data": assassin, "name": "Dark Elf Assassin", "pos": Vector2i(8, 3), "level": 3},
		{"data": seraph, "name": "Fallen Seraph", "pos": Vector2i(9, 2), "level": 3},
		{"data": demon, "name": "Shadow Demon", "pos": Vector2i(9, 4), "level": 3},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The inn goes quiet the wrong way. Shadows peel away from the walls."},
		{"speaker": "Lyris", "text": "We were followed."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The creatures dissolve into nothing. Whoever sent them knows exactly where you are."}
	]
	return config

