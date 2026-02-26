extends CanvasLayer

signal transition_finished

var _fader: ColorRect


func _ready() -> void:
	layer = 100
	_fader = ColorRect.new()
	_fader.color = Color.BLACK
	_fader.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fader.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fader.modulate.a = 0.0
	add_child(_fader)


func change_scene(path: String, fade_duration: float = 0.4) -> void:
	_fader.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween := create_tween()
	tween.tween_property(_fader, "modulate:a", 1.0, fade_duration)
	await tween.finished
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	var tween_out := create_tween()
	tween_out.tween_property(_fader, "modulate:a", 0.0, fade_duration)
	await tween_out.finished
	_fader.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition_finished.emit()


func start_new_game(slot: int) -> void:
	GameState.current_slot = slot
	GameState.reset_for_new_game()
	change_scene("res://scenes/story/CharacterCreation.tscn")


func load_game_slot(slot: int) -> void:
	if GameState.load_game(slot):
		change_scene("res://scenes/overworld/OverworldMap.tscn")


func continue_game() -> void:
	if GameState.has_autosave():
		load_game_slot(GameState.AUTOSAVE_SLOT)
		return
	# Fallback to last-used manual slot for old saves
	var slot := GameState.get_last_used_slot()
	if slot >= 0:
		load_game_slot(slot)


func go_to_tutorial_battle() -> void:
	GameState.current_battle_id = "tutorial"
	change_scene("res://scenes/battle/BattleMap.tscn")


func go_to_class_selection() -> void:
	change_scene("res://scenes/story/ClassSelection.tscn")


func go_to_throne_room() -> void:
	change_scene("res://scenes/story/ThroneRoom.tscn")


func go_to_barracks() -> void:
	change_scene("res://scenes/story/Barracks.tscn")


func go_to_title_screen() -> void:
	change_scene("res://scenes/story/TitleScreen.tscn")


func go_to_overworld() -> void:
	change_scene("res://scenes/overworld/OverworldMap.tscn")


func go_to_town(town_node_id: String) -> void:
	GameState.current_town_id = town_node_id
	change_scene("res://scenes/town/Town.tscn")


func go_to_party_select() -> void:
	change_scene("res://scenes/battle/PartySelect.tscn")


func go_to_game_over() -> void:
	change_scene("res://scenes/ui/GameOver.tscn")


func go_to_credits() -> void:
	change_scene("res://scenes/story/Credits.tscn")


func retry_battle() -> void:
	if GameState.has_autosave():
		var data: Dictionary = GameState._save_manager.load_from_slot(GameState.AUTOSAVE_SLOT)
		if not data.is_empty():
			var battle_id := GameState.current_battle_id
			GameState.load_game(GameState.AUTOSAVE_SLOT)
			GameState.current_battle_id = battle_id
			go_to_party_select()
			return
	go_to_overworld()
