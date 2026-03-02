extends RefCounted


static func load_stream(res_path: String) -> AudioStream:
	if is_headless():
		return null

	var abs_path: String = ProjectSettings.globalize_path(res_path)
	var lower := abs_path.to_lower()

	if lower.ends_with(".wav"):
		return _load_wav(abs_path)
	elif lower.ends_with(".ogg"):
		return _load_ogg(abs_path)
	elif lower.ends_with(".mp3"):
		return _load_mp3(abs_path)

	push_warning("AudioLoader: Unsupported format: " + res_path)
	return null


static func is_headless() -> bool:
	return DisplayServer.get_name() == "headless"


static func _load_wav(abs_path: String) -> AudioStream:
	var stream := AudioStreamWAV.load_from_file(abs_path, {})
	if stream == null:
		push_warning("AudioLoader: Failed to load WAV: " + abs_path)
	return stream


static func _load_ogg(abs_path: String) -> AudioStream:
	var stream := AudioStreamOggVorbis.load_from_file(abs_path)
	if stream == null:
		push_warning("AudioLoader: Failed to load OGG: " + abs_path)
	return stream


static func _load_mp3(abs_path: String) -> AudioStream:
	var file := FileAccess.open(abs_path, FileAccess.READ)
	if file == null:
		push_warning("AudioLoader: Cannot open MP3: " + abs_path)
		return null
	var stream := AudioStreamMP3.new()
	stream.data = file.get_buffer(file.get_length())
	return stream
