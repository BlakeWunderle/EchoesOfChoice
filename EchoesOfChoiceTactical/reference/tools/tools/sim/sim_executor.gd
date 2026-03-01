## Adapted AbilityExecutor for headless simulation.
## No SFX, no animation results, no XP/JP tracking. Returns kill count for AI scoring.
class_name SimExecutor extends RefCounted

const _SimUnit = preload("res://tools/sim/sim_unit.gd")
const _SimReactionSystem = preload("res://tools/sim/sim_reaction_system.gd")

var _grid: Grid
var _reaction_system


func _init(p_grid: Grid, p_reaction) -> void:
	_grid = p_grid
	_reaction_system = p_reaction


func execute(unit, ability: AbilityData, aoe_tiles: Array[Vector2i]) -> int:
	unit.award_ability_jp(ability)
	if ability.is_terrain_ability():
		return _execute_terrain(unit, ability, aoe_tiles)
	elif ability.is_heal():
		_execute_heal(unit, ability, aoe_tiles)
		return 0
	elif ability.is_buff_or_debuff():
		_execute_buff(unit, ability, aoe_tiles)
		return 0
	else:
		return _execute_damage(unit, ability, aoe_tiles)


func _execute_damage(attacker, ability: AbilityData, tiles: Array[Vector2i]) -> int:
	var kills := 0
	for tile in tiles:
		var target = _grid.get_occupant(tile)
		if not target is _SimUnit or not target.is_alive:
			continue
		if target.team == attacker.team:
			continue

		var damage := Combat.calculate_ability_damage(
			ability, attacker.get_stats_dict(), target.get_stats_dict())

		if Combat.roll_dodge(target.dodge_chance):
			continue

		if Combat.roll_crit(attacker.crit_chance):
			damage += attacker.crit_damage

		var def_result = _reaction_system.process_defensive_reactions(target, damage)
		damage = def_result["final_damage"]

		target.take_damage(damage)
		if not target.is_alive:
			kills += 1

		_reaction_system.check_flanking_strikes(attacker, target)

		if target.is_alive:
			_reaction_system.check_reactive_heal(target, damage)

	return kills


func _execute_heal(caster, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	for tile in tiles:
		var target = _grid.get_occupant(tile)
		if not target is _SimUnit or not target.is_alive:
			continue
		if target.team != caster.team:
			continue
		var amount := Combat.calculate_heal(ability, caster.magic_attack, caster.physical_attack)
		if ability.modified_stat == Enums.StatType.MAX_MANA:
			target.restore_mana(amount)
		else:
			target.heal(amount)


func _execute_buff(caster, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	for tile in tiles:
		var target = _grid.get_occupant(tile)
		if not target is _SimUnit or not target.is_alive:
			continue

		var is_debuff := ability.ability_type == Enums.AbilityType.DEBUFF
		if is_debuff and target.team == caster.team:
			continue
		if not is_debuff and target.team != caster.team:
			continue

		var ms := ModifiedStat.create(ability.modified_stat, ability.modifier, ability.impacted_turns, is_debuff)
		target.modified_stats.append(ms)
		target.apply_stat_modifier(ability.modified_stat, ability.modifier, is_debuff)


func _execute_terrain(caster, ability: AbilityData, tiles: Array[Vector2i]) -> int:
	var kills := 0
	var blocks_movement := ability.terrain_tile == Enums.TileType.WALL \
		or ability.terrain_tile == Enums.TileType.ICE_WALL
	for tile in tiles:
		if blocks_movement and _grid.is_occupied(tile):
			continue
		_grid.place_terrain(tile, ability.terrain_tile, ability.terrain_duration)
		if ability.terrain_tile == Enums.TileType.FIRE_TILE:
			var occupant = _grid.get_occupant(tile)
			if occupant is _SimUnit and occupant.is_alive:
				var dmg: int = max(1, 10 - occupant.magic_defense)
				occupant.take_damage(dmg)
				if not occupant.is_alive:
					kills += 1
	return kills
