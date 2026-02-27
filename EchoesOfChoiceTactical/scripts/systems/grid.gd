class_name Grid extends RefCounted

var width: int
var height: int
var _walkable: Array[bool] = []
var _movement_cost: Array[int] = []
var _elevation: Array[int] = []
var _occupants: Array = []
var _destructible_hp: Array[int] = []
var _blocks_los: Array[bool] = []
var _terrain_effects: Array[TerrainEffect] = []

const DIRECTIONS: Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]


func _init(w: int, h: int) -> void:
	width = w
	height = h
	var size := w * h
	_walkable.resize(size)
	_movement_cost.resize(size)
	_elevation.resize(size)
	_occupants.resize(size)
	_destructible_hp.resize(size)
	_blocks_los.resize(size)
	for i in size:
		_walkable[i] = true
		_movement_cost[i] = 1
		_elevation[i] = 0
		_occupants[i] = null
		_destructible_hp[i] = 0
		_blocks_los[i] = false


func _idx(pos: Vector2i) -> int:
	return pos.y * width + pos.x


func in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < width and pos.y >= 0 and pos.y < height


func is_walkable(pos: Vector2i) -> bool:
	return in_bounds(pos) and _walkable[_idx(pos)]


func get_movement_cost(pos: Vector2i) -> int:
	return _movement_cost[_idx(pos)]


func get_elevation(pos: Vector2i) -> int:
	return _elevation[_idx(pos)]


func get_occupant(pos: Vector2i):
	if not in_bounds(pos):
		return null
	return _occupants[_idx(pos)]


func set_occupant(pos: Vector2i, unit) -> void:
	if in_bounds(pos):
		var existing = _occupants[_idx(pos)]
		if existing != null and existing != unit:
			push_warning("Grid: overwriting occupant at %s: %s -> %s" % [pos, existing, unit])
		_occupants[_idx(pos)] = unit


func clear_occupant(pos: Vector2i) -> void:
	if in_bounds(pos):
		_occupants[_idx(pos)] = null


func is_occupied(pos: Vector2i) -> bool:
	return get_occupant(pos) != null


func blocks_line_of_sight(pos: Vector2i) -> bool:
	return in_bounds(pos) and _blocks_los[_idx(pos)]


func set_tile(pos: Vector2i, walkable: bool, cost: int, elevation: int, blocks_los: bool = false, destructible_hp: int = 0) -> void:
	if not in_bounds(pos):
		return
	var i := _idx(pos)
	_walkable[i] = walkable
	_movement_cost[i] = cost
	_elevation[i] = elevation
	_blocks_los[i] = blocks_los
	_destructible_hp[i] = destructible_hp


# BFS flood fill to find all reachable tiles for a unit
func get_reachable_tiles(origin: Vector2i, movement: int, jump_stat: int) -> Array[Vector2i]:
	var reachable: Array[Vector2i] = []
	var costs := {}
	costs[origin] = 0

	var frontier: Array[Vector2i] = [origin]

	while frontier.size() > 0:
		var current: Vector2i = frontier.pop_front()
		var current_cost: int = costs[current]

		for dir in DIRECTIONS:
			var neighbor := current + dir
			if not in_bounds(neighbor):
				continue
			if not is_walkable(neighbor):
				continue
			if is_occupied(neighbor):
				# Can path through allies but not enemies (handled by caller)
				pass

			var height_diff := get_elevation(neighbor) - get_elevation(current)

			# Can only climb if height difference is within jump stat
			if height_diff > jump_stat:
				continue

			var step_cost := get_movement_cost(neighbor)
			# Climbing costs extra movement per elevation level gained
			if height_diff > 0:
				step_cost += height_diff
			# Descending is free (no extra cost)

			var total_cost := current_cost + step_cost
			if total_cost > movement:
				continue

			if neighbor not in costs or total_cost < costs[neighbor]:
				costs[neighbor] = total_cost
				frontier.append(neighbor)

	for pos in costs:
		if pos != origin:
			reachable.append(pos)

	return reachable


# BFS to find the shortest path between two points
func find_path(start: Vector2i, end: Vector2i, movement: int, jump_stat: int) -> Array[Vector2i]:
	if start == end:
		return []

	var came_from := {}
	var costs := {}
	costs[start] = 0
	came_from[start] = null

	var frontier: Array[Vector2i] = [start]

	while frontier.size() > 0:
		var current: Vector2i = frontier.pop_front()
		if current == end:
			break

		var current_cost: int = costs[current]

		for dir in DIRECTIONS:
			var neighbor := current + dir
			if not in_bounds(neighbor):
				continue
			if not is_walkable(neighbor):
				continue

			var height_diff := get_elevation(neighbor) - get_elevation(current)
			if height_diff > jump_stat:
				continue

			var step_cost := get_movement_cost(neighbor)
			if height_diff > 0:
				step_cost += height_diff

			var total_cost := current_cost + step_cost
			if total_cost > movement:
				continue

			if neighbor not in costs or total_cost < costs[neighbor]:
				costs[neighbor] = total_cost
				came_from[neighbor] = current
				frontier.append(neighbor)

	if end not in came_from:
		return []

	var path: Array[Vector2i] = []
	var current := end
	while current != null and current != start:
		path.push_front(current)
		current = came_from[current]
	return path


# Get all tiles within a given range using Manhattan distance, accounting for elevation bonus
func get_tiles_in_range(origin: Vector2i, base_range: int, origin_elevation: int) -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	if base_range == 0:
		tiles.append(origin)
		return tiles
	for x in range(-base_range, base_range + 1):
		for y in range(-base_range, base_range + 1):
			if absi(x) + absi(y) > base_range:
				continue
			if x == 0 and y == 0:
				continue
			var target := origin + Vector2i(x, y)
			if not in_bounds(target):
				continue
			var elevation_advantage := origin_elevation - get_elevation(target)
			var effective_range := base_range + maxi(elevation_advantage, 0)
			if absi(x) + absi(y) <= effective_range:
				tiles.append(target)
	return tiles


# Get tiles affected by an AoE shape centered on a target
func get_aoe_tiles(target: Vector2i, shape: Enums.AoEShape, size: int, caster_pos: Vector2i = Vector2i.ZERO) -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []

	match shape:
		Enums.AoEShape.SINGLE:
			tiles.append(target)

		Enums.AoEShape.DIAMOND:
			for x in range(-size, size + 1):
				for y in range(-size, size + 1):
					if absi(x) + absi(y) <= size:
						var pos := target + Vector2i(x, y)
						if in_bounds(pos):
							tiles.append(pos)

		Enums.AoEShape.CROSS:
			tiles.append(target)
			for dir in DIRECTIONS:
				for i in range(1, size + 1):
					var pos := target + dir * i
					if in_bounds(pos):
						tiles.append(pos)

		Enums.AoEShape.SQUARE:
			for x in range(-size, size + 1):
				for y in range(-size, size + 1):
					var pos := target + Vector2i(x, y)
					if in_bounds(pos):
						tiles.append(pos)

		Enums.AoEShape.LINE:
			var direction := Vector2i.ZERO
			if caster_pos != Vector2i.ZERO:
				var diff := target - caster_pos
				if absi(diff.x) >= absi(diff.y):
					direction = Vector2i(signi(diff.x), 0)
				else:
					direction = Vector2i(0, signi(diff.y))
			if direction != Vector2i.ZERO:
				var pos := target
				for i in range(size):
					if in_bounds(pos):
						tiles.append(pos)
					pos += direction

		Enums.AoEShape.GLOBAL:
			for x in range(width):
				for y in range(height):
					tiles.append(Vector2i(x, y))

	return tiles


# Check line of sight between two points using Bresenham's line algorithm
func has_line_of_sight(from: Vector2i, to: Vector2i) -> bool:
	var points := _bresenham_line(from, to)
	for i in range(1, points.size() - 1):
		if blocks_line_of_sight(points[i]):
			return false
	return true


func _bresenham_line(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	var points: Array[Vector2i] = []
	var dx := absi(to.x - from.x)
	var dy := absi(to.y - from.y)
	var sx := 1 if from.x < to.x else -1
	var sy := 1 if from.y < to.y else -1
	var err := dx - dy
	var current := from

	while true:
		points.append(current)
		if current == to:
			break
		var e2 := 2 * err
		if e2 > -dy:
			err -= dy
			current.x += sx
		if e2 < dx:
			err += dx
			current.y += sy

	return points


# Get tiles adjacent to a position that are threatened by enemies
func get_threatened_tiles(pos: Vector2i, friendly_team: Enums.Team) -> Array[Vector2i]:
	var threatened: Array[Vector2i] = []
	for dir in DIRECTIONS:
		var adj := pos + dir
		var occupant = get_occupant(adj)
		if occupant != null and occupant.team != friendly_team:
			threatened.append(adj)
	return threatened


# Place temporary terrain from an ability
func place_terrain(pos: Vector2i, tile_type: Enums.TileType, duration: int) -> TerrainEffect:
	var effect := TerrainEffect.create(pos, tile_type, duration)
	var i := _idx(pos)
	effect.original_walkable = _walkable[i]
	effect.original_movement_cost = _movement_cost[i]
	effect.original_elevation = _elevation[i]

	match tile_type:
		Enums.TileType.ICE_WALL:
			_walkable[i] = false
			_blocks_los[i] = true
		Enums.TileType.WALL:
			_walkable[i] = false
			_blocks_los[i] = true
		Enums.TileType.FIRE_TILE:
			_movement_cost[i] = 2
		Enums.TileType.WATER:
			_movement_cost[i] = 3
		Enums.TileType.ROUGH_TERRAIN:
			_movement_cost[i] = 2

	_terrain_effects.append(effect)
	return effect


# Tick terrain effects at end of round, removing expired or triggered ones
func tick_terrain_effects() -> Array[Vector2i]:
	var removed_positions: Array[Vector2i] = []

	var remaining: Array[TerrainEffect] = []
	for effect in _terrain_effects:
		effect.turns_remaining -= 1
		if effect.turns_remaining <= 0 or effect.triggered:
			var i := _idx(effect.grid_position)
			_walkable[i] = effect.original_walkable
			_movement_cost[i] = effect.original_movement_cost
			_blocks_los[i] = false
			removed_positions.append(effect.grid_position)
		else:
			remaining.append(effect)

	_terrain_effects = remaining
	return removed_positions


# Get all active terrain tile positions of a given type
func get_active_terrain_positions(tile_type: Enums.TileType) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for effect in _terrain_effects:
		if effect.tile_type == tile_type and not effect.triggered:
			result.append(effect.grid_position)
	return result


# Trigger a trap at a position, marking it for removal. Returns true if a trap was found.
func trigger_trap(pos: Vector2i) -> bool:
	for effect in _terrain_effects:
		if effect.tile_type == Enums.TileType.TRAP and effect.grid_position == pos and not effect.triggered:
			effect.triggered = true
			return true
	return false
