class_name XpConfig

const BASE_ABILITY_XP := 10
const BASIC_ATTACK_BONUS_XP := 5
const KILL_BONUS_XP := 8
const CRIT_BONUS_XP := 3

const BASE_JP := 1
const IDENTITY_JP := 5

const TIER_1_JP_THRESHOLD := 50
const TIER_2_JP_THRESHOLD := 100

# ability_type and/or modified_stat values that count as identity actions per class_id
# Each entry is a dictionary with optional keys "ability_types" and "stat_types".
# If the used ability matches ANY listed type or stat, it's an identity action.
const CLASS_IDENTITY: Dictionary = {
	"squire": {
		"ability_types": [Enums.AbilityType.BUFF],
		"stat_types": [Enums.StatType.PHYSICAL_ATTACK],
	},
	"mage": {
		"stat_types": [Enums.StatType.MAGIC_ATTACK],
	},
	"entertainer": {
		"ability_types": [Enums.AbilityType.DEBUFF, Enums.AbilityType.BUFF],
	},
	"tinker": {
		"ability_types": [Enums.AbilityType.DEBUFF],
		"stat_types": [Enums.StatType.MAGIC_ATTACK],
	},
	"acolyte": {
		"ability_types": [Enums.AbilityType.HEAL, Enums.AbilityType.BUFF],
	},
	"wildling": {
		"ability_types": [Enums.AbilityType.DEBUFF, Enums.AbilityType.TERRAIN],
		"stat_types": [],
	},
}


static func xp_to_next_level(current_level: int) -> int:
	return current_level * 100


static func get_catchup_multiplier(unit_level: int, progression_stage: int) -> float:
	var expected := progression_stage + 1
	var delta := unit_level - expected
	if delta <= -2:
		return 2.0
	elif delta == -1:
		return 1.5
	elif delta == 0:
		return 1.0
	elif delta == 1:
		return 0.5
	else:
		return 0.1


static func is_identity_action(class_id: String, ability: AbilityData) -> bool:
	var identity: Dictionary = CLASS_IDENTITY.get(class_id, {})
	if identity.is_empty():
		return false
	var valid_types: Array = identity.get("ability_types", [])
	if ability.ability_type in valid_types:
		return true
	var valid_stats: Array = identity.get("stat_types", [])
	if ability.modified_stat in valid_stats:
		return true
	return false


static func calculate_jp(class_id: String, ability: AbilityData) -> int:
	if is_identity_action(class_id, ability):
		return IDENTITY_JP
	return BASE_JP


static func is_basic_attack(ability: AbilityData) -> bool:
	return ability.mana_cost == 0 and ability.ability_type == Enums.AbilityType.DAMAGE
