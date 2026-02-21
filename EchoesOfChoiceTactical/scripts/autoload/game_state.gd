extends Node

var player_name: String = ""
var player_gender: String = ""
var player_class_id: String = ""

var party_members: Array[Dictionary] = []

var progression_stage: int = 0
var current_battle_id: String = ""
var story_flags: Dictionary = {}

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
	})


func get_party_size() -> int:
	return party_members.size()


func set_flag(flag: String, value: bool = true) -> void:
	story_flags[flag] = value


func has_flag(flag: String) -> bool:
	return story_flags.get(flag, false)


func reset_for_new_game() -> void:
	player_name = ""
	player_gender = ""
	player_class_id = ""
	party_members.clear()
	progression_stage = 0
	current_battle_id = ""
	story_flags.clear()


func save_game() -> void:
	var save_data := {
		"player_name": player_name,
		"player_gender": player_gender,
		"player_class_id": player_class_id,
		"party_members": party_members,
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
	player_name = data.get("player_name", "")
	player_gender = data.get("player_gender", "")
	player_class_id = data.get("player_class_id", "")
	party_members.assign(data.get("party_members", []))
	progression_stage = data.get("progression_stage", 0)
	current_battle_id = data.get("current_battle", "")
	story_flags = data.get("story_flags", {})
	return true


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
