extends Node

## Multi-slot save persistence. 3 manual slots + 1 autosave.
## Saves party data and current battle ID as JSON to user://.

const FighterData = preload("res://scripts/data/fighter_data.gd")
const FighterDB = preload("res://scripts/data/fighter_db.gd")

const MAX_SAVE_SLOTS := 15
const AUTOSAVE_SLOT := 15
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
	var json_str: String = JSON.stringify(save_data, "\t")
	var path: String = _save_path(slot)
	var tmp_path: String = path + ".tmp"
	var file := FileAccess.open(tmp_path, FileAccess.WRITE)
	if file:
		file.store_string(json_str)
		file.close()
		var err: int = DirAccess.rename_absolute(tmp_path, path)
		if err != OK:
			GameLog.error("Save rename failed for slot %d (error %d)" % [slot, err])
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
		"play_seconds": GameState.play_seconds,
		"inventory": GameState.inventory.to_save_data(),
		"is_multiplayer": NetManager.is_multiplayer_active,
		"is_local_coop": LocalCoop.is_active,
		"player_count": LocalCoop.player_count if LocalCoop.is_active \
			else (NetManager.target_player_count if NetManager.is_multiplayer_active else 1),
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

	# Validate story unlock
	var story_id: String = data.get("story_id", "story_1")
	var story: Dictionary = StoryDB.get_story(story_id)
	if not UnlockManager.is_unlocked(story.get("unlock_requirement", "")):
		GameLog.warn("Load failed: story '%s' is locked" % story_id)
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

	# Reset ownership when loading in single-player mode
	if not NetManager.is_multiplayer_active:
		for fighter: FighterData in party:
			fighter.owner_peer_id = 1

	GameState.party = party
	GameState.current_story_id = data.get("story_id", "story_1")
	GameState.play_seconds = data.get("play_seconds", 0.0)
	# Restore inventory (old saves gracefully get empty inventory + 0 gold)
	var inv_data: Dictionary = data.get("inventory", {})
	if not inv_data.is_empty():
		GameState.inventory.apply_save_data(inv_data)
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
		"play_seconds": data.get("play_seconds", 0.0),
		"is_multiplayer": data.get("is_multiplayer", false),
		"is_local_coop": data.get("is_local_coop", false),
		"player_count": int(data.get("player_count", 1)),
	}


# =============================================================================
# Delete
# =============================================================================

func delete_save(slot: int) -> void:
	var path: String = _save_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		GameLog.info("Deleted save slot %d" % slot)
	# Clear last-used metadata if this was the last-used slot
	if get_last_used_slot() == slot:
		if FileAccess.file_exists(SAVE_META_PATH):
			DirAccess.remove_absolute(SAVE_META_PATH)


# =============================================================================
# Metadata
# =============================================================================

func _write_save_meta(slot: int) -> void:
	var tmp_path: String = SAVE_META_PATH + ".tmp"
	var file := FileAccess.open(tmp_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify({"last_slot": slot}))
		file.close()
		var err: int = DirAccess.rename_absolute(tmp_path, SAVE_META_PATH)
		if err != OK:
			GameLog.error("Save meta rename failed (error %d)" % err)
