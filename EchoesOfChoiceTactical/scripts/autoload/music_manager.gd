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
	MusicContext.BATTLE_SCIFI: "res://assets/audio/music/battle_scifi/",
	MusicContext.BATTLE_DARK: "res://assets/audio/music/battle_dark/",
	MusicContext.EXPLORATION: "res://assets/audio/music/exploration/",
	MusicContext.TOWN: "res://assets/audio/music/town/",
	MusicContext.CUTSCENE: "res://assets/audio/music/cutscene/",
}

var _player_a: AudioStreamPlayer
var _player_b: AudioStreamPlayer
var _active_player: AudioStreamPlayer
var _current_path: String = ""
var _current_context: int = -1
var _music_volume_linear: float = 0.8
var _headless: bool = false


func _ready() -> void:
	if AudioLoader.is_headless():
		_headless = true
		return

	_player_a = AudioStreamPlayer.new()
	_player_a.bus = "Music"
	_player_a.volume_db = linear_to_db(_music_volume_linear)
	add_child(_player_a)

	_player_b = AudioStreamPlayer.new()
	_player_b.bus = "Music"
	_player_b.volume_db = linear_to_db(0.0)
	add_child(_player_b)

	_active_player = _player_a

	_ensure_audio_bus()


func _ensure_audio_bus() -> void:
	if AudioServer.get_bus_index("Music") == -1:
		var idx: int = AudioServer.bus_count
		AudioServer.add_bus(idx)
		AudioServer.set_bus_name(idx, "Music")
		AudioServer.set_bus_send(idx, "Master")


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


func play_music(path: String, fade_duration: float = 1.0) -> void:
	if _headless:
		return
	if path == _current_path:
		return
	_current_path = path

	var stream: AudioStream = AudioLoader.load_stream(path)
	if stream == null:
		push_warning("MusicManager: Could not load: " + path)
		return

	var old_player: AudioStreamPlayer = _active_player
	var new_player: AudioStreamPlayer = _player_b if _active_player == _player_a else _player_a
	_active_player = new_player

	new_player.stream = stream
	new_player.volume_db = linear_to_db(0.0)
	new_player.play()

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(old_player, "volume_db", linear_to_db(0.0), fade_duration)
	tween.tween_property(new_player, "volume_db", linear_to_db(_music_volume_linear), fade_duration)
	tween.set_parallel(false)
	tween.tween_callback(old_player.stop)


func stop_music(fade_duration: float = 1.0) -> void:
	if _headless:
		return
	_current_path = ""
	_current_context = -1
	var tween := create_tween()
	tween.tween_property(_active_player, "volume_db", linear_to_db(0.0), fade_duration)
	tween.tween_callback(_active_player.stop)


func set_music_volume(linear: float) -> void:
	_music_volume_linear = clampf(linear, 0.0, 1.0)
	if _headless:
		return
	if _active_player.playing:
		_active_player.volume_db = linear_to_db(_music_volume_linear)


func clear_context() -> void:
	_current_context = -1


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
