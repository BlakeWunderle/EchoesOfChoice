extends Node2D

@onready var turn_manager: TurnManager = $TurnManager
@onready var grid_overlay: GridOverlay = $GridOverlay
@onready var grid_cursor: GridCursor = $GridCursor
@onready var camera: Camera2D = $Camera2D
@onready var units_container: Node2D = $Units
@onready var hud: CanvasLayer = $HUD
@onready var turn_info: Label = $HUD/TurnInfo
@onready var action_panel: VBoxContainer = $HUD/ActionPanel

var grid: Grid
var reaction_system: ReactionSystem
var unit_scene: PackedScene = preload("res://scenes/units/Unit.tscn")

var _current_phase: Enums.TurnPhase = Enums.TurnPhase.AWAITING_INPUT
var _selected_ability: AbilityData = null
var _reachable_tiles: Array[Vector2i] = []
var _attack_tiles: Array[Vector2i] = []


func _ready() -> void:
	_setup_test_battle()


func _setup_test_battle() -> void:
	grid = Grid.new(10, 8)
	reaction_system = ReactionSystem.new(grid)

	for x in range(10):
		for y in range(8):
			grid.set_tile(Vector2i(x, y), true, 1, 0)

	# Walls
	grid.set_tile(Vector2i(4, 2), false, 999, 0, true)
	grid.set_tile(Vector2i(4, 3), false, 999, 0, true)
	grid.set_tile(Vector2i(5, 2), false, 999, 0, true)
	grid.set_tile(Vector2i(5, 3), false, 999, 0, true)

	# Elevated hill
	grid.set_tile(Vector2i(2, 1), true, 1, 1)
	grid.set_tile(Vector2i(3, 1), true, 1, 1)
	grid.set_tile(Vector2i(2, 2), true, 1, 1)
	grid.set_tile(Vector2i(3, 2), true, 1, 2)

	# Rough terrain
	grid.set_tile(Vector2i(6, 4), true, 2, 0)
	grid.set_tile(Vector2i(7, 4), true, 2, 0)
	grid.set_tile(Vector2i(6, 5), true, 2, 0)

	# Destructible boulder
	grid.set_tile(Vector2i(5, 5), false, 999, 0, true, 20)

	# Player units
	var squire_data := _create_test_fighter("Squire", 50, 15, 12, 8, 5, 6, 8, 4, 2,
		[Enums.ReactionType.OPPORTUNITY_ATTACK, Enums.ReactionType.FLANKING_STRIKE, Enums.ReactionType.BODYGUARD])
	var mage_data := _create_test_fighter("Mage", 35, 30, 5, 4, 14, 8, 7, 3, 1,
		[Enums.ReactionType.SNAP_SHOT])
	var healer_data := _create_test_fighter("Healer", 40, 25, 6, 5, 10, 9, 7, 3, 1,
		[Enums.ReactionType.REACTIVE_HEAL])

	_spawn_unit(squire_data, "Roland", Enums.Team.PLAYER, Vector2i(1, 5), 1)
	_spawn_unit(mage_data, "Elara", Enums.Team.PLAYER, Vector2i(2, 6), 1)
	_spawn_unit(healer_data, "Sera", Enums.Team.PLAYER, Vector2i(1, 6), 1)

	# Enemy units
	var thug_data := _create_test_fighter("Thug", 40, 10, 11, 7, 3, 4, 7, 4, 1,
		[Enums.ReactionType.OPPORTUNITY_ATTACK])
	var archer_data := _create_test_fighter("Archer", 30, 10, 9, 5, 6, 4, 8, 4, 2,
		[Enums.ReactionType.SNAP_SHOT])

	_spawn_unit(thug_data, "Brute", Enums.Team.ENEMY, Vector2i(7, 1), 1)
	_spawn_unit(thug_data, "Ruffian", Enums.Team.ENEMY, Vector2i(8, 2), 1)
	_spawn_unit(archer_data, "Lookout", Enums.Team.ENEMY, Vector2i(8, 1), 1)

	var all_units: Array[Unit] = []
	for child in units_container.get_children():
		if child is Unit:
			all_units.append(child)

	turn_manager.setup(all_units)
	turn_manager.unit_turn_started.connect(_on_unit_turn_started)
	turn_manager.battle_ended.connect(_on_battle_ended)

	grid_cursor.cell_selected.connect(_on_cell_selected)
	grid_cursor.cell_hovered.connect(_on_cell_hovered)
	grid_cursor.cancelled.connect(_on_cursor_cancelled)

	_build_action_panel()

	turn_manager.run_battle()


func _create_test_fighter(display_name: String, hp: int, mp: int, p_atk: int, p_def: int,
		m_atk: int, m_def: int, spd: int, mov: int, jmp: int,
		reactions: Array[Enums.ReactionType]) -> FighterData:
	var data := FighterData.new()
	data.class_id = display_name.to_lower()
	data.class_display_name = display_name
	data.base_max_health = hp
	data.base_max_mana = mp
	data.base_physical_attack = p_atk
	data.base_physical_defense = p_def
	data.base_magic_attack = m_atk
	data.base_magic_defense = m_def
	data.base_speed = spd
	data.movement = mov
	data.jump = jmp
	data.reaction_types = reactions

	# Give everyone a basic attack ability for testing
	var basic_attack := AbilityData.new()
	basic_attack.ability_name = "Strike"
	basic_attack.flavor_text = "A basic melee attack."
	basic_attack.modified_stat = Enums.StatType.PHYSICAL_ATTACK
	basic_attack.modifier = 0
	basic_attack.use_on_enemy = true
	basic_attack.mana_cost = 0
	basic_attack.ability_range = 1
	basic_attack.aoe_shape = Enums.AoEShape.SINGLE
	basic_attack.ability_type = Enums.AbilityType.DAMAGE
	data.abilities.append(basic_attack)

	if display_name == "Mage":
		var fireball := AbilityData.new()
		fireball.ability_name = "Fireball"
		fireball.flavor_text = "A burst of flame engulfs the target."
		fireball.modified_stat = Enums.StatType.MAGIC_ATTACK
		fireball.modifier = 5
		fireball.use_on_enemy = true
		fireball.mana_cost = 8
		fireball.ability_range = 4
		fireball.aoe_shape = Enums.AoEShape.DIAMOND
		fireball.aoe_size = 1
		fireball.ability_type = Enums.AbilityType.DAMAGE
		data.abilities.append(fireball)

	if display_name == "Healer":
		var heal := AbilityData.new()
		heal.ability_name = "Mend"
		heal.flavor_text = "Soothing light restores an ally."
		heal.modified_stat = Enums.StatType.MAGIC_ATTACK
		heal.modifier = 8
		heal.use_on_enemy = false
		heal.mana_cost = 6
		heal.ability_range = 3
		heal.aoe_shape = Enums.AoEShape.SINGLE
		heal.ability_type = Enums.AbilityType.HEAL
		data.abilities.append(heal)

	return data


func _spawn_unit(data: FighterData, unit_name: String, team: Enums.Team, pos: Vector2i, level: int) -> Unit:
	var unit: Unit = unit_scene.instantiate()
	units_container.add_child(unit)
	unit.initialize(data, unit_name, team, level)
	unit.place_on_grid(pos)
	grid.set_occupant(pos, unit)

	var placeholder := ColorRect.new()
	placeholder.size = Vector2(48, 48)
	placeholder.position = Vector2(-24, -24)
	if team == Enums.Team.PLAYER:
		placeholder.color = Color(0.2, 0.5, 1.0)
	else:
		placeholder.color = Color(1.0, 0.2, 0.2)
	unit.add_child(placeholder)

	var label := Label.new()
	label.text = unit_name
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = Vector2(-30, 24)
	label.add_theme_font_size_override("font_size", 10)
	unit.add_child(label)

	return unit


# --- Action Panel (placeholder UI until Phase 9) ---

var _btn_attack: Button
var _btn_ability: Button
var _btn_move: Button
var _btn_wait: Button
var _btn_facing_n: Button
var _btn_facing_s: Button
var _btn_facing_e: Button
var _btn_facing_w: Button
var _facing_container: HBoxContainer
var _ability_container: VBoxContainer


func _build_action_panel() -> void:
	_btn_attack = Button.new()
	_btn_attack.text = "Attack"
	_btn_attack.pressed.connect(_on_attack_pressed)
	action_panel.add_child(_btn_attack)

	_btn_ability = Button.new()
	_btn_ability.text = "Ability"
	_btn_ability.pressed.connect(_on_ability_pressed)
	action_panel.add_child(_btn_ability)

	_btn_move = Button.new()
	_btn_move.text = "Move"
	_btn_move.pressed.connect(_on_move_pressed)
	action_panel.add_child(_btn_move)

	_btn_wait = Button.new()
	_btn_wait.text = "Wait"
	_btn_wait.pressed.connect(_on_wait_pressed)
	action_panel.add_child(_btn_wait)

	_ability_container = VBoxContainer.new()
	_ability_container.visible = false
	action_panel.add_child(_ability_container)

	# Facing chooser
	_facing_container = HBoxContainer.new()
	_facing_container.visible = false
	action_panel.add_child(_facing_container)

	_btn_facing_n = Button.new()
	_btn_facing_n.text = "N"
	_btn_facing_n.pressed.connect(func(): _set_facing(Enums.Facing.NORTH))
	_facing_container.add_child(_btn_facing_n)

	_btn_facing_s = Button.new()
	_btn_facing_s.text = "S"
	_btn_facing_s.pressed.connect(func(): _set_facing(Enums.Facing.SOUTH))
	_facing_container.add_child(_btn_facing_s)

	_btn_facing_e = Button.new()
	_btn_facing_e.text = "E"
	_btn_facing_e.pressed.connect(func(): _set_facing(Enums.Facing.EAST))
	_facing_container.add_child(_btn_facing_e)

	_btn_facing_w = Button.new()
	_btn_facing_w.text = "W"
	_btn_facing_w.pressed.connect(func(): _set_facing(Enums.Facing.WEST))
	_facing_container.add_child(_btn_facing_w)


func _show_action_menu(unit: Unit) -> void:
	action_panel.visible = true
	_ability_container.visible = false
	_facing_container.visible = false

	_btn_attack.visible = not unit.has_acted
	_btn_ability.visible = not unit.has_acted and unit.has_any_affordable_ability()
	_btn_move.visible = not unit.has_moved
	_btn_wait.visible = true

	_update_turn_info(unit)


func _hide_action_menu() -> void:
	action_panel.visible = false
	_ability_container.visible = false
	_facing_container.visible = false


func _update_turn_info(unit: Unit) -> void:
	var team_str := "PLAYER" if unit.team == Enums.Team.PLAYER else "ENEMY"
	turn_info.text = "%s the %s [%s]\nHP: %d/%d  MP: %d/%d" % [
		unit.unit_name, unit.unit_class, team_str,
		unit.health, unit.max_health, unit.mana, unit.max_mana]


# --- Action Handlers ---

func _on_attack_pressed() -> void:
	var unit := turn_manager.current_unit
	if unit == null or unit.has_acted:
		return
	_hide_action_menu()
	_current_phase = Enums.TurnPhase.ACT
	_selected_ability = unit.abilities[0] if unit.abilities.size() > 0 else null

	if _selected_ability == null:
		_show_action_menu(unit)
		return

	_show_targeting(_selected_ability, unit)


func _on_ability_pressed() -> void:
	var unit := turn_manager.current_unit
	if unit == null or unit.has_acted:
		return

	# Show ability list
	for child in _ability_container.get_children():
		child.queue_free()

	var affordable := unit.get_affordable_abilities()
	for i in range(affordable.size()):
		var ability := affordable[i]
		if ability.ability_name == "Strike":
			continue
		var btn := Button.new()
		btn.text = "%s (MP: %d, Range: %d)" % [ability.ability_name, ability.mana_cost, ability.ability_range]
		var idx := i
		btn.pressed.connect(func(): _on_ability_selected(affordable[idx]))
		_ability_container.add_child(btn)

	var back_btn := Button.new()
	back_btn.text = "Back"
	back_btn.pressed.connect(func():
		_ability_container.visible = false
		_show_action_menu(unit)
	)
	_ability_container.add_child(back_btn)

	_ability_container.visible = true
	_btn_attack.visible = false
	_btn_ability.visible = false
	_btn_move.visible = false
	_btn_wait.visible = false


func _on_ability_selected(ability: AbilityData) -> void:
	var unit := turn_manager.current_unit
	if unit == null:
		return
	_hide_action_menu()
	_current_phase = Enums.TurnPhase.ACT
	_selected_ability = ability
	_show_targeting(ability, unit)


func _on_move_pressed() -> void:
	var unit := turn_manager.current_unit
	if unit == null or unit.has_moved:
		return
	_hide_action_menu()
	_enter_move_phase(unit)


func _on_wait_pressed() -> void:
	var unit := turn_manager.current_unit
	if unit == null:
		return
	_hide_action_menu()
	grid_overlay.clear_all()
	_enter_facing_phase(unit)


# --- Turn Flow ---

func _on_unit_turn_started(unit: Unit) -> void:
	camera.position = unit.position

	if unit.team == Enums.Team.PLAYER:
		_current_phase = Enums.TurnPhase.AWAITING_INPUT
		_show_action_menu(unit)
	else:
		_start_ai_turn(unit)


func _enter_move_phase(unit: Unit) -> void:
	_current_phase = Enums.TurnPhase.MOVE
	_reachable_tiles = grid.get_reachable_tiles(unit.grid_position, unit.movement, unit.jump)

	var filtered: Array[Vector2i] = []
	for tile in _reachable_tiles:
		if not grid.is_occupied(tile):
			filtered.append(tile)
	_reachable_tiles = filtered

	grid_overlay.show_movement_range(_reachable_tiles)

	var threatened: Array[Vector2i] = []
	for tile in _reachable_tiles:
		var threats := grid.get_threatened_tiles(tile, unit.team)
		if threats.size() > 0 and tile not in threatened:
			threatened.append(tile)
	grid_overlay.show_threatened(threatened)

	grid_cursor.activate(_reachable_tiles, unit.grid_position)


func _show_targeting(ability: AbilityData, unit: Unit) -> void:
	var elev := grid.get_elevation(unit.grid_position)
	_attack_tiles = grid.get_tiles_in_range(unit.grid_position, ability.ability_range, elev)

	# Filter by line of sight for ranged abilities
	if ability.ability_range > 1:
		var los_filtered: Array[Vector2i] = []
		for tile in _attack_tiles:
			if grid.has_line_of_sight(unit.grid_position, tile):
				los_filtered.append(tile)
		_attack_tiles = los_filtered

	# Filter by valid targets
	var valid: Array[Vector2i] = []
	for tile in _attack_tiles:
		var occupant = grid.get_occupant(tile)
		if ability.use_on_enemy:
			if occupant is Unit and occupant.team != unit.team and occupant.is_alive:
				valid.append(tile)
			elif ability.is_terrain_ability():
				valid.append(tile)
		else:
			if occupant is Unit and occupant.team == unit.team and occupant.is_alive:
				valid.append(tile)
	_attack_tiles = valid

	grid_overlay.show_attack_range(_attack_tiles)
	grid_cursor.activate(_attack_tiles, unit.grid_position)


func _enter_facing_phase(unit: Unit) -> void:
	_current_phase = Enums.TurnPhase.CHOOSE_FACING
	grid_cursor.deactivate()
	action_panel.visible = true
	_btn_attack.visible = false
	_btn_ability.visible = false
	_btn_move.visible = false
	_btn_wait.visible = false
	_facing_container.visible = true


func _set_facing(dir: Enums.Facing) -> void:
	var unit := turn_manager.current_unit
	if unit == null:
		return
	unit.facing = dir
	_hide_action_menu()
	grid_overlay.clear_all()
	unit.end_turn()


# --- Input Handling ---

func _on_cell_selected(pos: Vector2i) -> void:
	var unit := turn_manager.current_unit
	if unit == null:
		return

	match _current_phase:
		Enums.TurnPhase.MOVE:
			_execute_move(unit, pos)
		Enums.TurnPhase.ACT:
			_execute_action(unit, pos)


func _execute_move(unit: Unit, target_pos: Vector2i) -> void:
	grid_cursor.deactivate()
	grid_overlay.clear_all()

	var path := grid.find_path(unit.grid_position, target_pos, unit.movement, unit.jump)
	if path.size() == 0 and target_pos != unit.grid_position:
		_show_action_menu(unit)
		return

	grid.clear_occupant(unit.grid_position)

	# Process reactions along movement path
	var prev := unit.grid_position
	for step in path:
		# Opportunity attacks when leaving threatened tiles
		reaction_system.check_opportunity_attacks(unit, prev, step)
		if not unit.is_alive:
			break
		# Snap shots when entering tiles adjacent to ranged enemies
		reaction_system.check_snap_shot(unit, prev, step)
		if not unit.is_alive:
			break
		prev = step

	await unit.animate_move_along_path(path)
	grid.set_occupant(target_pos, unit)
	unit.has_moved = true

	if not unit.is_alive:
		unit.end_turn()
		return

	if not unit.has_acted:
		_show_action_menu(unit)
	else:
		_enter_facing_phase(unit)


func _execute_action(unit: Unit, target_pos: Vector2i) -> void:
	grid_cursor.deactivate()
	grid_overlay.clear_all()

	if _selected_ability == null:
		_show_action_menu(unit)
		return

	var ability := _selected_ability
	_selected_ability = null
	unit.spend_mana(ability.mana_cost)
	unit.set_facing_toward(target_pos)

	# Get all tiles in AoE
	var aoe_tiles := grid.get_aoe_tiles(target_pos, ability.aoe_shape, ability.aoe_size, unit.grid_position)

	if ability.is_terrain_ability():
		_execute_terrain_ability(unit, ability, aoe_tiles)
	elif ability.is_heal():
		_execute_heal_ability(unit, ability, aoe_tiles)
	elif ability.is_buff_or_debuff():
		_execute_buff_ability(unit, ability, aoe_tiles)
	else:
		_execute_damage_ability(unit, ability, aoe_tiles)

	unit.has_acted = true

	if not unit.has_moved:
		_show_action_menu(unit)
	else:
		_enter_facing_phase(unit)


func _execute_damage_ability(attacker: Unit, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	for tile in tiles:
		var target = grid.get_occupant(tile)
		if not target is Unit or not target.is_alive:
			continue
		if target.team == attacker.team:
			continue

		var damage := Combat.calculate_ability_damage(ability, attacker.get_stats_dict(), target.get_stats_dict())

		if Combat.roll_dodge(target.dodge_chance):
			continue

		if Combat.roll_crit(attacker.crit_chance):
			damage += attacker.crit_damage

		# Process defensive reactions before applying damage
		damage = reaction_system.process_defensive_reactions(target, damage)

		target.take_damage(damage)

		# Check for flanking strikes
		reaction_system.check_flanking_strikes(attacker, target)

		# Check for reactive heal on the damaged unit
		if target.is_alive:
			reaction_system.check_reactive_heal(target, damage)


func _execute_heal_ability(caster: Unit, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	for tile in tiles:
		var target = grid.get_occupant(tile)
		if not target is Unit or not target.is_alive:
			continue
		if target.team != caster.team:
			continue
		var heal_amount := Combat.calculate_heal(ability, caster.magic_attack)
		target.heal(heal_amount)


func _execute_buff_ability(caster: Unit, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	for tile in tiles:
		var target = grid.get_occupant(tile)
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


func _execute_terrain_ability(_caster: Unit, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	for tile in tiles:
		if grid.is_occupied(tile):
			continue
		grid.place_terrain(tile, ability.terrain_tile, ability.terrain_duration)
	queue_redraw()


# --- Cursor Feedback ---

func _on_cell_hovered(pos: Vector2i) -> void:
	match _current_phase:
		Enums.TurnPhase.MOVE:
			var unit := turn_manager.current_unit
			if unit and pos in _reachable_tiles:
				var path := grid.find_path(unit.grid_position, pos, unit.movement, unit.jump)
				grid_overlay.show_path(path)
			else:
				grid_overlay.show_path([])
		Enums.TurnPhase.ACT:
			if _selected_ability and pos in _attack_tiles:
				var aoe := grid.get_aoe_tiles(pos, _selected_ability.aoe_shape,
					_selected_ability.aoe_size, turn_manager.current_unit.grid_position)
				grid_overlay.show_aoe_preview(aoe)
			else:
				grid_overlay.show_aoe_preview([])


func _on_cursor_cancelled() -> void:
	var unit := turn_manager.current_unit
	if unit == null:
		return

	grid_cursor.deactivate()
	grid_overlay.clear_all()

	match _current_phase:
		Enums.TurnPhase.MOVE:
			_show_action_menu(unit)
		Enums.TurnPhase.ACT:
			_selected_ability = null
			_show_action_menu(unit)


# --- AI ---

func _start_ai_turn(unit: Unit) -> void:
	_update_turn_info(unit)

	var closest_player: Unit = null
	var closest_dist := 999

	for player in turn_manager.player_units:
		if player.is_alive:
			var dist := _manhattan_distance(unit.grid_position, player.grid_position)
			if dist < closest_dist:
				closest_dist = dist
				closest_player = player

	# Try to attack first (act-then-move)
	var attacked := false
	if closest_player:
		for dir in Grid.DIRECTIONS:
			var adj := unit.grid_position + dir
			var occupant = grid.get_occupant(adj)
			if occupant is Unit and occupant.team == Enums.Team.PLAYER and occupant.is_alive:
				var damage := Combat.calculate_physical_damage(
					unit.physical_attack, occupant.physical_defense)
				if Combat.roll_crit(unit.crit_chance):
					damage += unit.crit_damage
				if not Combat.roll_dodge(occupant.dodge_chance):
					damage = reaction_system.process_defensive_reactions(occupant, damage)
					occupant.take_damage(damage)
					reaction_system.check_flanking_strikes(unit, occupant)
					if occupant.is_alive:
						reaction_system.check_reactive_heal(occupant, damage)
				unit.set_facing_toward(adj)
				attacked = true
				break

	# Then move
	if closest_player and closest_player.is_alive:
		var reachable := grid.get_reachable_tiles(unit.grid_position, unit.movement, unit.jump)
		var best_tile := unit.grid_position
		var best_dist := _manhattan_distance(unit.grid_position, closest_player.grid_position)

		for tile in reachable:
			if grid.is_occupied(tile):
				continue
			var dist := _manhattan_distance(tile, closest_player.grid_position)
			if attacked:
				# If already attacked, move away or stay (basic kiting for ranged)
				if unit.has_reaction_type(Enums.ReactionType.SNAP_SHOT) and dist > best_dist:
					best_dist = dist
					best_tile = tile
			else:
				if dist < best_dist:
					best_dist = dist
					best_tile = tile

		if best_tile != unit.grid_position:
			var path := grid.find_path(unit.grid_position, best_tile, unit.movement, unit.jump)
			grid.clear_occupant(unit.grid_position)

			var prev := unit.grid_position
			for step in path:
				reaction_system.check_opportunity_attacks(unit, prev, step)
				if not unit.is_alive:
					break
				reaction_system.check_snap_shot(unit, prev, step)
				if not unit.is_alive:
					break
				prev = step

			if unit.is_alive:
				await unit.animate_move_along_path(path)
				grid.set_occupant(best_tile, unit)

		# Attack again if not yet attacked and now adjacent
		if not attacked and unit.is_alive:
			for dir in Grid.DIRECTIONS:
				var adj := unit.grid_position + dir
				var occupant = grid.get_occupant(adj)
				if occupant is Unit and occupant.team == Enums.Team.PLAYER and occupant.is_alive:
					var damage := Combat.calculate_physical_damage(
						unit.physical_attack, occupant.physical_defense)
					if Combat.roll_crit(unit.crit_chance):
						damage += unit.crit_damage
					if not Combat.roll_dodge(occupant.dodge_chance):
						damage = reaction_system.process_defensive_reactions(occupant, damage)
						occupant.take_damage(damage)
						reaction_system.check_flanking_strikes(unit, occupant)
						if occupant.is_alive:
							reaction_system.check_reactive_heal(occupant, damage)
					unit.set_facing_toward(adj)
					break

	await get_tree().create_timer(0.6).timeout
	unit.end_turn()


func _manhattan_distance(a: Vector2i, b: Vector2i) -> int:
	return absi(a.x - b.x) + absi(a.y - b.y)


func _on_battle_ended(player_won: bool) -> void:
	grid_cursor.deactivate()
	grid_overlay.clear_all()
	_hide_action_menu()
	if player_won:
		turn_info.text = "VICTORY! The enemies have been vanquished."
	else:
		turn_info.text = "DEFEAT... The party has fallen."


# --- Grid Drawing ---

func _draw() -> void:
	if grid == null:
		return

	for x in range(grid.width):
		for y in range(grid.height):
			var pos := Vector2i(x, y)
			var rect := Rect2(Vector2(x * 64, y * 64), Vector2(64, 64))
			var elevation := grid.get_elevation(pos)

			if not grid.is_walkable(pos):
				if grid._destructible_hp[grid._idx(pos)] > 0:
					draw_rect(rect, Color(0.45, 0.35, 0.25), true)
				else:
					draw_rect(rect, Color(0.3, 0.25, 0.2), true)
			elif grid.get_movement_cost(pos) > 1:
				draw_rect(rect, Color(0.5, 0.55, 0.3), true)
			elif elevation >= 2:
				draw_rect(rect, Color(0.6, 0.65, 0.5), true)
			elif elevation >= 1:
				draw_rect(rect, Color(0.55, 0.6, 0.45), true)
			else:
				draw_rect(rect, Color(0.4, 0.55, 0.35), true)

			draw_rect(rect, Color(0.2, 0.2, 0.2, 0.3), false, 1.0)

			if elevation > 0:
				var elev_pos := Vector2(x * 64 + 2, y * 64 + 12)
				draw_string(ThemeDB.fallback_font, elev_pos, "h%d" % elevation,
					HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(1, 1, 1, 0.5))
