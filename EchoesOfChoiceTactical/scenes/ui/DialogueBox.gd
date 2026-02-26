extends Control

signal dialogue_finished

@onready var speaker_label: Label = $Panel/MarginContainer/VBoxContainer/SpeakerLabel
@onready var text_label: RichTextLabel = $Panel/MarginContainer/VBoxContainer/TextLabel
@onready var continue_indicator: Label = $Panel/MarginContainer/VBoxContainer/ContinueIndicator

var _lines: Array[Dictionary] = []
var _current_index: int = -1
var _typing: bool = false
var _portrait: TextureRect = null

const CHARS_PER_SECOND := 40.0

const MENTOR_SPRITES: Dictionary = {
	"Sir Aldric": "chibi_armored_knight_medieval_knight",
	"Elara": "chibi_dark_knight_archon_5",
	"Lyris": "chibi_ninja_female_1",
	"Professor Thane": "chibi_mage_1",
}


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
	var speaker: String = line.get("speaker", "")
	speaker_label.text = speaker
	speaker_label.visible = speaker != ""
	text_label.text = line.get("text", "")
	text_label.visible_ratio = 0.0
	continue_indicator.visible = false
	_typing = true
	_update_portrait(speaker)

	var total_chars := text_label.text.length()
	if total_chars > 0:
		var speed_mult: float = GameState.settings.get("text_speed", 1.0)
		var duration := total_chars / (CHARS_PER_SECOND * speed_mult)
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
	elif event.is_action_pressed("confirm"):
		_handle_advance()


func _update_portrait(speaker: String) -> void:
	if _portrait:
		_portrait.queue_free()
		_portrait = null
	if speaker.is_empty():
		return
	var sprite_id := _get_speaker_sprite_id(speaker)
	if sprite_id.is_empty():
		return
	var frames := SpriteLoader.get_frames(sprite_id)
	if not frames or not frames.has_animation("idle_down"):
		return
	var tex := frames.get_frame_texture("idle_down", 0)
	if not tex:
		return
	_portrait = TextureRect.new()
	_portrait.texture = tex
	_portrait.custom_minimum_size = Vector2(48, 48)
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	var vbox: VBoxContainer = speaker_label.get_parent()
	vbox.add_child(_portrait)
	vbox.move_child(_portrait, 0)


func _get_speaker_sprite_id(speaker: String) -> String:
	# Check mentors
	if MENTOR_SPRITES.has(speaker):
		return MENTOR_SPRITES[speaker]
	# Check if speaker is a party member
	if speaker == GameState.player_name:
		var data: FighterData = BattleConfig.load_class(GameState.player_class_id)
		if data:
			if GameState.player_gender in ["princess", "female"] and not data.sprite_id_female.is_empty():
				return data.sprite_id_female
			return data.sprite_id
	for member in GameState.party_members:
		if member.get("name", "") == speaker:
			var data: FighterData = BattleConfig.load_class(member.get("class_id", ""))
			if data:
				if member.get("gender", "") in ["princess", "female"] and not data.sprite_id_female.is_empty():
					return data.sprite_id_female
				return data.sprite_id
	return ""


func _handle_advance() -> void:
	if _typing:
		text_label.visible_ratio = 1.0
		_typing = false
		continue_indicator.visible = true
	else:
		SFXManager.play(SFXManager.Category.UI_SELECT, 0.3)
		_advance()
