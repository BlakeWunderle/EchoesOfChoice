extends Control

@onready var load_button: Button = $Panel/MarginContainer/VBox/Buttons/LoadButton
@onready var title_button: Button = $Panel/MarginContainer/VBox/Buttons/TitleButton


func _ready() -> void:
	MusicManager.stop_music(0.5)
	load_button.pressed.connect(_on_load)
	title_button.pressed.connect(_on_title)

	var slot := GameState.current_slot
	load_button.visible = slot >= 0 and GameState.has_save(slot)


func _on_load() -> void:
	SceneManager.load_game_slot(GameState.current_slot)


func _on_title() -> void:
	SceneManager.go_to_title_screen()
