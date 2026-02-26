extends Node2D


func _draw() -> void:
	var terrain: int = get_meta("terrain_type", -1)

	match terrain:
		MapData.Terrain.CASTLE:
			_draw_castle()
		MapData.Terrain.CITY, MapData.Terrain.CITY_GATE:
			_draw_city()
		MapData.Terrain.FOREST, MapData.Terrain.DEEP_FOREST:
			_draw_forest(terrain == MapData.Terrain.DEEP_FOREST)
		MapData.Terrain.SMOKE:
			_draw_smoke()
		MapData.Terrain.CLEARING:
			_draw_clearing()
		MapData.Terrain.SHORE, MapData.Terrain.BEACH:
			_draw_water(terrain == MapData.Terrain.BEACH)
		MapData.Terrain.RUINS:
			_draw_ruins()
		MapData.Terrain.CAVE:
			_draw_cave()
		MapData.Terrain.PORTAL:
			_draw_portal()
		MapData.Terrain.CIRCUS:
			_draw_circus()
		MapData.Terrain.CEMETERY:
			_draw_cemetery()
		MapData.Terrain.CRYPT:
			_draw_crypt()
		MapData.Terrain.ARMY_CAMP:
			_draw_army_camp()
		MapData.Terrain.MIRROR:
			_draw_mirror()
		MapData.Terrain.SHRINE:
			_draw_shrine()
		MapData.Terrain.VILLAGE:
			_draw_village()
		MapData.Terrain.INN:
			_draw_inn()


func _draw_castle() -> void:
	# Stone base
	draw_rect(Rect2(-30, -20, 60, 40), Color(0.45, 0.4, 0.35))
	# Towers
	draw_rect(Rect2(-30, -40, 14, 20), Color(0.5, 0.45, 0.4))
	draw_rect(Rect2(16, -40, 14, 20), Color(0.5, 0.45, 0.4))
	# Battlements
	draw_rect(Rect2(-28, -44, 6, 4), Color(0.55, 0.5, 0.45))
	draw_rect(Rect2(20, -44, 6, 4), Color(0.55, 0.5, 0.45))
	# Gate
	draw_rect(Rect2(-6, -4, 12, 24), Color(0.25, 0.2, 0.15))


func _draw_city() -> void:
	# Buildings
	draw_rect(Rect2(-25, -15, 16, 30), Color(0.5, 0.42, 0.35))
	draw_rect(Rect2(-5, -22, 14, 37), Color(0.45, 0.38, 0.3))
	draw_rect(Rect2(12, -10, 16, 25), Color(0.48, 0.4, 0.33))
	# Rooftops
	var roof1 := PackedVector2Array([Vector2(-27, -15), Vector2(-17, -28), Vector2(-7, -15)])
	draw_colored_polygon(roof1, Color(0.6, 0.3, 0.2))
	var roof2 := PackedVector2Array([Vector2(-7, -22), Vector2(2, -34), Vector2(11, -22)])
	draw_colored_polygon(roof2, Color(0.55, 0.28, 0.18))


func _draw_forest(deep: bool) -> void:
	var green := Color(0.15, 0.4, 0.15) if deep else Color(0.2, 0.5, 0.2)
	var dark := Color(0.1, 0.3, 0.1) if deep else Color(0.15, 0.4, 0.15)
	# Tree trunks
	draw_rect(Rect2(-20, 0, 6, 16), Color(0.4, 0.25, 0.1))
	draw_rect(Rect2(0, -4, 6, 20), Color(0.35, 0.22, 0.08))
	draw_rect(Rect2(16, 2, 6, 14), Color(0.38, 0.24, 0.09))
	# Canopy
	draw_circle(Vector2(-17, -10), 18.0, green)
	draw_circle(Vector2(3, -16), 22.0, dark)
	draw_circle(Vector2(19, -8), 16.0, green)


func _draw_smoke() -> void:
	# Burnt trees
	draw_rect(Rect2(-15, -5, 4, 20), Color(0.2, 0.15, 0.1))
	draw_rect(Rect2(10, -2, 4, 18), Color(0.22, 0.16, 0.1))
	# Smoke wisps (grey circles)
	draw_circle(Vector2(-8, -14), 14.0, Color(0.35, 0.32, 0.3, 0.6))
	draw_circle(Vector2(8, -18), 12.0, Color(0.4, 0.35, 0.32, 0.5))
	draw_circle(Vector2(0, -8), 10.0, Color(0.45, 0.4, 0.35, 0.4))
	# Embers
	draw_circle(Vector2(-12, 4), 3.0, Color(0.9, 0.4, 0.1))
	draw_circle(Vector2(6, 6), 2.0, Color(0.9, 0.5, 0.15))


func _draw_clearing() -> void:
	# Grass circle
	draw_circle(Vector2.ZERO, 28.0, Color(0.3, 0.55, 0.25))
	# Small flowers
	draw_circle(Vector2(-10, -8), 3.0, Color(0.8, 0.7, 0.2))
	draw_circle(Vector2(8, 5), 3.0, Color(0.7, 0.3, 0.6))
	draw_circle(Vector2(-5, 10), 2.5, Color(0.3, 0.5, 0.8))
	# Surrounding tree hints
	draw_circle(Vector2(-32, -5), 10.0, Color(0.2, 0.45, 0.18))
	draw_circle(Vector2(30, -8), 10.0, Color(0.2, 0.45, 0.18))


func _draw_water(wide: bool) -> void:
	var w := 50.0 if wide else 35.0
	# Sand
	draw_rect(Rect2(-w / 2, 0, w, 18), Color(0.75, 0.7, 0.5))
	# Water
	draw_rect(Rect2(-w / 2, -20, w, 20), Color(0.2, 0.4, 0.7))
	# Wave lines
	draw_line(Vector2(-w / 2 + 4, -8), Vector2(w / 2 - 4, -8), Color(0.3, 0.5, 0.8, 0.6), 1.5)
	draw_line(Vector2(-w / 2 + 8, -14), Vector2(w / 2 - 8, -14), Color(0.3, 0.5, 0.8, 0.4), 1.0)


func _draw_ruins() -> void:
	# Broken pillars
	draw_rect(Rect2(-22, -10, 8, 26), Color(0.5, 0.48, 0.44))
	draw_rect(Rect2(-22, -16, 8, 6), Color(0.55, 0.52, 0.48))
	draw_rect(Rect2(6, -4, 8, 20), Color(0.48, 0.46, 0.42))
	# Rubble
	draw_circle(Vector2(-6, 10), 5.0, Color(0.4, 0.38, 0.34))
	draw_circle(Vector2(2, 8), 3.0, Color(0.42, 0.4, 0.36))
	draw_circle(Vector2(18, 12), 4.0, Color(0.44, 0.42, 0.38))


func _draw_cave() -> void:
	# Cliff/hill
	var hill := PackedVector2Array([
		Vector2(-40, 16), Vector2(-30, -20), Vector2(-10, -32),
		Vector2(10, -30), Vector2(30, -18), Vector2(40, 16),
	])
	draw_colored_polygon(hill, Color(0.35, 0.3, 0.25))
	# Dark cave opening
	var opening := PackedVector2Array([
		Vector2(-14, 16), Vector2(-10, -4), Vector2(0, -10),
		Vector2(10, -4), Vector2(14, 16),
	])
	draw_colored_polygon(opening, Color(0.06, 0.05, 0.08))


func _draw_portal() -> void:
	# Outer glow
	draw_circle(Vector2.ZERO, 24.0, Color(0.4, 0.2, 0.6, 0.3))
	# Rift ring
	draw_arc(Vector2.ZERO, 18.0, 0, TAU, 32, Color(0.6, 0.3, 0.9), 3.0)
	# Inner void
	draw_circle(Vector2.ZERO, 12.0, Color(0.15, 0.05, 0.25))
	# Sparks
	draw_circle(Vector2(10, -14), 2.0, Color(0.8, 0.5, 1.0))
	draw_circle(Vector2(-12, 10), 2.0, Color(0.7, 0.4, 0.9))


func _draw_circus() -> void:
	# Tent
	var tent := PackedVector2Array([
		Vector2(-24, 16), Vector2(0, -28), Vector2(24, 16),
	])
	draw_colored_polygon(tent, Color(0.7, 0.2, 0.2))
	# Stripes
	var stripe := PackedVector2Array([
		Vector2(-12, 16), Vector2(0, -28), Vector2(12, 16),
	])
	draw_colored_polygon(stripe, Color(0.75, 0.7, 0.2))
	# Pole
	draw_line(Vector2(0, -28), Vector2(0, -34), Color(0.6, 0.55, 0.5), 2.0)


func _draw_cemetery() -> void:
	# Ground
	draw_rect(Rect2(-30, 4, 60, 14), Color(0.22, 0.2, 0.18))
	# Headstones
	draw_rect(Rect2(-22, -10, 10, 16), Color(0.5, 0.48, 0.46))
	draw_rect(Rect2(-24, -12, 14, 4), Color(0.52, 0.5, 0.48))
	draw_rect(Rect2(-2, -6, 8, 12), Color(0.48, 0.46, 0.44))
	draw_rect(Rect2(14, -14, 10, 20), Color(0.5, 0.48, 0.46))
	# Cross
	draw_rect(Rect2(17, -18, 4, 6), Color(0.52, 0.5, 0.48))
	draw_rect(Rect2(15, -14, 8, 2), Color(0.52, 0.5, 0.48))
	# Dead tree
	draw_line(Vector2(30, 8), Vector2(30, -16), Color(0.3, 0.22, 0.15), 2.5)
	draw_line(Vector2(30, -10), Vector2(36, -18), Color(0.3, 0.22, 0.15), 1.5)
	draw_line(Vector2(30, -6), Vector2(24, -14), Color(0.3, 0.22, 0.15), 1.5)


func _draw_crypt() -> void:
	# Tower
	draw_rect(Rect2(-12, -30, 24, 46), Color(0.4, 0.42, 0.45))
	# Gears
	draw_circle(Vector2(0, -10), 8.0, Color(0.5, 0.48, 0.4))
	draw_circle(Vector2(0, -10), 4.0, Color(0.38, 0.4, 0.43))
	# Chimney
	draw_rect(Rect2(6, -38, 6, 10), Color(0.35, 0.35, 0.38))
	# Smoke puff
	draw_circle(Vector2(9, -42), 5.0, Color(0.5, 0.5, 0.5, 0.4))


func _draw_army_camp() -> void:
	# Tents
	var tent1 := PackedVector2Array([Vector2(-28, 14), Vector2(-16, -8), Vector2(-4, 14)])
	draw_colored_polygon(tent1, Color(0.4, 0.35, 0.25))
	var tent2 := PackedVector2Array([Vector2(4, 14), Vector2(16, -8), Vector2(28, 14)])
	draw_colored_polygon(tent2, Color(0.42, 0.36, 0.26))
	# Banner pole
	draw_line(Vector2(0, 14), Vector2(0, -20), Color(0.4, 0.3, 0.2), 2.0)
	# Banner
	draw_rect(Rect2(1, -20, 12, 10), Color(0.7, 0.15, 0.15))


func _draw_mirror() -> void:
	# Reflective pool
	draw_circle(Vector2.ZERO, 22.0, Color(0.2, 0.25, 0.35))
	draw_circle(Vector2.ZERO, 16.0, Color(0.3, 0.35, 0.5))
	# Shimmer highlights
	draw_circle(Vector2(-4, -6), 4.0, Color(0.5, 0.55, 0.7, 0.5))
	draw_circle(Vector2(6, 3), 3.0, Color(0.45, 0.5, 0.65, 0.4))
	# Stone border
	draw_arc(Vector2.ZERO, 22.0, 0, TAU, 32, Color(0.4, 0.38, 0.34), 2.5)


func _draw_village() -> void:
	# Ground
	draw_circle(Vector2.ZERO, 30.0, Color(0.3, 0.45, 0.2))
	# Cottages
	draw_rect(Rect2(-22, -8, 16, 14), Color(0.5, 0.4, 0.28))
	var roof1 := PackedVector2Array([Vector2(-24, -8), Vector2(-14, -20), Vector2(-4, -8)])
	draw_colored_polygon(roof1, Color(0.55, 0.3, 0.15))
	draw_rect(Rect2(6, -4, 14, 12), Color(0.48, 0.38, 0.26))
	var roof2 := PackedVector2Array([Vector2(4, -4), Vector2(13, -16), Vector2(22, -4)])
	draw_colored_polygon(roof2, Color(0.5, 0.28, 0.14))
	# Well
	draw_circle(Vector2(-4, 10), 5.0, Color(0.35, 0.32, 0.3))
	draw_circle(Vector2(-4, 10), 3.0, Color(0.2, 0.35, 0.55))
	# Fence posts
	draw_rect(Rect2(-28, 8, 2, 8), Color(0.4, 0.3, 0.15))
	draw_rect(Rect2(26, 8, 2, 8), Color(0.4, 0.3, 0.15))


func _draw_inn() -> void:
	# Large building
	draw_rect(Rect2(-24, -16, 48, 36), Color(0.45, 0.35, 0.25))
	# Roof
	var roof := PackedVector2Array([Vector2(-28, -16), Vector2(0, -34), Vector2(28, -16)])
	draw_colored_polygon(roof, Color(0.5, 0.25, 0.15))
	# Chimney
	draw_rect(Rect2(12, -38, 6, 10), Color(0.4, 0.35, 0.3))
	draw_circle(Vector2(15, -40), 4.0, Color(0.5, 0.5, 0.5, 0.35))
	# Door
	draw_rect(Rect2(-5, 4, 10, 16), Color(0.3, 0.2, 0.1))
	# Windows
	draw_rect(Rect2(-18, -6, 8, 8), Color(0.7, 0.6, 0.3, 0.6))
	draw_rect(Rect2(10, -6, 8, 8), Color(0.7, 0.6, 0.3, 0.6))
	# Sign post
	draw_line(Vector2(30, 16), Vector2(30, -4), Color(0.4, 0.3, 0.2), 2.0)
	draw_rect(Rect2(24, -8, 14, 8), Color(0.45, 0.35, 0.2))


func _draw_shrine() -> void:
	# Stone platform
	draw_rect(Rect2(-20, 4, 40, 12), Color(0.45, 0.42, 0.4))
	# Pillar
	draw_rect(Rect2(-4, -22, 8, 28), Color(0.5, 0.48, 0.45))
	# Glowing orb
	draw_circle(Vector2(0, -28), 8.0, Color(0.3, 0.6, 0.9, 0.4))
	draw_circle(Vector2(0, -28), 5.0, Color(0.5, 0.8, 1.0, 0.6))
