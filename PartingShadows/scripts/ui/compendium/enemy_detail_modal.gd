class_name EnemyDetailModal extends DetailModalBase

## Detail modal for enemy entries: portrait, stats, abilities, flavor text.

var enemy_data: Dictionary = {}
var _EnemyRouter := preload("res://scripts/data/enemy_db_router.gd")


func _init(data: Dictionary) -> void:
	enemy_data = data


func build_content(container: VBoxContainer) -> void:
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 20)
	hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	container.add_child(hbox)

	# Left side: Portrait + encounter info (fixed width)
	var portrait_container := VBoxContainer.new()
	portrait_container.add_theme_constant_override("separation", 8)
	portrait_container.custom_minimum_size = Vector2(240, 0)
	hbox.add_child(portrait_container)

	var portrait := TextureRect.new()
	portrait.custom_minimum_size = Vector2(240, 240)
	portrait.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	var portrait_path: String = enemy_data.get("portrait_path", "")
	if portrait_path.is_empty() or not ResourceLoader.exists(portrait_path):
		portrait_path = "res://assets/art/ui/placeholder_portrait.png"
	if ResourceLoader.exists(portrait_path):
		portrait.texture = load(portrait_path)

	portrait_container.add_child(portrait)

	# Encounter info below portrait
	var story_id: String = enemy_data.get("story_id", "story_1")
	var story_names := {
		"story_1": "The Stranger's Shadow",
		"story_2": "Echoes in the Dark",
		"story_3": "The Woven Night",
	}

	var scene_image: String = enemy_data.get("scene_image", "")
	if not scene_image.is_empty() and ResourceLoader.exists(scene_image):
		var scene_tex := TextureRect.new()
		scene_tex.custom_minimum_size = Vector2(240, 140)
		scene_tex.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		scene_tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		scene_tex.texture = load(scene_image)
		portrait_container.add_child(scene_tex)

	var story_label := Label.new()
	story_label.text = story_names.get(story_id, story_id)
	story_label.add_theme_font_size_override("font_size", SettingsManager.font_size - 1)
	story_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	story_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	portrait_container.add_child(story_label)

	# Right side: tabbed panel
	var right_panel := VBoxContainer.new()
	right_panel.add_theme_constant_override("separation", 8)
	right_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	hbox.add_child(right_panel)

	# Name (always visible above tabs)
	var name_label := Label.new()
	name_label.text = enemy_data.get("name", "Unknown Enemy")
	name_label.add_theme_font_size_override("font_size", 20)
	name_label.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	right_panel.add_child(name_label)

	var sep := HSeparator.new()
	right_panel.add_child(sep)

	# Tab buttons
	var tab_row := HBoxContainer.new()
	tab_row.add_theme_constant_override("separation", 8)
	right_panel.add_child(tab_row)

	var info_btn := Button.new()
	info_btn.text = "Info"
	info_btn.custom_minimum_size = Vector2(100, 28)
	info_btn.add_theme_font_size_override("font_size", SettingsManager.font_size)
	info_btn.focus_mode = Control.FOCUS_ALL
	tab_row.add_child(info_btn)

	var abilities_btn := Button.new()
	abilities_btn.text = "Abilities"
	abilities_btn.custom_minimum_size = Vector2(100, 28)
	abilities_btn.add_theme_font_size_override("font_size", SettingsManager.font_size)
	abilities_btn.focus_mode = Control.FOCUS_ALL
	tab_row.add_child(abilities_btn)

	info_btn.focus_neighbor_right = abilities_btn.get_path()
	abilities_btn.focus_neighbor_left = info_btn.get_path()

	# Info tab content
	var info_content := VBoxContainer.new()
	info_content.add_theme_constant_override("separation", 8)
	right_panel.add_child(info_content)

	var flavor: String = enemy_data.get("flavor_text", "")
	if not flavor.is_empty():
		var flavor_label := Label.new()
		flavor_label.text = flavor
		flavor_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		flavor_label.add_theme_font_size_override("font_size", SettingsManager.font_size - 4)
		flavor_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.8))
		info_content.add_child(flavor_label)
		var sep2 := HSeparator.new()
		info_content.add_child(sep2)

	var stats_label := Label.new()
	stats_label.text = "Base Stats:"
	stats_label.add_theme_font_size_override("font_size", SettingsManager.font_size - 4)
	stats_label.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	info_content.add_child(stats_label)

	var stats_display := Label.new()
	stats_display.text = _format_stats()
	stats_display.add_theme_font_size_override("font_size", SettingsManager.font_size - 6)
	info_content.add_child(stats_display)

	# Abilities tab content
	var abilities_content := VBoxContainer.new()
	abilities_content.add_theme_constant_override("separation", 4)
	abilities_content.visible = false
	right_panel.add_child(abilities_content)

	var abilities: Array = enemy_data.get("abilities", [])
	if abilities.is_empty():
		var none_label := Label.new()
		none_label.text = "(No abilities data)"
		none_label.add_theme_font_size_override("font_size", SettingsManager.font_size - 6)
		none_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		abilities_content.add_child(none_label)
	for ability: Variant in abilities:
		if ability is Dictionary:
			var name_text: String = "• " + ability.get("name", "???")
			var cost: int = ability.get("mana_cost", 0)
			if cost > 0:
				name_text += "  (%d MP)" % cost
			var ability_name_label := Label.new()
			ability_name_label.text = name_text
			ability_name_label.add_theme_font_size_override("font_size", SettingsManager.font_size - 6)
			ability_name_label.add_theme_color_override("font_color", Color.WHITE)
			abilities_content.add_child(ability_name_label)
			var desc: String = ability.get("description", "")
			if not desc.is_empty():
				var desc_label := Label.new()
				desc_label.text = "    " + desc
				desc_label.add_theme_font_size_override("font_size", SettingsManager.font_size - 8)
				desc_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
				desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
				abilities_content.add_child(desc_label)
		elif ability is String:
			var ability_label := Label.new()
			ability_label.text = "• " + ability
			ability_label.add_theme_font_size_override("font_size", SettingsManager.font_size - 6)
			abilities_content.add_child(ability_label)

	# Tab switching
	var _switch_tab := func(show_info: bool) -> void:
		info_content.visible = show_info
		abilities_content.visible = not show_info
		info_btn.modulate = Color.WHITE if show_info else Color(0.6, 0.6, 0.6)
		abilities_btn.modulate = Color(0.6, 0.6, 0.6) if show_info else Color.WHITE
	info_btn.pressed.connect(func() -> void: _switch_tab.call(true))
	abilities_btn.pressed.connect(func() -> void: _switch_tab.call(false))
	_switch_tab.call(true)


func _format_stats() -> String:
	var class_id: String = enemy_data.get("class_id", "")
	if class_id.is_empty():
		return "Stats unavailable"

	var ranges: Dictionary = _EnemyRouter.get_stat_ranges(class_id)
	if ranges.is_empty():
		return "Stats unavailable"

	var lines: Array[String] = [
		"HP: %s  |  MP: %s" % [_fmt_range(ranges, "max_health"), _fmt_range(ranges, "max_mana")],
		"ATK: %s  |  DEF: %s" % [_fmt_range(ranges, "physical_attack"), _fmt_range(ranges, "physical_defense")],
		"MAG: %s  |  MDEF: %s" % [_fmt_range(ranges, "magic_attack"), _fmt_range(ranges, "magic_defense")],
		"SPD: %s  |  CRIT: %s%%  |  DODGE: %s%%" % [_fmt_range(ranges, "speed"), _fmt_range(ranges, "crit_chance"), _fmt_range(ranges, "dodge_chance")],
	]
	return "\n".join(lines)


func _fmt_range(ranges: Dictionary, stat: String) -> String:
	var r: Dictionary = ranges.get(stat, {})
	var lo: int = r.get("min", 0)
	var hi: int = r.get("max", 0)
	if lo == hi:
		return str(lo)
	return "%d-%d" % [lo, hi]
