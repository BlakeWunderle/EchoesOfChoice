extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var fog_layer: CanvasLayer = $FogLayer
@onready var info_panel: PanelContainer = $UILayer/InfoPanel
@onready var info_name: Label = $UILayer/InfoPanel/Margin/VBox/NameLabel
@onready var info_desc: Label = $UILayer/InfoPanel/Margin/VBox/DescLabel
@onready var info_status: Label = $UILayer/InfoPanel/Margin/VBox/StatusLabel
@onready var enter_button: Button = $UILayer/InfoPanel/Margin/VBox/EnterButton

const NODE_RADIUS := 18.0
const REVEAL_RADIUS := 90.0
const FOG_COLOR := Color(0.04, 0.04, 0.06, 0.92)
const PATH_COLOR := Color(0.45, 0.4, 0.35, 0.7)
const PATH_BORDER_COLOR := Color(0.2, 0.18, 0.14, 0.8)
const PATH_DASH_COLOR := Color(0.6, 0.55, 0.45, 0.35)
const NODE_AVAILABLE_COLOR := Color(1.0, 0.85, 0.3)
const NODE_COMPLETED_COLOR := Color(0.35, 0.7, 0.35)

# Terrain-based ring tint colors for node markers
const TERRAIN_RING_COLORS: Dictionary = {
	MapData.Terrain.CASTLE: Color(0.5, 0.48, 0.45),
	MapData.Terrain.CITY: Color(0.55, 0.45, 0.35),
	MapData.Terrain.CITY_GATE: Color(0.55, 0.45, 0.35),
	MapData.Terrain.FOREST: Color(0.25, 0.55, 0.2),
	MapData.Terrain.DEEP_FOREST: Color(0.15, 0.4, 0.12),
	MapData.Terrain.SMOKE: Color(0.45, 0.35, 0.25),
	MapData.Terrain.CLEARING: Color(0.4, 0.6, 0.3),
	MapData.Terrain.SHORE: Color(0.3, 0.5, 0.7),
	MapData.Terrain.BEACH: Color(0.7, 0.65, 0.45),
	MapData.Terrain.RUINS: Color(0.5, 0.47, 0.42),
	MapData.Terrain.CAVE: Color(0.35, 0.3, 0.28),
	MapData.Terrain.PORTAL: Color(0.5, 0.3, 0.7),
	MapData.Terrain.CIRCUS: Color(0.7, 0.35, 0.25),
	MapData.Terrain.CEMETERY: Color(0.35, 0.38, 0.34),
	MapData.Terrain.CRYPT: Color(0.4, 0.42, 0.5),
	MapData.Terrain.ARMY_CAMP: Color(0.45, 0.38, 0.28),
	MapData.Terrain.MIRROR: Color(0.35, 0.4, 0.55),
	MapData.Terrain.SHRINE: Color(0.4, 0.55, 0.75),
	MapData.Terrain.VILLAGE: Color(0.4, 0.5, 0.3),
	MapData.Terrain.INN: Color(0.55, 0.42, 0.28),
}

var _node_buttons: Dictionary = {}
var _selected_node_id: String = ""
var _pulse_time: float = 0.0
var _last_event_node: String = ""
var _grass_tex: Texture2D
var _objective_marker: Label = null

var _travel_event_scene: PackedScene = preload("res://scenes/story/TravelEvent.tscn")
var _menu_scene: PackedScene = preload("res://scenes/overworld/OverworldMenu.tscn")


func _ready() -> void:
	MusicManager.play_context(MusicManager.MusicContext.EXPLORATION)
	info_panel.visible = false
	enter_button.pressed.connect(_on_enter_battle)

	var party_btn := Button.new()
	party_btn.text = "Party"
	party_btn.custom_minimum_size = Vector2(80, 32)
	party_btn.position = Vector2(10, 10)
	party_btn.pressed.connect(_on_party_pressed)
	$UILayer.add_child(party_btn)

	var menu_btn := Button.new()
	menu_btn.text = "Menu"
	menu_btn.custom_minimum_size = Vector2(80, 32)
	menu_btn.position = Vector2(10, 48)
	menu_btn.pressed.connect(_on_menu_pressed)
	$UILayer.add_child(menu_btn)

	# Load grass background texture for revealed areas
	var grass_path := "res://assets/art/tilesets/overworld/path_road/PNG_Tiled/Ground_grass.png"
	if ResourceLoader.exists(grass_path):
		_grass_tex = load(grass_path) as Texture2D

	if not GameState.is_battle_completed("castle"):
		GameState.complete_battle("castle")

	_build_map()
	_center_camera_on_latest()


func _process(delta: float) -> void:
	_pulse_time += delta
	for nid in _node_buttons:
		var btn: Button = _node_buttons[nid]
		if MapData.is_node_available(nid):
			var pulse := 0.7 + 0.3 * sin(_pulse_time * 3.0)
			btn.modulate = Color(1.0, 1.0, 1.0, pulse)
	if _objective_marker:
		_objective_marker.position.y = _objective_marker.get_meta("base_y") + sin(_pulse_time * 4.0) * 4.0


func _build_map() -> void:
	var revealed := MapData.get_all_revealed_nodes()
	_objective_marker = null

	for nid in MapData.NODES:
		var node_data: Dictionary = MapData.NODES[nid]
		var pos: Vector2 = node_data["pos"]

		# Skip optional battles with no map position (launched from towns)
		if pos == Vector2.ZERO:
			continue

		var is_revealed: bool = nid in revealed

		if is_revealed:
			_create_terrain_landmark(nid, node_data)
			_create_node_button(nid, node_data)

	# Objective marker on first available uncompleted battle node
	for nid in MapData.NODES:
		if MapData.is_node_available(nid) and not GameState.is_battle_completed(nid):
			_create_objective_marker(MapData.NODES[nid]["pos"])
			break

	queue_redraw()


func _rebuild_map() -> void:
	for child in get_children():
		if child.is_in_group("map_element"):
			child.queue_free()
	_node_buttons.clear()
	await get_tree().process_frame
	_build_map()


func _create_terrain_landmark(nid: String, node_data: Dictionary) -> void:
	var pos: Vector2 = node_data["pos"]
	var terrain: int = node_data["terrain"]
	var landmark := Node2D.new()
	landmark.position = pos
	landmark.add_to_group("map_element")
	landmark.set_script(_TerrainDrawer)
	landmark.set_meta("terrain_type", terrain)
	add_child(landmark)


func _create_node_button(nid: String, node_data: Dictionary) -> void:
	var pos: Vector2 = node_data["pos"]
	var is_completed := GameState.is_battle_completed(nid)
	var is_available := MapData.is_node_available(nid)

	var btn := Button.new()
	btn.custom_minimum_size = Vector2(NODE_RADIUS * 2, NODE_RADIUS * 2)
	btn.position = pos - Vector2(NODE_RADIUS, NODE_RADIUS)
	btn.flat = true
	btn.add_to_group("map_element")
	btn.mouse_entered.connect(func(): _on_node_hovered(nid))
	btn.pressed.connect(func(): _on_node_clicked(nid))

	# Styled circle marker instead of ColorRect
	var marker := _NodeMarker.new()
	marker.position = Vector2(NODE_RADIUS, NODE_RADIUS)
	if is_completed:
		marker.color = NODE_COMPLETED_COLOR
	elif is_available:
		marker.color = NODE_AVAILABLE_COLOR
	else:
		marker.color = Color(0.4, 0.4, 0.4)
	marker.radius = NODE_RADIUS
	marker.is_battle = node_data.get("is_battle", true)
	var terrain: int = node_data.get("terrain", -1)
	marker.ring_color = TERRAIN_RING_COLORS.get(terrain, Color(0.3, 0.3, 0.3))
	btn.add_child(marker)

	add_child(btn)
	_node_buttons[nid] = btn


func _on_node_hovered(node_id: String) -> void:
	_show_info(node_id)


func _on_node_clicked(node_id: String) -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_selected_node_id = node_id
	_show_info(node_id)
	# Speculatively preload battle assets while the player reads the info panel
	var nd: Dictionary = MapData.get_node(node_id)
	if not nd.is_empty() and nd.get("is_battle", true):
		BattlePreloader.begin_preload(node_id)


func _show_info(node_id: String) -> void:
	var node_data: Dictionary = MapData.get_node(node_id)
	if node_data.is_empty():
		info_panel.visible = false
		return

	info_name.text = node_data["display_name"]
	info_desc.text = node_data["description"]

	var is_completed := GameState.is_battle_completed(node_id)
	var is_available := MapData.is_node_available(node_id)

	if is_completed:
		info_status.text = "Completed"
		info_status.add_theme_color_override("font_color", NODE_COMPLETED_COLOR)
		enter_button.text = "Revisit Battle" if node_data.get("is_battle", true) else "Revisit Town"
		enter_button.visible = true
	elif is_available and node_data.get("is_battle", true):
		info_status.text = "Available"
		info_status.add_theme_color_override("font_color", NODE_AVAILABLE_COLOR)
		enter_button.text = "Enter Battle"
		enter_button.visible = true
	elif is_available and not node_data.get("is_battle", true):
		info_status.text = "Available"
		info_status.add_theme_color_override("font_color", NODE_AVAILABLE_COLOR)
		enter_button.text = "Enter Town"
		enter_button.visible = true
	else:
		info_status.text = ""
		enter_button.visible = false

	_selected_node_id = node_id
	info_panel.visible = true


func _on_enter_battle() -> void:
	if _selected_node_id.is_empty():
		return
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	var node_data: Dictionary = MapData.get_node(_selected_node_id)
	if node_data.is_empty():
		return
	if not MapData.is_node_available(_selected_node_id) and not GameState.is_battle_completed(_selected_node_id):
		return

	var is_replay := GameState.is_battle_completed(_selected_node_id)

	# Branch-locking and travel events only apply on first entry
	if not is_replay:
		var siblings := MapData.get_branch_siblings(_selected_node_id)
		if siblings.size() > 0:
			GameState.lock_nodes(siblings)

	# Roll for travel event before entering the node
	var travel_event: Dictionary = _roll_travel_event(_selected_node_id, is_replay)
	if not travel_event.is_empty():
		_last_event_node = _selected_node_id
		var popup: Control = _travel_event_scene.instantiate()
		add_child(popup)
		popup.show_event(travel_event)

		# If the event is an ambush, intercept and reroute to the ambush battle
		var ambush_triggered := false
		popup.ambush_battle_requested.connect(func() -> void:
			ambush_triggered = true
			popup.event_finished.emit()  # unblock the await below
		)

		await popup.event_finished
		popup.queue_free()

		if ambush_triggered:
			GameState.current_battle_id = "travel_ambush"
			SceneManager.go_to_party_select()
			return

	if node_data.get("is_battle", true):
		GameState.current_battle_id = _selected_node_id
		SceneManager.go_to_party_select()
	else:
		if not is_replay:
			GameState.complete_battle(_selected_node_id)
		SceneManager.go_to_town(_selected_node_id)


func _roll_travel_event(node_id: String, is_backward: bool = false) -> Dictionary:
	# No back-to-back events on the same node
	if node_id == _last_event_node:
		return {}

	var eligible: Array = []
	for event in TravelEventData.EVENTS:
		# Merchants don't appear when backtracking
		if is_backward and event.get("event_type", "") == "merchant":
			continue
		var node_range: Array = event.get("node_range", [])
		if node_range.is_empty() or node_id in node_range:
			eligible.append(event)

	# Shuffle so the same event does not always fire first
	eligible.shuffle()

	for event in eligible:
		# Story and rumor events are one-shot — skip if already fired this run
		var event_id: String = event.get("id", "")
		var is_one_shot: bool = event.get("event_type", "") in ["story", "rumor"]
		if is_one_shot and event_id in GameState.fired_travel_event_ids:
			continue
		var chance: float = event.get("trigger_chance", 0.2)
		if randf() < chance:
			if not event_id.is_empty():
				GameState.fired_travel_event_ids.append(event_id)
			# Backward ambushes can be declined
			if is_backward and event.get("event_type", "") == "ambush":
				var evt: Dictionary = event.duplicate()
				evt["can_decline"] = true
				return evt
			return event

	return {}


func _create_objective_marker(pos: Vector2) -> void:
	_objective_marker = Label.new()
	_objective_marker.text = "v"
	_objective_marker.add_theme_font_size_override("font_size", 20)
	_objective_marker.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
	_objective_marker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_objective_marker.position = Vector2(pos.x - 8, pos.y - NODE_RADIUS - 28)
	_objective_marker.set_meta("base_y", _objective_marker.position.y)
	_objective_marker.add_to_group("map_element")
	add_child(_objective_marker)


func _on_party_pressed() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	var status_scene := preload("res://scenes/ui/StatusScreen.tscn")
	var status_ui: Control = status_scene.instantiate()
	status_ui.status_closed.connect(func(): status_ui.queue_free())
	$UILayer.add_child(status_ui)


func _on_menu_pressed() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	var menu_ui: Control = _menu_scene.instantiate()
	menu_ui.menu_closed.connect(func(): menu_ui.queue_free())
	$UILayer.add_child(menu_ui)


func _center_camera_on_latest() -> void:
	var latest_pos := Vector2(120, 360)
	var revealed := MapData.get_all_revealed_nodes()
	var max_x := 0.0
	for nid in revealed:
		var pos: Vector2 = MapData.NODES[nid]["pos"]
		if pos.x > max_x:
			max_x = pos.x
			latest_pos = pos
	camera.position = latest_pos


func _draw() -> void:
	var revealed := MapData.get_all_revealed_nodes()

	# Draw revealed area glow — soft gradient rings around explored nodes
	for nid in revealed:
		var pos: Vector2 = MapData.NODES[nid]["pos"]
		if pos == Vector2.ZERO:
			continue
		# Outer soft edge
		draw_circle(pos, REVEAL_RADIUS * 1.1, Color(0.14, 0.18, 0.1, 0.15))
		# Main reveal
		draw_circle(pos, REVEAL_RADIUS, Color(0.16, 0.2, 0.13, 0.3))
		# Inner brighter zone
		draw_circle(pos, REVEAL_RADIUS * 0.65, Color(0.18, 0.24, 0.14, 0.2))
		draw_circle(pos, REVEAL_RADIUS * 0.35, Color(0.2, 0.26, 0.15, 0.1))

	# Draw paths between revealed connected nodes (road with dark border + fill + dashes)
	for nid in revealed:
		var node_data: Dictionary = MapData.NODES[nid]
		var from_pos: Vector2 = node_data["pos"]
		if from_pos == Vector2.ZERO:
			continue
		for next_id in node_data.get("next_nodes", []):
			if next_id in revealed:
				var to_pos: Vector2 = MapData.NODES[next_id]["pos"]
				# Dark road border
				draw_line(from_pos, to_pos, PATH_BORDER_COLOR, 7.0, true)
				# Road fill
				draw_line(from_pos, to_pos, PATH_COLOR, 5.0, true)
				# Center dashes for cobblestone hint
				_draw_road_dashes(from_pos, to_pos)


func _draw_road_dashes(from: Vector2, to: Vector2) -> void:
	var dir := (to - from).normalized()
	var length := from.distance_to(to)
	var dash_len := 6.0
	var gap_len := 8.0
	var offset := NODE_RADIUS + 4.0  # start past the node circle
	while offset < length - NODE_RADIUS - 4.0:
		var start := from + dir * offset
		var end_offset := minf(offset + dash_len, length - NODE_RADIUS - 4.0)
		var end := from + dir * end_offset
		draw_line(start, end, PATH_DASH_COLOR, 1.5, true)
		offset += dash_len + gap_len


# Node marker inner class
class _NodeMarker extends Node2D:
	var color := Color.WHITE
	var ring_color := Color(0.3, 0.3, 0.3)
	var radius := 18.0
	var is_battle := true

	func _draw() -> void:
		# Drop shadow
		draw_circle(Vector2(2, 3), radius + 1, Color(0.0, 0.0, 0.0, 0.35))
		# Terrain-tinted outer ring
		draw_circle(Vector2.ZERO, radius + 3, ring_color.darkened(0.15))
		# Outer border
		draw_circle(Vector2.ZERO, radius + 1, Color(0.1, 0.1, 0.1, 0.8))
		# Main circle
		draw_circle(Vector2.ZERO, radius, color.darkened(0.2))
		# Inner highlight
		draw_circle(Vector2.ZERO, radius * 0.65, color)
		# Small specular highlight
		draw_circle(Vector2(-3, -4), radius * 0.25, Color(1, 1, 1, 0.15))
		# Battle = sword cross, Town = house shape (larger, cleaner icons)
		if is_battle:
			# Crossed swords
			draw_line(Vector2(-6, -6), Vector2(6, 6), Color(0.1, 0.1, 0.1, 0.7), 2.5)
			draw_line(Vector2(6, -6), Vector2(-6, 6), Color(0.1, 0.1, 0.1, 0.7), 2.5)
			# Sword hilts
			draw_line(Vector2(-4, -2), Vector2(-2, -4), Color(0.1, 0.1, 0.1, 0.5), 1.5)
			draw_line(Vector2(4, -2), Vector2(2, -4), Color(0.1, 0.1, 0.1, 0.5), 1.5)
		else:
			# House with peaked roof
			var house := PackedVector2Array([
				Vector2(-6, 5), Vector2(-6, -1), Vector2(0, -7), Vector2(6, -1), Vector2(6, 5),
			])
			draw_colored_polygon(house, Color(0.1, 0.1, 0.1, 0.55))
			# Door
			draw_rect(Rect2(-2, 0, 4, 5), Color(0.2, 0.15, 0.1, 0.5))


# Inline terrain drawer class
var _TerrainDrawer: GDScript = preload("res://scenes/overworld/terrain_drawer.gd")
