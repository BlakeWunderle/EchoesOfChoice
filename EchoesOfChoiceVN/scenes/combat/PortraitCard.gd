extends Control

signal clicked(unit: BattleUnit)

@onready var _portrait: TextureRect = %Portrait
@onready var _name_label: Label = %UnitName
@onready var _hp_bar: ProgressBar = %HPBar
@onready var _mp_bar: ProgressBar = %MPBar
@onready var _atb_bar: ProgressBar = %ATBBar
@onready var _panel: Panel = %CardPanel

var _unit: BattleUnit
var _targetable: bool = false


func setup(unit: BattleUnit) -> void:
	_unit = unit
	_name_label.text = unit.unit_name
	_load_portrait()
	update_display()


func update_display() -> void:
	if not _unit:
		return
	_hp_bar.value = _unit.get_hp_ratio() * 100.0
	_mp_bar.value = _unit.get_mp_ratio() * 100.0
	_atb_bar.value = _unit.get_atb_ratio() * 100.0
	modulate.a = 1.0 if _unit.is_alive else 0.4


func set_active(active: bool) -> void:
	if active:
		_panel.modulate = Color(1.2, 1.2, 1.0)
	else:
		_panel.modulate = Color.WHITE


func set_targetable(targetable: bool) -> void:
	_targetable = targetable
	if targetable:
		_panel.modulate = Color(1.0, 1.0, 1.4)
	else:
		_panel.modulate = Color.WHITE


func get_unit() -> BattleUnit:
	return _unit


func _load_portrait() -> void:
	# Attempt to load portrait from portrait_id mapping
	var path := "res://assets/art/portraits/characters/Character_01.png"
	if _unit.team == Enums.Team.PLAYER:
		# Use class-based portrait assignment
		var class_map := {
			"squire": "Character_10", "mage": "Character_30",
			"entertainer": "Character_50", "scholar": "Character_70",
		}
		var mapped: String = class_map.get(_unit.class_id, "")
		if mapped != "":
			path = "res://assets/art/portraits/characters/%s.png" % mapped
	else:
		# Enemies use numbered portraits based on hash
		var idx := (_unit.class_id.hash() % 100) + 1
		path = "res://assets/art/portraits/characters/Character_%02d.png" % clampi(idx, 1, 117)

	if ResourceLoader.exists(path):
		_portrait.texture = load(path) as Texture2D


func _gui_input(event: InputEvent) -> void:
	if _targetable and event is InputEventMouseButton and event.pressed:
		get_viewport().set_input_as_handled()
		clicked.emit(_unit)
