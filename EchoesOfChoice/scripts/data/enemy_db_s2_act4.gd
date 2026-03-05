class_name EnemyDBS2Act4

## Story 2 Act IV enemy factory: the Eye's domain.

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
# The Eye's servants (level 14)
# =============================================================================

static func create_gaze_stalker(n: String, lvl: int = 14) -> FighterData:
	var f := _base(n, "Gaze Stalker", lvl)
	f.health = _es(130, 148, 5, 7, lvl, 14); f.max_health = f.health
	f.mana = _es(10, 14, 1, 2, lvl, 14); f.max_mana = f.mana
	f.physical_attack = _es(38, 44, 2, 4, lvl, 14)
	f.physical_defense = _es(18, 22, 1, 3, lvl, 14)
	f.magic_attack = _es(10, 14, 0, 2, lvl, 14)
	f.magic_defense = _es(16, 20, 1, 2, lvl, 14)
	f.speed = _es(34, 40, 2, 3, lvl, 14)
	f.crit_chance = 16; f.crit_damage = 3; f.dodge_chance = 14
	f.abilities = [EAB.piercing_gaze_strike(), EAB.focus_break()]
	return f


static func create_memory_harvester(n: String, lvl: int = 14) -> FighterData:
	var f := _base(n, "Memory Harvester", lvl)
	f.health = _es(140, 158, 5, 7, lvl, 14); f.max_health = f.health
	f.mana = _es(22, 26, 2, 4, lvl, 14); f.max_mana = f.mana
	f.physical_attack = _es(10, 14, 0, 2, lvl, 14)
	f.physical_defense = _es(14, 18, 1, 2, lvl, 14)
	f.magic_attack = _es(38, 44, 2, 4, lvl, 14)
	f.magic_defense = _es(22, 26, 2, 3, lvl, 14)
	f.speed = _es(28, 34, 2, 3, lvl, 14)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.harvest_thought(), EAB.mass_extraction()]
	return f


static func create_oblivion_shade(n: String, lvl: int = 14) -> FighterData:
	var f := _base(n, "Oblivion Shade", lvl)
	f.health = _es(120, 136, 4, 6, lvl, 14); f.max_health = f.health
	f.mana = _es(18, 22, 2, 3, lvl, 14); f.max_mana = f.mana
	f.physical_attack = _es(10, 14, 0, 2, lvl, 14)
	f.physical_defense = _es(12, 16, 1, 2, lvl, 14)
	f.magic_attack = _es(36, 42, 2, 4, lvl, 14)
	f.magic_defense = _es(20, 24, 2, 3, lvl, 14)
	f.speed = _es(32, 38, 2, 3, lvl, 14)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 16
	f.abilities = [EAB.wave_of_oblivion(), EAB.nihil_bolt()]
	return f


static func create_thoughtform_knight(n: String, lvl: int = 14) -> FighterData:
	var f := _base(n, "Thoughtform Knight", lvl)
	f.health = _es(190, 210, 6, 9, lvl, 14); f.max_health = f.health
	f.mana = _es(12, 16, 1, 2, lvl, 14); f.max_mana = f.mana
	f.physical_attack = _es(40, 46, 2, 4, lvl, 14)
	f.physical_defense = _es(28, 32, 2, 4, lvl, 14)
	f.magic_attack = _es(8, 11, 0, 1, lvl, 14)
	f.magic_defense = _es(22, 26, 2, 3, lvl, 14)
	f.speed = _es(22, 28, 1, 2, lvl, 14)
	f.crit_chance = 12; f.crit_damage = 3; f.dodge_chance = 6
	f.abilities = [EAB.memory_blade(), EAB.ironclad_will()]
	return f


# =============================================================================
# The Eye (level 15 bosses)
# =============================================================================

static func create_the_iris(n: String, lvl: int = 15) -> FighterData:
	var f := _base(n, "The Iris", lvl)
	f.health = _es(260, 290, 6, 9, lvl, 15); f.max_health = f.health
	f.mana = _es(28, 32, 2, 4, lvl, 15); f.max_mana = f.mana
	f.physical_attack = _es(14, 18, 0, 2, lvl, 15)
	f.physical_defense = _es(24, 28, 2, 3, lvl, 15)
	f.magic_attack = _es(48, 55, 3, 5, lvl, 15)
	f.magic_defense = _es(30, 34, 2, 4, lvl, 15)
	f.speed = _es(30, 36, 2, 3, lvl, 15)
	f.crit_chance = 14; f.crit_damage = 3; f.dodge_chance = 8
	f.abilities = [EAB.prismatic_blast(), EAB.refraction_beam(), EAB.crystalline_ward()]
	return f


static func create_the_lidless_eye(n: String, lvl: int = 15) -> FighterData:
	var f := _base(n, "The Lidless Eye", lvl)
	f.health = _es(220, 250, 5, 8, lvl, 15); f.max_health = f.health
	f.mana = _es(26, 30, 2, 4, lvl, 15); f.max_mana = f.mana
	f.physical_attack = _es(10, 14, 0, 2, lvl, 15)
	f.physical_defense = _es(20, 24, 2, 3, lvl, 15)
	f.magic_attack = _es(44, 50, 3, 5, lvl, 15)
	f.magic_defense = _es(26, 30, 2, 4, lvl, 15)
	f.speed = _es(28, 34, 2, 3, lvl, 15)
	f.crit_chance = 12; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.gaze_of_forgetting(), EAB.memory_devour(), EAB.final_blink()]
	return f
