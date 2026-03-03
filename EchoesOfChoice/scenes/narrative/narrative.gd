extends Control

## Generic narrative scene for pre-battle, post-battle, and ending text.
## Reads GameState to determine which text to show and where to go next.
## After post-battle text, handles branch choices and town stop transitions.

const DialoguePanel := preload("res://scripts/ui/dialogue_panel.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")

var _dialogue: DialoguePanel
var _choice_menu: ChoiceMenu


func _ready() -> void:
	_build_ui()
	_show_narrative()


func _build_ui() -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 80)
	margin.add_theme_constant_override("margin_right", 80)
	margin.add_theme_constant_override("margin_top", 60)
	margin.add_theme_constant_override("margin_bottom", 60)
	add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(vbox)

	_dialogue = DialoguePanel.new()
	_dialogue.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_dialogue.all_text_finished.connect(_on_text_finished)
	vbox.add_child(_dialogue)

	_choice_menu = ChoiceMenu.new()
	_choice_menu.visible = false
	_choice_menu.choice_selected.connect(_on_branch_selected)
	vbox.add_child(_choice_menu)


func _show_narrative() -> void:
	match GameState.game_phase:
		GameState.GamePhase.NARRATIVE:
			MusicManager.play_context(MusicManager.MusicContext.CUTSCENE)
			if GameState.narrative_mode == GameState.NarrativeMode.PRE_BATTLE:
				_dialogue.show_text(GameState.current_battle.pre_battle_text)
			else:
				_dialogue.show_text(GameState.current_battle.post_battle_text)
		GameState.GamePhase.ENDING:
			_show_ending()


func _show_ending() -> void:
	if GameState.game_won:
		MusicManager.play_music("res://assets/audio/music/victory/SHORT Action #5 LOOP.wav")
	else:
		MusicManager.play_music("res://assets/audio/music/game_over/Sad Despair 03.wav")
	var lines: Array[String]
	if GameState.game_won:
		lines = [
			"The stranger is gone and with them, the shadow that covered the land.",
			"The sky clears. The city stirs. People emerge from hiding.",
			"It will take time, but the world will heal.",
			"Our heroes stand in the light, bruised and exhausted and alive.",
			"Every choice left an echo, and theirs will ring through the ages.",
			"",
			"Thank you for playing Echoes of Choice.",
		]
	else:
		lines = [
			"Our heroes fall and the darkness grows a little stronger.",
			"This journey may be over, but every great story deserves another telling.",
		]
	_dialogue.show_text(lines)


func _on_text_finished() -> void:
	match GameState.game_phase:
		GameState.GamePhase.NARRATIVE:
			if GameState.narrative_mode == GameState.NarrativeMode.PRE_BATTLE:
				if GameState.current_battle.enemies.is_empty():
					# No enemies, skip battle, go straight to post-battle text
					GameState.narrative_mode = GameState.NarrativeMode.POST_BATTLE
					_show_narrative()
				else:
					# Go to battle
					GameState.game_phase = GameState.GamePhase.BATTLE
					SceneManager.change_scene("res://scenes/battle/battle.tscn")
			else:
				# Post-battle: level up first
				GameState.level_up_party()
				# Check for branch choices
				if not GameState.current_battle.choices.is_empty():
					_show_branch_choices()
				else:
					_advance_after_battle()
		GameState.GamePhase.ENDING:
			# Return to title
			SceneManager.change_scene("res://scenes/title/title.tscn")


func _show_branch_choices() -> void:
	_dialogue.visible = false
	var options: Array[Dictionary] = []
	for choice: Dictionary in GameState.current_battle.choices:
		options.append({"label": choice["label"]})
	_choice_menu.show_choices(options)


func _on_branch_selected(index: int) -> void:
	_choice_menu.hide_menu()
	var battle_id: String = GameState.current_battle.choices[index]["battle_id"]
	GameState.advance_with_choice(battle_id)
	match GameState.game_phase:
		GameState.GamePhase.TOWN_STOP:
			SceneManager.change_scene("res://scenes/town_stop/town_stop.tscn")
		GameState.GamePhase.ENDING:
			GameState.game_won = true
			_dialogue.visible = true
			_show_ending()
		_:
			_dialogue.visible = true
			_show_narrative()


func _advance_after_battle() -> void:
	SaveManager.auto_save()
	GameState.advance_to_next_battle()
	match GameState.game_phase:
		GameState.GamePhase.ENDING:
			GameState.game_won = true
			_show_ending()
		GameState.GamePhase.TOWN_STOP:
			SceneManager.change_scene("res://scenes/town_stop/town_stop.tscn")
		_:
			_show_narrative()
