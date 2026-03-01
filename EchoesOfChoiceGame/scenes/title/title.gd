extends Control

## Title screen with animated reveal and menu.

const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")

var _title_label: Label
var _subtitle_label: Label
var _menu: VBoxContainer  ## ChoiceMenu instance
var _vbox: VBoxContainer


func _ready() -> void:
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
	_subtitle_label.text = "Every choice leaves an echo..."
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
	_show_menu()


func _show_menu() -> void:
	_menu.show_choices([
		{"label": "New Game"},
		{"label": "Quit"},
	])
	var t := create_tween()
	t.tween_property(_menu, "modulate:a", 1.0, 0.4)


func _on_menu_choice(index: int) -> void:
	match index:
		0:  # New Game
			GameState.start_new_game()
			SceneManager.change_scene("res://scenes/party_creation/party_creation.tscn")
		1:  # Quit
			get_tree().quit()
