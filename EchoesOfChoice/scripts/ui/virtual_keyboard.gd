class_name VirtualKeyboard extends PanelContainer

## On-screen keyboard for controller-based text entry.
## Emits signals as the player selects characters, backspaces, or confirms.

signal character_entered(ch: String)
signal backspace_pressed
signal confirmed

const CHARS: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ-' "
const COLUMNS: int = 10

var _grid: GridContainer
var _char_buttons: Array[Button] = []
var _backspace_btn: Button
var _done_btn: Button


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	custom_minimum_size = Vector2(500, 0)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	margin.add_child(vbox)

	# Character grid
	_grid = GridContainer.new()
	_grid.columns = COLUMNS
	_grid.add_theme_constant_override("h_separation", 4)
	_grid.add_theme_constant_override("v_separation", 4)
	vbox.add_child(_grid)

	for i: int in CHARS.length():
		var ch: String = CHARS[i]
		var btn := Button.new()
		btn.text = " " if ch == " " else ch
		if ch == " ":
			btn.tooltip_text = "Space"
		btn.custom_minimum_size = Vector2(44, 40)
		btn.focus_mode = Control.FOCUS_ALL
		var captured_ch: String = ch
		btn.pressed.connect(func() -> void: character_entered.emit(captured_ch))
		_grid.add_child(btn)
		_char_buttons.append(btn)

	# Bottom row: Backspace + Done
	var bottom := HBoxContainer.new()
	bottom.add_theme_constant_override("separation", 8)
	bottom.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(bottom)

	_backspace_btn = Button.new()
	_backspace_btn.text = "Backspace"
	_backspace_btn.custom_minimum_size = Vector2(140, 44)
	_backspace_btn.focus_mode = Control.FOCUS_ALL
	_backspace_btn.pressed.connect(func() -> void: backspace_pressed.emit())
	bottom.add_child(_backspace_btn)

	_done_btn = Button.new()
	_done_btn.text = "Done"
	_done_btn.custom_minimum_size = Vector2(140, 44)
	_done_btn.focus_mode = Control.FOCUS_ALL
	_done_btn.pressed.connect(func() -> void: confirmed.emit())
	bottom.add_child(_done_btn)

	_wire_focus()


func _wire_focus() -> void:
	var row_count: int = ceili(float(_char_buttons.size()) / COLUMNS)

	# Wire character grid: left/right wrap within rows, up/down between rows
	for i: int in _char_buttons.size():
		var btn: Button = _char_buttons[i]
		var row: int = i / COLUMNS
		var col: int = i % COLUMNS
		var row_start: int = row * COLUMNS
		var row_end: int = mini(row_start + COLUMNS, _char_buttons.size()) - 1

		# Left/right wrap within row
		var left_idx: int = row_start + ((col - 1 + (row_end - row_start + 1)) % (row_end - row_start + 1))
		var right_idx: int = row_start + ((col + 1) % (row_end - row_start + 1))
		btn.focus_neighbor_left = _char_buttons[left_idx].get_path()
		btn.focus_neighbor_right = _char_buttons[right_idx].get_path()

		# Up: previous row same column, or wrap to bottom buttons
		if row > 0:
			var up_idx: int = (row - 1) * COLUMNS + col
			btn.focus_neighbor_top = _char_buttons[up_idx].get_path()
		else:
			# Top row wraps down to bottom action buttons
			if col < COLUMNS / 2:
				btn.focus_neighbor_top = _backspace_btn.get_path()
			else:
				btn.focus_neighbor_top = _done_btn.get_path()

		# Down: next row same column, or go to bottom buttons
		if row < row_count - 1:
			var down_idx: int = (row + 1) * COLUMNS + col
			if down_idx < _char_buttons.size():
				btn.focus_neighbor_bottom = _char_buttons[down_idx].get_path()
			else:
				# Partial last row, go to bottom buttons
				if col < COLUMNS / 2:
					btn.focus_neighbor_bottom = _backspace_btn.get_path()
				else:
					btn.focus_neighbor_bottom = _done_btn.get_path()
		else:
			# Last row goes to bottom buttons
			if col < COLUMNS / 2:
				btn.focus_neighbor_bottom = _backspace_btn.get_path()
			else:
				btn.focus_neighbor_bottom = _done_btn.get_path()

	# Wire bottom buttons to each other and back to grid
	_backspace_btn.focus_neighbor_left = _done_btn.get_path()
	_backspace_btn.focus_neighbor_right = _done_btn.get_path()
	_done_btn.focus_neighbor_left = _backspace_btn.get_path()
	_done_btn.focus_neighbor_right = _backspace_btn.get_path()

	# Bottom buttons up → last grid row
	var last_row_start: int = (row_count - 1) * COLUMNS
	_backspace_btn.focus_neighbor_top = _char_buttons[last_row_start].get_path()
	var last_row_mid: int = mini(last_row_start + COLUMNS / 2, _char_buttons.size() - 1)
	_done_btn.focus_neighbor_top = _char_buttons[last_row_mid].get_path()

	# Bottom buttons down → first grid row (wrap)
	_backspace_btn.focus_neighbor_bottom = _char_buttons[0].get_path()
	_done_btn.focus_neighbor_bottom = _char_buttons[COLUMNS / 2].get_path()


func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		backspace_pressed.emit()


func grab_first_focus() -> void:
	if not _char_buttons.is_empty():
		_char_buttons[0].grab_focus()
