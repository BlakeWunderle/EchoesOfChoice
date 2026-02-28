extends Control

signal settings_closed

var _fullscreen_check: CheckBox
var _master_slider: HSlider
var _music_slider: HSlider
var _sfx_slider: HSlider
var _text_speed_slider: HSlider


func _ready() -> void:
	_build_ui()
	_load_current_values()


func _build_ui() -> void:
	# Dark backdrop
	var bg := ColorRect.new()
	bg.color = Color(0.0, 0.0, 0.0, 0.7)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# Center panel
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -200.0
	panel.offset_top = -210.0
	panel.offset_right = 200.0
	panel.offset_bottom = 180.0
	add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 16)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	margin.add_child(vbox)

	# Title
	var title := Label.new()
	title.text = "Settings"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	vbox.add_child(title)

	var sep := HSeparator.new()
	vbox.add_child(sep)

	# Fullscreen toggle
	_fullscreen_check = CheckBox.new()
	_fullscreen_check.text = "Fullscreen"
	_fullscreen_check.add_theme_font_size_override("font_size", 14)
	_fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	vbox.add_child(_fullscreen_check)

	var sep_fs := HSeparator.new()
	vbox.add_child(sep_fs)

	# Volume sliders
	_master_slider = _add_slider_row(vbox, "Master Volume", 0.0, 1.0, 0.05)
	_music_slider = _add_slider_row(vbox, "Music Volume", 0.0, 1.0, 0.05)
	_sfx_slider = _add_slider_row(vbox, "SFX Volume", 0.0, 1.0, 0.05)

	var sep2 := HSeparator.new()
	vbox.add_child(sep2)

	# Text speed slider
	_text_speed_slider = _add_slider_row(vbox, "Text Speed", 0.5, 3.0, 0.25)

	# Close button
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 8)
	vbox.add_child(spacer)

	var close_btn := Button.new()
	close_btn.text = "Close"
	close_btn.custom_minimum_size = Vector2(120, 36)
	close_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	close_btn.pressed.connect(_on_close)
	vbox.add_child(close_btn)

	# Connect slider changes
	_master_slider.value_changed.connect(_on_master_changed)
	_music_slider.value_changed.connect(_on_music_changed)
	_sfx_slider.value_changed.connect(_on_sfx_changed)
	_text_speed_slider.value_changed.connect(_on_text_speed_changed)


func _add_slider_row(parent: VBoxContainer, label_text: String, min_val: float, max_val: float, step_val: float) -> HSlider:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	parent.add_child(row)

	var lbl := Label.new()
	lbl.text = label_text
	lbl.custom_minimum_size = Vector2(130, 0)
	lbl.add_theme_font_size_override("font_size", 14)
	row.add_child(lbl)

	var slider := HSlider.new()
	slider.min_value = min_val
	slider.max_value = max_val
	slider.step = step_val
	slider.custom_minimum_size = Vector2(160, 20)
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(slider)

	var val_label := Label.new()
	val_label.custom_minimum_size = Vector2(40, 0)
	val_label.add_theme_font_size_override("font_size", 12)
	val_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(val_label)

	slider.value_changed.connect(func(val: float) -> void: val_label.text = "%d%%" % int(val * 100) if max_val <= 1.0 else "%.1fx" % val)
	return slider


func _load_current_values() -> void:
	_fullscreen_check.button_pressed = GameState.settings.get("fullscreen", true)
	_master_slider.value = GameState.settings.get("master_volume", 1.0)
	_music_slider.value = GameState.settings.get("music_volume", 0.8)
	_sfx_slider.value = GameState.settings.get("sfx_volume", 1.0)
	_text_speed_slider.value = GameState.settings.get("text_speed", 1.0)


func _on_fullscreen_toggled(enabled: bool) -> void:
	GameState.settings["fullscreen"] = enabled
	GameState.apply_settings()


func _on_master_changed(val: float) -> void:
	GameState.settings["master_volume"] = val
	GameState.apply_settings()


func _on_music_changed(val: float) -> void:
	GameState.settings["music_volume"] = val
	GameState.apply_settings()


func _on_sfx_changed(val: float) -> void:
	GameState.settings["sfx_volume"] = val
	GameState.apply_settings()
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)


func _on_text_speed_changed(val: float) -> void:
	GameState.settings["text_speed"] = val


func _on_close() -> void:
	SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
	GameState.save_settings()
	settings_closed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		_on_close()
		get_viewport().set_input_as_handled()
