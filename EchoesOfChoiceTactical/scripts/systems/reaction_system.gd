class_name ReactionSystem extends RefCounted

var grid: Grid


func _init(p_grid: Grid) -> void:
	grid = p_grid


# Check and trigger opportunity attacks when a unit leaves threatened tiles
func check_opportunity_attacks(moving_unit: Unit, from_pos: Vector2i, to_pos: Vector2i) -> Array[Dictionary]:
	var results: Array[Dictionary] = []

	for dir in Grid.DIRECTIONS:
		var adj := from_pos + dir
		if adj == to_pos:
			continue
		var occupant = grid.get_occupant(adj)
		if not _is_valid_reactor(occupant, moving_unit, Enums.ReactionType.OPPORTUNITY_ATTACK):
			continue

		var damage := Combat.calculate_physical_damage(
			occupant.physical_attack, moving_unit.physical_defense)
		var dodged := Combat.roll_dodge(moving_unit.dodge_chance)
		var critted := false

		if not dodged:
			critted = Combat.roll_crit(occupant.crit_chance)
			if critted:
				damage += occupant.crit_damage
			moving_unit.take_damage(damage)

		occupant.use_reaction()
		results.append({
			"reactor": occupant,
			"target": moving_unit,
			"type": Enums.ReactionType.OPPORTUNITY_ATTACK,
			"damage": damage if not dodged else 0,
			"dodged": dodged,
			"critted": critted,
		})

	return results


# Check and trigger flanking strikes when an attack lands
func check_flanking_strikes(attacker: Unit, target: Unit) -> Array[Dictionary]:
	var results: Array[Dictionary] = []

	for dir in Grid.DIRECTIONS:
		var adj := target.grid_position + dir
		var occupant = grid.get_occupant(adj)
		if occupant == attacker:
			continue
		if not _is_valid_reactor(occupant, target, Enums.ReactionType.FLANKING_STRIKE):
			continue
		# Flanker must be on the same team as the attacker
		if occupant.team != attacker.team:
			continue

		var damage := Combat.calculate_flanking_damage(
			occupant.physical_attack, target.physical_defense)

		if not Combat.roll_dodge(target.dodge_chance):
			target.take_damage(damage)
			occupant.use_reaction()
			results.append({
				"reactor": occupant,
				"target": target,
				"type": Enums.ReactionType.FLANKING_STRIKE,
				"damage": damage,
				"dodged": false,
			})
		else:
			occupant.use_reaction()
			results.append({
				"reactor": occupant,
				"target": target,
				"type": Enums.ReactionType.FLANKING_STRIKE,
				"damage": 0,
				"dodged": true,
			})

	return results


# Check and trigger snap shot when an enemy approaches a ranged unit head-on
func check_snap_shot(approaching_unit: Unit, from_pos: Vector2i, to_pos: Vector2i) -> Array[Dictionary]:
	var results: Array[Dictionary] = []

	for dir in Grid.DIRECTIONS:
		var adj := to_pos + dir
		var occupant = grid.get_occupant(adj)
		if not _is_valid_reactor(occupant, approaching_unit, Enums.ReactionType.SNAP_SHOT):
			continue

		# Only triggers if the approach is from the unit's front facing
		if not occupant.is_facing_toward(from_pos):
			continue

		var damage := Combat.calculate_snap_shot_damage(
			occupant.physical_attack, approaching_unit.physical_defense)

		if not Combat.roll_dodge(approaching_unit.dodge_chance):
			approaching_unit.take_damage(damage)
			occupant.use_reaction()
			results.append({
				"reactor": occupant,
				"target": approaching_unit,
				"type": Enums.ReactionType.SNAP_SHOT,
				"damage": damage,
				"dodged": false,
			})
		else:
			occupant.use_reaction()
			results.append({
				"reactor": occupant,
				"target": approaching_unit,
				"type": Enums.ReactionType.SNAP_SHOT,
				"damage": 0,
				"dodged": true,
			})

	return results


# Check and trigger reactive heal when an ally takes damage
func check_reactive_heal(damaged_unit: Unit, damage_amount: int) -> Array[Dictionary]:
	var results: Array[Dictionary] = []
	var all_units := _get_allies_in_range(damaged_unit, 3)

	for ally in all_units:
		if not _is_valid_reactor(ally, damaged_unit, Enums.ReactionType.REACTIVE_HEAL):
			continue
		if ally.team != damaged_unit.team:
			continue
		if not grid.has_line_of_sight(ally.grid_position, damaged_unit.grid_position):
			continue

		var heal_amount := Combat.calculate_reactive_heal(ally.magic_attack)
		damaged_unit.heal(heal_amount)
		ally.use_reaction()
		results.append({
			"reactor": ally,
			"target": damaged_unit,
			"type": Enums.ReactionType.REACTIVE_HEAL,
			"heal": heal_amount,
		})
		break

	return results


# Check and trigger damage mitigation when an ally takes damage
func check_damage_mitigation(damaged_unit: Unit, incoming_damage: int) -> Dictionary:
	var all_units := _get_allies_in_range(damaged_unit, 3)

	for ally in all_units:
		if not _is_valid_reactor(ally, damaged_unit, Enums.ReactionType.DAMAGE_MITIGATION):
			continue
		if ally.team != damaged_unit.team:
			continue
		if not grid.has_line_of_sight(ally.grid_position, damaged_unit.grid_position):
			continue

		var mitigated := Combat.calculate_mitigated_damage(incoming_damage)
		ally.use_reaction()
		return {
			"reactor": ally,
			"target": damaged_unit,
			"type": Enums.ReactionType.DAMAGE_MITIGATION,
			"original_damage": incoming_damage,
			"mitigated_damage": mitigated,
			"reduction": incoming_damage - mitigated,
			"active": true,
		}

	return {"active": false}


# Check and trigger bodyguard when an adjacent ally takes damage
func check_bodyguard(damaged_unit: Unit, incoming_damage: int) -> Dictionary:
	for dir in Grid.DIRECTIONS:
		var adj := damaged_unit.grid_position + dir
		var occupant = grid.get_occupant(adj)
		if not _is_valid_reactor(occupant, damaged_unit, Enums.ReactionType.BODYGUARD):
			continue
		if occupant.team != damaged_unit.team:
			continue

		var split := Combat.calculate_bodyguard_split(incoming_damage)
		occupant.use_reaction()
		return {
			"reactor": occupant,
			"target": damaged_unit,
			"type": Enums.ReactionType.BODYGUARD,
			"damage_to_ally": split["damage_to_ally"],
			"damage_to_tank": split["damage_to_tank"],
			"active": true,
		}

	return {"active": false}


# Process all defensive reactions before damage is applied.
# Returns the final damage the target actually takes.
func process_defensive_reactions(target: Unit, raw_damage: int) -> int:
	var final_damage := raw_damage

	# Check bodyguard first (adjacent tank absorbs portion)
	var bodyguard := check_bodyguard(target, final_damage)
	if bodyguard["active"]:
		final_damage = bodyguard["damage_to_ally"]
		bodyguard["reactor"].take_damage(bodyguard["damage_to_tank"])

	# Check damage mitigation (support within 3 tiles reduces damage)
	var mitigation := check_damage_mitigation(target, final_damage)
	if mitigation["active"]:
		final_damage = mitigation["mitigated_damage"]

	return final_damage


func _is_valid_reactor(unit, against: Unit, reaction_type: Enums.ReactionType) -> bool:
	if unit == null or not unit is Unit:
		return false
	if not unit.is_alive:
		return false
	if not unit.has_reaction:
		return false
	if unit.team == against.team:
		# Flanking strike and bodyguard/heal/mitigation check team differently
		if reaction_type in [Enums.ReactionType.OPPORTUNITY_ATTACK, Enums.ReactionType.SNAP_SHOT]:
			return false
	else:
		if reaction_type in [Enums.ReactionType.FLANKING_STRIKE, Enums.ReactionType.REACTIVE_HEAL,
				Enums.ReactionType.DAMAGE_MITIGATION, Enums.ReactionType.BODYGUARD]:
			return false
	return unit.has_reaction_type(reaction_type)


func _get_allies_in_range(unit: Unit, support_range: int) -> Array:
	var allies: Array = []
	for x in range(-support_range, support_range + 1):
		for y in range(-support_range, support_range + 1):
			if absi(x) + absi(y) > support_range:
				continue
			if x == 0 and y == 0:
				continue
			var pos := unit.grid_position + Vector2i(x, y)
			var occupant = grid.get_occupant(pos)
			if occupant != null and occupant is Unit and occupant != unit:
				allies.append(occupant)
	return allies
