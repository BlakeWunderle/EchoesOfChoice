class_name BattleUnit extends RefCounted

var unit_name: String
var class_id: String
var portrait_id: String = ""
var team: int  # Enums.Team
var row: int  # Enums.RowPosition
var level: int = 1

var max_health: int
var health: int
var max_mana: int
var mana: int
var physical_attack: int
var physical_defense: int
var magic_attack: int
var magic_defense: int
var speed: int
var crit_chance: int
var crit_damage: int
var dodge_chance: int

var turn_counter: float = 0.0
var is_alive: bool = true
var has_acted: bool = false

var abilities: Array[AbilityData] = []
var modified_stats: Array = []

var xp: int = 0
var jp: int = 0


static func from_fighter_data(data: FighterData, p_name: String, p_level: int, p_team: int) -> BattleUnit:
	var unit := BattleUnit.new()
	unit.unit_name = p_name
	unit.class_id = data.class_id
	unit.portrait_id = data.portrait_id
	unit.team = p_team
	unit.row = data.preferred_row
	unit.level = p_level
	unit.abilities = data.abilities.duplicate()

	var stats := data.get_stats_at_level(p_level)
	unit.max_health = stats["max_health"]
	unit.health = unit.max_health
	unit.max_mana = stats["max_mana"]
	unit.mana = unit.max_mana
	unit.physical_attack = stats["physical_attack"]
	unit.physical_defense = stats["physical_defense"]
	unit.magic_attack = stats["magic_attack"]
	unit.magic_defense = stats["magic_defense"]
	unit.speed = stats["speed"]
	unit.crit_chance = stats["crit_chance"]
	unit.crit_damage = stats["crit_damage"]
	unit.dodge_chance = stats["dodge_chance"]

	return unit


func get_stats() -> Dictionary:
	return {
		"max_health": max_health,
		"max_mana": max_mana,
		"physical_attack": physical_attack,
		"physical_defense": physical_defense,
		"magic_attack": magic_attack,
		"magic_defense": magic_defense,
		"speed": speed,
		"crit_chance": crit_chance,
		"crit_damage": crit_damage,
		"dodge_chance": dodge_chance,
	}


func take_damage(amount: int) -> int:
	var actual := mini(amount, health)
	health -= actual
	if health <= 0:
		health = 0
		is_alive = false
	return actual


func heal_hp(amount: int) -> int:
	var actual := mini(amount, max_health - health)
	health += actual
	return actual


func restore_mana(amount: int) -> int:
	var actual := mini(amount, max_mana - mana)
	mana += actual
	return actual


func spend_mana(cost: int) -> bool:
	if mana < cost:
		return false
	mana -= cost
	return true


func can_use_ability(ability: AbilityData) -> bool:
	return mana >= ability.mana_cost


func get_hp_ratio() -> float:
	if max_health <= 0:
		return 0.0
	return float(health) / float(max_health)


func get_mp_ratio() -> float:
	if max_mana <= 0:
		return 0.0
	return float(mana) / float(max_mana)


func get_atb_ratio() -> float:
	return clampf(turn_counter / 100.0, 0.0, 1.0)


func is_back_row() -> bool:
	return row == Enums.RowPosition.BACK


func apply_stat_modifier(stat: int, amount: int) -> void:
	match stat:
		Enums.StatType.PHYSICAL_ATTACK: physical_attack += amount
		Enums.StatType.PHYSICAL_DEFENSE: physical_defense += amount
		Enums.StatType.MAGIC_ATTACK: magic_attack += amount
		Enums.StatType.MAGIC_DEFENSE: magic_defense += amount
		Enums.StatType.SPEED: speed += amount
		Enums.StatType.DODGE_CHANCE: dodge_chance += amount
		Enums.StatType.CRIT_CHANCE: crit_chance += amount
		Enums.StatType.CRIT_DAMAGE: crit_damage += amount
		Enums.StatType.MAX_HEALTH:
			max_health += amount
			if amount > 0:
				health += amount


func tick_modifiers() -> void:
	var i := modified_stats.size() - 1
	while i >= 0:
		var mod: ModifiedStat = modified_stats[i]
		mod.turns_remaining -= 1
		if mod.turns_remaining <= 0:
			apply_stat_modifier(mod.stat, -mod.modifier)
			modified_stats.remove_at(i)
		i -= 1


func start_turn() -> void:
	has_acted = false


func end_turn() -> void:
	tick_modifiers()
