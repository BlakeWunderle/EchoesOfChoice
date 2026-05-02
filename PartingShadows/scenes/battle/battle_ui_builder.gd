class_name BattleUIBuilder

const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const PortraitCard := preload("res://scripts/ui/portrait_card.gd")
const StatsPanel := preload("res://scripts/ui/stats_panel.gd")
const TipOverlay := preload("res://scripts/ui/tip_overlay.gd")
const WaitingOverlay := preload("res://scripts/ui/waiting_overlay.gd")


## Builds all battle UI nodes, adds them as children of [param battle],
## and returns a Dictionary of named references. Does NOT connect signals.
static func build(battle: Control) -> Dictionary:
	# Scene image -- full screen background
	var scene_image := TextureRect.new()
	scene_image.set_anchors_preset(Control.PRESET_FULL_RECT)
	scene_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	scene_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	scene_image.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	scene_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	battle.add_child(scene_image)

	# Gradient overlay -- fades scene image into dark at bottom
	var gradient_overlay := TextureRect.new()
	gradient_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	gradient_overlay.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	gradient_overlay.stretch_mode = TextureRect.STRETCH_SCALE
	gradient_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var grad := GradientTexture2D.new()
	grad.gradient = Gradient.new()
	grad.gradient.set_color(0, Color(0.05, 0.05, 0.08, 0.0))
	grad.gradient.set_color(1, Color(0.05, 0.05, 0.08, 1.0))
	grad.gradient.set_offset(0, 0.3)
	grad.gradient.set_offset(1, 0.7)
	grad.fill_from = Vector2(0.5, 0.0)
	grad.fill_to = Vector2(0.5, 1.0)
	gradient_overlay.texture = grad
	battle.add_child(gradient_overlay)

	# UI root -- layered on top of scene image with bottom padding
	var ui_margin := MarginContainer.new()
	ui_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui_margin.add_theme_constant_override("margin_bottom", 16)
	ui_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	battle.add_child(ui_margin)

	var ui_root := VBoxContainer.new()
	ui_root.add_theme_constant_override("separation", 4)
	ui_root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ui_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_margin.add_child(ui_root)

	# Scene spacer -- pushes UI content to bottom half
	var scene_spacer := Control.new()
	scene_spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scene_spacer.size_flags_stretch_ratio = 3.0
	scene_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_root.add_child(scene_spacer)

	# Turn order bar (fixed height, no resizing)
	var turn_order_label := RichTextLabel.new()
	turn_order_label.bbcode_enabled = true
	turn_order_label.fit_content = false
	turn_order_label.scroll_active = false
	turn_order_label.add_theme_font_size_override("normal_font_size", 13)
	turn_order_label.custom_minimum_size = Vector2(0, 22)
	turn_order_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_root.add_child(turn_order_label)

	# Portraits row -- party left, enemies right
	var portraits_row := HBoxContainer.new()
	portraits_row.add_theme_constant_override("separation", 0)
	portraits_row.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Add left margin
	var left_margin := Control.new()
	left_margin.custom_minimum_size = Vector2(16, 0)
	left_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portraits_row.add_child(left_margin)

	var party_cards_box := HBoxContainer.new()
	party_cards_box.add_theme_constant_override("separation", 8)
	party_cards_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portraits_row.add_child(party_cards_box)

	var card_spacer := Control.new()
	card_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portraits_row.add_child(card_spacer)

	var enemy_cards_box := HBoxContainer.new()
	enemy_cards_box.add_theme_constant_override("separation", 8)
	enemy_cards_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portraits_row.add_child(enemy_cards_box)

	# Add right margin
	var right_margin := Control.new()
	right_margin.custom_minimum_size = Vector2(16, 0)
	right_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	portraits_row.add_child(right_margin)

	ui_root.add_child(portraits_row)

	# Bottom area: combat log (left) + action menu (right)
	# Fixed minimum height so portraits never shift when the action menu shows/hides
	var row_h: int = maxi(ChoiceMenu.GRID_BUTTON_MIN_SIZE.y,
		SettingsManager.font_size * 2 + 28)
	var bottom_row := HBoxContainer.new()
	bottom_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	bottom_row.size_flags_stretch_ratio = 1.2
	bottom_row.custom_minimum_size.y = row_h * 3 + 16
	bottom_row.add_theme_constant_override("separation", 16)
	ui_root.add_child(bottom_row)

	# Left side: persistent combat log
	var log_panel := VBoxContainer.new()
	log_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	log_panel.size_flags_stretch_ratio = 1.0
	log_panel.add_theme_constant_override("separation", 2)
	bottom_row.add_child(log_panel)

	var action_text := RichTextLabel.new()
	action_text.bbcode_enabled = true
	action_text.fit_content = false
	action_text.scroll_active = true
	action_text.scroll_following = true
	action_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	action_text.add_theme_font_size_override("normal_font_size", 14)
	action_text.mouse_filter = Control.MOUSE_FILTER_STOP
	log_panel.add_child(action_text)

	# Right side: action menu (bottom-aligned so content sits at bottom edge)
	var bottom_panel := VBoxContainer.new()
	bottom_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	bottom_panel.size_flags_stretch_ratio = 1.0
	bottom_panel.alignment = BoxContainer.ALIGNMENT_END
	bottom_row.add_child(bottom_panel)

	var action_menu := ChoiceMenu.new()
	action_menu.visible = false
	bottom_panel.add_child(action_menu)

	# Stats panel (overlay, on top of everything)
	var stats_panel := StatsPanel.new()
	stats_panel.visible = false
	stats_panel.set_anchors_preset(Control.PRESET_CENTER)
	stats_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	stats_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	stats_panel.custom_minimum_size = Vector2(350, 0)
	battle.add_child(stats_panel)

	var tip_overlay := TipOverlay.new()
	battle.add_child(tip_overlay)

	var waiting_overlay := WaitingOverlay.new()
	battle.add_child(waiting_overlay)

	# Local co-op player indicator
	var player_indicator := Label.new()
	player_indicator.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	player_indicator.add_theme_font_size_override("font_size", 20)
	player_indicator.add_theme_color_override("font_color", Color(0.3, 0.9, 0.5))
	player_indicator.set_anchors_preset(Control.PRESET_CENTER_TOP)
	player_indicator.grow_horizontal = Control.GROW_DIRECTION_BOTH
	player_indicator.offset_left = -200
	player_indicator.offset_right = 200
	player_indicator.offset_top = 12
	player_indicator.visible = false
	battle.add_child(player_indicator)

	# Auto-battle toggle button
	var auto_button := Button.new()
	auto_button.text = "AUTO"
	auto_button.flat = true
	auto_button.focus_mode = Control.FOCUS_NONE
	auto_button.add_theme_font_size_override("font_size", 18)
	auto_button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	auto_button.offset_left = -100
	auto_button.offset_right = -12
	auto_button.offset_top = 12
	auto_button.visible = false
	battle.add_child(auto_button)

	return {
		"scene_image": scene_image,
		"gradient_overlay": gradient_overlay,
		"action_text": action_text,
		"action_menu": action_menu,
		"stats_panel": stats_panel,
		"party_cards_box": party_cards_box,
		"enemy_cards_box": enemy_cards_box,
		"bottom_panel": bottom_panel,
		"turn_order_label": turn_order_label,
		"tip_overlay": tip_overlay,
		"waiting_overlay": waiting_overlay,
		"player_indicator": player_indicator,
		"auto_button": auto_button,
	}
