extends Control

enum _MenuState { ANIMATING, MAIN_MENU, SLOT_PICKER_NEW, SLOT_PICKER_LOAD, CONFIRM_OVERWRITE }

@onready var _title_label: Label = $CenterContainer/VBoxContainer/TitleLabel
@onready var _subtitle_label: Label = $CenterContainer/VBoxContainer/SubtitleLabel

var _state: _MenuState = _MenuState.ANIMATING
var _pending_slot: int = -1

# Dynamically built nodes
var _menu_panel: VBoxContainer
var _slot_panel: VBoxContainer
var _confirm_panel: VBoxContainer

var _new_game_btn: Button
var _continue_btn: Button
var _load_btn: Button
var _slot_buttons: Array[Button] = []


func _ready() -> void:
	MusicManager.play_context(MusicManager.MusicContext.MENU)
	_title_label.modulate.a = 0.0
	_subtitle_label.modulate.a = 0.0
	_build_ui()
	_play_reveal()


func _build_ui() -> void:
	_build_main_menu()
	_build_slot_panel()
	_build_confirm_panel()


func _build_main_menu() -> void:
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_CENTER)
	center.offset_top = 80
	add_child(center)

	_menu_panel = VBoxContainer.new()
	_menu_panel.add_theme_constant_override("separation", 16)
	_menu_panel.modulate.a = 0.0
	_menu_panel.visible = false
	center.add_child(_menu_panel)

	_new_game_btn = _make_button("New Game")
	_new_game_btn.pressed.connect(_on_new_game_pressed)
	_menu_panel.add_child(_new_game_btn)

	_continue_btn = _make_button("Continue")
	_continue_btn.pressed.connect(_on_continue_pressed)
	_menu_panel.add_child(_continue_btn)

	_load_btn = _make_button("Load")
	_load_btn.pressed.connect(_on_load_pressed)
	_menu_panel.add_child(_load_btn)

	var quit_btn := _make_button("Quit")
	quit_btn.pressed.connect(func() -> void: get_tree().quit())
	_menu_panel.add_child(quit_btn)

	_wire_focus([_new_game_btn, _continue_btn, _load_btn, quit_btn])


func _build_slot_panel() -> void:
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_CENTER)
	center.offset_top = 60
	add_child(center)

	_slot_panel = VBoxContainer.new()
	_slot_panel.add_theme_constant_override("separation", 14)
	_slot_panel.visible = false
	center.add_child(_slot_panel)

	for i in GameState.MAX_SAVE_SLOTS:
		var btn := _make_button("")
		btn.custom_minimum_size = Vector2(340, 56)
		var idx := i
		btn.pressed.connect(func() -> void: _on_slot_pressed(idx))
		_slot_panel.add_child(btn)
		_slot_buttons.append(btn)

	var back_btn := _make_button("Back")
	back_btn.pressed.connect(_show_main_menu)
	_slot_panel.add_child(back_btn)

	_wire_focus(_slot_buttons + [back_btn])


func _build_confirm_panel() -> void:
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_CENTER)
	center.offset_top = 20
	add_child(center)

	_confirm_panel = VBoxContainer.new()
	_confirm_panel.add_theme_constant_override("separation", 16)
	_confirm_panel.visible = false
	center.add_child(_confirm_panel)

	var lbl := Label.new()
	lbl.name = "ConfirmLabel"
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.text = "Overwrite this save?"
	_confirm_panel.add_child(lbl)

	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 24)
	_confirm_panel.add_child(hbox)

	var yes_btn := _make_button("Yes")
	yes_btn.pressed.connect(_on_overwrite_confirmed)
	hbox.add_child(yes_btn)

	var no_btn := _make_button("No")
	no_btn.pressed.connect(_on_overwrite_cancelled)
	hbox.add_child(no_btn)

	_wire_focus([yes_btn, no_btn])


# --- Animation ---

func _play_reveal() -> void:
	await get_tree().create_timer(0.5).timeout

	var t1 := create_tween()
	t1.tween_property(_title_label, "modulate:a", 1.0, 2.0)
	await t1.finished

	await get_tree().create_timer(0.5).timeout

	var t2 := create_tween()
	t2.tween_property(_subtitle_label, "modulate:a", 1.0, 1.5)
	await t2.finished

	await get_tree().create_timer(0.8).timeout
	_show_main_menu()


# --- Panel transitions ---

func _show_main_menu() -> void:
	_state = _MenuState.MAIN_MENU
	_slot_panel.visible = false
	_confirm_panel.visible = false

	var has_any := GameState.has_any_save()
	_continue_btn.disabled = not has_any
	_continue_btn.modulate.a = 1.0 if has_any else 0.5
	_load_btn.disabled = not has_any
	_load_btn.modulate.a = 1.0 if has_any else 0.5

	_menu_panel.visible = true
	var t := create_tween()
	t.tween_property(_menu_panel, "modulate:a", 1.0, 0.4)
	await t.finished

	if has_any:
		_continue_btn.grab_focus()
	else:
		_new_game_btn.grab_focus()


func _show_slot_picker(mode: _MenuState) -> void:
	_state = mode
	_menu_panel.visible = false
	_confirm_panel.visible = false

	var is_load := (mode == _MenuState.SLOT_PICKER_LOAD)
	var first_enabled: Button = null

	for i in GameState.MAX_SAVE_SLOTS:
		var summary := GameState.get_save_summary(i)
		var btn: Button = _slot_buttons[i]
		if summary["exists"]:
			var stage: int = summary["progression_stage"]
			var gp: int = summary["gold"]
			btn.text = "Slot %d — %s\nStage %d  |  %dG" % [
				i + 1, summary["player_name"], stage, gp
			]
			btn.disabled = false
			btn.modulate.a = 1.0
		else:
			btn.text = "Slot %d — Empty" % (i + 1)
			btn.disabled = is_load
			btn.modulate.a = 0.5 if is_load else 1.0

		if not btn.disabled and first_enabled == null:
			first_enabled = btn

	_slot_panel.visible = true
	if first_enabled:
		first_enabled.grab_focus()


func _show_confirm(slot: int) -> void:
	_state = _MenuState.CONFIRM_OVERWRITE
	_pending_slot = slot
	_slot_panel.visible = false

	var lbl: Label = _confirm_panel.get_node("ConfirmLabel")
	var summary := GameState.get_save_summary(slot)
	lbl.text = "Slot %d has a save (%s, Stage %d).\nStart a new game here?" % [
		slot + 1, summary["player_name"], int(summary["progression_stage"])
	]

	_confirm_panel.visible = true
	# Focus the Yes button
	_confirm_panel.get_child(1).get_child(0).grab_focus()


# --- Button callbacks ---

func _on_new_game_pressed() -> void:
	_show_slot_picker(_MenuState.SLOT_PICKER_NEW)


func _on_continue_pressed() -> void:
	SceneManager.continue_game()


func _on_load_pressed() -> void:
	_show_slot_picker(_MenuState.SLOT_PICKER_LOAD)


func _on_slot_pressed(slot: int) -> void:
	if _state == _MenuState.SLOT_PICKER_NEW:
		if GameState.has_save(slot):
			_show_confirm(slot)
		else:
			SceneManager.start_new_game(slot)
	elif _state == _MenuState.SLOT_PICKER_LOAD:
		SceneManager.load_game_slot(slot)


func _on_overwrite_confirmed() -> void:
	SceneManager.start_new_game(_pending_slot)


func _on_overwrite_cancelled() -> void:
	_show_slot_picker(_MenuState.SLOT_PICKER_NEW)


# --- Helpers ---

func _make_button(label: String) -> Button:
	var btn := Button.new()
	btn.text = label
	btn.custom_minimum_size = Vector2(220, 48)
	btn.focus_mode = Control.FOCUS_ALL
	return btn


func _wire_focus(buttons: Array) -> void:
	for i in buttons.size():
		var btn: Button = buttons[i]
		var prev: Button = buttons[(i - 1 + buttons.size()) % buttons.size()]
		var next: Button = buttons[(i + 1) % buttons.size()]
		btn.focus_neighbor_top = prev.get_path() if prev.is_inside_tree() else NodePath("")
		btn.focus_neighbor_bottom = next.get_path() if next.is_inside_tree() else NodePath("")


func _input(event: InputEvent) -> void:
	if _state == _MenuState.ANIMATING:
		return
	if event.is_action_pressed("ui_cancel"):
		match _state:
			_MenuState.SLOT_PICKER_NEW, _MenuState.SLOT_PICKER_LOAD:
				_show_main_menu()
			_MenuState.CONFIRM_OVERWRITE:
				_on_overwrite_cancelled()
