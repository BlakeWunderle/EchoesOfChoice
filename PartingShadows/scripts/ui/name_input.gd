class_name NameInput extends VBoxContainer

## Text entry field for character names.
## Shows a virtual on-screen keyboard when controller input is detected.

signal name_entered(player_name: String)
signal text_changed(new_text: String)

const _VirtualKeyboard := preload("res://scripts/ui/virtual_keyboard.gd")

var _prompt_label: Label
var _line_edit: LineEdit
var _confirm_btn: Button
var _virtual_kb: VirtualKeyboard


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	alignment = BoxContainer.ALIGNMENT_CENTER
	add_theme_constant_override("separation", 12)

	_prompt_label = Label.new()
	_prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_prompt_label.add_theme_font_size_override("font_size", 20)
	add_child(_prompt_label)

	_line_edit = LineEdit.new()
	_line_edit.placeholder_text = "Enter name..."
	_line_edit.custom_minimum_size = Vector2(300, 40)
	_line_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
	_line_edit.max_length = 20
	_line_edit.text_submitted.connect(_on_text_submitted)
	_line_edit.text_changed.connect(func(t: String) -> void: text_changed.emit(t))
	add_child(_line_edit)

	_confirm_btn = Button.new()
	_confirm_btn.text = "Confirm"
	_confirm_btn.custom_minimum_size = Vector2(200, 44)
	_confirm_btn.pressed.connect(_on_confirm_pressed)
	add_child(_confirm_btn)

	_virtual_kb = _VirtualKeyboard.new()
	_virtual_kb.visible = false
	_virtual_kb.character_entered.connect(_on_vk_char)
	_virtual_kb.backspace_pressed.connect(_on_vk_backspace)
	_virtual_kb.confirmed.connect(_on_confirm_pressed)
	add_child(_virtual_kb)


func show_prompt(text: String) -> void:
	_prompt_label.text = text
	_line_edit.text = ""
	_line_edit.editable = true
	_line_edit.placeholder_text = "Enter name..."
	_confirm_btn.visible = true
	_virtual_kb.visible = false
	visible = true
	_line_edit.grab_focus()


func show_mirror(prompt: String) -> void:
	_prompt_label.text = prompt
	_line_edit.text = ""
	_line_edit.editable = false
	_line_edit.placeholder_text = ""
	_confirm_btn.visible = false
	_virtual_kb.visible = false
	visible = true


func set_mirror_text(text: String) -> void:
	_line_edit.text = text


func _input(event: InputEvent) -> void:
	if not visible:
		return
	if LocalCoop.is_event_gated(event):
		return
	# Controller input while virtual keyboard hidden → show it
	if not _virtual_kb.visible:
		if event is InputEventJoypadButton and event.pressed:
			_show_virtual_keyboard()
			get_viewport().set_input_as_handled()
		elif event is InputEventJoypadMotion and absf(event.axis_value) >= 0.5:
			_show_virtual_keyboard()
			get_viewport().set_input_as_handled()
	# Keyboard input while virtual keyboard shown → hide it
	elif event is InputEventKey and event.pressed and not event.echo:
		_hide_virtual_keyboard()


func _show_virtual_keyboard() -> void:
	_virtual_kb.visible = true
	_line_edit.editable = false
	_confirm_btn.visible = false
	_virtual_kb.grab_first_focus()


func _hide_virtual_keyboard() -> void:
	_virtual_kb.visible = false
	_line_edit.editable = true
	_confirm_btn.visible = true
	_line_edit.grab_focus()


func _on_vk_char(ch: String) -> void:
	if _line_edit.text.length() < _line_edit.max_length:
		_line_edit.text += ch
		_line_edit.caret_column = _line_edit.text.length()


func _on_vk_backspace() -> void:
	if not _line_edit.text.is_empty():
		_line_edit.text = _line_edit.text.substr(0, _line_edit.text.length() - 1)
		_line_edit.caret_column = _line_edit.text.length()


func _on_text_submitted(_text: String) -> void:
	_on_confirm_pressed()


func _on_confirm_pressed() -> void:
	var entered: String = _line_edit.text.strip_edges()
	if entered.is_empty():
		_line_edit.placeholder_text = "Please enter a name..."
		if _virtual_kb.visible:
			_virtual_kb.grab_first_focus()
		else:
			_line_edit.grab_focus()
		return
	name_entered.emit(entered)
