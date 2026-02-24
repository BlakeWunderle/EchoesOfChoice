extends Node

# Only preload enums (no dependencies). Other types use Resource/duck typing to avoid load-order issues.
const _enums = preload("res://scripts/data/enums.gd")

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

var unlocked_classes: Array[String] = []
var selected_party: Array[String] = []
var player_level: int = 1

var fired_travel_event_ids: Array[String] = []

const REST_HEAL_FRACTION := 0.30

var current_slot: int = -1  # -1 = not loaded from a slot yet
var _save_manager = preload("res://scripts/autoload/save_load_manager.gd").new()


func set_player_info(p_name: String, p_gender: String) -> void:
	player_name = p_name
	player_gender = p_gender
	unlock_class(p_gender)


func set_player_class(class_id: String) -> void:
	player_class_id = class_id
	unlock_class(class_id)


func add_party_member(p_name: String, p_gender: String, class_id: String, level: int = 1) -> void:
	party_members.append({
		"name": p_name,
		"gender": p_gender,
		"class_id": class_id,
		"level": level,
		"xp": 0,
		"jp": 0,
		"current_hp": -1,
		"current_mp": -1,
	})
	unlock_class(class_id)


func remove_party_member(member_name: String) -> void:
	for i in range(party_members.size() - 1, -1, -1):
		if party_members[i]["name"] == member_name:
			party_members.remove_at(i)
			break


func get_party_size() -> int:
	return party_members.size()


# --- Class Unlock ---

func unlock_class(class_id: String) -> void:
	if class_id not in unlocked_classes:
		unlocked_classes.append(class_id)


func is_class_unlocked(class_id: String) -> bool:
	return class_id in unlocked_classes


func get_lowest_party_level() -> int:
	var lowest := player_level
	for member in party_members:
		var lvl: int = member.get("level", 1)
		if lvl < lowest:
			lowest = lvl
	return lowest


const RECRUIT_COST_BY_TIER := [100, 300, 600]

func get_recruit_cost(class_id: String) -> int:
	var path := "res://resources/classes/%s.tres" % class_id
	if ResourceLoader.exists(path):
		var data: Resource = load(path) as Resource
		if data and "tier" in data:
			var tier_idx: int = clampi(data.tier, 0, RECRUIT_COST_BY_TIER.size() - 1)
			return RECRUIT_COST_BY_TIER[tier_idx]
	return RECRUIT_COST_BY_TIER[0]


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


func update_party_after_battle(player_units: Array) -> Array[String]:
	var fallen: Array[String] = []
	for unit in player_units:
		if not ("team" in unit and "unit_name" in unit and "is_alive" in unit):
			continue
		if unit.team != _enums.Team.PLAYER:
			continue
		if not unit.is_alive:
			if unit.unit_name == player_name:
				fallen.insert(0, unit.unit_name)
			else:
				fallen.append(unit.unit_name)
				remove_party_member(unit.unit_name)
			continue
		if unit.unit_name == player_name:
			player_level = unit.level
			continue
		for i in range(party_members.size()):
			if party_members[i]["name"] == unit.unit_name:
				party_members[i]["level"] = unit.level
				party_members[i]["xp"] = unit.xp
				party_members[i]["jp"] = unit.jp
				party_members[i]["current_hp"] = unit.health
				party_members[i]["current_mp"] = unit.mana
				break
	return fallen


func advance_progression(battle_progression: int) -> void:
	if battle_progression > progression_stage:
		progression_stage = battle_progression


# --- HP/MP Tracking ---

func get_member_max_hp(member: Dictionary) -> int:
	var path := "res://resources/classes/%s.tres" % member.get("class_id", "")
	if ResourceLoader.exists(path):
		var data: Resource = load(path) as Resource
		if data and data.has_method("get_stats_at_level"):
			var stats: Dictionary = data.get_stats_at_level(member.get("level", 1))
			return int(stats.get("max_health", 0))
	return 0


func get_member_max_mp(member: Dictionary) -> int:
	var path := "res://resources/classes/%s.tres" % member.get("class_id", "")
	if ResourceLoader.exists(path):
		var data: Resource = load(path) as Resource
		if data and data.has_method("get_stats_at_level"):
			var stats: Dictionary = data.get_stats_at_level(member.get("level", 1))
			return int(stats.get("max_mana", 0))
	return 0


func get_tracked_hp_mp(unit_name: String) -> Dictionary:
	for member in party_members:
		if member.get("name", "") == unit_name:
			return {
				"hp": member.get("current_hp", -1),
				"mp": member.get("current_mp", -1),
			}
	return {"hp": -1, "mp": -1}


func heal_unit(unit_name: String, amount: int) -> int:
	for member in party_members:
		if member.get("name", "") == unit_name:
			var max_hp: int = get_member_max_hp(member)
			var cur: int = member.get("current_hp", -1)
			if cur < 0:
				cur = max_hp
			var new_hp: int = mini(cur + amount, max_hp)
			member["current_hp"] = new_hp
			return new_hp - cur
	return 0


func restore_mana(unit_name: String, amount: int) -> int:
	for member in party_members:
		if member.get("name", "") == unit_name:
			var max_mp: int = get_member_max_mp(member)
			var cur: int = member.get("current_mp", -1)
			if cur < 0:
				cur = max_mp
			var new_mp: int = mini(cur + amount, max_mp)
			member["current_mp"] = new_mp
			return new_mp - cur
	return 0


func full_rest_party() -> void:
	heal_party_partial(1.0, 1.0)


func heal_party_partial(hp_frac: float, mp_frac: float) -> void:
	for member in party_members:
		var max_hp: int = get_member_max_hp(member)
		var max_mp: int = get_member_max_mp(member)
		var cur_hp: int = member.get("current_hp", -1)
		var cur_mp: int = member.get("current_mp", -1)
		if cur_hp < 0:
			cur_hp = max_hp
		if cur_mp < 0:
			cur_mp = max_mp
		if max_hp > 0:
			member["current_hp"] = mini(cur_hp + int(max_hp * hp_frac), max_hp)
		if max_mp > 0:
			member["current_mp"] = mini(cur_mp + int(max_mp * mp_frac), max_mp)


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
		var item: Resource = _load_item(item_id) as Resource
		if item and item.get("is_consumable") and item.is_consumable():
			result.append({"item": item, "quantity": qty})
	return result


# --- Equipment (generic slots: 1/2/3 by tier) ---

func get_unit_tier(unit_name: String) -> int:
	var class_id: String = ""
	if unit_name == player_name:
		class_id = player_class_id
	else:
		for member in party_members:
			if member.get("name", "") == unit_name:
				class_id = member.get("class_id", "")
				break
	if class_id.is_empty():
		return 0
	var path := "res://resources/classes/%s.tres" % class_id
	if not ResourceLoader.exists(path):
		return 0
	var data: Resource = load(path) as Resource
	var t = data.get("tier") if data else null
	return int(t) if t != null else 0


func get_max_slots(unit_name: String) -> int:
	return get_unit_tier(unit_name) + 1


func _ensure_equipment_array(unit_name: String) -> void:
	if not equipment.has(unit_name):
		equipment[unit_name] = []
		return
	# Migrate old save format: { "weapon": id, "armor": id, "accessory": id } -> [id, id, id]
	var val = equipment[unit_name]
	if val is Dictionary:
		var arr: Array = []
		for key in ["weapon", "armor", "accessory"]:
			var id_str: String = val.get(key, "")
			if not id_str.is_empty():
				arr.append(id_str)
		equipment[unit_name] = arr


func equip_item(unit_name: String, item_id: String) -> bool:
	var item: Resource = _load_item(item_id) as Resource
	if not item or not item.get("is_equipment") or not item.is_equipment():
		return false
	_ensure_equipment_array(unit_name)
	var arr: Array = equipment[unit_name]
	var max_slots: int = get_max_slots(unit_name)
	if arr.size() >= max_slots:
		return false
	if not remove_item(item_id):
		return false
	arr.append(item_id)
	return true


func unequip_item(unit_name: String, slot_index: int) -> void:
	_ensure_equipment_array(unit_name)
	var arr: Array = equipment[unit_name]
	if slot_index < 0 or slot_index >= arr.size():
		return
	var item_id: String = arr[slot_index]
	arr.remove_at(slot_index)
	add_item(item_id)


func get_equipped_item_at(unit_name: String, slot_index: int) -> Resource:
	_ensure_equipment_array(unit_name)
	var arr: Array = equipment[unit_name]
	if slot_index < 0 or slot_index >= arr.size():
		return null
	var item_id: String = arr[slot_index]
	return _load_item(item_id)


func get_all_equipped(unit_name: String) -> Array:
	_ensure_equipment_array(unit_name)
	var arr: Array = equipment[unit_name]
	return arr.duplicate()


func is_item_unlocked(item: Resource) -> bool:
	if not item or not item.get("is_equipment") or not item.is_equipment():
		return false
	var party_class_ids: Array[String] = []
	if not player_class_id.is_empty():
		party_class_ids.append(player_class_id)
	for member in party_members:
		var cid: String = member.get("class_id", "")
		if not cid.is_empty() and cid not in party_class_ids:
			party_class_ids.append(cid)
	var highest_tier: int = 0
	for cid in party_class_ids:
		var path := "res://resources/classes/%s.tres" % cid
		if ResourceLoader.exists(path):
			var data: Resource = load(path) as Resource
			var dt = data.get("tier") if data else null
			if data and dt != null and int(dt) > highest_tier:
				highest_tier = int(dt)
	var ut = item.get("unlock_tier")
	if highest_tier < (int(ut) if ut != null else 0):
		return false
	var unlock_ids: Array = item.get("unlock_class_ids") if item.get("unlock_class_ids") != null else []
	if unlock_ids.is_empty():
		return true
	for cid in unlock_ids:
		if cid in party_class_ids:
			return true
	return false


func get_item_resource(item_id: String) -> Resource:
	return _load_item(item_id)


func _load_item(item_id: String) -> Resource:
	var path := "res://resources/items/%s.tres" % item_id
	if ResourceLoader.exists(path):
		return load(path) as Resource
	path = "res://resources/items/equipment/%s.tres" % item_id
	if ResourceLoader.exists(path):
		return load(path) as Resource
	return null


func reset_for_new_game() -> void:
	player_name = ""
	player_gender = ""
	player_class_id = ""
	player_level = 1
	party_members.clear()
	progression_stage = 0
	current_battle_id = ""
	current_town_id = ""
	story_flags.clear()
	completed_battles.clear()
	locked_nodes.clear()
	gold = 0
	inventory.clear()
	equipment.clear()
	unlocked_classes.clear()
	selected_party.clear()
	fired_travel_event_ids.clear()


func save_game() -> void:
	if current_slot < 0 or current_slot >= _save_manager.MAX_SAVE_SLOTS:
		push_error("GameState.save_game: no valid slot selected (current_slot=%d)" % current_slot)
		return
	var save_data := {
		"player_name": player_name,
		"player_gender": player_gender,
		"player_class_id": player_class_id,
		"player_level": player_level,
		"party_members": party_members,
		"progression_stage": progression_stage,
		"current_battle": current_battle_id,
		"story_flags": story_flags,
		"completed_battles": completed_battles,
		"locked_nodes": locked_nodes,
		"gold": gold,
		"inventory": inventory,
		"equipment": equipment,
		"unlocked_classes": unlocked_classes,
		"fired_travel_event_ids": fired_travel_event_ids,
	}
	_save_manager.save_to_slot(current_slot, save_data)


func load_game(slot: int) -> bool:
	var data: Dictionary = _save_manager.load_from_slot(slot)
	if data.is_empty():
		return false
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
	player_level = int(data.get("player_level", 1))
	var uc: Array = data.get("unlocked_classes", [])
	unlocked_classes.clear()
	for c in uc:
		unlocked_classes.append(str(c))
	var fe: Array = data.get("fired_travel_event_ids", [])
	fired_travel_event_ids.clear()
	for e in fe:
		fired_travel_event_ids.append(str(e))
	current_slot = slot
	_save_manager.mark_last_used(slot)
	return true


func delete_save(slot: int) -> void:
	_save_manager.delete_save(slot)


func has_save(slot: int) -> bool:
	return _save_manager.has_save(slot)


func has_any_save() -> bool:
	return _save_manager.has_any_save()


func get_last_used_slot() -> int:
	return _save_manager.get_last_used_slot()


func get_save_summary(slot: int) -> Dictionary:
	return _save_manager.get_save_summary(slot)
