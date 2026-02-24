class_name BattleTerrainRenderer extends Node2D

const TILE_SIZE := 64

var _grid: Grid
var _environment: String = "grassland"

# Color palettes per environment: {ground, ground_alt, wall, elevation_tint, grid_line}
const PALETTES := {
	"grassland": {
		"ground": Color(0.28, 0.45, 0.22),
		"ground_alt": Color(0.25, 0.42, 0.20),
		"wall": Color(0.4, 0.35, 0.28),
		"elevation_tint": Color(1.1, 1.1, 0.95),
		"grid_line": Color(0.2, 0.35, 0.15, 0.25),
	},
	"forest": {
		"ground": Color(0.18, 0.32, 0.14),
		"ground_alt": Color(0.16, 0.30, 0.12),
		"wall": Color(0.3, 0.2, 0.1),
		"elevation_tint": Color(1.05, 1.1, 0.95),
		"grid_line": Color(0.1, 0.22, 0.08, 0.25),
	},
	"city": {
		"ground": Color(0.42, 0.38, 0.32),
		"ground_alt": Color(0.40, 0.36, 0.30),
		"wall": Color(0.5, 0.45, 0.4),
		"elevation_tint": Color(1.1, 1.08, 1.05),
		"grid_line": Color(0.3, 0.28, 0.24, 0.3),
	},
	"cave": {
		"ground": Color(0.22, 0.2, 0.25),
		"ground_alt": Color(0.20, 0.18, 0.23),
		"wall": Color(0.35, 0.3, 0.28),
		"elevation_tint": Color(1.0, 1.0, 1.15),
		"grid_line": Color(0.15, 0.13, 0.18, 0.3),
	},
	"ruins": {
		"ground": Color(0.35, 0.32, 0.28),
		"ground_alt": Color(0.33, 0.30, 0.26),
		"wall": Color(0.48, 0.44, 0.4),
		"elevation_tint": Color(1.1, 1.05, 1.0),
		"grid_line": Color(0.25, 0.23, 0.2, 0.25),
	},
	"cemetery": {
		"ground": Color(0.2, 0.22, 0.18),
		"ground_alt": Color(0.18, 0.2, 0.16),
		"wall": Color(0.45, 0.42, 0.4),
		"elevation_tint": Color(1.0, 1.05, 1.1),
		"grid_line": Color(0.12, 0.14, 0.1, 0.3),
	},
	"shore": {
		"ground": Color(0.7, 0.65, 0.45),
		"ground_alt": Color(0.65, 0.6, 0.42),
		"wall": Color(0.5, 0.48, 0.35),
		"elevation_tint": Color(1.1, 1.1, 1.0),
		"grid_line": Color(0.5, 0.45, 0.3, 0.25),
	},
	"inn": {
		"ground": Color(0.4, 0.3, 0.2),
		"ground_alt": Color(0.38, 0.28, 0.18),
		"wall": Color(0.5, 0.4, 0.3),
		"elevation_tint": Color(1.1, 1.05, 1.0),
		"grid_line": Color(0.3, 0.22, 0.15, 0.3),
	},
	"scorched": {
		"ground": Color(0.3, 0.25, 0.2),
		"ground_alt": Color(0.28, 0.23, 0.18),
		"wall": Color(0.25, 0.2, 0.15),
		"elevation_tint": Color(1.1, 1.0, 0.9),
		"grid_line": Color(0.2, 0.16, 0.12, 0.3),
	},
	"lab": {
		"ground": Color(0.35, 0.37, 0.4),
		"ground_alt": Color(0.33, 0.35, 0.38),
		"wall": Color(0.45, 0.47, 0.5),
		"elevation_tint": Color(1.0, 1.05, 1.15),
		"grid_line": Color(0.25, 0.27, 0.3, 0.3),
	},
	"castle": {
		"ground": Color(0.38, 0.35, 0.32),
		"ground_alt": Color(0.36, 0.33, 0.30),
		"wall": Color(0.5, 0.48, 0.45),
		"elevation_tint": Color(1.1, 1.08, 1.05),
		"grid_line": Color(0.28, 0.25, 0.23, 0.25),
	},
	"shrine": {
		"ground": Color(0.28, 0.32, 0.4),
		"ground_alt": Color(0.26, 0.30, 0.38),
		"wall": Color(0.4, 0.42, 0.5),
		"elevation_tint": Color(1.0, 1.08, 1.2),
		"grid_line": Color(0.2, 0.22, 0.3, 0.25),
	},
	"carnival": {
		"ground": Color(0.4, 0.35, 0.25),
		"ground_alt": Color(0.38, 0.33, 0.23),
		"wall": Color(0.55, 0.3, 0.2),
		"elevation_tint": Color(1.1, 1.05, 1.0),
		"grid_line": Color(0.3, 0.25, 0.18, 0.25),
	},
	"camp": {
		"ground": Color(0.32, 0.38, 0.22),
		"ground_alt": Color(0.30, 0.36, 0.20),
		"wall": Color(0.4, 0.35, 0.25),
		"elevation_tint": Color(1.08, 1.1, 0.98),
		"grid_line": Color(0.22, 0.28, 0.15, 0.25),
	},
	"village": {
		"ground": Color(0.35, 0.42, 0.25),
		"ground_alt": Color(0.33, 0.40, 0.23),
		"wall": Color(0.48, 0.38, 0.26),
		"elevation_tint": Color(1.1, 1.08, 1.0),
		"grid_line": Color(0.25, 0.32, 0.18, 0.25),
	},
	"portal": {
		"ground": Color(0.2, 0.15, 0.3),
		"ground_alt": Color(0.18, 0.13, 0.28),
		"wall": Color(0.35, 0.25, 0.45),
		"elevation_tint": Color(1.0, 0.95, 1.2),
		"grid_line": Color(0.14, 0.1, 0.22, 0.3),
	},
	"mirror": {
		"ground": Color(0.25, 0.28, 0.35),
		"ground_alt": Color(0.23, 0.26, 0.33),
		"wall": Color(0.4, 0.42, 0.48),
		"elevation_tint": Color(1.05, 1.1, 1.15),
		"grid_line": Color(0.18, 0.2, 0.25, 0.25),
	},
}


func setup(grid: Grid, environment: String) -> void:
	_grid = grid
	_environment = environment if PALETTES.has(environment) else "grassland"
	queue_redraw()


func _draw() -> void:
	if not _grid:
		return

	var pal: Dictionary = PALETTES[_environment]
	var ground: Color = pal["ground"]
	var ground_alt: Color = pal["ground_alt"]
	var wall_color: Color = pal["wall"]
	var elev_tint: Color = pal["elevation_tint"]
	var line_color: Color = pal["grid_line"]

	for y in range(_grid.height):
		for x in range(_grid.width):
			var pos := Vector2i(x, y)
			var rect := Rect2(x * TILE_SIZE, y * TILE_SIZE, TILE_SIZE, TILE_SIZE)
			var walkable := _grid.is_walkable(pos)
			var elevation := _grid.get_elevation(pos)
			var is_destructible := not walkable and _grid._destructible_hp[_grid._idx(pos)] > 0

			if is_destructible:
				# Destructible object (crate/boulder)
				draw_rect(rect, wall_color.darkened(0.1))
				var inner := rect.grow(-6)
				draw_rect(inner, wall_color.lightened(0.15))
			elif not walkable:
				# Solid wall
				draw_rect(rect, wall_color)
				draw_rect(rect, wall_color.darkened(0.2), false, 2.0)
			else:
				# Ground tile with checkerboard pattern
				var base_color := ground if (x + y) % 2 == 0 else ground_alt
				# Tint by elevation
				if elevation > 0:
					for _e in range(elevation):
						base_color = Color(
							base_color.r * elev_tint.r,
							base_color.g * elev_tint.g,
							base_color.b * elev_tint.b,
						)
				draw_rect(rect, base_color)

			# Grid lines
			draw_rect(rect, line_color, false, 1.0)

	# Map border
	var border := Rect2(0, 0, _grid.width * TILE_SIZE, _grid.height * TILE_SIZE)
	draw_rect(border, line_color.lightened(0.3), false, 2.0)
