class_name NameInput extends VBoxContainer

## Text entry field for character names.
## Shows a virtual on-screen keyboard when controller input is detected.
## Includes a Random button that fills a random fantasy name.

signal name_entered(player_name: String)
signal text_changed(new_text: String)

const _VirtualKeyboard := preload("res://scripts/ui/virtual_keyboard.gd")

const _NAME_POOL: Array[String] = [
	# Female-sounding
	"Lyra", "Elara", "Mira", "Thea", "Rowan", "Brynn", "Ivy", "Wren", "Lila", "Kira",
	"Nyla", "Freya", "Gwen", "Tessa", "Maeve", "Aria", "Petra", "Faye", "Calla", "Dara",
	"Erin", "Sable", "Neve", "Isolde", "Astrid", "Ember", "Sage", "Coral", "Adara", "Fern",
	"Rhea", "Seren", "Liora", "Veda", "Yara", "Nessa", "Anya", "Talia", "Bria", "Rue",
	"Della", "Solene", "Iris", "Gemma", "Ayla", "Iona", "Maren", "Elowen", "Ciara", "Sybil",
	# Male-sounding
	"Kael", "Dorin", "Bram", "Thorn", "Renly", "Aldric", "Cade", "Flint", "Gareth", "Torin",
	"Leif", "Ronan", "Kiran", "Orin", "Thane", "Emric", "Joss", "Soren", "Dain", "Idris",
	"Lucian", "Voss", "Wynn", "Corbin", "Aeron", "Jasper", "Kellan", "Merric", "Nolan", "Orion",
	"Pax", "Quinn", "Riven", "Stellan", "Tavish", "Varen", "Warrick", "Cedric", "Fenris", "Gale",
	"Heath", "Isen", "Jorin", "Landry", "Niall", "Osric", "Phelan", "Hadric", "Calder", "Torsten",
]

var _prompt_label: Label
var _line_edit: LineEdit
var _btn_row: HBoxContainer
var _random_btn: Button
var _confirm_btn: Button
var _virtual_kb: VirtualKeyboard


func _ready() -> void:
	SettingsManager.font_size_changed.connect(_on_font_size_changed)
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

	_btn_row = HBoxContainer.new()
	_btn_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_btn_row.add_theme_constant_override("separation", 16)
	add_child(_btn_row)

	_random_btn = Button.new()
	_random_btn.text = "Random"
	_random_btn.custom_minimum_size = Vector2(200, 44)
	_random_btn.pressed.connect(_on_random_pressed)
	_btn_row.add_child(_random_btn)

	_confirm_btn = Button.new()
	_confirm_btn.text = "Confirm"
	_confirm_btn.custom_minimum_size = Vector2(200, 44)
	_confirm_btn.pressed.connect(_on_confirm_pressed)
	_btn_row.add_child(_confirm_btn)

	_virtual_kb = _VirtualKeyboard.new()
	_virtual_kb.visible = false
	_virtual_kb.character_entered.connect(_on_vk_char)
	_virtual_kb.backspace_pressed.connect(_on_vk_backspace)
	_virtual_kb.confirmed.connect(_hide_virtual_keyboard)
	add_child(_virtual_kb)

	# Focus neighbors for controller navigation
	_line_edit.focus_neighbor_bottom = _random_btn.get_path()
	_random_btn.focus_neighbor_top = _line_edit.get_path()
	_random_btn.focus_neighbor_right = _confirm_btn.get_path()
	_confirm_btn.focus_neighbor_top = _line_edit.get_path()
	_confirm_btn.focus_neighbor_left = _random_btn.get_path()


func show_prompt(text: String) -> void:
	_prompt_label.text = text
	_line_edit.text = ""
	_line_edit.editable = true
	_line_edit.placeholder_text = "Enter name..."
	_confirm_btn.visible = true
	_virtual_kb.visible = false
	_btn_row.visible = true
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
	# Controller accept on line edit -> show virtual keyboard
	if not _virtual_kb.visible:
		if _line_edit.has_focus() and event.is_action_pressed("ui_accept"):
			if event is InputEventJoypadButton:
				_show_virtual_keyboard()
				get_viewport().set_input_as_handled()
	# Start button or keyboard input while virtual keyboard shown -> hide it
	elif _virtual_kb.visible:
		if event is InputEventJoypadButton and event.pressed \
				and event.button_index == JOY_BUTTON_START:
			_hide_virtual_keyboard()
			get_viewport().set_input_as_handled()
		elif event is InputEventKey and event.pressed and not event.echo:
			_hide_virtual_keyboard()


func _show_virtual_keyboard() -> void:
	_virtual_kb.visible = true
	_line_edit.editable = false
	_btn_row.visible = false
	_virtual_kb.grab_first_focus()


func _hide_virtual_keyboard() -> void:
	_virtual_kb.visible = false
	_line_edit.editable = true
	_btn_row.visible = true
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


func _on_random_pressed() -> void:
	_line_edit.text = _NAME_POOL[randi() % _NAME_POOL.size()]
	_line_edit.caret_column = _line_edit.text.length()


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


func _on_font_size_changed(size: int) -> void:
	if _prompt_label:
		_prompt_label.add_theme_font_size_override("font_size", size)
