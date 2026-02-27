class_name BattleAI extends RefCounted

var _grid: Grid
var _reaction_system: ReactionSystem
var _turn_manager: TurnManager
var _scene_root: Node2D
var _execute_ability_fn: Callable
var _update_turn_info_fn: Callable
var _combat_animator: CombatAnimator


func _init(p_grid: Grid, p_reaction: ReactionSystem, p_turn_mgr: TurnManager,
		p_scene_root: Node2D, p_execute_fn: Callable, p_update_info_fn: Callable,
		p_combat_animator: CombatAnimator = null) -> void:
	_grid = p_grid
	_reaction_system = p_reaction
	_turn_manager = p_turn_mgr
	_scene_root = p_scene_root
	_execute_ability_fn = p_execute_fn
	_update_turn_info_fn = p_update_info_fn
	_combat_animator = p_combat_animator


func run_turn(unit: Unit) -> void:
	_update_turn_info_fn.call(unit)
	await _scene_root.get_tree().create_timer(0.3).timeout

	# Act-then-move: try best ability from current position first
	var pre_action := _best_action(unit, unit.grid_position)
	if pre_action.size() > 0:
		await _perform_action(unit, pre_action)
		await _scene_root.get_tree().create_timer(0.3).timeout

	# Move to optimal position
	if unit.is_alive and not unit.has_moved:
		var move_dest := _best_move(unit)
		if move_dest != unit.grid_position:
			await _execute_move(unit, move_dest)

	# Act-after-move: if didn't act before moving, try from new position
	if unit.is_alive and not unit.has_acted:
		var post_action := _best_action(unit, unit.grid_position)
		if post_action.size() > 0:
			await _perform_action(unit, post_action)
			await _scene_root.get_tree().create_timer(0.3).timeout

	await _scene_root.get_tree().create_timer(0.4).timeout
	unit.end_turn()


func _execute_move(unit: Unit, move_dest: Vector2i) -> void:
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

	# Process reactions along path
	var move_reactions: Array[Dictionary] = []
	var prev := unit.grid_position
	for step in actual_path:
		move_reactions.append_array(_reaction_system.check_opportunity_attacks(unit, prev, step))
		if not unit.is_alive:
			break
		move_reactions.append_array(_reaction_system.check_snap_shot(unit, prev, step))
		if not unit.is_alive:
			break
		prev = step
	if unit.is_alive:
		await unit.animate_move_along_path(actual_path)
		if move_reactions.size() > 0 and _combat_animator:
			await _combat_animator.animate_reaction_results(move_reactions)
		_grid.set_occupant(actual_dest, unit)
		if trap_idx >= 0 and _grid.trigger_trap(actual_dest):
			var tr := _scene_root.get_node_or_null("TerrainRenderer") as Node2D
			if tr:
				tr.queue_redraw()
			unit.has_acted = true
	else:
		if move_reactions.size() > 0 and _combat_animator:
			await _combat_animator.animate_reaction_results(move_reactions)
		await unit.play_death_animation()
		unit.visible = false
	unit.has_moved = true


func _best_action(unit: Unit, from_pos: Vector2i) -> Dictionary:
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


func _score_action(unit: Unit, ability: AbilityData, target_tile: Vector2i, from_pos: Vector2i) -> float:
	var aoe_tiles := _grid.get_aoe_tiles(target_tile, ability.aoe_shape, ability.aoe_size, from_pos)
	var score := 0.0
	if ability.is_heal():
		for tile in aoe_tiles:
			var target = _grid.get_occupant(tile)
			if target is Unit and target.is_alive and target.team == unit.team:
				score += float(target.max_health - target.health)
	elif ability.ability_type == Enums.AbilityType.BUFF:
		for tile in aoe_tiles:
			var target = _grid.get_occupant(tile)
			if target is Unit and target.is_alive and target.team == unit.team:
				score += 8.0
	elif ability.ability_type == Enums.AbilityType.DEBUFF:
		for tile in aoe_tiles:
			var target = _grid.get_occupant(tile)
			if target is Unit and target.is_alive and target.team != unit.team:
				score += 8.0
	elif ability.is_terrain_ability():
		for player_unit in _get_enemies(unit):
			if player_unit.is_alive:
				var dist := _manhattan_distance(target_tile, player_unit.grid_position)
				if dist <= 2:
					score += 6.0
	else:
		for tile in aoe_tiles:
			var target = _grid.get_occupant(tile)
			if target is Unit and target.is_alive and target.team != unit.team:
				var damage := Combat.calculate_ability_damage(ability, unit.get_stats_dict(), target.get_stats_dict())
				var hp_ratio := float(target.health) / float(target.max_health)
				score += float(damage) * (2.0 - hp_ratio)
	return score


func _perform_action(unit: Unit, action: Dictionary) -> void:
	var ability: AbilityData = action["ability"]
	var target_pos: Vector2i = action["target_pos"]
	unit.set_facing_toward(target_pos)
	unit.spend_mana(ability.mana_cost)
	var aoe_tiles := _grid.get_aoe_tiles(target_pos, ability.aoe_shape, ability.aoe_size, unit.grid_position)
	await _execute_ability_fn.call(unit, ability, aoe_tiles)
	unit.has_acted = true


func _best_move(unit: Unit) -> Vector2i:
	var reachable := _grid.get_reachable_tiles(unit.grid_position, unit.movement, unit.jump)
	var best_tile := unit.grid_position
	var best_score := -INF
	for tile in reachable:
		if _grid.is_occupied(tile):
			continue
		var score := _score_move_tile(unit, tile)
		if score > best_score:
			best_score = score
			best_tile = tile
	return best_tile


func _score_move_tile(unit: Unit, tile: Vector2i) -> float:
	var max_range := 1
	var has_heal := false
	for ability in unit.abilities:
		if ability.is_heal():
			has_heal = true
		elif not ability.is_buff_or_debuff() and not ability.is_terrain_ability():
			if ability.ability_range > max_range:
				max_range = ability.ability_range

	if has_heal:
		var heal_score := 0.0
		for ally in _get_allies(unit):
			if ally.is_alive and ally != unit:
				var missing := ally.max_health - ally.health
				if missing > 0:
					var dist := _manhattan_distance(tile, ally.grid_position)
					heal_score += float(missing) / float(dist + 1)
		if heal_score > 0.0:
			return heal_score

	var weakest: Unit = null
	var lowest_hp := INF
	for player in _get_enemies(unit):
		if player.is_alive and float(player.health) < lowest_hp:
			lowest_hp = float(player.health)
			weakest = player
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


func _get_allies(unit: Unit) -> Array[Unit]:
	if unit.team == Enums.Team.PLAYER:
		return _turn_manager.player_units
	return _turn_manager.enemy_units


func _get_enemies(unit: Unit) -> Array[Unit]:
	if unit.team == Enums.Team.PLAYER:
		return _turn_manager.enemy_units
	return _turn_manager.player_units


static func _manhattan_distance(a: Vector2i, b: Vector2i) -> int:
	return absi(a.x - b.x) + absi(a.y - b.y)
