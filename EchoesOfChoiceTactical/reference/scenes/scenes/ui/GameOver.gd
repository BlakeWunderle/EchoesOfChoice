extends Control

@onready var load_button: Button = $Panel/MarginContainer/VBox/Buttons/LoadButton
@onready var title_button: Button = $Panel/MarginContainer/VBox/Buttons/TitleButton
@onready var credits_button: Button = $Panel/MarginContainer/VBox/Buttons/CreditsButton


func _ready() -> void:
	MusicManager.play_music("res://assets/audio/music/game_over/Sad Despair 03.wav", 0.5)
	SFXManager.play(SFXManager.Category.UI_FANFARE, 0.6)
	load_button.pressed.connect(_on_load)
	title_button.pressed.connect(_on_title)
	credits_button.pressed.connect(_on_credits)

	var slot := GameState.current_slot
	load_button.visible = slot >= 0 and GameState.has_save(slot)

	# Add Retry Battle button if we have autosave and a valid battle
	if GameState.has_autosave() and not GameState.current_battle_id.is_empty():
		var retry_btn := Button.new()
		retry_btn.text = "Retry Battle"
		retry_btn.pressed.connect(_on_retry)
		var buttons_container: Node = load_button.get_parent()
		buttons_container.add_child(retry_btn)
		buttons_container.move_child(retry_btn, 0)


func _on_load() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	SceneManager.load_game_slot(GameState.current_slot)


func _on_title() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	SceneManager.go_to_title_screen()


func _on_retry() -> void:
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	SceneManager.retry_battle()


func _on_credits() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	SceneManager.go_to_credits()
