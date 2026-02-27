extends Control

signal summary_closed

@onready var title_label: Label = $Panel/MarginContainer/VBox/TitleLabel
@onready var unit_list: VBoxContainer = $Panel/MarginContainer/VBox/ScrollContainer/UnitList
@onready var continue_button: Button = $Panel/MarginContainer/VBox/ContinueButton


func _ready() -> void:
	MusicManager.play_music("res://assets/audio/music/victory/SHORT Action #5 LOOP.wav")
	SFXManager.play(SFXManager.Category.UI_FANFARE, 0.8)
	continue_button.pressed.connect(func():
		SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
		summary_closed.emit()
		queue_free()
	)


func setup(player_units: Array, gold_earned: int = 0, perma_fallen: Array[String] = [], item_rewards: Array[String] = []) -> void:
	for child in unit_list.get_children():
		child.queue_free()

	if gold_earned > 0:
		var gold_row := HBoxContainer.new()
		gold_row.add_theme_constant_override("separation", 8)
		var gold_label := Label.new()
		gold_label.text = "Gold +%d   (Total: %d)" % [gold_earned, GameState.gold]
		gold_label.add_theme_font_size_override("font_size", 15)
		gold_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
		gold_row.add_child(gold_label)
		unit_list.add_child(gold_row)

	for item_id in item_rewards:
		var item_row := HBoxContainer.new()
		var item_label := Label.new()
		var item_res: Resource = GameState.get_item_resource(item_id)
		var display: String = item_res.display_name if item_res and item_res.get("display_name") else item_id
		item_label.text = "Item obtained: %s" % display
		item_label.add_theme_font_size_override("font_size", 15)
		item_label.add_theme_color_override("font_color", Color(0.6, 1.0, 0.7))
		item_row.add_child(item_label)
		unit_list.add_child(item_row)

	if gold_earned > 0 or item_rewards.size() > 0:
		var sep := HSeparator.new()
		sep.add_theme_constant_override("separation", 4)
		unit_list.add_child(sep)

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
			name_label.add_theme_color_override("font_color", Color(0.7, 0.2, 0.2))
			var fallen_label := Label.new()
			if unit.unit_name in perma_fallen:
				fallen_label.text = "LOST PERMANENTLY"
				fallen_label.add_theme_color_override("font_color", Color(0.9, 0.15, 0.15))
			else:
				fallen_label.text = "(Fallen)"
				fallen_label.add_theme_color_override("font_color", Color(0.6, 0.3, 0.3))
			fallen_label.add_theme_font_size_override("font_size", 11)
			row.add_child(fallen_label)

	if perma_fallen.size() > 0:
		var sep2 := HSeparator.new()
		sep2.add_theme_constant_override("separation", 8)
		unit_list.add_child(sep2)
		var death_note := Label.new()
		var names_str := ", ".join(perma_fallen)
		death_note.text = "%s ha%s been permanently lost." % [names_str, "s" if perma_fallen.size() == 1 else "ve"]
		death_note.add_theme_font_size_override("font_size", 13)
		death_note.add_theme_color_override("font_color", Color(0.8, 0.25, 0.25))
		death_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		unit_list.add_child(death_note)
