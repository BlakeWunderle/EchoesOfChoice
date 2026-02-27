class_name GridCursor extends Node2D

signal cell_selected(pos: Vector2i)
signal cell_hovered(pos: Vector2i)
signal cancelled

var grid_position: Vector2i = Vector2i.ZERO
var active: bool = false
var valid_cells: Array[Vector2i] = []

const TILE_SIZE := 64
const CURSOR_COLOR := Color(1.0, 0.9, 0.2)
const CURSOR_INVALID_COLOR := Color(0.6, 0.6, 0.6)
const CORNER_LEN := 12.0
const LINE_WIDTH := 3.0

var _pulse_time: float = 0.0
var _repeat_timer: float = 0.0
var _is_repeating: bool = false
const _REPEAT_DELAY := 0.4
const _REPEAT_INTERVAL := 0.12


func _ready() -> void:
	set_process_input(false)


func _process(delta: float) -> void:
	if active:
		_pulse_time += delta
		_handle_held_direction(delta)
		queue_redraw()


func _draw() -> void:
	if not active:
		return
	var is_valid := grid_position in valid_cells
	var base_color := CURSOR_COLOR if is_valid else CURSOR_INVALID_COLOR
	var pulse := 0.7 + 0.3 * sin(_pulse_time * 4.0)
	var color := Color(base_color.r, base_color.g, base_color.b, pulse)

	var half := TILE_SIZE / 2.0
	var tl := Vector2(-half, -half)
	var tr := Vector2(half, -half)
	var bl := Vector2(-half, half)
	var br := Vector2(half, half)

	# Corner brackets
	draw_line(tl, tl + Vector2(CORNER_LEN, 0), color, LINE_WIDTH)
	draw_line(tl, tl + Vector2(0, CORNER_LEN), color, LINE_WIDTH)

	draw_line(tr, tr + Vector2(-CORNER_LEN, 0), color, LINE_WIDTH)
	draw_line(tr, tr + Vector2(0, CORNER_LEN), color, LINE_WIDTH)

	draw_line(bl, bl + Vector2(CORNER_LEN, 0), color, LINE_WIDTH)
	draw_line(bl, bl + Vector2(0, -CORNER_LEN), color, LINE_WIDTH)

	draw_line(br, br + Vector2(-CORNER_LEN, 0), color, LINE_WIDTH)
	draw_line(br, br + Vector2(0, -CORNER_LEN), color, LINE_WIDTH)


func activate(valid: Array[Vector2i], start_pos: Vector2i = Vector2i.ZERO) -> void:
	valid_cells = valid
	grid_position = start_pos
	active = true
	_update_position()
	set_process_input(true)
	visible = true


func deactivate() -> void:
	active = false
	set_process_input(false)
	visible = false


func _input(event: InputEvent) -> void:
	if not active:
		return

	if event.is_action_pressed("move_up"):
		_move_cursor(Vector2i(0, -1))
		_repeat_timer = 0.0
		_is_repeating = false
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("move_down"):
		_move_cursor(Vector2i(0, 1))
		_repeat_timer = 0.0
		_is_repeating = false
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("move_left"):
		_move_cursor(Vector2i(-1, 0))
		_repeat_timer = 0.0
		_is_repeating = false
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("move_right"):
		_move_cursor(Vector2i(1, 0))
		_repeat_timer = 0.0
		_is_repeating = false
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("confirm"):
		if grid_position in valid_cells:
			SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
			cell_selected.emit(grid_position)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("cancel"):
		SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
		cancelled.emit()
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton:
		_handle_mouse_button(event as InputEventMouseButton)
	elif event is InputEventMouseMotion:
		_handle_mouse_motion(event as InputEventMouseMotion)


func _handle_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var cell := _screen_to_grid(event.position)
		grid_position = cell
		_update_position()
		if grid_position in valid_cells:
			SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
			cell_selected.emit(grid_position)
		else:
			cell_hovered.emit(grid_position)
		get_viewport().set_input_as_handled()
	elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
		cancelled.emit()
		get_viewport().set_input_as_handled()


func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	var cell := _screen_to_grid(event.position)
	if cell != grid_position:
		grid_position = cell
		_update_position()
		cell_hovered.emit(grid_position)


func _screen_to_grid(screen_pos: Vector2) -> Vector2i:
	var world_pos := get_viewport().get_canvas_transform().affine_inverse() * screen_pos
	return Vector2i(int(floor(world_pos.x / TILE_SIZE)), int(floor(world_pos.y / TILE_SIZE)))


func _handle_held_direction(delta: float) -> void:
	var dir := Vector2i.ZERO
	if Input.is_action_pressed("move_up"):
		dir = Vector2i(0, -1)
	elif Input.is_action_pressed("move_down"):
		dir = Vector2i(0, 1)
	elif Input.is_action_pressed("move_left"):
		dir = Vector2i(-1, 0)
	elif Input.is_action_pressed("move_right"):
		dir = Vector2i(1, 0)

	if dir == Vector2i.ZERO:
		_repeat_timer = 0.0
		_is_repeating = false
		return

	_repeat_timer += delta
	var threshold := _REPEAT_INTERVAL if _is_repeating else _REPEAT_DELAY
	if _repeat_timer >= threshold:
		_move_cursor(dir)
		_repeat_timer = 0.0
		_is_repeating = true


func _move_cursor(dir: Vector2i) -> void:
	var new_pos := grid_position + dir
	grid_position = new_pos
	_update_position()
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.3)
	cell_hovered.emit(grid_position)


func _update_position() -> void:
	position = Vector2(grid_position.x * TILE_SIZE + TILE_SIZE / 2, grid_position.y * TILE_SIZE + TILE_SIZE / 2)
