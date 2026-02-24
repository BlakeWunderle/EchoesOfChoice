extends Control

signal dialogue_finished

@onready var speaker_label: Label = $Panel/MarginContainer/VBoxContainer/SpeakerLabel
@onready var text_label: RichTextLabel = $Panel/MarginContainer/VBoxContainer/TextLabel
@onready var continue_indicator: Label = $Panel/MarginContainer/VBoxContainer/ContinueIndicator

var _lines: Array[Dictionary] = []
var _current_index: int = -1
var _typing: bool = false

const CHARS_PER_SECOND := 40.0


func show_dialogue(lines: Array[Dictionary]) -> void:
	_lines = lines
	_current_index = -1
	visible = true
	_advance()


func _advance() -> void:
	_current_index += 1
	if _current_index >= _lines.size():
		visible = false
		dialogue_finished.emit()
		return

	var line: Dictionary = _lines[_current_index]
	speaker_label.text = line.get("speaker", "")
	speaker_label.visible = speaker_label.text != ""
	text_label.text = line.get("text", "")
	text_label.visible_ratio = 0.0
	continue_indicator.visible = false
	_typing = true

	var total_chars := text_label.text.length()
	if total_chars > 0:
		var duration := total_chars / CHARS_PER_SECOND
		var tween := create_tween()
		tween.tween_property(text_label, "visible_ratio", 1.0, duration)
		await tween.finished

	_typing = false
	continue_indicator.visible = true


func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventMouseButton and event.pressed:
		_handle_advance()
	elif event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER or event.keycode == KEY_SPACE:
			_handle_advance()


func _handle_advance() -> void:
	if _typing:
		text_label.visible_ratio = 1.0
		_typing = false
		continue_indicator.visible = true
	else:
		SFXManager.play(SFXManager.Category.UI_SELECT, 0.3)
		_advance()
