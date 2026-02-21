extends Node

var party: Array = []
var progression_stage: int = 0
var current_battle_id: String = ""
var story_flags: Dictionary = {}

const SAVE_PATH := "user://savegame.json"


func add_to_party(unit_data: Dictionary) -> void:
	party.append(unit_data)


func remove_from_party(index: int) -> void:
	if index >= 0 and index < party.size():
		party.remove_at(index)


func save_game() -> void:
	var save_data := {
		"party": party,
		"progression_stage": progression_stage,
		"current_battle": current_battle_id,
		"story_flags": story_flags,
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
	party = data.get("party", [])
	progression_stage = data.get("progression_stage", 0)
	current_battle_id = data.get("current_battle", "")
	story_flags = data.get("story_flags", {})
	return true


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
