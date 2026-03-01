class_name BattleAI


static func decide_action(unit: BattleUnit, allies: Array[BattleUnit],
		enemies: Array[BattleUnit]) -> Dictionary:
	var best_score := -1.0
	var best_ability: AbilityData = null
	var best_targets: Array[BattleUnit] = []

	for ability in unit.abilities:
		if not unit.can_use_ability(ability):
			continue
		var targets := _get_targets(ability, unit, allies, enemies)
		if targets.is_empty():
			continue
		var score := _score_action(ability, unit, targets)
		if score > best_score:
			best_score = score
			best_ability = ability
			best_targets = targets

	if best_ability:
		return {"ability": best_ability, "targets": best_targets}

	# Fallback: first ability on weakest enemy
	if unit.abilities.size() > 0:
		var target := _pick_weakest(enemies)
		if target:
			return {"ability": unit.abilities[0], "targets": [target]}
	return {}


static func _score_action(ability: AbilityData, caster: BattleUnit,
		targets: Array[BattleUnit]) -> float:
	var score := 0.0
	match ability.ability_type:
		Enums.AbilityType.HEAL:
			for target in targets:
				if target.is_alive:
					score += float(target.max_health - target.health)
		Enums.AbilityType.BUFF:
			for target in targets:
				if target.is_alive:
					score += 8.0
		Enums.AbilityType.DEBUFF:
			for target in targets:
				if target.is_alive:
					score += 8.0
		Enums.AbilityType.DAMAGE:
			for target in targets:
				if target.is_alive:
					var dmg := float(Combat.calculate_ability_damage(
						ability, caster.get_stats(), target.get_stats()))
					score += dmg * (2.0 - target.get_hp_ratio())
	return score


static func _get_targets(ability: AbilityData, caster: BattleUnit,
		allies: Array[BattleUnit], enemies: Array[BattleUnit]) -> Array[BattleUnit]:
	var pool: Array[BattleUnit] = []
	match ability.ability_type:
		Enums.AbilityType.DAMAGE, Enums.AbilityType.DEBUFF:
			pool = _alive(enemies)
		Enums.AbilityType.HEAL, Enums.AbilityType.BUFF:
			pool = _alive(allies)

	match ability.target_scope:
		Enums.TargetScope.SINGLE:
			var target := _pick_best_single(ability, caster, pool)
			return [target] if target else []
		_:
			return pool


static func _pick_best_single(ability: AbilityData, caster: BattleUnit,
		pool: Array[BattleUnit]) -> BattleUnit:
	if pool.is_empty():
		return null
	if ability.ability_type == Enums.AbilityType.HEAL:
		var most_hurt: BattleUnit = null
		var most_missing := 0
		for u in pool:
			var missing := u.max_health - u.health
			if missing > most_missing:
				most_missing = missing
				most_hurt = u
		return most_hurt if most_hurt else pool[0]
	return _pick_weakest(pool)


static func _pick_weakest(units: Array[BattleUnit]) -> BattleUnit:
	var weakest: BattleUnit = null
	var lowest_hp := 999999
	for u in units:
		if u.is_alive and u.health < lowest_hp:
			lowest_hp = u.health
			weakest = u
	return weakest


static func _alive(units: Array[BattleUnit]) -> Array[BattleUnit]:
	var result: Array[BattleUnit] = []
	for u in units:
		if u.is_alive:
			result.append(u)
	return result
