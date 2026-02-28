extends Control

const CLASS_INFO: Dictionary = {
	"squire": {
		"name": "Squire",
		"desc": "A sturdy warrior who fights with steel and shield. Strong physical attacks and solid defense.",
	},
	"mage": {
		"name": "Mage",
		"desc": "A wielder of arcane forces and elemental magic. Devastating spells but fragile in close combat.",
	},
	"entertainer": {
		"name": "Entertainer",
		"desc": "A charismatic performer who inspires allies. Powerful buffs and support abilities.",
	},
	"scholar": {
		"name": "Scholar",
		"desc": "A brilliant mind who turns knowledge into power. Versatile gadgets and analytical abilities.",
	},
}

var _selected_class: String = ""
var _gender_group := ButtonGroup.new()
var _class_group := ButtonGroup.new()

@onready var _name_input: LineEdit = %NameInput
@onready var _male_btn: Button = %MaleButton
@onready var _female_btn: Button = %FemaleButton
@onready var _class_grid: GridContainer = %ClassGrid
@onready var _class_desc: RichTextLabel = %ClassDesc
@onready var _confirm_btn: Button = %ConfirmButton


func _ready() -> void:
	MusicManager.play_context(MusicManager.MusicContext.CUTSCENE)

	_male_btn.toggle_mode = true
	_female_btn.toggle_mode = true
	_male_btn.button_group = _gender_group
	_female_btn.button_group = _gender_group
	_male_btn.button_pressed = true

	for class_id in CLASS_INFO:
		var info: Dictionary = CLASS_INFO[class_id]
		var btn := Button.new()
		btn.text = info["name"]
		btn.toggle_mode = true
		btn.button_group = _class_group
		btn.custom_minimum_size = Vector2(180, 50)
		btn.pressed.connect(_on_class_selected.bind(class_id))
		_class_grid.add_child(btn)

	_confirm_btn.pressed.connect(_on_confirm)
	_confirm_btn.disabled = true
	_name_input.text_changed.connect(_on_name_changed)
	_name_input.grab_focus()
	_class_desc.text = "Select a class to see its description."


func _on_class_selected(class_id: String) -> void:
	_selected_class = class_id
	var info: Dictionary = CLASS_INFO[class_id]
	_class_desc.text = "[b]%s[/b]\n%s" % [info["name"], info["desc"]]
	_update_confirm_state()


func _on_name_changed(_new_text: String) -> void:
	_update_confirm_state()


func _update_confirm_state() -> void:
	_confirm_btn.disabled = _name_input.text.strip_edges().is_empty() or _selected_class.is_empty()


func _on_confirm() -> void:
	var p_name := _name_input.text.strip_edges()
	if p_name.is_empty() or _selected_class.is_empty():
		return
	var gender := "prince" if _male_btn.button_pressed else "princess"
	GameState.set_player_info(p_name, gender)
	GameState.set_player_class(_selected_class)
	SceneManager.go_to_tavern_opening()
