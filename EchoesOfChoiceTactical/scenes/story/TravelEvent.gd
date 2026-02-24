extends Control

signal event_finished
signal ambush_battle_requested

var _event_data: Dictionary = {}


func show_event(event: Dictionary) -> void:
	_event_data = event
	_build_ui()
	visible = true


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
