extends Control

## Party creation scene — tavern introduction + 3 character creation loops.
## Text and flow from C# Program.cs CreateParty().

const DialoguePanel := preload("res://scripts/ui/dialogue_panel.gd")
const NameInput := preload("res://scripts/ui/name_input.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")
const FighterDB := preload("res://scripts/data/fighter_db.gd")

enum State {
	INTRO, NAME_1, CLASS_1, CONFIRM_1,
	BRIDGE_1, NAME_2, CLASS_2, CONFIRM_2,
	BRIDGE_2, NAME_3, CLASS_3, CONFIRM_3,
	OUTRO, DONE,
}

const CLASS_OPTIONS: Array[Dictionary] = [
	{"label": "Squire", "description": "A sturdy warrior who fights with steel and shield."},
	{"label": "Mage", "description": "A wielder of arcane forces and elemental magic."},
	{"label": "Entertainer", "description": "A charismatic performer who inspires allies."},
	{"label": "Tinker", "description": "A brilliant mind who turns knowledge into power."},
	{"label": "Wildling", "description": "A primal soul who communes with nature and beasts."},
]

const CLASS_IDS: Array[String] = ["Squire", "Mage", "Entertainer", "Tinker", "Wildling"]

var _state: State = State.INTRO
var _current_name: String = ""
var _party: Array[FighterData] = []

var _dialogue: DialoguePanel
var _name_input: NameInput
var _choice_menu: ChoiceMenu
var _vbox: VBoxContainer


func _ready() -> void:
	_build_ui()
	_set_state(State.INTRO)


func _build_ui() -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 80)
	margin.add_theme_constant_override("margin_right", 80)
	margin.add_theme_constant_override("margin_top", 40)
	margin.add_theme_constant_override("margin_bottom", 40)
	add_child(margin)

	_vbox = VBoxContainer.new()
	_vbox.add_theme_constant_override("separation", 16)
	margin.add_child(_vbox)

	_dialogue = DialoguePanel.new()
	_dialogue.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_dialogue.all_text_finished.connect(_on_text_finished)
	_dialogue.visible = false
	_vbox.add_child(_dialogue)

	_name_input = NameInput.new()
	_name_input.name_entered.connect(_on_name_entered)
	_name_input.visible = false
	_vbox.add_child(_name_input)

	_choice_menu = ChoiceMenu.new()
	_choice_menu.choice_selected.connect(_on_class_selected)
	_choice_menu.visible = false
	_vbox.add_child(_choice_menu)


func _set_state(new_state: State) -> void:
	_state = new_state
	_dialogue.visible = false
	_name_input.visible = false
	_choice_menu.visible = false

	match _state:
		State.INTRO:
			_show_dialogue(_get_intro_text())
		State.NAME_1:
			_name_input.show_prompt("'What is your name, young warrior?'")
		State.NAME_2:
			_name_input.show_prompt("'And what is your name?'")
		State.NAME_3:
			_name_input.show_prompt("'And you? What is your name?'")
		State.CLASS_1, State.CLASS_2, State.CLASS_3:
			_show_dialogue(["What is your calling?"])
		State.CONFIRM_1, State.CONFIRM_2, State.CONFIRM_3:
			var fighter: FighterData = _party.back()
			_show_dialogue(["%s the %s joins the party!" % [
				fighter.character_name, fighter.character_type]])
		State.BRIDGE_1:
			_show_dialogue(_get_bridge_1_text())
		State.BRIDGE_2:
			_show_dialogue(_get_bridge_2_text())
		State.OUTRO:
			_show_dialogue(_get_outro_text())
		State.DONE:
			_finish()


func _show_dialogue(lines: Array) -> void:
	_dialogue.show_text(lines)


func _on_text_finished() -> void:
	match _state:
		State.INTRO:
			_set_state(State.NAME_1)
		State.CLASS_1, State.CLASS_2, State.CLASS_3:
			_dialogue.visible = false
			_choice_menu.show_choices(CLASS_OPTIONS)
		State.CONFIRM_1:
			_set_state(State.BRIDGE_1)
		State.CONFIRM_2:
			_set_state(State.BRIDGE_2)
		State.CONFIRM_3:
			_set_state(State.OUTRO)
		State.BRIDGE_1:
			_set_state(State.NAME_2)
		State.BRIDGE_2:
			_set_state(State.NAME_3)
		State.OUTRO:
			_set_state(State.DONE)


func _on_name_entered(player_name: String) -> void:
	_current_name = player_name
	_name_input.visible = false

	match _state:
		State.NAME_1:
			_show_dialogue(["'Greetings, %s. You look like someone who can handle themselves.'" % player_name])
			_state = State.CLASS_1
		State.NAME_2:
			_show_dialogue(["'Greetings, %s. Good, we'll need the help.'" % player_name])
			_state = State.CLASS_2
		State.NAME_3:
			_show_dialogue(["'Greetings, %s. That makes three. That should be enough.'" % player_name])
			_state = State.CLASS_3


func _on_class_selected(index: int) -> void:
	_choice_menu.hide_menu()
	var class_id: String = CLASS_IDS[index]
	var fighter: FighterData = FighterDB.create_player(class_id, _current_name)
	_party.append(fighter)

	match _state:
		State.CLASS_1: _set_state(State.CONFIRM_1)
		State.CLASS_2: _set_state(State.CONFIRM_2)
		State.CLASS_3: _set_state(State.CONFIRM_3)


func _finish() -> void:
	GameState.set_party(_party)
	GameState.advance_to_battle("CityStreetBattle")
	SceneManager.change_scene("res://scenes/narrative/narrative.tscn")


# --- Narrative text from C# Program.cs ---

func _get_intro_text() -> Array[String]:
	return [
		"The Copper Mug. Your regular haunt. You know every crack in the floorboards, every stain on the bar.",
		"But tonight something is different. The fire burns low without anyone stoking it. The other regulars have gone quiet.",
		"A shrouded stranger sits in the corner booth \u2014 a booth that was empty a moment ago.",
		"The air feels heavy. Wrong. Like the room itself is holding its breath.",
		"The stranger catches your eye and waves you over.",
	]


func _get_bridge_1_text() -> Array[String]:
	return [
		"Shortly after, another warrior overhears the conversation and slides into the booth.",
		"The stranger looks them over and asks the same question.",
	]


func _get_bridge_2_text() -> Array[String]:
	return [
		"One last warrior takes a seat at the now crowded table.",
		"The stranger doesn't even hesitate.",
	]


func _get_outro_text() -> Array[String]:
	return [
		"The stranger leans in close, voice barely above a whisper.",
		"'Something evil has taken root beyond the forest. The city needs heroes whether it knows it or not.'",
		"'Find the source. End it. I'll be watching \u2014 and I'll find you when the time is right.'",
		"The stranger raises a glass but doesn't drink \u2014 just holds it, watching the liquid catch the firelight.",
		"Then they set it down, untouched, and disappear into the crowd. The coin left on the table is gold. Blank on one side.",
	]
