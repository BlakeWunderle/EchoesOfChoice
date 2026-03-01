extends Control

const MAX_PARTY_SIZE := 5

var _selected_names: Array[String] = []
var _member_buttons: Dictionary = {}

@onready var title_label: Label = $Panel/MarginContainer/VBox/TitleLabel
@onready var roster_list: VBoxContainer = $Panel/MarginContainer/VBox/ScrollContainer/RosterList
@onready var count_label: Label = $Panel/MarginContainer/VBox/Footer/CountLabel
@onready var start_button: Button = $Panel/MarginContainer/VBox/Footer/StartButton


func _ready() -> void:
	start_button.pressed.connect(_on_start_battle)
	# Continue/start preloading battle assets while the player picks their party
	if not GameState.current_battle_id.is_empty():
		BattlePreloader.begin_preload(GameState.current_battle_id)

	var roster_size := GameState.party_members.size()
	if roster_size <= MAX_PARTY_SIZE - 1:
		_auto_select_all()
		return

	_build_roster_ui()
	_update_count()


func _auto_select_all() -> void:
	GameState.selected_party.clear()
	for member in GameState.party_members:
		GameState.selected_party.append(member["name"])
	SceneManager.change_scene("res://scenes/battle/BattleMap.tscn")


func _build_roster_ui() -> void:
	_clear_children(roster_list)
	_selected_names.clear()
	_member_buttons.clear()

	var mc_row := _make_member_row(GameState.player_name, GameState.player_class_id, GameState.player_level, true)
	roster_list.add_child(mc_row)

	var sep := HSeparator.new()
	roster_list.add_child(sep)

	for member in GameState.party_members:
		var mname: String = member["name"]
		var row := _make_member_row(mname, member["class_id"], member.get("level", 1), false)
		roster_list.add_child(row)


func _make_member_row(unit_name: String, class_id: String, level: int, is_mc: bool) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)

	var toggle := Button.new()
	if is_mc:
		toggle.text = "[Leader]"
		toggle.disabled = true
		toggle.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
	else:
		toggle.text = "[ ]"
		toggle.custom_minimum_size = Vector2(50, 32)
		toggle.pressed.connect(_on_toggle_member.bind(unit_name, toggle))
		_member_buttons[unit_name] = toggle
	row.add_child(toggle)

	var name_label := Label.new()
	name_label.text = unit_name
	name_label.custom_minimum_size = Vector2(140, 0)
	name_label.add_theme_font_size_override("font_size", 15)
	row.add_child(name_label)

	var class_label := Label.new()
	class_label.text = class_id.capitalize()
	class_label.custom_minimum_size = Vector2(100, 0)
	class_label.add_theme_font_size_override("font_size", 13)
	class_label.add_theme_color_override("font_color", Color(0.6, 0.7, 0.8))
	row.add_child(class_label)

	var level_label := Label.new()
	level_label.text = "Lv %d" % level
	level_label.add_theme_font_size_override("font_size", 13)
	level_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	row.add_child(level_label)

	var data: FighterData = BattleConfig.load_class(class_id)
	if data:
		var stats := data.get_stats_at_level(level)
		var hp_label := Label.new()
		hp_label.text = "HP %d" % stats["max_health"]
		hp_label.add_theme_font_size_override("font_size", 12)
		hp_label.add_theme_color_override("font_color", Color(0.5, 0.8, 0.5))
		row.add_child(hp_label)

		var role := data.get_role_tag()
		var role_lbl := Label.new()
		role_lbl.text = "[%s]" % role
		role_lbl.add_theme_font_size_override("font_size", 11)
		role_lbl.add_theme_color_override("font_color", _role_color(role))
		row.add_child(role_lbl)

	return row


static func _role_color(role: String) -> Color:
	match role:
		"Melee": return Color(0.9, 0.6, 0.3)
		"Ranged": return Color(0.3, 0.8, 0.3)
		"Magic": return Color(0.5, 0.5, 1.0)
		"Support": return Color(0.3, 0.9, 0.8)
		"Tank": return Color(0.8, 0.8, 0.3)
	return Color(0.7, 0.7, 0.7)


func _on_toggle_member(unit_name: String, btn: Button) -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	if unit_name in _selected_names:
		_selected_names.erase(unit_name)
		btn.text = "[ ]"
	else:
		if _selected_names.size() >= MAX_PARTY_SIZE - 1:
			return
		_selected_names.append(unit_name)
		btn.text = "[X]"
	_update_count()


func _update_count() -> void:
	var total := _selected_names.size() + 1
	count_label.text = "%d / %d selected" % [total, MAX_PARTY_SIZE]

	var max_additional := mini(MAX_PARTY_SIZE - 1, GameState.party_members.size())
	start_button.disabled = _selected_names.size() < max_additional and _selected_names.size() < MAX_PARTY_SIZE - 1

	for mname in _member_buttons:
		var btn: Button = _member_buttons[mname]
		if mname not in _selected_names and _selected_names.size() >= MAX_PARTY_SIZE - 1:
			btn.disabled = true
		else:
			btn.disabled = false


func _on_start_battle() -> void:
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	GameState.selected_party = _selected_names.duplicate()
	SceneManager.change_scene("res://scenes/battle/BattleMap.tscn")


func _clear_children(container: Node) -> void:
	for child in container.get_children():
		child.queue_free()
