extends Control

signal promote_closed

var _selected_unit_name: String = ""
var _selected_class_id: String = ""

@onready var jp_info_label: Label = $Panel/MarginContainer/VBox/Header/JPInfoLabel
@onready var member_list: VBoxContainer = $Panel/MarginContainer/VBox/Content/MemberScroll/MemberList
@onready var detail_panel: VBoxContainer = $Panel/MarginContainer/VBox/Content/DetailScroll/DetailPanel
@onready var close_button: Button = $Panel/MarginContainer/VBox/CloseButton

const STAT_ENTRIES: Array = [
	["HP", "max_health"], ["MP", "max_mana"],
	["P.Atk", "physical_attack"], ["P.Def", "physical_defense"],
	["M.Atk", "magic_attack"], ["M.Def", "magic_defense"],
	["Speed", "speed"], ["Move", "movement"], ["Jump", "jump"],
	["Crit", "crit_chance"], ["Dodge", "dodge_chance"],
]


func _ready() -> void:
	close_button.pressed.connect(func():
		SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
		promote_closed.emit()
	)
	_show_member_list()


func _show_member_list() -> void:
	_selected_unit_name = ""
	_selected_class_id = ""
	_clear_children(member_list)
	_clear_children(detail_panel)

	var found_any := false

	if GameState.can_promote(GameState.player_name):
		_add_member_row(
			GameState.player_name,
			GameState.player_class_id,
			GameState.player_jp,
		)
		found_any = true

	for member in GameState.party_members:
		var unit_name: String = member.get("name", "")
		if GameState.can_promote(unit_name):
			_add_member_row(
				unit_name,
				member.get("class_id", ""),
				member.get("jp", 0),
			)
			found_any = true

	if not found_any:
		var empty := Label.new()
		empty.text = "No members ready for promotion."
		empty.add_theme_font_size_override("font_size", 14)
		empty.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		member_list.add_child(empty)

	jp_info_label.text = "Spend JP to upgrade class tier"


func _add_member_row(unit_name: String, class_id: String, jp: int) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)

	var name_btn := Button.new()
	name_btn.text = unit_name
	name_btn.custom_minimum_size = Vector2(120, 32)
	name_btn.add_theme_font_size_override("font_size", 14)
	name_btn.pressed.connect(_on_member_selected.bind(unit_name, class_id))
	row.add_child(name_btn)

	var class_label := Label.new()
	class_label.text = class_id.capitalize()
	class_label.custom_minimum_size = Vector2(90, 0)
	class_label.add_theme_font_size_override("font_size", 12)
	class_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	row.add_child(class_label)

	var jp_label := Label.new()
	jp_label.text = "%d JP" % jp
	jp_label.add_theme_font_size_override("font_size", 12)
	jp_label.add_theme_color_override("font_color", Color(0.3, 0.8, 1.0))
	row.add_child(jp_label)

	member_list.add_child(row)


func _on_member_selected(unit_name: String, class_id: String) -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_selected_unit_name = unit_name
	_selected_class_id = class_id
	_show_promotion_options()


func _show_promotion_options() -> void:
	_clear_children(detail_panel)

	var path := "res://resources/classes/%s.tres" % _selected_class_id
	if not ResourceLoader.exists(path):
		return
	var current_data: FighterData = load(path) as FighterData
	if not current_data:
		return

	var level := _get_unit_level(_selected_unit_name)
	var current_stats := current_data.get_stats_at_level(level)

	var tier_threshold := GameState.get_jp_threshold(current_data.tier)
	var tier_names := ["Base", "Tier 1", "Tier 2"]
	var current_tier_name: String = tier_names[clampi(current_data.tier, 0, 2)]
	var next_tier_name: String = tier_names[clampi(current_data.tier + 1, 0, 2)]

	var header := Label.new()
	header.text = "%s — %s (%s)" % [_selected_unit_name, current_data.class_display_name, current_tier_name]
	header.add_theme_font_size_override("font_size", 16)
	detail_panel.add_child(header)

	var jp_lbl := Label.new()
	jp_lbl.text = "JP: %d / %d — Promote to %s" % [_get_unit_jp(_selected_unit_name), tier_threshold, next_tier_name]
	jp_lbl.add_theme_font_size_override("font_size", 12)
	jp_lbl.add_theme_color_override("font_color", Color(0.3, 0.8, 1.0))
	detail_panel.add_child(jp_lbl)

	var sep := HSeparator.new()
	detail_panel.add_child(sep)

	var choose_lbl := Label.new()
	choose_lbl.text = "Choose a specialization:"
	choose_lbl.add_theme_font_size_override("font_size", 13)
	choose_lbl.add_theme_color_override("font_color", Color(0.8, 0.8, 0.6))
	detail_panel.add_child(choose_lbl)

	for option in current_data.upgrade_options:
		_add_upgrade_option(option, current_stats, level)


func _add_upgrade_option(option: FighterData, current_stats: Dictionary, level: int) -> void:
	var new_stats := option.get_stats_at_level(level)

	var option_container := VBoxContainer.new()
	option_container.add_theme_constant_override("separation", 2)

	var tier_colors := [Color(0.6, 0.6, 0.6), Color(0.4, 0.7, 1.0), Color(0.9, 0.7, 0.2)]
	var title := Label.new()
	title.text = option.class_display_name
	title.add_theme_font_size_override("font_size", 15)
	title.add_theme_color_override("font_color", tier_colors[clampi(option.tier, 0, 2)])
	option_container.add_child(title)

	for entry in STAT_ENTRIES:
		var stat_name: String = entry[0]
		var stat_key: String = entry[1]
		var old_val: int = current_stats.get(stat_key, 0)
		var new_val: int = new_stats.get(stat_key, 0)
		var delta: int = new_val - old_val

		var stat_row := HBoxContainer.new()
		stat_row.add_theme_constant_override("separation", 6)

		var sname := Label.new()
		sname.text = stat_name
		sname.custom_minimum_size = Vector2(45, 0)
		sname.add_theme_font_size_override("font_size", 11)
		sname.add_theme_color_override("font_color", Color(0.6, 0.7, 0.8))
		stat_row.add_child(sname)

		var sval := Label.new()
		sval.text = "%d → %d" % [old_val, new_val]
		sval.custom_minimum_size = Vector2(80, 0)
		sval.add_theme_font_size_override("font_size", 11)
		stat_row.add_child(sval)

		var delta_lbl := Label.new()
		if delta > 0:
			delta_lbl.text = "+%d" % delta
			delta_lbl.add_theme_color_override("font_color", Color(0.4, 0.9, 0.4))
		elif delta < 0:
			delta_lbl.text = "%d" % delta
			delta_lbl.add_theme_color_override("font_color", Color(0.9, 0.4, 0.4))
		else:
			delta_lbl.text = "="
			delta_lbl.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		delta_lbl.add_theme_font_size_override("font_size", 11)
		stat_row.add_child(delta_lbl)

		option_container.add_child(stat_row)

	if option.abilities.size() > 0:
		var ab_title := Label.new()
		ab_title.text = "Abilities:"
		ab_title.add_theme_font_size_override("font_size", 11)
		ab_title.add_theme_color_override("font_color", Color(0.8, 0.7, 0.5))
		option_container.add_child(ab_title)
		for ability in option.abilities:
			var ab_lbl := Label.new()
			ab_lbl.text = "  " + ability.display_name
			ab_lbl.add_theme_font_size_override("font_size", 11)
			option_container.add_child(ab_lbl)

	var promote_btn := Button.new()
	promote_btn.text = "Promote to %s" % option.class_display_name
	promote_btn.custom_minimum_size = Vector2(180, 30)
	promote_btn.add_theme_font_size_override("font_size", 13)
	promote_btn.pressed.connect(_on_promote_confirmed.bind(option.class_id, option.class_display_name))
	option_container.add_child(promote_btn)

	var spacer := HSeparator.new()
	option_container.add_child(spacer)

	detail_panel.add_child(option_container)


func _on_promote_confirmed(new_class_id: String, display_name: String) -> void:
	if not GameState.promote_member(_selected_unit_name, new_class_id):
		return
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)

	_clear_children(detail_panel)
	var success := Label.new()
	success.text = "%s has been promoted to %s!" % [_selected_unit_name, display_name]
	success.add_theme_font_size_override("font_size", 15)
	success.add_theme_color_override("font_color", Color(0.4, 0.9, 0.4))
	success.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_panel.add_child(success)

	var slot_info := Label.new()
	var new_tier := GameState.get_unit_tier(_selected_unit_name)
	slot_info.text = "Equipment slots: %d" % (new_tier + 1)
	slot_info.add_theme_font_size_override("font_size", 12)
	slot_info.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	detail_panel.add_child(slot_info)

	_show_member_list()


func _get_unit_jp(unit_name: String) -> int:
	if unit_name == GameState.player_name:
		return GameState.player_jp
	for member in GameState.party_members:
		if member.get("name", "") == unit_name:
			return member.get("jp", 0)
	return 0


func _get_unit_level(unit_name: String) -> int:
	if unit_name == GameState.player_name:
		return GameState.player_level
	for member in GameState.party_members:
		if member.get("name", "") == unit_name:
			return member.get("level", 1)
	return 1


func _clear_children(container: Node) -> void:
	for child in container.get_children():
		child.queue_free()
