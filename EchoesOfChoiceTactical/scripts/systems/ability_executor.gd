class_name AbilityExecutor extends RefCounted

var _grid: Grid
var _reaction_system: ReactionSystem


func _init(p_grid: Grid, p_reaction: ReactionSystem) -> void:
	_grid = p_grid
	_reaction_system = p_reaction


## Dispatches ability execution by type. Returns true if terrain was modified
## (caller should queue_redraw).
func execute(unit: Unit, ability: AbilityData, aoe_tiles: Array[Vector2i]) -> bool:
	if ability.is_terrain_ability():
		_execute_terrain(unit, ability, aoe_tiles)
		return true
	elif ability.is_heal():
		_execute_heal(unit, ability, aoe_tiles)
	elif ability.is_buff_or_debuff():
		_execute_buff(unit, ability, aoe_tiles)
	else:
		_execute_damage(unit, ability, aoe_tiles)
	return false


func _execute_damage(attacker: Unit, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	var got_crit := false
	var got_kill := false

	for tile in tiles:
		var target = _grid.get_occupant(tile)
		if not target is Unit or not target.is_alive:
			continue
		if target.team == attacker.team:
			continue

		var damage := Combat.calculate_ability_damage(ability, attacker.get_stats_dict(), target.get_stats_dict())

		if Combat.roll_dodge(target.dodge_chance):
			SFXManager.play(SFXManager.Category.WHOOSH, 0.7)
			continue

		var this_crit := Combat.roll_crit(attacker.crit_chance)
		if this_crit:
			damage += attacker.crit_damage
			got_crit = true

		damage = _reaction_system.process_defensive_reactions(target, damage)

		target.take_damage(damage)
		SFXManager.play_ability_sfx(ability)
		if this_crit:
			SFXManager.play(SFXManager.Category.IMPACT, 0.8)

		if not target.is_alive:
			got_kill = true

		_reaction_system.check_flanking_strikes(attacker, target)

		if target.is_alive:
			_reaction_system.check_reactive_heal(target, damage)

	attacker.award_ability_xp_jp(ability, got_crit, got_kill)


func _execute_heal(caster: Unit, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	for tile in tiles:
		var target = _grid.get_occupant(tile)
		if not target is Unit or not target.is_alive:
			continue
		if target.team != caster.team:
			continue
		var amount := Combat.calculate_heal(ability, caster.magic_attack, caster.physical_attack)
		if ability.modified_stat == Enums.StatType.MAX_MANA:
			target.restore_mana(amount)
		else:
			target.heal(amount)
		SFXManager.play(SFXManager.Category.SHIMMER)

	caster.award_ability_xp_jp(ability, false, false)


func _execute_buff(caster: Unit, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	for tile in tiles:
		var target = _grid.get_occupant(tile)
		if not target is Unit or not target.is_alive:
			continue

		var is_debuff := ability.ability_type == Enums.AbilityType.DEBUFF
		if is_debuff and target.team == caster.team:
			continue
		if not is_debuff and target.team != caster.team:
			continue

		var ms := ModifiedStat.create(ability.modified_stat, ability.modifier, ability.impacted_turns, is_debuff)
		target.modified_stats.append(ms)
		target.apply_stat_modifier(ability.modified_stat, ability.modifier, is_debuff)
		SFXManager.play(SFXManager.Category.SHIMMER, 0.8)

	caster.award_ability_xp_jp(ability, false, false)


func _execute_terrain(caster: Unit, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	var blocks_movement := ability.terrain_tile == Enums.TileType.WALL \
		or ability.terrain_tile == Enums.TileType.ICE_WALL
	SFXManager.play_ability_sfx(ability)
	for tile in tiles:
		if blocks_movement and _grid.is_occupied(tile):
			continue
		_grid.place_terrain(tile, ability.terrain_tile, ability.terrain_duration)
		if ability.terrain_tile == Enums.TileType.FIRE_TILE:
			var occupant = _grid.get_occupant(tile)
			if occupant is Unit and occupant.is_alive:
				apply_fire_damage(occupant)
	caster.award_ability_xp_jp(ability, false, false)


func apply_fire_damage(unit: Unit) -> void:
	var dmg := max(1, 10 - unit.magic_defense)
	unit.take_damage(dmg)
	SFXManager.play(SFXManager.Category.FIRE, 0.7)
