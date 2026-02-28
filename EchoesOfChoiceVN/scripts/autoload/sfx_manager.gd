extends Node

const AudioLoader = preload("res://scripts/autoload/audio_loader.gd")
const Enums = preload("res://scripts/data/enums.gd")

enum Category {
	STRIKE,
	IMPACT,
	SLASH,
	WHOOSH,
	SPELL,
	FIRE,
	LIGHTNING,
	BEAM,
	CHARGED,
	VORTEX,
	BODY_HIT,
	EARTH,
	SHIMMER,
	MONSTER,
	RANGED_IMPACT,
	FOOTSTEP,
	UI_SELECT,
	UI_CONFIRM,
	UI_CANCEL,
	UI_POPUP,
	UI_FANFARE,
	UI_TRANSITION,
}

const _SFX_ROOT: String = "res://assets/audio/sfx/"

const CATEGORY_FOLDERS: Dictionary = {
	Category.STRIKE: ["combat/Clean_Strike_Sword_Katana_Dagger/", "combat/Crystal_Sword_Strike/"],
	Category.IMPACT: ["combat/Bright_Crisp_Strike_Impact/", "combat/Clean_Object_Impact/", "combat/Object_Impact_Hit_Typ1/"],
	Category.SLASH: ["combat/Bright_Slash_Attack/", "combat/Sliced_Whirl/"],
	Category.WHOOSH: ["combat/Quick_Swish_Swoosh_Whoosh/", "combat/Bright_Swoosh_Whoosh/", "combat/Flyby_Passby/"],
	Category.SPELL: ["combat/Spell_Burst_Crystal/", "combat/Spell_Burst_Saber_Clash/"],
	Category.FIRE: ["combat/FireThrower_Blow_Typ1/", "combat/FireThrower_Blow_Typ2/", "combat/Arcblade-Ignition_Fire_Blow/"],
	Category.LIGHTNING: ["combat/Tesla-Coil_Gunshot_Fire/"],
	Category.BEAM: ["combat/Beam-Slashed-Typ1/", "combat/Beam-Slashed-Typ2/", "combat/Bright-Flare_Beam_Clean_Swish/", "combat/Bright-Flare_Beam_Swish_Whirl/"],
	Category.CHARGED: ["combat/Charged_Strike/"],
	Category.VORTEX: ["combat/Vortex_Burst/", "combat/Bio-Fusion_Blast_Short-Tail/", "combat/Bio-Fusion_Blast_Long-Tail/"],
	Category.BODY_HIT: ["combat/Kick_Body_Impact/", "combat/Weapon_Attack_Organic_Impact/"],
	Category.EARTH: ["combat/Earthy_Rumble_Rock_Move/", "combat/Strike_Large_Object/"],
	Category.SHIMMER: ["combat/Sparkly_Shimmer_Charged_Particles/"],
	Category.MONSTER: ["combat/"],
	Category.RANGED_IMPACT: ["ranged/arrow_impacts/"],
	Category.FOOTSTEP: ["movement/"],
	Category.UI_SELECT: ["ui/"],
	Category.UI_CONFIRM: ["ui/"],
	Category.UI_CANCEL: ["ui/"],
	Category.UI_POPUP: ["ui/"],
	Category.UI_FANFARE: ["ui/"],
	Category.UI_TRANSITION: ["ui/"],
}

const CATEGORY_FILTERS: Dictionary = {
	Category.MONSTER: ["Monster", "Creature", "Growl", "Roar", "Snarl", "Alien"],
	Category.UI_SELECT: ["Button Sound", "Selection Sound"],
	Category.UI_CONFIRM: ["Notification Sound"],
	Category.UI_CANCEL: ["Error Sound", "Negative Notification"],
	Category.UI_POPUP: ["Pop-Up Sound"],
	Category.UI_FANFARE: ["Exciting Fanfare"],
	Category.UI_TRANSITION: ["Transition Sound"],
}

const VOICE_ACTIONS: Array[String] = ["attack", "battle_cry", "confirm", "vocal"]

const POOL_SIZE: int = 8
const DEFAULT_COOLDOWN_MS: float = 80.0
const VOICE_COOLDOWN_MS: float = 300.0
const PITCH_VARIATION: float = 0.08
const VOICE_PITCH_VARIATION: float = 0.03

var _players: Array[AudioStreamPlayer] = []
var _play_times: Array[float] = []
var _sfx_volume_linear: float = 1.0
var _track_cache: Dictionary = {}
var _stream_cache: Dictionary = {}
var _last_played: Dictionary = {}
var _cooldown_timers: Dictionary = {}
var _headless: bool = false


func _ready() -> void:
	if AudioLoader.is_headless():
		_headless = true
		return
	_ensure_audio_bus()
	for i in POOL_SIZE:
		var player := AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		_players.append(player)
		_play_times.append(0.0)


func _ensure_audio_bus() -> void:
	if AudioServer.get_bus_index("SFX") == -1:
		var idx: int = AudioServer.bus_count
		AudioServer.add_bus(idx)
		AudioServer.set_bus_name(idx, "SFX")
		AudioServer.set_bus_send(idx, "Master")


func play(category: int, volume: float = 1.0, pitch_shift: bool = true) -> void:
	if _headless:
		return
	var key: String = "cat:%d" % category
	if not _check_cooldown(key, DEFAULT_COOLDOWN_MS):
		return
	var tracks: Array[String] = _get_tracks_for_category(category)
	if tracks.is_empty():
		return
	var path: String = _pick_random(tracks, key)
	var player := _get_available_player()
	_play_on_player(player, path, volume, PITCH_VARIATION if pitch_shift else 0.0)


func play_voice(pack_id: String, action: String, volume: float = 1.0) -> void:
	if _headless:
		return
	if action not in VOICE_ACTIONS:
		return
	var key: String = "voice:%s:%s" % [pack_id, action]
	if not _check_cooldown(key, VOICE_COOLDOWN_MS):
		return
	var folder: String = _SFX_ROOT + "voices/%s/%s/" % [pack_id, action]
	var cache_key: String = "voice:%s:%s" % [pack_id, action]
	if not _track_cache.has(cache_key):
		_track_cache[cache_key] = _list_tracks(folder)
	var tracks: Array[String] = _track_cache[cache_key]
	if tracks.is_empty():
		return
	var path: String = _pick_random(tracks, key)
	var player := _get_available_player()
	_play_on_player(player, path, volume, VOICE_PITCH_VARIATION)


func play_at_path(path: String, volume: float = 1.0, pitch_shift: bool = false) -> void:
	if _headless:
		return
	var player := _get_available_player()
	_play_on_player(player, path, volume, PITCH_VARIATION if pitch_shift else 0.0)


func set_sfx_volume(linear: float) -> void:
	_sfx_volume_linear = clampf(linear, 0.0, 1.0)
	var bus_idx: int = AudioServer.get_bus_index("SFX")
	if bus_idx >= 0:
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(maxf(0.0001, _sfx_volume_linear)))


func stop_all() -> void:
	for player in _players:
		player.stop()


func play_ability_sfx(ability: Resource) -> void:
	if _headless:
		return
	if ability.is_heal():
		play(Category.SHIMMER)
		return
	if ability.is_buff_or_debuff():
		play(Category.SHIMMER, 0.8)
		return
	match ability.modified_stat:
		Enums.StatType.PHYSICAL_ATTACK, Enums.StatType.ATTACK:
			play(Category.STRIKE)
		Enums.StatType.MAGIC_ATTACK:
			play(_resolve_magic_sfx(ability.ability_name))
		Enums.StatType.MIXED_ATTACK:
			play(Category.CHARGED)
		_:
			play(Category.IMPACT)


func _resolve_magic_sfx(ability_name: String) -> int:
	var lower := ability_name.to_lower()
	for keyword in ["fire", "flame", "burn", "ignite", "inferno", "blaze", "scorch"]:
		if lower.contains(keyword):
			return Category.FIRE
	for keyword in ["lightning", "thunder", "shock", "bolt", "storm", "jolt"]:
		if lower.contains(keyword):
			return Category.LIGHTNING
	for keyword in ["beam", "ray", "laser", "pulse"]:
		if lower.contains(keyword):
			return Category.BEAM
	for keyword in ["vortex", "void", "dark", "shadow", "drain", "siphon", "necrotic"]:
		if lower.contains(keyword):
			return Category.VORTEX
	return Category.SPELL


func _get_available_player() -> AudioStreamPlayer:
	for i in _players.size():
		if not _players[i].playing:
			return _players[i]
	var oldest_idx: int = 0
	for i in range(1, _players.size()):
		if _play_times[i] < _play_times[oldest_idx]:
			oldest_idx = i
	_players[oldest_idx].stop()
	return _players[oldest_idx]


func _load_cached_stream(path: String) -> AudioStream:
	if _stream_cache.has(path):
		return _stream_cache[path]
	var stream: AudioStream = AudioLoader.load_stream(path)
	if stream != null:
		_stream_cache[path] = stream
	return stream


func _play_on_player(player: AudioStreamPlayer, path: String, volume: float, pitch_var: float) -> void:
	var stream: AudioStream = _load_cached_stream(path)
	if stream == null:
		return
	player.stream = stream
	player.volume_db = linear_to_db(maxf(0.0001, volume * _sfx_volume_linear))
	if pitch_var > 0.0:
		player.pitch_scale = 1.0 + randf_range(-pitch_var, pitch_var)
	else:
		player.pitch_scale = 1.0
	player.play()
	var idx: int = _players.find(player)
	if idx >= 0:
		_play_times[idx] = Time.get_ticks_msec()


func _pick_random(tracks: Array[String], dedup_key: String) -> String:
	if tracks.size() <= 1:
		return tracks[0]
	var choice: String = tracks[randi() % tracks.size()]
	if choice == _last_played.get(dedup_key, "") and tracks.size() > 2:
		choice = tracks[randi() % tracks.size()]
	_last_played[dedup_key] = choice
	return choice


func _check_cooldown(key: String, cooldown_ms: float) -> bool:
	var now: float = Time.get_ticks_msec()
	var last: float = _cooldown_timers.get(key, 0.0)
	if now - last < cooldown_ms:
		return false
	_cooldown_timers[key] = now
	return true


func _get_tracks_for_category(category: int) -> Array[String]:
	if _track_cache.has(category):
		return _track_cache[category]
	var folders: Array = CATEGORY_FOLDERS.get(category, [])
	var all_tracks: Array[String] = []
	for relative_folder: String in folders:
		var full_path: String = _SFX_ROOT + relative_folder
		all_tracks.append_array(_list_tracks(full_path))
	var filters: Array = CATEGORY_FILTERS.get(category, [])
	if not filters.is_empty():
		var filtered: Array[String] = []
		for track: String in all_tracks:
			var file_name: String = track.get_file()
			for f: String in filters:
				if file_name.containsn(f):
					filtered.append(track)
					break
		all_tracks = filtered
	_track_cache[category] = all_tracks
	return all_tracks


func _list_tracks(folder: String) -> Array[String]:
	var tracks: Array[String] = []
	var dir := DirAccess.open(folder)
	if dir == null:
		return tracks
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			var lower := file_name.to_lower()
			if lower.ends_with(".wav") or lower.ends_with(".ogg") or lower.ends_with(".mp3"):
				tracks.append(folder + file_name)
			elif lower.ends_with(".wav.import") or lower.ends_with(".ogg.import") or lower.ends_with(".mp3.import"):
				var original := file_name.substr(0, file_name.length() - 7)
				tracks.append(folder + original)
		file_name = dir.get_next()
	dir.list_dir_end()
	return tracks
