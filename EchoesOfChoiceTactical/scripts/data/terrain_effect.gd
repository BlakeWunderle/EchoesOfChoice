class_name TerrainEffect extends RefCounted

var grid_position: Vector2i
var tile_type: Enums.TileType
var turns_remaining: int
var original_walkable: bool
var original_movement_cost: int
var original_elevation: int


static func create(pos: Vector2i, type: Enums.TileType, duration: int) -> TerrainEffect:
	var te := TerrainEffect.new()
	te.grid_position = pos
	te.tile_type = type
	te.turns_remaining = duration
	return te
