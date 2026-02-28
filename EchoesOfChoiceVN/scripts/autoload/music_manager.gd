extends Node

const AudioLoader = preload("res://scripts/autoload/audio_loader.gd")

enum MusicContext {
	MENU,
	BATTLE,
	BATTLE_BOSS,
	BATTLE_SCIFI,
	BATTLE_DARK,
	EXPLORATION,
	TOWN,
	CUTSCENE,
	GAME_OVER,
	VICTORY,
}

const CONTEXT_FOLDERS: Dictionary = {
	MusicContext.MENU: "res://assets/audio/music/menu/",
	MusicContext.BATTLE: "res://assets/audio/music/battle/",
	MusicContext.BATTLE_BOSS: "res://assets/audio/music/boss/",
	MusicContext.BATTLE_DARK: "res://assets/audio/music/battle_dark/",
	MusicContext.TOWN: "res://assets/audio/music/town/",
	MusicContext.CUTSCENE: "res://assets/audio/music/cutscene/",
	MusicContext.GAME_OVER: "res://assets/audio/music/game_over/",
	MusicContext.VICTORY: "res://assets/audio/music/victory/",
}

const _MAX_MUSIC_CACHE: int = 3

var _player: AudioStreamPlayer
var _current_path: String = ""
var _current_context: int = -1
var _music_volume_linear: float = 0.8
var _headless: bool = false
var _stream_cache: Dictionary = {}
var _stream_access_order: Array[String] = []
var _folder_cache: Dictionary = {}


func _ready() -> void:
	if AudioLoader.is_headless():
		_headless = true


func play_context(context: int, fade: float = 1.0) -> void:
	if _headless:
		return
	if context == _current_context:
		return
	_current_context = context
	var folder: String = CONTEXT_FOLDERS.get(context, "")
	if folder.is_empty():
		stop_music(fade)
		return
	var tracks: Array[String] = _list_tracks(folder)
	if tracks.is_empty():
		return
	var path: String = tracks[randi() % tracks.size()]
	play_music(path, fade)


func play_music(path: String, fade_duration: float = 0.5) -> void:
	if _headless:
		return
	if path == _current_path:
		return
	_current_path = path

	var stream: AudioStream = _load_cached_stream(path)
	if stream == null:
		push_warning("MusicManager: Could not load: " + path)
		return

	_fade_out_player(fade_duration)
	_player = AudioStreamPlayer.new()
	add_child(_player)
	_player.stream = stream
	_player.volume_db = linear_to_db(maxf(0.0001, _music_volume_linear))
	_player.finished.connect(_player.play)
	_player.play()


func stop_music(fade_duration: float = 0.5) -> void:
	if _headless:
		return
	_current_path = ""
	_current_context = -1
	_fade_out_player(fade_duration)


func _fade_out_player(duration: float) -> void:
	if _player == null:
		return
	var dying := _player
	_player = null
	if not dying.playing or duration <= 0.0:
		dying.stop()
		dying.queue_free()
		return
	if dying.finished.is_connected(dying.play):
		dying.finished.disconnect(dying.play)
	var tween := dying.create_tween()
	tween.tween_property(dying, "volume_db", -40.0, duration)
	tween.tween_callback(dying.stop)
	tween.tween_callback(dying.queue_free)


func set_music_volume(linear: float) -> void:
	_music_volume_linear = clampf(linear, 0.0, 1.0)
	if _headless:
		return
	if _player != null and _player.playing:
		_player.volume_db = linear_to_db(maxf(0.0001, _music_volume_linear))


func clear_context() -> void:
	_current_context = -1


func _load_cached_stream(path: String) -> AudioStream:
	if _stream_cache.has(path):
		_stream_access_order.erase(path)
		_stream_access_order.append(path)
		return _stream_cache[path]
	var stream: AudioStream = load(path) as AudioStream
	if stream == null:
		stream = AudioLoader.load_stream(path)
	if stream == null:
		return null
	while _stream_cache.size() >= _MAX_MUSIC_CACHE and not _stream_access_order.is_empty():
		var evict_path: String = _stream_access_order[0]
		_stream_access_order.remove_at(0)
		_stream_cache.erase(evict_path)
	_stream_cache[path] = stream
	_stream_access_order.append(path)
	return stream


func _list_tracks(folder: String) -> Array[String]:
	if _folder_cache.has(folder):
		return _folder_cache[folder]
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
				var original_path := folder + original
				if FileAccess.file_exists(original_path):
					tracks.append(original_path)
		file_name = dir.get_next()
	dir.list_dir_end()
	_folder_cache[folder] = tracks
	return tracks
