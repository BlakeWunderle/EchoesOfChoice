extends Node

## Preloads battle assets (enemy .tres, SpriteFrames, terrain textures) in the
## background using ResourceLoader.load_threaded_request(). Call begin_preload()
## from the overworld map or party select screen to warm caches before the
## battle scene loads.

const _BattleMetadata = preload("res://scripts/data/battle_metadata.gd")
const _TileTextureCache = preload("res://scripts/systems/tile_texture_cache.gd")

var _pending_requests: Array[String] = []
var _preload_battle_id: String = ""
var _is_preloading: bool = false
var _phase: int = 0  # 0 = enemy .tres, 1 = SpriteFrames
var _headless: bool = false


func _ready() -> void:
	if DisplayServer.get_name() == "headless":
		_headless = true
	set_process(false)


func begin_preload(battle_id: String) -> void:
	if _headless:
		return
	if _preload_battle_id == battle_id and _is_preloading:
		return
	if _is_preloading:
		cancel_preload()

	var meta: Dictionary = _BattleMetadata.get_metadata(battle_id)
	if meta.is_empty():
		return

	_preload_battle_id = battle_id
	_is_preloading = true
	_phase = 0
	_pending_requests.clear()

	# Phase 0: queue enemy FighterData .tres and terrain textures
	var enemy_paths: Array = meta.get("enemy_paths", [])
	for path: String in enemy_paths:
		_request_threaded(path)

	var environment: String = meta.get("environment", "grassland")
	_queue_terrain_textures(environment)

	set_process(true)


func cancel_preload() -> void:
	_pending_requests.clear()
	_is_preloading = false
	_preload_battle_id = ""
	_phase = 0
	set_process(false)


func warm_caches() -> void:
	if _preload_battle_id.is_empty():
		return
	var meta: Dictionary = _BattleMetadata.get_metadata(_preload_battle_id)
	if meta.is_empty():
		return
	# Push preloaded enemy sprites into SpriteLoader cache
	for path: String in meta.get("enemy_paths", []):
		var data: FighterData = load(path) as FighterData
		if data and not data.sprite_id.is_empty():
			SpriteLoader.get_frames(data.sprite_id)
		if data and not data.sprite_id_female.is_empty():
			SpriteLoader.get_frames(data.sprite_id_female)


func _queue_terrain_textures(environment: String) -> void:
	var env_data: Dictionary = _TileTextureCache.ENVIRONMENT_TILES.get(environment, {})
	if not env_data.is_empty():
		_request_threaded(env_data["path"])
	var wall_data: Dictionary = _TileTextureCache.WALL_TILES.get(environment, {})
	if not wall_data.is_empty():
		_request_threaded(wall_data["path"])


func _request_threaded(path: String) -> void:
	if not ResourceLoader.exists(path):
		return
	if ResourceLoader.has_cached(path):
		return
	var err := ResourceLoader.load_threaded_request(path, "", false, ResourceLoader.CACHE_MODE_REUSE)
	if err == OK:
		_pending_requests.append(path)


func _process(_delta: float) -> void:
	if not _is_preloading:
		set_process(false)
		return

	var still_pending: Array[String] = []
	for path in _pending_requests:
		var status := ResourceLoader.load_threaded_get_status(path)
		if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			still_pending.append(path)
		elif status == ResourceLoader.THREAD_LOAD_LOADED:
			ResourceLoader.load_threaded_get(path)

	_pending_requests = still_pending

	if not _pending_requests.is_empty():
		return

	if _phase == 0:
		# Phase 0 done: enemy .tres loaded. Now extract sprite_ids and queue SpriteFrames.
		_phase = 1
		_queue_sprite_frames()
		if _pending_requests.is_empty():
			_is_preloading = false
			set_process(false)
	else:
		_is_preloading = false
		set_process(false)


func _queue_sprite_frames() -> void:
	var meta: Dictionary = _BattleMetadata.get_metadata(_preload_battle_id)
	var sprite_ids: Dictionary = {}

	for path: String in meta.get("enemy_paths", []):
		var data: FighterData = load(path) as FighterData
		if data:
			if not data.sprite_id.is_empty():
				sprite_ids[data.sprite_id] = true
			if not data.sprite_id_female.is_empty():
				sprite_ids[data.sprite_id_female] = true

	# Player party sprites
	_collect_player_sprite_ids(sprite_ids)

	for sid: String in sprite_ids:
		var sf_path := SpriteLoader.SPRITEFRAMES_DIR + sid + ".tres"
		_request_threaded(sf_path)


func _collect_player_sprite_ids(sprite_ids: Dictionary) -> void:
	var pc_class_id: String = GameState.player_class_id
	if not pc_class_id.is_empty():
		var pc_path := "res://resources/classes/%s.tres" % pc_class_id
		if ResourceLoader.exists(pc_path):
			var pc_data: FighterData = load(pc_path) as FighterData
			if pc_data:
				var is_female := GameState.player_gender in ["female", "princess"]
				var sid: String = pc_data.sprite_id_female if is_female and not pc_data.sprite_id_female.is_empty() else pc_data.sprite_id
				if not sid.is_empty():
					sprite_ids[sid] = true

	for member in GameState.party_members:
		var class_id: String = member.get("class_id", "")
		if class_id.is_empty():
			continue
		var mpath := "res://resources/classes/%s.tres" % class_id
		if not ResourceLoader.exists(mpath):
			continue
		var mdata: FighterData = load(mpath) as FighterData
		if mdata:
			var gender: String = member.get("gender", "")
			var is_fem := gender in ["female", "princess"]
			var sid: String = mdata.sprite_id_female if is_fem and not mdata.sprite_id_female.is_empty() else mdata.sprite_id
			if not sid.is_empty():
				sprite_ids[sid] = true
