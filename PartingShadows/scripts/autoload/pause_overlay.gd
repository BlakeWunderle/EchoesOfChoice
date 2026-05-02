extends CanvasLayer

## Global pause menu overlay accessible from any gameplay scene via ESC.
## Shows Resume, Save, Quit to Title, and Quit Game options.
## Save opens a slot picker sub-menu.

const StoryDB := preload("res://scripts/data/story_db.gd")
const SettingsPanel := preload("res://scripts/ui/settings_panel.gd")
const ConfirmDialog := preload("res://scripts/ui/confirm_dialog.gd")
const FighterPicker := preload("res://scripts/ui/fighter_picker.gd")
const CompendiumPanelNew := preload("res://scripts/ui/compendium/compendium_panel.gd")
const InputRemapPanel := preload("res://scripts/ui/input_remap_panel.gd")
const TipOverlay := preload("res://scripts/ui/tip_overlay.gd")
const PauseSaveSlots_C := preload("res://scripts/autoload/pause_save_slots.gd")
const ItemData := preload("res://scripts/data/item_data.gd")
const EquipmentPanel := preload("res://scripts/ui/equipment_panel.gd")

enum Mode { HIDDEN, MAIN_MENU, SAVE_SLOTS, SETTINGS, COMPENDIUM, INVENTORY, EQUIPMENT, KEY_BINDINGS, MP_CHOICE, WAITING_MP, FIGHTER_PICK, LOCAL_ASSIGN }

var _mode: Mode = Mode.HIDDEN
var _panel: Control
var _main_vbox: VBoxContainer
var _save_vbox: VBoxContainer
var _settings_panel: SettingsPanel
var _compendium_panel: CompendiumPanelNew
var _remap_panel: InputRemapPanel
var _resume_btn: Button
var _save_btn: Button
var _title_btn: Button
var _feedback_label: Label
var _confirm_dialog: ConfirmDialog
var _open_mp_btn: Button
var _fighter_picker: FighterPicker
var _tip_overlay: TipOverlay
var _center_panel: PanelContainer
var _pause_title: Label
var _pause_sep: HSeparator
var _panel_expanded: bool = false
var _pending_save_slot: int = -1
var _save_slots: PauseSaveSlots_C
var _prev_focus: Control = null
var _mp_choice_vbox: VBoxContainer
var _local_assign_vbox: VBoxContainer
var _local_device_labels: Array[Label] = []
var _local_claimed: Array[int] = []  # device_id per slot (-2 = unclaimed)
var _local_player_count: int = 2
var _inventory_vbox: VBoxContainer
var _equipment_vbox: VBoxContainer
var _waiting_mp_vbox: VBoxContainer


func _ready() -> void:
	layer = 99  # Below SceneManager fader (100)
	process_mode = Node.PROCESS_MODE_ALWAYS
	_save_slots = PauseSaveSlots_C.new(self)
	_build_ui()
	_panel.visible = false


# =============================================================================
# UI construction
# =============================================================================

func _build_ui() -> void:
	_panel = Control.new()
	_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_panel)

	# Dark backdrop
	var bg := ColorRect.new()
	bg.color = Color(0.0, 0.0, 0.0, 0.6)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_panel.add_child(bg)

	# Center panel container
	_center_panel = PanelContainer.new()
	_center_panel.set_anchors_preset(Control.PRESET_CENTER)
	_center_panel.offset_left = -200.0
	_center_panel.offset_top = -280.0
	_center_panel.offset_right = 200.0
	_center_panel.offset_bottom = 280.0
	_panel.add_child(_center_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 16)
	_center_panel.add_child(margin)

	var root_vbox := VBoxContainer.new()
	root_vbox.add_theme_constant_override("separation", 10)
	margin.add_child(root_vbox)

	# Title
	_pause_title = Label.new()
	_pause_title.text = "PAUSED"
	_pause_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_pause_title.add_theme_font_size_override("font_size", 26)
	_pause_title.add_theme_color_override("font_color", Color.WHITE)
	_pause_title.add_theme_constant_override("outline_size", 2)
	_pause_title.add_theme_color_override("font_outline_color", Color.BLACK)
	root_vbox.add_child(_pause_title)

	_pause_sep = HSeparator.new()
	root_vbox.add_child(_pause_sep)

	# Main menu buttons
	_main_vbox = VBoxContainer.new()
	_main_vbox.add_theme_constant_override("separation", 6)
	root_vbox.add_child(_main_vbox)

	_resume_btn = _make_button("Resume")
	_resume_btn.pressed.connect(_resume)
	_main_vbox.add_child(_resume_btn)

	_save_btn = _make_button("Save")
	_save_btn.pressed.connect(_show_save_slots)
	_main_vbox.add_child(_save_btn)

	_open_mp_btn = _make_button("Co-op")
	_open_mp_btn.pressed.connect(_show_mp_choice)
	_main_vbox.add_child(_open_mp_btn)

	var settings_btn := _make_button("Settings")
	settings_btn.pressed.connect(_show_settings)
	_main_vbox.add_child(settings_btn)

	var compendium_btn := _make_button("Compendium")
	compendium_btn.pressed.connect(_show_compendium)
	_main_vbox.add_child(compendium_btn)

	var inventory_btn := _make_button("Inventory")
	inventory_btn.pressed.connect(_show_inventory)
	_main_vbox.add_child(inventory_btn)

	var equipment_btn := _make_button("Equipment")
	equipment_btn.pressed.connect(_show_equipment)
	_main_vbox.add_child(equipment_btn)

	var logs_btn := _make_button("Copy Logs")
	logs_btn.pressed.connect(_copy_logs)
	_main_vbox.add_child(logs_btn)

	_title_btn = _make_button("Quit to Title")
	_title_btn.pressed.connect(_quit_to_title)
	_main_vbox.add_child(_title_btn)

	var quit_btn := _make_button("Quit Game")
	quit_btn.pressed.connect(_quit_game)
	_main_vbox.add_child(quit_btn)

	# Feedback label for copy confirmation
	_feedback_label = Label.new()
	_feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_feedback_label.add_theme_font_size_override("font_size", 16)
	_feedback_label.add_theme_color_override("font_color", Color(0.5, 1.0, 0.5))
	_feedback_label.visible = false
	root_vbox.add_child(_feedback_label)

	# Save slot sub-menu (hidden by default)
	_save_vbox = VBoxContainer.new()
	_save_vbox.add_theme_constant_override("separation", 6)
	_save_vbox.visible = false
	root_vbox.add_child(_save_vbox)

	# Co-op choice sub-menu (hidden by default)
	_mp_choice_vbox = VBoxContainer.new()
	_mp_choice_vbox.add_theme_constant_override("separation", 6)
	_mp_choice_vbox.visible = false
	root_vbox.add_child(_mp_choice_vbox)

	var local_2p_btn := _make_button("Local Co-op (2 Players)")
	local_2p_btn.pressed.connect(func() -> void: _start_local_coop(2))
	_mp_choice_vbox.add_child(local_2p_btn)

	var local_3p_btn := _make_button("Local Co-op (3 Players)")
	local_3p_btn.pressed.connect(func() -> void: _start_local_coop(3))
	_mp_choice_vbox.add_child(local_3p_btn)

	if SteamManager.is_steam_running:
		var online_btn := _make_button("Online")
		online_btn.pressed.connect(_open_to_multiplayer)
		_mp_choice_vbox.add_child(online_btn)

	var mp_back_btn := _make_button("Back")
	mp_back_btn.pressed.connect(_back_to_main)
	_mp_choice_vbox.add_child(mp_back_btn)

	# Local controller assignment (hidden by default)
	_local_assign_vbox = VBoxContainer.new()
	_local_assign_vbox.add_theme_constant_override("separation", 8)
	_local_assign_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	_local_assign_vbox.visible = false
	root_vbox.add_child(_local_assign_vbox)

	# Waiting for online player (hidden by default)
	_waiting_mp_vbox = VBoxContainer.new()
	_waiting_mp_vbox.add_theme_constant_override("separation", 10)
	_waiting_mp_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	_waiting_mp_vbox.visible = false
	root_vbox.add_child(_waiting_mp_vbox)

	var waiting_lbl := Label.new()
	waiting_lbl.text = "Waiting for a player to join..."
	waiting_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	waiting_lbl.add_theme_color_override("font_color", Color(0.5, 1.0, 0.5))
	_waiting_mp_vbox.add_child(waiting_lbl)

	var invite_btn := _make_button("Invite Friend")
	invite_btn.pressed.connect(func() -> void:
		if NetManager.lobby_id > 0:
			Steam.activateGameOverlayInviteDialog(NetManager.lobby_id))
	_waiting_mp_vbox.add_child(invite_btn)

	var cancel_mp_btn := _make_button("Cancel")
	cancel_mp_btn.pressed.connect(_cancel_open_mp)
	_waiting_mp_vbox.add_child(cancel_mp_btn)

	# Settings panel (hidden by default)
	_settings_panel = SettingsPanel.new()
	_settings_panel.visible = false
	_settings_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_settings_panel.back_pressed.connect(_back_to_main)
	_settings_panel.key_bindings_pressed.connect(_show_key_bindings)
	root_vbox.add_child(_settings_panel)

	# Compendium panel (hidden by default, global context like title screen)
	_compendium_panel = CompendiumPanelNew.new()
	_compendium_panel.visible = false
	_compendium_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_compendium_panel.grid_columns = 5
	_compendium_panel.items_per_page = 10
	_compendium_panel.set_context(CompendiumPanelNew.Context.GLOBAL)
	_compendium_panel.close_requested.connect(_back_to_main)
	root_vbox.add_child(_compendium_panel)

	# Inventory panel (hidden by default)
	_inventory_vbox = VBoxContainer.new()
	_inventory_vbox.add_theme_constant_override("separation", 6)
	_inventory_vbox.visible = false
	_inventory_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_vbox.add_child(_inventory_vbox)

	# Equipment panel (hidden by default)
	_equipment_vbox = VBoxContainer.new()
	_equipment_vbox.add_theme_constant_override("separation", 6)
	_equipment_vbox.visible = false
	_equipment_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_vbox.add_child(_equipment_vbox)

	# Key bindings panel (hidden by default)
	_remap_panel = InputRemapPanel.new()
	_remap_panel.visible = false
	_remap_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_remap_panel.back_pressed.connect(_back_to_main)
	root_vbox.add_child(_remap_panel)

	# Confirm dialog (overlays entire screen)
	_confirm_dialog = ConfirmDialog.new()
	_panel.add_child(_confirm_dialog)

	_tip_overlay = TipOverlay.new()
	_panel.add_child(_tip_overlay)


func _make_button(text: String) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(280, 36)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.focus_mode = Control.FOCUS_ALL
	btn.add_theme_font_size_override("font_size", SettingsManager.font_size)
	_apply_focus_style(btn)
	return btn


static func _apply_focus_style(btn: Button) -> void:
	var focus_sb := StyleBoxFlat.new()
	focus_sb.bg_color = Color(0.2, 0.2, 0.3, 0.9)
	focus_sb.border_color = Color.WHITE
	focus_sb.set_border_width_all(3)
	focus_sb.set_corner_radius_all(4)
	focus_sb.set_content_margin_all(6)
	btn.add_theme_stylebox_override("focus", focus_sb)


# =============================================================================
# Input
# =============================================================================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		match _mode:
			Mode.HIDDEN:
				_show_pause()
			Mode.MAIN_MENU:
				_resume()
			Mode.SAVE_SLOTS:
				_back_to_main()
			Mode.SETTINGS:
				_back_to_main()
			Mode.COMPENDIUM:
				_back_to_main()
			Mode.INVENTORY:
				_back_to_main()
			Mode.EQUIPMENT:
				_back_to_main()
			Mode.KEY_BINDINGS:
				_back_to_main()
			Mode.MP_CHOICE:
				_back_to_main()
			Mode.WAITING_MP:
				_cancel_open_mp()
			Mode.FIGHTER_PICK:
				pass  # FighterPicker handles its own ESC
			Mode.LOCAL_ASSIGN:
				_cancel_local_assign()
		get_viewport().set_input_as_handled()


# =============================================================================
# Main menu actions
# =============================================================================

func _show_pause() -> void:
	# Only pause during gameplay
	if GameState.game_phase == GameState.GamePhase.TITLE:
		return
	if GameState.game_phase == GameState.GamePhase.ENDING:
		return
	if SceneManager.is_transitioning():
		return

	_prev_focus = get_viewport().gui_get_focus_owner()
	_mode = Mode.MAIN_MENU
	_panel.visible = true
	_main_vbox.visible = true
	_save_vbox.visible = false
	_settings_panel.visible = false

	# In multiplayer: don't pause the tree (breaks networking), relabel quit
	if NetManager.is_multiplayer_active:
		_save_btn.visible = NetManager.is_host
		_open_mp_btn.visible = false
		_title_btn.text = "Leave Session"
		# Notify other players to also show pause overlay
		var my_name: String = NetManager.peer_names.get(
			multiplayer.get_unique_id(), "Player")
		_rpc_pause_sync.rpc(my_name)
	else:
		_save_btn.visible = true
		_title_btn.text = "Quit to Title"
		get_tree().paused = true
		# Show "Co-op" only during narrative or town_stop with a party, and not already in co-op
		var can_open_mp: bool = GameState.game_phase in [
			GameState.GamePhase.NARRATIVE, GameState.GamePhase.TOWN_STOP] \
			and not GameState.party.is_empty() \
			and not LocalCoop.is_active
		_open_mp_btn.visible = can_open_mp

	_resume_btn.call_deferred("grab_focus")


func _resume() -> void:
	if NetManager.is_multiplayer_active:
		_rpc_resume_sync.rpc()
	_do_resume_local()


func _quit_to_title() -> void:
	_confirm_dialog.confirmed.connect(_on_quit_to_title_confirmed, CONNECT_ONE_SHOT)
	if NetManager.is_multiplayer_active:
		_confirm_dialog.show_confirm("Leave the multiplayer session?")
	else:
		_confirm_dialog.show_confirm("Return to title? Unsaved progress will be lost.")


func _on_quit_to_title_confirmed(accepted: bool) -> void:
	if not accepted:
		return
	_mode = Mode.HIDDEN
	_panel.visible = false
	if not NetManager.is_multiplayer_active:
		get_tree().paused = false
	else:
		NetManager.leave_session()
	GameState.game_phase = GameState.GamePhase.TITLE
	SceneManager.change_scene("res://scenes/title/title.tscn")


func _copy_logs() -> void:
	var context: Array[String] = [
		"Phase: %s" % _phase_name(),
		"Battle: %s" % GameState.current_battle_id,
		"Party: %s" % _party_summary(),
	]
	GameLog.copy_to_clipboard(context)
	_feedback_label.text = "Copied to clipboard!"
	_feedback_label.visible = true
	await get_tree().create_timer(1.5).timeout
	if _mode != Mode.HIDDEN:
		_feedback_label.visible = false


func _quit_game() -> void:
	_confirm_dialog.confirmed.connect(_on_quit_game_confirmed, CONNECT_ONE_SHOT)
	_confirm_dialog.show_confirm("Are you sure you want to quit?")


func _on_quit_game_confirmed(accepted: bool) -> void:
	if not accepted:
		return
	get_tree().quit()


# =============================================================================
# Co-op sub-menu
# =============================================================================

func _show_mp_choice() -> void:
	_mode = Mode.MP_CHOICE
	_main_vbox.visible = false
	_mp_choice_vbox.visible = true
	_mp_choice_vbox.get_child(0).call_deferred("grab_focus")


# =============================================================================
# Online Multiplayer
# =============================================================================

func _open_to_multiplayer() -> void:
	_mp_choice_vbox.visible = false
	for fighter: RefCounted in GameState.party:
		fighter.owner_peer_id = 1
	NetManager.target_player_count = 2
	# Allow networking while tree is paused
	NetManager.process_mode = Node.PROCESS_MODE_ALWAYS
	# Use Steam lobby (async — lobby_id arrives via signal)
	if SteamManager.is_steam_running:
		NetManager.steam_hosting_started.connect(_on_steam_hosting_ready, CONNECT_ONE_SHOT)
		NetManager.steam_hosting_failed.connect(_on_steam_hosting_fail, CONNECT_ONE_SHOT)
		NetManager.host_game_steam()
	else:
		var err := NetManager.host_game()
		if err != OK:
			_feedback_label.text = "Failed to start server."
			_feedback_label.visible = true
			return
	_mode = Mode.WAITING_MP
	_main_vbox.visible = false
	_waiting_mp_vbox.visible = true
	_waiting_mp_vbox.get_child(1).call_deferred("grab_focus")
	NetManager.player_joined.connect(_on_mp_player_joined)


func _on_steam_hosting_ready(new_lobby_id: int) -> void:
	if NetManager.steam_hosting_failed.is_connected(_on_steam_hosting_fail):
		NetManager.steam_hosting_failed.disconnect(_on_steam_hosting_fail)
	# Lobby is now created — open invite dialog
	Steam.activateGameOverlayInviteDialog(new_lobby_id)


func _on_steam_hosting_fail() -> void:
	if NetManager.steam_hosting_started.is_connected(_on_steam_hosting_ready):
		NetManager.steam_hosting_started.disconnect(_on_steam_hosting_ready)
	_waiting_mp_vbox.visible = false
	_feedback_label.text = "Failed to create Steam lobby."
	_feedback_label.visible = true
	_back_to_main()


func _on_mp_player_joined(_peer_id: int, _player_name: String) -> void:
	if NetManager.player_joined.is_connected(_on_mp_player_joined):
		NetManager.player_joined.disconnect(_on_mp_player_joined)
	NetManager.target_player_count = NetManager.get_connected_peer_count()
	_show_fighter_picker_mp()


func _show_fighter_picker_mp() -> void:
	_mode = Mode.FIGHTER_PICK
	_waiting_mp_vbox.visible = false
	_fighter_picker = FighterPicker.new()
	_fighter_picker.local_only = true
	_panel.add_child(_fighter_picker)
	_fighter_picker.setup(GameState.party, NetManager.target_player_count)
	_fighter_picker.assignment_confirmed.connect(_on_mp_fighter_confirmed)
	_fighter_picker.assignment_cancelled.connect(_on_mp_fighter_cancelled)


func _on_mp_fighter_confirmed(_slot_owners: Dictionary) -> void:
	_fighter_picker.queue_free()
	_fighter_picker = null
	get_tree().paused = false
	NetManager.process_mode = Node.PROCESS_MODE_INHERIT
	NetManager.broadcast_slot_assignments()
	NetManager.broadcast_game_state()
	_mode = Mode.HIDDEN
	_panel.visible = false
	NetManager.reload_current_scene_all_peers()


func _on_mp_fighter_cancelled() -> void:
	_fighter_picker.queue_free()
	_fighter_picker = null
	_cancel_open_mp()


func _cancel_open_mp() -> void:
	if NetManager.player_joined.is_connected(_on_mp_player_joined):
		NetManager.player_joined.disconnect(_on_mp_player_joined)
	if NetManager.steam_hosting_started.is_connected(_on_steam_hosting_ready):
		NetManager.steam_hosting_started.disconnect(_on_steam_hosting_ready)
	if NetManager.steam_hosting_failed.is_connected(_on_steam_hosting_fail):
		NetManager.steam_hosting_failed.disconnect(_on_steam_hosting_fail)
	NetManager.leave_session()
	NetManager.process_mode = Node.PROCESS_MODE_INHERIT
	_waiting_mp_vbox.visible = false
	_back_to_main()


# =============================================================================
# Local Co-op (mid-game)
# =============================================================================

const _LOCAL_UNCLAIMED: int = -2


func _start_local_coop(count: int) -> void:
	_local_player_count = count
	_mp_choice_vbox.visible = false
	_mode = Mode.LOCAL_ASSIGN
	get_tree().paused = false
	_build_local_assign_ui(count)
	_local_assign_vbox.visible = true


func _build_local_assign_ui(count: int) -> void:
	# Clear previous
	for child: Node in _local_assign_vbox.get_children():
		child.queue_free()
	_local_device_labels.clear()
	_local_claimed.clear()

	var header := Label.new()
	header.text = "ASSIGN CONTROLLERS"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 22)
	header.add_theme_color_override("font_color", Color.WHITE)
	_local_assign_vbox.add_child(header)

	var hint := Label.new()
	hint.text = "Press A/Start or Enter to claim a slot"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 14)
	hint.add_theme_color_override("font_color", Color(0.6, 0.7, 0.8))
	_local_assign_vbox.add_child(hint)

	for i: int in count:
		_local_claimed.append(_LOCAL_UNCLAIMED)
		var row := HBoxContainer.new()
		row.alignment = BoxContainer.ALIGNMENT_CENTER
		row.add_theme_constant_override("separation", 12)
		_local_assign_vbox.add_child(row)

		var slot_lbl := Label.new()
		slot_lbl.text = "Player %d:" % (i + 1)
		slot_lbl.custom_minimum_size = Vector2(100, 0)
		row.add_child(slot_lbl)

		var device_lbl := Label.new()
		device_lbl.text = "Waiting..."
		device_lbl.add_theme_color_override("font_color", Color(0.8, 0.6, 0.3))
		device_lbl.custom_minimum_size = Vector2(140, 0)
		_local_device_labels.append(device_lbl)
		row.add_child(device_lbl)

	var cancel_btn := _make_button("Cancel")
	cancel_btn.pressed.connect(_cancel_local_assign)
	_local_assign_vbox.add_child(cancel_btn)


func _input(event: InputEvent) -> void:
	if _mode != Mode.LOCAL_ASSIGN:
		return
	# Detect confirm presses for controller assignment
	if not event.is_pressed() or event.is_echo():
		return
	var is_confirm: bool = false
	var device_id: int = -1
	if event is InputEventKey and event.keycode in [KEY_ENTER, KEY_KP_ENTER, KEY_SPACE]:
		is_confirm = true
		device_id = -1  # keyboard
	elif event is InputEventJoypadButton:
		var btn_idx: int = (event as InputEventJoypadButton).button_index
		if btn_idx in [JOY_BUTTON_A, JOY_BUTTON_START]:
			is_confirm = true
			device_id = event.device
	if not is_confirm:
		return
	# Already claimed by someone?
	if device_id in _local_claimed:
		return
	# Find next unclaimed slot
	for i: int in _local_claimed.size():
		if _local_claimed[i] == _LOCAL_UNCLAIMED:
			_local_claimed[i] = device_id
			var name: String = "Keyboard" if device_id == -1 else "Gamepad %d" % (device_id + 1)
			_local_device_labels[i].text = name
			_local_device_labels[i].remove_theme_color_override("font_color")
			_local_device_labels[i].add_theme_color_override("font_color", Color(0.3, 1.0, 0.5))
			break
	# Check if all slots filled
	var all_claimed: bool = true
	for d: int in _local_claimed:
		if d == _LOCAL_UNCLAIMED:
			all_claimed = false
			break
	if all_claimed:
		_finalize_local_coop()


func _finalize_local_coop() -> void:
	LocalCoop.start(_local_player_count)
	LocalCoop.player_devices = _local_claimed.duplicate() as Array[int]
	LocalCoop.assign_slots(GameState.party.size())
	_local_assign_vbox.visible = false
	_mode = Mode.HIDDEN
	_panel.visible = false
	# Reload current scene so local co-op input gating takes effect
	SceneManager.change_scene(get_tree().current_scene.scene_file_path)


func _cancel_local_assign() -> void:
	_local_assign_vbox.visible = false
	get_tree().paused = true
	_back_to_main()


# =============================================================================
# Settings sub-menu
# =============================================================================

func _show_settings() -> void:
	_mode = Mode.SETTINGS
	_main_vbox.visible = false
	_pause_title.visible = false
	_pause_sep.visible = false
	_panel_expanded = true
	_center_panel.set_anchors_preset(Control.PRESET_CENTER)
	_center_panel.offset_left = -240.0
	_center_panel.offset_top = -320.0
	_center_panel.offset_right = 240.0
	_center_panel.offset_bottom = 320.0
	_settings_panel.visible = true
	_settings_panel.focus_first()


func _show_compendium() -> void:
	_mode = Mode.COMPENDIUM
	_main_vbox.visible = false
	_pause_title.visible = false
	_pause_sep.visible = false
	# Use most of the screen for compendium (narrower for 5-col grid)
	_panel_expanded = true
	_center_panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	_center_panel.offset_left = 180.0
	_center_panel.offset_top = 30.0
	_center_panel.offset_right = -180.0
	_center_panel.offset_bottom = -30.0
	_compendium_panel.visible = true
	_compendium_panel.refresh_data()
	_tip_overlay.show_tip_once("compendium",
		"The compendium tracks enemies, classes, and battles you've " +
		"encountered in this playthrough.\n\n" +
		"Click cards for detailed information and stats!")


func _show_inventory() -> void:
	_mode = Mode.INVENTORY
	_main_vbox.visible = false
	_pause_title.visible = false
	_pause_sep.visible = false

	# Rebuild inventory content each time
	for child: Node in _inventory_vbox.get_children():
		child.queue_free()

	var title := Label.new()
	title.text = "INVENTORY"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	_inventory_vbox.add_child(title)

	var gold_lbl := Label.new()
	gold_lbl.text = "Gold: %d" % GameState.inventory.gold
	gold_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	gold_lbl.add_theme_font_size_override("font_size", SettingsManager.font_size)
	gold_lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	_inventory_vbox.add_child(gold_lbl)

	var sep := HSeparator.new()
	_inventory_vbox.add_child(sep)

	var items: Array = GameState.inventory.get_items()
	for i: int in 6:
		var line := Label.new()
		line.add_theme_font_size_override("font_size", SettingsManager.font_size)
		if i < items.size():
			var item: ItemData = items[i]
			line.text = "%s  -  %s" % [item.item_name, item.get_use_description()]
			line.add_theme_color_override("font_color", Color(0.8, 0.9, 1.0))
		else:
			line.text = "(empty)"
			line.add_theme_color_override("font_color", Color(0.4, 0.4, 0.4))
		_inventory_vbox.add_child(line)

	var back_btn := _make_button("Back")
	back_btn.pressed.connect(_back_to_main)
	_inventory_vbox.add_child(back_btn)
	back_btn.call_deferred("grab_focus")

	_inventory_vbox.visible = true


func _show_equipment() -> void:
	_mode = Mode.EQUIPMENT
	_main_vbox.visible = false
	_pause_title.visible = false
	_pause_sep.visible = false

	for child: Node in _equipment_vbox.get_children():
		child.queue_free()

	var title := Label.new()
	title.text = "EQUIPMENT"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(0.5, 0.9, 0.8))
	_equipment_vbox.add_child(title)

	var sep := HSeparator.new()
	_equipment_vbox.add_child(sep)

	var _EquipmentData := preload("res://scripts/data/equipment_data.gd")
	for fighter: RefCounted in GameState.party:
		if not fighter.is_user_controlled:
			continue
		var name_lbl := Label.new()
		name_lbl.text = "%s the %s" % [fighter.character_name, fighter.character_type]
		name_lbl.add_theme_font_size_override("font_size", SettingsManager.font_size)
		name_lbl.add_theme_color_override("font_color", Color(0.85, 0.95, 0.9))
		_equipment_vbox.add_child(name_lbl)

		if fighter.equipment.is_empty():
			var empty_lbl := Label.new()
			empty_lbl.text = "  No equipment"
			empty_lbl.add_theme_font_size_override("font_size", SettingsManager.font_size - 1)
			empty_lbl.add_theme_color_override("font_color", Color(0.4, 0.4, 0.4))
			_equipment_vbox.add_child(empty_lbl)
		else:
			for equip: RefCounted in fighter.equipment:
				var upgraded: String = "  [Upgraded]" if equip.upgrade_level > 0 else ""
				var line := Label.new()
				line.text = "  %s: %s  (%s)%s" % [
					equip.get_slot_name(), equip.display_name,
					equip.get_bonus_text(), upgraded]
				line.add_theme_font_size_override("font_size", SettingsManager.font_size - 1)
				line.add_theme_color_override("font_color", Color(0.8, 0.9, 1.0))
				_equipment_vbox.add_child(line)

		var spacer := Control.new()
		spacer.custom_minimum_size = Vector2(0, 4)
		_equipment_vbox.add_child(spacer)

	var back_btn := _make_button("Back")
	back_btn.pressed.connect(_back_to_main)
	_equipment_vbox.add_child(back_btn)
	back_btn.call_deferred("grab_focus")

	_equipment_vbox.visible = true


func _show_key_bindings() -> void:
	_mode = Mode.KEY_BINDINGS
	_main_vbox.visible = false
	_pause_title.visible = false
	_pause_sep.visible = false
	_panel_expanded = true
	_center_panel.set_anchors_preset(Control.PRESET_CENTER)
	_center_panel.offset_left = -240.0
	_center_panel.offset_top = -320.0
	_center_panel.offset_right = 240.0
	_center_panel.offset_bottom = 320.0
	_settings_panel.visible = false
	_remap_panel.visible = true
	_remap_panel.focus_first()


# =============================================================================
# Save slot sub-menu
# =============================================================================

func _show_save_slots() -> void:
	_save_slots.show_save_slots()


func _on_save_slot_selected(slot: int) -> void:
	_save_slots.on_save_slot_selected(slot)


func _on_overwrite_confirmed(accepted: bool) -> void:
	_save_slots.on_overwrite_confirmed(accepted)


func _do_save(slot: int) -> void:
	_save_slots.do_save(slot)


func _on_delete_slot_selected(slot: int) -> void:
	_save_slots.on_delete_slot_selected(slot)


func _on_delete_confirmed(accepted: bool) -> void:
	_save_slots.on_delete_confirmed(accepted)


func _back_to_main() -> void:
	_mode = Mode.MAIN_MENU
	_save_vbox.visible = false
	_settings_panel.visible = false
	_compendium_panel.visible = false
	_inventory_vbox.visible = false
	_equipment_vbox.visible = false
	_remap_panel.visible = false
	_mp_choice_vbox.visible = false
	_local_assign_vbox.visible = false
	_waiting_mp_vbox.visible = false
	_feedback_label.visible = false
	_pause_title.visible = true
	_pause_sep.visible = true
	# Restore default center panel size only if it was expanded
	if _panel_expanded:
		_panel_expanded = false
		_center_panel.set_anchors_preset(Control.PRESET_CENTER)
		_center_panel.offset_left = -200.0
		_center_panel.offset_top = -280.0
		_center_panel.offset_right = 200.0
		_center_panel.offset_bottom = 280.0
	_main_vbox.visible = true
	_resume_btn.call_deferred("grab_focus")


func _phase_name() -> String:
	match GameState.game_phase:
		GameState.GamePhase.TITLE: return "Title"
		GameState.GamePhase.PARTY_CREATION: return "Party Creation"
		GameState.GamePhase.NARRATIVE: return "Narrative"
		GameState.GamePhase.BATTLE: return "Battle"
		GameState.GamePhase.TOWN_STOP: return "Town Stop"
		GameState.GamePhase.ENDING: return "Ending"
		_: return "Unknown"


func _party_summary() -> String:
	if GameState.party.is_empty():
		return "(none)"
	var parts: Array[String] = []
	for fighter: RefCounted in GameState.party:
		parts.append("%s the %s (Lv%d)" % [
			fighter.character_name, fighter.character_type, fighter.level])
	return ", ".join(parts)


# =============================================================================
# Multiplayer pause sync
# =============================================================================

func _do_resume_local() -> void:
	# Reset sub-panels if open
	if _mode in [Mode.SAVE_SLOTS, Mode.SETTINGS, Mode.COMPENDIUM, Mode.KEY_BINDINGS]:
		_back_to_main()
	_mode = Mode.HIDDEN
	_panel.visible = false
	_pause_title.text = "PAUSED"
	if not NetManager.is_multiplayer_active:
		get_tree().paused = false
	if is_instance_valid(_prev_focus):
		_prev_focus.grab_focus()
	_prev_focus = null


@rpc("any_peer", "call_remote", "reliable")
func _rpc_pause_sync(pauser_name: String) -> void:
	if _mode != Mode.HIDDEN:
		# Already paused — just update title to show who paused
		_pause_title.text = "PAUSED by %s" % pauser_name
		return
	_pause_title.text = "PAUSED by %s" % pauser_name
	_prev_focus = get_viewport().gui_get_focus_owner()
	_mode = Mode.MAIN_MENU
	_panel.visible = true
	_main_vbox.visible = true
	_save_vbox.visible = false
	_settings_panel.visible = false
	_save_btn.visible = false
	_open_mp_btn.visible = false
	_title_btn.text = "Leave Session"
	_resume_btn.call_deferred("grab_focus")


@rpc("any_peer", "call_remote", "reliable")
func _rpc_resume_sync() -> void:
	if _mode == Mode.HIDDEN:
		return
	_do_resume_local()
