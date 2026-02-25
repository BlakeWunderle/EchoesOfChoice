extends Control

@onready var load_button: Button = $Panel/MarginContainer/VBox/Buttons/LoadButton
@onready var title_button: Button = $Panel/MarginContainer/VBox/Buttons/TitleButton
@onready var credits_button: Button = $Panel/MarginContainer/VBox/Buttons/CreditsButton


func _ready() -> void:
	MusicManager.stop_music(0.5)
	load_button.pressed.connect(_on_load)
	title_button.pressed.connect(_on_title)
	credits_button.pressed.connect(_on_credits)

	var slot := GameState.current_slot
	load_button.visible = slot >= 0 and GameState.has_save(slot)


func _on_load() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	SceneManager.load_game_slot(GameState.current_slot)


func _on_title() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	SceneManager.go_to_title_screen()


func _on_credits() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	SceneManager.go_to_credits()
