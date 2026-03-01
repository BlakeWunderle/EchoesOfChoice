class_name Combat

const CRIT_ROLL_MAX := 100
const DODGE_ROLL_MAX := 100


static func calculate_physical_damage(attacker_phys_atk: int, defender_phys_def: int) -> int:
	return maxi(attacker_phys_atk - defender_phys_def, 0)


static func calculate_magic_damage(modifier: int, attacker_mag_atk: int, defender_mag_def: int) -> int:
	return maxi(modifier + attacker_mag_atk - defender_mag_def, 0)


static func calculate_mixed_damage(modifier: int, attacker_phys: int, attacker_mag: int,
		defender_phys: int, defender_mag: int) -> int:
	var atk_avg := (attacker_phys + attacker_mag) / 2
	var def_avg := (defender_phys + defender_mag) / 2
	return maxi(modifier + atk_avg - def_avg, 0)


static func calculate_ability_damage(ability: AbilityData, attacker: Dictionary, defender: Dictionary) -> int:
	match ability.modified_stat:
		Enums.StatType.PHYSICAL_ATTACK:
			return calculate_physical_damage(
				ability.modifier + attacker["physical_attack"],
				defender["physical_defense"])
		Enums.StatType.MAGIC_ATTACK:
			return calculate_magic_damage(
				ability.modifier, attacker["magic_attack"],
				defender["magic_defense"])
		Enums.StatType.MIXED_ATTACK:
			return calculate_mixed_damage(
				ability.modifier,
				attacker["physical_attack"], attacker["magic_attack"],
				defender["physical_defense"], defender["magic_defense"])
	return 0


static func roll_crit(crit_chance: int) -> bool:
	var roll := randi_range(1, CRIT_ROLL_MAX)
	return roll > (CRIT_ROLL_MAX - crit_chance)


static func roll_dodge(dodge_chance: int) -> bool:
	var roll := randi_range(1, DODGE_ROLL_MAX)
	return roll <= dodge_chance


static func calculate_heal(ability: AbilityData, caster_mag_atk: int, caster_phys_atk: int = 0) -> int:
	if ability.modified_stat == Enums.StatType.MIXED_ATTACK:
		var atk_avg := (caster_phys_atk + caster_mag_atk) / 2
		return ability.modifier + atk_avg
	return ability.modifier + caster_mag_atk
