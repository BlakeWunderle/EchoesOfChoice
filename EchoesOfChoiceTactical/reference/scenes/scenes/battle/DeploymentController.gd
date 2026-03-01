class_name DeploymentController extends Control

signal deployment_complete

const MAX_DEPLOY := 5

var grid: Grid
var grid_overlay: GridOverlay
var grid_cursor: GridCursor
var deployment_zone: Array[Vector2i] = []
var available_units: Array[Dictionary] = []
var units_container: Node2D
var unit_scene: PackedScene
var battle_map: Node2D

var _placed: Dictionary = {}        # unit_name -> {"pos": Vector2i, "node": Unit}
var _selected_entry: Dictionary = {}
var _roster_buttons: Dictionary = {} # unit_name -> Button
var _count_label: Label
var _start_button: Button
var _info_label: Label


func _ready() -> void:
	_filter_deployment_zone()
	_build_ui()
	grid_overlay.show_deploy_zone(deployment_zone)
	grid_cursor.cell_selected.connect(_on_cell_selected)
	grid_cursor.cell_hovered.connect(_on_cell_hovered)
	grid_cursor.cancelled.connect(_on_cancelled)


func _filter_deployment_zone() -> void:
	var valid: Array[Vector2i] = []
	for pos in deployment_zone:
		if grid.is_walkable(pos) and not grid.is_occupied(pos):
			valid.append(pos)
	deployment_zone = valid


func _build_ui() -> void:
	var panel := PanelContainer.new()
	panel.anchor_right = 1.0
	panel.anchor_top = 0.0
	panel.anchor_bottom = 1.0
	panel.offset_left = -300
	panel.offset_right = 0
	panel.offset_top = 10
	panel.offset_bottom = -10
	panel.anchor_left = 1.0

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.12, 0.92)
	style.border_color = Color(0.8, 0.65, 0.2)
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	style.set_content_margin_all(12)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	panel.add_child(vbox)

	var title := Label.new()
	title.text = "DEPLOY YOUR FORCES"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
	vbox.add_child(title)

	_info_label = Label.new()
	_info_label.text = "Select a unit, then click a green tile"
	_info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_info_label.add_theme_font_size_override("font_size", 12)
	_info_label.add_theme_color_override("font_color", Color(0.6, 0.7, 0.8))
	_info_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	vbox.add_child(_info_label)

	var sep1 := HSeparator.new()
	vbox.add_child(sep1)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.custom_minimum_size = Vector2(0, 200)
	vbox.add_child(scroll)

	var roster_list := VBoxContainer.new()
	roster_list.add_theme_constant_override("separation", 4)
	roster_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(roster_list)

	var deploy_count := mini(available_units.size(), MAX_DEPLOY)
	for i in range(deploy_count):
		var entry: Dictionary = available_units[i]
		var btn := _make_unit_button(entry)
		roster_list.add_child(btn)
		_roster_buttons[entry["name"]] = btn

	var sep2 := HSeparator.new()
	vbox.add_child(sep2)

	_count_label = Label.new()
	_count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_count_label.add_theme_font_size_override("font_size", 14)
	vbox.add_child(_count_label)

	_start_button = Button.new()
	_start_button.text = "Start Battle"
	_start_button.custom_minimum_size = Vector2(0, 40)
	_start_button.pressed.connect(_on_start_pressed)
	vbox.add_child(_start_button)

	_update_ui()


func _make_unit_button(entry: Dictionary) -> Button:
	var data: FighterData = entry["data"]
	var role := data.get_role_tag()
	var text := "%s  Lv%d  %s  [%s]" % [entry["name"], entry["level"], data.class_display_name, role]

	var btn := Button.new()
	btn.text = text
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.custom_minimum_size = Vector2(0, 36)
	btn.pressed.connect(_on_roster_button_pressed.bind(entry))
	return btn


func _on_roster_button_pressed(entry: Dictionary) -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_selected_entry = entry

	# Highlight selected button
	for uname in _roster_buttons:
		var btn: Button = _roster_buttons[uname]
		if uname == entry["name"]:
			btn.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
		else:
			btn.remove_theme_color_override("font_color")

	_info_label.text = "Click a green tile to place " + entry["name"]
	var valid := _get_available_tiles()
	grid_cursor.activate(valid, _get_zone_center())


func _on_cell_selected(pos: Vector2i) -> void:
	if _selected_entry.is_empty():
		# Check if clicking a placed unit to pick it up
		var occupant = grid.get_occupant(pos)
		if occupant is Unit and occupant.team == Enums.Team.PLAYER:
			_pick_up_unit(occupant.unit_name)
		return

	if pos not in deployment_zone:
		return

	# If another unit is already on this tile, swap or reject
	var occupant = grid.get_occupant(pos)
	if occupant is Unit:
		return

	var uname: String = _selected_entry["name"]

	# If this unit was already placed, remove from old position
	if _placed.has(uname):
		var old_pos: Vector2i = _placed[uname]["pos"]
		var old_node: Unit = _placed[uname]["node"]
		grid.clear_occupant(old_pos)
		old_node.queue_free()
		_placed.erase(uname)

	# Spawn unit at selected position
	var unit := _spawn_deploy_unit(_selected_entry, pos)
	_placed[uname] = {"pos": pos, "node": unit}

	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	_selected_entry = {}

	# Clear button highlights
	for bname in _roster_buttons:
		_roster_buttons[bname].remove_theme_color_override("font_color")

	_info_label.text = "Select a unit, then click a green tile"
	grid_cursor.deactivate()
	_update_ui()


func _on_cell_hovered(_pos: Vector2i) -> void:
	pass


func _on_cancelled() -> void:
	_selected_entry = {}
	for bname in _roster_buttons:
		_roster_buttons[bname].remove_theme_color_override("font_color")
	_info_label.text = "Select a unit, then click a green tile"
	grid_cursor.deactivate()


func _pick_up_unit(uname: String) -> void:
	if not _placed.has(uname):
		return
	var old_pos: Vector2i = _placed[uname]["pos"]
	var old_node: Unit = _placed[uname]["node"]
	grid.clear_occupant(old_pos)
	old_node.queue_free()
	_placed.erase(uname)

	# Find the entry for this unit and select it
	for entry in available_units:
		if entry["name"] == uname:
			_selected_entry = entry
			break

	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	if _roster_buttons.has(uname):
		_roster_buttons[uname].add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
	_info_label.text = "Click a green tile to place " + uname

	var valid := _get_available_tiles()
	grid_cursor.activate(valid, _get_zone_center())
	_update_ui()


func _spawn_deploy_unit(entry: Dictionary, pos: Vector2i) -> Unit:
	var unit: Unit = unit_scene.instantiate()
	units_container.add_child(unit)
	var gender := _get_member_gender(entry["name"])
	unit.initialize(entry["data"], entry["name"], Enums.Team.PLAYER, entry["level"], gender)
	unit.place_on_grid(pos)
	unit.facing = Enums.Facing.EAST
	unit._update_facing_animation()
	grid.set_occupant(pos, unit)

	# Add name label like BattleMap does
	var label := Label.new()
	label.text = entry["name"]
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = Vector2(-30, 24)
	label.add_theme_font_size_override("font_size", 10)
	unit.add_child(label)

	return unit


func _get_member_gender(uname: String) -> String:
	if uname == GameState.player_name:
		return GameState.player_gender
	for member in GameState.party_members:
		if member["name"] == uname:
			return member.get("gender", "")
	return ""


func _get_available_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for pos in deployment_zone:
		if not grid.is_occupied(pos):
			tiles.append(pos)
	return tiles


func _get_zone_center() -> Vector2i:
	if deployment_zone.is_empty():
		return Vector2i.ZERO
	var sum := Vector2i.ZERO
	for pos in deployment_zone:
		sum += pos
	return Vector2i(sum.x / deployment_zone.size(), sum.y / deployment_zone.size())


func _update_ui() -> void:
	var deploy_count := mini(available_units.size(), MAX_DEPLOY)
	_count_label.text = "%d / %d placed" % [_placed.size(), deploy_count]

	# Mark placed units in roster
	for uname in _roster_buttons:
		var btn: Button = _roster_buttons[uname]
		if _placed.has(uname):
			btn.add_theme_color_override("font_color", Color(0.3, 0.8, 0.3))
		else:
			btn.remove_theme_color_override("font_color")

	_start_button.disabled = _placed.size() < deploy_count


func _on_start_pressed() -> void:
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	grid_cursor.deactivate()
	grid_overlay.clear_deploy_zone()

	# Disconnect cursor signals
	if grid_cursor.cell_selected.is_connected(_on_cell_selected):
		grid_cursor.cell_selected.disconnect(_on_cell_selected)
	if grid_cursor.cell_hovered.is_connected(_on_cell_hovered):
		grid_cursor.cell_hovered.disconnect(_on_cell_hovered)
	if grid_cursor.cancelled.is_connected(_on_cancelled):
		grid_cursor.cancelled.disconnect(_on_cancelled)

	deployment_complete.emit()
	queue_free()
