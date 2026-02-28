extends Control

signal closed

@onready var _buy_list: VBoxContainer = %BuyList
@onready var _sell_list: VBoxContainer = %SellList
@onready var _buy_tab: Button = %BuyTab
@onready var _sell_tab: Button = %SellTab
@onready var _gold_label: Label = %ShopGold
@onready var _detail_label: Label = %ItemDetail

var _shop_items: Array = []
var _mode: String = "buy"


func setup(item_ids: Array) -> void:
	_shop_items = item_ids
	_mode = "buy"
	_refresh()
	_buy_tab.grab_focus()


func _refresh() -> void:
	_gold_label.text = "Gold: %d" % GameState.gold
	_detail_label.text = ""
	if _mode == "buy":
		_buy_list.visible = true
		_sell_list.visible = false
		_refresh_buy()
	else:
		_buy_list.visible = false
		_sell_list.visible = true
		_refresh_sell()


func _refresh_buy() -> void:
	for child in _buy_list.get_children():
		child.queue_free()
	for item_id in _shop_items:
		var item: Resource = GameState.get_item_resource(item_id)
		if not item:
			continue
		var btn := Button.new()
		var price: int = item.get("cost") if item.get("cost") != null else 0
		btn.text = "%s  (%d gold)" % [item.get("item_name") if item.get("item_name") else item_id, price]
		btn.custom_minimum_size = Vector2(0, 36)
		btn.disabled = not GameState.can_afford(price)
		var iid := item_id
		var pr := price
		btn.pressed.connect(func(): _buy_item(iid, pr))
		btn.focus_entered.connect(func(): _show_detail(item))
		_buy_list.add_child(btn)


func _refresh_sell() -> void:
	for child in _sell_list.get_children():
		child.queue_free()
	for item_id in GameState.inventory:
		var qty: int = GameState.inventory[item_id]
		if qty <= 0:
			continue
		var item: Resource = GameState.get_item_resource(item_id)
		if not item:
			continue
		var sell_price: int = int(item.get("cost") * 0.5) if item.get("cost") else 0
		var btn := Button.new()
		btn.text = "%s x%d  (%d gold)" % [
			item.get("item_name") if item.get("item_name") else item_id,
			qty, sell_price]
		btn.custom_minimum_size = Vector2(0, 36)
		var iid := item_id
		var sp := sell_price
		btn.pressed.connect(func(): _sell_item(iid, sp))
		btn.focus_entered.connect(func(): _show_detail(item))
		_sell_list.add_child(btn)


func _buy_item(item_id: String, price: int) -> void:
	if GameState.spend_gold(price):
		GameState.add_item(item_id)
		_refresh()


func _sell_item(item_id: String, price: int) -> void:
	if GameState.remove_item(item_id):
		GameState.add_gold(price)
		_refresh()


func _show_detail(item: Resource) -> void:
	var text := ""
	if item.get("item_name"):
		text += str(item.item_name) + "\n"
	if item.get("flavor_text"):
		text += str(item.flavor_text)
	_detail_label.text = text


func _on_buy_tab() -> void:
	_mode = "buy"
	_refresh()


func _on_sell_tab() -> void:
	_mode = "sell"
	_refresh()


func _on_close() -> void:
	closed.emit()
