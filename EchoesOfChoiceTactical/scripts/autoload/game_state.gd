extends Node

var player_name: String = ""
var player_gender: String = ""
var player_class_id: String = ""

var party_members: Array[Dictionary] = []

var progression_stage: int = 0
var current_battle_id: String = ""
var current_town_id: String = ""
var story_flags: Dictionary = {}

var completed_battles: Array[String] = []
var locked_nodes: Array[String] = []

var gold: int = 0
var inventory: Dictionary = {}
var equipment: Dictionary = {}

const SAVE_PATH := "user://savegame.json"


func set_player_info(p_name: String, p_gender: String) -> void:
	player_name = p_name
	player_gender = p_gender


func set_player_class(class_id: String) -> void:
	player_class_id = class_id


func add_party_member(p_name: String, p_gender: String, class_id: String, level: int = 1) -> void:
	party_members.append({
		"name": p_name,
		"gender": p_gender,
		"class_id": class_id,
		"level": level,
		"xp": 0,
		"jp": 0,
	})


func get_party_size() -> int:
	return party_members.size()


func set_flag(flag: String, value: bool = true) -> void:
	story_flags[flag] = value


func has_flag(flag: String) -> bool:
	return story_flags.get(flag, false)


func complete_battle(battle_id: String) -> void:
	if battle_id not in completed_battles:
		completed_battles.append(battle_id)


func lock_nodes(node_ids: Array[String]) -> void:
	for nid in node_ids:
		if nid not in locked_nodes:
			locked_nodes.append(nid)


func is_battle_completed(battle_id: String) -> bool:
	return battle_id in completed_battles


func is_node_locked(node_id: String) -> bool:
	return node_id in locked_nodes


func update_party_after_battle(player_units: Array) -> void:
	for unit in player_units:
		if not unit is Unit:
			continue
		var u: Unit = unit
		if u.team != Enums.Team.PLAYER:
			continue
		if u.unit_name == player_name:
			# Player character (not in party_members array)
			continue
		for i in range(party_members.size()):
			if party_members[i]["name"] == u.unit_name:
				party_members[i]["level"] = u.level
				party_members[i]["xp"] = u.xp
				party_members[i]["jp"] = u.jp
				break


func advance_progression(battle_progression: int) -> void:
	if battle_progression > progression_stage:
		progression_stage = battle_progression


# --- Gold ---

func add_gold(amount: int) -> void:
	gold += amount


func spend_gold(amount: int) -> bool:
	if gold < amount:
		return false
	gold -= amount
	return true


func can_afford(amount: int) -> bool:
	return gold >= amount


# --- Inventory ---

func add_item(item_id: String, quantity: int = 1) -> void:
	inventory[item_id] = inventory.get(item_id, 0) + quantity


func remove_item(item_id: String, quantity: int = 1) -> bool:
	var owned: int = inventory.get(item_id, 0)
	if owned < quantity:
		return false
	owned -= quantity
	if owned <= 0:
		inventory.erase(item_id)
	else:
		inventory[item_id] = owned
	return true


func get_item_count(item_id: String) -> int:
	return inventory.get(item_id, 0)


func get_consumables_in_inventory() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for item_id in inventory:
		var qty: int = inventory[item_id]
		if qty <= 0:
			continue
		var item := _load_item(item_id)
		if item and item.is_consumable():
			result.append({"item": item, "quantity": qty})
	return result


# --- Equipment ---

func equip_item(unit_name: String, item_id: String) -> void:
	var item := _load_item(item_id)
	if not item or not item.is_equipment():
		return
	var slot_key := _slot_key(item.get_equip_slot())
	if not equipment.has(unit_name):
		equipment[unit_name] = {}
	var prev_id: String = equipment[unit_name].get(slot_key, "")
	if not prev_id.is_empty():
		add_item(prev_id)
	equipment[unit_name][slot_key] = item_id
	remove_item(item_id)


func unequip_item(unit_name: String, slot: Enums.EquipSlot) -> void:
	var slot_key := _slot_key(slot)
	if not equipment.has(unit_name):
		return
	var item_id: String = equipment[unit_name].get(slot_key, "")
	if item_id.is_empty():
		return
	equipment[unit_name].erase(slot_key)
	add_item(item_id)
	if equipment[unit_name].is_empty():
		equipment.erase(unit_name)


func get_equipped_item(unit_name: String, slot: Enums.EquipSlot) -> ItemData:
	var slot_key := _slot_key(slot)
	if not equipment.has(unit_name):
		return null
	var item_id: String = equipment[unit_name].get(slot_key, "")
	if item_id.is_empty():
		return null
	return _load_item(item_id)


func get_all_equipped(unit_name: String) -> Dictionary:
	if not equipment.has(unit_name):
		return {}
	return equipment[unit_name].duplicate()


func _slot_key(slot: Enums.EquipSlot) -> String:
	match slot:
		Enums.EquipSlot.WEAPON: return "weapon"
		Enums.EquipSlot.ARMOR: return "armor"
		Enums.EquipSlot.ACCESSORY: return "accessory"
	return "weapon"


func _load_item(item_id: String) -> ItemData:
	var path := "res://resources/items/%s.tres" % item_id
	if ResourceLoader.exists(path):
		return load(path) as ItemData
	return null


func reset_for_new_game() -> void:
	player_name = ""
	player_gender = ""
	player_class_id = ""
	party_members.clear()
	progression_stage = 0
	current_battle_id = ""
	story_flags.clear()
	completed_battles.clear()
	locked_nodes.clear()
	gold = 0
	inventory.clear()
	equipment.clear()


func save_game() -> void:
	var save_data := {
		"player_name": player_name,
		"player_gender": player_gender,
		"player_class_id": player_class_id,
		"party_members": party_members,
		"progression_stage": progression_stage,
		"current_battle": current_battle_id,
		"story_flags": story_flags,
		"completed_battles": completed_battles,
		"locked_nodes": locked_nodes,
		"gold": gold,
		"inventory": inventory,
		"equipment": equipment,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return false
	var json := JSON.new()
	var result := json.parse(file.get_as_text())
	file.close()
	if result != OK:
		return false
	var data: Dictionary = json.data
	player_name = data.get("player_name", "")
	player_gender = data.get("player_gender", "")
	player_class_id = data.get("player_class_id", "")
	party_members.assign(data.get("party_members", []))
	progression_stage = data.get("progression_stage", 0)
	current_battle_id = data.get("current_battle", "")
	story_flags = data.get("story_flags", {})
	var cb: Array = data.get("completed_battles", [])
	completed_battles.clear()
	for b in cb:
		completed_battles.append(str(b))
	var ln: Array = data.get("locked_nodes", [])
	locked_nodes.clear()
	for n in ln:
		locked_nodes.append(str(n))
	gold = int(data.get("gold", 0))
	inventory = data.get("inventory", {})
	equipment = data.get("equipment", {})
	return true


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
