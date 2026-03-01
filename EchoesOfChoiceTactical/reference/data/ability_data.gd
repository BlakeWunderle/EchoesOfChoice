class_name AbilityData extends Resource

@export var ability_name: String
@export var flavor_text: String
@export var modified_stat: Enums.StatType
@export var modifier: int
@export var impacted_turns: int = 0
@export var use_on_enemy: bool = true
@export var mana_cost: int = 0

@export_group("Spatial")
@export var ability_range: int = 1
@export var aoe_shape: Enums.AoEShape = Enums.AoEShape.SINGLE
@export var aoe_size: int = 0

@export_group("Type")
@export var ability_type: Enums.AbilityType = Enums.AbilityType.DAMAGE

@export_group("Terrain")
@export var terrain_tile: Enums.TileType = Enums.TileType.FLOOR
@export var terrain_duration: int = 0


func is_terrain_ability() -> bool:
	return ability_type == Enums.AbilityType.TERRAIN


func is_heal() -> bool:
	return ability_type == Enums.AbilityType.HEAL


func is_buff_or_debuff() -> bool:
	return ability_type == Enums.AbilityType.BUFF or ability_type == Enums.AbilityType.DEBUFF


func get_effective_range(elevation_advantage: int) -> int:
	if ability_range < 2:
		return ability_range
	return ability_range + maxi(elevation_advantage, 0)
