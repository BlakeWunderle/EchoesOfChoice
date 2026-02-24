class_name EquipmentManager extends RefCounted

var _state  # GameState (untyped to avoid circular reference)


func _init(state) -> void:
	_state = state


func get_unit_tier(unit_name: String) -> int:
	var class_id: String = ""
	if unit_name == _state.player_name:
		class_id = _state.player_class_id
	else:
		for member in _state.party_members:
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
	if not _state.equipment.has(unit_name):
		_state.equipment[unit_name] = []
		return
	var val = _state.equipment[unit_name]
	if val is Dictionary:
		var arr: Array = []
		for key in ["weapon", "armor", "accessory"]:
			var id_str: String = val.get(key, "")
			if not id_str.is_empty():
				arr.append(id_str)
		_state.equipment[unit_name] = arr


func equip_item(unit_name: String, item_id: String) -> bool:
	var item: Resource = _state._load_item(item_id) as Resource
	if not item or not item.get("is_equipment") or not item.is_equipment():
		return false
	_ensure_equipment_array(unit_name)
	var arr: Array = _state.equipment[unit_name]
	var max_slots: int = get_max_slots(unit_name)
	if arr.size() >= max_slots:
		return false
	if not _state.remove_item(item_id):
		return false
	arr.append(item_id)
	return true


func unequip_item(unit_name: String, slot_index: int) -> void:
	_ensure_equipment_array(unit_name)
	var arr: Array = _state.equipment[unit_name]
	if slot_index < 0 or slot_index >= arr.size():
		return
	var item_id: String = arr[slot_index]
	arr.remove_at(slot_index)
	_state.add_item(item_id)


func get_equipped_item_at(unit_name: String, slot_index: int) -> Resource:
	_ensure_equipment_array(unit_name)
	var arr: Array = _state.equipment[unit_name]
	if slot_index < 0 or slot_index >= arr.size():
		return null
	var item_id: String = arr[slot_index]
	return _state._load_item(item_id)


func get_all_equipped(unit_name: String) -> Array:
	_ensure_equipment_array(unit_name)
	var arr: Array = _state.equipment[unit_name]
	return arr.duplicate()


func is_item_unlocked(item: Resource) -> bool:
	if not item or not item.get("is_equipment") or not item.is_equipment():
		return false
	var party_class_ids: Array[String] = []
	if not _state.player_class_id.is_empty():
		party_class_ids.append(_state.player_class_id)
	for member in _state.party_members:
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
