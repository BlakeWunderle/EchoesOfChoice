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
const NODE_AVAILABLE_COLOR := Color(1.0, 0.85, 0.3)
const NODE_COMPLETED_COLOR := Color(0.35, 0.7, 0.35)

var _node_buttons: Dictionary = {}
var _selected_node_id: String = ""
var _pulse_time: float = 0.0
var _last_event_node: String = ""

var _travel_event_scene: PackedScene = preload("res://scenes/story/TravelEvent.tscn")


func _ready() -> void:
	info_panel.visible = false
	enter_button.pressed.connect(_on_enter_battle)

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


func _build_map() -> void:
	var revealed := MapData.get_all_revealed_nodes()

	for nid in MapData.NODES:
		var node_data: Dictionary = MapData.NODES[nid]
		var pos: Vector2 = node_data["pos"]
		var is_revealed := nid in revealed

		if is_revealed:
			_create_terrain_landmark(nid, node_data)
			_create_node_button(nid, node_data)

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

	var dot := ColorRect.new()
	dot.size = Vector2(NODE_RADIUS * 2, NODE_RADIUS * 2)
	if is_completed:
		dot.color = NODE_COMPLETED_COLOR
	elif is_available:
		dot.color = NODE_AVAILABLE_COLOR
	else:
		dot.color = Color(0.4, 0.4, 0.4)
	btn.add_child(dot)

	add_child(btn)
	_node_buttons[nid] = btn


func _on_node_hovered(node_id: String) -> void:
	_show_info(node_id)


func _on_node_clicked(node_id: String) -> void:
	_selected_node_id = node_id
	_show_info(node_id)


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
		enter_button.visible = false
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
	var node_data: Dictionary = MapData.get_node(_selected_node_id)
	if node_data.is_empty():
		return
	if not MapData.is_node_available(_selected_node_id):
		return

	var siblings := MapData.get_branch_siblings(_selected_node_id)
	if siblings.size() > 0:
		GameState.lock_nodes(siblings)

	# Roll for travel event before entering the node
	var travel_event: Dictionary = _roll_travel_event(_selected_node_id)
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
		GameState.complete_battle(_selected_node_id)
		SceneManager.go_to_town(_selected_node_id)


func _roll_travel_event(node_id: String) -> Dictionary:
	# No back-to-back events on the same node
	if node_id == _last_event_node:
		return {}

	var eligible: Array = []
	for event in TravelEventData.EVENTS:
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
			return event

	return {}


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

	# Draw paths between revealed connected nodes
	for nid in revealed:
		var node_data: Dictionary = MapData.NODES[nid]
		var from_pos: Vector2 = node_data["pos"]
		for next_id in node_data.get("next_nodes", []):
			if next_id in revealed:
				draw_line(from_pos, MapData.NODES[next_id]["pos"], PATH_COLOR, 3.0, true)

	# Draw fog circles (dark everywhere except around revealed nodes)
	# We draw the revealed node backgrounds as subtle circles
	for nid in revealed:
		var pos: Vector2 = MapData.NODES[nid]["pos"]
		draw_circle(pos, REVEAL_RADIUS, Color(0.08, 0.1, 0.08, 0.3))


# Inline terrain drawer class
var _TerrainDrawer: GDScript = preload("res://scenes/overworld/terrain_drawer.gd")
