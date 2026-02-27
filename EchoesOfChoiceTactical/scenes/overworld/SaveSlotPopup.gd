extends Control

signal popup_closed

enum _Mode { SAVE, LOAD }
enum _State { SLOTS, CONFIRM }

var _mode: _Mode
var _state: _State = _State.SLOTS
var _pending_slot: int = -1
var _slot_buttons: Array[Button] = []
var _slot_panel: VBoxContainer
var _confirm_panel: VBoxContainer
var _status_label: Label


func open_save() -> void:
	_mode = _Mode.SAVE
	_build_ui("Save Game")


func open_load() -> void:
	_mode = _Mode.LOAD
	_build_ui("Load Game")


func _build_ui(title_text: String) -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.0, 0.0, 0.0, 0.6)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -180.0
	panel.offset_top = -150.0
	panel.offset_right = 180.0
	panel.offset_bottom = 150.0
	add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 16)
	panel.add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 10)
	margin.add_child(root)

	var title := Label.new()
	title.text = title_text
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	root.add_child(title)

	var sep := HSeparator.new()
	root.add_child(sep)

	_status_label = Label.new()
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_label.add_theme_font_size_override("font_size", 14)
	_status_label.add_theme_color_override("font_color", Color(0.3, 0.9, 0.3))
	_status_label.visible = false
	root.add_child(_status_label)

	_build_slot_panel(root)
	_build_confirm_panel(root)
	_refresh_slots()


func _build_slot_panel(parent: VBoxContainer) -> void:
	_slot_panel = VBoxContainer.new()
	_slot_panel.add_theme_constant_override("separation", 8)
	parent.add_child(_slot_panel)

	for i in GameState.MAX_SAVE_SLOTS:
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(300, 50)
		btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		var idx := i
		btn.pressed.connect(func() -> void: _on_slot_pressed(idx))
		_slot_panel.add_child(btn)
		_slot_buttons.append(btn)

	var back_btn := Button.new()
	back_btn.text = "Back"
	back_btn.custom_minimum_size = Vector2(240, 36)
	back_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	back_btn.pressed.connect(_on_back)
	_slot_panel.add_child(back_btn)


func _build_confirm_panel(parent: VBoxContainer) -> void:
	_confirm_panel = VBoxContainer.new()
	_confirm_panel.add_theme_constant_override("separation", 12)
	_confirm_panel.visible = false
	parent.add_child(_confirm_panel)

	var lbl := Label.new()
	lbl.name = "ConfirmLabel"
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_confirm_panel.add_child(lbl)

	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 24)
	_confirm_panel.add_child(hbox)

	var yes_btn := Button.new()
	yes_btn.text = "Overwrite"
	yes_btn.custom_minimum_size = Vector2(120, 36)
	yes_btn.pressed.connect(_on_overwrite_confirmed)
	hbox.add_child(yes_btn)

	var no_btn := Button.new()
	no_btn.text = "Cancel"
	no_btn.custom_minimum_size = Vector2(120, 36)
	no_btn.pressed.connect(_on_overwrite_cancelled)
	hbox.add_child(no_btn)


func _refresh_slots() -> void:
	_state = _State.SLOTS
	_confirm_panel.visible = false
	_slot_panel.visible = true

	var is_load := (_mode == _Mode.LOAD)
	var first_enabled: Button = null

	for i in GameState.MAX_SAVE_SLOTS:
		var summary := GameState.get_save_summary(i)
		var btn: Button = _slot_buttons[i]
		if summary["exists"]:
			btn.text = "Slot %d  —  %s  (Stage %d, %dG)" % [
				i + 1, summary["player_name"],
				int(summary["progression_stage"]), int(summary["gold"])
			]
			btn.disabled = false
			btn.modulate.a = 1.0
		else:
			btn.text = "Slot %d  —  Empty" % (i + 1)
			btn.disabled = is_load
			btn.modulate.a = 0.5 if is_load else 1.0

		if not btn.disabled and first_enabled == null:
			first_enabled = btn

	if first_enabled:
		first_enabled.grab_focus()


func _on_slot_pressed(slot: int) -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	if _mode == _Mode.SAVE:
		if GameState.has_save(slot):
			_show_confirm(slot)
		else:
			_do_save(slot)
	else:
		SceneManager.load_game_slot(slot)


func _show_confirm(slot: int) -> void:
	_state = _State.CONFIRM
	_pending_slot = slot
	_slot_panel.visible = false

	var lbl: Label = _confirm_panel.get_node("ConfirmLabel")
	var summary := GameState.get_save_summary(slot)
	lbl.text = "Overwrite Slot %d?\n%s — Stage %d" % [
		slot + 1, summary["player_name"], int(summary["progression_stage"])
	]

	_confirm_panel.visible = true
	_confirm_panel.get_child(1).get_child(0).grab_focus()


func _on_overwrite_confirmed() -> void:
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	_do_save(_pending_slot)


func _on_overwrite_cancelled() -> void:
	SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
	_refresh_slots()


func _do_save(slot: int) -> void:
	GameState.current_slot = slot
	GameState.save_game()
	_status_label.text = "Game Saved!"
	_status_label.visible = true
	_status_label.modulate.a = 1.0
	_refresh_slots()
	var tw := create_tween()
	tw.tween_interval(1.5)
	tw.tween_property(_status_label, "modulate:a", 0.0, 0.5)
	tw.tween_callback(func() -> void: _status_label.visible = false)


func _on_back() -> void:
	SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
	popup_closed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		match _state:
			_State.SLOTS:
				_on_back()
			_State.CONFIRM:
				_on_overwrite_cancelled()
