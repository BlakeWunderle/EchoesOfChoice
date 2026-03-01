class_name TutorialOverlay extends Control

signal dismissed

var _panel: PanelContainer


static func create(title_text: String, body_text: String) -> TutorialOverlay:
	var overlay := TutorialOverlay.new()
	overlay.set_anchors_preset(PRESET_FULL_RECT)
	overlay._build(title_text, body_text)
	return overlay


func _build(title_text: String, body_text: String) -> void:
	# Semi-transparent backdrop
	var bg := ColorRect.new()
	bg.color = Color(0.0, 0.0, 0.0, 0.5)
	bg.set_anchors_preset(PRESET_FULL_RECT)
	add_child(bg)

	_panel = PanelContainer.new()
	_panel.set_anchors_preset(PRESET_CENTER)
	_panel.offset_left = -200
	_panel.offset_right = 200
	_panel.offset_top = -80
	_panel.offset_bottom = 80
	add_child(_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	margin.add_child(vbox)

	var title := Label.new()
	title.text = title_text
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var body := Label.new()
	body.text = body_text
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_font_size_override("font_size", 13)
	vbox.add_child(body)

	var btn := Button.new()
	btn.text = "Got it!"
	btn.custom_minimum_size = Vector2(100, 32)
	btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	btn.pressed.connect(func():
		SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
		dismissed.emit()
		queue_free()
	)
	vbox.add_child(btn)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
		dismissed.emit()
		queue_free()
		get_viewport().set_input_as_handled()


const TUTORIALS: Dictionary = {
	"tutorial_movement": {
		"flag": "tutorial_movement_seen",
		"title": "Movement",
		"body": "Blue tiles show where you can move. Move the cursor to select a tile, then confirm to move there. Press cancel to go back.",
	},
	"tutorial_targeting": {
		"flag": "tutorial_targeting_seen",
		"title": "Targeting",
		"body": "Red tiles show attack range. Move the cursor to an enemy and confirm to attack. The damage preview shows estimated damage.",
	},
	"tutorial_reactions": {
		"flag": "tutorial_reactions_seen",
		"title": "Reactions",
		"body": "Units can react once per round. Reaction icons appear below each unit. Moving near enemies may trigger their reactions!",
	},
}


static func should_show(tutorial_id: String) -> bool:
	var data: Dictionary = TUTORIALS.get(tutorial_id, {})
	if data.is_empty():
		return false
	return not GameState.has_flag(data["flag"])


static func show_tutorial(tutorial_id: String, parent: Node) -> TutorialOverlay:
	var data: Dictionary = TUTORIALS.get(tutorial_id, {})
	if data.is_empty():
		return null
	GameState.set_flag(data["flag"])
	var overlay := TutorialOverlay.create(data["title"], data["body"])
	parent.add_child(overlay)
	return overlay
