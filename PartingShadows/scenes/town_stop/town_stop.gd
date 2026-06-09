extends Control

## Town stop sequencer. Orchestrates phase handlers (upgrades, equipment, ultimates, shop)
## between intro/outro narration and branch choices. Each phase is a full-screen overlay.

const DialoguePanel := preload("res://scripts/ui/dialogue_panel.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const ReadyGate := preload("res://scripts/ui/ready_gate.gd")
const VotePanel := preload("res://scripts/ui/vote_panel.gd")
const TipOverlay := preload("res://scripts/ui/tip_overlay.gd")
const WaitingOverlay := preload("res://scripts/ui/waiting_overlay.gd")
const ShopDB := preload("res://scripts/data/shop_db.gd")
const ItemDB := preload("res://scripts/data/item_db.gd")
const ItemData := preload("res://scripts/data/item_data.gd")
const TownEquipmentHandler := preload("res://scripts/ui/town_equipment_handler.gd")
const TownUltimateHandler := preload("res://scripts/ui/town_ultimate_handler.gd")
const TownShopHandler := preload("res://scripts/ui/town_shop_handler.gd")
const TownUpgradeHandler := preload("res://scripts/ui/town_upgrade_handler.gd")

enum TownPhase { INTRO_TEXT, UPGRADING, EQUIPPING, ULTIMATE_SELECT, SHOPPING, OUTRO_TEXT, BRANCH_CHOICE }

var _dialogue: DialoguePanel
var _choice_menu: ChoiceMenu
var _ready_gate: ReadyGate
var _vote_panel: VotePanel
var _pending_advance: Callable
var _tip_overlay: TipOverlay
var _waiting_overlay: WaitingOverlay
var _upgrade_label: Label
var _scene_image: TextureRect
var _phase: TownPhase = TownPhase.INTRO_TEXT
var _active_handler: Control = null
var _buffered_peer_ready: Array[int] = []


func _ready() -> void:
	_build_ui()
	_start_town()
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
	_scene_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_scene_image)

	# Dark overlay for text readability
	var overlay := ColorRect.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0, 0, 0, 0.55)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
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

	_upgrade_label = Label.new()
	_upgrade_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_upgrade_label.add_theme_font_size_override("font_size", 28)
	_upgrade_label.visible = false
	vbox.add_child(_upgrade_label)

	_choice_menu = ChoiceMenu.new()
	_choice_menu.visible = false
	_choice_menu.choice_selected.connect(_on_choice_selected)
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

	_waiting_overlay = WaitingOverlay.new()
	add_child(_waiting_overlay)


func _start_town() -> void:
	var battle = GameState.current_battle
	if not battle.scene_image.is_empty() and ResourceLoader.exists(battle.scene_image):
		_scene_image.texture = load(battle.scene_image)
	if not battle.music_track.is_empty():
		MusicManager.play_music(battle.music_track)
	else:
		MusicManager.play_context(MusicManager.MusicContext.TOWN)
	_phase = TownPhase.INTRO_TEXT
	if not battle.pre_battle_text.is_empty():
		_dialogue.show_text(battle.pre_battle_text)
		_open_gate_early(_do_intro_advance)
	else:
		_launch_upgrades()


func _on_text_finished() -> void:
	# Online multiplayer: gate was opened when text started; just mark ready now
	if NetManager.is_multiplayer_active:
		_mark_self_ready()
		return

	# Local co-op: show ready gate so all local players confirm
	if LocalCoop.is_active:
		match _phase:
			TownPhase.INTRO_TEXT:
				_show_ready_gate(_do_intro_advance)
			TownPhase.OUTRO_TEXT:
				_show_ready_gate(_do_outro_advance)
		return

	_do_text_advance()


func _do_text_advance() -> void:
	match _phase:
		TownPhase.INTRO_TEXT:
			_do_intro_advance()
		TownPhase.OUTRO_TEXT:
			_do_outro_advance()


func _do_intro_advance() -> void:
	_launch_upgrades()


func _do_outro_advance() -> void:
	if NetManager.is_multiplayer_active and not NetManager.is_host:
		# Guest: host drives via _rpc_advance_next / _rpc_branch_chosen / _rpc_change_scene
		# Exception: branch choices need the vote panel on both sides
		var battle = GameState.current_battle
		if not battle.choices.is_empty():
			_check_branch_or_advance()
		return
	_check_branch_or_advance()


func _show_ready_gate(callback: Callable) -> void:
	_pending_advance = callback
	if LocalCoop.is_active:
		_ready_gate.start_local(LocalCoop.player_count)
	elif NetManager.is_multiplayer_active:
		_ready_gate.start_online(NetManager.get_connected_peer_count())
		var my_idx: int = NetManager.get_my_peer_index()
		_ready_gate.mark_ready(my_idx)
		NetManager.notify_scene_ready(my_idx)


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
	if _active_handler and _active_handler.has_method("on_peer_scene_ready"):
		_active_handler.on_peer_scene_ready(player_index)
	elif _ready_gate.visible:
		_ready_gate.mark_ready(player_index)
	else:
		if player_index not in _buffered_peer_ready:
			_buffered_peer_ready.append(player_index)


func _drain_buffered_ready() -> void:
	if _active_handler and _active_handler.has_method("on_peer_scene_ready"):
		for idx: int in _buffered_peer_ready:
			_active_handler.on_peer_scene_ready(idx)
	_buffered_peer_ready.clear()


func _on_all_ready() -> void:
	if _pending_advance.is_valid():
		var cb := _pending_advance
		_pending_advance = Callable()
		cb.call_deferred()


func _launch_upgrades() -> void:
	if _active_handler:
		return
	_phase = TownPhase.UPGRADING
	_dialogue.visible = false
	_ready_gate.visible = false
	var handler := TownUpgradeHandler.new({
		"is_multiplayer": NetManager.is_multiplayer_active,
		"is_host": NetManager.is_host if NetManager.is_multiplayer_active else true,
	})
	handler.phase_finished.connect(_on_upgrades_finished)
	handler.rpc_requested.connect(_forward_upgrade_rpc)
	_active_handler = handler
	add_child(handler)
	_drain_buffered_ready.call_deferred()


func _on_upgrades_finished() -> void:
	if _active_handler:
		_active_handler.queue_free()
		_active_handler = null
	_start_equipping()


func _forward_upgrade_rpc(method: String, args: Array) -> void:
	_do_forward_upgrade_rpc.call_deferred(method, args)


func _do_forward_upgrade_rpc(method: String, args: Array) -> void:
	match method:
		"begin_upgrades":
			_rpc_begin_upgrades.rpc()
		"advance_upgrade":
			_rpc_advance_upgrade.rpc(args[0])
		"show_mirror":
			_rpc_show_upgrade_mirror.rpc(args[0], args[1], args[2], args[3])
		"request_upgrade":
			_rpc_request_upgrade.rpc_id(args[0], args[1], args[2], args[3], args[4])
		"submit_upgrade":
			_rpc_submit_upgrade.rpc_id(1, args[0], args[1])
		"upgrade_applied":
			_rpc_upgrade_applied.rpc(args[0], args[1], args[2], args[3])
		"mirror_focus":
			_rpc_mirror_focus.rpc(args[0])


func _on_choice_selected(index: int) -> void:
	match _phase:
		TownPhase.BRANCH_CHOICE:
			_on_branch_selected(index)


func _start_equipping() -> void:
	if _active_handler:
		return
	_phase = TownPhase.EQUIPPING
	var handler := TownEquipmentHandler.new({
		"party": GameState.party,
		"story_id": GameState.current_story_id,
		"is_multiplayer": NetManager.is_multiplayer_active,
		"is_host": NetManager.is_host if NetManager.is_multiplayer_active else true,
	})
	handler.phase_finished.connect(_on_equip_finished)
	handler.rpc_requested.connect(_forward_equip_rpc)
	_active_handler = handler
	add_child(handler)
	_drain_buffered_ready.call_deferred()


func _on_equip_finished() -> void:
	if _active_handler:
		_active_handler.queue_free()
		_active_handler = null
	_start_ultimate_select()


func _forward_equip_rpc(method: String, args: Array) -> void:
	_do_forward_equip_rpc.call_deferred(method, args)


func _do_forward_equip_rpc(method: String, args: Array) -> void:
	match method:
		"begin_equipping":
			_rpc_begin_equipping.rpc()
		"show_equip_mirror":
			_rpc_show_equip_mirror.rpc(args[0], args[1])
		"request_equip_slot":
			_rpc_request_equip_slot.rpc_id(args[0], args[1], args[2])
		"submit_equip_slot":
			_rpc_submit_equip_slot.rpc_id(1, args[0], args[1])
		"show_equip_upgrade_mirror":
			_rpc_show_equip_upgrade_mirror.rpc(args[0], args[1], args[2])
		"request_equip_upgrade":
			_rpc_request_equip_upgrade.rpc_id(args[0], args[1], args[2], args[3])
		"submit_equip_upgrade":
			_rpc_submit_equip_upgrade.rpc_id(1, args[0], args[1])
		"equip_applied":
			_rpc_equip_applied.rpc(args[0], args[1], args[2])
		"mirror_equip_focus":
			_rpc_mirror_focus.rpc(args[0])


func _start_ultimate_select() -> void:
	if _active_handler:
		return
	_phase = TownPhase.ULTIMATE_SELECT
	var handler := TownUltimateHandler.new({
		"party": GameState.party,
		"battle_id": GameState.current_battle.battle_id,
		"is_multiplayer": NetManager.is_multiplayer_active,
		"is_host": NetManager.is_host if NetManager.is_multiplayer_active else true,
	})
	handler.phase_finished.connect(_on_ult_finished)
	handler.rpc_requested.connect(_forward_ultimate_rpc)
	_active_handler = handler
	add_child(handler)
	_drain_buffered_ready.call_deferred()


func _on_ult_finished() -> void:
	if _active_handler:
		_active_handler.queue_free()
		_active_handler = null
	_check_shop_or_advance()


func _forward_ultimate_rpc(method: String, args: Array) -> void:
	_do_forward_ultimate_rpc.call_deferred(method, args)


func _do_forward_ultimate_rpc(method: String, args: Array) -> void:
	match method:
		"begin_ultimates":
			_rpc_begin_ultimates.rpc()
		"show_mirror":
			_rpc_show_ultimate_mirror.rpc(args[0], args[1], args[2])
		"request_ultimate":
			_rpc_request_ultimate.rpc_id(args[0], args[1], args[2], args[3])
		"submit_ultimate":
			_rpc_submit_ultimate.rpc_id(1, args[0], args[1])
		"ultimate_applied":
			_rpc_ultimate_applied.rpc(args[0], args[1])
		"mirror_focus":
			_rpc_mirror_focus.rpc(args[0])


func _check_shop_or_advance() -> void:
	if NetManager.is_multiplayer_active and not NetManager.is_host:
		return

	var battle = GameState.current_battle
	var shop_items: Array = ShopDB.get_shop_items(battle.battle_id)
	if not shop_items.is_empty() and GameState.inventory.gold > 0:
		if NetManager.is_multiplayer_active:
			_send_begin_shop.call_deferred()
		_launch_shop(shop_items)
		return

	if NetManager.is_multiplayer_active:
		_send_skip_shop.call_deferred()
	_show_outro_or_advance()


func _send_begin_shop() -> void:
	_rpc_begin_shop.rpc(GameState.inventory.gold)


func _send_skip_shop() -> void:
	_rpc_skip_shop.rpc()


func _show_outro_or_advance() -> void:
	var battle = GameState.current_battle
	if not battle.post_battle_text.is_empty():
		_phase = TownPhase.OUTRO_TEXT
		_dialogue.visible = true
		_dialogue.show_text(battle.post_battle_text)
		_open_gate_early(_do_outro_advance)
	else:
		_check_branch_or_advance()


func _launch_shop(shop_items: Array) -> void:
	if _active_handler:
		return
	_phase = TownPhase.SHOPPING
	var is_readonly: bool = NetManager.is_multiplayer_active and not NetManager.is_host
	var handler := TownShopHandler.new({
		"shop_items": shop_items,
		"battle_id": GameState.current_battle.battle_id,
		"is_host": NetManager.is_host if NetManager.is_multiplayer_active else true,
		"is_multiplayer": NetManager.is_multiplayer_active,
		"is_readonly": is_readonly,
	})
	handler.phase_finished.connect(_on_shop_finished)
	handler.purchase_made.connect(_on_shop_purchase)
	handler.discard_and_buy.connect(_on_shop_discard_and_buy)
	handler.shop_opened_broadcast.connect(_on_shop_opened_broadcast)
	handler.shop_closed_broadcast.connect(_on_shop_closed_broadcast)
	_active_handler = handler
	add_child(handler)
	_drain_buffered_ready.call_deferred()


func _on_shop_finished() -> void:
	if _active_handler:
		_active_handler.queue_free()
		_active_handler = null
	_show_outro_or_advance()


func _on_shop_purchase(item_id: String, price: int) -> void:
	if NetManager.is_multiplayer_active and NetManager.is_host:
		_rpc_shop_purchase.rpc(item_id, price)


func _on_shop_discard_and_buy(discard_index: int, item_id: String, price: int) -> void:
	if NetManager.is_multiplayer_active and NetManager.is_host:
		_rpc_shop_discard_and_buy.rpc(discard_index, item_id, price)


func _on_shop_opened_broadcast(items_json: String) -> void:
	if NetManager.is_multiplayer_active and NetManager.is_host:
		_rpc_shop_opened.rpc(items_json)


func _on_shop_closed_broadcast() -> void:
	if NetManager.is_multiplayer_active and NetManager.is_host:
		_rpc_shop_closed.rpc()


func _check_branch_or_advance() -> void:
	var battle = GameState.current_battle
	if not battle.choices.is_empty():
		_tip_overlay.show_tip_once("first_branch",
			"Your choices shape the story. Different paths lead to " +
			"different battles, enemies, and endings.\n\n" +
			"Choose carefully. There is no going back!")
		_phase = TownPhase.BRANCH_CHOICE
		_dialogue.visible = false
		var options: Array[Dictionary] = []
		for choice: Dictionary in battle.choices:
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
		_upgrade_label.text = "Choose your path:"
		_upgrade_label.visible = true
		_choice_menu.show_choices(options)
	else:
		_advance()


func _on_branch_selected(index: int) -> void:
	_choice_menu.hide_menu()
	_upgrade_label.visible = false
	_apply_branch_choice(index)


func _on_vote_resolved(winning_index: int) -> void:
	_apply_branch_choice(winning_index)


func _on_vote_cast(player_index: int, choice_index: int) -> void:
	_rpc_cast_vote.rpc(player_index, choice_index)


func _apply_branch_choice(index: int) -> void:
	var battle_id: String = GameState.current_battle.choices[index]["battle_id"]
	if NetManager.is_multiplayer_active:
		_rpc_branch_chosen.rpc(battle_id)
	GameState.advance_with_choice(battle_id)
	_go_to_next()


func _advance() -> void:
	GameState.advance_to_next_battle()
	if NetManager.is_multiplayer_active and NetManager.is_host:
		_rpc_advance_next.rpc(GameState.current_battle_id)
	_go_to_next()


func _go_to_next() -> void:
	var scene_path: String = "res://scenes/narrative/narrative.tscn"
	match GameState.game_phase:
		GameState.GamePhase.ENDING:
			GameState.game_won = true
		_:
			pass
	if NetManager.is_multiplayer_active and NetManager.is_host:
		NetManager.change_scene_for_peers(scene_path)
	SceneManager.change_scene(scene_path)


# =============================================================================
# Multiplayer disconnect
# =============================================================================

func _on_player_left(_peer_id: int, player_name: String) -> void:
	if not NetManager.is_host:
		return
	GameLog.info("TownStop: %s disconnected, ending session" % player_name)
	SaveManager.auto_save()
	NetManager.leave_session()
	SceneManager.change_scene("res://scenes/title/title.tscn")


func _on_session_ended(reason: String) -> void:
	GameLog.info("TownStop: Session ended (%s)" % reason)
	_waiting_overlay.hide_waiting()
	_choice_menu.hide_menu()
	_upgrade_label.visible = false
	_dialogue.visible = true
	_dialogue.show_text([reason])
	await get_tree().create_timer(2.5).timeout
	SceneManager.change_scene("res://scenes/title/title.tscn")


# =============================================================================
# Multiplayer RPCs
# =============================================================================

## Host -> All: Begin upgrade phase (after intro text finishes).
@rpc("authority", "call_remote", "reliable")
func _rpc_begin_upgrades() -> void:
	if not _active_handler:
		_launch_upgrades()


## Host -> All: Advance to next upgrade index.
@rpc("authority", "call_remote", "reliable")
func _rpc_advance_upgrade(new_index: int) -> void:
	if _active_handler and _active_handler.has_method("on_rpc_advance_upgrade"):
		_active_handler.on_rpc_advance_upgrade(new_index)


## Host -> Guest: Request the owning player to choose an upgrade.
@rpc("authority", "call_remote", "reliable")
func _rpc_request_upgrade(party_index: int, char_name: String, char_class: String,
		items: Array) -> void:
	if _active_handler and _active_handler.has_method("on_rpc_request_upgrade"):
		_active_handler.on_rpc_request_upgrade(party_index, char_name, char_class, items)


## Host -> All: Show upgrade options as read-only mirror for non-owning peers.
@rpc("authority", "call_remote", "reliable")
func _rpc_show_upgrade_mirror(party_index: int, char_name: String, char_class: String,
		_items: Array) -> void:
	if _active_handler and _active_handler.has_method("on_rpc_show_upgrade_mirror"):
		_active_handler.on_rpc_show_upgrade_mirror(party_index, char_name, char_class, _items)


## Guest -> Host: Submit chosen upgrade item.
@rpc("any_peer", "call_remote", "reliable")
func _rpc_submit_upgrade(party_index: int, item: String) -> void:
	if not NetManager.is_host:
		return
	if _active_handler and _active_handler.has_method("on_rpc_submit_upgrade"):
		_active_handler.on_rpc_submit_upgrade(party_index, item)


## Host -> All: Broadcast upgrade result so all peers update their party.
@rpc("authority", "call_remote", "reliable")
func _rpc_upgrade_applied(party_index: int, item: String, old_name: String,
		new_class: String) -> void:
	if _active_handler and _active_handler.has_method("on_rpc_upgrade_applied"):
		_active_handler.on_rpc_upgrade_applied(party_index, item, old_name, new_class)


## Host -> All: Branch choice made by host.
@rpc("authority", "call_remote", "reliable")
func _rpc_branch_chosen(battle_id: String) -> void:
	GameState.advance_with_choice(battle_id)
	_go_to_next()


## Host -> All: Advance to next battle (no branch).
@rpc("authority", "call_remote", "reliable")
func _rpc_advance_next(battle_id: String) -> void:
	if not battle_id.is_empty():
		GameState.advance_to_battle(battle_id)


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


## Host -> All: Broadcast a shop discard + purchase so peers update inventory.
@rpc("authority", "call_remote", "reliable")
func _rpc_shop_discard_and_buy(discard_index: int, item_id: String, price: int) -> void:
	GameState.inventory.remove_at(discard_index)
	GameState.inventory.spend_gold(price)
	var bought: ItemData = ItemDB.create_by_id(item_id)
	if bought:
		GameState.inventory.add_item(bought)
	if _active_handler and _active_handler.has_method("on_rpc_discard_and_buy"):
		_active_handler.on_rpc_discard_and_buy(discard_index, item_id, price)


## Host -> All: Broadcast a shop purchase so peers update inventory + refresh mirror.
@rpc("authority", "call_remote", "reliable")
func _rpc_shop_purchase(item_id: String, price: int) -> void:
	GameState.inventory.spend_gold(price)
	var item: ItemData = ItemDB.create_by_id(item_id)
	if item:
		GameState.inventory.add_item(item)
	if _active_handler and _active_handler.has_method("on_rpc_purchase"):
		_active_handler.on_rpc_purchase(item_id, price)


## Host -> All: Shop opened with inventory list (guest receives items to display).
@rpc("authority", "call_remote", "reliable")
func _rpc_shop_opened(items_json: String) -> void:
	if _active_handler and _active_handler.has_method("on_rpc_shop_opened"):
		_active_handler.on_rpc_shop_opened(items_json)


## Host -> All: Shop closed, proceed to next phase.
@rpc("authority", "call_remote", "reliable")
func _rpc_shop_closed() -> void:
	if _active_handler and _active_handler.has_method("on_rpc_shop_closed"):
		_active_handler.on_rpc_shop_closed()


## Host -> All: Begin shop phase with synced gold.
@rpc("authority", "call_remote", "reliable")
func _rpc_begin_shop(gold: int) -> void:
	GameState.inventory.gold = gold
	if not _active_handler:
		var battle = GameState.current_battle
		var shop_items: Array = ShopDB.get_shop_items(battle.battle_id)
		_launch_shop(shop_items)


## Host -> All: No shop, proceed to outro/advance.
@rpc("authority", "call_remote", "reliable")
func _rpc_skip_shop() -> void:
	_show_outro_or_advance()


## Host -> All: Begin equipment upgrade phase.
@rpc("authority", "call_remote", "reliable")
func _rpc_begin_equipping() -> void:
	if not _active_handler:
		_start_equipping()


## Host -> All: Show equipment slots as read-only mirror.
@rpc("authority", "call_remote", "reliable")
func _rpc_show_equip_mirror(party_index: int, char_name: String) -> void:
	if _active_handler and _active_handler.has_method("on_rpc_show_equip_mirror"):
		_active_handler.on_rpc_show_equip_mirror(party_index, char_name)


## Host -> Guest: Request the owning player to pick an equipment slot.
@rpc("authority", "call_remote", "reliable")
func _rpc_request_equip_slot(party_index: int, char_name: String) -> void:
	if _active_handler and _active_handler.has_method("on_rpc_request_equip_slot"):
		_active_handler.on_rpc_request_equip_slot(party_index, char_name)


## Guest -> Host: Submit chosen equipment slot.
@rpc("any_peer", "call_remote", "reliable")
func _rpc_submit_equip_slot(party_index: int, slot_index: int) -> void:
	if not NetManager.is_host:
		return
	if _active_handler and _active_handler.has_method("on_rpc_submit_equip_slot"):
		_active_handler.on_rpc_submit_equip_slot(party_index, slot_index)


## Host -> All: Show upgrade options as read-only mirror after slot selected.
@rpc("authority", "call_remote", "reliable")
func _rpc_show_equip_upgrade_mirror(party_index: int, slot_name: String,
		equip_idx: int) -> void:
	if _active_handler and _active_handler.has_method("on_rpc_show_equip_upgrade_mirror"):
		_active_handler.on_rpc_show_equip_upgrade_mirror(party_index, slot_name, equip_idx)


## Host -> Guest: Request the owning player to pick an upgrade.
@rpc("authority", "call_remote", "reliable")
func _rpc_request_equip_upgrade(party_index: int, slot_name: String,
		equip_idx: int) -> void:
	if _active_handler and _active_handler.has_method("on_rpc_request_equip_upgrade"):
		_active_handler.on_rpc_request_equip_upgrade(party_index, slot_name, equip_idx)


## Guest -> Host: Submit chosen equipment upgrade.
@rpc("any_peer", "call_remote", "reliable")
func _rpc_submit_equip_upgrade(party_index: int, choice_id: String) -> void:
	if not NetManager.is_host:
		return
	if _active_handler and _active_handler.has_method("on_rpc_submit_equip_upgrade"):
		_active_handler.on_rpc_submit_equip_upgrade(party_index, choice_id)


## Host -> All: Broadcast equipment upgrade result so all peers update.
@rpc("authority", "call_remote", "reliable")
func _rpc_equip_applied(party_index: int, choice_id: String,
		equip_idx: int) -> void:
	if _active_handler and _active_handler.has_method("on_rpc_equip_applied"):
		_active_handler.on_rpc_equip_applied(party_index, choice_id, equip_idx)


## Host -> All: Begin ultimate selection phase.
@rpc("authority", "call_remote", "reliable")
func _rpc_begin_ultimates() -> void:
	if not _active_handler:
		_start_ultimate_select()


## Host -> All: Show ultimate options as read-only mirror for non-owning peers.
@rpc("authority", "call_remote", "reliable")
func _rpc_show_ultimate_mirror(party_index: int, char_name: String,
		char_class: String) -> void:
	if _active_handler and _active_handler.has_method("on_rpc_show_ultimate_mirror"):
		_active_handler.on_rpc_show_ultimate_mirror(party_index, char_name, char_class)


## Host -> Guest: Request the owning player to choose an ultimate.
@rpc("authority", "call_remote", "reliable")
func _rpc_request_ultimate(party_index: int, char_name: String,
		char_class: String) -> void:
	if _active_handler and _active_handler.has_method("on_rpc_request_ultimate"):
		_active_handler.on_rpc_request_ultimate(party_index, char_name, char_class)


## Guest -> Host: Submit chosen ultimate.
@rpc("any_peer", "call_remote", "reliable")
func _rpc_submit_ultimate(party_index: int, ultimate_id: String) -> void:
	if not NetManager.is_host:
		return
	if _active_handler and _active_handler.has_method("on_rpc_submit_ultimate"):
		_active_handler.on_rpc_submit_ultimate(party_index, ultimate_id)


## Host -> All: Broadcast ultimate result so all peers update their party.
@rpc("authority", "call_remote", "reliable")
func _rpc_ultimate_applied(party_index: int, ultimate_id: String) -> void:
	if _active_handler and _active_handler.has_method("on_rpc_ultimate_applied"):
		_active_handler.on_rpc_ultimate_applied(party_index, ultimate_id)


## Any -> All: Sync which option the active player is focusing (for mirror viewers).
@rpc("any_peer", "call_remote", "reliable")
func _rpc_mirror_focus(index: int) -> void:
	if _active_handler and _active_handler.has_method("on_rpc_mirror_focus"):
		_active_handler.on_rpc_mirror_focus(index)
