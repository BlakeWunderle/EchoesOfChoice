extends Control

signal action_chosen(action: Dictionary)

@onready var _main_box: HBoxContainer = %MainButtons
@onready var _sub_panel: Panel = %SubPanel
@onready var _sub_list: VBoxContainer = %SubList

var _unit: BattleUnit


func show_for(unit: BattleUnit) -> void:
	_unit = unit
	visible = true
	_show_main()


func _show_main() -> void:
	_main_box.visible = true
	_sub_panel.visible = false
	for child in _main_box.get_children():
		if child is Button and child.name == "AbilityBtn":
			child.disabled = _unit.abilities.size() <= 1
	_main_box.get_child(0).call_deferred("grab_focus")


func _on_attack() -> void:
	if _unit.abilities.size() > 0:
		visible = false
		action_chosen.emit({"type": "attack", "ability": _unit.abilities[0]})


func _on_ability() -> void:
	_main_box.visible = false
	_sub_panel.visible = true
	for child in _sub_list.get_children():
		child.queue_free()
	for ability in _unit.abilities:
		var btn := Button.new()
		btn.text = "%s  MP:%d" % [ability.ability_name, ability.mana_cost]
		btn.disabled = not _unit.can_use_ability(ability)
		btn.custom_minimum_size = Vector2(0, 36)
		var ab := ability
		btn.pressed.connect(func():
			visible = false
			action_chosen.emit({"type": "ability", "ability": ab}))
		_sub_list.add_child(btn)
	var back := Button.new()
	back.text = "Back"
	back.custom_minimum_size = Vector2(0, 36)
	back.pressed.connect(_show_main)
	_sub_list.add_child(back)
	await get_tree().process_frame
	if _sub_list.get_child_count() > 0:
		_sub_list.get_child(0).grab_focus()


func _on_item() -> void:
	# TODO: Item menu
	_show_main()


func _on_defend() -> void:
	visible = false
	action_chosen.emit({"type": "defend"})


func _ready() -> void:
	visible = false
	%AttackBtn.pressed.connect(_on_attack)
	%AbilityBtn.pressed.connect(_on_ability)
	%ItemBtn.pressed.connect(_on_item)
	%DefendBtn.pressed.connect(_on_defend)
