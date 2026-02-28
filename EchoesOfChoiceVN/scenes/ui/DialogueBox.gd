extends Control

signal dialogue_finished
signal choice_made(key: String)

@onready var _left_portrait: TextureRect = %LeftPortrait
@onready var _right_portrait: TextureRect = %RightPortrait
@onready var _panel: Panel = %DialoguePanel
@onready var _speaker_label: Label = %SpeakerLabel
@onready var _text_label: RichTextLabel = %TextLabel
@onready var _continue_indicator: Label = %ContinueIndicator
@onready var _choice_dimmer: ColorRect = %ChoiceDimmer
@onready var _choice_panel: Panel = %ChoicePanel
@onready var _prompt_label: Label = %PromptLabel
@onready var _choice_container: VBoxContainer = %ChoiceContainer

var _lines: Array[Dictionary] = []
var _current_index: int = -1
var _typing: bool = false
var _waiting_for_choice: bool = false
var _tween: Tween

const CHARS_PER_SECOND := 40.0

const SPEAKER_COLORS: Dictionary = {
	"???": Color(0.6, 0.4, 0.8),
	"Cloaked Stranger": Color(0.6, 0.4, 0.8),
	"The Stranger": Color(0.8, 0.2, 0.2),
}
const PLAYER_COLOR := Color(0.85, 0.85, 1.0)
const PARTY_COLOR := Color(0.7, 0.9, 0.7)
const DEFAULT_COLOR := Color(0.9, 0.75, 0.4)


func show_dialogue(lines: Array[Dictionary]) -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	_lines = lines
	_current_index = -1
	_typing = false
	_waiting_for_choice = false
	_choice_dimmer.visible = false
	_choice_panel.visible = false
	_panel.visible = true
	visible = true
	_advance()


func show_choice(prompt: String, options: Array[Dictionary]) -> void:
	_waiting_for_choice = true
	_panel.visible = false
	_choice_dimmer.visible = true
	_choice_panel.visible = true
	_prompt_label.text = prompt
	for child in _choice_container.get_children():
		child.queue_free()
	await get_tree().process_frame
	for i in range(options.size()):
		var btn := Button.new()
		btn.text = options[i].get("text", "")
		btn.custom_minimum_size = Vector2(0, 44)
		var key: String = options[i].get("key", str(i))
		btn.pressed.connect(_on_choice_selected.bind(key))
		_choice_container.add_child(btn)
		if i == 0:
			btn.call_deferred("grab_focus")


func set_portrait(side: String, texture_path: String) -> void:
	if texture_path.is_empty():
		if side == "left":
			_left_portrait.texture = null
			_left_portrait.visible = false
		elif side == "right":
			_right_portrait.texture = null
			_right_portrait.visible = false
		return
	var tex: Texture2D = load(texture_path) as Texture2D
	if not tex:
		return
	if side == "left":
		_left_portrait.texture = tex
		_left_portrait.visible = true
	elif side == "right":
		_right_portrait.texture = tex
		_right_portrait.visible = true


func clear_portraits() -> void:
	_left_portrait.texture = null
	_left_portrait.visible = false
	_right_portrait.texture = null
	_right_portrait.visible = false


func _on_choice_selected(key: String) -> void:
	_waiting_for_choice = false
	_choice_dimmer.visible = false
	_choice_panel.visible = false
	choice_made.emit(key)


func _advance() -> void:
	_current_index += 1
	if _current_index >= _lines.size():
		_panel.visible = false
		dialogue_finished.emit()
		return

	var line: Dictionary = _lines[_current_index]
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")

	_speaker_label.text = speaker
	_speaker_label.visible = speaker != ""
	if speaker != "":
		_speaker_label.add_theme_color_override("font_color", _get_speaker_color(speaker))

	_text_label.text = text
	_text_label.visible_ratio = 0.0
	_continue_indicator.visible = false
	_typing = true

	_update_portraits(line)

	var total_chars := text.length()
	if total_chars > 0:
		var speed_mult: float = GameState.settings.get("text_speed", 1.0)
		var duration := total_chars / (CHARS_PER_SECOND * speed_mult)
		_tween = create_tween()
		_tween.tween_property(_text_label, "visible_ratio", 1.0, duration)
		_tween.finished.connect(_on_typing_complete, CONNECT_ONE_SHOT)
	else:
		_on_typing_complete()


func _on_typing_complete() -> void:
	_typing = false
	_continue_indicator.visible = true


func _update_portraits(line: Dictionary) -> void:
	var portrait_path: String = line.get("portrait", "")
	var side: String = line.get("side", "")

	if portrait_path != "" and side != "":
		set_portrait(side, portrait_path)

	if side == "left":
		_left_portrait.modulate.a = 1.0
		if _right_portrait.texture:
			_right_portrait.modulate.a = 0.5
	elif side == "right":
		_right_portrait.modulate.a = 1.0
		if _left_portrait.texture:
			_left_portrait.modulate.a = 0.5
	else:
		if _left_portrait.texture:
			_left_portrait.modulate.a = 0.5
		if _right_portrait.texture:
			_right_portrait.modulate.a = 0.5


func _get_speaker_color(speaker: String) -> Color:
	if SPEAKER_COLORS.has(speaker):
		return SPEAKER_COLORS[speaker]
	if speaker == GameState.player_name:
		return PLAYER_COLOR
	for member in GameState.party_members:
		if member.get("name", "") == speaker:
			return PARTY_COLOR
	return DEFAULT_COLOR


func _input(event: InputEvent) -> void:
	if not visible or _waiting_for_choice:
		return
	if event is InputEventMouseButton and event.pressed:
		get_viewport().set_input_as_handled()
		_handle_advance()
	elif event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		_handle_advance()


func _handle_advance() -> void:
	if _typing:
		if _tween and _tween.is_valid():
			_tween.kill()
		_text_label.visible_ratio = 1.0
		_on_typing_complete()
	else:
		_advance()
