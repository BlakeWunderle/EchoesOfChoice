class_name Inventory extends RefCounted

## Party-shared inventory for consumable items and gold.

const ItemData := preload("res://scripts/data/item_data.gd")

const MAX_ITEMS := 5

var _items: Array = []  ## Array of ItemData
var gold: int = 0


func add_item(item: ItemData) -> bool:
	if _items.size() >= MAX_ITEMS:
		return false
	_items.append(item)
	return true


func remove_at(index: int) -> void:
	if index >= 0 and index < _items.size():
		_items.remove_at(index)


func use_item(index: int) -> ItemData:
	if index < 0 or index >= _items.size():
		return null
	var item: ItemData = _items[index]
	_items.remove_at(index)
	return item


func get_item(index: int) -> ItemData:
	if index < 0 or index >= _items.size():
		return null
	return _items[index]


func get_items() -> Array:
	return _items


func size() -> int:
	return _items.size()


func is_full() -> bool:
	return _items.size() >= MAX_ITEMS


func add_gold(amount: int) -> void:
	gold += amount


func spend_gold(amount: int) -> bool:
	if gold < amount:
		return false
	gold -= amount
	return true


func clear() -> void:
	_items.clear()
	gold = 0


func to_save_data() -> Dictionary:
	var item_ids: Array[String] = []
	for item: ItemData in _items:
		item_ids.append(item.to_save_data())
	return {"items": item_ids, "gold": gold}


func apply_save_data(data: Dictionary) -> void:
	_items.clear()
	gold = data.get("gold", 0)
	var item_ids: Array = data.get("items", [])
	for id: String in item_ids:
		_items.append(ItemData.from_save_id(id))
