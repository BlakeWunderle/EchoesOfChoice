class_name TerrainOverrides extends RefCounted


## Returns array of terrain overrides: {pos: Vector2i, walkable: bool, cost: int, elevation: int, blocks_los: bool, destructible_hp: int}.
## Only includes tiles that are not unit spawn positions.
static func get_terrain_overrides(config: BattleConfig) -> Array:
	var occupied: Dictionary = {}
	for entry in config.player_units:
		occupied[entry["pos"]] = true
	for entry in config.enemy_units:
		occupied[entry["pos"]] = true

	var w: int = config.grid_width
	var h: int = config.grid_height
	var out: Array = []

	match config.battle_id:
		"city_street":
			# Buildings as walls (middle of map), avoid spawns at x 0-1 and 8-9
			for x in range(3, 7):
				for y in [2, 3, 4]:
					var pos := Vector2i(x, y)
					if not occupied.get(pos, false):
						out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"forest":
			# Scattered trees (blocking), leave paths
			var trees: Array[Vector2i] = [Vector2i(4, 2), Vector2i(5, 4), Vector2i(6, 1), Vector2i(6, 6), Vector2i(3, 5)]
			for pos in trees:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"smoke":
			# Sparse blocking (haze)
			var blocks: Array[Vector2i] = [Vector2i(4, 3), Vector2i(6, 4), Vector2i(5, 5)]
			for pos in blocks:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"deep_forest":
			# Dense trees and a ridge (elevation 1)
			var trees: Array[Vector2i] = [Vector2i(3, 2), Vector2i(4, 4), Vector2i(5, 1), Vector2i(5, 5), Vector2i(6, 3)]
			for pos in trees:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
			for pos in [Vector2i(4, 3), Vector2i(5, 3)]:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": true, "cost": 1, "elevation": 1, "blocks_los": false, "destructible_hp": 0})
		"clearing":
			# Central hill (elevation 1-2), 14x10
			for dx in range(5, 9):
				for dy in range(3, 7):
					var pos := Vector2i(dx, dy)
					if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
						var elev: int = 2 if dx >= 6 and dx <= 7 and dy >= 4 and dy <= 5 else 1
						out.append({"pos": pos, "walkable": true, "cost": 1, "elevation": elev, "blocks_los": false, "destructible_hp": 0})
		"ruins":
			# Crumbling walls and elevation steps, 12x10
			var walls: Array[Vector2i] = [Vector2i(4, 2), Vector2i(4, 3), Vector2i(5, 2), Vector2i(5, 3), Vector2i(6, 5), Vector2i(6, 6), Vector2i(7, 5), Vector2i(7, 6)]
			for pos in walls:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
			for pos in [Vector2i(7, 2), Vector2i(7, 3), Vector2i(8, 2), Vector2i(8, 3)]:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": true, "cost": 1, "elevation": 1, "blocks_los": false, "destructible_hp": 0})
		"cave":
			# Corridor walls and destructible boulder, 8x6
			var walls: Array[Vector2i] = [Vector2i(2, 0), Vector2i(2, 1), Vector2i(3, 5), Vector2i(4, 0), Vector2i(4, 5)]
			for pos in walls:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
			var boulder := Vector2i(4, 3)
			if not occupied.get(boulder, false):
				out.append({"pos": boulder, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 20})
		"portal":
			# Rift edges (blocking)
			var edges: Array[Vector2i] = [Vector2i(4, 1), Vector2i(4, 6), Vector2i(5, 0), Vector2i(5, 7), Vector2i(6, 2), Vector2i(6, 5)]
			for pos in edges:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"shore":
			# Water edge (blocking), sand (rough)
			var water: Array[Vector2i] = [Vector2i(5, 0), Vector2i(6, 0), Vector2i(7, 0)]
			for pos in water:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
			for pos in [Vector2i(4, 4), Vector2i(5, 5), Vector2i(6, 4)]:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": true, "cost": 2, "elevation": 0, "blocks_los": false, "destructible_hp": 0})
		"beach":
			# Sand (rough), wreckage (blocking)
			for dx in range(4, 7):
				for dy in [3, 4]:
					var pos := Vector2i(dx, dy)
					if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
						out.append({"pos": pos, "walkable": true, "cost": 2, "elevation": 0, "blocks_los": false, "destructible_hp": 0})
			var wreck: Array[Vector2i] = [Vector2i(5, 1), Vector2i(6, 6)]
			for pos in wreck:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"cemetery_battle":
			# Tombstones (blocking/rough), mausoleum
			var stones: Array[Vector2i] = [Vector2i(3, 2), Vector2i(4, 5), Vector2i(5, 1), Vector2i(6, 4), Vector2i(4, 3)]
			for pos in stones:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"box_battle":
			# Tents (walls), stage (elevation)
			var tents: Array[Vector2i] = [Vector2i(3, 2), Vector2i(4, 2), Vector2i(5, 5), Vector2i(6, 5)]
			for pos in tents:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
			for pos in [Vector2i(5, 3), Vector2i(6, 3)]:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": true, "cost": 1, "elevation": 1, "blocks_los": false, "destructible_hp": 0})
		"army_battle":
			# Barricades (blocking)
			var barricades: Array[Vector2i] = [Vector2i(4, 2), Vector2i(5, 2), Vector2i(4, 5), Vector2i(5, 5)]
			for pos in barricades:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"lab_battle":
			# Walls, machinery (blocking), crates
			var walls: Array[Vector2i] = [Vector2i(3, 2), Vector2i(4, 2), Vector2i(5, 4), Vector2i(6, 4)]
			for pos in walls:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
			var crate := Vector2i(5, 3)
			if not occupied.get(crate, false):
				out.append({"pos": crate, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 15})
		"mirror_battle":
			# Reflective floor, minimal obstacles (arena), 14x10
			var pillars: Array[Vector2i] = [Vector2i(6, 2), Vector2i(6, 7), Vector2i(7, 4), Vector2i(8, 2), Vector2i(8, 7)]
			for pos in pillars:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
		"return_city_1", "return_city_2", "return_city_3", "return_city_4":
			# City gate: gatehouse walls (blocking), gate platform (elevation), 10x8
			var gate_walls: Array[Vector2i] = [Vector2i(6, 0), Vector2i(6, 7), Vector2i(7, 0), Vector2i(7, 7)]
			for pos in gate_walls:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": false, "cost": 999, "elevation": 0, "blocks_los": true, "destructible_hp": 0})
			for pos in [Vector2i(7, 3), Vector2i(7, 4)]:
				if pos.x >= 0 and pos.x < w and pos.y >= 0 and pos.y < h and not occupied.get(pos, false):
					out.append({"pos": pos, "walkable": true, "cost": 1, "elevation": 1, "blocks_los": false, "destructible_hp": 0})

	return out
