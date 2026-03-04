extends Node

## Multi-slot save persistence. 3 manual slots + 1 autosave.
## Saves party data and current battle ID as JSON to user://.

const FighterData = preload("res://scripts/data/fighter_data.gd")
const FighterDB = preload("res://scripts/data/fighter_db.gd")

const MAX_SAVE_SLOTS := 3
const AUTOSAVE_SLOT := 3
const SAVE_META_PATH := "user://save_meta.json"
const AUTOSAVE_PATH := "user://autosave.json"
const SAVE_VERSION := 1


func _save_path(slot: int) -> String:
	if slot == AUTOSAVE_SLOT:
		return AUTOSAVE_PATH
	return "user://savegame_%d.json" % slot


# =============================================================================
# Save
# =============================================================================

func save_to_slot(slot: int) -> void:
	GameLog.info("Saved slot %d" % slot)
	var save_data: Dictionary = _build_save_data()
	var file := FileAccess.open(_save_path(slot), FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
	if slot != AUTOSAVE_SLOT:
		_write_save_meta(slot)


func auto_save() -> void:
	save_to_slot(AUTOSAVE_SLOT)


func _build_save_data() -> Dictionary:
	var party_data: Array[Dictionary] = []
	for fighter: FighterData in GameState.party:
		party_data.append(fighter.to_save_data())
	return {
		"save_version": SAVE_VERSION,
		"timestamp": Time.get_datetime_string_from_system(),
		"current_battle_id": GameState.current_battle_id,
		"story_id": GameState.current_story_id,
		"party": party_data,
	}


# =============================================================================
# Load
# =============================================================================

func load_from_slot(slot: int) -> bool:
	GameLog.info("Loading slot %d" % slot)
	var data: Dictionary = _read_save(slot)
	if data.is_empty():
		GameLog.warn("Load failed: slot %d empty or corrupt" % slot)
		return false

	# Reconstruct party
	var party: Array[FighterData] = []
	for fighter_dict: Dictionary in data["party"]:
		var fighter := FighterData.new()
		fighter.apply_save_data(fighter_dict)
		# Restore display name if missing from old saves
		if fighter.character_type.is_empty():
			fighter.character_type = FighterDB.get_display_name(fighter.class_id)
		fighter.abilities = FighterDB.get_abilities_for_class(fighter.class_id)
		party.append(fighter)

	GameState.party = party
	GameState.current_story_id = data.get("story_id", "story_1")
	GameState.advance_to_battle(data["current_battle_id"])
	# advance_to_battle sets narrative_mode=PRE_BATTLE, game_phase=NARRATIVE

	if slot != AUTOSAVE_SLOT:
		_write_save_meta(slot)
	return true


func _read_save(slot: int) -> Dictionary:
	var path: String = _save_path(slot)
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		return {}
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return {}
	file.close()
	return json.data


# =============================================================================
# Queries
# =============================================================================

func has_save(slot: int) -> bool:
	return FileAccess.file_exists(_save_path(slot))


func has_any_save() -> bool:
	for i: int in MAX_SAVE_SLOTS:
		if has_save(i):
			return true
	return has_autosave()


func has_autosave() -> bool:
	return FileAccess.file_exists(AUTOSAVE_PATH)


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
	var data: Dictionary = _read_save(slot)
	if data.is_empty():
		return {"exists": false}
	var party: Array = data.get("party", [])
	if party.is_empty():
		return {"exists": false}
	var lead: Dictionary = party[0]
	return {
		"exists": true,
		"lead_name": lead.get("character_name", "Unknown"),
		"lead_class": lead.get("character_type", lead.get("class_id", "")),
		"level": int(lead.get("level", 1)),
		"party_size": party.size(),
		"battle_id": data.get("current_battle_id", ""),
		"story_id": data.get("story_id", "story_1"),
	}


# =============================================================================
# Metadata
# =============================================================================

func _write_save_meta(slot: int) -> void:
	var file := FileAccess.open(SAVE_META_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify({"last_slot": slot}))
		file.close()
