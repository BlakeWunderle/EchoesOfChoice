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
var _dialogue_box_scene: PackedScene = preload("res://scenes/ui/DialogueBox.tscn")

var _battle_config: BattleConfig
var _current_phase: Enums.TurnPhase = Enums.TurnPhase.AWAITING_INPUT
var _selected_ability: AbilityData = null
var _selected_item: ItemData = null
var _reachable_tiles: Array[Vector2i] = []
var _attack_tiles: Array[Vector2i] = []


func _ready() -> void:
	var battle_id := GameState.current_battle_id
	var config := _get_battle_config(battle_id)
	if config:
		_setup_from_config(config)
	elif not battle_id.is_empty():
		_setup_from_config(BattleConfig.create_placeholder(battle_id))
	else:
		_setup_test_battle()


static var _config_creators: Dictionary = {
	"tutorial": BattleConfig.create_tutorial,
	"city_street": BattleConfig.create_city_street,
	"forest": BattleConfig.create_forest,
	"village_raid": BattleConfig.create_village_raid,
	"smoke": BattleConfig.create_smoke,
	"deep_forest": BattleConfig.create_deep_forest,
	"clearing": BattleConfig.create_clearing,
	"ruins": BattleConfig.create_ruins,
	"cave": BattleConfig.create_cave,
	"portal": BattleConfig.create_portal,
	"inn_ambush": BattleConfig.create_inn_ambush,
	"shore": BattleConfig.create_shore,
	"beach": BattleConfig.create_beach,
	"cemetery_battle": BattleConfig.create_cemetery_battle,
	"box_battle": BattleConfig.create_box_battle,
	"army_battle": BattleConfig.create_army_battle,
	"lab_battle": BattleConfig.create_lab_battle,
	"mirror_battle": BattleConfig.create_mirror_battle,
	"gate_ambush": BattleConfig.create_gate_ambush,
	"city_gate_ambush": BattleConfig.create_city_gate_ambush,
	"return_city_1": BattleConfig.create_return_city_1,
	"return_city_2": BattleConfig.create_return_city_2,
	"return_city_3": BattleConfig.create_return_city_3,
	"return_city_4": BattleConfig.create_return_city_4,
	"elemental_1": BattleConfig.create_elemental_1,
	"elemental_2": BattleConfig.create_elemental_2,
	"elemental_3": BattleConfig.create_elemental_3,
	"elemental_4": BattleConfig.create_elemental_4,
	"final_castle": BattleConfig.create_final_castle,
	"travel_ambush": BattleConfig.create_travel_ambush,
}


func _get_battle_config(battle_id: String) -> BattleConfig:
	if _config_creators.has(battle_id):
		return _config_creators[battle_id].call()
	return null


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
	_begin_battle()


func _setup_from_config(config: BattleConfig) -> void:
	_battle_config = config
	grid = Grid.new(config.grid_width, config.grid_height)
	reaction_system = ReactionSystem.new(grid)

	for x in range(config.grid_width):
		for y in range(config.grid_height):
			grid.set_tile(Vector2i(x, y), true, 1, 0)

	var terrain_overrides: Array = BattleConfig.get_terrain_overrides(config)
	for t in terrain_overrides:
		var pos: Vector2i = t["pos"]
		grid.set_tile(pos, t["walkable"], t["cost"], t["elevation"], t["blocks_los"], t.get("destructible_hp", 0))

	for entry in config.player_units:
		var unit := _spawn_unit(entry["data"], entry["name"], Enums.Team.PLAYER, entry["pos"], entry["level"])
		var member_xp := _find_party_member_xp(entry["name"])
		unit.initialize_xp(member_xp[0], member_xp[1])

	for entry in config.enemy_units:
		_spawn_unit(entry["data"], entry["name"], Enums.Team.ENEMY, entry["pos"], entry["level"])

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
	_begin_battle()


func _begin_battle() -> void:
	if _battle_config and _battle_config.pre_battle_dialogue.size() > 0:
		await _show_dialogue(_battle_config.pre_battle_dialogue)
	turn_manager.run_battle()


func _show_dialogue(lines: Array[Dictionary]) -> void:
	var dialogue_box: Control = _dialogue_box_scene.instantiate()
	$HUD.add_child(dialogue_box)
	dialogue_box.show_dialogue(lines)
	await dialogue_box.dialogue_finished
	dialogue_box.queue_free()


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
var _btn_item: Button
var _btn_move: Button
var _btn_wait: Button
var _btn_facing_n: Button
var _btn_facing_s: Button
var _btn_facing_e: Button
var _btn_facing_w: Button
var _facing_container: HBoxContainer
var _ability_container: VBoxContainer
var _item_container: VBoxContainer


func _build_action_panel() -> void:
	_btn_attack = Button.new()
	_btn_attack.text = "Attack"
	_btn_attack.pressed.connect(_on_attack_pressed)
	action_panel.add_child(_btn_attack)

	_btn_ability = Button.new()
	_btn_ability.text = "Ability"
	_btn_ability.pressed.connect(_on_ability_pressed)
	action_panel.add_child(_btn_ability)

	_btn_item = Button.new()
	_btn_item.text = "Item"
	_btn_item.pressed.connect(_on_item_pressed)
	action_panel.add_child(_btn_item)

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

	_item_container = VBoxContainer.new()
	_item_container.visible = false
	action_panel.add_child(_item_container)

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
	_item_container.visible = false
	_facing_container.visible = false

	_btn_attack.visible = not unit.has_acted
	_btn_ability.visible = not unit.has_acted and unit.has_any_affordable_ability()
	_btn_item.visible = not unit.has_acted and _has_usable_items()
	_btn_move.visible = not unit.has_moved
	_btn_wait.visible = true

	_update_turn_info(unit)


func _hide_action_menu() -> void:
	action_panel.visible = false
	_ability_container.visible = false
	_item_container.visible = false
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
	_btn_item.visible = false
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


func _on_item_pressed() -> void:
	var unit := turn_manager.current_unit
	if unit == null or unit.has_acted:
		return

	for child in _item_container.get_children():
		child.queue_free()

	var consumables := GameState.get_consumables_in_inventory()
	for entry in consumables:
		var item: ItemData = entry["item"]
		var qty: int = entry["quantity"]
		var btn := Button.new()
		btn.text = "%s x%d  (%s)" % [item.display_name, qty, item.get_stat_summary()]
		btn.pressed.connect(func(): _on_item_selected(item))
		_item_container.add_child(btn)

	var back_btn := Button.new()
	back_btn.text = "Back"
	back_btn.pressed.connect(func():
		_item_container.visible = false
		_show_action_menu(unit)
	)
	_item_container.add_child(back_btn)

	_item_container.visible = true
	_btn_attack.visible = false
	_btn_ability.visible = false
	_btn_item.visible = false
	_btn_move.visible = false
	_btn_wait.visible = false


func _on_item_selected(item: ItemData) -> void:
	var unit := turn_manager.current_unit
	if unit == null:
		return
	_selected_item = item
	_hide_action_menu()
	_current_phase = Enums.TurnPhase.ACT

	var target_tiles: Array[Vector2i] = []
	match item.consumable_effect:
		Enums.ConsumableEffect.HEAL_HP, Enums.ConsumableEffect.RESTORE_MANA, Enums.ConsumableEffect.BUFF_STAT:
			target_tiles = _get_ally_tiles(unit)

	if target_tiles.is_empty():
		target_tiles.append(unit.grid_position)

	grid_overlay.show_attack_range(target_tiles)
	_attack_tiles = target_tiles
	grid_cursor.activate(target_tiles, unit.grid_position)


func _get_ally_tiles(user: Unit) -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for child in units_container.get_children():
		if child is Unit and child.is_alive and child.team == user.team:
			tiles.append(child.grid_position)
	return tiles


func _has_usable_items() -> bool:
	return GameState.get_consumables_in_inventory().size() > 0


func _execute_item(unit: Unit, target_pos: Vector2i) -> void:
	grid_cursor.deactivate()
	grid_overlay.clear_all()

	if _selected_item == null:
		_show_action_menu(unit)
		return

	var item := _selected_item
	_selected_item = null

	var target = grid.get_occupant(target_pos)
	if not target is Unit or not target.is_alive:
		target = unit

	if not GameState.remove_item(item.item_id):
		_show_action_menu(unit)
		return

	match item.consumable_effect:
		Enums.ConsumableEffect.HEAL_HP:
			target.heal(item.consumable_value)
		Enums.ConsumableEffect.RESTORE_MANA:
			target.mana = mini(target.mana + item.consumable_value, target.max_mana)
		Enums.ConsumableEffect.BUFF_STAT:
			var ms := ModifiedStat.create(item.buff_stat, item.consumable_value, item.buff_turns, false)
			target.modified_stats.append(ms)
			target.apply_stat_modifier(item.buff_stat, item.consumable_value, false)

	unit.has_acted = true

	if not unit.has_moved:
		_show_action_menu(unit)
	else:
		_enter_facing_phase(unit)


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

	# Fire tile damage at start of turn
	var fire_positions := grid.get_active_terrain_positions(Enums.TileType.FIRE_TILE)
	if unit.grid_position in fire_positions:
		_apply_fire_damage(unit)
		if not unit.is_alive:
			unit.end_turn()
			return

	if unit.team == Enums.Team.PLAYER:
		_current_phase = Enums.TurnPhase.AWAITING_INPUT
		_show_action_menu(unit)
	else:
		_start_ai_turn(unit)


func _apply_fire_damage(unit: Unit) -> void:
	var dmg := max(1, 10 - unit.mag_def)
	unit.take_damage(dmg)


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
		if ability.is_terrain_ability():
			valid.append(tile)  # terrain can be placed on any in-range tile
		elif ability.use_on_enemy:
			if occupant is Unit and occupant.team != unit.team and occupant.is_alive:
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
	_btn_item.visible = false
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
			if _selected_item != null:
				_execute_item(unit, pos)
			else:
				_execute_action(unit, pos)


func _execute_move(unit: Unit, target_pos: Vector2i) -> void:
	grid_cursor.deactivate()
	grid_overlay.clear_all()

	var path := grid.find_path(unit.grid_position, target_pos, unit.movement, unit.jump)
	if path.size() == 0 and target_pos != unit.grid_position:
		_show_action_menu(unit)
		return

	grid.clear_occupant(unit.grid_position)

	# Check for trap tiles along the path; truncate movement there
	var trap_positions := grid.get_active_terrain_positions(Enums.TileType.TRAP)
	var trap_step_idx := -1
	for i in range(path.size()):
		if path[i] in trap_positions:
			trap_step_idx = i
			break

	var actual_path := path
	var actual_dest := target_pos
	if trap_step_idx >= 0:
		actual_path = path.slice(0, trap_step_idx + 1)
		actual_dest = path[trap_step_idx]

	# Process reactions along actual movement path
	var prev := unit.grid_position
	for step in actual_path:
		# Opportunity attacks when leaving threatened tiles
		reaction_system.check_opportunity_attacks(unit, prev, step)
		if not unit.is_alive:
			break
		# Snap shots when entering tiles adjacent to ranged enemies
		reaction_system.check_snap_shot(unit, prev, step)
		if not unit.is_alive:
			break
		prev = step

	await unit.animate_move_along_path(actual_path)
	grid.set_occupant(actual_dest, unit)
	unit.has_moved = true

	if not unit.is_alive:
		unit.end_turn()
		return

	# Trigger trap if unit stepped on one — forfeits their action
	if trap_step_idx >= 0 and grid.trigger_trap(actual_dest):
		queue_redraw()
		unit.has_acted = true
		_enter_facing_phase(unit)
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
	var got_crit := false
	var got_kill := false

	for tile in tiles:
		var target = grid.get_occupant(tile)
		if not target is Unit or not target.is_alive:
			continue
		if target.team == attacker.team:
			continue

		var damage := Combat.calculate_ability_damage(ability, attacker.get_stats_dict(), target.get_stats_dict())

		if Combat.roll_dodge(target.dodge_chance):
			continue

		var this_crit := Combat.roll_crit(attacker.crit_chance)
		if this_crit:
			damage += attacker.crit_damage
			got_crit = true

		damage = reaction_system.process_defensive_reactions(target, damage)

		target.take_damage(damage)

		if not target.is_alive:
			got_kill = true

		reaction_system.check_flanking_strikes(attacker, target)

		if target.is_alive:
			reaction_system.check_reactive_heal(target, damage)

	attacker.award_ability_xp_jp(ability, got_crit, got_kill)


func _execute_heal_ability(caster: Unit, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	for tile in tiles:
		var target = grid.get_occupant(tile)
		if not target is Unit or not target.is_alive:
			continue
		if target.team != caster.team:
			continue
		var amount := Combat.calculate_heal(ability, caster.magic_attack)
		if ability.modified_stat == Enums.StatType.MAX_MANA:
			target.restore_mana(amount)
		else:
			target.heal(amount)

	caster.award_ability_xp_jp(ability, false, false)


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

	caster.award_ability_xp_jp(ability, false, false)


func _execute_terrain_ability(caster: Unit, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	var blocks_movement := ability.terrain_tile == Enums.TileType.WALL \
		or ability.terrain_tile == Enums.TileType.ICE_WALL
	for tile in tiles:
		if blocks_movement and grid.is_occupied(tile):
			continue
		grid.place_terrain(tile, ability.terrain_tile, ability.terrain_duration)
		# Deal immediate fire damage to any unit already on a lava tile
		if ability.terrain_tile == Enums.TileType.FIRE_TILE:
			var occupant = grid.get_occupant(tile)
			if occupant is Unit and occupant.is_alive:
				_apply_fire_damage(occupant)
	caster.award_ability_xp_jp(ability, false, false)
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
			_selected_item = null
			_show_action_menu(unit)


# --- AI ---

func _start_ai_turn(unit: Unit) -> void:
	_update_turn_info(unit)
	await get_tree().create_timer(0.3).timeout

	# Act-then-move: try best ability from current position first
	var pre_action := _ai_best_action(unit, unit.grid_position)
	if pre_action.size() > 0:
		_ai_perform_action(unit, pre_action)
		await get_tree().create_timer(0.3).timeout

	# Move to optimal position
	if unit.is_alive and not unit.has_moved:
		var move_dest := _ai_best_move(unit)
		if move_dest != unit.grid_position:
			var path := grid.find_path(unit.grid_position, move_dest, unit.movement, unit.jump)
			grid.clear_occupant(unit.grid_position)

			# Check for traps along AI movement path
			var ai_trap_positions := grid.get_active_terrain_positions(Enums.TileType.TRAP)
			var ai_trap_idx := -1
			for i in range(path.size()):
				if path[i] in ai_trap_positions:
					ai_trap_idx = i
					break
			var ai_actual_path := path
			var ai_actual_dest := move_dest
			if ai_trap_idx >= 0:
				ai_actual_path = path.slice(0, ai_trap_idx + 1)
				ai_actual_dest = path[ai_trap_idx]

			var prev := unit.grid_position
			for step in ai_actual_path:
				reaction_system.check_opportunity_attacks(unit, prev, step)
				if not unit.is_alive:
					break
				reaction_system.check_snap_shot(unit, prev, step)
				if not unit.is_alive:
					break
				prev = step
			if unit.is_alive:
				await unit.animate_move_along_path(ai_actual_path)
				grid.set_occupant(ai_actual_dest, unit)
				if ai_trap_idx >= 0 and grid.trigger_trap(ai_actual_dest):
					queue_redraw()
					unit.has_acted = true
			unit.has_moved = true

	# Act-after-move: if didn't act before moving, try from new position
	if unit.is_alive and not unit.has_acted:
		var post_action := _ai_best_action(unit, unit.grid_position)
		if post_action.size() > 0:
			_ai_perform_action(unit, post_action)
			await get_tree().create_timer(0.3).timeout

	await get_tree().create_timer(0.4).timeout
	unit.end_turn()


func _ai_best_action(unit: Unit, from_pos: Vector2i) -> Dictionary:
	var best_score := 0.0
	var best := {}
	for ability in unit.get_affordable_abilities():
		var elev := grid.get_elevation(from_pos)
		var in_range := grid.get_tiles_in_range(from_pos, ability.ability_range, elev)
		for tile in in_range:
			var score := _ai_score_action(unit, ability, tile, from_pos)
			if score > best_score:
				best_score = score
				best = {"ability": ability, "target_pos": tile}
	return best


func _ai_score_action(unit: Unit, ability: AbilityData, target_tile: Vector2i, from_pos: Vector2i) -> float:
	var aoe_tiles := grid.get_aoe_tiles(target_tile, ability.aoe_shape, ability.aoe_size, from_pos)
	var score := 0.0
	if ability.is_heal():
		for tile in aoe_tiles:
			var target = grid.get_occupant(tile)
			if target is Unit and target.is_alive and target.team == unit.team:
				score += float(target.max_health - target.health)
	elif ability.ability_type == Enums.AbilityType.BUFF:
		for tile in aoe_tiles:
			var target = grid.get_occupant(tile)
			if target is Unit and target.is_alive and target.team == unit.team:
				score += 8.0
	elif ability.ability_type == Enums.AbilityType.DEBUFF:
		for tile in aoe_tiles:
			var target = grid.get_occupant(tile)
			if target is Unit and target.is_alive and target.team != unit.team:
				score += 8.0
	elif ability.is_terrain_ability():
		# Score terrain by how many enemies are near the target area
		for player_unit in turn_manager.player_units:
			if player_unit.is_alive:
				var dist := _manhattan_distance(target_tile, player_unit.grid_position)
				if dist <= 2:
					score += 6.0
	else:
		for tile in aoe_tiles:
			var target = grid.get_occupant(tile)
			if target is Unit and target.is_alive and target.team != unit.team:
				var damage := Combat.calculate_ability_damage(ability, unit.get_stats_dict(), target.get_stats_dict())
				var hp_ratio := float(target.health) / float(target.max_health)
				score += float(damage) * (2.0 - hp_ratio)
	return score


func _ai_perform_action(unit: Unit, action: Dictionary) -> void:
	var ability: AbilityData = action["ability"]
	var target_pos: Vector2i = action["target_pos"]
	unit.set_facing_toward(target_pos)
	unit.spend_mana(ability.mana_cost)
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


func _ai_best_move(unit: Unit) -> Vector2i:
	var reachable := grid.get_reachable_tiles(unit.grid_position, unit.movement, unit.jump)
	var best_tile := unit.grid_position
	var best_score := -INF
	for tile in reachable:
		if grid.is_occupied(tile):
			continue
		var score := _ai_score_move_tile(unit, tile)
		if score > best_score:
			best_score = score
			best_tile = tile
	return best_tile


func _ai_score_move_tile(unit: Unit, tile: Vector2i) -> float:
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
		for ally in turn_manager.enemy_units:
			if ally.is_alive and ally != unit:
				var missing := ally.max_health - ally.health
				if missing > 0:
					var dist := _manhattan_distance(tile, ally.grid_position)
					heal_score += float(missing) / float(dist + 1)
		if heal_score > 0.0:
			return heal_score

	var weakest: Unit = null
	var lowest_hp := INF
	for player in turn_manager.player_units:
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


func _find_party_member_xp(unit_name: String) -> Array:
	for member in GameState.party_members:
		if member["name"] == unit_name:
			return [member.get("xp", 0), member.get("jp", 0)]
	return [0, 0]


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

	var player_units_list: Array = []
	for child in units_container.get_children():
		if child is Unit and child.team == Enums.Team.PLAYER:
			player_units_list.append(child)

	var gold_earned := 0
	var item_rewards_earned: Array[String] = []
	var pending_reward_choices: Array = []
	if player_won:
		var node_data: Dictionary = MapData.get_node(GameState.current_battle_id)
		var battle_prog: int = node_data.get("progression", 0)
		if battle_prog >= 0:
			GameState.advance_progression(battle_prog)
		gold_earned = int(node_data.get("gold_reward", 0))
		if gold_earned > 0:
			GameState.add_gold(gold_earned)
		for item_id in node_data.get("item_rewards", []):
			GameState.add_item(item_id)
			item_rewards_earned.append(item_id)
		pending_reward_choices = node_data.get("reward_choices", [])

	var fallen: Array[String] = GameState.update_party_after_battle(player_units_list)
	var mc_died := fallen.size() > 0 and fallen[0] == GameState.player_name

	await get_tree().create_timer(2.0).timeout

	if mc_died:
		SceneManager.go_to_game_over()
		return

	if player_won and _battle_config and _battle_config.post_battle_dialogue.size() > 0:
		await _show_dialogue(_battle_config.post_battle_dialogue)

	if player_won and pending_reward_choices.size() > 0:
		var chosen_id: String = await _show_reward_choice(pending_reward_choices)
		if not chosen_id.is_empty():
			GameState.add_item(chosen_id)
			item_rewards_earned.append(chosen_id)

	if GameState.current_battle_id == "tutorial":
		GameState.set_flag("tutorial_complete")
		SceneManager.go_to_class_selection()
	else:
		if player_won and (_has_xp_gains(player_units_list) or gold_earned > 0 or fallen.size() > 0 or item_rewards_earned.size() > 0):
			_show_battle_summary(player_units_list, gold_earned, fallen, item_rewards_earned)
		elif player_won:
			GameState.complete_battle(GameState.current_battle_id)
			SceneManager.go_to_overworld()
		else:
			SceneManager.go_to_overworld()


func _has_xp_gains(units: Array) -> bool:
	for u in units:
		if u is Unit and (u.xp_gained_this_battle > 0 or u.jp_gained_this_battle > 0):
			return true
	return false


func _show_battle_summary(units: Array, gold_earned: int = 0, fallen: Array[String] = [], item_rewards: Array[String] = []) -> void:
	var summary_scene := preload("res://scenes/battle/BattleSummary.tscn")
	var summary: Control = summary_scene.instantiate()
	summary.setup(units, gold_earned, fallen, item_rewards)
	summary.summary_closed.connect(func():
		GameState.complete_battle(GameState.current_battle_id)
		SceneManager.go_to_overworld()
	)
	$HUD.add_child(summary)


func _show_reward_choice(choices: Array) -> String:
	var choice_scene := preload("res://scenes/ui/RewardChoiceUI.tscn")
	var choice_ui: Control = choice_scene.instantiate()
	var choice_items: Array = []
	for item_id: String in choices:
		var item: Resource = GameState.get_item_resource(item_id)
		if item:
			choice_items.append(item)
	choice_ui.setup(choice_items)
	$HUD.add_child(choice_ui)
	var chosen_id: String = await choice_ui.item_chosen
	choice_ui.queue_free()
	return chosen_id


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

	# Draw active terrain effect overlays on top of base tiles
	for pos in grid.get_active_terrain_positions(Enums.TileType.FIRE_TILE):
		draw_rect(Rect2(Vector2(pos.x * 64, pos.y * 64), Vector2(64, 64)), Color(1.0, 0.3, 0.0, 0.4), true)
	for pos in grid.get_active_terrain_positions(Enums.TileType.WATER):
		draw_rect(Rect2(Vector2(pos.x * 64, pos.y * 64), Vector2(64, 64)), Color(0.1, 0.4, 1.0, 0.4), true)
	for pos in grid.get_active_terrain_positions(Enums.TileType.ROUGH_TERRAIN):
		draw_rect(Rect2(Vector2(pos.x * 64, pos.y * 64), Vector2(64, 64)), Color(0.5, 0.35, 0.1, 0.4), true)
	for pos in grid.get_active_terrain_positions(Enums.TileType.TRAP):
		draw_rect(Rect2(Vector2(pos.x * 64, pos.y * 64), Vector2(64, 64)), Color(0.8, 0.2, 0.8, 0.45), true)
