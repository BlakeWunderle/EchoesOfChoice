extends Control

@onready var load_button: Button = $Panel/MarginContainer/VBox/Buttons/LoadButton
@onready var title_button: Button = $Panel/MarginContainer/VBox/Buttons/TitleButton


func _ready() -> void:
	load_button.pressed.connect(_on_load)
	title_button.pressed.connect(_on_title)

	load_button.visible = GameState.has_save()


func _on_load() -> void:
	if GameState.load_game():
		SceneManager.go_to_overworld()


func _on_title() -> void:
	SceneManager.go_to_title_screen()
