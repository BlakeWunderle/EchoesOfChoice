extends Control

signal shop_closed

var shop_items: Array = []
var _mode: String = "buy"

@onready var gold_label: Label = $Panel/MarginContainer/VBox/Header/GoldLabel
@onready var buy_button: Button = $Panel/MarginContainer/VBox/Header/BuyTab
@onready var sell_button: Button = $Panel/MarginContainer/VBox/Header/SellTab
@onready var item_list: VBoxContainer = $Panel/MarginContainer/VBox/ScrollContainer/ItemList
@onready var detail_label: Label = $Panel/MarginContainer/VBox/DetailLabel
@onready var close_button: Button = $Panel/MarginContainer/VBox/CloseButton


func _ready() -> void:
	buy_button.pressed.connect(func(): _switch_mode("buy"))
	sell_button.pressed.connect(func(): _switch_mode("sell"))
	close_button.pressed.connect(func(): shop_closed.emit())
	_update_gold()
	_refresh_list()


func setup(items: Array) -> void:
	shop_items = items


func _switch_mode(mode: String) -> void:
	_mode = mode
	buy_button.disabled = (mode == "buy")
	sell_button.disabled = (mode == "sell")
	detail_label.text = ""
	_refresh_list()


func _update_gold() -> void:
	gold_label.text = "Gold: %d" % GameState.gold


func _refresh_list() -> void:
	for child in item_list.get_children():
		child.queue_free()

	if _mode == "buy":
		_populate_buy_list()
	else:
		_populate_sell_list()


func _populate_buy_list() -> void:
	if shop_items.is_empty():
		var empty := Label.new()
		empty.text = "No items for sale."
		empty.add_theme_font_size_override("font_size", 14)
		empty.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		item_list.add_child(empty)
		return

	for item in shop_items:
		if not item is ItemData:
			continue
		var row := _create_buy_row(item)
		item_list.add_child(row)


func _populate_sell_list() -> void:
	var has_items := false
	for item_id in GameState.inventory:
		var qty: int = GameState.inventory[item_id]
		if qty <= 0:
			continue
		var item: ItemData = _load_item(item_id)
		if not item:
			continue
		has_items = true
		var row := _create_sell_row(item, qty)
		item_list.add_child(row)

	if not has_items:
		var empty := Label.new()
		empty.text = "No items to sell."
		empty.add_theme_font_size_override("font_size", 14)
		empty.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		item_list.add_child(empty)


func _create_buy_row(item: ItemData) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)

	var name_lbl := Label.new()
	name_lbl.text = item.display_name
	name_lbl.custom_minimum_size = Vector2(160, 0)
	name_lbl.add_theme_font_size_override("font_size", 14)
	row.add_child(name_lbl)

	var type_lbl := Label.new()
	type_lbl.text = _type_label(item)
	type_lbl.custom_minimum_size = Vector2(80, 0)
	type_lbl.add_theme_font_size_override("font_size", 12)
	type_lbl.add_theme_color_override("font_color", Color(0.6, 0.7, 0.8))
	row.add_child(type_lbl)

	var stats_lbl := Label.new()
	stats_lbl.text = item.get_stat_summary()
	stats_lbl.custom_minimum_size = Vector2(180, 0)
	stats_lbl.add_theme_font_size_override("font_size", 12)
	stats_lbl.add_theme_color_override("font_color", Color(0.5, 0.9, 0.5))
	row.add_child(stats_lbl)

	var price_lbl := Label.new()
	price_lbl.text = "%dg" % item.buy_price
	price_lbl.custom_minimum_size = Vector2(50, 0)
	price_lbl.add_theme_font_size_override("font_size", 13)
	price_lbl.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
	row.add_child(price_lbl)

	var buy_btn := Button.new()
	buy_btn.text = "Buy"
	buy_btn.custom_minimum_size = Vector2(60, 28)
	buy_btn.add_theme_font_size_override("font_size", 12)
	var can_buy := GameState.can_afford(item.buy_price)
	buy_btn.disabled = not can_buy
	buy_btn.pressed.connect(_on_buy_pressed.bind(item))
	row.add_child(buy_btn)

	row.mouse_entered.connect(func(): _show_detail(item))

	return row


func _create_sell_row(item: ItemData, qty: int) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)

	var name_lbl := Label.new()
	name_lbl.text = item.display_name
	name_lbl.custom_minimum_size = Vector2(160, 0)
	name_lbl.add_theme_font_size_override("font_size", 14)
	row.add_child(name_lbl)

	var qty_lbl := Label.new()
	qty_lbl.text = "x%d" % qty
	qty_lbl.custom_minimum_size = Vector2(40, 0)
	qty_lbl.add_theme_font_size_override("font_size", 13)
	qty_lbl.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	row.add_child(qty_lbl)

	var stats_lbl := Label.new()
	stats_lbl.text = item.get_stat_summary()
	stats_lbl.custom_minimum_size = Vector2(180, 0)
	stats_lbl.add_theme_font_size_override("font_size", 12)
	stats_lbl.add_theme_color_override("font_color", Color(0.5, 0.9, 0.5))
	row.add_child(stats_lbl)

	var price_lbl := Label.new()
	price_lbl.text = "%dg" % item.get_sell_price()
	price_lbl.custom_minimum_size = Vector2(50, 0)
	price_lbl.add_theme_font_size_override("font_size", 13)
	price_lbl.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
	row.add_child(price_lbl)

	var sell_btn := Button.new()
	sell_btn.text = "Sell"
	sell_btn.custom_minimum_size = Vector2(60, 28)
	sell_btn.add_theme_font_size_override("font_size", 12)
	sell_btn.pressed.connect(_on_sell_pressed.bind(item))
	row.add_child(sell_btn)

	row.mouse_entered.connect(func(): _show_detail(item))

	return row


func _on_buy_pressed(item: ItemData) -> void:
	if not GameState.spend_gold(item.buy_price):
		return
	GameState.add_item(item.item_id)
	_update_gold()
	_refresh_list()


func _on_sell_pressed(item: ItemData) -> void:
	if not GameState.remove_item(item.item_id):
		return
	GameState.add_gold(item.get_sell_price())
	_update_gold()
	_refresh_list()


func _show_detail(item: ItemData) -> void:
	detail_label.text = item.description if not item.description.is_empty() else item.display_name


func _type_label(item: ItemData) -> String:
	match item.item_type:
		Enums.ItemType.CONSUMABLE: return "[Use]"
		Enums.ItemType.EQUIPMENT: return "[Equip]"
	return ""


func _load_item(item_id: String) -> ItemData:
	var path := "res://resources/items/%s.tres" % item_id
	if ResourceLoader.exists(path):
		return load(path) as ItemData
	path = "res://resources/items/equipment/%s.tres" % item_id
	if ResourceLoader.exists(path):
		return load(path) as ItemData
	return null
