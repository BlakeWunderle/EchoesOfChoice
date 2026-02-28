extends Control

const _STRANGER_PORTRAIT := "res://assets/art/portraits/characters/Character_01.png"
const _CLASS_PORTRAITS: Dictionary = {
	"squire": "res://assets/art/portraits/characters/Character_10.png",
	"mage": "res://assets/art/portraits/characters/Character_30.png",
	"entertainer": "res://assets/art/portraits/characters/Character_50.png",
	"scholar": "res://assets/art/portraits/characters/Character_70.png",
}

const CLASS_INFO: Dictionary = {
	"squire": {"name": "Squire", "desc": "A sturdy warrior with steel and shield."},
	"mage": {"name": "Mage", "desc": "A wielder of arcane magic."},
	"entertainer": {"name": "Entertainer", "desc": "A performer who inspires allies."},
	"scholar": {"name": "Scholar", "desc": "A brilliant inventor and analyst."},
}

signal _recruit_confirmed

@onready var _dialogue_box: Control = %DialogueBox
@onready var _recruit_panel: Panel = %RecruitPanel
@onready var _recruit_title: Label = %RecruitTitle
@onready var _recruit_name: LineEdit = %RecruitName
@onready var _recruit_male_btn: Button = %RecruitMale
@onready var _recruit_female_btn: Button = %RecruitFemale
@onready var _recruit_class_grid: GridContainer = %RecruitClassGrid
@onready var _recruit_class_desc: RichTextLabel = %RecruitClassDesc
@onready var _recruit_confirm: Button = %RecruitConfirm

var _recruit_selected_class: String = ""
var _recruit_gender_group := ButtonGroup.new()
var _recruit_class_group := ButtonGroup.new()


func _ready() -> void:
	MusicManager.play_context(MusicManager.MusicContext.CUTSCENE)
	_recruit_panel.visible = false
	_setup_recruit_panel()
	_play_story()


func _setup_recruit_panel() -> void:
	_recruit_male_btn.toggle_mode = true
	_recruit_female_btn.toggle_mode = true
	_recruit_male_btn.button_group = _recruit_gender_group
	_recruit_female_btn.button_group = _recruit_gender_group
	_recruit_male_btn.button_pressed = true

	for class_id in CLASS_INFO:
		var info: Dictionary = CLASS_INFO[class_id]
		var btn := Button.new()
		btn.text = info["name"]
		btn.toggle_mode = true
		btn.button_group = _recruit_class_group
		btn.custom_minimum_size = Vector2(160, 44)
		btn.pressed.connect(_on_recruit_class_selected.bind(class_id))
		_recruit_class_grid.add_child(btn)

	_recruit_confirm.pressed.connect(_on_recruit_confirm)
	_recruit_confirm.disabled = true
	_recruit_name.text_changed.connect(_on_recruit_name_changed)


func _play_story() -> void:
	# Opening narration
	_dialogue_box.show_dialogue(_opening_narration())
	await _dialogue_box.dialogue_finished

	# Stranger greets player
	_dialogue_box.show_dialogue(_stranger_greeting())
	await _dialogue_box.dialogue_finished

	# Recruit 3 companions
	var intros := [_companion_intro_1(), _companion_intro_2(), _companion_intro_3()]
	for i in range(3):
		_dialogue_box.show_dialogue(intros[i])
		await _dialogue_box.dialogue_finished

		var companion := await _recruit_companion(i + 1)
		var gender_key := "prince" if _recruit_male_btn.button_pressed else "princess"
		GameState.add_party_member(companion["name"], gender_key, companion["class_id"])

		_dialogue_box.show_dialogue(_companion_welcome(companion))
		await _dialogue_box.dialogue_finished

	# Final briefing
	_dialogue_box.clear_portraits()
	_dialogue_box.show_dialogue(_stranger_briefing())
	await _dialogue_box.dialogue_finished

	# Transition to first battle
	GameState.current_battle_id = "city_street"
	SceneManager.go_to_battle()


func _recruit_companion(index: int) -> Dictionary:
	_recruit_panel.visible = true
	_recruit_title.text = "Companion %d" % index
	_recruit_name.text = ""
	_recruit_selected_class = ""
	_recruit_confirm.disabled = true
	_recruit_male_btn.button_pressed = true
	for child in _recruit_class_grid.get_children():
		if child is Button:
			child.button_pressed = false
	_recruit_class_desc.text = ""
	_recruit_name.grab_focus()

	await _recruit_confirmed

	_recruit_panel.visible = false
	return {
		"name": _recruit_name.text.strip_edges(),
		"class_id": _recruit_selected_class,
	}


func _on_recruit_class_selected(class_id: String) -> void:
	_recruit_selected_class = class_id
	var info: Dictionary = CLASS_INFO[class_id]
	_recruit_class_desc.text = "[b]%s[/b] — %s" % [info["name"], info["desc"]]
	_update_recruit_confirm()


func _on_recruit_name_changed(_new_text: String) -> void:
	_update_recruit_confirm()


func _update_recruit_confirm() -> void:
	_recruit_confirm.disabled = (
		_recruit_name.text.strip_edges().is_empty()
		or _recruit_selected_class.is_empty()
	)


func _on_recruit_confirm() -> void:
	if _recruit_name.text.strip_edges().is_empty() or _recruit_selected_class.is_empty():
		return
	_recruit_confirmed.emit()


# --- Dialogue Builders ---

func _player_portrait() -> String:
	return _CLASS_PORTRAITS.get(GameState.player_class_id, "")


func _opening_narration() -> Array[Dictionary]:
	return [
		{"text": "The tavern sits heavy with smoke and silence. A fire crackles low in the hearth, casting long shadows across worn wooden tables."},
		{"text": "Outside, the world grows darker with each passing day. Villages vanish behind walls of fog. Travelers speak of creatures on the roads that weren't there a season ago."},
		{"text": "But here, in this dim corner booth, sits someone who seems untroubled by it all. A figure wrapped in a dark cloak, nursing a drink, watching."},
		{"text": "Their eyes find you across the room."},
	]


func _stranger_greeting() -> Array[Dictionary]:
	var pname := GameState.player_name
	return [
		{"speaker": "???", "text": "You there. Come, sit.", "side": "left", "portrait": _STRANGER_PORTRAIT},
		{"text": "The hooded figure gestures to the empty seat. Up close, their features are hidden — only a sharp jaw and knowing smile visible beneath the cowl."},
		{"speaker": "???", "text": "I've been watching you, %s. You move like someone with purpose." % pname, "side": "left"},
		{"speaker": pname, "text": "Who are you? What do you want?", "side": "right", "portrait": _player_portrait()},
		{"speaker": "???", "text": "Names aren't important right now. What matters is that the kingdom is dying, and very few people know why.", "side": "left"},
		{"speaker": "???", "text": "Something evil has taken root beyond the forest. A corruption that spreads further every day.", "side": "left"},
		{"speaker": "???", "text": "The king's soldiers are stretched thin. The guilds bicker. No one is coming to save this land.", "side": "left"},
		{"speaker": "???", "text": "But you... you could make a difference. If you had the right people beside you.", "side": "left"},
	]


func _companion_intro_1() -> Array[Dictionary]:
	return [
		{"text": "As if on cue, another figure overhears the conversation and slides into the booth."},
		{"text": "A warrior with steady eyes and an easy confidence takes a seat beside you."},
	]


func _companion_intro_2() -> Array[Dictionary]:
	return [
		{"text": "Across the tavern, a second figure catches the stranger's eye. Without hesitation, they stride over."},
		{"text": "They pull up a chair, settling in with quiet resolve."},
	]


func _companion_intro_3() -> Array[Dictionary]:
	return [
		{"text": "One last warrior pushes through the crowd, drawn by the energy at the corner table."},
		{"text": "They squeeze into the booth with a grin, completing the group."},
	]


func _companion_welcome(companion: Dictionary) -> Array[Dictionary]:
	var class_name: String = CLASS_INFO.get(companion["class_id"], {}).get("name", "???")
	return [
		{"text": "%s the %s joins the party!" % [companion["name"], class_name]},
	]


func _stranger_briefing() -> Array[Dictionary]:
	var pname := GameState.player_name
	return [
		{"speaker": "???", "text": "Four of you. Good. That should be enough.", "side": "left", "portrait": _STRANGER_PORTRAIT},
		{"speaker": pname, "text": "Enough for what, exactly?", "side": "right", "portrait": _player_portrait()},
		{"speaker": "???", "text": "Head east through the city. The darkness starts at the forest's edge, but the rot runs far deeper.", "side": "left"},
		{"speaker": "???", "text": "Find the source. End it. I'll find you again when the time is right.", "side": "left"},
		{"text": "The stranger downs their drink, rises, and vanishes into the crowd. Just like that — gone."},
		{"text": "You look at your new companions. The road ahead won't be easy, but at least you won't walk it alone."},
	]
