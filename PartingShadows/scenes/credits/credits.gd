extends Control

## Scrolling credits scene. Auto-scrolls upward with tween animation.
## Any key or button press returns to the title screen.

const SCROLL_DURATION := 30.0
const CREDITS_TRACK := "res://assets/audio/music/cutscene/#1 Alt 2.wav"

var _scroll_container: ScrollContainer
var _credits_vbox: VBoxContainer
var _scroll_tween: Tween
var _can_skip: bool = false


func _ready() -> void:
	MusicManager.play_music(CREDITS_TRACK)
	_build_ui()
	_start_scroll()


func _build_ui() -> void:
	# Dark background
	var bg := ColorRect.new()
	bg.color = Color(0.03, 0.03, 0.06)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	_scroll_container = ScrollContainer.new()
	_scroll_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	_scroll_container.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	add_child(_scroll_container)

	_credits_vbox = VBoxContainer.new()
	_credits_vbox.add_theme_constant_override("separation", 8)
	_credits_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll_container.add_child(_credits_vbox)

	# Initial spacer to start credits below screen
	_add_spacer(720)

	_add_heading("PARTING SHADOWS")
	_add_spacer(40)

	_add_heading("Game Design & Development")
	_add_line("Wunderelf Studios")
	_add_spacer(30)

	_add_heading("Programming")
	_add_line("Wunderelf Studios")
	_add_spacer(30)

	_add_heading("Built With")
	_add_line("Godot Engine 4.6")
	_add_line("godotengine.org")
	_add_spacer(30)

	_add_heading("Music")
	_add_line("Fantasy Tension Series")
	_add_line("Sad Despair Series")
	_add_line("Medieval & Town Tracks")
	_add_line("Boss Tracks")
	_add_line("Licensed via Humble Bundle")
	_add_spacer(30)

	_add_heading("Sound Effects")
	_add_line("Combat & UI Sound Packs")
	_add_line("Licensed via Humble Bundle")
	_add_spacer(30)

	_add_heading("Art")
	_add_line("Battle backgrounds and character portraits")
	_add_line("created with Midjourney")
	_add_spacer(30)

	_add_heading("Fonts")
	_add_line("Cinzel Bold by Natanael Gama")
	_add_line("Cormorant Garamond by Christian Thalmann")
	_add_spacer(30)

	_add_heading("Special Thanks")
	_add_line("The Godot Community")
	_add_line("Lauren Doss")
	_add_line("Mandee Hamorsky")
	_add_line("Jacque Long")
	_add_line("Kelci Monzione")
	_add_line("John White")
	_add_line("Jess Pereira")
	_add_line("Josh Rollefson")
	_add_line("Wayne Uyemura")
	_add_spacer(40)

	_add_heading("\"Some paths can't be retraced.\"")
	_add_spacer(30)

	var version_str: String = ProjectSettings.get_setting("application/config/version", "")
	if not version_str.is_empty():
		_add_line("v" + version_str)
	_add_spacer(30)

	_add_line("Thank you for playing.")
	_add_spacer(720)

	# Skip hint at bottom of screen
	var hint := Label.new()
	hint.text = "Press any key to return"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 14)
	hint.add_theme_color_override("font_color", Color(0.4, 0.45, 0.5, 0.6))
	hint.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	hint.grow_vertical = Control.GROW_DIRECTION_BEGIN
	hint.offset_top = -40
	add_child(hint)


func _add_heading(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 28)
	label.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	_credits_vbox.add_child(label)


func _add_line(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 20)
	label.add_theme_color_override("font_color", Color(0.75, 0.8, 0.85))
	_credits_vbox.add_child(label)


func _add_spacer(height: float) -> void:
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, height)
	_credits_vbox.add_child(spacer)


func _start_scroll() -> void:
	# Wait a frame so layout is calculated
	await get_tree().process_frame
	var max_scroll: int = int(_credits_vbox.size.y - _scroll_container.size.y)
	if max_scroll <= 0:
		_can_skip = true
		return

	_scroll_tween = create_tween()
	_scroll_tween.tween_property(_scroll_container, "scroll_vertical", max_scroll, SCROLL_DURATION)
	_scroll_tween.finished.connect(_on_scroll_finished)

	# Allow skipping after a short delay
	await get_tree().create_timer(1.0).timeout
	_can_skip = true


func _on_scroll_finished() -> void:
	# Wait a moment then return to title
	await get_tree().create_timer(2.0).timeout
	_return_to_title()


func _unhandled_input(event: InputEvent) -> void:
	if not _can_skip:
		return
	if event is InputEventKey and event.pressed:
		_return_to_title()
	elif event is InputEventJoypadButton and event.pressed:
		_return_to_title()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_return_to_title()


func _return_to_title() -> void:
	_can_skip = false
	if _scroll_tween and _scroll_tween.is_running():
		_scroll_tween.kill()
	SceneManager.change_scene("res://scenes/title/title.tscn")
