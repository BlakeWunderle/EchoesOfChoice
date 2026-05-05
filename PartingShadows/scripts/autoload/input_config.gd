extends Node
## Registers game-specific input actions with keyboard + gamepad bindings.
## Must be the first autoload so actions exist before any scene processes input.
## Supports runtime keyboard remapping; gamepad bindings are always hardcoded.

const ACTION_NAMES: Array[String] = [
	"move_up", "move_down", "move_left", "move_right",
	"confirm", "cancel", "pause",
]

const ACTION_DISPLAY_NAMES: Dictionary = {
	"move_up": "Move Up",
	"move_down": "Move Down",
	"move_left": "Move Left",
	"move_right": "Move Right",
	"confirm": "Confirm",
	"cancel": "Cancel",
	"pause": "Pause",
}

const DEFAULT_KEYBOARD_BINDINGS: Dictionary = {
	"move_up": [KEY_W, KEY_UP],
	"move_down": [KEY_S, KEY_DOWN],
	"move_left": [KEY_A, KEY_LEFT],
	"move_right": [KEY_D, KEY_RIGHT],
	"confirm": [KEY_ENTER, KEY_SPACE, KEY_Z],
	"cancel": [KEY_ESCAPE, KEY_X],
	"pause": [KEY_ESCAPE],
}

## Default gamepad bindings (used for reset)
const DEFAULT_GAMEPAD_BINDINGS: Dictionary = {
	"move_up": [{"type": "button", "index": JOY_BUTTON_DPAD_UP},
		{"type": "axis", "axis": JOY_AXIS_LEFT_Y, "value": -1.0}],
	"move_down": [{"type": "button", "index": JOY_BUTTON_DPAD_DOWN},
		{"type": "axis", "axis": JOY_AXIS_LEFT_Y, "value": 1.0}],
	"move_left": [{"type": "button", "index": JOY_BUTTON_DPAD_LEFT},
		{"type": "axis", "axis": JOY_AXIS_LEFT_X, "value": -1.0}],
	"move_right": [{"type": "button", "index": JOY_BUTTON_DPAD_RIGHT},
		{"type": "axis", "axis": JOY_AXIS_LEFT_X, "value": 1.0}],
	"confirm": [{"type": "button", "index": JOY_BUTTON_A}],
	"cancel": [{"type": "button", "index": JOY_BUTTON_B}],
	"pause": [{"type": "button", "index": JOY_BUTTON_START}],
}

## Current gamepad bindings (remappable at runtime)
var _GAMEPAD_BINDINGS: Dictionary = {}

var keyboard_bindings: Dictionary = {}
## True when a Nintendo controller is detected (A/B face buttons are swapped vs Xbox)
var _nintendo_layout: bool = false
## True when the last meaningful input came from a gamepad (used for cursor hiding)
var _using_controller: bool = false
## True when the pause menu was opened due to controller disconnect
var _controller_disconnect_paused: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	keyboard_bindings = DEFAULT_KEYBOARD_BINDINGS.duplicate(true)
	_GAMEPAD_BINDINGS = DEFAULT_GAMEPAD_BINDINGS.duplicate(true)
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	_detect_nintendo_layout()
	apply_bindings()
	_log_connected_joypads()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if _using_controller:
			_using_controller = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if _controller_disconnect_paused:
			_controller_disconnect_paused = false
			PauseOverlay._feedback_label.visible = false
	elif event is InputEventMouseMotion:
		# Only switch to mouse if there was real movement (ignore synthetic hover events)
		if event.relative.length() > 1.0 and _using_controller:
			_using_controller = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event is InputEventKey:
		if _controller_disconnect_paused:
			_controller_disconnect_paused = false
			PauseOverlay._feedback_label.visible = false
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if event is InputEventJoypadMotion and absf(event.axis_value) < 0.5:
			return  # Ignore stick drift
		if not _using_controller:
			_using_controller = true
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func apply_bindings() -> void:
	for action: String in ACTION_NAMES:
		if InputMap.has_action(action):
			InputMap.action_erase_events(action)
		else:
			InputMap.add_action(action, 0.5)
		# Keyboard bindings (remappable)
		var keys: Array = keyboard_bindings.get(action, [])
		for keycode in keys:
			var ev := InputEventKey.new()
			ev.keycode = int(keycode) as Key
			InputMap.action_add_event(action, ev)
		# Gamepad bindings (hardcoded, with Nintendo A/B swap if needed)
		var pads: Array = _GAMEPAD_BINDINGS.get(action, [])
		for pad: Dictionary in pads:
			if pad["type"] == "button":
				var btn_index: JoyButton = int(pad["index"]) as JoyButton
				if _nintendo_layout:
					if btn_index == JOY_BUTTON_A:
						btn_index = JOY_BUTTON_B
					elif btn_index == JOY_BUTTON_B:
						btn_index = JOY_BUTTON_A
				var ev := InputEventJoypadButton.new()
				ev.device = -1
				ev.button_index = btn_index
				InputMap.action_add_event(action, ev)
			elif pad["type"] == "axis":
				var ev := InputEventJoypadMotion.new()
				ev.device = -1
				ev.axis = int(pad["axis"]) as JoyAxis
				ev.axis_value = pad["value"]
				InputMap.action_add_event(action, ev)
	# Add gamepad buttons/axes to built-in UI actions so Godot controls respond to gamepads.
	# Use device=-1 (any device) so all connected controllers work.
	_add_joypad_to_ui_action("ui_accept", _get_confirm_button())
	_add_joypad_to_ui_action("ui_cancel", _get_cancel_button())
	_add_joypad_nav_to_ui_actions()
	_sync_keyboard_nav_to_ui_actions()
	# Strip Tab / Shift+Tab from focus actions to avoid stealing Steam overlay shortcut
	for focus_action: String in ["ui_focus_next", "ui_focus_prev"]:
		if not InputMap.has_action(focus_action):
			continue
		for existing: InputEvent in InputMap.action_get_events(focus_action).duplicate():
			if existing is InputEventKey:
				InputMap.action_erase_event(focus_action, existing)


func _detect_nintendo_layout() -> void:
	_nintendo_layout = false
	for device: int in Input.get_connected_joypads():
		var pad_name: String = Input.get_joy_name(device).to_lower()
		if "nintendo" in pad_name or "pro controller" in pad_name or "joy-con" in pad_name:
			_nintendo_layout = true
			GameLog.info("Nintendo controller detected — swapping A/B buttons")
			return


func _get_confirm_button() -> JoyButton:
	return JOY_BUTTON_B if _nintendo_layout else JOY_BUTTON_A


func _get_cancel_button() -> JoyButton:
	return JOY_BUTTON_A if _nintendo_layout else JOY_BUTTON_B


func _add_joypad_to_ui_action(action_name: String, button: JoyButton) -> void:
	if not InputMap.has_action(action_name):
		return
	# Remove any existing joypad button events (may have wrong device) then re-add with device=-1
	for existing: InputEvent in InputMap.action_get_events(action_name).duplicate():
		if existing is InputEventJoypadButton:
			InputMap.action_erase_event(action_name, existing)
	var ev := InputEventJoypadButton.new()
	ev.device = -1
	ev.button_index = button
	InputMap.action_add_event(action_name, ev)


func _add_joypad_nav_to_ui_actions() -> void:
	## Ensure d-pad and left-stick navigation works for all UI menus.
	## Godot 4's built-in ui_up/down/left/right may lack gamepad mappings.
	var nav_buttons: Dictionary = {
		"ui_up": JOY_BUTTON_DPAD_UP,
		"ui_down": JOY_BUTTON_DPAD_DOWN,
		"ui_left": JOY_BUTTON_DPAD_LEFT,
		"ui_right": JOY_BUTTON_DPAD_RIGHT,
	}
	var nav_axes: Dictionary = {
		"ui_up": [JOY_AXIS_LEFT_Y, -1.0],
		"ui_down": [JOY_AXIS_LEFT_Y, 1.0],
		"ui_left": [JOY_AXIS_LEFT_X, -1.0],
		"ui_right": [JOY_AXIS_LEFT_X, 1.0],
	}
	for action: String in nav_buttons.keys():
		if not InputMap.has_action(action):
			continue
		# Remove existing joypad events then re-add with device=-1
		for existing: InputEvent in InputMap.action_get_events(action).duplicate():
			if existing is InputEventJoypadButton or existing is InputEventJoypadMotion:
				InputMap.action_erase_event(action, existing)
		var btn := InputEventJoypadButton.new()
		btn.device = -1
		btn.button_index = nav_buttons[action] as JoyButton
		InputMap.action_add_event(action, btn)
		var axis := InputEventJoypadMotion.new()
		axis.device = -1
		axis.axis = nav_axes[action][0] as JoyAxis
		axis.axis_value = nav_axes[action][1]
		InputMap.action_add_event(action, axis)


func _sync_keyboard_nav_to_ui_actions() -> void:
	var mapping: Dictionary = {
		"move_up": "ui_up", "move_down": "ui_down",
		"move_left": "ui_left", "move_right": "ui_right",
	}
	for move_action: String in mapping:
		var ui_action: String = mapping[move_action]
		if not InputMap.has_action(ui_action):
			continue
		for keycode in keyboard_bindings.get(move_action, []):
			var key: Key = int(keycode) as Key
			var already: bool = false
			for existing: InputEvent in InputMap.action_get_events(ui_action):
				if existing is InputEventKey and (existing as InputEventKey).keycode == key:
					already = true
					break
			if not already:
				var ev := InputEventKey.new()
				ev.keycode = key
				InputMap.action_add_event(ui_action, ev)


func rebind_action(action_name: String, keycode: Key) -> void:
	keyboard_bindings[action_name] = [keycode]
	apply_bindings()
	SettingsManager.save_key_bindings(keyboard_bindings)


func rebind_gamepad_action(action_name: String, button: JoyButton) -> void:
	## Replace the first button binding for this action with the new button.
	var bindings: Array = _GAMEPAD_BINDINGS.get(action_name, [])
	var found: bool = false
	for i: int in bindings.size():
		if bindings[i]["type"] == "button":
			bindings[i] = {"type": "button", "index": int(button)}
			found = true
			break
	if not found:
		bindings.append({"type": "button", "index": int(button)})
	_GAMEPAD_BINDINGS[action_name] = bindings
	apply_bindings()


func reset_bindings() -> void:
	keyboard_bindings = DEFAULT_KEYBOARD_BINDINGS.duplicate(true)
	_GAMEPAD_BINDINGS = DEFAULT_GAMEPAD_BINDINGS.duplicate(true)
	apply_bindings()
	SettingsManager.save_key_bindings(keyboard_bindings)


func get_key_name(action_name: String) -> String:
	var keys: Array = keyboard_bindings.get(action_name, [])
	if keys.is_empty():
		return "None"
	return OS.get_keycode_string(int(keys[0]))


func _log_connected_joypads() -> void:
	var pads: Array[int] = Input.get_connected_joypads()
	if pads.is_empty():
		var msg := "No controllers detected"
		GameLog.info(msg)
		print(msg)
		return
	for device: int in pads:
		var pad_name: String = Input.get_joy_name(device)
		var guid: String = Input.get_joy_guid(device)
		var msg := "Controller %d: %s (GUID: %s)" % [device, pad_name, guid]
		GameLog.info(msg)
		print(msg)


func _on_joy_connection_changed(device: int, connected: bool) -> void:
	var msg: String
	if connected:
		var pad_name: String = Input.get_joy_name(device)
		var guid: String = Input.get_joy_guid(device)
		msg = "Controller %d connected: %s (GUID: %s)" % [device, pad_name, guid]
	else:
		msg = "Controller %d disconnected" % device
	GameLog.info(msg)
	print(msg)
	# Re-detect layout and rebind in case controller type changed
	_detect_nintendo_layout()
	apply_bindings()
	if connected and _controller_disconnect_paused:
		_controller_disconnect_paused = false
		PauseOverlay._feedback_label.visible = false
	# Open pause menu if the player was using a controller and it disconnected
	elif not connected and _using_controller:
		_show_controller_disconnected()


func load_bindings(data: Dictionary) -> void:
	## Called by SettingsManager on startup with saved binding data.
	if data.is_empty():
		return
	for action: String in ACTION_NAMES:
		if data.has(action):
			keyboard_bindings[action] = data[action]
	apply_bindings()


# =============================================================================
# Controller disconnect -> pause menu with message
# =============================================================================

func _show_controller_disconnected() -> void:
	if GameState.game_phase == GameState.GamePhase.TITLE:
		return
	if GameState.game_phase == GameState.GamePhase.ENDING:
		return
	if NetManager.is_multiplayer_active:
		return
	if PauseOverlay._panel and PauseOverlay._panel.visible:
		return  # Already paused
	_controller_disconnect_paused = true
	PauseOverlay._show_pause()
	PauseOverlay._feedback_label.text = "Controller disconnected"
	PauseOverlay._feedback_label.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	PauseOverlay._feedback_label.visible = true
