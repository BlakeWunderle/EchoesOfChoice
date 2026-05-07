class_name TownShopHandler extends Control

## Self-contained shop phase for town stops.
## Builds its own full-screen UI: item list, pagination, discard sub-phase.

const DialoguePanel := preload("res://scripts/ui/dialogue_panel.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const TipOverlay := preload("res://scripts/ui/tip_overlay.gd")
const ReadyGate := preload("res://scripts/ui/ready_gate.gd")
const PaginationControls := preload("res://scripts/ui/compendium/pagination_controls.gd")
const ItemDB := preload("res://scripts/data/item_db.gd")
const ItemData := preload("res://scripts/data/item_data.gd")
const ShopDB := preload("res://scripts/data/shop_db.gd")

signal phase_finished
signal purchase_made(item_id: String, price: int)
signal discard_and_buy(discard_index: int, item_id: String, price: int)
signal shop_opened_broadcast(items_json: String)
signal shop_closed_broadcast

const PAGE_SIZE: int = 5

enum ShopPhase { NARRATION, BROWSING, DISCARD }

var _shop_items: Array = []
var _battle_id: String = ""
var _is_host: bool = true
var _is_multiplayer: bool = false
var _is_readonly: bool = false

var _phase: ShopPhase = ShopPhase.NARRATION
var _page: int = 0
var _pending_buy_id: String = ""
var _pending_buy_price: int = 0

var _dialogue: DialoguePanel
var _choice_menu: ChoiceMenu
var _header_label: Label
var _pagination: PaginationControls
var _tip_overlay: TipOverlay
var _ready_gate: ReadyGate


func _init(params: Dictionary) -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_shop_items = params.get("shop_items", [])
	_battle_id = params.get("battle_id", "")
	_is_host = params.get("is_host", true)
	_is_multiplayer = params.get("is_multiplayer", false)
	_is_readonly = params.get("is_readonly", false)


func _ready() -> void:
	_build_ui()
	_start()


func _build_ui() -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
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
	vbox.add_child(_choice_menu)

	_pagination = PaginationControls.new()
	_pagination.visible = false
	_pagination.page_changed.connect(_on_page_changed)
	vbox.add_child(_pagination)

	_ready_gate = ReadyGate.new()
	_ready_gate.visible = false
	_ready_gate.all_ready.connect(_on_all_ready)
	vbox.add_child(_ready_gate)

	_tip_overlay = TipOverlay.new()
	add_child(_tip_overlay)


func _start() -> void:
	_page = 0

	var shop_text: Array[String] = ShopDB.get_shop_text(_battle_id)
	if not shop_text.is_empty():
		_phase = ShopPhase.NARRATION
		_dialogue.visible = true
		_dialogue.show_text(shop_text)
		if _is_multiplayer:
			_ready_gate.visible = true
			_ready_gate.reset(NetManager.target_player_count if NetManager.is_multiplayer_active else 1)
		return

	_open_menu()


func _on_text_finished() -> void:
	if _is_multiplayer and NetManager.is_multiplayer_active:
		_ready_gate.mark_ready(multiplayer.get_unique_id())
		return
	if LocalCoop.is_active:
		_ready_gate.visible = true
		_ready_gate.reset(LocalCoop.player_count)
		_ready_gate.mark_ready(1)
		return
	_open_menu()


func _on_all_ready() -> void:
	_ready_gate.visible = false
	_open_menu()


func _open_menu() -> void:
	_dialogue.visible = false
	_phase = ShopPhase.BROWSING

	_tip_overlay.show_tip_once("first_shop",
		"Spend gold earned from battle to buy items. " +
		"Items can be used during battle as a turn action.\n\n" +
		"Your inventory holds up to 5 items.")

	if _is_readonly:
		_show_readonly()
		return

	if _is_multiplayer and _is_host:
		var items_data: Array = []
		for entry: Dictionary in _shop_items:
			items_data.append({"item_id": entry.item_id, "price": entry.price})
		shop_opened_broadcast.emit(JSON.stringify(items_data))

	_show_menu()


func _show_readonly() -> void:
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
	_header_label.text = "%s is shopping  |  Gold: %d  |  Items: %d/%d" % [
		host_name, GameState.inventory.gold, GameState.inventory.size(), GameState.inventory.MAX_ITEMS]
	_header_label.visible = true
	_choice_menu.show_choices(options)
	_choice_menu.highlight_option(0)


func _show_menu() -> void:
	var total: int = _shop_items.size()
	var page_count: int = ceili(float(total) / PAGE_SIZE)
	if _page >= page_count:
		_page = maxi(page_count - 1, 0)
	var start: int = _page * PAGE_SIZE
	var end_idx: int = mini(start + PAGE_SIZE, total)

	var options: Array[Dictionary] = []
	for i: int in range(start, end_idx):
		var entry: Dictionary = _shop_items[i]
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

	_header_label.text = "Shop  |  Gold: %d  |  Items: %d/%d" % [
		GameState.inventory.gold, GameState.inventory.size(), GameState.inventory.MAX_ITEMS]
	_header_label.visible = true
	_choice_menu.show_choices(options)

	_pagination.total_pages = page_count
	_pagination.current_page = _page + 1
	_pagination.visible = page_count > 1

	if page_count > 1:
		var last_btn: Button = _choice_menu.get_last_button()
		if last_btn:
			last_btn.focus_neighbor_bottom = _pagination.get_focus_target().get_path()
			_pagination.set_top_neighbor(last_btn)


func _on_choice_selected(index: int) -> void:
	match _phase:
		ShopPhase.BROWSING:
			_on_shop_selected(index)
		ShopPhase.DISCARD:
			_on_discard_selected(index)


func _on_shop_selected(index: int) -> void:
	var start: int = _page * PAGE_SIZE
	var end_idx: int = mini(start + PAGE_SIZE, _shop_items.size())
	var items_on_page: int = end_idx - start

	if index >= items_on_page:
		_finish()
		return

	var actual_index: int = start + index
	var entry: Dictionary = _shop_items[actual_index]
	var price: int = entry.price
	if GameState.inventory.gold < price:
		_show_menu()
		return
	if GameState.inventory.is_full():
		_pending_buy_id = entry.item_id
		_pending_buy_price = price
		_show_discard()
		return
	GameState.inventory.spend_gold(price)
	var item: ItemData = ItemDB.create_by_id(entry.item_id)
	GameState.inventory.add_item(item)
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	GameLog.info("Shop: bought %s for %dg" % [item.item_name, price])
	purchase_made.emit(entry.item_id, price)
	if GameState.inventory.gold <= 0:
		_finish()
		return
	_show_menu()


func _on_page_changed(new_page: int) -> void:
	_page = new_page - 1
	_show_menu()


func _show_discard() -> void:
	_phase = ShopPhase.DISCARD
	var items: Array = GameState.inventory.get_items()
	var options: Array[Dictionary] = []
	for i: int in items.size():
		var item: ItemData = items[i]
		options.append({"label": item.item_name, "description": item.get_use_description()})
	options.append({"label": "Cancel"})
	_header_label.text = "Inventory full -- discard an item to make room"
	_header_label.visible = true
	_choice_menu.show_choices(options)


func _on_discard_selected(index: int) -> void:
	var items: Array = GameState.inventory.get_items()
	if index >= items.size():
		_pending_buy_id = ""
		_pending_buy_price = 0
		_phase = ShopPhase.BROWSING
		_show_menu()
		return

	GameState.inventory.remove_at(index)
	GameLog.info("Shop: discarded %s to make room" % items[index].item_name)

	GameState.inventory.spend_gold(_pending_buy_price)
	var item: ItemData = ItemDB.create_by_id(_pending_buy_id)
	GameState.inventory.add_item(item)
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	GameLog.info("Shop: bought %s for %dg" % [item.item_name, _pending_buy_price])
	discard_and_buy.emit(index, _pending_buy_id, _pending_buy_price)

	_pending_buy_id = ""
	_pending_buy_price = 0
	_phase = ShopPhase.BROWSING

	if GameState.inventory.gold <= 0:
		_finish()
		return
	_show_menu()


func _finish() -> void:
	_choice_menu.hide_menu()
	_header_label.visible = false
	_pagination.visible = false
	shop_closed_broadcast.emit()
	phase_finished.emit()


func _input(event: InputEvent) -> void:
	if not _choice_menu.visible:
		return
	if _is_readonly:
		return
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("cancel"):
		if _phase == ShopPhase.DISCARD:
			_on_discard_selected(GameState.inventory.size())
		else:
			_finish()
		get_viewport().set_input_as_handled()


## Called by town_stop when receiving _rpc_shop_purchase from host.
func on_rpc_purchase(_item_id: String, _price: int) -> void:
	if _is_readonly:
		_show_readonly()


## Called by town_stop when receiving _rpc_shop_discard_and_buy from host.
func on_rpc_discard_and_buy(_discard_index: int, _item_id: String, _price: int) -> void:
	if _is_readonly:
		_show_readonly()


## Called by town_stop when receiving _rpc_shop_opened from host (guest side).
func on_rpc_shop_opened(items_json: String) -> void:
	var parsed: Array = JSON.parse_string(items_json)
	if parsed == null:
		return
	_shop_items.clear()
	for entry in parsed:
		_shop_items.append({"item_id": entry["item_id"], "price": int(entry["price"])})
	_show_readonly()


## Called by town_stop when receiving _rpc_shop_closed from host.
func on_rpc_shop_closed() -> void:
	_choice_menu.hide_menu()
	_header_label.visible = false
	phase_finished.emit()
