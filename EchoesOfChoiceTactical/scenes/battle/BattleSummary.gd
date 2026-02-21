extends Control

signal summary_closed

@onready var title_label: Label = $Panel/MarginContainer/VBox/TitleLabel
@onready var unit_list: VBoxContainer = $Panel/MarginContainer/VBox/ScrollContainer/UnitList
@onready var continue_button: Button = $Panel/MarginContainer/VBox/ContinueButton


func _ready() -> void:
	continue_button.pressed.connect(func():
		summary_closed.emit()
		queue_free()
	)


func setup(player_units: Array) -> void:
	for child in unit_list.get_children():
		child.queue_free()

	for u in player_units:
		if not u is Unit:
			continue
		var unit: Unit = u
		if not unit.is_alive and unit.xp_gained_this_battle == 0:
			continue

		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 16)

		var name_label := Label.new()
		name_label.text = unit.unit_name
		name_label.custom_minimum_size = Vector2(140, 0)
		name_label.add_theme_font_size_override("font_size", 15)
		row.add_child(name_label)

		var class_label := Label.new()
		class_label.text = unit.unit_class
		class_label.custom_minimum_size = Vector2(100, 0)
		class_label.add_theme_font_size_override("font_size", 13)
		class_label.add_theme_color_override("font_color", Color(0.6, 0.7, 0.8))
		row.add_child(class_label)

		var xp_label := Label.new()
		xp_label.text = "XP +%d" % unit.xp_gained_this_battle
		xp_label.custom_minimum_size = Vector2(80, 0)
		xp_label.add_theme_font_size_override("font_size", 13)
		xp_label.add_theme_color_override("font_color", Color(0.9, 0.85, 0.4))
		row.add_child(xp_label)

		var jp_label := Label.new()
		jp_label.text = "JP +%d" % unit.jp_gained_this_battle
		jp_label.custom_minimum_size = Vector2(80, 0)
		jp_label.add_theme_font_size_override("font_size", 13)
		jp_label.add_theme_color_override("font_color", Color(0.4, 0.8, 0.9))
		row.add_child(jp_label)

		var level_label := Label.new()
		level_label.text = "Lv %d" % unit.level
		level_label.add_theme_font_size_override("font_size", 13)
		if unit.levels_gained_this_battle > 0:
			level_label.text += "  LEVEL UP!"
			level_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.3))
		else:
			level_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
		row.add_child(level_label)

		unit_list.add_child(row)

		if not unit.is_alive:
			name_label.add_theme_color_override("font_color", Color(0.5, 0.3, 0.3))
			var fallen := Label.new()
			fallen.text = "(Fallen)"
			fallen.add_theme_font_size_override("font_size", 11)
			fallen.add_theme_color_override("font_color", Color(0.6, 0.3, 0.3))
			row.add_child(fallen)
