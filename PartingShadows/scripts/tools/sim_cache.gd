class_name SimCache

## Balance snapshot caching for battle simulations.
## Caches results keyed by MD5 hashes of all dependency files so unchanged
## stages can be skipped on re-runs.

const SRep := preload("res://scripts/tools/sim_report.gd")

const CACHE_PATH := "user://sim_temp/sim_cache.json"

const GLOBAL_FILES: Array[String] = [
	"res://scripts/data/fighter_db.gd",
	"res://scripts/data/fighter_db_t1.gd",
	"res://scripts/data/fighter_db_t2.gd",
	"res://scripts/data/fighter_db_t2b.gd",
	"res://scripts/data/ability_db.gd",
	"res://scripts/data/ability_db_player.gd",
	"res://scripts/data/ability_db_player_b.gd",
	"res://scripts/data/fighter_data.gd",
	"res://scripts/data/ability_data.gd",
	"res://scripts/data/enums.gd",
	"res://scripts/tools/party_composer.gd",
	"res://scripts/tools/simulation_runner.gd",
	"res://scripts/tools/battle_stage_db.gd",
	"res://scripts/tools/battle_stage_db_s2s3.gd",
	"res://scripts/battle/battle_engine.gd",
	"res://scripts/data/equipment_db.gd",
	"res://scripts/data/equipment_data.gd",
]

const STORY_FILES := {
	1: [
		"res://scripts/data/story1/enemy_db.gd",
		"res://scripts/data/story1/enemy_db_act2.gd",
		"res://scripts/data/story1/enemy_db_act345.gd",
		"res://scripts/data/story1/enemy_ability_db.gd",
		"res://scripts/data/story1/enemy_ability_db_late.gd",
		"res://scripts/data/story1/battle_db_act1.gd",
		"res://scripts/data/story1/battle_db_act2.gd",
		"res://scripts/data/story1/battle_db_act3.gd",
		"res://scripts/data/story1/battle_db_act45.gd",
	],
	2: [
		"res://scripts/data/story2/enemy_db_s2.gd",
		"res://scripts/data/story2/enemy_db_s2_act2.gd",
		"res://scripts/data/story2/enemy_db_s2_act3.gd",
		"res://scripts/data/story2/enemy_db_s2_act4.gd",
		"res://scripts/data/story2/enemy_ability_db_s2.gd",
		"res://scripts/data/story2/enemy_ability_db_s2_late.gd",
		"res://scripts/data/story2/battle_db_s2.gd",
		"res://scripts/data/story2/battle_db_s2_act2.gd",
		"res://scripts/data/story2/battle_db_s2_act3.gd",
		"res://scripts/data/story2/battle_db_s2_act4.gd",
	],
	3: [
		"res://scripts/data/story3/enemy_db_s3.gd",
		"res://scripts/data/story3/enemy_db_s3_act2.gd",
		"res://scripts/data/story3/enemy_db_s3_act3.gd",
		"res://scripts/data/story3/enemy_db_s3_act45.gd",
		"res://scripts/data/story3/enemy_db_s3_pathb.gd",
		"res://scripts/data/story3/enemy_db_s3_pathc.gd",
		"res://scripts/data/story3/enemy_ability_db_s3.gd",
		"res://scripts/data/story3/enemy_ability_db_s3_act2.gd",
		"res://scripts/data/story3/enemy_ability_db_s3_pathb.gd",
		"res://scripts/data/story3/enemy_ability_db_s3_pathc.gd",
		"res://scripts/data/story3/battle_db_s3.gd",
		"res://scripts/data/story3/battle_db_s3_act2.gd",
		"res://scripts/data/story3/battle_db_s3_act3.gd",
		"res://scripts/data/story3/battle_db_s3_act45.gd",
		"res://scripts/data/story3/battle_db_s3_pathb.gd",
		"res://scripts/data/story3/battle_db_s3_pathc.gd",
	],
}

static var _cache: Dictionary = {}
static var _loaded := false
static var _global_hash := ""
static var _story_hashes: Dictionary = {}


static func _ensure_loaded() -> void:
	if _loaded:
		return
	_loaded = true
	if not FileAccess.file_exists(CACHE_PATH):
		return
	var file := FileAccess.open(CACHE_PATH, FileAccess.READ)
	if file == null:
		return
	var json := JSON.new()
	if json.parse(file.get_as_text()) == OK and json.data is Dictionary:
		_cache = json.data


static func _hash_files(paths: Array) -> String:
	var combined := ""
	for p: String in paths:
		var h := FileAccess.get_md5(p)
		if h == "":
			return ""  # File missing -- force cache miss
		combined += h
	return combined.md5_text()


static func _get_global_hash() -> String:
	if _global_hash == "":
		_global_hash = _hash_files(GLOBAL_FILES)
	return _global_hash


static func _get_story_hash(story: int) -> String:
	if not _story_hashes.has(story):
		var files: Array = STORY_FILES.get(story, [])
		_story_hashes[story] = _hash_files(files) if not files.is_empty() else ""
	return _story_hashes[story]


## Return cached result dict, or {} on miss.
static func get_cached(stage_name: String, story: int,
		sims_per_combo: int, sample_size: int) -> Dictionary:
	_ensure_loaded()
	if not _cache.has("stages"):
		return {}
	var entry: Dictionary = _cache.stages.get(stage_name, {})
	if entry.is_empty():
		return {}
	if entry.get("global_hash", "") != _get_global_hash():
		return {}
	if entry.get("story_hash", "") != _get_story_hash(story):
		return {}
	if int(entry.get("sims", -1)) != sims_per_combo:
		return {}
	if int(entry.get("sample", -1)) != sample_size:
		return {}
	return entry.get("result", {})


## Store a simulation result in the cache (call save() later to persist).
static func store(stage_name: String, story: int,
		sims_per_combo: int, sample_size: int,
		result: Dictionary, stage: Dictionary) -> void:
	_ensure_loaded()
	if not _cache.has("stages"):
		_cache["stages"] = {}
	_cache.stages[stage_name] = {
		"global_hash": _get_global_hash(),
		"story_hash": _get_story_hash(story),
		"sims": sims_per_combo,
		"sample": sample_size,
		"result": result,
		"report_entry": SRep.build_entry(result, stage),
	}


## Write the cache to disk.
static func save() -> void:
	if _cache.is_empty():
		return
	DirAccess.make_dir_recursive_absolute(
		ProjectSettings.globalize_path(CACHE_PATH.get_base_dir()))
	var json_str := JSON.stringify(_cache, "\t")
	var file := FileAccess.open(CACHE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_str)
		file.close()


## Delete the cache file and reset all state.
static func clear() -> void:
	if FileAccess.file_exists(CACHE_PATH):
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path(CACHE_PATH))
	_cache = {}
	_loaded = false
	_global_hash = ""
	_story_hashes = {}
