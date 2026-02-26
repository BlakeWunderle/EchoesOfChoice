extends Control

signal recruit_closed

enum Phase { CLASS_SELECT, GENDER_SELECT, NAME_INPUT }

var _phase: int = Phase.CLASS_SELECT
var _selected_class_id: String = ""
var _selected_gender: String = ""

@onready var gold_label: Label = $Panel/MarginContainer/VBox/Header/GoldLabel
@onready var recruit_level_label: Label = $Panel/MarginContainer/VBox/Header/RecruitLevelLabel
@onready var class_list: VBoxContainer = $Panel/MarginContainer/VBox/Content/ClassScroll/ClassList
@onready var detail_panel: VBoxContainer = $Panel/MarginContainer/VBox/Content/DetailPanel
@onready var close_button: Button = $Panel/MarginContainer/VBox/CloseButton


func _ready() -> void:
	close_button.pressed.connect(func():
		SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
		recruit_closed.emit()
	)
	_update_gold()
	_show_class_list()


func _update_gold() -> void:
	gold_label.text = "Gold: %d" % GameState.gold
	recruit_level_label.text = "Recruit Lv: %d" % GameState.get_lowest_party_level()


func _show_class_list() -> void:
	_phase = Phase.CLASS_SELECT
	_selected_class_id = ""
	_clear_children(class_list)
	_clear_children(detail_panel)

	var unlocked := GameState.unlocked_classes
	if unlocked.is_empty():
		var empty := Label.new()
		empty.text = "No classes unlocked."
		empty.add_theme_font_size_override("font_size", 14)
		empty.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		class_list.add_child(empty)
		return

	for class_id in unlocked:
		if class_id == "prince" or class_id == "princess":
			continue
		var path := "res://resources/classes/%s.tres" % class_id
		if not ResourceLoader.exists(path):
			continue
		var data: FighterData = load(path)
		if not data:
			continue
		_add_class_row(data)


func _add_class_row(data: FighterData) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)

	var name_btn := Button.new()
	name_btn.text = data.class_display_name
	name_btn.custom_minimum_size = Vector2(140, 32)
	name_btn.add_theme_font_size_override("font_size", 14)
	name_btn.pressed.connect(_on_class_selected.bind(data))
	row.add_child(name_btn)

	var tier_names := ["Base", "Tier 1", "Tier 2"]
	var tier_label := Label.new()
	tier_label.text = tier_names[clampi(data.tier, 0, 2)]
	tier_label.custom_minimum_size = Vector2(50, 0)
	tier_label.add_theme_font_size_override("font_size", 12)
	var tier_colors := [Color(0.6, 0.6, 0.6), Color(0.4, 0.7, 1.0), Color(0.9, 0.7, 0.2)]
	tier_label.add_theme_color_override("font_color", tier_colors[clampi(data.tier, 0, 2)])
	row.add_child(tier_label)

	var cost := GameState.get_recruit_cost(data.class_id)
	var cost_label := Label.new()
	cost_label.text = "%dg" % cost
	cost_label.custom_minimum_size = Vector2(50, 0)
	cost_label.add_theme_font_size_override("font_size", 13)
	if GameState.can_afford(cost):
		cost_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
	else:
		cost_label.add_theme_color_override("font_color", Color(0.5, 0.3, 0.3))
		name_btn.disabled = true
	row.add_child(cost_label)

	class_list.add_child(row)


func _on_class_selected(data: FighterData) -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_selected_class_id = data.class_id
	_show_class_detail(data)


func _show_class_detail(data: FighterData) -> void:
	_clear_children(detail_panel)

	var recruit_level := GameState.get_lowest_party_level()
	var stats := data.get_stats_at_level(recruit_level)

	var title := Label.new()
	title.text = data.class_display_name
	title.add_theme_font_size_override("font_size", 18)
	detail_panel.add_child(title)

	var level_lbl := Label.new()
	level_lbl.text = "Level: %d" % recruit_level
	level_lbl.add_theme_font_size_override("font_size", 13)
	level_lbl.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	detail_panel.add_child(level_lbl)

	var sep := HSeparator.new()
	detail_panel.add_child(sep)

	var stat_entries := [
		["HP", stats["max_health"]], ["MP", stats["max_mana"]],
		["P.Atk", stats["physical_attack"]], ["P.Def", stats["physical_defense"]],
		["M.Atk", stats["magic_attack"]], ["M.Def", stats["magic_defense"]],
		["Speed", stats["speed"]], ["Move", stats["movement"]], ["Jump", stats["jump"]],
	]
	for entry in stat_entries:
		var stat_row := HBoxContainer.new()
		stat_row.add_theme_constant_override("separation", 8)
		var sname := Label.new()
		sname.text = entry[0]
		sname.custom_minimum_size = Vector2(50, 0)
		sname.add_theme_font_size_override("font_size", 12)
		sname.add_theme_color_override("font_color", Color(0.6, 0.7, 0.8))
		stat_row.add_child(sname)
		var sval := Label.new()
		sval.text = str(entry[1])
		sval.add_theme_font_size_override("font_size", 12)
		stat_row.add_child(sval)
		detail_panel.add_child(stat_row)

	if data.abilities.size() > 0:
		var sep2 := HSeparator.new()
		detail_panel.add_child(sep2)
		var ab_title := Label.new()
		ab_title.text = "Abilities:"
		ab_title.add_theme_font_size_override("font_size", 13)
		ab_title.add_theme_color_override("font_color", Color(0.8, 0.7, 0.5))
		detail_panel.add_child(ab_title)
		for ability in data.abilities:
			var ab_btn := Button.new()
			ab_btn.text = "  %s (MP: %d, R: %d)" % [ability.ability_name, ability.mana_cost, ability.ability_range]
			ab_btn.flat = true
			ab_btn.add_theme_font_size_override("font_size", 12)
			ab_btn.mouse_entered.connect(_show_ability_tooltip.bind(ability, ab_btn))
			ab_btn.mouse_exited.connect(_hide_ability_tooltip)
			ab_btn.focus_entered.connect(_show_ability_tooltip.bind(ability, ab_btn))
			ab_btn.focus_exited.connect(_hide_ability_tooltip)
			detail_panel.add_child(ab_btn)

	var cost := GameState.get_recruit_cost(data.class_id)
	var sep3 := HSeparator.new()
	detail_panel.add_child(sep3)

	var cost_lbl := Label.new()
	cost_lbl.text = "Cost: %dg" % cost
	cost_lbl.add_theme_font_size_override("font_size", 14)
	cost_lbl.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
	detail_panel.add_child(cost_lbl)

	var recruit_btn := Button.new()
	recruit_btn.text = "Recruit"
	recruit_btn.custom_minimum_size = Vector2(120, 36)
	recruit_btn.disabled = not GameState.can_afford(cost)
	recruit_btn.pressed.connect(_on_recruit_pressed)
	detail_panel.add_child(recruit_btn)


func _on_recruit_pressed() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_phase = Phase.GENDER_SELECT
	_clear_children(detail_panel)

	var title := Label.new()
	title.text = "Choose Gender"
	title.add_theme_font_size_override("font_size", 16)
	detail_panel.add_child(title)

	var male_btn := Button.new()
	male_btn.text = "Male"
	male_btn.custom_minimum_size = Vector2(120, 36)
	male_btn.pressed.connect(_on_gender_chosen.bind("male"))
	detail_panel.add_child(male_btn)

	var female_btn := Button.new()
	female_btn.text = "Female"
	female_btn.custom_minimum_size = Vector2(120, 36)
	female_btn.pressed.connect(_on_gender_chosen.bind("female"))
	detail_panel.add_child(female_btn)

	var back_btn := Button.new()
	back_btn.text = "Back"
	back_btn.custom_minimum_size = Vector2(80, 30)
	back_btn.pressed.connect(func():
		var path := "res://resources/classes/%s.tres" % _selected_class_id
		_show_class_detail(load(path))
	)
	detail_panel.add_child(back_btn)


func _on_gender_chosen(gender: String) -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_selected_gender = gender
	_phase = Phase.NAME_INPUT
	_clear_children(detail_panel)

	var title := Label.new()
	title.text = "Enter Name"
	title.add_theme_font_size_override("font_size", 16)
	detail_panel.add_child(title)

	var name_input := LineEdit.new()
	name_input.placeholder_text = "Recruit name..."
	name_input.custom_minimum_size = Vector2(200, 36)
	name_input.max_length = 20
	detail_panel.add_child(name_input)

	var btn_row := HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 12)

	var confirm_btn := Button.new()
	confirm_btn.text = "Confirm"
	confirm_btn.custom_minimum_size = Vector2(100, 36)
	confirm_btn.pressed.connect(_on_name_confirmed.bind(name_input))
	btn_row.add_child(confirm_btn)

	var back_btn := Button.new()
	back_btn.text = "Back"
	back_btn.custom_minimum_size = Vector2(80, 30)
	back_btn.pressed.connect(_on_recruit_pressed)
	btn_row.add_child(back_btn)

	detail_panel.add_child(btn_row)

	name_input.grab_focus()


func _on_name_confirmed(name_input: LineEdit) -> void:
	var recruit_name := name_input.text.strip_edges()
	if recruit_name.is_empty():
		return

	var cost := GameState.get_recruit_cost(_selected_class_id)
	if not GameState.spend_gold(cost):
		return
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)

	var recruit_level := GameState.get_lowest_party_level()
	GameState.add_party_member(recruit_name, _selected_gender, _selected_class_id, recruit_level)

	_update_gold()
	_show_class_list()

	_clear_children(detail_panel)
	var success := Label.new()
	success.text = "%s the %s has joined your roster!" % [recruit_name, _selected_class_id.capitalize()]
	success.add_theme_font_size_override("font_size", 14)
	success.add_theme_color_override("font_color", Color(0.4, 0.9, 0.4))
	success.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_panel.add_child(success)


var _ability_tooltip: AbilityTooltip = null


func _show_ability_tooltip(ability: AbilityData, anchor: Button) -> void:
	_hide_ability_tooltip()
	_ability_tooltip = AbilityTooltip.create(ability)
	detail_panel.add_child(_ability_tooltip)
	_ability_tooltip.position = Vector2(anchor.size.x + 8, anchor.position.y)


func _hide_ability_tooltip() -> void:
	if _ability_tooltip:
		_ability_tooltip.queue_free()
		_ability_tooltip = null


func _clear_children(container: Node) -> void:
	_hide_ability_tooltip()
	for child in container.get_children():
		child.queue_free()
