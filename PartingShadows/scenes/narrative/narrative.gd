extends Control

## Generic narrative scene for pre-battle, post-battle, and ending text.
## Reads GameState to determine which text to show and where to go next.
## After post-battle text, handles branch choices and town stop transitions.

const DialoguePanel := preload("res://scripts/ui/dialogue_panel.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const ReadyGate := preload("res://scripts/ui/ready_gate.gd")
const VotePanel := preload("res://scripts/ui/vote_panel.gd")
const TipOverlay := preload("res://scripts/ui/tip_overlay.gd")
const _StoryDB := preload("res://scripts/data/story_db.gd")
const Endings := preload("res://scenes/narrative/narrative_endings.gd")
const _DemoConfig := preload("res://scripts/data/demo_config.gd")

var _dialogue: DialoguePanel
var _choice_menu: ChoiceMenu
var _ready_gate: ReadyGate
var _vote_panel: VotePanel
var _tip_overlay: TipOverlay
var _scene_image: TextureRect
var _pending_advance: Callable  ## What to do after all players ready up


func _ready() -> void:
	_build_ui()
	_show_narrative()
	if NetManager.is_multiplayer_active:
		NetManager.player_left.connect(_on_player_left)
		NetManager.session_ended.connect(_on_session_ended)
		NetManager.peer_scene_ready.connect(_on_peer_scene_ready)


func _build_ui() -> void:
	# Background image (behind everything)
	_scene_image = TextureRect.new()
	_scene_image.set_anchors_preset(Control.PRESET_FULL_RECT)
	_scene_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_scene_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_scene_image.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	add_child(_scene_image)

	# Dark overlay for text readability
	var overlay := ColorRect.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0, 0, 0, 0.55)
	add_child(overlay)

	var margin := MarginContainer.new()
	margin.anchor_left = 0.0
	margin.anchor_top = 0.0
	margin.anchor_right = 1.0
	margin.anchor_bottom = 0.5
	margin.clip_contents = true
	margin.add_theme_constant_override("margin_left", 80)
	margin.add_theme_constant_override("margin_right", 80)
	margin.add_theme_constant_override("margin_top", 60)
	margin.add_theme_constant_override("margin_bottom", 20)
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

	_ready_gate = ReadyGate.new()
	_ready_gate.visible = false
	_ready_gate.all_ready.connect(_on_all_ready)
	vbox.add_child(_ready_gate)

	_vote_panel = VotePanel.new()
	_vote_panel.visible = false
	_vote_panel.vote_resolved.connect(_on_vote_resolved)
	_vote_panel.vote_cast.connect(_on_vote_cast)
	vbox.add_child(_vote_panel)

	_tip_overlay = TipOverlay.new()
	add_child(_tip_overlay)


func _show_narrative() -> void:
	var battle = GameState.current_battle
	var img_path: String = ""
	if GameState.narrative_mode == GameState.NarrativeMode.POST_BATTLE and not battle.post_scene_image.is_empty():
		img_path = battle.post_scene_image
	elif not battle.scene_image.is_empty():
		img_path = battle.scene_image
	if not img_path.is_empty() and ResourceLoader.exists(img_path):
		_scene_image.texture = load(img_path)
	else:
		_scene_image.texture = null
	match GameState.game_phase:
		GameState.GamePhase.NARRATIVE:
			if not battle.music_track.is_empty():
				MusicManager.play_music(battle.music_track)
			else:
				MusicManager.play_context(MusicManager.MusicContext.BATTLE)
			if GameState.narrative_mode == GameState.NarrativeMode.PRE_BATTLE:
				_dialogue.show_text(GameState.current_battle.pre_battle_text)
			else:
				_dialogue.show_text(GameState.current_battle.post_battle_text)
			_open_gate_early(_do_advance_text)
		GameState.GamePhase.ENDING:
			_show_ending()
		_:
			push_error("Narrative: unexpected game_phase %s" % GameState.game_phase)
			_dialogue.show_text(["Something went wrong. Press continue to return to title."])


var _is_defeat: bool = false


func _show_ending() -> void:
	if _DemoConfig.is_demo():
		_is_defeat = not GameState.game_won
		if _is_defeat:
			MusicManager.play_music("res://assets/audio/music/game_over/Sad Despair 03.wav")
			var defeat_lines: Array[String]
			match GameState.current_story_id:
				"story_2":
					defeat_lines = Endings.get_ending_text_story_2(false, GameState.current_battle_id)
				"story_3":
					defeat_lines = Endings.get_ending_text_story_3(false, GameState.current_battle_id)
				_:
					defeat_lines = Endings.get_ending_text_story_1(false, GameState.current_battle_id)
			defeat_lines.append("")
			defeat_lines.append("Battles won: %d" % GameState.battles_won)
			defeat_lines.append("")
			defeat_lines.append("The full game is available now on Steam with three complete stories, branching paths, and dozens of class upgrades.")
			_dialogue.show_text(defeat_lines)
			_open_gate_early(_do_advance_text)
			return
		MusicManager.play_music("res://assets/audio/music/victory/SHORT Action #5 LOOP.wav")
		var lines: Array[String] = Endings.get_demo_ending_text()
		_dialogue.show_text(lines)
		_open_gate_early(_do_advance_text)
		return
	var is_first_completion: bool = false
	_is_defeat = not GameState.game_won
	if GameState.game_won:
		var story: Dictionary = _StoryDB.get_story(GameState.current_story_id)
		var completion_key: String = story.get("completion_unlock", "")
		if not completion_key.is_empty():
			is_first_completion = not UnlockManager.is_unlocked(completion_key)
			UnlockManager.unlock(completion_key)
		# Track Story 3 path completion for Path C gating
		if GameState.current_story_id == "story_3":
			match GameState.current_battle_id:
				"S3_DreamNexus":
					UnlockManager.unlock("story_3_path_a")
				"S3_B_DreamNexus":
					UnlockManager.unlock("story_3_path_b")
				"S3_C_DreamNexus":
					UnlockManager.unlock("story_3_path_c")
		MusicManager.play_music("res://assets/audio/music/victory/SHORT Action #5 LOOP.wav")
	else:
		MusicManager.play_music("res://assets/audio/music/game_over/Sad Despair 03.wav")
	var lines: Array[String]
	match GameState.current_story_id:
		"story_2":
			lines = Endings.get_ending_text_story_2(GameState.game_won, GameState.current_battle_id)
		"story_3":
			lines = Endings.get_ending_text_story_3(GameState.game_won, GameState.current_battle_id)
		_:
			lines = Endings.get_ending_text_story_1(GameState.game_won, GameState.current_battle_id)
	if _is_defeat:
		lines.append("")
		lines.append("Battles won: %d" % GameState.battles_won)
	if is_first_completion:
		lines.append_array(Endings.get_unlock_notification_lines(GameState.current_story_id))
		_tip_overlay.show_tip_once("story_unlock",
			"Each story features different enemies, environments, and " +
			"challenges. Completing stories also unlocks new base classes " +
			"for your party.\n\n" +
			"Try the new content from the title screen!")
	_dialogue.show_text(lines)
	_open_gate_early(_do_advance_text)


func _on_text_finished() -> void:
	# Online multiplayer: gate was opened when text started; just mark ready now
	if NetManager.is_multiplayer_active:
		_mark_self_ready()
		return

	# Local co-op: show ready gate so all local players confirm
	if LocalCoop.is_active:
		_show_ready_gate(_do_advance_text)
		return

	_do_advance_text()


## Pre-open the ready gate when text starts so incoming RPCs aren't lost.
func _open_gate_early(callback: Callable) -> void:
	if not NetManager.is_multiplayer_active:
		return
	_pending_advance = callback
	_ready_gate.start_online(NetManager.get_connected_peer_count())


## Mark local player as ready and notify peers (called when text finishes).
func _mark_self_ready() -> void:
	var my_idx: int = NetManager.get_my_peer_index()
	_ready_gate.mark_ready(my_idx)
	NetManager.notify_scene_ready(my_idx)


## Received a ready signal from a remote peer via NetManager relay.
func _on_peer_scene_ready(player_index: int) -> void:
	_ready_gate.mark_ready(player_index)


func _do_advance_text() -> void:
	# In online multiplayer, only the host advances narrative
	if NetManager.is_multiplayer_active and not NetManager.is_host:
		return
	match GameState.game_phase:
		GameState.GamePhase.NARRATIVE:
			if GameState.narrative_mode == GameState.NarrativeMode.PRE_BATTLE:
				if GameState.current_battle.enemies.is_empty():
					# No enemies, skip battle, go straight to post-battle text
					GameState.narrative_mode = GameState.NarrativeMode.POST_BATTLE
					_show_narrative()
				else:
					# Go to battle (keep music playing across transition)
					GameState.game_phase = GameState.GamePhase.BATTLE
					if NetManager.is_multiplayer_active:
						NetManager.change_scene_for_peers("res://scenes/battle/battle.tscn")
					SceneManager.change_scene("res://scenes/battle/battle.tscn", 0.4, true)
			else:
				# Post-battle: level up first
				GameState.level_up_party()
				# Check for branch choices
				if not GameState.current_battle.choices.is_empty():
					_show_branch_choices()
				else:
					_advance_after_battle()
		GameState.GamePhase.ENDING:
			if _is_defeat:
				_show_defeat_choices()
			else:
				_return_to_menu()
		_:
			_return_to_menu()


func _show_ready_gate(callback: Callable) -> void:
	_pending_advance = callback
	if LocalCoop.is_active:
		_ready_gate.start_local(LocalCoop.player_count)
	elif NetManager.is_multiplayer_active:
		_ready_gate.start_online(NetManager.get_connected_peer_count())
		var my_idx: int = NetManager.get_my_peer_index()
		_ready_gate.mark_ready(my_idx)
		NetManager.notify_scene_ready(my_idx)


func _on_all_ready() -> void:
	if _pending_advance.is_valid():
		var cb := _pending_advance
		_pending_advance = Callable()
		# Defer so SceneManager.change_scene runs outside the mark_ready/RPC call stack
		cb.call_deferred()




func _show_defeat_choices() -> void:
	_tip_overlay.show_tip_once("first_defeat",
		"The game autosaves after every battle. You can load your " +
		"last save and try again with a different strategy.\n\n" +
		"Consider adjusting your party composition or class upgrades " +
		"at the next town stop.")
	_dialogue.visible = false
	var options: Array[Dictionary] = []
	if SaveManager.has_any_save():
		options.append({"label": "Load Last Save"})
	options.append({"label": "Return to Title"})
	_choice_menu.show_choices(options)
	_choice_menu.choice_selected.disconnect(_on_branch_selected)
	_choice_menu.choice_selected.connect(_on_defeat_choice, CONNECT_ONE_SHOT)


func _on_defeat_choice(index: int) -> void:
	_choice_menu.hide_menu()
	_choice_menu.choice_selected.connect(_on_branch_selected)
	var has_saves: bool = SaveManager.has_any_save()
	if has_saves and index == 0:
		# Load last save
		var slot: int = SaveManager.get_last_used_slot()
		if slot < 0:
			if SaveManager.has_autosave():
				slot = SaveManager.AUTOSAVE_SLOT
			else:
				for i: int in SaveManager.MAX_SAVE_SLOTS:
					if SaveManager.has_save(i):
						slot = i
						break
		if slot >= 0 and SaveManager.load_from_slot(slot):
			var target: String = "res://scenes/town_stop/town_stop.tscn" \
				if GameState.game_phase == GameState.GamePhase.TOWN_STOP \
				else "res://scenes/narrative/narrative.tscn"
			if NetManager.is_multiplayer_active and NetManager.is_host:
				NetManager.broadcast_game_state()
				NetManager.change_scene_for_peers(target)
			SceneManager.change_scene(target)
			return
	_return_to_menu()


func _show_branch_choices() -> void:
	_tip_overlay.show_tip_once("first_branch",
		"Your choices shape the story. Different paths lead to " +
		"different battles, enemies, and endings.\n\n" +
		"Choose carefully. There is no going back!")
	_dialogue.visible = false
	var options: Array[Dictionary] = []
	for choice: Dictionary in GameState.current_battle.choices:
		var opt: Dictionary = {"label": choice["label"]}
		if choice.has("description"):
			opt["description"] = choice["description"]
		options.append(opt)

	# Multi-player: use voting panel
	if LocalCoop.is_active:
		_vote_panel.start_local(options, LocalCoop.player_count)
		return
	if NetManager.is_multiplayer_active:
		if NetManager.is_host:
			_vote_panel.start_online(options)
		else:
			_vote_panel.start_online(options)
		return

	# Single player: direct choice
	_choice_menu.show_choices(options)


func _on_branch_selected(index: int) -> void:
	_choice_menu.hide_menu()
	_apply_branch_choice(index)


func _on_vote_resolved(winning_index: int) -> void:
	_apply_branch_choice(winning_index)


func _on_vote_cast(player_index: int, choice_index: int) -> void:
	_rpc_cast_vote.rpc(player_index, choice_index)


func _apply_branch_choice(index: int) -> void:
	var battle_id: String = GameState.current_battle.choices[index]["battle_id"]

	# Broadcast choice to all peers
	if NetManager.is_multiplayer_active:
		_rpc_branch_chosen.rpc(battle_id)

	GameState.advance_with_choice(battle_id)
	_navigate_after_advance()


func _navigate_after_advance() -> void:
	match GameState.game_phase:
		GameState.GamePhase.TOWN_STOP:
			if NetManager.is_multiplayer_active and NetManager.is_host:
				NetManager.change_scene_for_peers("res://scenes/town_stop/town_stop.tscn")
			SceneManager.change_scene("res://scenes/town_stop/town_stop.tscn")
		GameState.GamePhase.ENDING:
			GameState.game_won = true
			_dialogue.visible = true
			_show_ending()
		_:
			_dialogue.visible = true
			_show_narrative()


func _advance_after_battle() -> void:
	if NetManager.is_multiplayer_active and NetManager.is_host:
		SaveManager.auto_save()
	elif not NetManager.is_multiplayer_active:
		SaveManager.auto_save()
	GameState.advance_to_next_battle()

	match GameState.game_phase:
		GameState.GamePhase.ENDING:
			GameState.game_won = true
			if NetManager.is_multiplayer_active and NetManager.is_host:
				_rpc_show_ending.rpc()
			_show_ending()
		GameState.GamePhase.TOWN_STOP:
			if NetManager.is_multiplayer_active and NetManager.is_host:
				_rpc_advance_to_battle.rpc(GameState.current_battle_id)
				NetManager.change_scene_for_peers("res://scenes/town_stop/town_stop.tscn")
			SceneManager.change_scene("res://scenes/town_stop/town_stop.tscn")
		_:
			if NetManager.is_multiplayer_active and NetManager.is_host:
				_rpc_advance_to_battle.rpc(GameState.current_battle_id)
			_show_narrative()


## Return to lobby (multiplayer) or title (single player).
func _return_to_menu() -> void:
	if NetManager.is_multiplayer_active:
		var dest := "res://scenes/lobby/lobby.tscn"
		NetManager.change_scene_for_peers(dest)
		SceneManager.change_scene(dest)
	else:
		SceneManager.change_scene("res://scenes/title/title.tscn")


# =============================================================================
# Multiplayer disconnect
# =============================================================================

func _on_player_left(_peer_id: int, player_name: String) -> void:
	if not NetManager.is_host:
		return
	GameLog.info("Narrative: %s disconnected, ending session" % player_name)
	SaveManager.auto_save()
	NetManager.leave_session()
	SceneManager.change_scene("res://scenes/title/title.tscn")


func _on_session_ended(reason: String) -> void:
	GameLog.info("Narrative: Session ended (%s)" % reason)
	_choice_menu.hide_menu()
	_dialogue.visible = true
	_dialogue.show_text([reason])
	await get_tree().create_timer(2.5).timeout
	SceneManager.change_scene("res://scenes/title/title.tscn")


# =============================================================================
# Multiplayer RPCs
# =============================================================================


## Host -> All: Branch choice made by host.
@rpc("authority", "call_remote", "reliable")
func _rpc_branch_chosen(battle_id: String) -> void:
	GameState.advance_with_choice(battle_id)
	_navigate_after_advance()


## Host -> All: Show the ending screen (victory or defeat).
@rpc("authority", "call_remote", "reliable")
func _rpc_show_ending() -> void:
	GameState.game_won = true
	GameState.game_phase = GameState.GamePhase.ENDING
	_show_ending()


## Host -> All: Advance to next battle.
@rpc("authority", "call_remote", "reliable")
func _rpc_advance_to_battle(battle_id: String) -> void:
	if not battle_id.is_empty():
		GameState.advance_to_battle(battle_id)
	# Re-render narrative if staying on this scene (host handles scene
	# changes separately for town stop / ending transitions)
	if GameState.game_phase == GameState.GamePhase.NARRATIVE:
		_show_narrative()




## Any -> Host: Cast a vote for a branch choice.
@rpc("any_peer", "call_remote", "reliable")
func _rpc_cast_vote(player_index: int, choice_index: int) -> void:
	_vote_panel.receive_vote(player_index, choice_index)
	if NetManager.is_host:
		_rpc_vote_broadcast.rpc(player_index, choice_index)


## Host -> All: Broadcast a vote.
@rpc("authority", "call_remote", "reliable")
func _rpc_vote_broadcast(player_index: int, choice_index: int) -> void:
	_vote_panel.receive_vote(player_index, choice_index)
