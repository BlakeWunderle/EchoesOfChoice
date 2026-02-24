class_name BattleConfigProg45 extends RefCounted


static func create_shore() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "shore"
	config.grid_width = 10
	config.grid_height = 8
	BattleConfig._build_party_units(config)

	var node_data: Dictionary = MapData.get_node("shore")
	var progression: int = node_data.get("progression", 4)
	var lvl: int = maxi(1, progression)

	# C# ShoreBattle: 3 Sirens (Lorelei, Thalassa, Ligeia). Sirens + aquatic only; no pirates. Unique names fitting class.
	var siren := load("res://resources/enemies/siren.tres")
	var tide_nymph := load("res://resources/enemies/tide_nymph.tres")
	config.enemy_units = [
		{"data": siren, "name": "Thalassa", "pos": Vector2i(8, 1), "level": lvl},
		{"data": siren, "name": "Ligeia", "pos": Vector2i(8, 5), "level": lvl},
		{"data": tide_nymph, "name": "Nerida", "pos": Vector2i(8, 2), "level": lvl},
		{"data": tide_nymph, "name": "Coralie", "pos": Vector2i(8, 4), "level": lvl},
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
	BattleConfig._build_party_units(config)

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
	BattleConfig._build_party_units(config)

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
	BattleConfig._build_party_units(config)

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
	BattleConfig._build_party_units(config)

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
	BattleConfig._build_party_units(config)

	var node_data: Dictionary = MapData.get_node("mirror_battle")
	var progression: int = node_data.get("progression", 5)
	var lvl: int = maxi(1, progression)

	# C# MirrorBattle: shadow clones of party (no fixed enemy list). Tactical: void_watcher (commanding lead), mirror_stalker, dusk_prowler × 2, twilight_moth. No shadow_hound — this is the watcher's real force, not a scouting pack.
	var void_watcher := load("res://resources/enemies/void_watcher.tres")
	var prowler := load("res://resources/enemies/dusk_prowler.tres")
	var stalker := load("res://resources/enemies/mirror_stalker.tres")
	var moth := load("res://resources/enemies/twilight_moth.tres")
	config.enemy_units = [
		{"data": void_watcher, "name": "Tenebris", "pos": Vector2i(13, 4), "level": lvl},
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
	BattleConfig._build_party_units(config)

	# By gate_town, the watcher deploys shadow agents — not street muscle. gloom_stalker leads with two fast prowlers flanking; cursed_peddler is the one hired specialist (keeps "paid ambush" flavor).
	var stalker := load("res://resources/enemies/mirror_stalker.tres")
	var prowler := load("res://resources/enemies/dusk_prowler.tres")
	var peddler := load("res://resources/enemies/cursed_peddler.tres")
	var moth := load("res://resources/enemies/twilight_moth.tres")
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

