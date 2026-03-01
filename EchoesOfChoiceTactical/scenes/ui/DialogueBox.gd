extends Control

signal dialogue_finished

@onready var panel: Panel = $Panel
@onready var portrait_container: VBoxContainer = $Panel/MarginContainer/HBoxContainer/PortraitContainer
@onready var speaker_label: Label = $Panel/MarginContainer/HBoxContainer/TextContent/SpeakerLabel
@onready var text_label: RichTextLabel = $Panel/MarginContainer/HBoxContainer/TextContent/TextLabel
@onready var continue_indicator: Label = $Panel/MarginContainer/HBoxContainer/TextContent/ContinueIndicator

var _lines: Array[Dictionary] = []
var _current_index: int = -1
var _typing: bool = false
var _portrait: TextureRect = null

const CHARS_PER_SECOND := 40.0

const MENTOR_SPRITES: Dictionary = {
	"Sir Aldric": "chibi_armored_knight_medieval_knight",
	"Elara": "chibi_dark_knight_archon_5",
	"Lyris": "chibi_ninja_assassin_white_ninja",
	"Professor Thane": "chibi_mage_1",
}

const STRANGER_SPRITES: Dictionary = {
	"???": "chibi_black_reaper_1_brown",
	"Cloaked Stranger": "chibi_black_reaper_1_brown",
	"The Stranger": "chibi_black_reaper_1",
}

const NPC_SPRITES: Dictionary = {
	"Maren": "chibi_women_citizen_women_1",
	"Corvin": "chibi_citizen_1",
	"Sela": "chibi_women_citizen_women_3",
	"Bram": "chibi_citizen_2",
	"Lyra": "chibi_women_citizen_women_2",
	"Donal": "chibi_villager_1",
	"Petra": "chibi_women_citizen_women_2_tinker",
}

const SPEAKER_COLORS: Dictionary = {
	"Sir Aldric": Color(0.9, 0.75, 0.4),
	"Elara": Color(0.9, 0.75, 0.4),
	"Lyris": Color(0.9, 0.75, 0.4),
	"Professor Thane": Color(0.9, 0.75, 0.4),
	"???": Color(0.6, 0.4, 0.8),
	"Cloaked Stranger": Color(0.6, 0.4, 0.8),
	"The Stranger": Color(0.8, 0.2, 0.2),
}

const NPC_COLOR := Color(0.9, 0.8, 0.5)
const PLAYER_COLOR := Color(0.85, 0.85, 1.0)
const PARTY_COLOR := Color(0.7, 0.9, 0.7)
const DEFAULT_COLOR := Color(0.85, 0.85, 0.85)


func show_dialogue(lines: Array[Dictionary]) -> void:
	_lines = lines
	_current_index = -1
	visible = true
	# Entrance animation: slide up + fade in
	panel.position.y += 20
	panel.modulate.a = 0.0
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "position:y", panel.position.y - 20, 0.25).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate:a", 1.0, 0.2)
	tween.set_parallel(false)
	tween.tween_callback(_advance)


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
	if speaker != "":
		speaker_label.add_theme_color_override("font_color", _get_speaker_color(speaker))
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
		portrait_container.visible = false
		return
	var sprite_id := _get_speaker_sprite_id(speaker)
	if sprite_id.is_empty():
		portrait_container.visible = false
		return
	var frames := SpriteLoader.get_frames(sprite_id)
	if not frames or not frames.has_animation("idle_down"):
		portrait_container.visible = false
		return
	var tex := frames.get_frame_texture("idle_down", 0)
	if not tex:
		portrait_container.visible = false
		return
	_portrait = TextureRect.new()
	_portrait.texture = tex
	_portrait.custom_minimum_size = Vector2(80, 80)
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait_container.add_child(_portrait)
	portrait_container.visible = true


func _get_speaker_sprite_id(speaker: String) -> String:
	if MENTOR_SPRITES.has(speaker):
		return MENTOR_SPRITES[speaker]
	if STRANGER_SPRITES.has(speaker):
		return STRANGER_SPRITES[speaker]
	if NPC_SPRITES.has(speaker):
		return NPC_SPRITES[speaker]
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


func _get_speaker_color(speaker: String) -> Color:
	if SPEAKER_COLORS.has(speaker):
		return SPEAKER_COLORS[speaker]
	if NPC_SPRITES.has(speaker):
		return NPC_COLOR
	if speaker == GameState.player_name:
		return PLAYER_COLOR
	for member in GameState.party_members:
		if member.get("name", "") == speaker:
			return PARTY_COLOR
	return DEFAULT_COLOR


func _handle_advance() -> void:
	if _typing:
		text_label.visible_ratio = 1.0
		_typing = false
		continue_indicator.visible = true
	else:
		SFXManager.play(SFXManager.Category.UI_SELECT, 0.3)
		_advance()
