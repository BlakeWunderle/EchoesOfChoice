extends Control

## Studio splash screen. Shows Wunderelf Studios branding, then auto-advances
## to the title screen. Press any key to skip.

const _TITLE_SCENE: String = "res://scenes/title/title.tscn"
const _LOGO_PATH: String = "res://assets/art/ui/wunderelf_logo.png"

const _INITIAL_DELAY: float = 0.5
const _LOGO_FADE_IN: float = 1.0
const _TEXT_FADE_IN: float = 0.5
const _HOLD_DURATION: float = 1.5

var _transitioning: bool = false


func _ready() -> void:
	SceneManager.preload_scene(_TITLE_SCENE)
	_build_ui()
	_play_sequence()


func _build_ui() -> void:
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 0)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(vbox)

	# Elf logo image
	if ResourceLoader.exists(_LOGO_PATH):
		var logo := TextureRect.new()
		logo.texture = load(_LOGO_PATH)
		logo.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		logo.custom_minimum_size = Vector2(400, 400)
		logo.modulate.a = 0.0
		logo.name = "Logo"
		vbox.add_child(logo)

	# Studio name text
	var studio_label := Label.new()
	studio_label.text = "WUNDERELF STUDIOS"
	studio_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	studio_label.add_theme_font_size_override("font_size", 42)
	studio_label.add_theme_color_override("font_color", Color(0.92, 0.82, 0.55, 1.0))
	studio_label.modulate.a = 0.0
	studio_label.name = "StudioName"
	vbox.add_child(studio_label)


func _play_sequence() -> void:
	await get_tree().create_timer(_INITIAL_DELAY).timeout
	if _transitioning:
		return

	# Fade in logo
	var logo: TextureRect = find_child("Logo") as TextureRect
	if logo:
		var tween := create_tween()
		tween.tween_property(logo, "modulate:a", 1.0, _LOGO_FADE_IN)
		await tween.finished
		if _transitioning:
			return

	# Fade in studio name
	var studio: Label = find_child("StudioName") as Label
	if studio:
		var t_text := create_tween()
		t_text.tween_property(studio, "modulate:a", 1.0, _TEXT_FADE_IN)
		await t_text.finished
		if _transitioning:
			return

	# Hold
	await get_tree().create_timer(_HOLD_DURATION).timeout
	if _transitioning:
		return

	_go_to_title()


func _unhandled_input(event: InputEvent) -> void:
	if _transitioning:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		_go_to_title()
	elif event is InputEventMouseButton and event.pressed:
		_go_to_title()
	elif event is InputEventJoypadButton and event.pressed:
		_go_to_title()


func _go_to_title() -> void:
	if _transitioning:
		return
	_transitioning = true
	SceneManager.change_scene(_TITLE_SCENE)
