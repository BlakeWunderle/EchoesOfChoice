extends Control

## Town stop scene. Shows narrative, per-character class upgrades, branch choices.
## Flow: pre_battle_text → per-character upgrade picks → post_battle_text → branch/advance.

const DialoguePanel := preload("res://scripts/ui/dialogue_panel.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const ClassInfoPanel := preload("res://scripts/ui/class_info_panel.gd")
const ReadyGate := preload("res://scripts/ui/ready_gate.gd")
const VotePanel := preload("res://scripts/ui/vote_panel.gd")
const TipOverlay := preload("res://scripts/ui/tip_overlay.gd")
const WaitingOverlay := preload("res://scripts/ui/waiting_overlay.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")
const FighterDB := preload("res://scripts/data/fighter_db.gd")
const ShopDB := preload("res://scripts/data/shop_db.gd")
const ItemDB := preload("res://scripts/data/item_db.gd")
const ItemData := preload("res://scripts/data/item_data.gd")
const TownEquipmentHandler := preload("res://scripts/ui/town_equipment_handler.gd")
const TownUltimateHandler := preload("res://scripts/ui/town_ultimate_handler.gd")

enum TownPhase { INTRO_TEXT, UPGRADING, UPGRADE_REVEAL, EQUIPPING, ULTIMATE_SELECT, SHOPPING, OUTRO_TEXT, BRANCH_CHOICE }

var _dialogue: DialoguePanel
var _choice_menu: ChoiceMenu
var _ready_gate: ReadyGate
var _vote_panel: VotePanel
var _pending_advance: Callable
var _tip_overlay: TipOverlay
var _waiting_overlay: WaitingOverlay
var _upgrade_label: Label
var _class_info_panel: ClassInfoPanel
var _scene_image: TextureRect
var _player_indicator: Label
var _phase: TownPhase = TownPhase.INTRO_TEXT
var _upgrade_index: int = 0  ## Which party member is choosing
var _upgrade_class_ids: Array[String] = []  ## Class IDs for current upgrade options (for panel)
var _shop_items: Array = []  ## Current shop inventory [{item_id, price}]
var _gold_label: Label
var _equip_handler: TownEquipmentHandler  ## Equipment upgrade phase handler
var _equip_sub_phase: String = "slot"     ## "slot" or "upgrade"
var _ult_handler: TownUltimateHandler    ## Ultimate ability selection handler


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

	_upgrade_label = Label.new()
	_upgrade_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_upgrade_label.add_theme_font_size_override("font_size", 28)
	_upgrade_label.visible = false
	vbox.add_child(_upgrade_label)

	_choice_menu = ChoiceMenu.new()
	_choice_menu.visible = false
	_choice_menu.choice_selected.connect(_on_choice_selected)
	_choice_menu.option_focused.connect(_on_option_focused)
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

	# Class info panel (bottom half, shown during upgrade selection)
	var info_margin := MarginContainer.new()
	info_margin.anchor_left = 0.0
	info_margin.anchor_top = 0.5
	info_margin.anchor_right = 1.0
	info_margin.anchor_bottom = 1.0
	info_margin.add_theme_constant_override("margin_left", 80)
	info_margin.add_theme_constant_override("margin_right", 80)
	info_margin.add_theme_constant_override("margin_top", 8)
	info_margin.add_theme_constant_override("margin_bottom", 20)
	add_child(info_margin)

	_class_info_panel = ClassInfoPanel.new()
	_class_info_panel.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	info_margin.add_child(_class_info_panel)

	_tip_overlay = TipOverlay.new()
	add_child(_tip_overlay)

	_waiting_overlay = WaitingOverlay.new()
	add_child(_waiting_overlay)

	# Local co-op player indicator
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
		_begin_upgrades()


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
			TownPhase.UPGRADE_REVEAL:
				_show_ready_gate(_do_reveal_advance)
			TownPhase.EQUIPPING:
				_show_ready_gate(_do_equip_narration_advance)
			TownPhase.ULTIMATE_SELECT:
				_show_ready_gate(_do_ult_narration_advance)
			TownPhase.SHOPPING:
				_show_ready_gate(_do_shop_menu_open)
			TownPhase.OUTRO_TEXT:
				_show_ready_gate(_do_outro_advance)
		return

	_do_text_advance()


func _do_text_advance() -> void:
	match _phase:
		TownPhase.INTRO_TEXT:
			_do_intro_advance()
		TownPhase.UPGRADE_REVEAL:
			_do_reveal_advance()
		TownPhase.EQUIPPING:
			_do_equip_narration_advance()
		TownPhase.ULTIMATE_SELECT:
			_do_ult_narration_advance()
		TownPhase.SHOPPING:
			_do_shop_menu_open()
		TownPhase.OUTRO_TEXT:
			_do_outro_advance()


func _do_equip_narration_advance() -> void:
	_dialogue.visible = false
	if _equip_handler:
		_equip_handler.on_narration_done()


func _do_intro_advance() -> void:
	if NetManager.is_multiplayer_active:
		if NetManager.is_host:
			_rpc_begin_upgrades.rpc()
		else:
			# Guest: wait for host's _rpc_begin_upgrades to drive the flow
			return
	_begin_upgrades()


func _do_reveal_advance() -> void:
	if NetManager.is_multiplayer_active and not NetManager.is_host:
		# Guest: wait for host's _rpc_advance_upgrade instead of advancing locally.
		# Don't hide dialogue — keep upgrade text visible until host advances.
		return
	_dialogue.visible = false
	_upgrade_index += 1
	if NetManager.is_multiplayer_active:
		_rpc_advance_upgrade.rpc(_upgrade_index)
	_show_next_upgrade()


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
	_ready_gate.mark_ready(player_index)


func _on_all_ready() -> void:
	if _pending_advance.is_valid():
		var cb := _pending_advance
		_pending_advance = Callable()
		cb.call_deferred()




func _begin_upgrades() -> void:
	_phase = TownPhase.UPGRADING
	_upgrade_index = 0
	_dialogue.visible = false
	_tip_overlay.show_tip_once("first_town",
		"Town stops let you upgrade your party. " +
		"Each character can evolve into a specialized class.\n\n" +
		"Tier 0 classes upgrade to Tier 1, " +
		"and Tier 1 upgrades to Tier 2. " +
		"Each upgrade unlocks new abilities and improves stats.\n\n" +
		"Choose wisely. Upgrades are permanent!")
	_show_next_upgrade()


func _show_next_upgrade() -> void:
	_waiting_overlay.hide_waiting()
	# Skip party members with no upgrades available
	while _upgrade_index < GameState.party.size() \
			and GameState.party[_upgrade_index].upgrade_items.is_empty():
		_upgrade_index += 1

	if _upgrade_index >= GameState.party.size():
		_finish_upgrades()
		return

	var fighter: FighterData = GameState.party[_upgrade_index]
	_phase = TownPhase.UPGRADING

	# Local co-op: gate input to the owning player
	if LocalCoop.is_active:
		var owner: int = LocalCoop.get_player_for_slot(_upgrade_index)
		LocalCoop.set_active_player(owner)
		_player_indicator.text = "Player %d" % (owner + 1)
		_player_indicator.visible = true

	# Multiplayer: host drives all upgrades via RPCs
	if NetManager.is_multiplayer_active:
		if NetManager.is_host:
			var items: Array[String] = fighter.upgrade_items.duplicate()
			# Broadcast mirror to all peers (non-owners show disabled view)
			_rpc_show_upgrade_mirror.rpc(_upgrade_index, fighter.character_name,
				fighter.character_type, items)
			if NetManager.is_my_fighter(_upgrade_index):
				# Host's own character — show choice menu locally
				_upgrade_label.text = "%s the %s. Choose an upgrade:" % [
					fighter.character_name, fighter.character_type]
				_upgrade_label.visible = true
				var options: Array[Dictionary] = _format_upgrade_options(fighter)
				_choice_menu.show_choices(options)
			else:
				# Remote player's character — send request and wait
				var owner_name: String = NetManager.get_fighter_owner_name(_upgrade_index)
				_upgrade_label.visible = false
				_choice_menu.visible = false
				_waiting_overlay.show_waiting(owner_name)
				var owner_peer: int = NetManager.get_fighter_owner_peer(_upgrade_index)
				_rpc_request_upgrade.rpc_id(owner_peer, _upgrade_index, fighter.character_name,
					fighter.character_type, items)
		else:
			# Guest: wait for mirror RPC or request_upgrade RPC
			_upgrade_label.visible = false
			_choice_menu.visible = false
		return

	_upgrade_label.text = "%s the %s. Choose an upgrade:" % [
		fighter.character_name, fighter.character_type]
	_upgrade_label.visible = true

	var options: Array[Dictionary] = _format_upgrade_options(fighter)
	_choice_menu.show_choices(options)


func _format_upgrade_options(fighter: FighterData) -> Array[Dictionary]:
	var options: Array[Dictionary] = []
	_upgrade_class_ids.clear()
	for item: String in fighter.upgrade_items:
		var preview: Dictionary = FighterDB.preview_upgrade(fighter, item)
		if preview.is_empty():
			options.append({"label": item})
			_upgrade_class_ids.append("")
			continue
		_upgrade_class_ids.append(preview.get("new_class_id", ""))
		var parts: Array[String] = []
		for key: String in preview["deltas"]:
			var diff: int = preview["deltas"][key]
			parts.append("%s%d %s" % ["+" if diff > 0 else "", diff, key])
		var desc: String = preview["new_class"]
		if not parts.is_empty():
			desc += "  |  " + ", ".join(parts)
		options.append({"label": item, "description": desc})
	return options


func _on_choice_selected(index: int) -> void:
	_class_info_panel.visible = false
	match _phase:
		TownPhase.UPGRADING:
			_on_upgrade_selected(index)
		TownPhase.EQUIPPING:
			_on_equip_choice_selected(index)
		TownPhase.ULTIMATE_SELECT:
			_on_ult_choice_selected(index)
		TownPhase.SHOPPING:
			_on_shop_selected(index)
		TownPhase.BRANCH_CHOICE:
			_on_branch_selected(index)


func _on_option_focused(index: int) -> void:
	if _phase == TownPhase.UPGRADING:
		if index >= 0 and index < _upgrade_class_ids.size():
			var class_id: String = _upgrade_class_ids[index]
			if not class_id.is_empty():
				_class_info_panel.show_class(class_id)
			else:
				_class_info_panel.visible = false
		else:
			_class_info_panel.visible = false
		# Sync focus to mirror viewers
		if NetManager.is_multiplayer_active:
			_rpc_mirror_focus.rpc(index)
	elif _phase == TownPhase.SHOPPING:
		# Sync focus to mirror viewers
		if NetManager.is_multiplayer_active:
			_rpc_mirror_focus.rpc(index)
	else:
		_class_info_panel.visible = false


func _on_upgrade_selected(index: int) -> void:
	if LocalCoop.is_active:
		LocalCoop.clear_active_player()
		_player_indicator.visible = false

	var fighter: FighterData = GameState.party[_upgrade_index]
	var item: String = fighter.upgrade_items[index]

	# In multiplayer as guest: send choice to host instead of applying locally
	if NetManager.is_multiplayer_active and not NetManager.is_host:
		_rpc_submit_upgrade.rpc_id(1, _upgrade_index, item)
		_choice_menu.hide_menu()
		_upgrade_label.visible = false
		# Wait for host to broadcast the result
		return

	var old_name: String = fighter.character_name
	GameState.upgrade_party_member(fighter, item)
	var new_class: String = fighter.character_type
	CompendiumManager.record_class(fighter.class_id, new_class)
	GameLog.info("Upgrade: %s -> %s" % [old_name, new_class])

	# Broadcast upgrade result to all peers
	if NetManager.is_multiplayer_active:
		_rpc_upgrade_applied.rpc(_upgrade_index, item, old_name, new_class)

	_choice_menu.hide_menu()
	_upgrade_label.visible = false
	_phase = TownPhase.UPGRADE_REVEAL
	_dialogue.visible = true
	_dialogue.show_text([
		"%s takes the %s..." % [old_name, item],
		"%s is now a %s!" % [old_name, new_class],
	])
	_open_gate_early(_do_reveal_advance)


func _finish_upgrades() -> void:
	# Level up party after upgrades
	GameState.level_up_party()

	# Check for equipment upgrades before shop
	_start_equipping()


func _start_equipping() -> void:
	_equip_handler = TownEquipmentHandler.new()
	_equip_handler.narration_requested.connect(_on_equip_narration)
	_equip_handler.choices_requested.connect(_on_equip_choices)
	_equip_handler.upgrade_complete.connect(_on_equip_upgrade_complete)
	_equip_handler.phase_finished.connect(_on_equip_finished)
	_phase = TownPhase.EQUIPPING
	_equip_sub_phase = "slot"
	_equip_handler.start(GameState.party, GameState.current_story_id)


func _on_equip_narration(lines: Array) -> void:
	_dialogue.visible = true
	_dialogue.show_text(lines)


func _on_equip_choices(options: Array, header: String) -> void:
	_dialogue.visible = false
	_upgrade_label.text = header
	_upgrade_label.visible = true
	_class_info_panel.visible = false
	_choice_menu.show_choices(options)
	_equip_sub_phase = _equip_handler.get_sub_phase()


func _on_equip_upgrade_complete(_char_index: int, slot_name: String,
		equip_name: String) -> void:
	GameLog.info("Equipment: upgraded %s (%s)" % [equip_name, slot_name])


func _on_equip_finished() -> void:
	_choice_menu.hide_menu()
	_upgrade_label.visible = false
	_equip_handler = null

	# Check for ultimate selection before shop
	_start_ultimate_select()


func _start_ultimate_select() -> void:
	_ult_handler = TownUltimateHandler.new()
	_ult_handler.narration_requested.connect(_on_ult_narration)
	_ult_handler.choices_requested.connect(_on_ult_choices)
	_ult_handler.selection_complete.connect(_on_ult_selection_complete)
	_ult_handler.phase_finished.connect(_on_ult_finished)
	_phase = TownPhase.ULTIMATE_SELECT
	_ult_handler.start(GameState.party)


func _do_ult_narration_advance() -> void:
	_dialogue.visible = false
	if _ult_handler:
		_ult_handler.on_narration_done()


func _on_ult_narration(lines: Array) -> void:
	_dialogue.visible = true
	_dialogue.show_text(lines)


func _on_ult_choices(options: Array, header: String) -> void:
	_dialogue.visible = false
	_upgrade_label.text = header
	_upgrade_label.visible = true
	_class_info_panel.visible = false
	_choice_menu.show_choices(options)

	# Local co-op: gate input to the owning player
	if LocalCoop.is_active:
		var owner: int = LocalCoop.get_player_for_slot(_ult_handler.get_current_char_index())
		LocalCoop.set_active_player(owner)
		_player_indicator.text = "Player %d" % (owner + 1)
		_player_indicator.visible = true


func _on_ult_selection_complete(_char_index: int, ultimate_name: String) -> void:
	GameLog.info("Ultimate: selected %s" % ultimate_name)


func _on_ult_choice_selected(index: int) -> void:
	if _ult_handler == null:
		return
	if LocalCoop.is_active:
		LocalCoop.clear_active_player()
		_player_indicator.visible = false
	_ult_handler.on_choice_selected(index)


func _on_ult_finished() -> void:
	_choice_menu.hide_menu()
	_upgrade_label.visible = false
	_ult_handler = null

	_check_shop_or_advance()


func _check_shop_or_advance() -> void:
	# Check for shop before outro
	var battle = GameState.current_battle
	_shop_items = ShopDB.get_shop_items(battle.battle_id)
	if not _shop_items.is_empty() and GameState.inventory.gold > 0:
		_start_shopping()
		return

	_show_outro_or_advance()


func _show_outro_or_advance() -> void:
	var battle = GameState.current_battle
	if not battle.post_battle_text.is_empty():
		_phase = TownPhase.OUTRO_TEXT
		_dialogue.visible = true
		_dialogue.show_text(battle.post_battle_text)
		_open_gate_early(_do_outro_advance)
	else:
		_check_branch_or_advance()


func _start_shopping() -> void:
	_phase = TownPhase.SHOPPING

	# Show shop narration if available
	var battle = GameState.current_battle
	var shop_text: Array[String] = ShopDB.get_shop_text(battle.battle_id)
	if not shop_text.is_empty():
		_dialogue.visible = true
		_upgrade_label.visible = false
		_dialogue.show_text(shop_text)
		_pending_advance = _do_shop_menu_open
		return

	_do_shop_menu_open()


func _do_shop_menu_open() -> void:
	_dialogue.visible = false
	_upgrade_label.text = "Shop"
	_upgrade_label.visible = true

	_tip_overlay.show_tip_once("first_shop",
		"Spend gold earned from battle to buy items. " +
		"Items can be used during battle as a turn action.\n\n" +
		"Your inventory holds up to 5 items.")

	# Online multiplayer: only host interacts, guests see read-only mirror
	if NetManager.is_multiplayer_active and not NetManager.is_host:
		_show_shop_menu_readonly()
		return

	if NetManager.is_multiplayer_active and NetManager.is_host:
		# Broadcast shop items to peers
		var items_data: Array = []
		for entry: Dictionary in _shop_items:
			items_data.append({"item_id": entry.item_id, "price": entry.price})
		_rpc_shop_opened.rpc(JSON.stringify(items_data))

	_show_shop_menu()


func _show_shop_menu_readonly() -> void:
	var options: Array[Dictionary] = []
	for entry: Dictionary in _shop_items:
		var item: ItemData = ItemDB.create_by_id(entry.item_id)
		if item:
			options.append({
				"label": "%s - %dg" % [item.item_name, entry.price],
				"description": item.get_use_description(),
				"disabled": true,
			})
		else:
			options.append({"label": entry.item_id, "disabled": true})
	options.append({"label": "Done Shopping", "disabled": true})

	var host_name: String = NetManager.get_fighter_owner_name(0)
	_upgrade_label.text = "%s is shopping  |  Gold: %d  |  Items: %d/%d" % [
		host_name, GameState.inventory.gold, GameState.inventory.size(), GameState.inventory.MAX_ITEMS]
	_upgrade_label.visible = true
	_choice_menu.show_choices(options)
	_choice_menu.highlight_option(0)


func _show_shop_menu() -> void:
	var options: Array[Dictionary] = []
	for entry: Dictionary in _shop_items:
		var item: ItemData = ItemDB.create_by_id(entry.item_id)
		if item:
			var affordable: String = "" if GameState.inventory.gold >= entry.price else " [not enough gold]"
			options.append({
				"label": "%s - %dg" % [item.item_name, entry.price],
				"description": item.get_use_description() + affordable,
			})
		else:
			options.append({"label": entry.item_id})
	options.append({"label": "Done Shopping"})

	# Update gold display
	_upgrade_label.text = "Shop  |  Gold: %d  |  Items: %d/%d" % [
		GameState.inventory.gold, GameState.inventory.size(), GameState.inventory.MAX_ITEMS]
	_upgrade_label.visible = true
	_choice_menu.show_choices(options)


func _on_equip_choice_selected(index: int) -> void:
	if _equip_handler == null:
		return
	if _equip_sub_phase == "slot":
		_equip_handler.on_slot_selected(index)
	else:
		_equip_handler.on_upgrade_selected(index)


func _on_shop_selected(index: int) -> void:
	# "Done Shopping" is the last option
	if index >= _shop_items.size():
		_choice_menu.hide_menu()
		_upgrade_label.visible = false
		if _gold_label:
			_gold_label.queue_free()
			_gold_label = null
		if NetManager.is_multiplayer_active and NetManager.is_host:
			_rpc_shop_closed.rpc()
		_show_outro_or_advance()
		return

	var entry: Dictionary = _shop_items[index]
	var price: int = entry.price
	if GameState.inventory.gold < price:
		# Can't afford - just re-show the menu
		_show_shop_menu()
		return

	if GameState.inventory.is_full():
		_dialogue.visible = true
		_dialogue.show_text(["Your inventory is full (%d/%d). Use or drop items in battle first." % [GameState.inventory.size(), GameState.inventory.MAX_ITEMS]])
		await get_tree().create_timer(1.5).timeout
		_dialogue.visible = false
		_show_shop_menu()
		return

	# Purchase the item
	GameState.inventory.spend_gold(price)
	var item: ItemData = ItemDB.create_by_id(entry.item_id)
	GameState.inventory.add_item(item)
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	GameLog.info("Shop: bought %s for %dg" % [item.item_name, price])

	# Broadcast to peers
	if NetManager.is_multiplayer_active and NetManager.is_host:
		_rpc_shop_purchase.rpc(entry.item_id, price)

	# Re-show menu (player can buy more)
	if GameState.inventory.gold <= 0:
		_choice_menu.hide_menu()
		_upgrade_label.visible = false
		if NetManager.is_multiplayer_active and NetManager.is_host:
			_rpc_shop_closed.rpc()
		_show_outro_or_advance()
		return
	_show_shop_menu()


func _check_branch_or_advance() -> void:
	var battle = GameState.current_battle
	if not battle.choices.is_empty():
		_phase = TownPhase.BRANCH_CHOICE
		_dialogue.visible = false
		var options: Array[Dictionary] = []
		for choice: Dictionary in battle.choices:
			options.append({"label": choice["label"]})

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
	_begin_upgrades()


## Host -> All: Advance to next upgrade index.
@rpc("authority", "call_remote", "reliable")
func _rpc_advance_upgrade(new_index: int) -> void:
	_dialogue.visible = false
	_upgrade_index = new_index
	_show_next_upgrade()


## Host -> Guest: Request the owning player to choose an upgrade.
@rpc("authority", "call_remote", "reliable")
func _rpc_request_upgrade(party_index: int, char_name: String, char_class: String,
		items: Array) -> void:
	_upgrade_index = party_index
	_phase = TownPhase.UPGRADING
	_waiting_overlay.hide_waiting()
	_upgrade_label.text = "%s the %s. Choose an upgrade:" % [char_name, char_class]
	_upgrade_label.visible = true
	var fighter: FighterData = GameState.party[party_index]
	var options: Array[Dictionary] = _format_upgrade_options(fighter)
	_choice_menu.show_choices(options)


## Host -> All: Show upgrade options as read-only mirror for non-owning peers.
@rpc("authority", "call_remote", "reliable")
func _rpc_show_upgrade_mirror(party_index: int, char_name: String, char_class: String,
		_items: Array) -> void:
	if NetManager.is_my_fighter(party_index):
		return  # I'm the one choosing, ignore mirror
	_upgrade_index = party_index
	_phase = TownPhase.UPGRADING
	_waiting_overlay.hide_waiting()
	_upgrade_label.text = "Choosing upgrade for %s the %s:" % [char_name, char_class]
	_upgrade_label.visible = true
	var fighter: FighterData = GameState.party[party_index]
	var options: Array[Dictionary] = _format_upgrade_options(fighter)
	for opt: Dictionary in options:
		opt["disabled"] = true
	_choice_menu.show_choices(options)
	# Show first option highlighted by default
	_choice_menu.highlight_option(0)
	if not _upgrade_class_ids.is_empty() and not _upgrade_class_ids[0].is_empty():
		_class_info_panel.show_class(_upgrade_class_ids[0])


## Guest -> Host: Submit chosen upgrade item.
@rpc("any_peer", "call_remote", "reliable")
func _rpc_submit_upgrade(party_index: int, item: String) -> void:
	if not NetManager.is_host:
		return
	var fighter: FighterData = GameState.party[party_index]
	var old_name: String = fighter.character_name
	GameState.upgrade_party_member(fighter, item)
	var new_class: String = fighter.character_type
	CompendiumManager.record_class(fighter.class_id, new_class)
	GameLog.info("Upgrade: %s -> %s (remote)" % [old_name, new_class])
	# Defer broadcast to avoid nested RPC issues (called from within RPC handler)
	_deferred_broadcast_upgrade.call_deferred(party_index, item, old_name, new_class)
	_waiting_overlay.hide_waiting()
	_choice_menu.hide_menu()
	_upgrade_label.visible = false
	_phase = TownPhase.UPGRADE_REVEAL
	_dialogue.visible = true
	_dialogue.show_text([
		"%s takes the %s..." % [old_name, item],
		"%s is now a %s!" % [old_name, new_class],
	])
	_open_gate_early(_do_reveal_advance)


func _deferred_broadcast_upgrade(party_index: int, item: String, old_name: String,
		new_class: String) -> void:
	_rpc_upgrade_applied.rpc(party_index, item, old_name, new_class)


## Host -> All: Broadcast upgrade result so all peers update their party.
@rpc("authority", "call_remote", "reliable")
func _rpc_upgrade_applied(party_index: int, item: String, old_name: String,
		new_class: String) -> void:
	var fighter: FighterData = GameState.party[party_index]
	GameState.upgrade_party_member(fighter, item)
	CompendiumManager.record_class(fighter.class_id, new_class)
	GameLog.info("Upgrade (sync): %s -> %s" % [old_name, new_class])
	_waiting_overlay.hide_waiting()
	_choice_menu.hide_menu()
	_upgrade_label.visible = false
	_phase = TownPhase.UPGRADE_REVEAL
	_dialogue.visible = true
	_dialogue.show_text([
		"%s takes the %s..." % [old_name, item],
		"%s is now a %s!" % [old_name, new_class],
	])
	_open_gate_early(_do_reveal_advance)


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


## Host -> All: Broadcast a shop purchase so peers update inventory + refresh mirror.
@rpc("authority", "call_remote", "reliable")
func _rpc_shop_purchase(item_id: String, price: int) -> void:
	GameState.inventory.spend_gold(price)
	var item: ItemData = ItemDB.create_by_id(item_id)
	if item:
		GameState.inventory.add_item(item)
	# Refresh the read-only mirror display
	if _phase == TownPhase.SHOPPING:
		_show_shop_menu_readonly()


## Host -> All: Shop opened with inventory list (guest receives items to display).
@rpc("authority", "call_remote", "reliable")
func _rpc_shop_opened(items_json: String) -> void:
	var parsed: Array = JSON.parse_string(items_json)
	if parsed == null:
		return
	_shop_items.clear()
	for entry in parsed:
		_shop_items.append({"item_id": entry["item_id"], "price": int(entry["price"])})
	_show_shop_menu_readonly()


## Host -> All: Shop closed, proceed to next phase.
@rpc("authority", "call_remote", "reliable")
func _rpc_shop_closed() -> void:
	_choice_menu.hide_menu()
	_upgrade_label.visible = false
	_show_outro_or_advance()


## Any -> All: Sync which option the active player is focusing (for mirror viewers).
@rpc("any_peer", "call_remote", "reliable")
func _rpc_mirror_focus(index: int) -> void:
	_choice_menu.highlight_option(index)
	# Show class info panel for upgrade options
	if _phase == TownPhase.UPGRADING and index >= 0 and index < _upgrade_class_ids.size():
		var class_id: String = _upgrade_class_ids[index]
		if not class_id.is_empty():
			_class_info_panel.show_class(class_id)
		else:
			_class_info_panel.visible = false
