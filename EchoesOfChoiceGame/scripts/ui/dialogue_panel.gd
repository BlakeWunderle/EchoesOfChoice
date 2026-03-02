class_name DialoguePanel extends PanelContainer

## Displays narrative text line-by-line with a continue prompt.
## Replaces Console.WriteLine + Pause() from the C# version.

signal all_text_finished

const CHAR_DELAY: float = 0.02  ## Seconds between characters for typewriter effect

var _lines: Array = []
var _current_line: int = 0
var _typing: bool = false
var _full_text: String = ""
var _accepting_input: bool = false  ## Guard against stray clicks from scene transitions

var _label: RichTextLabel
var _continue_label: Label
var _margin: MarginContainer


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	size_flags_horizontal = Control.SIZE_FILL
	size_flags_vertical = Control.SIZE_FILL

	_margin = MarginContainer.new()
	_margin.add_theme_constant_override("margin_left", 24)
	_margin.add_theme_constant_override("margin_right", 24)
	_margin.add_theme_constant_override("margin_top", 16)
	_margin.add_theme_constant_override("margin_bottom", 16)
	add_child(_margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	_margin.add_child(vbox)

	_label = RichTextLabel.new()
	_label.bbcode_enabled = true
	_label.scroll_active = true
	_label.scroll_following = true
	_label.fit_content = false
	_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_label.add_theme_font_size_override("normal_font_size", 18)
	vbox.add_child(_label)

	_continue_label = Label.new()
	_continue_label.text = "Press Space or click to continue..."
	_continue_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_continue_label.add_theme_font_size_override("font_size", 14)
	_continue_label.modulate.a = 0.0
	vbox.add_child(_continue_label)


func show_text(lines: Array) -> void:
	_lines = lines
	_current_line = 0
	_label.clear()
	_continue_label.modulate.a = 0.0
	visible = true
	_accepting_input = false
	_start_input_guard()
	_type_next_line()


func _start_input_guard() -> void:
	## Brief delay before accepting input to prevent scene-transition clicks
	await get_tree().create_timer(0.3).timeout
	_accepting_input = true


func _type_next_line() -> void:
	if _current_line >= _lines.size():
		_show_continue()
		return

	if _current_line > 0:
		_label.append_text("\n\n")

	_full_text = _lines[_current_line]
	_typing = true

	var chars_added: int = 0
	for ch: String in _full_text:
		_label.append_text(ch)
		chars_added += 1
		if not _typing:
			# Player pressed advance — show rest instantly
			var remaining: String = _full_text.substr(chars_added)
			_label.append_text(remaining)
			break
		await get_tree().create_timer(CHAR_DELAY).timeout

	_typing = false
	_current_line += 1
	_type_next_line()


func _show_continue() -> void:
	_continue_label.modulate.a = 1.0
	_start_pulse()


func _start_pulse() -> void:
	var tween := create_tween().set_loops()
	tween.tween_property(_continue_label, "modulate:a", 0.5, 0.8)
	tween.tween_property(_continue_label, "modulate:a", 1.0, 0.8)


func _input(event: InputEvent) -> void:
	if not visible or not _accepting_input:
		return

	var pressed: bool = false
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
			pressed = true
	elif event is InputEventMouseButton and event.pressed:
		pressed = true

	if not pressed:
		return

	get_viewport().set_input_as_handled()

	if _typing:
		# Skip typewriter — show the rest of the current line immediately
		_typing = false
	elif _current_line >= _lines.size():
		# All lines shown and player pressed continue
		_continue_label.modulate.a = 0.0
		all_text_finished.emit()
