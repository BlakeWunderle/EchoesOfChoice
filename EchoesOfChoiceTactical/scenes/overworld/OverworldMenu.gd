extends Control

signal menu_closed

enum _State { MAIN, SAVE_SLOTS, LOAD_SLOTS, CONFIRM_OVERWRITE }

var _state: _State = _State.MAIN
var _pending_slot: int = -1
var _sub_menu_open: bool = false

var _main_panel: VBoxContainer
var _slot_panel: VBoxContainer
var _confirm_panel: VBoxContainer
var _slot_buttons: Array[Button] = []
var _status_label: Label


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.0, 0.0, 0.0, 0.6)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -180.0
	panel.offset_top = -200.0
	panel.offset_right = 180.0
	panel.offset_bottom = 200.0
	add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 16)
	panel.add_child(margin)

	var root_vbox := VBoxContainer.new()
	root_vbox.add_theme_constant_override("separation", 10)
	margin.add_child(root_vbox)

	var title := Label.new()
	title.text = "MENU"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	root_vbox.add_child(title)

	var sep := HSeparator.new()
	root_vbox.add_child(sep)

	_status_label = Label.new()
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_label.add_theme_font_size_override("font_size", 14)
	_status_label.add_theme_color_override("font_color", Color(0.3, 0.9, 0.3))
	_status_label.visible = false
	root_vbox.add_child(_status_label)

	_build_main_panel(root_vbox)
	_build_slot_panel(root_vbox)
	_build_confirm_panel(root_vbox)


func _build_main_panel(parent: VBoxContainer) -> void:
	_main_panel = VBoxContainer.new()
	_main_panel.add_theme_constant_override("separation", 8)
	parent.add_child(_main_panel)

	var save_btn := _make_button("Save Game")
	save_btn.pressed.connect(_on_save)
	_main_panel.add_child(save_btn)

	var load_btn := _make_button("Load Game")
	load_btn.pressed.connect(_on_load)
	_main_panel.add_child(load_btn)

	var items_btn := _make_button("Items")
	items_btn.pressed.connect(_on_items)
	_main_panel.add_child(items_btn)

	var settings_btn := _make_button("Settings")
	settings_btn.pressed.connect(_on_settings)
	_main_panel.add_child(settings_btn)

	var sep := HSeparator.new()
	_main_panel.add_child(sep)

	var title_btn := _make_button("Return to Title")
	title_btn.pressed.connect(_on_quit_title)
	_main_panel.add_child(title_btn)

	var close_btn := _make_button("Close")
	close_btn.pressed.connect(_on_close)
	_main_panel.add_child(close_btn)

	save_btn.grab_focus()


func _build_slot_panel(parent: VBoxContainer) -> void:
	_slot_panel = VBoxContainer.new()
	_slot_panel.add_theme_constant_override("separation", 8)
	_slot_panel.visible = false
	parent.add_child(_slot_panel)

	for i in GameState.MAX_SAVE_SLOTS:
		var btn := _make_button("")
		btn.custom_minimum_size = Vector2(300, 50)
		var idx := i
		btn.pressed.connect(func() -> void: _on_slot_pressed(idx))
		_slot_panel.add_child(btn)
		_slot_buttons.append(btn)

	var back_btn := _make_button("Back")
	back_btn.pressed.connect(_show_main)
	_slot_panel.add_child(back_btn)


func _build_confirm_panel(parent: VBoxContainer) -> void:
	_confirm_panel = VBoxContainer.new()
	_confirm_panel.add_theme_constant_override("separation", 12)
	_confirm_panel.alignment = BoxContainer.ALIGNMENT_CENTER
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

	var yes_btn := _make_button("Overwrite")
	yes_btn.custom_minimum_size = Vector2(120, 36)
	yes_btn.pressed.connect(_on_overwrite_confirmed)
	hbox.add_child(yes_btn)

	var no_btn := _make_button("Cancel")
	no_btn.custom_minimum_size = Vector2(120, 36)
	no_btn.pressed.connect(_on_overwrite_cancelled)
	hbox.add_child(no_btn)


# --- Panel transitions ---

func _show_main() -> void:
	_state = _State.MAIN
	_slot_panel.visible = false
	_confirm_panel.visible = false
	_main_panel.visible = true
	_main_panel.get_child(0).grab_focus()


func _show_slots(mode: _State) -> void:
	_state = mode
	_main_panel.visible = false
	_confirm_panel.visible = false
	_status_label.visible = false

	var is_load := (mode == _State.LOAD_SLOTS)
	var first_enabled: Button = null

	for i in GameState.MAX_SAVE_SLOTS:
		var summary := GameState.get_save_summary(i)
		var btn: Button = _slot_buttons[i]
		if summary["exists"]:
			var stage: int = summary["progression_stage"]
			var gp: int = summary["gold"]
			btn.text = "Slot %d  —  %s  (Stage %d, %dG)" % [
				i + 1, summary["player_name"], stage, gp
			]
			btn.disabled = false
			btn.modulate.a = 1.0
		else:
			btn.text = "Slot %d  —  Empty" % (i + 1)
			btn.disabled = is_load
			btn.modulate.a = 0.5 if is_load else 1.0

		if not btn.disabled and first_enabled == null:
			first_enabled = btn

	_slot_panel.visible = true
	if first_enabled:
		first_enabled.grab_focus()


func _show_confirm(slot: int) -> void:
	_state = _State.CONFIRM_OVERWRITE
	_pending_slot = slot
	_slot_panel.visible = false

	var lbl: Label = _confirm_panel.get_node("ConfirmLabel")
	var summary := GameState.get_save_summary(slot)
	lbl.text = "Overwrite Slot %d?\n%s — Stage %d" % [
		slot + 1, summary["player_name"], int(summary["progression_stage"])
	]

	_confirm_panel.visible = true
	_confirm_panel.get_child(1).get_child(0).grab_focus()


# --- Button callbacks ---

func _on_save() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_show_slots(_State.SAVE_SLOTS)


func _on_load() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_show_slots(_State.LOAD_SLOTS)


func _on_items() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_sub_menu_open = true
	var items_ui: Control = preload("res://scenes/ui/ItemsUI.tscn").instantiate()
	add_child(items_ui)
	items_ui.items_closed.connect(func() -> void:
		items_ui.queue_free()
		_sub_menu_open = false
	)


func _on_settings() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_sub_menu_open = true
	var settings_ui: Control = preload("res://scenes/ui/SettingsMenu.tscn").instantiate()
	add_child(settings_ui)
	settings_ui.settings_closed.connect(func() -> void:
		settings_ui.queue_free()
		_sub_menu_open = false
	)


func _on_quit_title() -> void:
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	SceneManager.go_to_title_screen()


func _on_close() -> void:
	SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
	menu_closed.emit()


func _on_slot_pressed(slot: int) -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	if _state == _State.SAVE_SLOTS:
		if GameState.has_save(slot):
			_show_confirm(slot)
		else:
			_do_save(slot)
	elif _state == _State.LOAD_SLOTS:
		SceneManager.load_game_slot(slot)


func _on_overwrite_confirmed() -> void:
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	_do_save(_pending_slot)


func _on_overwrite_cancelled() -> void:
	SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
	_show_slots(_State.SAVE_SLOTS)


func _do_save(slot: int) -> void:
	GameState.current_slot = slot
	GameState.save_game()
	_show_main()
	_status_label.text = "Game Saved!"
	_status_label.visible = true
	_status_label.modulate.a = 1.0
	var tw := create_tween()
	tw.tween_interval(1.5)
	tw.tween_property(_status_label, "modulate:a", 0.0, 0.5)
	tw.tween_callback(func() -> void: _status_label.visible = false)


# --- Input ---

func _unhandled_input(event: InputEvent) -> void:
	if _sub_menu_open:
		return
	if event.is_action_pressed("cancel") or event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		match _state:
			_State.MAIN:
				_on_close()
			_State.SAVE_SLOTS, _State.LOAD_SLOTS:
				_show_main()
			_State.CONFIRM_OVERWRITE:
				_on_overwrite_cancelled()


func _make_button(label: String) -> Button:
	var btn := Button.new()
	btn.text = label
	btn.custom_minimum_size = Vector2(240, 36)
	btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	return btn
