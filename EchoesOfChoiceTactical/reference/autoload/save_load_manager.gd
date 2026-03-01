class_name SaveLoadManager extends RefCounted

const MAX_SAVE_SLOTS := 3
const AUTOSAVE_SLOT := 3
const SAVE_META_PATH := "user://save_meta.json"
const AUTOSAVE_PATH := "user://autosave.json"
const SETTINGS_PATH := "user://settings.json"


func _save_path(slot: int) -> String:
	if slot == AUTOSAVE_SLOT:
		return AUTOSAVE_PATH
	return "user://savegame_%d.json" % slot


func save_to_slot(slot: int, save_data: Dictionary) -> void:
	var file := FileAccess.open(_save_path(slot), FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
	if slot != AUTOSAVE_SLOT:
		_write_save_meta(slot)


func load_from_slot(slot: int) -> Dictionary:
	if not FileAccess.file_exists(_save_path(slot)):
		return {}
	var file := FileAccess.open(_save_path(slot), FileAccess.READ)
	if not file:
		return {}
	var json := JSON.new()
	var result := json.parse(file.get_as_text())
	file.close()
	if result != OK:
		return {}
	return json.data


func mark_last_used(slot: int) -> void:
	_write_save_meta(slot)


func _write_save_meta(slot: int) -> void:
	var file := FileAccess.open(SAVE_META_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify({"last_slot": slot}))
		file.close()


func delete_save(slot: int) -> void:
	var path := _save_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)


func has_save(slot: int) -> bool:
	return FileAccess.file_exists(_save_path(slot))


func has_any_save() -> bool:
	for i in MAX_SAVE_SLOTS:
		if has_save(i):
			return true
	return false


func get_last_used_slot() -> int:
	if not FileAccess.file_exists(SAVE_META_PATH):
		return -1
	var file := FileAccess.open(SAVE_META_PATH, FileAccess.READ)
	if not file:
		return -1
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return -1
	file.close()
	var slot: int = int(json.data.get("last_slot", -1))
	if slot >= 0 and slot < MAX_SAVE_SLOTS and has_save(slot):
		return slot
	return -1


func get_save_summary(slot: int) -> Dictionary:
	if not has_save(slot):
		return {"exists": false}
	var file := FileAccess.open(_save_path(slot), FileAccess.READ)
	if not file:
		return {"exists": false}
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return {"exists": false}
	file.close()
	var d: Dictionary = json.data
	return {
		"exists": true,
		"player_name": d.get("player_name", "Unknown"),
		"player_class_id": d.get("player_class_id", ""),
		"progression_stage": int(d.get("progression_stage", 0)),
		"gold": int(d.get("gold", 0)),
	}


func has_autosave() -> bool:
	return FileAccess.file_exists(AUTOSAVE_PATH)


func save_settings(data: Dictionary) -> void:
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()


func load_settings() -> Dictionary:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return {}
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if not file:
		return {}
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return {}
	file.close()
	return json.data
