class_name RewardChoiceUI
extends Control

signal item_chosen(item_id: String)

const STAT_NAMES: Dictionary = {
	0: "P.Atk",
	1: "P.Def",
	2: "M.Atk",
	3: "M.Def",
	7: "Speed",
	8: "Dodge%",
	10: "Max HP",
	11: "Max MP",
	12: "Crit%",
	14: "Movement",
	15: "Jump",
}


func setup(items: Array) -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var bg := ColorRect.new()
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0.0, 0.0, 0.0, 0.75)
	add_child(bg)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var outer_panel := PanelContainer.new()
	center.add_child(outer_panel)

	var outer_vbox := VBoxContainer.new()
	outer_vbox.add_theme_constant_override("separation", 20)
	outer_panel.add_child(outer_vbox)

	var title := Label.new()
	title.text = "Choose Your Reward"
	title.add_theme_font_size_override("font_size", 24)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	outer_vbox.add_child(title)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 16)
	outer_vbox.add_child(hbox)

	for item in items:
		hbox.add_child(_make_card(item))


func _make_card(item: Resource) -> Control:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(210, 0)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	panel.add_child(vbox)

	var name_label := Label.new()
	name_label.text = item.get("display_name") if item.get("display_name") else item.get("item_id")
	name_label.add_theme_font_size_override("font_size", 16)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(name_label)

	var sep := HSeparator.new()
	vbox.add_child(sep)

	var desc_label := Label.new()
	desc_label.text = item.get("description") if item.get("description") else ""
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.add_theme_font_size_override("font_size", 12)
	desc_label.custom_minimum_size = Vector2(190, 0)
	vbox.add_child(desc_label)

	var bonuses: Dictionary = item.get("stat_bonuses") if item.get("stat_bonuses") else {}
	for stat_key: int in bonuses:
		var stat_label := Label.new()
		var stat_name: String = STAT_NAMES.get(stat_key, "Stat %d" % stat_key)
		stat_label.text = "+%d %s" % [bonuses[stat_key], stat_name]
		stat_label.add_theme_color_override("font_color", Color(0.6, 1.0, 0.7))
		stat_label.add_theme_font_size_override("font_size", 14)
		vbox.add_child(stat_label)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(spacer)

	var choose_btn := Button.new()
	choose_btn.text = "Choose"
	var id: String = item.get("item_id")
	choose_btn.pressed.connect(func() -> void: item_chosen.emit(id))
	vbox.add_child(choose_btn)

	return panel
