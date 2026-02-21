class_name GridCursor extends Node2D

signal cell_selected(pos: Vector2i)
signal cell_hovered(pos: Vector2i)
signal cancelled

var grid_position: Vector2i = Vector2i.ZERO
var active: bool = false
var valid_cells: Array[Vector2i] = []

const TILE_SIZE := 64


func _ready() -> void:
	set_process_input(false)


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
					cell_selected.emit(grid_position)
			KEY_ESCAPE, KEY_X:
				cancelled.emit()


func _move_cursor(dir: Vector2i) -> void:
	var new_pos := grid_position + dir
	grid_position = new_pos
	_update_position()
	cell_hovered.emit(grid_position)


func _update_position() -> void:
	position = Vector2(grid_position.x * TILE_SIZE + TILE_SIZE / 2, grid_position.y * TILE_SIZE + TILE_SIZE / 2)
