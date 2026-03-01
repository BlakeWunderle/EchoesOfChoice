extends Control

## Generic narrative scene for pre-battle, post-battle, and ending text.
## Reads GameState to determine which text to show and where to go next.

const DialoguePanel := preload("res://scripts/ui/dialogue_panel.gd")

var _dialogue: DialoguePanel


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

	_dialogue = DialoguePanel.new()
	_dialogue.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_dialogue.all_text_finished.connect(_on_text_finished)
	margin.add_child(_dialogue)


func _show_narrative() -> void:
	match GameState.game_phase:
		GameState.GamePhase.NARRATIVE:
			if GameState.narrative_mode == GameState.NarrativeMode.PRE_BATTLE:
				_dialogue.show_text(GameState.current_battle.pre_battle_text)
			else:
				_dialogue.show_text(GameState.current_battle.post_battle_text)
		GameState.GamePhase.ENDING:
			_show_ending()


func _show_ending() -> void:
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
				# Go to battle
				GameState.game_phase = GameState.GamePhase.BATTLE
				SceneManager.change_scene("res://scenes/battle/battle.tscn")
			else:
				# Post-battle: level up, advance
				GameState.level_up_party()
				GameState.advance_to_next_battle()
				if GameState.game_phase == GameState.GamePhase.ENDING:
					GameState.game_won = true
					_show_ending()
				else:
					# Next battle's pre-narrative
					_show_narrative()
		GameState.GamePhase.ENDING:
			# Return to title
			SceneManager.change_scene("res://scenes/title/title.tscn")
