extends Control


func _ready() -> void:
	MusicManager.play_context(MusicManager.MusicContext.GAME_OVER)


func _on_retry() -> void:
	if GameState.current_battle_id != "":
		SceneManager.go_to_battle()
	else:
		SceneManager.go_to_title_screen()


func _on_title() -> void:
	SceneManager.go_to_title_screen()
