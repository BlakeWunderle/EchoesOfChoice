class_name AbilityData extends Resource

@export var ability_name: String
@export var flavor_text: String
@export var modified_stat: Enums.StatType
@export var modifier: int
@export var impacted_turns: int = 0
@export var use_on_enemy: bool = true
@export var mana_cost: int = 0

@export_group("Targeting")
@export var target_scope: Enums.TargetScope = Enums.TargetScope.SINGLE
@export var requires_front_row: bool = false

@export_group("Type")
@export var ability_type: Enums.AbilityType = Enums.AbilityType.DAMAGE


func is_heal() -> bool:
	return ability_type == Enums.AbilityType.HEAL


func is_buff_or_debuff() -> bool:
	return ability_type == Enums.AbilityType.BUFF or ability_type == Enums.AbilityType.DEBUFF
