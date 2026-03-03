extends Control

## Title screen with animated reveal and menu.
## Shows Continue and Load Game options when saves exist.

const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")

enum Mode { MAIN_MENU, LOAD_SLOTS }

var _title_label: Label
var _subtitle_label: Label
var _menu: ChoiceMenu
var _vbox: VBoxContainer
var _mode: Mode = Mode.MAIN_MENU
var _has_saves: bool = false


func _ready() -> void:
	MusicManager.play_music("res://assets/audio/music/menu/Land of Heroes Alt LOOP.wav")
	_build_ui()
	_play_reveal()


func _build_ui() -> void:
	# Center container
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	_vbox = VBoxContainer.new()
	_vbox.add_theme_constant_override("separation", 16)
	_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(_vbox)

	# Title
	_title_label = Label.new()
	_title_label.text = "ECHOES OF CHOICE"
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.add_theme_font_size_override("font_size", 56)
	_title_label.modulate.a = 0.0
	_vbox.add_child(_title_label)

	# Subtitle
	_subtitle_label = Label.new()
	_subtitle_label.text = "Some paths can't be retraced."
	_subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_subtitle_label.add_theme_font_size_override("font_size", 20)
	_subtitle_label.modulate.a = 0.0
	_vbox.add_child(_subtitle_label)

	# Spacer
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 24)
	_vbox.add_child(spacer)

	# Menu
	_menu = ChoiceMenu.new()
	_menu.modulate.a = 0.0
	_menu.visible = false
	_menu.choice_selected.connect(_on_menu_choice)
	_vbox.add_child(_menu)


func _play_reveal() -> void:
	await get_tree().create_timer(0.3).timeout

	var t1 := create_tween()
	t1.tween_property(_title_label, "modulate:a", 1.0, 1.5)
	await t1.finished

	await get_tree().create_timer(0.3).timeout

	var t2 := create_tween()
	t2.tween_property(_subtitle_label, "modulate:a", 1.0, 1.0)
	await t2.finished

	await get_tree().create_timer(0.5).timeout
	_show_main_menu()


# =============================================================================
# Main menu
# =============================================================================

func _show_main_menu() -> void:
	_mode = Mode.MAIN_MENU
	_has_saves = SaveManager.has_any_save()

	var options: Array[Dictionary] = []
	if _has_saves:
		options.append({"label": "Continue"})
	options.append({"label": "New Game"})
	if _has_saves:
		options.append({"label": "Load Game"})
	options.append({"label": "Quit"})

	_menu.show_choices(options)
	var t := create_tween()
	t.tween_property(_menu, "modulate:a", 1.0, 0.4)


func _on_menu_choice(index: int) -> void:
	match _mode:
		Mode.MAIN_MENU:
			_handle_main_choice(index)
		Mode.LOAD_SLOTS:
			_handle_load_choice(index)


func _handle_main_choice(index: int) -> void:
	var offset: int = 1 if _has_saves else 0

	if _has_saves and index == 0:
		# Continue: load last-used slot, or autosave, or first available
		var slot: int = _find_best_continue_slot()
		if slot >= 0 and SaveManager.load_from_slot(slot):
			SceneManager.change_scene("res://scenes/narrative/narrative.tscn")
		return

	if index == offset:
		# New Game
		GameState.start_new_game()
		SceneManager.change_scene("res://scenes/party_creation/party_creation.tscn")
	elif _has_saves and index == offset + 1:
		# Load Game
		_show_load_slots()
	else:
		# Quit (last option)
		get_tree().quit()


func _find_best_continue_slot() -> int:
	var slot: int = SaveManager.get_last_used_slot()
	if slot >= 0:
		return slot
	if SaveManager.has_autosave():
		return SaveManager.AUTOSAVE_SLOT
	for i: int in SaveManager.MAX_SAVE_SLOTS:
		if SaveManager.has_save(i):
			return i
	return -1


# =============================================================================
# Load slot picker
# =============================================================================

func _show_load_slots() -> void:
	_mode = Mode.LOAD_SLOTS

	var options: Array[Dictionary] = []

	# 3 manual slots
	for i: int in SaveManager.MAX_SAVE_SLOTS:
		var summary: Dictionary = SaveManager.get_save_summary(i)
		if summary.get("exists", false):
			options.append({"label": "Slot %d: %s the %s - Lv %d" % [
				i + 1,
				summary.get("lead_name", "???"),
				summary.get("lead_class", "???"),
				summary.get("level", 1),
			]})
		else:
			options.append({"label": "Slot %d: Empty" % [i + 1], "disabled": true})

	# Autosave slot
	var auto_summary: Dictionary = SaveManager.get_save_summary(SaveManager.AUTOSAVE_SLOT)
	if auto_summary.get("exists", false):
		options.append({"label": "Autosave: %s the %s - Lv %d" % [
			auto_summary.get("lead_name", "???"),
			auto_summary.get("lead_class", "???"),
			auto_summary.get("level", 1),
		]})
	else:
		options.append({"label": "Autosave: Empty", "disabled": true})

	options.append({"label": "Back"})
	_menu.show_choices(options)


func _handle_load_choice(index: int) -> void:
	var total_slots: int = SaveManager.MAX_SAVE_SLOTS + 1  # 3 manual + 1 autosave
	if index >= total_slots:
		# Back
		_show_main_menu()
		return

	# Map index to slot (0-2 = manual, 3 = autosave)
	var slot: int = index
	if index == SaveManager.MAX_SAVE_SLOTS:
		slot = SaveManager.AUTOSAVE_SLOT

	if SaveManager.load_from_slot(slot):
		SceneManager.change_scene("res://scenes/narrative/narrative.tscn")
