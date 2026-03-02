class_name NameInput extends VBoxContainer

## Text entry field for character names.
## Replaces Console.ReadLine for free-text input in C#.

signal name_entered(player_name: String)

var _prompt_label: Label
var _line_edit: LineEdit
var _confirm_btn: Button


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
	add_child(_line_edit)

	_confirm_btn = Button.new()
	_confirm_btn.text = "Confirm"
	_confirm_btn.custom_minimum_size = Vector2(200, 44)
	_confirm_btn.pressed.connect(_on_confirm_pressed)
	add_child(_confirm_btn)


func show_prompt(text: String) -> void:
	_prompt_label.text = text
	_line_edit.text = ""
	visible = true
	_line_edit.grab_focus()


func _on_text_submitted(_text: String) -> void:
	_on_confirm_pressed()


func _on_confirm_pressed() -> void:
	var entered: String = _line_edit.text.strip_edges()
	if entered.is_empty():
		_line_edit.placeholder_text = "Please enter a name..."
		_line_edit.grab_focus()
		return
	name_entered.emit(entered)
