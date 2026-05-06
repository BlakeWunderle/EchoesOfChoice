class_name DetailModalBase extends Control

## Base modal with dim overlay, close button, and ESC handler.
## Subclasses override build_content() to add specific details.

signal close_requested

var _overlay: ColorRect
var _modal_panel: PanelContainer
var _content_container: VBoxContainer


func _ready() -> void:
	# Allow modal to work while tree is paused (pause menu compendium)
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Cover entire viewport
	anchor_right = 1.0
	anchor_bottom = 1.0
	mouse_filter = Control.MOUSE_FILTER_STOP

	# Dim overlay
	_overlay = ColorRect.new()
	_overlay.color = Color(0, 0, 0, 0.7)
	_overlay.anchor_right = 1.0
	_overlay.anchor_bottom = 1.0
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_overlay.gui_input.connect(_on_overlay_clicked)
	add_child(_overlay)

	# Modal panel (centered, larger size)
	_modal_panel = PanelContainer.new()
	_modal_panel.custom_minimum_size = Vector2(800, 600)
	_modal_panel.anchor_left = 0.5
	_modal_panel.anchor_top = 0.5
	_modal_panel.anchor_right = 0.5
	_modal_panel.anchor_bottom = 0.5
	_modal_panel.offset_left = -400
	_modal_panel.offset_top = -300
	_modal_panel.offset_right = 400
	_modal_panel.offset_bottom = 300
	add_child(_modal_panel)

	# Outer vbox to hold close button above scroll
	var outer_vbox := VBoxContainer.new()
	outer_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outer_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_modal_panel.add_child(outer_vbox)

	# Close button (top-right, fixed above scroll)
	var close_btn := Button.new()
	close_btn.text = "X"
	close_btn.custom_minimum_size = Vector2(32, 32)
	close_btn.size_flags_horizontal = Control.SIZE_SHRINK_END
	close_btn.add_theme_font_size_override("font_size", 18)
	close_btn.focus_mode = Control.FOCUS_ALL
	close_btn.pressed.connect(_on_close)
	outer_vbox.add_child(close_btn)

	# Scroll container for content
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	outer_vbox.add_child(scroll)

	# Content vbox
	_content_container = VBoxContainer.new()
	_content_container.add_theme_constant_override("separation", 10)
	_content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_content_container)

	# Subclasses build content here
	build_content(_content_container)

	# Focus the first focusable element in content, fallback to close button
	_grab_first_focusable(_content_container, close_btn)

	# Fade in animation
	modulate = Color(1, 1, 1, 0)
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)


## Override in subclasses to build modal content
func build_content(container: VBoxContainer) -> void:
	pass


func _grab_first_focusable(node: Node, fallback: Control) -> void:
	var target: Control = _find_first_focusable(node)
	if target:
		target.grab_focus()
	elif fallback:
		fallback.grab_focus()


func _find_first_focusable(node: Node) -> Control:
	for child: Node in node.get_children():
		if child is Control and (child as Control).focus_mode == Control.FOCUS_ALL:
			return child as Control
		var found: Control = _find_first_focusable(child)
		if found:
			return found
	return null


func _on_close() -> void:
	# Fade out animation
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.15)
	tween.tween_callback(func() -> void:
		close_requested.emit()
		queue_free()
	)


func _on_overlay_clicked(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_on_close()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # ESC key
		_on_close()
		get_viewport().set_input_as_handled()
