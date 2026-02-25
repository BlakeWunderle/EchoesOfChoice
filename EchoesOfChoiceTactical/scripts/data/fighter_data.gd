class_name FighterData extends Resource

@export var class_id: String
@export var class_display_name: String
@export var sprite_id: String = ""
@export var sprite_id_female: String = ""

@export_group("Base Stats")
@export var base_max_health: int = 50
@export var base_max_mana: int = 20
@export var base_physical_attack: int = 10
@export var base_physical_defense: int = 8
@export var base_magic_attack: int = 5
@export var base_magic_defense: int = 5
@export var base_speed: int = 8
@export var base_crit_chance: int = 1
@export var base_crit_damage: int = 5
@export var base_dodge_chance: int = 1

@export_group("Growth Per Level")
@export var growth_health: int = 8
@export var growth_mana: int = 3
@export var growth_physical_attack: int = 2
@export var growth_physical_defense: int = 2
@export var growth_magic_attack: int = 1
@export var growth_magic_defense: int = 1
@export var growth_speed: int = 1

@export_group("Movement")
@export var movement: int = 4
@export var jump: int = 2

@export_group("Reactions")
@export var reaction_types: Array[Enums.ReactionType] = []

@export_group("Abilities")
@export var abilities: Array[AbilityData] = []

@export_group("Upgrades")
@export var tier: int = 0
@export var upgrade_options: Array[FighterData] = []


func calculate_stat(base: int, growth: int, level: int) -> int:
	return base + growth * (level - 1)


func get_stats_at_level(level: int) -> Dictionary:
	return {
		"max_health": calculate_stat(base_max_health, growth_health, level),
		"max_mana": calculate_stat(base_max_mana, growth_mana, level),
		"physical_attack": calculate_stat(base_physical_attack, growth_physical_attack, level),
		"physical_defense": calculate_stat(base_physical_defense, growth_physical_defense, level),
		"magic_attack": calculate_stat(base_magic_attack, growth_magic_attack, level),
		"magic_defense": calculate_stat(base_magic_defense, growth_magic_defense, level),
		"speed": calculate_stat(base_speed, growth_speed, level),
		"crit_chance": base_crit_chance,
		"crit_damage": base_crit_damage,
		"dodge_chance": base_dodge_chance,
		"movement": movement,
		"jump": jump,
	}
