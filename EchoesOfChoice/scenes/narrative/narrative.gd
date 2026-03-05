extends Control

## Generic narrative scene for pre-battle, post-battle, and ending text.
## Reads GameState to determine which text to show and where to go next.
## After post-battle text, handles branch choices and town stop transitions.

const DialoguePanel := preload("res://scripts/ui/dialogue_panel.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const _StoryDB := preload("res://scripts/data/story_db.gd")

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
			if not GameState.current_battle.cutscene_track.is_empty():
				MusicManager.play_music(GameState.current_battle.cutscene_track)
			else:
				MusicManager.play_context(MusicManager.MusicContext.CUTSCENE)
			if GameState.narrative_mode == GameState.NarrativeMode.PRE_BATTLE:
				_dialogue.show_text(GameState.current_battle.pre_battle_text)
			else:
				_dialogue.show_text(GameState.current_battle.post_battle_text)
		GameState.GamePhase.ENDING:
			_show_ending()
		_:
			push_error("Narrative: unexpected game_phase %s" % GameState.game_phase)
			_dialogue.show_text(["Something went wrong. Press continue to return to title."])


func _show_ending() -> void:
	var is_first_completion: bool = false
	if GameState.game_won:
		var story: Dictionary = _StoryDB.get_story(GameState.current_story_id)
		var completion_key: String = story.get("completion_unlock", "")
		if not completion_key.is_empty():
			is_first_completion = not UnlockManager.is_unlocked(completion_key)
			UnlockManager.unlock(completion_key)
		MusicManager.play_music("res://assets/audio/music/victory/SHORT Action #5 LOOP.wav")
	else:
		MusicManager.play_music("res://assets/audio/music/game_over/Sad Despair 03.wav")
	var lines: Array[String]
	if GameState.current_story_id == "story_2":
		lines = _ending_text_story_2()
	else:
		lines = _ending_text_story_1()
	if is_first_completion:
		lines.append_array(_unlock_notification_lines())
	_dialogue.show_text(lines)


func _ending_text_story_1() -> Array[String]:
	if GameState.game_won:
		return [
			"The stranger is gone and with them, the shadow that covered the land.",
			"The sky clears. The city stirs. People emerge from hiding.",
			"It will take time, but the world will heal.",
			"Our heroes stand in the light, bruised and exhausted and alive.",
			"Every choice left an echo, and theirs will ring through the ages.",
			"",
			"Thank you for playing Echoes of Choice.",
		]
	else:
		return [
			"Our heroes fall and the darkness grows a little stronger.",
			"This journey may be over, but every great story deserves another telling.",
		]


func _ending_text_story_2() -> Array[String]:
	if GameState.game_won:
		return [
			"The Eye closes for the last time. The crystallized memories shatter, and light rises from the depths like a thousand lanterns set free.",
			"Across the coast, people stop mid-sentence. A name they forgot. A face they lost. A moment that was taken, returned without explanation.",
			"The old woman in the fishing village remembers the dinner. The blacksmith remembers why the sword was urgent. The barkeep remembers the conversations.",
			"Deep below, in the place where the Eye once watched, the party stands in silence. The machinery is dark. The crystals are empty.",
			"A voice, faint as breath, echoes through the chamber. Sera's voice, carried on the last of the light.",
			"'Thank you.'",
			"They carry her memory with them. Not because they have to. Because they choose to.",
			"",
			"Thank you for playing Echoes of Choice.",
		]
	else:
		return [
			"The Eye remains open. The memories do not return.",
			"In the darkness below the world, something watches. Something waits. Something remembers everything it has taken.",
			"This journey may be over, but every great story deserves another telling.",
		]


func _unlock_notification_lines() -> Array[String]:
	match GameState.current_story_id:
		"story_1":
			return [
				"",
				"New content unlocked!",
				"A new story awaits: \"Echoes in the Dark.\" Three strangers wake in a cave with no memory.",
				"A new class has emerged: the Wanderer. A wilderness fighter who learned to endure the land's magic.",
			]
		"story_2":
			return [
				"",
				"New content unlocked!",
				"You have completed all available stories. More adventures may follow.",
			]
		_:
			return []


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
		_:
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
