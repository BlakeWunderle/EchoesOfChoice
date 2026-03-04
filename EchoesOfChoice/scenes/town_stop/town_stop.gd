extends Control

## Town stop scene. Shows narrative, per-character class upgrades, branch choices.
## Flow: pre_battle_text → per-character upgrade picks → post_battle_text → branch/advance.

const DialoguePanel := preload("res://scripts/ui/dialogue_panel.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")

enum TownPhase { INTRO_TEXT, UPGRADING, UPGRADE_REVEAL, OUTRO_TEXT, BRANCH_CHOICE }

var _dialogue: DialoguePanel
var _choice_menu: ChoiceMenu
var _upgrade_label: Label
var _phase: TownPhase = TownPhase.INTRO_TEXT
var _upgrade_index: int = 0  ## Which party member is choosing


func _ready() -> void:
	_build_ui()
	_start_town()


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

	_upgrade_label = Label.new()
	_upgrade_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_upgrade_label.add_theme_font_size_override("font_size", 20)
	_upgrade_label.visible = false
	vbox.add_child(_upgrade_label)

	_choice_menu = ChoiceMenu.new()
	_choice_menu.visible = false
	_choice_menu.choice_selected.connect(_on_choice_selected)
	vbox.add_child(_choice_menu)


func _start_town() -> void:
	var battle = GameState.current_battle
	if not battle.music_track.is_empty():
		MusicManager.play_music(battle.music_track)
	else:
		MusicManager.play_context(MusicManager.MusicContext.TOWN)
	_phase = TownPhase.INTRO_TEXT
	if not battle.pre_battle_text.is_empty():
		_dialogue.show_text(battle.pre_battle_text)
	else:
		_begin_upgrades()


func _on_text_finished() -> void:
	match _phase:
		TownPhase.INTRO_TEXT:
			_begin_upgrades()
		TownPhase.UPGRADE_REVEAL:
			_dialogue.visible = false
			_upgrade_index += 1
			_show_next_upgrade()
		TownPhase.OUTRO_TEXT:
			_check_branch_or_advance()


func _begin_upgrades() -> void:
	_phase = TownPhase.UPGRADING
	_upgrade_index = 0
	_dialogue.visible = false
	_show_next_upgrade()


func _show_next_upgrade() -> void:
	if _upgrade_index >= GameState.party.size():
		_finish_upgrades()
		return

	var fighter: FighterData = GameState.party[_upgrade_index]
	if fighter.upgrade_items.is_empty():
		# No upgrades available, skip
		_upgrade_index += 1
		_show_next_upgrade()
		return

	_phase = TownPhase.UPGRADING
	_upgrade_label.text = "%s the %s. Choose an upgrade:" % [
		fighter.character_name, fighter.character_type]
	_upgrade_label.visible = true

	var options: Array[Dictionary] = []
	for item: String in fighter.upgrade_items:
		options.append({"label": item})
	_choice_menu.show_choices(options)


func _on_choice_selected(index: int) -> void:
	match _phase:
		TownPhase.UPGRADING:
			_on_upgrade_selected(index)
		TownPhase.BRANCH_CHOICE:
			_on_branch_selected(index)


func _on_upgrade_selected(index: int) -> void:
	var fighter: FighterData = GameState.party[_upgrade_index]
	var item: String = fighter.upgrade_items[index]
	var old_name: String = fighter.character_name
	GameState.upgrade_party_member(fighter, item)
	var new_class: String = fighter.character_type
	GameLog.info("Upgrade: %s -> %s" % [old_name, new_class])

	_choice_menu.hide_menu()
	_upgrade_label.visible = false
	_phase = TownPhase.UPGRADE_REVEAL
	_dialogue.visible = true
	_dialogue.show_text([
		"%s takes the %s..." % [old_name, item],
		"%s is now a %s!" % [old_name, new_class],
	])


func _finish_upgrades() -> void:
	# Level up party after upgrades
	GameState.level_up_party()

	# Show outro text if any
	var battle = GameState.current_battle
	if not battle.post_battle_text.is_empty():
		_phase = TownPhase.OUTRO_TEXT
		_dialogue.visible = true
		_dialogue.show_text(battle.post_battle_text)
	else:
		_check_branch_or_advance()


func _check_branch_or_advance() -> void:
	var battle = GameState.current_battle
	if not battle.choices.is_empty():
		_phase = TownPhase.BRANCH_CHOICE
		_dialogue.visible = false
		_upgrade_label.text = "Choose your path:"
		_upgrade_label.visible = true
		var options: Array[Dictionary] = []
		for choice: Dictionary in battle.choices:
			options.append({"label": choice["label"]})
		_choice_menu.show_choices(options)
	else:
		_advance()


func _on_branch_selected(index: int) -> void:
	_choice_menu.hide_menu()
	_upgrade_label.visible = false
	var battle_id: String = GameState.current_battle.choices[index]["battle_id"]
	GameState.advance_with_choice(battle_id)
	_go_to_next()


func _advance() -> void:
	GameState.advance_to_next_battle()
	_go_to_next()


func _go_to_next() -> void:
	match GameState.game_phase:
		GameState.GamePhase.ENDING:
			GameState.game_won = true
			SceneManager.change_scene("res://scenes/narrative/narrative.tscn")
		GameState.GamePhase.NARRATIVE:
			SceneManager.change_scene("res://scenes/narrative/narrative.tscn")
		_:
			SceneManager.change_scene("res://scenes/narrative/narrative.tscn")
