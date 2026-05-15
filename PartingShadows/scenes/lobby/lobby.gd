extends Control

## Multiplayer lobby screen. Host creates a game, guests join via IP.
## Shows player list, player count toggle (2P/3P), story select, and start.
##
## Flow: Title -> Lobby -> Party Creation (once host starts)

const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const StoryDB := preload("res://scripts/data/story_db.gd")
const ConfirmDialog := preload("res://scripts/ui/confirm_dialog.gd")
const FighterPicker := preload("res://scripts/ui/fighter_picker.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")
const FighterDB := preload("res://scripts/data/fighter_db.gd")
const Title := preload("res://scenes/title/title.gd")

enum Mode { ROLE_SELECT, HOSTING, CONNECTING, IN_LOBBY, LOAD_SAVE, FIGHTER_PICK }

var _mode: Mode = Mode.ROLE_SELECT
var _vbox: VBoxContainer
var _header: Label
var _menu: ChoiceMenu
var _player_list: VBoxContainer
var _player_labels: Array[Label] = []
var _status_label: Label
var _address_input: LineEdit
var _confirm_dialog: ConfirmDialog

# Host-only state
var _story_index: int = 0
var _stories: Array[Dictionary] = []
var _load_slot_actions: Array[Dictionary] = []
var _fighter_picker: FighterPicker


func _ready() -> void:
	if not SteamManager.is_steam_running:
		SceneManager.change_scene("res://scenes/title/title.tscn")
		return
	MusicManager.play_music("res://assets/audio/music/menu/Land of Heroes Alt LOOP.wav")
	NetManager.player_joined.connect(_on_player_joined)
	NetManager.player_left.connect(_on_player_left)
	NetManager.lobby_ready.connect(_on_lobby_ready)
	NetManager.session_ended.connect(_on_session_ended)
	NetManager.steam_hosting_started.connect(_on_steam_hosting_started)
	NetManager.steam_hosting_failed.connect(_on_steam_hosting_failed)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	_build_ui()
	# Returning from a finished game with session still active
	if NetManager.is_multiplayer_active:
		if NetManager.is_host:
			_on_steam_hosting_started(NetManager.lobby_id)
		else:
			_show_guest_lobby()
	# Auto-join if arriving from a Steam overlay invite
	elif NetManager.pending_join_lobby_id > 0:
		var lobby := NetManager.pending_join_lobby_id
		NetManager.pending_join_lobby_id = 0
		_auto_join_steam_lobby(lobby)
	else:
		_show_role_select()


func _build_ui() -> void:
	# Background
	var bg := TextureRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var bg_path := _pick_background()
	if ResourceLoader.exists(bg_path):
		bg.texture = load(bg_path)
	add_child(bg)

	# Center
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	_vbox = VBoxContainer.new()
	_vbox.add_theme_constant_override("separation", 16)
	_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	_vbox.custom_minimum_size.x = 500
	center.add_child(_vbox)

	# Header
	_header = Label.new()
	_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_header.add_theme_font_size_override("font_size", 36)
	_header.add_theme_constant_override("outline_size", 2)
	_header.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	_header.add_theme_constant_override("shadow_offset_x", 3)
	_header.add_theme_constant_override("shadow_offset_y", 3)
	_header.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
	_vbox.add_child(_header)

	# Spacer
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 8)
	_vbox.add_child(spacer)

	# Status label (for messages)
	_status_label = Label.new()
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_label.add_theme_font_size_override("font_size", 18)
	_status_label.add_theme_color_override("font_color", Color(0.7, 0.8, 0.85))
	_status_label.visible = false
	_vbox.add_child(_status_label)

	# Player list container
	_player_list = VBoxContainer.new()
	_player_list.add_theme_constant_override("separation", 6)
	_player_list.visible = false
	_vbox.add_child(_player_list)

	# Address input (for joining)
	_address_input = LineEdit.new()
	_address_input.placeholder_text = "Enter host IP address..."
	_address_input.custom_minimum_size = Vector2(300, 40)
	_address_input.alignment = HORIZONTAL_ALIGNMENT_CENTER
	_address_input.max_length = 45
	_address_input.visible = false
	# _address_input is kept in the scene tree but unused (Steam-only lobby)
	_vbox.add_child(_address_input)

	# Menu
	_menu = ChoiceMenu.new()
	_menu.choice_selected.connect(_on_menu_choice)
	_vbox.add_child(_menu)

	# Confirm dialog
	_confirm_dialog = ConfirmDialog.new()
	add_child(_confirm_dialog)


# =============================================================================
# Role selection (Host / Join / Back)
# =============================================================================

func _show_role_select() -> void:
	_mode = Mode.ROLE_SELECT
	_header.text = "MULTIPLAYER"
	_status_label.visible = false
	_player_list.visible = false
	_address_input.visible = false

	_menu.show_choices([
		{"label": "Host Game", "description": "Create a game and invite friends"},
		{"label": "Back"},
	])


func _on_menu_choice(index: int) -> void:
	match _mode:
		Mode.ROLE_SELECT:
			_handle_role_choice(index)
		Mode.HOSTING:
			_handle_host_menu_choice(index)
		Mode.IN_LOBBY:
			_handle_lobby_choice(index)
		Mode.LOAD_SAVE:
			_handle_load_save_choice(index)


func _handle_role_choice(index: int) -> void:
	match index:
		0:  # Host Game
			_start_hosting()
		1:  # Back
			SceneManager.change_scene("res://scenes/title/title.tscn")


# =============================================================================
# Hosting
# =============================================================================

func _start_hosting() -> void:
	NetManager.target_player_count = 2
	if SteamManager.is_steam_running:
		_header.text = "HOST GAME"
		_status_label.text = "Creating Steam lobby..."
		_status_label.visible = true
		_address_input.visible = false
		_menu.hide_menu()
		NetManager.host_game_steam()
		return

	# Steam required — should not reach here after the _ready() guard
	_status_label.text = "Steam is required for online play."
	_status_label.visible = true


func _on_steam_hosting_started(_lobby_id: int) -> void:
	_mode = Mode.HOSTING
	_header.text = "HOST GAME"
	_address_input.visible = false
	_show_host_menu()
	_refresh_player_list()
	_status_label.text = "Lobby created! Use 'Invite Friend' below to send an invite."
	_status_label.visible = true
	_status_label.add_theme_font_size_override("font_size", 22)
	_status_label.add_theme_color_override("font_color", Color.WHITE)
	_status_label.add_theme_constant_override("outline_size", 2)
	_status_label.add_theme_color_override("font_outline_color", Color.BLACK)


func _on_steam_hosting_failed() -> void:
	_status_label.text = "Failed to create Steam lobby. Check your connection."
	_status_label.visible = true
	_show_role_select()


var _host_menu_actions: Array[String] = []

func _show_host_menu() -> void:
	_host_menu_actions.clear()
	var options: Array[Dictionary] = []

	# Player count toggle
	var player_count_label: String = "%d Players" % NetManager.target_player_count
	options.append({"label": player_count_label, "description": "Toggle between 2 and 3 players"})
	_host_menu_actions.append("toggle_players")

	# Invite friend
	options.append({"label": "Invite Friend", "description": "Send a Steam invite to a friend"})
	_host_menu_actions.append("invite")

	# Story selection
	_stories = StoryDB.get_all_stories()
	var current_story: Dictionary = _stories[_story_index] if _story_index < _stories.size() else {}
	var story_title: String = current_story.get("title", "Story 1")
	options.append({"label": "Story: %s" % story_title, "description": "Change story"})
	_host_menu_actions.append("toggle_story")

	# Load Save (only if saves exist)
	if SaveManager.has_any_save():
		options.append({"label": "Load Save", "description": "Continue from a saved game"})
		_host_menu_actions.append("load_save")

	# Start Game
	if NetManager.is_lobby_full():
		options.append({"label": "Start Game"})
	else:
		options.append({"label": "Start Game", "disabled": true,
			"description": "Waiting for %d more player(s)" % (NetManager.target_player_count - NetManager.get_connected_peer_count())})
	_host_menu_actions.append("start_game")

	options.append({"label": "Cancel"})
	_host_menu_actions.append("cancel")
	_menu.show_choices(options)


func _handle_host_menu_choice(index: int) -> void:
	if index < 0 or index >= _host_menu_actions.size():
		return
	match _host_menu_actions[index]:
		"toggle_players":
			NetManager.target_player_count = 3 if NetManager.target_player_count == 2 else 2
			NetManager._assign_host_slots()
			_show_host_menu()
		"invite":
			Steam.activateGameOverlayInviteDialog(NetManager.lobby_id)
			_show_host_menu()
		"toggle_story":
			_story_index = (_story_index + 1) % _stories.size()
			var attempts: int = 0
			while attempts < _stories.size():
				var story: Dictionary = _stories[_story_index]
				var req: String = story.get("unlock_requirement", "")
				if req.is_empty() or UnlockManager.is_unlocked(req):
					break
				_story_index = (_story_index + 1) % _stories.size()
				attempts += 1
			_show_host_menu()
		"load_save":
			_show_load_save_slots()
		"start_game":
			if NetManager.is_lobby_full():
				_start_multiplayer_game()
		"cancel":
			_confirm_dialog.confirmed.connect(_on_cancel_confirmed, CONNECT_ONE_SHOT)
			_confirm_dialog.show_confirm("Leave the lobby?")


# =============================================================================
# Joining (via Steam invite only — no manual join UI)
# =============================================================================

func _auto_join_steam_lobby(steam_lobby_id: int) -> void:
	_mode = Mode.CONNECTING
	_header.text = "JOIN GAME"
	_status_label.text = "Connecting via Steam..."
	_status_label.visible = true
	_address_input.visible = false
	_menu.hide_menu()
	NetManager.join_game_steam(steam_lobby_id)



# =============================================================================
# In Lobby (guest view)
# =============================================================================

func _show_guest_lobby() -> void:
	_mode = Mode.IN_LOBBY
	_header.text = "LOBBY"
	_status_label.text = "Waiting for host to start the game..."
	_status_label.visible = true
	_address_input.visible = false
	_refresh_player_list()

	_menu.show_choices([
		{"label": "Leave"},
	])


func _handle_lobby_choice(index: int) -> void:
	match index:
		0:  # Leave
			_confirm_dialog.confirmed.connect(_on_cancel_confirmed, CONNECT_ONE_SHOT)
			_confirm_dialog.show_confirm("Leave the lobby?")


# =============================================================================
# Player list
# =============================================================================

func _refresh_player_list() -> void:
	# Clear existing labels
	for lbl: Label in _player_labels:
		lbl.queue_free()
	_player_labels.clear()

	_player_list.visible = true

	# Header
	var list_header := Label.new()
	list_header.text = "Players:"
	list_header.add_theme_font_size_override("font_size", 20)
	list_header.add_theme_color_override("font_color", Color(0.6, 0.75, 0.8))
	list_header.add_theme_constant_override("outline_size", 2)
	list_header.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	_player_list.add_child(list_header)
	_player_labels.append(list_header)

	# Player entries
	for peer_id: int in NetManager.peer_names:
		var name: String = NetManager.peer_names[peer_id]
		var slots: Array = NetManager.peer_slots.get(peer_id, [])
		var slot_str: String = ""
		if not slots.is_empty():
			var char_nums: Array[String] = []
			for s: int in slots:
				char_nums.append("Char %d" % (s + 1))
			slot_str = " (%s)" % ", ".join(char_nums)

		var lbl := Label.new()
		lbl.text = "  %s%s%s" % [name, slot_str, " (Host)" if peer_id == 1 else ""]
		lbl.add_theme_font_size_override("font_size", 18)
		lbl.add_theme_color_override("font_color", Color(0.85, 0.9, 0.95))
		lbl.add_theme_constant_override("outline_size", 2)
		lbl.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
		_player_list.add_child(lbl)
		_player_labels.append(lbl)


# =============================================================================
# Starting the game
# =============================================================================

func _start_multiplayer_game() -> void:
	var story: Dictionary = _stories[_story_index]
	var story_id: String = story.get("story_id", "story_1")

	# Bundle slot data directly into the start RPC for atomic delivery
	var slot_data: Dictionary = {}
	for peer_id: int in NetManager.peer_slots:
		slot_data[peer_id] = NetManager.peer_slots[peer_id]

	_rpc_start_game.rpc(story_id, slot_data, NetManager.target_player_count)


@rpc("authority", "call_local", "reliable")
func _rpc_start_game(story_id: String, slot_data: Dictionary, p_count: int) -> void:
	NetManager.apply_slot_data(slot_data, p_count)
	GameState.start_new_game(story_id)
	SceneManager.change_scene("res://scenes/party_creation/party_creation.tscn")


# =============================================================================
# Load Save
# =============================================================================

var _load_page: int = 0
const _SLOTS_PER_PAGE: int = 5

func _show_load_save_slots() -> void:
	_load_page = 0
	_build_load_save_menu()


func _build_load_save_menu() -> void:
	_mode = Mode.LOAD_SAVE
	_load_slot_actions.clear()
	var options: Array[Dictionary] = []

	var total_pages: int = ceili(float(SaveManager.MAX_SAVE_SLOTS) / _SLOTS_PER_PAGE)
	_load_page = clampi(_load_page, 0, total_pages - 1)
	var page_start: int = _load_page * _SLOTS_PER_PAGE
	var page_end: int = mini(page_start + _SLOTS_PER_PAGE, SaveManager.MAX_SAVE_SLOTS)

	for i: int in range(page_start, page_end):
		var summary: Dictionary = SaveManager.get_save_summary(i)
		if summary.get("exists", false):
			var story_title: String = StoryDB.get_story(
				summary.get("story_id", "story_1")).get("title", "")
			var mp_tag: String = " [Co-op]" if summary.get("is_multiplayer", false) else ""
			var secs: float = summary.get("play_seconds", 0.0)
			var h: int = int(secs) / 3600
			var m: int = (int(secs) % 3600) / 60
			options.append({"label": "Slot %d: %s the %s - Lv %d (%s)%s [%dh %dm]" % [
				i + 1, summary.get("lead_name", "???"), summary.get("lead_class", "???"),
				summary.get("level", 1), story_title, mp_tag, h, m]})
			_load_slot_actions.append({"action": "load", "slot": i})
		else:
			options.append({"label": "Slot %d: Empty" % [i + 1], "disabled": true})
			_load_slot_actions.append({"action": "empty"})

	# Autosave on last page
	if _load_page == total_pages - 1:
		var auto_summary: Dictionary = SaveManager.get_save_summary(SaveManager.AUTOSAVE_SLOT)
		if auto_summary.get("exists", false):
			var auto_story: String = StoryDB.get_story(
				auto_summary.get("story_id", "story_1")).get("title", "")
			var mp_tag: String = " [Co-op]" if auto_summary.get("is_multiplayer", false) else ""
			var auto_secs: float = auto_summary.get("play_seconds", 0.0)
			var auto_h: int = int(auto_secs) / 3600
			var auto_m: int = (int(auto_secs) % 3600) / 60
			options.append({"label": "Autosave: %s the %s - Lv %d (%s)%s [%dh %dm]" % [
				auto_summary.get("lead_name", "???"), auto_summary.get("lead_class", "???"),
				auto_summary.get("level", 1), auto_story, mp_tag, auto_h, auto_m]})
			_load_slot_actions.append({"action": "load", "slot": SaveManager.AUTOSAVE_SLOT})
		else:
			options.append({"label": "Autosave: Empty", "disabled": true})
			_load_slot_actions.append({"action": "empty"})

	# Page navigation
	if total_pages > 1:
		if _load_page > 0:
			options.append({"label": "< Prev Page"})
			_load_slot_actions.append({"action": "prev_page"})
		if _load_page < total_pages - 1:
			options.append({"label": "Next Page >"})
			_load_slot_actions.append({"action": "next_page"})

	options.append({"label": "Back"})
	_load_slot_actions.append({"action": "back"})
	_menu.show_choices(options)


func _handle_load_save_choice(index: int) -> void:
	if index < 0 or index >= _load_slot_actions.size():
		return
	var entry: Dictionary = _load_slot_actions[index]
	match entry.get("action", ""):
		"back":
			_mode = Mode.HOSTING
			_show_host_menu()
		"prev_page":
			_load_page -= 1
			_build_load_save_menu()
		"next_page":
			_load_page += 1
			_build_load_save_menu()
		"load":
			var slot: int = int(entry["slot"])
			if SaveManager.load_from_slot(slot):
				_show_fighter_picker()
			else:
				_status_label.text = "Failed to load save."
				_status_label.visible = true


func _show_fighter_picker() -> void:
	_mode = Mode.FIGHTER_PICK
	_menu.hide_menu()
	_status_label.visible = false
	_fighter_picker = FighterPicker.new()
	add_child(_fighter_picker)
	_fighter_picker.setup(GameState.party, NetManager.target_player_count)
	_fighter_picker.assignment_confirmed.connect(_on_fighter_pick_confirmed)
	_fighter_picker.assignment_cancelled.connect(_on_fighter_pick_cancelled)


func _on_fighter_pick_confirmed(_slot_owners: Dictionary) -> void:
	_fighter_picker.queue_free()
	_fighter_picker = null
	# Bundle slot data directly into the RPC for atomic delivery
	var slot_data: Dictionary = {}
	for peer_id: int in NetManager.peer_slots:
		slot_data[peer_id] = NetManager.peer_slots[peer_id]
	var party_data: Array[Dictionary] = []
	for fighter: FighterData in GameState.party:
		party_data.append(fighter.to_save_data())
	var inv_data: Dictionary = GameState.inventory.to_save_data()
	# Set up game state on all peers (call_local)
	_rpc_load_party_and_start.rpc(party_data, GameState.current_battle_id,
		GameState.current_story_id, slot_data, NetManager.target_player_count, inv_data)
	# Scene change routed through NetManager autoload for reliable delivery
	var target: String = "res://scenes/town_stop/town_stop.tscn" \
		if GameState.game_phase == GameState.GamePhase.TOWN_STOP \
		else "res://scenes/narrative/narrative.tscn"
	NetManager.change_scene_for_peers(target)
	SceneManager.change_scene(target)


func _on_fighter_pick_cancelled() -> void:
	_fighter_picker.queue_free()
	_fighter_picker = null
	_mode = Mode.HOSTING
	_show_host_menu()


@rpc("authority", "call_local", "reliable")
func _rpc_load_party_and_start(party_data: Array, battle_id: String, story_id: String,
		slot_data: Dictionary, p_count: int, inv_data: Dictionary = {}) -> void:
	NetManager.apply_slot_data(slot_data, p_count)
	if not NetManager.is_host:
		# Guest: reconstruct party from host data
		GameState.party.clear()
		for data: Dictionary in party_data:
			var fighter := FighterData.new()
			fighter.apply_save_data(data)
			fighter.abilities = FighterDB.get_abilities_for_class(fighter.class_id)
			GameState.party.append(fighter)
		if not inv_data.is_empty():
			GameState.inventory.apply_save_data(inv_data)
		GameState.current_story_id = story_id
		GameState.advance_to_battle(battle_id)
	# Scene change is routed through NetManager separately (not here)


# =============================================================================
# Helpers
# =============================================================================

func _pick_background() -> String:
	if not Title._cached_bg.is_empty():
		return Title._cached_bg
	var options: Array[String] = ["res://assets/art/ui/title_background.png"]
	if UnlockManager.is_unlocked("story_1_complete"):
		options.append("res://assets/art/ui/title_background_s2.png")
	if UnlockManager.is_unlocked("story_2_complete"):
		options.append("res://assets/art/ui/title_background_s3.png")
	return options[randi() % options.size()]


# =============================================================================
# Callbacks
# =============================================================================

func _on_player_joined(peer_id: int, player_name: String) -> void:
	GameLog.info("Lobby: %s (peer %d) joined" % [player_name, peer_id])
	_refresh_player_list()
	if _mode == Mode.HOSTING:
		_show_host_menu()


func _on_player_left(peer_id: int, player_name: String) -> void:
	GameLog.info("Lobby: %s (peer %d) left" % [player_name, peer_id])
	_refresh_player_list()
	if _mode == Mode.HOSTING:
		_show_host_menu()


func _on_lobby_ready() -> void:
	if _mode == Mode.HOSTING:
		_show_host_menu()  # Refresh to enable Start button


func _on_session_ended(reason: String) -> void:
	_status_label.text = reason
	_status_label.visible = true
	_menu.hide_menu()
	await get_tree().create_timer(2.5).timeout
	SceneManager.change_scene("res://scenes/title/title.tscn")


func _on_cancel_confirmed(accepted: bool) -> void:
	if accepted:
		NetManager.leave_session()
		SceneManager.change_scene("res://scenes/title/title.tscn")


# Called when guest successfully connects (via NetManager signal forwarding)
func _on_connected_to_server() -> void:
	_show_guest_lobby()
