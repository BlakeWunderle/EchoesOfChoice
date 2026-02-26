extends Control

signal event_finished
signal ambush_battle_requested

var _event_data: Dictionary = {}


func show_event(event: Dictionary) -> void:
	_event_data = event
	_build_ui()
	visible = true
	SFXManager.play(SFXManager.Category.UI_POPUP, 0.6)

	# Popup entrance animation: scale up + fade in
	var panel_node := get_child(1) if get_child_count() > 1 else null
	if panel_node:
		panel_node.scale = Vector2(0.9, 0.9)
		panel_node.pivot_offset = panel_node.size * 0.5
		panel_node.modulate.a = 0.0
		var tween := create_tween()
		tween.set_parallel(true)
		tween.tween_property(panel_node, "scale", Vector2.ONE, 0.2).set_ease(Tween.EASE_OUT)
		tween.tween_property(panel_node, "modulate:a", 1.0, 0.2)


func _build_ui() -> void:
	# Full-screen dim overlay
	var overlay := ColorRect.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0.0, 0.0, 0.0, 0.65)
	add_child(overlay)

	# Centered panel
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(500, 0)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_bottom", 24)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 14)
	margin.add_child(vbox)

	var event_type: String = _event_data.get("event_type", "story")
	var type_color: Color = _type_color(event_type)

	var tag_label := Label.new()
	tag_label.text = event_type.to_upper()
	tag_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tag_label.add_theme_color_override("font_color", type_color)
	tag_label.add_theme_font_size_override("font_size", 13)
	vbox.add_child(tag_label)

	var title_label := Label.new()
	title_label.text = _event_data.get("title", "")
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 22)
	vbox.add_child(title_label)

	# Stranger portrait for story_stranger event
	if _event_data.get("id", "") == "story_stranger":
		var frames := SpriteLoader.get_frames("chibi_black_reaper_1_neutral")
		if frames and frames.has_animation("idle_down"):
			var tex := frames.get_frame_texture("idle_down", 0)
			if tex:
				var portrait := TextureRect.new()
				portrait.texture = tex
				portrait.custom_minimum_size = Vector2(64, 64)
				portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
				portrait.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
				vbox.add_child(portrait)

	var sep := HSeparator.new()
	vbox.add_child(sep)

	var dialogue: Array = _event_data.get("dialogue", [])
	for line in dialogue:
		var speaker: String = line.get("speaker", "")
		var text: String = line.get("text", "")
		var line_label := Label.new()
		if speaker.is_empty():
			line_label.text = text
		else:
			line_label.text = "[%s]  %s" % [speaker, text]
		line_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		line_label.custom_minimum_size.x = 440
		vbox.add_child(line_label)

	if event_type == "merchant":
		var shop_btn := Button.new()
		shop_btn.text = "Browse Wares"
		shop_btn.pressed.connect(_on_browse_merchant)
		vbox.add_child(shop_btn)

	var continue_btn := Button.new()
	if event_type == "ambush":
		continue_btn.text = "Fight!"
		continue_btn.pressed.connect(_on_continue)
		vbox.add_child(continue_btn)
		if _event_data.get("can_decline", false):
			var flee_btn := Button.new()
			flee_btn.text = "Flee"
			flee_btn.pressed.connect(func() -> void: event_finished.emit())
			vbox.add_child(flee_btn)
	else:
		continue_btn.text = "Continue"
		continue_btn.pressed.connect(_on_continue)
		vbox.add_child(continue_btn)


func _type_color(event_type: String) -> Color:
	match event_type:
		"story":   return Color(0.7, 0.85, 1.0)
		"rumor":   return Color(1.0, 0.85, 0.4)
		"rest":    return Color(0.5, 0.9, 0.5)
		"merchant": return Color(0.9, 0.7, 0.3)
		"ambush":  return Color(1.0, 0.4, 0.4)
		_:         return Color(1.0, 1.0, 1.0)


func _on_browse_merchant() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	var item_ids: Array = _event_data.get("merchant_items", [])
	var items: Array = []
	for item_id in item_ids:
		var res: Resource = GameState.get_item_resource(item_id)
		if res:
			items.append(res)
	if items.is_empty():
		return
	var shop_scene: PackedScene = preload("res://scenes/ui/ShopUI.tscn")
	var shop: Control = shop_scene.instantiate()
	shop.setup(items)
	shop.shop_closed.connect(func():
		shop.queue_free()
	)
	add_child(shop)


func _on_continue() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	var gold_reward: int = _event_data.get("gold_reward", 0)
	if gold_reward > 0:
		GameState.add_gold(gold_reward)
	var event_type: String = _event_data.get("event_type", "")
	if event_type == "rest":
		GameState.heal_party_partial(GameState.REST_HEAL_FRACTION, GameState.REST_HEAL_FRACTION)
	elif event_type == "ambush":
		ambush_battle_requested.emit()
		return  # OverworldMap handles teardown and routing
	event_finished.emit()
