class_name TownEquipmentHandler extends Control

## Self-contained equipment upgrade phase for town stops.
## Shows slot selection and upgrade options per character.
## Supports online multiplayer with mirror UI and RPC sync.

const DialoguePanel := preload("res://scripts/ui/dialogue_panel.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const TipOverlay := preload("res://scripts/ui/tip_overlay.gd")
const ReadyGate := preload("res://scripts/ui/ready_gate.gd")
const WaitingOverlay := preload("res://scripts/ui/waiting_overlay.gd")
const EquipmentDB := preload("res://scripts/data/equipment_db.gd")
const EquipmentData := preload("res://scripts/data/equipment_data.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")

signal phase_finished
signal rpc_requested(method: String, args: Array)

var _party: Array = []
var _story_id: String = ""
var _is_multiplayer: bool = false
var _is_host: bool = true
var _char_index: int = 0
var _upgrade_options: Array[Dictionary] = []
var _upgrade_option_ids: Array[String] = []
var _selected_equip: EquipmentData = null
var _selected_equip_idx: int = -1
var _equip_slot_indices: Array[int] = []
var _sub_phase: String = "slot"

var _dialogue: DialoguePanel
var _choice_menu: ChoiceMenu
var _header_label: Label
var _tip_overlay: TipOverlay
var _ready_gate: ReadyGate
var _waiting_overlay: WaitingOverlay
var _player_indicator: Label
var _pending_advance: Callable


func _init(params: Dictionary) -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_party = params.get("party", [])
	_story_id = params.get("story_id", "")
	_is_multiplayer = params.get("is_multiplayer", false)
	_is_host = params.get("is_host", true)


func _ready() -> void:
	_build_ui()
	_start()


func _build_ui() -> void:
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
	_dialogue.visible = false
	vbox.add_child(_dialogue)

	_header_label = Label.new()
	_header_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_header_label.add_theme_font_size_override("font_size", 28)
	_header_label.visible = false
	vbox.add_child(_header_label)

	_choice_menu = ChoiceMenu.new()
	_choice_menu.visible = false
	_choice_menu.choice_selected.connect(_on_choice_selected)
	_choice_menu.option_focused.connect(_on_option_focused)
	vbox.add_child(_choice_menu)

	_ready_gate = ReadyGate.new()
	_ready_gate.visible = false
	_ready_gate.all_ready.connect(_on_all_ready)
	vbox.add_child(_ready_gate)

	_tip_overlay = TipOverlay.new()
	add_child(_tip_overlay)

	_waiting_overlay = WaitingOverlay.new()
	add_child(_waiting_overlay)

	_player_indicator = Label.new()
	_player_indicator.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_player_indicator.add_theme_font_size_override("font_size", 22)
	_player_indicator.add_theme_color_override("font_color", Color(0.3, 0.9, 0.5))
	_player_indicator.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_player_indicator.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_player_indicator.offset_left = -200
	_player_indicator.offset_right = 200
	_player_indicator.offset_top = 16
	_player_indicator.visible = false
	add_child(_player_indicator)


func _start() -> void:
	_char_index = 0
	if not _any_upgradeable():
		phase_finished.emit()
		return

	if _is_multiplayer and _is_host:
		rpc_requested.emit("begin_equipping", [])

	var lines: Array[String] = EquipmentDB.get_upgrade_text(_story_id)
	_dialogue.visible = true
	_dialogue.show_text(lines)
	if _is_multiplayer:
		_open_gate_early(_do_text_advance)


func _on_text_finished() -> void:
	if _is_multiplayer and NetManager.is_multiplayer_active:
		_mark_self_ready()
		return
	if LocalCoop.is_active:
		_ready_gate.start_local(LocalCoop.player_count)
		return
	_do_text_advance()


func _do_text_advance() -> void:
	_dialogue.visible = false
	_show_slot_selection()


func _on_all_ready() -> void:
	if _pending_advance.is_valid():
		var cb := _pending_advance
		_pending_advance = Callable()
		cb.call_deferred()


func _on_choice_selected(index: int) -> void:
	if _sub_phase == "slot":
		_on_slot_selected(index)
	else:
		_on_upgrade_selected(index)


func _input(event: InputEvent) -> void:
	if not _choice_menu.visible:
		return
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("cancel"):
		if _sub_phase == "upgrade":
			_sub_phase = "slot"
			SFXManager.play(SFXManager.Category.UI_SELECT, 0.2)
			_show_slot_selection()
			get_viewport().set_input_as_handled()


func _on_option_focused(index: int) -> void:
	if _is_multiplayer:
		rpc_requested.emit("mirror_equip_focus", [index])


func _any_upgradeable() -> bool:
	for fighter: FighterData in _party:
		if not fighter.is_user_controlled:
			continue
		for equip: EquipmentData in fighter.equipment:
			if equip.upgrade_level < 1:
				return true
	return false


func _show_slot_selection() -> void:
	_waiting_overlay.hide_waiting()

	while _char_index < _party.size():
		var fighter: FighterData = _party[_char_index]
		if fighter.is_user_controlled and _has_upgradeable(fighter):
			break
		_char_index += 1

	if _char_index >= _party.size():
		_choice_menu.hide_menu()
		_header_label.visible = false
		_player_indicator.visible = false
		_waiting_overlay.hide_waiting()
		phase_finished.emit()
		return

	var fighter: FighterData = _party[_char_index]
	_sub_phase = "slot"

	if LocalCoop.is_active:
		var owner: int = LocalCoop.get_player_for_slot(_char_index)
		LocalCoop.set_active_player(owner)
		_player_indicator.text = "Player %d" % (owner + 1)
		_player_indicator.visible = true

	var options: Array[Dictionary] = _format_slot_options(fighter)

	if _is_multiplayer:
		if _is_host:
			rpc_requested.emit("show_equip_mirror", [
				_char_index, fighter.character_name])
			if NetManager.is_my_fighter(_char_index):
				_header_label.text = "Select equipment for %s:" % fighter.character_name
				_header_label.visible = true
				_choice_menu.show_choices(options)
			else:
				_header_label.text = "Choosing equipment for %s:" % fighter.character_name
				_header_label.visible = true
				var mirror_opts: Array[Dictionary] = _format_slot_options(fighter)
				for opt: Dictionary in mirror_opts:
					opt["disabled"] = true
				_choice_menu.show_choices(mirror_opts)
				_choice_menu.highlight_option(0)
				var owner_peer: int = NetManager.get_fighter_owner_peer(_char_index)
				rpc_requested.emit("request_equip_slot", [
					owner_peer, _char_index, fighter.character_name])
		else:
			_header_label.visible = false
			_choice_menu.visible = false
		return

	_header_label.text = "Select equipment for %s:" % fighter.character_name
	_header_label.visible = true
	_choice_menu.show_choices(options)


func _format_slot_options(fighter: FighterData) -> Array[Dictionary]:
	var options: Array[Dictionary] = []
	_equip_slot_indices.clear()
	for i: int in fighter.equipment.size():
		var equip: EquipmentData = fighter.equipment[i]
		var label: String = "%s (%s)" % [equip.display_name, equip.get_bonus_text()]
		if equip.upgrade_level >= 1:
			label += "  [Upgraded]"
			options.append({"label": label, "disabled": true})
		else:
			options.append({"label": label})
		_equip_slot_indices.append(i)
	return options


func _on_slot_selected(index: int) -> void:
	if index < 0 or index >= _equip_slot_indices.size():
		return

	var fighter: FighterData = _party[_char_index]
	var equip_idx: int = _equip_slot_indices[index]
	_selected_equip = fighter.equipment[equip_idx]
	_selected_equip_idx = equip_idx

	if _selected_equip.upgrade_level >= 1:
		return

	if _is_multiplayer and not _is_host:
		rpc_requested.emit("submit_equip_slot", [_char_index, index])
		_choice_menu.hide_menu()
		_header_label.visible = false
		return

	_show_upgrade_choices()

	if _is_multiplayer and _is_host:
		rpc_requested.emit("show_equip_upgrade_mirror", [
			_char_index, _selected_equip.get_slot_name(), _selected_equip_idx])


func _show_upgrade_choices() -> void:
	_upgrade_options = EquipmentDB.get_upgrade_options(_selected_equip)
	_upgrade_option_ids.clear()
	var options: Array[Dictionary] = []
	for opt: Dictionary in _upgrade_options:
		_upgrade_option_ids.append(opt.id)
		options.append({"label": opt.label, "description": opt.description})

	_sub_phase = "upgrade"
	_header_label.text = "Select %s:" % _selected_equip.get_slot_name()
	_header_label.visible = true
	_choice_menu.show_choices(options)


func _on_upgrade_selected(index: int) -> void:
	if index < 0 or index >= _upgrade_option_ids.size():
		return

	var fighter: FighterData = _party[_char_index]
	var choice_id: String = _upgrade_option_ids[index]

	if _is_multiplayer and not _is_host:
		rpc_requested.emit("submit_equip_upgrade", [_char_index, choice_id])
		_choice_menu.hide_menu()
		_header_label.visible = false
		return

	_apply_equip_upgrade(_char_index, choice_id)


func _apply_equip_upgrade(party_index: int, choice_id: String) -> void:
	var fighter: FighterData = _party[party_index]
	if _selected_equip == null and party_index < _party.size():
		for equip: EquipmentData in fighter.equipment:
			if equip.upgrade_level < 1:
				_selected_equip = equip
				break
	if _selected_equip == null:
		return

	var slot_name: String = _selected_equip.get_slot_name()
	EquipmentDB.apply_upgrade(_selected_equip, fighter, choice_id)
	GameLog.info("Equipment: upgraded %s (%s)" % [_selected_equip.display_name, slot_name])

	if _is_multiplayer and _is_host:
		rpc_requested.emit("equip_applied", [party_index, choice_id, _selected_equip_idx])

	if LocalCoop.is_active:
		LocalCoop.clear_active_player()
		_player_indicator.visible = false

	_char_index = party_index + 1
	_selected_equip = null
	_selected_equip_idx = -1
	_show_slot_selection()


func _has_upgradeable(fighter: FighterData) -> bool:
	for equip: EquipmentData in fighter.equipment:
		if equip.upgrade_level < 1:
			return true
	return false


# =========================================================================
# Ready gate helpers
# =========================================================================

func _open_gate_early(callback: Callable) -> void:
	if not _is_multiplayer or not NetManager.is_multiplayer_active:
		return
	_pending_advance = callback
	_ready_gate.start_online(NetManager.get_connected_peer_count())


func _mark_self_ready() -> void:
	var my_idx: int = NetManager.get_my_peer_index()
	_ready_gate.mark_ready(my_idx)
	NetManager.notify_scene_ready(my_idx)


# =========================================================================
# Inbound RPC methods (called by town_stop RPC forwarders)
# =========================================================================

func on_peer_scene_ready(player_index: int) -> void:
	_ready_gate.mark_ready(player_index)


func on_rpc_show_equip_mirror(party_index: int, char_name: String) -> void:
	if NetManager.is_my_fighter(party_index):
		return
	_char_index = party_index
	_waiting_overlay.hide_waiting()
	var fighter: FighterData = _party[party_index]
	var options: Array[Dictionary] = _format_slot_options(fighter)
	for opt: Dictionary in options:
		opt["disabled"] = true
	_header_label.text = "Choosing equipment for %s:" % char_name
	_header_label.visible = true
	_choice_menu.show_choices(options)
	_choice_menu.highlight_option(0)


func on_rpc_request_equip_slot(party_index: int, char_name: String) -> void:
	_char_index = party_index
	_waiting_overlay.hide_waiting()
	var fighter: FighterData = _party[party_index]
	_header_label.text = "Select equipment for %s:" % char_name
	_header_label.visible = true
	_choice_menu.show_choices(_format_slot_options(fighter))


func on_rpc_submit_equip_slot(party_index: int, slot_index: int) -> void:
	if not _is_host:
		return
	_char_index = party_index
	var fighter: FighterData = _party[party_index]
	_equip_slot_indices.clear()
	for i: int in fighter.equipment.size():
		_equip_slot_indices.append(i)
	if slot_index < 0 or slot_index >= _equip_slot_indices.size():
		return
	var equip_idx: int = _equip_slot_indices[slot_index]
	_selected_equip = fighter.equipment[equip_idx]
	_selected_equip_idx = equip_idx
	if _selected_equip.upgrade_level >= 1:
		return
	var slot_name: String = _selected_equip.get_slot_name()
	rpc_requested.emit("show_equip_upgrade_mirror", [party_index, slot_name, equip_idx])
	if NetManager.is_my_fighter(party_index):
		_show_upgrade_choices()
	else:
		_sub_phase = "upgrade"
		var upgrade_opts: Array[Dictionary] = EquipmentDB.get_upgrade_options(_selected_equip)
		_upgrade_option_ids.clear()
		var mirror_opts: Array[Dictionary] = []
		for opt: Dictionary in upgrade_opts:
			_upgrade_option_ids.append(opt.id)
			mirror_opts.append({"label": opt.label, "description": opt.description, "disabled": true})
		_header_label.text = "Choosing %s:" % slot_name
		_header_label.visible = true
		_choice_menu.show_choices(mirror_opts)
		_choice_menu.highlight_option(0)
		var owner_peer: int = NetManager.get_fighter_owner_peer(party_index)
		rpc_requested.emit("request_equip_upgrade", [
			owner_peer, party_index, slot_name, equip_idx])


func on_rpc_show_equip_upgrade_mirror(party_index: int, slot_name: String,
		equip_idx: int) -> void:
	_sub_phase = "upgrade"
	var fighter: FighterData = _party[party_index]
	if equip_idx >= 0 and equip_idx < fighter.equipment.size():
		_selected_equip = fighter.equipment[equip_idx]
		_selected_equip_idx = equip_idx
	if _selected_equip == null:
		return
	var options: Array[Dictionary] = []
	_upgrade_option_ids.clear()
	var upgrade_opts: Array[Dictionary] = EquipmentDB.get_upgrade_options(_selected_equip)
	for opt: Dictionary in upgrade_opts:
		_upgrade_option_ids.append(opt.id)
		options.append({"label": opt.label, "description": opt.description, "disabled": true})
	_header_label.text = "Choosing %s:" % slot_name
	_header_label.visible = true
	_choice_menu.show_choices(options)
	_choice_menu.highlight_option(0)


func on_rpc_request_equip_upgrade(party_index: int, slot_name: String,
		equip_idx: int) -> void:
	_char_index = party_index
	var fighter: FighterData = _party[party_index]
	if equip_idx >= 0 and equip_idx < fighter.equipment.size():
		_selected_equip = fighter.equipment[equip_idx]
		_selected_equip_idx = equip_idx
	if _selected_equip == null:
		return
	_show_upgrade_choices()


func on_rpc_submit_equip_upgrade(party_index: int, choice_id: String) -> void:
	if not _is_host:
		return
	_char_index = party_index
	_apply_equip_upgrade(party_index, choice_id)


func on_rpc_equip_applied(party_index: int, choice_id: String,
		equip_idx: int) -> void:
	var fighter: FighterData = _party[party_index]
	if equip_idx >= 0 and equip_idx < fighter.equipment.size():
		var equip: EquipmentData = fighter.equipment[equip_idx]
		EquipmentDB.apply_upgrade(equip, fighter, choice_id)
		GameLog.info("Equipment (sync): upgraded %s" % equip.display_name)
	_char_index = party_index + 1
	_show_slot_selection()


func on_rpc_mirror_focus(index: int) -> void:
	_choice_menu.highlight_option(index)
