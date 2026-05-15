class_name TownUpgradeHandler extends Control

## Self-contained upgrade phase for town stops.
## Iterates party members, shows class upgrade choices with info panel.

const DialoguePanel := preload("res://scripts/ui/dialogue_panel.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const ClassInfoPanel := preload("res://scripts/ui/class_info_panel.gd")
const TipOverlay := preload("res://scripts/ui/tip_overlay.gd")
const ReadyGate := preload("res://scripts/ui/ready_gate.gd")
const WaitingOverlay := preload("res://scripts/ui/waiting_overlay.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")
const FighterDB := preload("res://scripts/data/fighter_db.gd")

signal phase_finished
signal rpc_requested(method: String, args: Array)

var _is_multiplayer: bool = false
var _is_host: bool = true
var _upgrade_index: int = 0
var _upgrade_class_ids: Array[String] = []
var _upgrade_deltas: Array[Dictionary] = []
var _revealing: bool = false

var _dialogue: DialoguePanel
var _choice_menu: ChoiceMenu
var _class_info_panel: ClassInfoPanel
var _header_label: Label
var _tip_overlay: TipOverlay
var _ready_gate: ReadyGate
var _waiting_overlay: WaitingOverlay
var _player_indicator: Label
var _pending_advance: Callable


func _init(params: Dictionary) -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_is_multiplayer = params.get("is_multiplayer", false)
	_is_host = params.get("is_host", true)


func _ready() -> void:
	_build_ui()
	_start()


func _build_ui() -> void:
	var outer_margin := MarginContainer.new()
	outer_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	outer_margin.add_theme_constant_override("margin_left", 80)
	outer_margin.add_theme_constant_override("margin_right", 80)
	outer_margin.add_theme_constant_override("margin_top", 40)
	outer_margin.add_theme_constant_override("margin_bottom", 20)
	add_child(outer_margin)

	var root_vbox := VBoxContainer.new()
	root_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_vbox.add_theme_constant_override("separation", 8)
	outer_margin.add_child(root_vbox)

	_dialogue = DialoguePanel.new()
	_dialogue.all_text_finished.connect(_on_text_finished)
	_dialogue.visible = false
	root_vbox.add_child(_dialogue)
	_dialogue.size_flags_vertical = 0
	_dialogue.custom_minimum_size.y = 200

	_header_label = Label.new()
	_header_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_header_label.add_theme_font_size_override("font_size", 28)
	_header_label.visible = false
	root_vbox.add_child(_header_label)

	_choice_menu = ChoiceMenu.new()
	_choice_menu.visible = false
	_choice_menu.choice_selected.connect(_on_choice_selected)
	_choice_menu.option_focused.connect(_on_option_focused)
	root_vbox.add_child(_choice_menu)

	_ready_gate = ReadyGate.new()
	_ready_gate.visible = false
	_ready_gate.all_ready.connect(_on_all_ready)
	root_vbox.add_child(_ready_gate)

	_class_info_panel = ClassInfoPanel.new()
	root_vbox.add_child(_class_info_panel)

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
	_upgrade_index = 0
	_revealing = false

	_tip_overlay.show_tip_once("first_town",
		"Town stops let you upgrade your party. " +
		"Each character can evolve into a specialized class.\n\n" +
		"Tier 0 classes upgrade to Tier 1, " +
		"and Tier 1 upgrades to Tier 2. " +
		"Each upgrade unlocks new abilities and improves stats.\n\n" +
		"Choose wisely. Upgrades are permanent!")

	if _is_multiplayer and _is_host:
		rpc_requested.emit("begin_upgrades", [])

	_show_next_upgrade()


func _show_next_upgrade() -> void:
	_waiting_overlay.hide_waiting()
	_revealing = false

	while _upgrade_index < GameState.party.size() \
			and GameState.party[_upgrade_index].upgrade_items.is_empty():
		_upgrade_index += 1

	if _upgrade_index >= GameState.party.size():
		_finish()
		return

	var fighter: FighterData = GameState.party[_upgrade_index]

	if LocalCoop.is_active:
		var owner: int = LocalCoop.get_player_for_slot(_upgrade_index)
		LocalCoop.set_active_player(owner)
		_player_indicator.text = "Player %d" % (owner + 1)
		_player_indicator.visible = true

	if _is_multiplayer:
		if _is_host:
			var items: Array[String] = fighter.upgrade_items.duplicate()
			rpc_requested.emit("show_mirror", [
				_upgrade_index, fighter.character_name,
				fighter.character_type, items])
			if NetManager.is_my_fighter(_upgrade_index):
				_header_label.text = "%s the %s. Choose an upgrade:" % [
					fighter.character_name, fighter.character_type]
				_header_label.visible = true
				var options: Array[Dictionary] = _format_upgrade_options(fighter)
				_choice_menu.show_choices(options)
			else:
				_header_label.text = "Choosing upgrade for %s the %s:" % [
					fighter.character_name, fighter.character_type]
				_header_label.visible = true
				var mirror_opts: Array[Dictionary] = _format_upgrade_options(fighter)
				for opt: Dictionary in mirror_opts:
					opt["disabled"] = true
				_choice_menu.show_choices(mirror_opts)
				_choice_menu.highlight_option(0)
				if not _upgrade_class_ids.is_empty() and not _upgrade_class_ids[0].is_empty():
					var deltas: Dictionary = _upgrade_deltas[0] if not _upgrade_deltas.is_empty() else {}
					_class_info_panel.show_class(_upgrade_class_ids[0], true, deltas)
				var owner_peer: int = NetManager.get_fighter_owner_peer(_upgrade_index)
				rpc_requested.emit("request_upgrade", [
					owner_peer, _upgrade_index, fighter.character_name,
					fighter.character_type, items])
		else:
			_header_label.visible = false
			_choice_menu.visible = false
		return

	_header_label.text = "%s the %s. Choose an upgrade:" % [
		fighter.character_name, fighter.character_type]
	_header_label.visible = true
	var options: Array[Dictionary] = _format_upgrade_options(fighter)
	_choice_menu.show_choices(options)


func _format_upgrade_options(fighter: FighterData) -> Array[Dictionary]:
	var options: Array[Dictionary] = []
	_upgrade_class_ids.clear()
	_upgrade_deltas.clear()
	for item: String in fighter.upgrade_items:
		var preview: Dictionary = FighterDB.preview_upgrade(fighter, item)
		if preview.is_empty():
			options.append({"label": item})
			_upgrade_class_ids.append("")
			_upgrade_deltas.append({})
			continue
		_upgrade_class_ids.append(preview.get("new_class_id", ""))
		_upgrade_deltas.append(preview.get("deltas", {}))
		options.append({"label": item})
	return options


func _on_choice_selected(index: int) -> void:
	if _revealing:
		return
	_class_info_panel.visible = false

	if LocalCoop.is_active:
		LocalCoop.clear_active_player()
		_player_indicator.visible = false

	var fighter: FighterData = GameState.party[_upgrade_index]
	var item: String = fighter.upgrade_items[index]

	if _is_multiplayer and not _is_host:
		rpc_requested.emit("submit_upgrade", [_upgrade_index, item])
		_choice_menu.hide_menu()
		_header_label.visible = false
		return

	_apply_upgrade(_upgrade_index, item)


func _apply_upgrade(party_index: int, item: String) -> void:
	var fighter: FighterData = GameState.party[party_index]
	var old_name: String = fighter.character_name
	GameState.upgrade_party_member(fighter, item)
	var new_class: String = fighter.character_type
	CompendiumManager.record_class(fighter.class_id, new_class)
	GameLog.info("Upgrade: %s -> %s" % [old_name, new_class])

	if _is_multiplayer and _is_host:
		rpc_requested.emit("upgrade_applied", [party_index, item, old_name, new_class])

	_show_reveal(old_name, item, new_class)


func _show_reveal(old_name: String, item: String, new_class: String) -> void:
	_choice_menu.hide_menu()
	_header_label.visible = false
	_class_info_panel.visible = false
	_waiting_overlay.hide_waiting()
	_revealing = true
	_dialogue.visible = true
	_dialogue.show_text([
		"%s takes the %s..." % [old_name, item],
		"%s is now a %s!" % [old_name, new_class],
	])
	if _is_multiplayer:
		_open_gate_early(_do_reveal_advance)


func _on_text_finished() -> void:
	if _is_multiplayer and NetManager.is_multiplayer_active:
		_mark_self_ready()
		return
	if LocalCoop.is_active:
		_show_ready_gate(_do_reveal_advance)
		return
	_do_reveal_advance()


func _do_reveal_advance() -> void:
	_dialogue.visible = false
	_revealing = false
	if _is_multiplayer and not _is_host:
		return
	_upgrade_index += 1
	if _is_multiplayer:
		rpc_requested.emit("advance_upgrade", [_upgrade_index])
	_show_next_upgrade()


func _on_option_focused(index: int) -> void:
	if index >= 0 and index < _upgrade_class_ids.size():
		var class_id: String = _upgrade_class_ids[index]
		if not class_id.is_empty():
			var deltas: Dictionary = {}
			if index < _upgrade_deltas.size():
				deltas = _upgrade_deltas[index]
			_class_info_panel.show_class(class_id, true, deltas)
		else:
			_class_info_panel.visible = false
	else:
		_class_info_panel.visible = false
	if _is_multiplayer:
		rpc_requested.emit("mirror_focus", [index])


func _finish() -> void:
	GameState.level_up_party()
	_choice_menu.hide_menu()
	_header_label.visible = false
	_class_info_panel.visible = false
	_player_indicator.visible = false
	_waiting_overlay.hide_waiting()
	phase_finished.emit()


# =========================================================================
# Ready gate helpers
# =========================================================================

func _show_ready_gate(callback: Callable) -> void:
	_pending_advance = callback
	if LocalCoop.is_active:
		_ready_gate.start_local(LocalCoop.player_count)
	elif _is_multiplayer and NetManager.is_multiplayer_active:
		_ready_gate.start_online(NetManager.get_connected_peer_count())
		var my_idx: int = NetManager.get_my_peer_index()
		_ready_gate.mark_ready(my_idx)
		NetManager.notify_scene_ready(my_idx)


func _open_gate_early(callback: Callable) -> void:
	if not _is_multiplayer or not NetManager.is_multiplayer_active:
		return
	_pending_advance = callback
	_ready_gate.start_online(NetManager.get_connected_peer_count())


func _mark_self_ready() -> void:
	var my_idx: int = NetManager.get_my_peer_index()
	_ready_gate.mark_ready(my_idx)
	NetManager.notify_scene_ready(my_idx)


func _on_all_ready() -> void:
	if _pending_advance.is_valid():
		var cb := _pending_advance
		_pending_advance = Callable()
		cb.call_deferred()


# =========================================================================
# Inbound RPC methods (called by town_stop RPC forwarders)
# =========================================================================

func on_peer_scene_ready(player_index: int) -> void:
	_ready_gate.mark_ready(player_index)


func on_rpc_advance_upgrade(new_index: int) -> void:
	_dialogue.visible = false
	_upgrade_index = new_index
	_show_next_upgrade()


func on_rpc_request_upgrade(party_index: int, char_name: String, char_class: String,
		_items: Array) -> void:
	_upgrade_index = party_index
	_waiting_overlay.hide_waiting()
	_header_label.text = "%s the %s. Choose an upgrade:" % [char_name, char_class]
	_header_label.visible = true
	var fighter: FighterData = GameState.party[party_index]
	var options: Array[Dictionary] = _format_upgrade_options(fighter)
	_choice_menu.show_choices(options)


func on_rpc_show_upgrade_mirror(party_index: int, char_name: String, char_class: String,
		_items: Array) -> void:
	if NetManager.is_my_fighter(party_index):
		return
	_upgrade_index = party_index
	_waiting_overlay.hide_waiting()
	_header_label.text = "Choosing upgrade for %s the %s:" % [char_name, char_class]
	_header_label.visible = true
	var fighter: FighterData = GameState.party[party_index]
	var options: Array[Dictionary] = _format_upgrade_options(fighter)
	for opt: Dictionary in options:
		opt["disabled"] = true
	_choice_menu.show_choices(options)
	_choice_menu.highlight_option(0)
	if not _upgrade_class_ids.is_empty() and not _upgrade_class_ids[0].is_empty():
		var deltas: Dictionary = _upgrade_deltas[0] if not _upgrade_deltas.is_empty() else {}
		_class_info_panel.show_class(_upgrade_class_ids[0], true, deltas)


func on_rpc_submit_upgrade(party_index: int, item: String) -> void:
	if not _is_host:
		return
	_apply_upgrade(party_index, item)


func on_rpc_upgrade_applied(party_index: int, item: String, old_name: String,
		new_class: String) -> void:
	var fighter: FighterData = GameState.party[party_index]
	GameState.upgrade_party_member(fighter, item)
	CompendiumManager.record_class(fighter.class_id, new_class)
	GameLog.info("Upgrade (sync): %s -> %s" % [old_name, new_class])
	_show_reveal(old_name, item, new_class)


func on_rpc_mirror_focus(index: int) -> void:
	_choice_menu.highlight_option(index)
	if index >= 0 and index < _upgrade_class_ids.size():
		var class_id: String = _upgrade_class_ids[index]
		if not class_id.is_empty():
			var deltas: Dictionary = _upgrade_deltas[index] if index < _upgrade_deltas.size() else {}
			_class_info_panel.show_class(class_id, true, deltas)
		else:
			_class_info_panel.visible = false
