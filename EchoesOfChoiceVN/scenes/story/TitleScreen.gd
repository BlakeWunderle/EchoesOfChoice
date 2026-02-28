extends Control


func _ready() -> void:
	MusicManager.play_context(MusicManager.MusicContext.MENU)

	var has_save := GameState.has_any_save() or GameState.has_autosave()
	%ContinueButton.visible = has_save
	%LoadButton.visible = has_save

	%NewGameButton.pressed.connect(_on_new_game)
	%ContinueButton.pressed.connect(_on_continue)
	%LoadButton.pressed.connect(_on_load)
	%QuitButton.pressed.connect(_on_quit)

	%NewGameButton.grab_focus()


func _on_new_game() -> void:
	# For now, use slot 0
	SceneManager.start_new_game(0)


func _on_continue() -> void:
	SceneManager.continue_game()


func _on_load() -> void:
	# TODO: Show slot selection UI
	var slot := GameState.get_last_used_slot()
	if slot >= 0:
		SceneManager.load_game_slot(slot)


func _on_quit() -> void:
	get_tree().quit()
