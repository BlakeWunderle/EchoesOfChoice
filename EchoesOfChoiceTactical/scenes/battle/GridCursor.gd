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


func _ready() -> void:
	set_process_input(false)


func _process(delta: float) -> void:
	if active:
		_pulse_time += delta
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

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_UP, KEY_W:
				_move_cursor(Vector2i(0, -1))
			KEY_DOWN, KEY_S:
				_move_cursor(Vector2i(0, 1))
			KEY_LEFT, KEY_A:
				_move_cursor(Vector2i(-1, 0))
			KEY_RIGHT, KEY_D:
				_move_cursor(Vector2i(1, 0))
			KEY_ENTER, KEY_SPACE, KEY_Z:
				if grid_position in valid_cells:
					SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
					cell_selected.emit(grid_position)
			KEY_ESCAPE, KEY_X:
				SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
				cancelled.emit()


func _move_cursor(dir: Vector2i) -> void:
	var new_pos := grid_position + dir
	grid_position = new_pos
	_update_position()
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.3)
	cell_hovered.emit(grid_position)


func _update_position() -> void:
	position = Vector2(grid_position.x * TILE_SIZE + TILE_SIZE / 2, grid_position.y * TILE_SIZE + TILE_SIZE / 2)
