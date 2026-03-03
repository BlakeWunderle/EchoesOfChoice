class_name ChoiceMenu extends VBoxContainer

## Vertical list of clickable buttons for player choices.
## Replaces numbered Console.ReadLine menus from C#.

signal choice_selected(index: int)

const BUTTON_MIN_SIZE := Vector2(320, 48)

var _buttons: Array[Button] = []


func _ready() -> void:
	add_theme_constant_override("separation", 10)
	alignment = BoxContainer.ALIGNMENT_CENTER


## Show a list of choices. Each option dict has:
##   "label": String (required)
##   "description": String (optional, shown as smaller text below label)
##   "disabled": bool (optional)
func show_choices(options: Array) -> void:
	_clear_buttons()
	visible = true

	for i: int in options.size():
		var opt: Dictionary = options[i]
		var btn := Button.new()
		btn.custom_minimum_size = BUTTON_MIN_SIZE
		btn.focus_mode = Control.FOCUS_ALL

		if opt.has("description") and not opt["description"].is_empty():
			btn.text = "%s\n  %s" % [opt["label"], opt["description"]]
		else:
			btn.text = opt["label"]

		if opt.get("disabled", false):
			btn.disabled = true
			btn.modulate.a = 0.5

		var idx: int = i
		btn.pressed.connect(func() -> void: _on_button_pressed(idx))
		add_child(btn)
		_buttons.append(btn)

	_wire_focus()

	# Focus first enabled button
	for btn: Button in _buttons:
		if not btn.disabled:
			btn.grab_focus()
			break


func _on_button_pressed(index: int) -> void:
	choice_selected.emit(index)


func _clear_buttons() -> void:
	for btn: Button in _buttons:
		btn.queue_free()
	_buttons.clear()


func hide_menu() -> void:
	_clear_buttons()
	visible = false


func _wire_focus() -> void:
	var enabled: Array[Button] = []
	for btn: Button in _buttons:
		if not btn.disabled:
			enabled.append(btn)

	for i: int in enabled.size():
		var btn: Button = enabled[i]
		var prev: Button = enabled[(i - 1 + enabled.size()) % enabled.size()]
		var next_btn: Button = enabled[(i + 1) % enabled.size()]
		btn.focus_neighbor_top = prev.get_path()
		btn.focus_neighbor_bottom = next_btn.get_path()
