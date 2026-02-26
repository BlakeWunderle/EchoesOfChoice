extends Control

signal resumed
signal quit_to_overworld
signal quit_to_title
signal settings_requested

var _settings_open: bool = false


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	# Dark backdrop
	var bg := ColorRect.new()
	bg.color = Color(0.0, 0.0, 0.0, 0.6)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# Center panel
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -160.0
	panel.offset_top = -130.0
	panel.offset_right = 160.0
	panel.offset_bottom = 130.0
	add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 16)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)

	# Title
	var title := Label.new()
	title.text = "PAUSED"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	vbox.add_child(title)

	var sep := HSeparator.new()
	vbox.add_child(sep)

	# Buttons
	var resume_btn := _make_button("Resume")
	resume_btn.pressed.connect(_on_resume)
	vbox.add_child(resume_btn)

	var settings_btn := _make_button("Settings")
	settings_btn.pressed.connect(_on_settings)
	vbox.add_child(settings_btn)

	var overworld_btn := _make_button("Quit to Overworld")
	overworld_btn.pressed.connect(_on_quit_overworld)
	vbox.add_child(overworld_btn)

	var title_btn := _make_button("Quit to Title")
	title_btn.pressed.connect(_on_quit_title)
	vbox.add_child(title_btn)

	resume_btn.grab_focus()


func _make_button(text: String) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(200, 36)
	btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	return btn


func _on_resume() -> void:
	SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
	resumed.emit()


func _on_settings() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	settings_requested.emit()


func _on_quit_overworld() -> void:
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	quit_to_overworld.emit()


func _on_quit_title() -> void:
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	quit_to_title.emit()


func _unhandled_input(event: InputEvent) -> void:
	if _settings_open:
		return
	if event.is_action_pressed("cancel") or event.is_action_pressed("pause"):
		_on_resume()
		get_viewport().set_input_as_handled()
