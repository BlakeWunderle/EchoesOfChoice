extends Node

## Global settings persistence. Loads from user://settings.json on startup,
## saves after any change. Emits signals so systems can react in real time.

const SETTINGS_PATH := "user://settings.json"

# -- Signals -----------------------------------------------------------------

signal music_volume_changed(linear: float)
signal sfx_volume_changed(linear: float)
signal master_volume_changed(linear: float)
signal text_speed_changed(delay: float)
signal display_mode_changed(mode: String)
signal resolution_changed(res: Vector2i)
signal combat_pause_changed(seconds: float)
signal font_size_changed(size: int)
signal color_blind_mode_changed(mode: String)
signal screen_reader_changed(enabled: bool)
signal reduced_motion_changed(enabled: bool)

# -- Defaults ----------------------------------------------------------------

const DEFAULT_MUSIC_VOLUME := 0.8
const DEFAULT_SFX_VOLUME := 0.8
const DEFAULT_MASTER_VOLUME := 1.0
const DEFAULT_TEXT_SPEED := 0.02
const DEFAULT_DISPLAY_MODE := "fullscreen"
const DEFAULT_RESOLUTION := "1280x720"
const DEFAULT_COMBAT_PAUSE := 1.2
const DEFAULT_FONT_SIZE := 24
const DEFAULT_COLOR_BLIND_MODE := "normal"
const DEFAULT_SCREEN_READER := false
const DEFAULT_REDUCED_MOTION := false

# -- State -------------------------------------------------------------------

var music_volume: float = DEFAULT_MUSIC_VOLUME:
	set(v):
		v = clampf(v, 0.0, 1.0)
		if music_volume == v:
			return
		music_volume = v
		music_volume_changed.emit(v)
		_save()

var sfx_volume: float = DEFAULT_SFX_VOLUME:
	set(v):
		v = clampf(v, 0.0, 1.0)
		if sfx_volume == v:
			return
		sfx_volume = v
		sfx_volume_changed.emit(v)
		_save()

var master_volume: float = DEFAULT_MASTER_VOLUME:
	set(v):
		v = clampf(v, 0.0, 1.0)
		if master_volume == v:
			return
		master_volume = v
		AudioServer.set_bus_volume_db(0, linear_to_db(maxf(0.0001, v)))
		master_volume_changed.emit(v)
		_save()

var text_speed: float = DEFAULT_TEXT_SPEED:
	set(v):
		if text_speed == v:
			return
		text_speed = v
		text_speed_changed.emit(v)
		_save()

var display_mode: String = DEFAULT_DISPLAY_MODE:
	set(v):
		if display_mode == v:
			return
		display_mode = v
		_apply_display()
		display_mode_changed.emit(v)
		_save()

var resolution: String = DEFAULT_RESOLUTION:
	set(v):
		if resolution == v:
			return
		resolution = v
		_apply_display()
		resolution_changed.emit(parse_resolution(v))
		_save()

var combat_pause: float = DEFAULT_COMBAT_PAUSE:
	set(v):
		if combat_pause == v:
			return
		combat_pause = v
		combat_pause_changed.emit(v)
		_save()

var font_size: int = DEFAULT_FONT_SIZE:
	set(v):
		if font_size == v:
			return
		var old_size: int = font_size
		font_size = v
		_apply_font_size(old_size, v)
		font_size_changed.emit(v)
		_save()

var color_blind_mode: String = DEFAULT_COLOR_BLIND_MODE:
	set(v):
		if color_blind_mode == v:
			return
		color_blind_mode = v
		color_blind_mode_changed.emit(v)
		_save()

var screen_reader: bool = DEFAULT_SCREEN_READER:
	set(v):
		if screen_reader == v:
			return
		screen_reader = v
		screen_reader_changed.emit(v)
		_save()

var reduced_motion: bool = DEFAULT_REDUCED_MOTION:
	set(v):
		if reduced_motion == v:
			return
		reduced_motion = v
		reduced_motion_changed.emit(v)
		_save()


# -- Color Blind Palettes ---------------------------------------------------

# Each palette: { hp_high, hp_mid, hp_low, mp, buff, debuff }
const COLOR_PALETTES: Dictionary = {
	"normal": {
		"hp_high": Color(0.2, 0.9, 0.2),
		"hp_mid": Color(0.9, 0.9, 0.2),
		"hp_low": Color(0.9, 0.2, 0.2),
		"mp": Color(0.3, 0.5, 0.9),
		"buff": Color(0.5, 1.0, 0.5),
		"debuff": Color(1.0, 0.5, 0.5),
	},
	"deuteranopia": {
		"hp_high": Color(0.3, 0.6, 1.0),
		"hp_mid": Color(1.0, 0.8, 0.3),
		"hp_low": Color(1.0, 0.4, 0.3),
		"mp": Color(0.6, 0.4, 0.9),
		"buff": Color(0.4, 0.7, 1.0),
		"debuff": Color(1.0, 0.6, 0.3),
	},
	"protanopia": {
		"hp_high": Color(0.3, 0.6, 1.0),
		"hp_mid": Color(1.0, 0.85, 0.3),
		"hp_low": Color(0.9, 0.4, 0.6),
		"mp": Color(0.6, 0.4, 0.9),
		"buff": Color(0.4, 0.7, 1.0),
		"debuff": Color(0.9, 0.5, 0.6),
	},
	"tritanopia": {
		"hp_high": Color(0.3, 0.85, 0.85),
		"hp_mid": Color(0.9, 0.5, 0.7),
		"hp_low": Color(0.9, 0.2, 0.2),
		"mp": Color(0.3, 0.5, 0.9),
		"buff": Color(0.4, 0.9, 0.9),
		"debuff": Color(0.9, 0.5, 0.6),
	},
}


func get_palette() -> Dictionary:
	return COLOR_PALETTES.get(color_blind_mode, COLOR_PALETTES["normal"])


# -- Lifecycle ---------------------------------------------------------------

func _ready() -> void:
	_load()
	_apply_all()


func reset_defaults() -> void:
	music_volume = DEFAULT_MUSIC_VOLUME
	sfx_volume = DEFAULT_SFX_VOLUME
	master_volume = DEFAULT_MASTER_VOLUME
	text_speed = DEFAULT_TEXT_SPEED
	display_mode = DEFAULT_DISPLAY_MODE
	resolution = DEFAULT_RESOLUTION
	combat_pause = DEFAULT_COMBAT_PAUSE
	font_size = DEFAULT_FONT_SIZE
	color_blind_mode = DEFAULT_COLOR_BLIND_MODE
	screen_reader = DEFAULT_SCREEN_READER
	reduced_motion = DEFAULT_REDUCED_MOTION


# -- Persistence -------------------------------------------------------------

func _load() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if not file:
		return
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		return
	file.close()
	var data: Dictionary = json.data
	music_volume = data.get("music_volume", DEFAULT_MUSIC_VOLUME)
	sfx_volume = data.get("sfx_volume", DEFAULT_SFX_VOLUME)
	master_volume = data.get("master_volume", DEFAULT_MASTER_VOLUME)
	text_speed = data.get("text_speed", DEFAULT_TEXT_SPEED)
	# Backward compat: old saves have "fullscreen" bool, new saves have "display_mode"
	if data.has("display_mode"):
		display_mode = data.get("display_mode", DEFAULT_DISPLAY_MODE)
	elif data.get("fullscreen", true):
		display_mode = "fullscreen"
	else:
		display_mode = "windowed"
	resolution = data.get("resolution", DEFAULT_RESOLUTION)
	combat_pause = data.get("combat_pause", DEFAULT_COMBAT_PAUSE)
	font_size = int(data.get("font_size", DEFAULT_FONT_SIZE))
	color_blind_mode = data.get("color_blind_mode", DEFAULT_COLOR_BLIND_MODE)
	screen_reader = data.get("screen_reader", DEFAULT_SCREEN_READER)
	reduced_motion = data.get("reduced_motion", DEFAULT_REDUCED_MOTION)
	# Load custom key bindings into InputConfig
	var bindings: Dictionary = data.get("key_bindings", {})
	if not bindings.is_empty():
		InputConfig.load_bindings(bindings)


func _save() -> void:
	var data := {
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"master_volume": master_volume,
		"text_speed": text_speed,
		"display_mode": display_mode,
		"resolution": resolution,
		"combat_pause": combat_pause,
		"font_size": font_size,
		"color_blind_mode": color_blind_mode,
		"screen_reader": screen_reader,
		"reduced_motion": reduced_motion,
		"key_bindings": InputConfig.keyboard_bindings,
	}
	var json_str: String = JSON.stringify(data, "\t")
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_str)
		file.close()


var _game_theme: Theme = preload("res://resources/gui/game_theme.tres")


func _apply_font_size(old_base: int, new_base: int) -> void:
	# Update the project theme so un-overridden controls update automatically
	_game_theme.default_font_size = new_base
	_game_theme.set_font_size("font_size", "Button", new_base)
	_game_theme.set_font_size("font_size", "Label", new_base)
	_game_theme.set_font_size("font_size", "OptionButton", new_base)
	_game_theme.set_font_size("normal_font_size", "RichTextLabel", new_base)
	# Walk the scene tree and scale per-control font size overrides
	if get_tree():
		_update_font_overrides(get_tree().root, old_base, new_base)


func _update_font_overrides(node: Node, old_base: int, new_base: int) -> void:
	if node is Control:
		var ctrl := node as Control
		_scale_override(ctrl, "font_size", old_base, new_base)
		_scale_override(ctrl, "normal_font_size", old_base, new_base)
	for child: Node in node.get_children():
		_update_font_overrides(child, old_base, new_base)


func _scale_override(ctrl: Control, prop: String, old_base: int, new_base: int) -> void:
	if not ctrl.has_theme_font_size_override(prop):
		return
	var current: int = ctrl.get_theme_font_size(prop)
	if current < 16:
		return  # Skip tiny compact UI elements (fighter bars, portrait cards)
	var delta: int = current - old_base
	ctrl.add_theme_font_size_override(prop, new_base + delta)


func _apply_all() -> void:
	# Apply font size to theme
	_apply_font_size(font_size, font_size)
	# Apply master volume to the Master audio bus
	AudioServer.set_bus_volume_db(0, linear_to_db(maxf(0.0001, master_volume)))
	# Apply music volume
	music_volume_changed.emit(music_volume)
	# Apply SFX volume
	var sfx_bus: int = AudioServer.get_bus_index(&"SFX")
	if sfx_bus >= 0:
		AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(maxf(0.0001, sfx_volume)))
	sfx_volume_changed.emit(sfx_volume)
	# Apply display
	_apply_display()


func _apply_display() -> void:
	match display_mode:
		"fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		"borderless":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		"windowed":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_size(parse_resolution(resolution))
			# Center window on screen
			var screen_size: Vector2i = DisplayServer.screen_get_size()
			var win_size: Vector2i = parse_resolution(resolution)
			var pos: Vector2i = (screen_size - win_size) / 2
			DisplayServer.window_set_position(pos)


func save_key_bindings(bindings: Dictionary) -> void:
	## Called by InputConfig when bindings change.
	_save()


static func parse_resolution(res_str: String) -> Vector2i:
	var parts: PackedStringArray = res_str.split("x")
	if parts.size() == 2:
		return Vector2i(int(parts[0]), int(parts[1]))
	return Vector2i(1280, 720)
