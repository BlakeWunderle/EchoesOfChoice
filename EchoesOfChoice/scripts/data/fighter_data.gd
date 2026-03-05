class_name FighterData extends RefCounted

## Mirrors C# BaseFighter. A live fighter instance with mutable combat state.

const Enums := preload("res://scripts/data/enums.gd")
const _FighterDB := preload("res://scripts/data/fighter_db.gd")

var character_name: String
var character_type: String  ## Class display name (e.g. "Squire", "Thug")
var class_id: String        ## Internal class key for save/load and level-up routing
var is_user_controlled: bool

var level: int = 1
var health: int
var max_health: int
var mana: int
var max_mana: int
var physical_attack: int
var physical_defense: int
var magic_attack: int
var magic_defense: int
var speed: int
var crit_chance: int
var crit_damage: int
var dodge_chance: int

var turn_calculation: int = 0  ## ATB accumulator
var abilities: Array = []  ## Array of AbilityData
var modified_stats: Array[Dictionary] = []  ## {stat, modifier, turns, is_negative, damage_per_turn}
var ability_cooldowns: Dictionary = {}      ## ability_name -> remaining turns
var upgrade_items: Array[String] = []       ## For class upgrade paths


func clone() -> FighterData:
	var c := FighterData.new()
	c.character_name = character_name
	c.character_type = character_type
	c.class_id = class_id
	c.is_user_controlled = is_user_controlled
	c.level = level
	c.health = health; c.max_health = max_health
	c.mana = mana; c.max_mana = max_mana
	c.physical_attack = physical_attack
	c.physical_defense = physical_defense
	c.magic_attack = magic_attack
	c.magic_defense = magic_defense
	c.speed = speed
	c.crit_chance = crit_chance
	c.crit_damage = crit_damage
	c.dodge_chance = dodge_chance
	c.abilities = abilities.duplicate()
	c.ability_cooldowns = ability_cooldowns.duplicate()
	c.upgrade_items = upgrade_items.duplicate()
	return c


func reset_for_battle() -> void:
	health = max_health
	mana = max_mana
	turn_calculation = 0
	ability_cooldowns.clear()
	# Revert any lingering stat mods
	for mod: Dictionary in modified_stats:
		_revert_mod(mod)
	modified_stats.clear()


func _revert_mod(mod: Dictionary) -> void:
	if mod.get("damage_per_turn", 0) > 0:
		return  # DoT mods don't change stats
	var stat: Enums.StatType = mod["stat"]
	var amount: int = mod["modifier"]
	var is_neg: bool = mod["is_negative"]
	# Reverse the original application
	_apply_stat_change(stat, amount, not is_neg)


func _apply_stat_change(stat: Enums.StatType, amount: int, negative: bool) -> void:
	var sign_val: int = -1 if negative else 1
	match stat:
		Enums.StatType.ATTACK:
			physical_attack += amount * sign_val
			magic_attack += amount * sign_val
		Enums.StatType.DEFENSE:
			physical_defense += amount * sign_val
			magic_defense += amount * sign_val
		Enums.StatType.PHYSICAL_ATTACK:
			physical_attack += amount * sign_val
		Enums.StatType.PHYSICAL_DEFENSE:
			physical_defense += amount * sign_val
		Enums.StatType.MAGIC_ATTACK:
			magic_attack += amount * sign_val
		Enums.StatType.MAGIC_DEFENSE:
			magic_defense += amount * sign_val
		Enums.StatType.SPEED:
			speed += amount * sign_val
		Enums.StatType.MIXED_ATTACK:
			physical_attack += amount * sign_val
			magic_attack += amount * sign_val
		Enums.StatType.DODGE_CHANCE:
			dodge_chance += amount * sign_val
	_clamp_stats()


func _clamp_stats() -> void:
	physical_attack = maxi(0, physical_attack)
	physical_defense = maxi(0, physical_defense)
	magic_attack = maxi(0, magic_attack)
	magic_defense = maxi(0, magic_defense)
	speed = maxi(1, speed)
	dodge_chance = clampi(dodge_chance, 0, 50)
	crit_chance = clampi(crit_chance, 0, 50)


func to_save_data() -> Dictionary:
	return {
		"class_id": class_id,
		"character_name": character_name,
		"character_type": character_type,
		"is_user_controlled": is_user_controlled,
		"level": level,
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
		"upgrade_items": upgrade_items,
	}


func apply_save_data(data: Dictionary) -> void:
	class_id = data.get("class_id", "")
	character_name = data["character_name"]
	character_type = data.get("character_type", "")
	is_user_controlled = data["is_user_controlled"]
	level = data["level"]
	max_health = data["max_health"]
	health = max_health
	max_mana = data["max_mana"]
	mana = max_mana
	physical_attack = data["physical_attack"]
	physical_defense = data["physical_defense"]
	magic_attack = data["magic_attack"]
	magic_defense = data["magic_defense"]
	speed = data["speed"]
	crit_chance = data["crit_chance"]
	crit_damage = data["crit_damage"]
	dodge_chance = data["dodge_chance"]
	var saved_items = data.get("upgrade_items", [])
	upgrade_items.clear()
	if saved_items.is_empty():
		upgrade_items = _FighterDB.get_default_upgrade_items(class_id)
	else:
		for item in saved_items:
			upgrade_items.append(item)
