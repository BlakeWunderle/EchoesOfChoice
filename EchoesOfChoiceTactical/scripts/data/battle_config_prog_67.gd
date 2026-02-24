class_name BattleConfigProg67 extends RefCounted


static func create_city_gate_ambush() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "city_gate_ambush"
	config.grid_width = 10
	config.grid_height = 8
	BattleConfig._build_party_units(config)

	var void_stalker := load("res://resources/enemies/void_stalker.tres")
	var gloom_stalker := load("res://resources/enemies/gloom_stalker.tres")
	var void_shade := load("res://resources/enemies/void_shade.tres")
	var void_prowler := load("res://resources/enemies/void_prowler.tres")
	config.enemy_units = [
		{"data": void_stalker, "name": "The Watcher's Hand", "pos": Vector2i(9, 3), "level": 6},
		{"data": gloom_stalker, "name": "Gate Shadow", "pos": Vector2i(8, 1), "level": 6},
		{"data": gloom_stalker, "name": "Gate Shadow", "pos": Vector2i(8, 5), "level": 6},
		{"data": void_shade, "name": "Turned Warden", "pos": Vector2i(9, 2), "level": 6},
		{"data": void_prowler, "name": "City Runner", "pos": Vector2i(8, 4), "level": 6},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "Inside the walls. Shadow agents and a city mage — working together."},
		{"speaker": "Aldric", "text": "The same commander as the mirror crossing. It followed us in."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "They scatter. The city's four districts open ahead — each held by someone who will not let you through."},
	]
	return config


static func create_return_city_1() -> BattleConfig:
	# East Gate — The East Rampart: Seraph + Hellion pair
	var config := BattleConfig.new()
	config.battle_id = "return_city_1"
	config.grid_width = 10
	config.grid_height = 8
	BattleConfig._build_party_units(config)

	var seraph := load("res://resources/enemies/seraph.tres")
	var arch_hellion := load("res://resources/enemies/arch_hellion.tres")
	var void_prowler := load("res://resources/enemies/void_prowler.tres")
	var gloom := load("res://resources/enemies/gloom_stalker.tres")
	config.enemy_units = [
		{"data": seraph, "name": "Sera", "pos": Vector2i(9, 3), "level": 6},
		{"data": arch_hellion, "name": "Ares", "pos": Vector2i(9, 5), "level": 6},
		{"data": void_prowler, "name": "Shadow Guard", "pos": Vector2i(8, 1), "level": 6},
		{"data": void_prowler, "name": "Shadow Guard", "pos": Vector2i(8, 5), "level": 6},
		{"data": gloom, "name": "Gloom Warden", "pos": Vector2i(8, 3), "level": 6},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The eastern rampart. A divine warrior and a fire lord guard the passage side by side."},
		{"speaker": "Thane", "text": "Different powers, same orders. Whoever hired them has reach."},
	]
	config.post_battle_dialogue = [
		{"speaker": "Sera", "text": "The gate is yours. What stands at the fire shrine beyond — that was not our doing."},
	]
	return config


static func create_return_city_2() -> BattleConfig:
	# North Gate — The Scholar Quarter: Necromancer + Witch pair
	var config := BattleConfig.new()
	config.battle_id = "return_city_2"
	config.grid_width = 10
	config.grid_height = 8
	BattleConfig._build_party_units(config)

	var necromancer := load("res://resources/enemies/necromancer.tres")
	var elder_witch := load("res://resources/enemies/elder_witch.tres")
	var void_shade := load("res://resources/enemies/void_shade.tres")
	var dread_wraith := load("res://resources/enemies/dread_wraith.tres")
	config.enemy_units = [
		{"data": necromancer, "name": "Arin", "pos": Vector2i(9, 3), "level": 6},
		{"data": elder_witch, "name": "Nira", "pos": Vector2i(9, 5), "level": 6},
		{"data": void_shade, "name": "Pale Shade", "pos": Vector2i(8, 1), "level": 6},
		{"data": void_shade, "name": "Pale Shade", "pos": Vector2i(8, 5), "level": 6},
		{"data": dread_wraith, "name": "Street Shade", "pos": Vector2i(8, 3), "level": 6},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The scholar quarter. A necromancer and a witch have filled the streets with their workings — dead and nature, tangled together."},
		{"speaker": "Elara", "text": "The tides shrine lies beyond. We have to break through."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "Nature and death both go silent. The north road is open."},
	]
	return config


static func create_return_city_3() -> BattleConfig:
	# West Gate — The Forge District: Psion + Runewright (guard_scholar) pair
	var config := BattleConfig.new()
	config.battle_id = "return_city_3"
	config.grid_width = 10
	config.grid_height = 8
	BattleConfig._build_party_units(config)

	var psion := load("res://resources/enemies/psion.tres")
	var scholar := load("res://resources/enemies/guard_scholar.tres")
	var void_prowler := load("res://resources/enemies/void_prowler.tres")
	var gloom := load("res://resources/enemies/gloom_stalker.tres")
	config.enemy_units = [
		{"data": psion, "name": "Elan", "pos": Vector2i(9, 3), "level": 6},
		{"data": scholar, "name": "Nale", "pos": Vector2i(9, 5), "level": 6},
		{"data": void_prowler, "name": "Shadow Guard", "pos": Vector2i(8, 1), "level": 6},
		{"data": void_prowler, "name": "Shadow Guard", "pos": Vector2i(8, 5), "level": 6},
		{"data": gloom, "name": "Gloom Warden", "pos": Vector2i(8, 3), "level": 6},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The forge district. Warding circles on every wall — a psion and a runewright have locked the road down."},
		{"speaker": "Lyris", "text": "Mind and rune. Do not stand still."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The wards collapse. West road clear."},
	]
	return config


static func create_return_city_4() -> BattleConfig:
	# South Gate — The Temple Road: Warlock + Shaman pair
	var config := BattleConfig.new()
	config.battle_id = "return_city_4"
	config.grid_width = 10
	config.grid_height = 8
	BattleConfig._build_party_units(config)

	var warlock := load("res://resources/enemies/warlock.tres")
	var shaman := load("res://resources/enemies/shaman.tres")
	var void_shade := load("res://resources/enemies/void_shade.tres")
	var void_s := load("res://resources/enemies/void_stalker.tres")
	config.enemy_units = [
		{"data": warlock, "name": "Alis", "pos": Vector2i(9, 3), "level": 6},
		{"data": shaman, "name": "Sila", "pos": Vector2i(9, 5), "level": 6},
		{"data": void_shade, "name": "Shadow Pact", "pos": Vector2i(8, 1), "level": 6},
		{"data": void_shade, "name": "Shadow Pact", "pos": Vector2i(8, 5), "level": 6},
		{"data": void_s, "name": "Void Gate", "pos": Vector2i(8, 3), "level": 6},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The temple road. A warlock and a shaman hold the crossing — pact and spirit, pulling in the same direction."},
		{"speaker": "Aldric", "text": "The stone shrine lies under the temple. We go through them."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The pact unravels. The temple road is ours."},
	]
	return config


static func create_elemental_1() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "elemental_1"
	config.grid_width = 12
	config.grid_height = 10
	BattleConfig._build_party_units(config)

	# Shrine of Flames: mono-fire (1 lead lvl 8 + 4 lesser lvl 7)
	var fire_elem := load("res://resources/enemies/fire_elemental.tres")
	config.enemy_units = [
		{"data": fire_elem, "name": "Pyraxis", "pos": Vector2i(11, 5), "level": 8},
		{"data": fire_elem, "name": "Ember", "pos": Vector2i(10, 2), "level": 7},
		{"data": fire_elem, "name": "Cinder", "pos": Vector2i(10, 5), "level": 7},
		{"data": fire_elem, "name": "Flicker", "pos": Vector2i(10, 8), "level": 7},
		{"data": fire_elem, "name": "Ash", "pos": Vector2i(11, 3), "level": 7},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "A fire elemental towers above the shrine — four lesser flames circle it. The air itself is burning."},
		{"speaker": "Elara", "text": "We end this."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "Pyraxis crashes down. Sunlight breaks through smoke."},
		{"speaker": "", "text": "On a rooftop above — a figure. Watching. A single nod. Then gone."},
		{"speaker": "Aldric", "text": "Every step. That same presence."},
	]
	return config


static func create_elemental_2() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "elemental_2"
	config.grid_width = 12
	config.grid_height = 10
	BattleConfig._build_party_units(config)

	# Shrine of Tides: mono-water (1 lead lvl 8 + 4 lesser lvl 7)
	var water_elem := load("res://resources/enemies/water_elemental.tres")
	config.enemy_units = [
		{"data": water_elem, "name": "Undine the Deep", "pos": Vector2i(11, 5), "level": 8},
		{"data": water_elem, "name": "Ripple", "pos": Vector2i(10, 2), "level": 7},
		{"data": water_elem, "name": "Surge", "pos": Vector2i(10, 5), "level": 7},
		{"data": water_elem, "name": "Torrent", "pos": Vector2i(10, 8), "level": 7},
		{"data": water_elem, "name": "Tide", "pos": Vector2i(11, 3), "level": 7},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The shrine floods with water. An immense elemental rises — four currents circle it."},
		{"speaker": "Thane", "text": "Someone pulled every elemental in the city to the same purpose."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The tides recede. Water drains away."},
		{"speaker": "", "text": "On the rooftop — a nod. The same one."},
	]
	return config


static func create_elemental_3() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "elemental_3"
	config.grid_width = 12
	config.grid_height = 10
	BattleConfig._build_party_units(config)

	# Shrine of Winds: mono-air (1 lead lvl 8 + 4 lesser lvl 7)
	var air_elem := load("res://resources/enemies/air_elemental.tres")
	config.enemy_units = [
		{"data": air_elem, "name": "Gale Lord", "pos": Vector2i(11, 5), "level": 8},
		{"data": air_elem, "name": "Gust", "pos": Vector2i(10, 2), "level": 7},
		{"data": air_elem, "name": "Squall", "pos": Vector2i(10, 5), "level": 7},
		{"data": air_elem, "name": "Zephyr", "pos": Vector2i(10, 8), "level": 7},
		{"data": air_elem, "name": "Drift", "pos": Vector2i(11, 3), "level": 7},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "A vortex fills the shrine chamber. The lead elemental is at its center — four lesser winds orbit in a tightening spiral."},
		{"speaker": "Lyris", "text": "We are in the eye of it. No retreating."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "The vortex dies. Wind fades. The city breathes."},
		{"speaker": "", "text": "A figure on the rooftop gives one nod — then disappears."},
	]
	return config


static func create_elemental_4() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "elemental_4"
	config.grid_width = 12
	config.grid_height = 10
	BattleConfig._build_party_units(config)

	# Shrine of Stone: mono-earth (1 lead lvl 8 + 4 lesser lvl 7)
	var earth_elem := load("res://resources/enemies/earth_elemental.tres")
	config.enemy_units = [
		{"data": earth_elem, "name": "Terrath", "pos": Vector2i(11, 5), "level": 8},
		{"data": earth_elem, "name": "Rubble", "pos": Vector2i(10, 2), "level": 7},
		{"data": earth_elem, "name": "Gravel", "pos": Vector2i(10, 5), "level": 7},
		{"data": earth_elem, "name": "Shard", "pos": Vector2i(10, 8), "level": 7},
		{"data": earth_elem, "name": "Stone", "pos": Vector2i(11, 3), "level": 7},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The temple floor has split open. An earth elemental rose from below — and four lesser forms with it."},
		{"speaker": "Aldric", "text": "If this is how it ends —"},
		{"speaker": "Thane", "text": "It is not."},
	]
	config.post_battle_dialogue = [
		{"speaker": "", "text": "Terrath crumbles. The ground goes still."},
		{"speaker": "", "text": "The figure that has been watching since the crossroads — always the same rooftop, always the same nod — is gone."},
		{"speaker": "Elara", "text": "The castle."},
	]
	return config


static func create_final_castle() -> BattleConfig:
	var config := BattleConfig.new()
	config.battle_id = "final_castle"
	config.grid_width = 14
	config.grid_height = 12
	BattleConfig._build_party_units(config)

	# The Stranger — final boss — plus elite castle guard. Level 8.
	var stranger := load("res://resources/enemies/the_stranger.tres")
	var guard_mage := load("res://resources/enemies/guard_mage.tres")
	var guard_squire := load("res://resources/enemies/guard_squire.tres")
	config.enemy_units = [
		{"data": stranger, "name": "The Stranger", "pos": Vector2i(12, 5), "level": 8},
		{"data": guard_mage, "name": "Valdris", "pos": Vector2i(12, 2), "level": 8},
		{"data": guard_mage, "name": "Valdris", "pos": Vector2i(12, 8), "level": 8},
		{"data": guard_squire, "name": "Aldous", "pos": Vector2i(11, 3), "level": 8},
		{"data": guard_squire, "name": "Edmund", "pos": Vector2i(11, 7), "level": 8},
	]

	config.pre_battle_dialogue = [
		{"speaker": "", "text": "The throne room. The Stranger stands at its center, hood down at last. A face you have not seen before — but a voice you recognize from the note in the forest."},
		{"speaker": "The Stranger", "text": "You made it. All of you. The forest, the shrines, the Mirror. I watched every step."},
		{"speaker": "Aldric", "text": "You set those elementals loose. You built the encampment. Why?"},
		{"speaker": "The Stranger", "text": "Because the city needed defenders, not mourners. I built the trials. You passed them. Now comes the final test — whether you can stop me."},
		{"speaker": "", "text": "He raises his staff. The royal guard falls into formation."},
	]
	config.post_battle_dialogue = [
		{"speaker": "The Stranger", "text": "...Good. That is the answer I needed."},
		{"speaker": "", "text": "He lowers his staff. The corruption fades from his eyes — whatever drove him to this, it is over."},
		{"speaker": "The Stranger", "text": "The city is safe. You have proven that. Whatever comes next — you are ready for it."},
		{"speaker": "", "text": "The throne room is quiet. Outside, the city breathes."},
		{"speaker": "", "text": "Every choice left an echo. Yours will ring through the ages."},
	]
	return config

