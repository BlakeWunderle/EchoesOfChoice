extends Node
## Registers game-specific input actions with keyboard + gamepad bindings.
## Must be the first autoload so actions exist before any scene processes input.


func _ready() -> void:
	_setup_actions()


func _setup_actions() -> void:
	_add_action("move_up", [
		_key(KEY_W), _key(KEY_UP),
		_joy_button(JOY_BUTTON_DPAD_UP),
		_joy_axis(JOY_AXIS_LEFT_Y, -1.0),
	])
	_add_action("move_down", [
		_key(KEY_S), _key(KEY_DOWN),
		_joy_button(JOY_BUTTON_DPAD_DOWN),
		_joy_axis(JOY_AXIS_LEFT_Y, 1.0),
	])
	_add_action("move_left", [
		_key(KEY_A), _key(KEY_LEFT),
		_joy_button(JOY_BUTTON_DPAD_LEFT),
		_joy_axis(JOY_AXIS_LEFT_X, -1.0),
	])
	_add_action("move_right", [
		_key(KEY_D), _key(KEY_RIGHT),
		_joy_button(JOY_BUTTON_DPAD_RIGHT),
		_joy_axis(JOY_AXIS_LEFT_X, 1.0),
	])
	_add_action("confirm", [
		_key(KEY_ENTER), _key(KEY_SPACE), _key(KEY_Z),
		_joy_button(JOY_BUTTON_A),
	])
	_add_action("cancel", [
		_key(KEY_ESCAPE), _key(KEY_X),
		_joy_button(JOY_BUTTON_B),
	])
	_add_action("inspect", [
		_key(KEY_TAB),
		_joy_button(JOY_BUTTON_Y),
	])
	_add_action("pause", [
		_joy_button(JOY_BUTTON_START),
	])


func _add_action(action_name: String, events: Array) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name, 0.5)
	for event in events:
		InputMap.action_add_event(action_name, event)


func _key(keycode: Key) -> InputEventKey:
	var ev := InputEventKey.new()
	ev.keycode = keycode
	return ev


func _joy_button(button: JoyButton) -> InputEventJoypadButton:
	var ev := InputEventJoypadButton.new()
	ev.button_index = button
	return ev


func _joy_axis(axis: JoyAxis, value: float) -> InputEventJoypadMotion:
	var ev := InputEventJoypadMotion.new()
	ev.axis = axis
	ev.axis_value = value
	return ev
