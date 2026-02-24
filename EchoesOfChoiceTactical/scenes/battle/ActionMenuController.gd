class_name ActionMenuController extends VBoxContainer

signal attack_chosen
signal ability_chosen(ability: AbilityData)
signal item_chosen(item: ItemData)
signal move_chosen
signal wait_chosen
signal facing_chosen(dir: int)

var _btn_attack: Button
var _btn_ability: Button
var _btn_item: Button
var _btn_move: Button
var _btn_wait: Button
var _btn_facing_n: Button
var _btn_facing_s: Button
var _btn_facing_e: Button
var _btn_facing_w: Button
var _facing_container: HBoxContainer
var _ability_container: VBoxContainer
var _item_container: VBoxContainer
var _current_unit: Unit


func _ready() -> void:
	_btn_attack = Button.new()
	_btn_attack.text = "Attack"
	_btn_attack.pressed.connect(_on_attack_pressed)
	add_child(_btn_attack)

	_btn_ability = Button.new()
	_btn_ability.text = "Ability"
	_btn_ability.pressed.connect(_on_ability_pressed)
	add_child(_btn_ability)

	_btn_item = Button.new()
	_btn_item.text = "Item"
	_btn_item.pressed.connect(_on_item_pressed)
	add_child(_btn_item)

	_btn_move = Button.new()
	_btn_move.text = "Move"
	_btn_move.pressed.connect(_on_move_pressed)
	add_child(_btn_move)

	_btn_wait = Button.new()
	_btn_wait.text = "Wait"
	_btn_wait.pressed.connect(_on_wait_pressed)
	add_child(_btn_wait)

	_ability_container = VBoxContainer.new()
	_ability_container.visible = false
	add_child(_ability_container)

	_item_container = VBoxContainer.new()
	_item_container.visible = false
	add_child(_item_container)

	_facing_container = HBoxContainer.new()
	_facing_container.visible = false
	add_child(_facing_container)

	_btn_facing_n = Button.new()
	_btn_facing_n.text = "N"
	_btn_facing_n.pressed.connect(func(): _on_facing_selected(Enums.Facing.NORTH))
	_facing_container.add_child(_btn_facing_n)

	_btn_facing_s = Button.new()
	_btn_facing_s.text = "S"
	_btn_facing_s.pressed.connect(func(): _on_facing_selected(Enums.Facing.SOUTH))
	_facing_container.add_child(_btn_facing_s)

	_btn_facing_e = Button.new()
	_btn_facing_e.text = "E"
	_btn_facing_e.pressed.connect(func(): _on_facing_selected(Enums.Facing.EAST))
	_facing_container.add_child(_btn_facing_e)

	_btn_facing_w = Button.new()
	_btn_facing_w.text = "W"
	_btn_facing_w.pressed.connect(func(): _on_facing_selected(Enums.Facing.WEST))
	_facing_container.add_child(_btn_facing_w)


func show_menu(unit: Unit) -> void:
	_current_unit = unit
	visible = true
	_ability_container.visible = false
	_item_container.visible = false
	_facing_container.visible = false

	_btn_attack.visible = not unit.has_acted
	_btn_ability.visible = not unit.has_acted and unit.has_any_affordable_ability()
	_btn_item.visible = not unit.has_acted and _has_usable_items()
	_btn_move.visible = not unit.has_moved
	_btn_wait.visible = true


func hide_menu() -> void:
	visible = false
	_ability_container.visible = false
	_item_container.visible = false
	_facing_container.visible = false


func show_facing() -> void:
	visible = true
	_btn_attack.visible = false
	_btn_ability.visible = false
	_btn_item.visible = false
	_btn_move.visible = false
	_btn_wait.visible = false
	_facing_container.visible = true


func _has_usable_items() -> bool:
	return GameState.get_consumables_in_inventory().size() > 0


# --- Internal Handlers ---

func _on_attack_pressed() -> void:
	if _current_unit == null or _current_unit.has_acted:
		return
	hide_menu()
	attack_chosen.emit()


func _on_ability_pressed() -> void:
	if _current_unit == null or _current_unit.has_acted:
		return

	for child in _ability_container.get_children():
		child.queue_free()

	var affordable := _current_unit.get_affordable_abilities()
	for i in range(affordable.size()):
		var ability := affordable[i]
		if ability.ability_name == "Strike":
			continue
		var btn := Button.new()
		btn.text = "%s (MP: %d, Range: %d)" % [ability.ability_name, ability.mana_cost, ability.ability_range]
		var idx := i
		btn.pressed.connect(func(): _on_ability_picked(affordable[idx]))
		_ability_container.add_child(btn)

	var back_btn := Button.new()
	back_btn.text = "Back"
	back_btn.pressed.connect(func():
		_ability_container.visible = false
		show_menu(_current_unit)
	)
	_ability_container.add_child(back_btn)

	_ability_container.visible = true
	_btn_attack.visible = false
	_btn_ability.visible = false
	_btn_item.visible = false
	_btn_move.visible = false
	_btn_wait.visible = false


func _on_ability_picked(ability: AbilityData) -> void:
	hide_menu()
	ability_chosen.emit(ability)


func _on_item_pressed() -> void:
	if _current_unit == null or _current_unit.has_acted:
		return

	for child in _item_container.get_children():
		child.queue_free()

	var consumables := GameState.get_consumables_in_inventory()
	for entry in consumables:
		var item: ItemData = entry["item"]
		if item.consumable_effect == Enums.ConsumableEffect.FULL_REST_ALL:
			continue
		var qty: int = entry["quantity"]
		var btn := Button.new()
		btn.text = "%s x%d  (%s)" % [item.display_name, qty, item.get_stat_summary()]
		btn.pressed.connect(func(): _on_item_picked(item))
		_item_container.add_child(btn)

	var back_btn := Button.new()
	back_btn.text = "Back"
	back_btn.pressed.connect(func():
		_item_container.visible = false
		show_menu(_current_unit)
	)
	_item_container.add_child(back_btn)

	_item_container.visible = true
	_btn_attack.visible = false
	_btn_ability.visible = false
	_btn_item.visible = false
	_btn_move.visible = false
	_btn_wait.visible = false


func _on_item_picked(item: ItemData) -> void:
	hide_menu()
	item_chosen.emit(item)


func _on_move_pressed() -> void:
	if _current_unit == null or _current_unit.has_moved:
		return
	hide_menu()
	move_chosen.emit()


func _on_wait_pressed() -> void:
	if _current_unit == null:
		return
	hide_menu()
	wait_chosen.emit()


func _on_facing_selected(dir: int) -> void:
	hide_menu()
	facing_chosen.emit(dir)
