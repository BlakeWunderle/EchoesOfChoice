## Synchronous AI for headless simulation. Adapted from BattleAI.
## No await, no Node2D, no CombatAnimator. Works for both player and enemy units.
class_name SimAI extends RefCounted

const _SimUnit = preload("res://tools/sim/sim_unit.gd")

var _grid: Grid
var _reaction_system
var _executor
var _all_units: Array
var _player_units: Array
var _enemy_units: Array


func _init(p_grid: Grid, p_reaction, p_executor) -> void:
	_grid = p_grid
	_reaction_system = p_reaction
	_executor = p_executor


func set_units(all: Array, players: Array, enemies: Array) -> void:
	_all_units = all
	_player_units = players
	_enemy_units = enemies


func run_turn(unit) -> void:
	# Act-then-move: try best ability from current position first
	var pre_action := _best_action(unit, unit.grid_position)
	if pre_action.size() > 0:
		_perform_action(unit, pre_action)

	# Move to optimal position
	if unit.is_alive and not unit.has_moved:
		var move_dest := _best_move(unit)
		if move_dest != unit.grid_position:
			_execute_move(unit, move_dest)

	# Act-after-move: if didn't act before, try from new position
	if unit.is_alive and not unit.has_acted:
		var post_action := _best_action(unit, unit.grid_position)
		if post_action.size() > 0:
			_perform_action(unit, post_action)

	unit.end_turn()


func _execute_move(unit, move_dest: Vector2i) -> void:
	var path := _grid.find_path(unit.grid_position, move_dest, unit.movement, unit.jump)
	_grid.clear_occupant(unit.grid_position)

	# Check for traps along movement path
	var trap_positions := _grid.get_active_terrain_positions(Enums.TileType.TRAP)
	var trap_idx := -1
	for i in range(path.size()):
		if path[i] in trap_positions:
			trap_idx = i
			break
	var actual_path := path
	var actual_dest := move_dest
	if trap_idx >= 0:
		actual_path = path.slice(0, trap_idx + 1)
		actual_dest = path[trap_idx]

	# Process reactions along path (no animation)
	var prev: Vector2i = unit.grid_position
	for step in actual_path:
		_reaction_system.check_opportunity_attacks(unit, prev, step)
		if not unit.is_alive:
			break
		_reaction_system.check_snap_shot(unit, prev, step)
		if not unit.is_alive:
			break
		prev = step

	if unit.is_alive:
		unit.grid_position = actual_dest
		_grid.set_occupant(actual_dest, unit)
		if trap_idx >= 0:
			_grid.trigger_trap(actual_dest)
			unit.has_acted = true
	unit.has_moved = true


func _best_action(unit, from_pos: Vector2i) -> Dictionary:
	var best_score := 0.0
	var best := {}
	for ability in unit.get_affordable_abilities():
		var elev := _grid.get_elevation(from_pos)
		var in_range := _grid.get_tiles_in_range(from_pos, ability.ability_range, elev)
		for tile in in_range:
			var score := _score_action(unit, ability, tile, from_pos)
			if score > best_score:
				best_score = score
				best = {"ability": ability, "target_pos": tile}
	return best


func _score_action(unit, ability: AbilityData, target_tile: Vector2i, from_pos: Vector2i) -> float:
	var aoe_tiles := _grid.get_aoe_tiles(target_tile, ability.aoe_shape, ability.aoe_size, from_pos)
	var foes := _enemy_units if unit.team == Enums.Team.PLAYER else _player_units
	var allies := _player_units if unit.team == Enums.Team.PLAYER else _enemy_units
	var score := 0.0

	if ability.is_heal():
		for tile in aoe_tiles:
			var target = _grid.get_occupant(tile)
			if target is _SimUnit and target.is_alive and target.team == unit.team:
				score += float(target.max_health - target.health)
	elif ability.ability_type == Enums.AbilityType.BUFF:
		for tile in aoe_tiles:
			var target = _grid.get_occupant(tile)
			if target is _SimUnit and target.is_alive and target.team == unit.team:
				score += 8.0
	elif ability.ability_type == Enums.AbilityType.DEBUFF:
		for tile in aoe_tiles:
			var target = _grid.get_occupant(tile)
			if target is _SimUnit and target.is_alive and target.team != unit.team:
				score += 8.0
	elif ability.is_terrain_ability():
		for foe in foes:
			if foe.is_alive:
				var dist := _manhattan_distance(target_tile, foe.grid_position)
				if dist <= 2:
					score += 6.0
	else:
		for tile in aoe_tiles:
			var target = _grid.get_occupant(tile)
			if target is _SimUnit and target.is_alive and target.team != unit.team:
				var damage := Combat.calculate_ability_damage(
					ability, unit.get_stats_dict(), target.get_stats_dict())
				var hp_ratio := float(target.health) / float(target.max_health)
				score += float(damage) * (2.0 - hp_ratio)
	return score


func _perform_action(unit, action: Dictionary) -> void:
	var ability: AbilityData = action["ability"]
	var target_pos: Vector2i = action["target_pos"]
	unit.set_facing_toward(target_pos)
	unit.spend_mana(ability.mana_cost)
	var aoe_tiles := _grid.get_aoe_tiles(
		target_pos, ability.aoe_shape, ability.aoe_size, unit.grid_position)
	_executor.execute(unit, ability, aoe_tiles)
	unit.has_acted = true


func _best_move(unit) -> Vector2i:
	var reachable := _grid.get_reachable_tiles(unit.grid_position, unit.movement, unit.jump)
	var best_tile: Vector2i = unit.grid_position
	var best_score := -INF
	for tile in reachable:
		if _grid.is_occupied(tile):
			continue
		var score := _score_move_tile(unit, tile)
		if score > best_score:
			best_score = score
			best_tile = tile
	return best_tile


func _score_move_tile(unit, tile: Vector2i) -> float:
	var foes := _enemy_units if unit.team == Enums.Team.PLAYER else _player_units
	var allies := _player_units if unit.team == Enums.Team.PLAYER else _enemy_units

	var max_range := 1
	var has_heal := false
	for ability in unit.abilities:
		if ability.is_heal():
			has_heal = true
		elif not ability.is_buff_or_debuff() and not ability.is_terrain_ability():
			if ability.ability_range > max_range:
				max_range = ability.ability_range

	# Healers move toward injured allies
	if has_heal:
		var heal_score := 0.0
		for ally in allies:
			if ally.is_alive and ally != unit:
				var missing: int = ally.max_health - ally.health
				if missing > 0:
					var dist := _manhattan_distance(tile, ally.grid_position)
					heal_score += float(missing) / float(dist + 1)
		if heal_score > 0.0:
			return heal_score

	# DPS moves toward weakest foe
	var weakest = null
	var lowest_hp := INF
	for foe in foes:
		if foe.is_alive and float(foe.health) < lowest_hp:
			lowest_hp = float(foe.health)
			weakest = foe
	if weakest == null:
		return 0.0

	var dist := _manhattan_distance(tile, weakest.grid_position)
	if max_range >= 2:
		var score := 100.0 - float(absi(dist - max_range)) * 10.0
		if dist == 1:
			score -= 20.0
		return score
	else:
		if dist == 1:
			return 100.0
		return 100.0 - float(dist) * 10.0


static func _manhattan_distance(a: Vector2i, b: Vector2i) -> int:
	return absi(a.x - b.x) + absi(a.y - b.y)
