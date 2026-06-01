class_name EnemyDBS2Act3

## Story 2 Act III enemy factory: memory sanctum constructs.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const EABL := preload("res://scripts/data/story2/enemy_ability_db_s2_late.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# Sanctum guardians (levels 10-11) -- used by P10, P11
# =============================================================================

static func create_memory_wisp(n: String, lvl: int = 10) -> FighterData:
	var f := EH.base(n, "Memory Wisp", lvl)
	f.health = EH.es(314, 369, 3, 6, lvl, 10); f.max_health = f.health
	f.mana = EH.es(32, 38, 2, 4, lvl, 10); f.max_mana = f.mana
	f.physical_attack = EH.es(17, 21, 0, 2, lvl, 10)
	f.physical_defense = EH.es(19, 26, 1, 3, lvl, 10)
	f.magic_attack = EH.es(73, 83, 2, 4, lvl, 10)
	f.magic_defense = EH.es(34, 41, 2, 3, lvl, 10)
	f.speed = EH.es(39, 45, 2, 3, lvl, 10)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 25
	f.abilities = [EABL.recall_bolt(), EABL.memory_drain()]
	f.flavor_text = "A shimmering fragment of someone's forgotten recollection, given form and hunger. It feeds on the memories of the living."
	return f


static func create_shattered_frame(n: String, lvl: int = 10) -> FighterData:
	var f := EH.base(n, "Shattered Frame", lvl)
	f.health = EH.es(294, 346, 2, 5, lvl, 10); f.max_health = f.health
	f.mana = EH.es(32, 38, 2, 4, lvl, 10); f.max_mana = f.mana
	f.physical_attack = EH.es(17, 21, 0, 2, lvl, 10)
	f.physical_defense = EH.es(21, 28, 1, 3, lvl, 10)
	f.magic_attack = EH.es(96, 106, 2, 4, lvl, 10)
	f.magic_defense = EH.es(32, 39, 2, 3, lvl, 10)
	f.speed = EH.es(50, 56, 2, 3, lvl, 10)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EABL.mirror_shard(), EABL.dissonant_echo()]
	f.flavor_text = "An ornate mirror frame that has torn itself from the echo gallery's walls and learned to hunt. Its cracked glass shows scenes that never happened, or perhaps already did."
	return f


static func create_echo_sentinel(n: String, lvl: int = 10) -> FighterData:
	var f := EH.base(n, "Echo Sentinel", lvl)
	f.health = EH.es(419, 478, 4, 6, lvl, 10); f.max_health = f.health
	f.mana = EH.es(21, 30, 3, 3, lvl, 10); f.max_mana = f.mana
	f.physical_attack = EH.es(67, 76, 2, 4, lvl, 10)
	f.physical_defense = EH.es(47, 54, 2, 3, lvl, 10)
	f.magic_attack = EH.es(15, 19, 0, 1, lvl, 10)
	f.magic_defense = EH.es(29, 37, 1, 3, lvl, 10)
	f.speed = EH.es(36, 42, 1, 2, lvl, 10)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EABL.crystal_strike(), EABL.ward_of_echoes()]
	f.flavor_text = "A towering construct of solidified memory, shaped like an armored knight. It guards the sanctum's corridors with relentless vigilance."
	return f


static func create_thought_eater(n: String, lvl: int = 11) -> FighterData:
	var f := EH.base(n, "Thought Eater", lvl)
	f.health = EH.es(374, 430, 3, 6, lvl, 11); f.max_health = f.health
	f.mana = EH.es(34, 40, 2, 4, lvl, 11); f.max_mana = f.mana
	f.physical_attack = EH.es(17, 21, 0, 2, lvl, 11)
	f.physical_defense = EH.es(24, 30, 1, 3, lvl, 11)
	f.magic_attack = EH.es(92, 104, 2, 5, lvl, 11)
	f.magic_defense = EH.es(40, 47, 2, 3, lvl, 11)
	f.speed = EH.es(43, 49, 2, 3, lvl, 11)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 25
	f.abilities = [EABL.mind_rend(), EABL.psychic_leech()]
	f.flavor_text = "A formless psychic predator that burrows into the mind to consume thoughts whole. Victims feel their knowledge dissolving like mist."
	return f


static func create_grief_shade(n: String, lvl: int = 11) -> FighterData:
	var f := EH.base(n, "Grief Shade", lvl)
	f.health = EH.es(361, 414, 3, 5, lvl, 11); f.max_health = f.health
	f.mana = EH.es(32, 38, 2, 4, lvl, 11); f.max_mana = f.mana
	f.physical_attack = EH.es(19, 23, 0, 2, lvl, 11)
	f.physical_defense = EH.es(21, 28, 1, 2, lvl, 11)
	f.magic_attack = EH.es(86, 96, 2, 4, lvl, 11)
	f.magic_defense = EH.es(34, 41, 2, 3, lvl, 11)
	f.speed = EH.es(44, 50, 2, 3, lvl, 11)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [EABL.sorrows_touch(), EABL.wail_of_loss()]
	f.flavor_text = "A weeping shadow born from concentrated sorrow. Its touch carries the weight of every loss ever felt in this place."
	return f


static func create_sorrow_shade(n: String, lvl: int = 11) -> FighterData:
	var f := EH.base(n, "Sorrow Shade", lvl)
	f.health = EH.es(342, 394, 3, 4, lvl, 11); f.max_health = f.health
	f.mana = EH.es(38, 44, 2, 4, lvl, 11); f.max_mana = f.mana
	f.physical_attack = EH.es(20, 24, 0, 2, lvl, 11)
	f.physical_defense = EH.es(21, 28, 1, 2, lvl, 11)
	f.magic_attack = EH.es(96, 105, 2, 4, lvl, 11)
	f.magic_defense = EH.es(34, 41, 2, 3, lvl, 11)
	f.speed = EH.es(43, 49, 2, 3, lvl, 11)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [EABL.grief_surge(), EABL.shattered_trust()]
	f.flavor_text = "A shadow crystallized from the sanctum's deepest sorrows. Unlike grief shades born elsewhere, this one carries the weight of shattered memories and broken trust."
	return f


static func create_hollow_watcher(n: String, lvl: int = 11) -> FighterData:
	var f := EH.base(n, "Hollow Watcher", lvl)
	f.health = EH.es(346, 394, 4, 6, lvl, 11); f.max_health = f.health
	f.mana = EH.es(24, 33, 3, 3, lvl, 11); f.max_mana = f.mana
	f.physical_attack = EH.es(66, 73, 2, 4, lvl, 11)
	f.physical_defense = EH.es(32, 40, 2, 3, lvl, 11)
	f.magic_attack = EH.es(19, 23, 0, 2, lvl, 11)
	f.magic_defense = EH.es(29, 36, 1, 3, lvl, 11)
	f.speed = EH.es(44, 50, 1, 3, lvl, 11)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EABL.blind_strike(), EABL.sense_intent()]
	f.flavor_text = "A faceless guardian that perceives the world through stolen senses. It anticipates its enemies' movements before they act."
	return f


# =============================================================================
# Deep sanctum enemies (levels 12-13) -- used by P11
# =============================================================================

static func create_mirror_self(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Mirror Self", lvl)
	f.health = EH.es(334, 382, 3, 6, lvl, 12); f.max_health = f.health
	f.mana = EH.es(38, 44, 2, 4, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(88, 98, 2, 4, lvl, 12)
	f.physical_defense = EH.es(34, 42, 2, 3, lvl, 12)
	f.magic_attack = EH.es(88, 98, 2, 4, lvl, 12)
	f.magic_defense = EH.es(34, 42, 2, 3, lvl, 12)
	f.speed = EH.es(45, 51, 2, 3, lvl, 12)
	f.crit_chance = 25; f.crit_damage = 5; f.dodge_chance = 20
	f.abilities = [EABL.mirrored_slash(), EABL.reflected_spell()]
	f.flavor_text = "A perfect reflection of the one who gazes upon it. It fights with borrowed skill, turning your own strengths against you."
	return f


static func create_void_weaver(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Void Weaver", lvl)
	f.health = EH.es(370, 419, 3, 5, lvl, 12); f.max_health = f.health
	f.mana = EH.es(46, 54, 2, 4, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(18, 22, 0, 2, lvl, 12)
	f.physical_defense = EH.es(27, 34, 1, 3, lvl, 12)
	f.magic_attack = EH.es(98, 111, 3, 5, lvl, 12)
	f.magic_defense = EH.es(35, 42, 2, 4, lvl, 12)
	f.speed = EH.es(42, 48, 2, 3, lvl, 12)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EABL.void_bolt(), EABL.unravel()]
	f.flavor_text = "A spindly entity that weaves threads of nothingness between its fingers. Where its threads fall, memory and meaning unravel."
	return f


static func create_mnemonic_golem(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Mnemonic Golem", lvl)
	f.health = EH.es(466, 533, 5, 7, lvl, 12); f.max_health = f.health
	f.mana = EH.es(21, 30, 3, 3, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(94, 107, 3, 5, lvl, 12)
	f.physical_defense = EH.es(53, 62, 2, 4, lvl, 12)
	f.magic_attack = EH.es(16, 20, 0, 1, lvl, 12)
	f.magic_defense = EH.es(42, 49, 2, 3, lvl, 12)
	f.speed = EH.es(27, 33, 1, 2, lvl, 12)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EABL.memory_slam(), EABL.crystallize()]
	f.flavor_text = "A hulking automaton built from thousands of compressed memories. Each fist carries the petrified weight of forgotten lives."
	return f


# =============================================================================
# Act III boss enemies (level 13)
# =============================================================================

static func create_the_warden(n: String, lvl: int = 13) -> FighterData:
	var f := EH.base(n, "The Warden", lvl)
	f.health = EH.es(886, 1001, 9, 12, lvl, 13); f.max_health = f.health
	f.mana = EH.es(36, 44, 2, 4, lvl, 13); f.max_mana = f.mana
	f.physical_attack = EH.es(20, 24, 0, 2, lvl, 13)
	f.physical_defense = EH.es(38, 44, 2, 3, lvl, 13)
	f.magic_attack = EH.es(117, 129, 3, 5, lvl, 13)
	f.magic_defense = EH.es(47, 53, 2, 4, lvl, 13)
	f.speed = EH.es(51, 57, 2, 3, lvl, 13)
	f.crit_chance = 20; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EABL.sanctum_judgment(), EABL.barrier_of_ages(), EABL.decree_of_exile(), EABL.memory_verdict(), EABL.dispel_will()]
	f.flavor_text = "The sanctum's supreme guardian, an entity of crystallized law and ancient purpose. It judges all who enter and finds them wanting."
	return f


static func create_fractured_protector(n: String, lvl: int = 13) -> FighterData:
	var f := EH.base(n, "Fractured Protector", lvl)
	f.health = EH.es(831, 937, 7, 11, lvl, 13); f.max_health = f.health
	f.mana = EH.es(34, 40, 2, 4, lvl, 13); f.max_mana = f.mana
	f.physical_attack = EH.es(100, 110, 2, 4, lvl, 13)
	f.physical_defense = EH.es(32, 39, 2, 3, lvl, 13)
	f.magic_attack = EH.es(87, 98, 2, 4, lvl, 13)
	f.magic_defense = EH.es(35, 41, 2, 3, lvl, 13)
	f.speed = EH.es(53, 59, 2, 3, lvl, 13)
	f.crit_chance = 20; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EABL.corrupted_mending(), EABL.eye_infused_strike(), EABL.drowned_light(), EABL.memory_fracture(), EABL.fractured_blessing()]
	f.flavor_text = "Once a noble defender of the memory sanctum, now cracked and unstable. Her healing magic has been inverted by the Eye's corruption, burning instead of mending, taking instead of giving."
	return f


# =============================================================================
# P9: Beneath the Lighthouse (unique enemies)
# Wisps strip party mag_def, Guardian buffs team defense
# =============================================================================

static func create_fading_wisp(n: String, lvl: int = 10) -> FighterData:
	var f := EH.base(n, "Fading Wisp", lvl)
	f.health = EH.es(286, 326, 3, 6, lvl, 10); f.max_health = f.health
	f.mana = EH.es(32, 38, 2, 4, lvl, 10); f.max_mana = f.mana
	f.physical_attack = EH.es(61, 68, 2, 3, lvl, 10)
	f.physical_defense = EH.es(25, 31, 1, 3, lvl, 10)
	f.magic_attack = EH.es(64, 73, 2, 3, lvl, 10)
	f.magic_defense = EH.es(36, 43, 2, 3, lvl, 10)
	f.speed = EH.es(41, 47, 2, 3, lvl, 10)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 25
	f.abilities = [EABL.corrosive_flicker(), EABL.flickering_decay()]
	f.flavor_text = "A dying wisp that gutters like a candle in the wind. Its corrupted light clings to flesh and slowly eats away from within."
	return f


static func create_dim_guardian(n: String, lvl: int = 10) -> FighterData:
	var f := EH.base(n, "Dim Guardian", lvl)
	f.health = EH.es(315, 363, 3, 5, lvl, 10); f.max_health = f.health
	f.mana = EH.es(21, 30, 3, 3, lvl, 10); f.max_mana = f.mana
	f.physical_attack = EH.es(80, 90, 2, 4, lvl, 10)
	f.physical_defense = EH.es(33, 39, 1, 3, lvl, 10)
	f.magic_attack = EH.es(16, 20, 0, 1, lvl, 10)
	f.magic_defense = EH.es(29, 35, 1, 3, lvl, 10)
	f.speed = EH.es(36, 43, 1, 2, lvl, 10)
	f.crit_chance = 20; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EABL.fading_blow(), EABL.last_surge()]
	f.flavor_text = "A sentinel fading from existence, channeling its final reserves into desperate, devastating strikes rather than the defense it once held."
	return f


# =============================================================================
# P12 GT: Guardian's Threshold (unique enemies)
# Tank + taunt / magic + attack suppression / mixed + speed control
# =============================================================================

static func create_ward_construct(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Ward Construct", lvl)
	f.health = EH.es(427, 493, 5, 7, lvl, 12); f.max_health = f.health
	f.mana = EH.es(21, 30, 3, 3, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(116, 130, 3, 5, lvl, 12)
	f.physical_defense = EH.es(57, 66, 2, 4, lvl, 12)
	f.magic_attack = EH.es(20, 24, 0, 1, lvl, 12)
	f.magic_defense = EH.es(46, 54, 2, 3, lvl, 12)
	f.speed = EH.es(33, 40, 1, 2, lvl, 12)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EABL.reinforced_strike(), EABL.warding_presence()]
	f.flavor_text = "A massive stone construct bound by ancient wards. It was built to hold the threshold against any intrusion, and it has never failed."
	return f


static func create_null_phantom(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Null Phantom", lvl)
	f.health = EH.es(322, 370, 3, 6, lvl, 12); f.max_health = f.health
	f.mana = EH.es(40, 46, 2, 4, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(22, 26, 0, 2, lvl, 12)
	f.physical_defense = EH.es(29, 36, 1, 3, lvl, 12)
	f.magic_attack = EH.es(94, 105, 3, 5, lvl, 12)
	f.magic_defense = EH.es(51, 60, 2, 4, lvl, 12)
	f.speed = EH.es(42, 49, 2, 3, lvl, 12)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 25
	f.abilities = [EABL.null_lance(), EABL.nullification()]
	f.flavor_text = "A phantom of pure negation that erases whatever it touches. Magic withers in its presence, and even thoughts lose coherence."
	return f


static func create_threshold_echo(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Threshold Echo", lvl)
	f.health = EH.es(348, 398, 4, 6, lvl, 12); f.max_health = f.health
	f.mana = EH.es(32, 40, 2, 4, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(83, 94, 2, 4, lvl, 12)
	f.physical_defense = EH.es(35, 44, 2, 3, lvl, 12)
	f.magic_attack = EH.es(81, 92, 2, 4, lvl, 12)
	f.magic_defense = EH.es(35, 44, 2, 3, lvl, 12)
	f.speed = EH.es(43, 50, 2, 3, lvl, 12)
	f.crit_chance = 20; f.crit_damage = 3; f.dodge_chance = 20
	f.abilities = [EABL.liminal_strike(), EABL.threshold_bind()]
	f.flavor_text = "A repeating impression left at the boundary between memory and void. It strikes with the force of a moment that refuses to be forgotten."
	return f


# =============================================================================
# P12 FA: Forgotten Archive (unique enemies)
# Tank + taunt / magic + silence / magic + DoT / physical + defense debuff
# =============================================================================

static func create_ink_devourer(n: String, lvl: int = 11) -> FighterData:
	var f := EH.base(n, "Ink Devourer", lvl)
	f.health = EH.es(336, 392, 3, 5, lvl, 11); f.max_health = f.health
	f.mana = EH.es(32, 38, 2, 4, lvl, 11); f.max_mana = f.mana
	f.physical_attack = EH.es(19, 23, 0, 2, lvl, 11)
	f.physical_defense = EH.es(22, 28, 1, 2, lvl, 11)
	f.magic_attack = EH.es(110, 121, 2, 5, lvl, 11)
	f.magic_defense = EH.es(32, 40, 2, 3, lvl, 11)
	f.speed = EH.es(50, 56, 2, 3, lvl, 11)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 25
	f.abilities = [EABL.ink_lash(), EABL.devour_script()]
	f.flavor_text = "A glistening predator of living ink that slithers between the shelves. It consumed the forbidden texts and now hunts with their stolen knowledge."
	return f


static func create_silent_archivist(n: String, lvl: int = 11) -> FighterData:
	var f := EH.base(n, "Silent Archivist", lvl)
	f.health = EH.es(375, 427, 4, 6, lvl, 11); f.max_health = f.health
	f.mana = EH.es(24, 28, 2, 4, lvl, 11); f.max_mana = f.mana
	f.physical_attack = EH.es(23, 27, 0, 2, lvl, 11)
	f.physical_defense = EH.es(32, 40, 2, 3, lvl, 11)
	f.magic_attack = EH.es(99, 109, 3, 5, lvl, 11)
	f.magic_defense = EH.es(39, 46, 2, 3, lvl, 11)
	f.speed = EH.es(43, 49, 1, 3, lvl, 11)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EABL.archived_spell(), EABL.silence()]
	f.flavor_text = "A robed figure that glides between shelves of crystallized memory. It enforces silence with absolute authority, sealing the voices of intruders."
	return f


static func create_lost_record(n: String, lvl: int = 10) -> FighterData:
	var f := EH.base(n, "Lost Record", lvl)
	f.health = EH.es(291, 339, 4, 6, lvl, 10); f.max_health = f.health
	f.mana = EH.es(32, 40, 2, 4, lvl, 10); f.max_mana = f.mana
	f.physical_attack = EH.es(18, 22, 0, 2, lvl, 10)
	f.physical_defense = EH.es(24, 30, 1, 3, lvl, 10)
	f.magic_attack = EH.es(81, 93, 2, 5, lvl, 10)
	f.magic_defense = EH.es(34, 42, 2, 3, lvl, 10)
	f.speed = EH.es(44, 51, 2, 3, lvl, 10)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [EABL.fragmented_blast(), EABL.corrupted_text()]
	f.flavor_text = "A swirling mass of broken text and scattered data, once a coherent record of the past. Its fragmented knowledge strikes like shrapnel."
	return f


static func create_maw_codex(n: String, lvl: int = 11) -> FighterData:
	var f := EH.base(n, "Maw Codex", lvl)
	f.health = EH.es(392, 448, 4, 6, lvl, 11); f.max_health = f.health
	f.mana = EH.es(21, 30, 3, 3, lvl, 11); f.max_mana = f.mana
	f.physical_attack = EH.es(97, 107, 2, 4, lvl, 11)
	f.physical_defense = EH.es(30, 37, 2, 3, lvl, 11)
	f.magic_attack = EH.es(17, 21, 0, 1, lvl, 11)
	f.magic_defense = EH.es(28, 35, 1, 3, lvl, 11)
	f.speed = EH.es(41, 47, 1, 3, lvl, 11)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EABL.tome_bite(), EABL.knowledge_storm()]
	f.flavor_text = "A massive grimoire that has grown teeth and hunger. Its cover yawns open to reveal a gullet of razored pages that devour anything within reach."
	return f
