class_name EnemyDBS2Act3

## Story 2 Act III enemy factory: memory sanctum constructs.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const EAB := preload("res://scripts/data/enemy_ability_db_s2.gd")


static func _es(base_min: int, base_max: int, gmin: int, gmax: int, level: int, base_level: int = 1) -> int:
	var lvl: int = level - base_level
	var lo: int = base_min + lvl * gmin
	var hi: int = base_max + lvl * (gmax - 1)
	if hi <= lo:
		return lo
	return randi_range(lo, hi - 1)


static func _base(name: String, type: String, lvl: int) -> FighterData:
	var f := FighterData.new()
	f.character_name = name
	f.character_type = type
	f.class_id = type
	f.is_user_controlled = false
	f.level = lvl
	return f


# =============================================================================
# Sanctum guardians (levels 10-11)
# =============================================================================

static func create_memory_wisp(n: String, lvl: int = 10) -> FighterData:
	var f := _base(n, "Memory Wisp", lvl)
	f.health = _es(90, 105, 4, 6, lvl, 10); f.max_health = f.health
	f.mana = _es(16, 20, 2, 3, lvl, 10); f.max_mana = f.mana
	f.physical_attack = _es(8, 11, 0, 2, lvl, 10)
	f.physical_defense = _es(10, 14, 1, 2, lvl, 10)
	f.magic_attack = _es(30, 35, 2, 4, lvl, 10)
	f.magic_defense = _es(16, 20, 1, 3, lvl, 10)
	f.speed = _es(30, 36, 2, 3, lvl, 10)
	f.crit_chance = 8; f.crit_damage = 2; f.dodge_chance = 16
	f.abilities = [EAB.recall_bolt(), EAB.memory_drain()]
	return f


static func create_echo_sentinel(n: String, lvl: int = 10) -> FighterData:
	var f := _base(n, "Echo Sentinel", lvl)
	f.health = _es(145, 165, 5, 8, lvl, 10); f.max_health = f.health
	f.mana = _es(10, 14, 1, 2, lvl, 10); f.max_mana = f.mana
	f.physical_attack = _es(28, 33, 2, 3, lvl, 10)
	f.physical_defense = _es(24, 28, 2, 3, lvl, 10)
	f.magic_attack = _es(6, 9, 0, 1, lvl, 10)
	f.magic_defense = _es(18, 22, 1, 3, lvl, 10)
	f.speed = _es(22, 28, 1, 2, lvl, 10)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 5
	f.abilities = [EAB.crystal_strike(), EAB.ward_of_echoes()]
	return f


static func create_thought_eater(n: String, lvl: int = 11) -> FighterData:
	var f := _base(n, "Thought Eater", lvl)
	f.health = _es(120, 138, 4, 7, lvl, 11); f.max_health = f.health
	f.mana = _es(18, 22, 2, 4, lvl, 11); f.max_mana = f.mana
	f.physical_attack = _es(8, 11, 0, 2, lvl, 11)
	f.physical_defense = _es(12, 16, 1, 2, lvl, 11)
	f.magic_attack = _es(32, 37, 2, 4, lvl, 11)
	f.magic_defense = _es(20, 24, 2, 3, lvl, 11)
	f.speed = _es(28, 34, 2, 3, lvl, 11)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 12
	f.abilities = [EAB.mind_rend(), EAB.psychic_leech()]
	return f


static func create_grief_shade(n: String, lvl: int = 11) -> FighterData:
	var f := _base(n, "Grief Shade", lvl)
	f.health = _es(100, 115, 4, 6, lvl, 11); f.max_health = f.health
	f.mana = _es(16, 20, 2, 3, lvl, 11); f.max_mana = f.mana
	f.physical_attack = _es(10, 14, 0, 2, lvl, 11)
	f.physical_defense = _es(10, 14, 1, 2, lvl, 11)
	f.magic_attack = _es(28, 32, 2, 4, lvl, 11)
	f.magic_defense = _es(18, 22, 1, 3, lvl, 11)
	f.speed = _es(30, 36, 2, 3, lvl, 11)
	f.crit_chance = 8; f.crit_damage = 2; f.dodge_chance = 18
	f.abilities = [EAB.sorrows_touch(), EAB.wail_of_loss()]
	return f


static func create_hollow_watcher(n: String, lvl: int = 11) -> FighterData:
	var f := _base(n, "Hollow Watcher", lvl)
	f.health = _es(130, 148, 5, 7, lvl, 11); f.max_health = f.health
	f.mana = _es(12, 16, 1, 3, lvl, 11); f.max_mana = f.mana
	f.physical_attack = _es(30, 35, 2, 4, lvl, 11)
	f.physical_defense = _es(18, 22, 2, 3, lvl, 11)
	f.magic_attack = _es(10, 14, 0, 2, lvl, 11)
	f.magic_defense = _es(14, 18, 1, 2, lvl, 11)
	f.speed = _es(26, 32, 1, 3, lvl, 11)
	f.crit_chance = 14; f.crit_damage = 2; f.dodge_chance = 8
	f.abilities = [EAB.blind_strike(), EAB.sense_intent()]
	return f


# =============================================================================
# Deep sanctum enemies (levels 12-13)
# =============================================================================

static func create_mirror_self(n: String, lvl: int = 12) -> FighterData:
	var f := _base(n, "Mirror Self", lvl)
	f.health = _es(140, 160, 5, 7, lvl, 12); f.max_health = f.health
	f.mana = _es(16, 20, 2, 3, lvl, 12); f.max_mana = f.mana
	f.physical_attack = _es(33, 38, 2, 4, lvl, 12)
	f.physical_defense = _es(16, 20, 1, 3, lvl, 12)
	f.magic_attack = _es(33, 38, 2, 4, lvl, 12)
	f.magic_defense = _es(16, 20, 1, 3, lvl, 12)
	f.speed = _es(30, 36, 2, 3, lvl, 12)
	f.crit_chance = 14; f.crit_damage = 3; f.dodge_chance = 14
	f.abilities = [EAB.mirrored_slash(), EAB.reflected_spell()]
	return f


static func create_void_weaver(n: String, lvl: int = 12) -> FighterData:
	var f := _base(n, "Void Weaver", lvl)
	f.health = _es(125, 142, 4, 6, lvl, 12); f.max_health = f.health
	f.mana = _es(20, 24, 2, 4, lvl, 12); f.max_mana = f.mana
	f.physical_attack = _es(8, 11, 0, 2, lvl, 12)
	f.physical_defense = _es(12, 16, 1, 2, lvl, 12)
	f.magic_attack = _es(36, 42, 3, 5, lvl, 12)
	f.magic_defense = _es(24, 28, 2, 4, lvl, 12)
	f.speed = _es(28, 34, 2, 3, lvl, 12)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.void_bolt(), EAB.unravel()]
	return f


static func create_mnemonic_golem(n: String, lvl: int = 12) -> FighterData:
	var f := _base(n, "Mnemonic Golem", lvl)
	f.health = _es(175, 200, 6, 9, lvl, 12); f.max_health = f.health
	f.mana = _es(10, 14, 1, 2, lvl, 12); f.max_mana = f.mana
	f.physical_attack = _es(35, 40, 2, 4, lvl, 12)
	f.physical_defense = _es(26, 30, 2, 4, lvl, 12)
	f.magic_attack = _es(6, 9, 0, 1, lvl, 12)
	f.magic_defense = _es(20, 24, 2, 3, lvl, 12)
	f.speed = _es(18, 24, 1, 2, lvl, 12)
	f.crit_chance = 12; f.crit_damage = 3; f.dodge_chance = 4
	f.abilities = [EAB.memory_slam(), EAB.crystallize()]
	return f


# =============================================================================
# Act III boss enemies (level 13)
# =============================================================================

static func create_the_warden(n: String, lvl: int = 13) -> FighterData:
	var f := _base(n, "The Warden", lvl)
	f.health = _es(210, 235, 6, 9, lvl, 13); f.max_health = f.health
	f.mana = _es(22, 26, 2, 4, lvl, 13); f.max_mana = f.mana
	f.physical_attack = _es(14, 18, 0, 2, lvl, 13)
	f.physical_defense = _es(24, 28, 2, 3, lvl, 13)
	f.magic_attack = _es(42, 48, 3, 5, lvl, 13)
	f.magic_defense = _es(30, 34, 2, 4, lvl, 13)
	f.speed = _es(28, 34, 2, 3, lvl, 13)
	f.crit_chance = 12; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.sanctum_judgment(), EAB.barrier_of_ages(), EAB.purge_thought()]
	return f


static func create_fractured_protector(n: String, lvl: int = 13) -> FighterData:
	var f := _base(n, "Fractured Protector", lvl)
	f.health = _es(195, 220, 5, 8, lvl, 13); f.max_health = f.health
	f.mana = _es(20, 24, 2, 4, lvl, 13); f.max_mana = f.mana
	f.physical_attack = _es(36, 42, 2, 4, lvl, 13)
	f.physical_defense = _es(20, 24, 2, 3, lvl, 13)
	f.magic_attack = _es(34, 40, 2, 4, lvl, 13)
	f.magic_defense = _es(22, 26, 2, 3, lvl, 13)
	f.speed = _es(32, 38, 2, 3, lvl, 13)
	f.crit_chance = 14; f.crit_damage = 3; f.dodge_chance = 12
	f.abilities = [EAB.desperate_strike(), EAB.memory_seal(), EAB.forgetting_touch()]
	return f
