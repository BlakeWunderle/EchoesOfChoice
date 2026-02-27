class_name BattleConfigProg45 extends RefCounted


static func create_shore() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "shore"
	config.grid_width = 10
	config.grid_height = 8
	config.environment = "shore"
	config.music_track = "res://assets/audio/music/battle/Fantasy Tension - Circle of the Serpent.ogg"
	BattleConfig._build_party_units(config)

	var node_data: Dictionary = MapData.get_node("shore")
	var progression: int = node_data.get("progression", 4)
	var lvl: int = maxi(1, progression)

	# Medusas and sea elf archers guard the coastal caves.
	var medusa := load("res://resources/enemies/medusa.tres")
	var sea_elf := load("res://resources/enemies/sea_elf.tres")
	config.enemy_units = [
		{"data": medusa, "name": "Thalassa", "pos": Vector2i(8, 1), "level": lvl},
		{"data": medusa, "name": "Ligeia", "pos": Vector2i(8, 5), "level": lvl},
		{"data": sea_elf, "name": "Nerida", "pos": Vector2i(8, 2), "level": lvl},
		{"data": sea_elf, "name": "Coralie", "pos": Vector2i(8, 4), "level": lvl},
		{"data": medusa, "name": "Lorelei", "pos": Vector2i(9, 3), "level": lvl},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "Salt hangs heavy in the air. The coast road is beautiful — and something beneath the waves is watching."},
		{"speaker": "", "text": "Figures rise from the tide pools — snake-haired, stone-eyed. Behind them, sea elf archers nock arrows."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The last medusa retreats into the coastal caves. The coast opens ahead."},
		{"speaker": "Aldric", "text": "The beach. And something on the horizon — a shipwreck."}
	]
	return config


static func create_beach() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "beach"
	config.grid_width = 10
	config.grid_height = 8
	config.environment = "shore"
	config.music_track = "res://assets/audio/music/battle/Pillage LOOP.wav"
	BattleConfig._build_party_units(config)

	var node_data: Dictionary = MapData.get_node("beach")
	var progression: int = node_data.get("progression", 4)
	var lvl: int = maxi(1, progression)

	# C# BeachBattle: Captain (Greybeard), Pirates (Flint, Bonny). Tactical: captain + 2 pirates + 2 sea shamans.
	var captain := load("res://resources/enemies/captain.tres")
	var pirate := load("res://resources/enemies/pirate.tres")
	var sea_shaman := load("res://resources/enemies/sea_shaman.tres")
	config.enemy_units = [
		{"data": pirate, "name": "Flint", "pos": Vector2i(8, 1), "level": lvl},
		{"data": pirate, "name": "Bonny", "pos": Vector2i(8, 5), "level": lvl},
		{"data": sea_shaman, "name": "Tidecaller", "pos": Vector2i(8, 4), "level": lvl},
		{"data": sea_shaman, "name": "Riptide", "pos": Vector2i(9, 3), "level": lvl},
		{"data": captain, "name": "Greybeard", "pos": Vector2i(9, 2), "level": lvl},
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
	config.environment = "cemetery"
	config.music_context = 4  # MusicManager.MusicContext.BATTLE_DARK
	config.music_track = "res://assets/audio/music/battle_dark/MUSC_Black_Moon_52BPM_Eminor_1644_Full_Loop.wav"
	BattleConfig._build_party_units(config)

	var node_data: Dictionary = MapData.get_node("cemetery_battle")
	var progression: int = node_data.get("progression", 4)
	var lvl: int = maxi(1, progression)

	# C# CemeteryBattle: 3 Zombies (Mort--, Rave--, Jori--). Tactical: corporeal zombies + ranged specters + wraith lead. Distinct from ruins (ethereal shades/wraiths only).
	var zombie := load("res://resources/enemies/zombie.tres")
	var specter := load("res://resources/enemies/specter.tres")
	var grave_wraith := load("res://resources/enemies/grave_wraith.tres")
	config.enemy_units = [
		{"data": zombie, "name": "Mortis", "pos": Vector2i(8, 1), "level": lvl},
		{"data": zombie, "name": "Ravenna", "pos": Vector2i(8, 5), "level": lvl},
		{"data": specter, "name": "Duskward", "pos": Vector2i(8, 2), "level": lvl},
		{"data": specter, "name": "Hollow", "pos": Vector2i(8, 4), "level": lvl},
		{"data": grave_wraith, "name": "Joris", "pos": Vector2i(9, 3), "level": lvl},
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
	config.environment = "carnival"
	config.music_track = "res://assets/audio/music/battle_scifi/Cantina - Smooth Talk LOOP.wav"
	BattleConfig._build_party_units(config)

	var node_data: Dictionary = MapData.get_node("box_battle")
	var progression: int = node_data.get("progression", 4)
	var lvl: int = maxi(1, progression)

	# C# BoxBattle: circus with ring leader. Ringmaster (Gaspard), Harlequin (Louis, Pierrot), Chanteuse (Erembour, Colombine). All performers — no fae.
	var ringmaster := load("res://resources/enemies/ringmaster.tres")
	var harlequin := load("res://resources/enemies/harlequin.tres")
	var enchantress := load("res://resources/enemies/elf_enchantress.tres")
	config.enemy_units = [
		{"data": harlequin, "name": "Louis", "pos": Vector2i(8, 1), "level": lvl},
		{"data": enchantress, "name": "Erembour", "pos": Vector2i(8, 2), "level": lvl},
		{"data": enchantress, "name": "Colombine", "pos": Vector2i(8, 4), "level": lvl},
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
	config.environment = "camp"
	config.music_track = "res://assets/audio/music/battle/Defending The Kingdom LOOP.wav"
	BattleConfig._build_party_units(config)

	var node_data: Dictionary = MapData.get_node("army_battle")
	var progression: int = node_data.get("progression", 4)
	var lvl: int = maxi(1, progression)

	# Shadow fiends and orc warchanters serve the Commander's mixed dark army.
	var commander := load("res://resources/enemies/commander.tres")
	var shadow_fiend := load("res://resources/enemies/shadow_fiend.tres")
	var warchanter := load("res://resources/enemies/orc_warchanter.tres")
	config.enemy_units = [
		{"data": shadow_fiend, "name": "Theron", "pos": Vector2i(8, 1), "level": lvl},
		{"data": warchanter, "name": "Cristole", "pos": Vector2i(8, 2), "level": lvl},
		{"data": shadow_fiend, "name": "Sentinel", "pos": Vector2i(8, 5), "level": lvl},
		{"data": warchanter, "name": "Vestal", "pos": Vector2i(9, 2), "level": lvl},
		{"data": commander, "name": "Varro", "pos": Vector2i(9, 3), "level": lvl},
	]
	
	config.pre_battle_dialogue = [
		{"speaker": "", "text": "An encampment blocks the road. Organized — tents in rows, a command post at center."},
		{"speaker": "Varro", "text": "This road is closed by order of the Commanders Guild. Turn back."},
		{"speaker": "Aldric", "text": "We are not turning back."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The commander falls. The encampment scatters. The crypt beyond the tree line waits."}
	]
	return config


static func create_lab_battle() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "lab_battle"
	config.grid_width = 10
	config.grid_height = 8
	config.environment = "crypt"
	config.music_context = 4  # MusicManager.MusicContext.BATTLE_DARK
	config.music_track = "res://assets/audio/music/battle_dark/08_Rotten_Memories.wav"
	BattleConfig._build_party_units(config)

	var node_data: Dictionary = MapData.get_node("lab_battle")
	var progression: int = node_data.get("progression", 4)
	var lvl: int = maxi(1, progression)

	# Sealed crypt guarded by frost-enchanted sentinels, golems, and undead crusader.
	var frost_sentinel := load("res://resources/enemies/frost_sentinel.tres")
	var arc_golem := load("res://resources/enemies/arc_golem.tres")
	var crusader := load("res://resources/enemies/skeleton_crusader.tres")
	var ironclad := load("res://resources/enemies/ironclad.tres")
	config.enemy_units = [
		{"data": frost_sentinel, "name": "Frost Warden", "pos": Vector2i(8, 1), "level": lvl},
		{"data": arc_golem, "name": "Arc Golem", "pos": Vector2i(8, 2), "level": lvl},
		{"data": ironclad, "name": "Iron Golem", "pos": Vector2i(9, 3), "level": lvl},
		{"data": frost_sentinel, "name": "Frost Guard", "pos": Vector2i(8, 5), "level": lvl},
		{"data": crusader, "name": "Skeleton Crusader", "pos": Vector2i(8, 4), "level": lvl},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The crypt has been sealed for years. Frost clings to every surface, and the guardians inside still stand vigil."},
		{"speaker": "Thane", "text": "Frost sentinels. Golems. Someone sealed this place and left protectors behind."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The guardians fall. The crypt's inscriptions are dated centuries back — this place was not built for war. Built for custody."},
		{"speaker": "Elara", "text": "Something was being kept here for a very long time. The Guild was paid to make sure it stayed sealed."}
	]
	return config


static func create_mirror_battle() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "mirror_battle"
	config.grid_width = 14
	config.grid_height = 10
	config.environment = "mirror"
	config.music_track = "res://assets/audio/music/battle/Fantasy Tension - Dark Fables.ogg"
	BattleConfig._build_party_units(config)

	var node_data: Dictionary = MapData.get_node("mirror_battle")
	var progression: int = node_data.get("progression", 5)
	var lvl: int = maxi(1, progression)

	# Gorgon commands elite shadow force at the mirror crossing.
	var gorgon := load("res://resources/enemies/gorgon.tres")
	var dark_elf := load("res://resources/enemies/dark_elf_blade.tres")
	var corsair := load("res://resources/enemies/ghost_corsair.tres")
	var dark_seraph := load("res://resources/enemies/dark_seraph.tres")
	config.enemy_units = [
		{"data": gorgon, "name": "Tenebris", "pos": Vector2i(13, 4), "level": lvl},
		{"data": corsair, "name": "Vesper", "pos": Vector2i(12, 2), "level": lvl},
		{"data": dark_elf, "name": "Noctis", "pos": Vector2i(12, 1), "level": lvl},
		{"data": dark_elf, "name": "Penumbra", "pos": Vector2i(12, 7), "level": lvl},
		{"data": dark_seraph, "name": "Dusk", "pos": Vector2i(12, 5), "level": lvl},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "All three roads converge at a dark crossing. Shadows move in the space between the lights."},
		{"speaker": "Lyris", "text": "Something is watching from the dark. More than one."},
		{"speaker": "Aldric", "text": "The same dark elf blades as the inn ambush. It has been tracking us since the crossroads."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The last of them falls. The crossing clears."},
		{"speaker": "Aldric", "text": "Gate Town is ahead. Last chance to rest before we take the city gates."}
	]
	return config


static func create_gate_ambush() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "gate_ambush"
	config.grid_width = 10
	config.grid_height = 8
	config.environment = "city"
	config.music_track = "res://assets/audio/music/battle/Fantasy Tension - Storming the Citadel.ogg"
	BattleConfig._build_party_units(config)

	# Shadow agents deployed at Gate Town: ghost corsair leads, dark elf blades flank, bone sorcerer as specialist.
	var corsair := load("res://resources/enemies/ghost_corsair.tres")
	var dark_elf := load("res://resources/enemies/dark_elf_blade.tres")
	var sorcerer := load("res://resources/enemies/bone_sorcerer.tres")
	var dark_seraph := load("res://resources/enemies/dark_seraph.tres")
	config.enemy_units = [
		{"data": corsair, "name": "Shadow at the Gate", "pos": Vector2i(9, 3), "level": 5},
		{"data": dark_elf, "name": "Gate Blade", "pos": Vector2i(8, 1), "level": 5},
		{"data": dark_elf, "name": "Gate Hunter", "pos": Vector2i(8, 5), "level": 5},
		{"data": sorcerer, "name": "Bone Sorcerer", "pos": Vector2i(9, 2), "level": 5},
		{"data": dark_seraph, "name": "Gate Seraph", "pos": Vector2i(8, 3), "level": 5},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "Gate Town's outer road. Someone knew you were coming."},
		{"speaker": "", "text": "Ghost corsairs drop from the rooftops. A bone sorcerer steps from the alley."}
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The last of them flees. Street muscle and a shadow watcher — hired hands and sent creatures, working the same job."},
		{"speaker": "Aldric", "text": "Whoever is behind this is not running low on resources."}
	]
	return config

