class_name AbilityData extends Resource

## Mirrors C# Ability.cs — defines a single ability's properties.

const Enums := preload("res://scripts/data/enums.gd")

@export var ability_name: String
@export var flavor_text: String
@export var modified_stat: Enums.StatType
@export var modifier: int
@export var impacted_turns: int  ## 0 = instant damage/heal
@export var use_on_enemy: bool = true
@export var mana_cost: int
@export var target_all: bool = false
@export var damage_per_turn: int = 0
@export var life_steal_percent: float = 0.0


func get_description() -> String:
	var target: String
	if target_all:
		target = "All Enemies" if use_on_enemy else "All Allies"
	else:
		target = "Enemy" if use_on_enemy else "Ally"

	var effect: String
	if not use_on_enemy and impacted_turns == 0:
		effect = "Heals"
	elif impacted_turns > 0:
		var stat_name: String
		match modified_stat:
			Enums.StatType.ATTACK: stat_name = "Attack"
			Enums.StatType.DEFENSE: stat_name = "Defense"
			Enums.StatType.PHYSICAL_ATTACK: stat_name = "Physical Attack"
			Enums.StatType.PHYSICAL_DEFENSE: stat_name = "Physical Defense"
			Enums.StatType.MAGIC_ATTACK: stat_name = "Magic Attack"
			Enums.StatType.MAGIC_DEFENSE: stat_name = "Magic Defense"
			Enums.StatType.SPEED: stat_name = "Speed"
			Enums.StatType.DODGE_CHANCE: stat_name = "Dodge"
			Enums.StatType.TAUNT: stat_name = "Taunt"
			_: stat_name = "Stats"
		var verb: String = "Reduces" if use_on_enemy else "Boosts"
		effect = "%s %s for %d turn(s)" % [verb, stat_name, impacted_turns]
	else:
		match modified_stat:
			Enums.StatType.PHYSICAL_ATTACK: effect = "Physical damage"
			Enums.StatType.MAGIC_ATTACK: effect = "Magic damage"
			Enums.StatType.MIXED_ATTACK: effect = "Mixed damage"
			_: effect = "Damage"

	return "[%s] %s" % [target, effect]
