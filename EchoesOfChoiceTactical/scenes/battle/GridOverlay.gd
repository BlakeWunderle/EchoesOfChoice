class_name GridOverlay extends Node2D

const TILE_SIZE := 64

var _movement_tiles: Array[Vector2i] = []
var _attack_tiles: Array[Vector2i] = []
var _aoe_tiles: Array[Vector2i] = []
var _threatened_tiles: Array[Vector2i] = []
var _path_tiles: Array[Vector2i] = []

var movement_color := Color(0.2, 0.5, 1.0, 0.3)
var attack_color := Color(1.0, 0.2, 0.2, 0.3)
var aoe_color := Color(1.0, 0.6, 0.1, 0.3)
var threatened_color := Color(1.0, 0.0, 0.0, 0.15)
var path_color := Color(0.2, 0.8, 1.0, 0.5)
var heal_color := Color(0.2, 1.0, 0.3, 0.3)


func show_movement_range(tiles: Array[Vector2i]) -> void:
	_movement_tiles = tiles
	queue_redraw()


func show_attack_range(tiles: Array[Vector2i]) -> void:
	_attack_tiles = tiles
	queue_redraw()


func show_aoe_preview(tiles: Array[Vector2i]) -> void:
	_aoe_tiles = tiles
	queue_redraw()


func show_threatened(tiles: Array[Vector2i]) -> void:
	_threatened_tiles = tiles
	queue_redraw()


func show_path(tiles: Array[Vector2i]) -> void:
	_path_tiles = tiles
	queue_redraw()


func clear_all() -> void:
	_movement_tiles.clear()
	_attack_tiles.clear()
	_aoe_tiles.clear()
	_threatened_tiles.clear()
	_path_tiles.clear()
	queue_redraw()


func clear_movement() -> void:
	_movement_tiles.clear()
	queue_redraw()


func clear_attack() -> void:
	_attack_tiles.clear()
	_aoe_tiles.clear()
	queue_redraw()


func _draw() -> void:
	for tile in _threatened_tiles:
		_draw_tile(tile, threatened_color)
		_draw_tile_border(tile, Color(1.0, 0.0, 0.0, 0.4))

	for tile in _movement_tiles:
		_draw_tile(tile, movement_color)

	for tile in _attack_tiles:
		_draw_tile(tile, attack_color)

	for tile in _aoe_tiles:
		_draw_tile(tile, aoe_color)

	for tile in _path_tiles:
		_draw_tile(tile, path_color)


func _draw_tile(pos: Vector2i, color: Color) -> void:
	var rect := Rect2(Vector2(pos.x * TILE_SIZE, pos.y * TILE_SIZE), Vector2(TILE_SIZE, TILE_SIZE))
	draw_rect(rect, color, true)


func _draw_tile_border(pos: Vector2i, color: Color) -> void:
	var rect := Rect2(Vector2(pos.x * TILE_SIZE, pos.y * TILE_SIZE), Vector2(TILE_SIZE, TILE_SIZE))
	draw_rect(rect, color, false, 2.0)
