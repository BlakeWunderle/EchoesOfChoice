class_name AbilityExecutor

const _ModifiedStat = preload("res://scripts/data/modified_stat.gd")


static func execute(ability: AbilityData, caster: BattleUnit, targets: Array[BattleUnit]) -> Array[Dictionary]:
	match ability.ability_type:
		Enums.AbilityType.DAMAGE:
			return _execute_damage(ability, caster, targets)
		Enums.AbilityType.HEAL:
			return _execute_heal(ability, caster, targets)
		Enums.AbilityType.BUFF:
			return _execute_buff(ability, caster, targets, false)
		Enums.AbilityType.DEBUFF:
			return _execute_buff(ability, caster, targets, true)
	return []


static func _execute_damage(ability: AbilityData, caster: BattleUnit, targets: Array[BattleUnit]) -> Array[Dictionary]:
	var results: Array[Dictionary] = []
	var attacker_stats := caster.get_stats()

	for target in targets:
		if not target.is_alive:
			continue
		var defender_stats := target.get_stats()
		var damage := Combat.calculate_ability_damage(ability, attacker_stats, defender_stats)

		if Combat.roll_dodge(target.dodge_chance, target.is_back_row()):
			results.append({"target": target, "type": "dodge"})
			continue

		var is_crit := Combat.roll_crit(caster.crit_chance)
		if is_crit:
			damage += caster.crit_damage

		damage = maxi(damage, 1)
		var old_hp := target.get_hp_ratio()
		target.take_damage(damage)
		var new_hp := target.get_hp_ratio()

		results.append({
			"target": target,
			"type": "damage",
			"amount": damage,
			"is_crit": is_crit,
			"killed": not target.is_alive,
			"old_hp_ratio": old_hp,
			"new_hp_ratio": new_hp,
		})
	return results


static func _execute_heal(ability: AbilityData, caster: BattleUnit, targets: Array[BattleUnit]) -> Array[Dictionary]:
	var results: Array[Dictionary] = []

	for target in targets:
		if not target.is_alive:
			continue
		var amount: int
		if ability.modified_stat == Enums.StatType.MAX_MANA:
			amount = caster.magic_attack + ability.modifier
			var healed := target.restore_mana(amount)
			results.append({"target": target, "type": "mana_heal", "amount": healed})
		else:
			amount = Combat.calculate_heal(ability, caster.magic_attack, caster.physical_attack)
			var old_hp := target.get_hp_ratio()
			var healed := target.heal_hp(amount)
			results.append({
				"target": target,
				"type": "heal",
				"amount": healed,
				"old_hp_ratio": old_hp,
				"new_hp_ratio": target.get_hp_ratio(),
			})
	return results


static func _execute_buff(ability: AbilityData, caster: BattleUnit,
		targets: Array[BattleUnit], is_debuff: bool) -> Array[Dictionary]:
	var results: Array[Dictionary] = []
	var stat_name := _stat_name(ability.modified_stat)

	for target in targets:
		if not target.is_alive:
			continue
		var mod := _ModifiedStat.create(
			ability.modified_stat,
			-ability.modifier if is_debuff else ability.modifier,
			ability.impacted_turns,
			is_debuff
		)
		target.modified_stats.append(mod)
		target.apply_stat_modifier(mod.stat, mod.modifier)

		results.append({
			"target": target,
			"type": "debuff" if is_debuff else "buff",
			"stat_name": stat_name,
		})
	return results


static func _stat_name(stat: Enums.StatType) -> String:
	match stat:
		Enums.StatType.PHYSICAL_ATTACK: return "ATK"
		Enums.StatType.PHYSICAL_DEFENSE: return "DEF"
		Enums.StatType.MAGIC_ATTACK: return "MATK"
		Enums.StatType.MAGIC_DEFENSE: return "MDEF"
		Enums.StatType.SPEED: return "SPD"
		Enums.StatType.DODGE_CHANCE: return "EVA"
		Enums.StatType.CRIT_CHANCE: return "CRIT"
		Enums.StatType.MAX_HEALTH: return "HP"
		Enums.StatType.MAX_MANA: return "MP"
	return "STAT"
