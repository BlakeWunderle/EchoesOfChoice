class_name ChoiceMenu extends VBoxContainer

## Clickable button menu for player choices.
## Supports vertical list (default) and 2-column grid layout.
## In local co-op, each player gets their own colored cursor overlay.
## All players on the same button shows a white combined border.

signal choice_selected(index: int)
signal option_focused(index: int)

const BUTTON_MIN_SIZE := Vector2(420, 48)
const GRID_BUTTON_MIN_SIZE := Vector2(200, 64)
const _DESC_FONT := preload("res://assets/fonts/CormorantGaramond-SemiBold.ttf")
## Distinct cursor colors per player slot (P1 blue, P2 orange, P3 green)
const PLAYER_COLORS: Array[Color] = [
	Color(0.3, 0.65, 1.0),
	Color(1.0, 0.60, 0.15),
	Color(0.35, 1.0, 0.35),
]

var _buttons: Array[Button] = []
var _grid: GridContainer

## Co-op multi-cursor state
var _coop_mode: bool = false
var _player_cursors: Array[int] = []
var _player_overlays: Array = []   # [button_idx][player_idx] -> Panel
var _player_sbs: Array = []        # [button_idx][player_idx] -> StyleBoxFlat
var _last_nav_ms: Array[int] = []  # per-player tick at last stick navigation
const _NAV_COOLDOWN_MS: int = 280  # ms between repeated stick navigations
var _sp_last_nav_ms: int = 0       # cooldown for single-player/online left stick nav


func _ready() -> void:
	add_theme_constant_override("separation", 10)
	alignment = BoxContainer.ALIGNMENT_CENTER


## Show a list of choices. Each option dict has:
##   "label": String (required)
##   "description": String (optional, shown as smaller text below label)
##   "disabled": bool (optional)
## Set use_grid=true for 2-column Pokemon-style layout.
func show_choices(options: Array, use_grid: bool = false) -> void:
	_clear_buttons()
	visible = true

	var btn_parent: Control = self
	if use_grid:
		_grid = GridContainer.new()
		_grid.columns = 2
		_grid.add_theme_constant_override("h_separation", 12)
		_grid.add_theme_constant_override("v_separation", 8)
		# Fixed height for 3 rows so grid never resizes between menus
		var row_h: int = maxi(GRID_BUTTON_MIN_SIZE.y, SettingsManager.font_size * 2 + 28)
		_grid.custom_minimum_size.y = row_h * 3 + 16
		add_child(_grid)
		btn_parent = _grid

	for i: int in options.size():
		var opt: Dictionary = options[i]
		var btn := Button.new()
		btn.custom_minimum_size = GRID_BUTTON_MIN_SIZE if use_grid else BUTTON_MIN_SIZE
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.focus_mode = Control.FOCUS_ALL
		btn.add_theme_font_size_override("font_size", SettingsManager.font_size)
		btn.add_theme_constant_override("outline_size", 2)
		btn.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))

		var has_desc: bool = opt.has("description") and not opt["description"].is_empty()
		if has_desc:
			btn.text = ""
			var desc_text: String = opt.get("description", "")
			var desc_lines: int = desc_text.count("\n") + 1
			var desc_fs: int = maxi(SettingsManager.font_size - 2, 14)
			var est_h: int = SettingsManager.font_size + desc_fs * desc_lines + 32
			btn.custom_minimum_size.y = maxi(btn.custom_minimum_size.y, est_h)
			var vbox := VBoxContainer.new()
			vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
			vbox.alignment = BoxContainer.ALIGNMENT_CENTER
			vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var title_lbl := Label.new()
			title_lbl.text = opt["label"]
			title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			title_lbl.add_theme_font_size_override("font_size", SettingsManager.font_size)
			title_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var desc_lbl := Label.new()
			desc_lbl.text = opt["description"]
			desc_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			desc_lbl.add_theme_font_override("font", _DESC_FONT)
			desc_lbl.add_theme_font_size_override("font_size", maxi(SettingsManager.font_size - 2, 14))
			desc_lbl.add_theme_color_override("font_color", Color(0.7, 0.75, 0.8))
			desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			desc_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			vbox.add_child(title_lbl)
			vbox.add_child(desc_lbl)
			btn.add_child(vbox)
		else:
			btn.text = opt["label"]

		if opt.get("disabled", false):
			btn.disabled = true
			btn.modulate.a = 0.5

		if SettingsManager.screen_reader:
			btn.tooltip_text = "Option %d of %d: %s" % [i + 1, options.size(), opt["label"]]

		_apply_focus_style(btn)
		var idx: int = i
		btn.pressed.connect(func() -> void: _on_button_pressed(idx))
		btn.focus_entered.connect(func() -> void: option_focused.emit(idx))
		btn.mouse_entered.connect(func() -> void: option_focused.emit(idx))
		btn_parent.add_child(btn)
		_buttons.append(btn)

	_wire_focus(use_grid)

	if LocalCoop.is_active and LocalCoop.player_devices.size() > 1:
		_setup_coop_cursors()
	else:
		# Single player: focus first enabled button
		for btn: Button in _buttons:
			if not btn.disabled:
				btn.grab_focus()
				break


func _on_button_pressed(index: int) -> void:
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.3)
	choice_selected.emit(index)


func _clear_buttons() -> void:
	for btn: Button in _buttons:
		btn.queue_free()
	_buttons.clear()
	if _grid:
		_grid.queue_free()
		_grid = null
	_coop_mode = false
	_player_cursors.clear()
	_player_overlays.clear()
	_player_sbs.clear()
	_last_nav_ms.clear()
	_sp_last_nav_ms = 0


func focus_first() -> void:
	for btn: Button in _buttons:
		if not btn.disabled:
			btn.grab_focus()
			break


func highlight_option(index: int) -> void:
	for i: int in _buttons.size():
		if _buttons[i].disabled:
			_buttons[i].modulate.a = 0.85 if i == index else 0.5


func hide_menu() -> void:
	_clear_buttons()
	visible = false


func _wire_focus(use_grid: bool = false) -> void:
	var enabled: Array[Button] = []
	for btn: Button in _buttons:
		if not btn.disabled:
			enabled.append(btn)

	if enabled.is_empty():
		return

	if use_grid:
		_wire_grid_focus(enabled)
	else:
		_wire_list_focus(enabled)


func _wire_list_focus(enabled: Array[Button]) -> void:
	for i: int in enabled.size():
		var btn: Button = enabled[i]
		var prev: Button = enabled[(i - 1 + enabled.size()) % enabled.size()]
		var next_btn: Button = enabled[(i + 1) % enabled.size()]
		btn.focus_neighbor_top = prev.get_path()
		btn.focus_neighbor_bottom = next_btn.get_path()


func _wire_grid_focus(enabled: Array[Button]) -> void:
	## Wire 2-column grid navigation: up/down between rows, left/right between columns.
	var cols: int = 2
	for i: int in enabled.size():
		var btn: Button = enabled[i]
		var col: int = i % cols

		# Left/right within row
		if col > 0:
			btn.focus_neighbor_left = enabled[i - 1].get_path()
		elif enabled.size() > 1:
			btn.focus_neighbor_left = enabled[mini(i + 1, enabled.size() - 1)].get_path()

		if col < cols - 1 and i + 1 < enabled.size():
			btn.focus_neighbor_right = enabled[i + 1].get_path()
		elif col == cols - 1 or i + 1 >= enabled.size():
			btn.focus_neighbor_right = enabled[i - col].get_path()

		# Up/down between rows
		var up_idx: int = i - cols
		if up_idx >= 0:
			btn.focus_neighbor_top = enabled[up_idx].get_path()
		else:
			var last_row_start: int = (enabled.size() - 1) / cols * cols
			var wrap_idx: int = mini(last_row_start + col, enabled.size() - 1)
			btn.focus_neighbor_top = enabled[wrap_idx].get_path()

		var down_idx: int = i + cols
		if down_idx < enabled.size():
			btn.focus_neighbor_bottom = enabled[down_idx].get_path()
		else:
			var wrap_idx: int = mini(col, enabled.size() - 1)
			btn.focus_neighbor_bottom = enabled[wrap_idx].get_path()


# =============================================================================
# Co-op multi-cursor
# =============================================================================

func _setup_coop_cursors() -> void:
	_coop_mode = true
	var player_count: int = LocalCoop.player_devices.size()

	# All players start on the first enabled button
	var first_enabled: int = 0
	for i: int in _buttons.size():
		if not _buttons[i].disabled:
			first_enabled = i
			break
	for _p: int in player_count:
		_player_cursors.append(first_enabled)
		_last_nav_ms.append(0)

	# Add a colored border overlay per player onto each button
	for btn: Button in _buttons:
		btn.focus_mode = Control.FOCUS_NONE
		var btn_overlays: Array[Panel] = []
		var btn_sbs: Array[StyleBoxFlat] = []
		for p: int in player_count:
			var overlay := Panel.new()
			overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
			overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
			overlay.visible = false
			var sb := StyleBoxFlat.new()
			sb.bg_color = Color.TRANSPARENT
			sb.draw_center = false
			sb.set_border_width_all(3)
			sb.set_corner_radius_all(4)
			sb.border_color = PLAYER_COLORS[mini(p, PLAYER_COLORS.size() - 1)]
			overlay.add_theme_stylebox_override("panel", sb)
			btn.add_child(overlay)
			btn_overlays.append(overlay)
			btn_sbs.append(sb)
		_player_overlays.append(btn_overlays)
		_player_sbs.append(btn_sbs)

	_refresh_coop_cursors()


func _refresh_coop_cursors() -> void:
	var player_count: int = _player_cursors.size()
	var active: int = LocalCoop.active_player  # -1 = all visible, >= 0 = only this player

	for i: int in _buttons.size():
		var overlays: Array = _player_overlays[i]
		var sbs: Array = _player_sbs[i]

		if active >= 0:
			# Turn gating: only the active player's cursor is ever visible
			for p: int in player_count:
				var on_btn: bool = (p == active and _player_cursors[p] == i)
				(overlays[p] as Panel).visible = on_btn
				if on_btn:
					(sbs[p] as StyleBoxFlat).border_color = PLAYER_COLORS[mini(p, PLAYER_COLORS.size() - 1)]
		else:
			# All players active — show individual colors, white if all on same button
			var here_count: int = 0
			for p: int in player_count:
				if _player_cursors[p] == i:
					here_count += 1

			if here_count == 0:
				for p: int in player_count:
					(overlays[p] as Panel).visible = false
			elif here_count == player_count:
				# All on same button — white on first overlay, hide rest
				(overlays[0] as Panel).visible = true
				(sbs[0] as StyleBoxFlat).border_color = Color.WHITE
				for p: int in range(1, overlays.size()):
					(overlays[p] as Panel).visible = false
			else:
				for p: int in player_count:
					var on_btn: bool = _player_cursors[p] == i
					(overlays[p] as Panel).visible = on_btn
					if on_btn:
						(sbs[p] as StyleBoxFlat).border_color = PLAYER_COLORS[mini(p, PLAYER_COLORS.size() - 1)]


func _move_cursor(player_idx: int, direction: int) -> void:
	var current: int = _player_cursors[player_idx]
	var new_idx: int = current
	var count: int = _buttons.size()
	for _attempt: int in count:
		new_idx = (new_idx + direction + count) % count
		if not _buttons[new_idx].disabled:
			break
	if new_idx != current:
		_player_cursors[player_idx] = new_idx
		_refresh_coop_cursors()
		SFXManager.play(SFXManager.Category.UI_SELECT, 0.2)


## Route navigation to list or grid movement depending on layout.
func _navigate(player_idx: int, dir: Vector2i) -> void:
	if _grid != null:
		_navigate_grid(player_idx, dir)
	else:
		# In list mode treat left/up as -1 and right/down as +1
		var step: int = -1 if (dir.y < 0 or dir.x < 0) else 1
		_move_cursor(player_idx, step)


## Grid-aware cursor movement. dir.y = row delta (-1/+1), dir.x = col delta (-1/+1).
func _navigate_grid(player_idx: int, dir: Vector2i) -> void:
	const COLS: int = 2
	var current: int = _player_cursors[player_idx]
	var count: int = _buttons.size()
	var rows: int = (count + COLS - 1) / COLS

	var cur_row: int = current / COLS
	var cur_col: int = current % COLS

	var new_row: int = (cur_row + dir.y + rows) % rows
	var new_col: int = (cur_col + dir.x + COLS) % COLS
	var new_idx: int = mini(new_row * COLS + new_col, count - 1)

	if not _buttons[new_idx].disabled and new_idx != current:
		_player_cursors[player_idx] = new_idx
		_refresh_coop_cursors()
		SFXManager.play(SFXManager.Category.UI_SELECT, 0.2)


func _get_player_for_event(event: InputEvent) -> int:
	for p: int in LocalCoop.player_devices.size():
		var device: int = LocalCoop.player_devices[p]
		if device == -1 and event is InputEventKey:
			return p
		elif device >= 0 \
				and (event is InputEventJoypadButton or event is InputEventJoypadMotion) \
				and event.device == device:
			return p
	return -1


func _input(event: InputEvent) -> void:
	if not visible:
		return

	# Single-player and online: handle left stick nav only.
	# D-pad, keyboard, and gamepad face buttons are handled by Godot's focus system.
	if not _coop_mode:
		if not (event is InputEventJoypadMotion):
			return
		var motion := event as InputEventJoypadMotion
		var side: int = -1
		if motion.axis == JOY_AXIS_LEFT_Y and abs(motion.axis_value) >= 0.5:
			side = SIDE_BOTTOM if motion.axis_value > 0 else SIDE_TOP
		elif motion.axis == JOY_AXIS_LEFT_X and abs(motion.axis_value) >= 0.5 and _grid != null:
			side = SIDE_RIGHT if motion.axis_value > 0 else SIDE_LEFT
		else:
			return
		var now: int = Time.get_ticks_msec()
		if now - _sp_last_nav_ms < _NAV_COOLDOWN_MS:
			return
		_sp_last_nav_ms = now
		var focused := get_viewport().gui_get_focus_owner()
		if focused == null:
			return
		var next := focused.find_valid_focus_neighbor(side)
		if next:
			next.grab_focus()
			SFXManager.play(SFXManager.Category.UI_SELECT, 0.2)
		get_viewport().set_input_as_handled()
		return

	var is_motion: bool = event is InputEventJoypadMotion
	if event is InputEventKey and (not event.pressed or event.echo):
		return
	if event is InputEventJoypadButton and not event.pressed:
		return

	var player_idx: int = _get_player_for_event(event)
	if player_idx < 0:
		return

	# Respect LocalCoop turn gating — during sequential character creation etc.
	# active_player is set to the owning player; others must not act.
	if LocalCoop.active_player >= 0 and player_idx != LocalCoop.active_player:
		return

	# Left stick: direct axis sign check with cooldown
	# is_action() doesn't reliably distinguish direction for JoypadMotion.
	if is_motion:
		var motion := event as InputEventJoypadMotion
		var nav_dir := Vector2i.ZERO
		if motion.axis == JOY_AXIS_LEFT_Y and abs(motion.axis_value) >= 0.5:
			nav_dir.y = 1 if motion.axis_value > 0 else -1
		elif motion.axis == JOY_AXIS_LEFT_X and abs(motion.axis_value) >= 0.5 and _grid != null:
			nav_dir.x = 1 if motion.axis_value > 0 else -1
		else:
			return
		var now: int = Time.get_ticks_msec()
		if now - _last_nav_ms[player_idx] < _NAV_COOLDOWN_MS:
			return
		_last_nav_ms[player_idx] = now
		_navigate(player_idx, nav_dir)
		get_viewport().set_input_as_handled()
		return

	if event.is_action("move_up") or event.is_action("ui_up"):
		_navigate(player_idx, Vector2i(0, -1))
		get_viewport().set_input_as_handled()
	elif event.is_action("move_down") or event.is_action("ui_down"):
		_navigate(player_idx, Vector2i(0, 1))
		get_viewport().set_input_as_handled()
	elif event.is_action("move_left") or event.is_action("ui_left"):
		_navigate(player_idx, Vector2i(-1, 0))
		get_viewport().set_input_as_handled()
	elif event.is_action("move_right") or event.is_action("ui_right"):
		_navigate(player_idx, Vector2i(1, 0))
		get_viewport().set_input_as_handled()
	elif event.is_action("confirm") or event.is_action("ui_accept"):
		var idx: int = _player_cursors[player_idx]
		if not _buttons[idx].disabled:
			_on_button_pressed(idx)
		get_viewport().set_input_as_handled()
	# cancel/ui_cancel intentionally not consumed — parent scenes handle back navigation


static func _apply_focus_style(btn: Button) -> void:
	var focus_sb := StyleBoxFlat.new()
	focus_sb.bg_color = Color(0.2, 0.2, 0.3, 0.9)
	focus_sb.border_color = Color.WHITE
	focus_sb.set_border_width_all(3)
	focus_sb.set_corner_radius_all(4)
	focus_sb.set_content_margin_all(6)
	btn.add_theme_stylebox_override("focus", focus_sb)
