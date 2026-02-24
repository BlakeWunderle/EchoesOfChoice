extends Control

signal items_closed

@onready var item_list: VBoxContainer = $Panel/MarginContainer/VBox/ScrollContainer/ItemList
@onready var detail_label: Label = $Panel/MarginContainer/VBox/DetailLabel
@onready var close_button: Button = $Panel/MarginContainer/VBox/CloseButton


func _ready() -> void:
	close_button.pressed.connect(func(): items_closed.emit())
	_refresh_list()


func _refresh_list() -> void:
	detail_label.text = ""
	for child in item_list.get_children():
		child.queue_free()

	var consumables := GameState.get_consumables_in_inventory()
	if consumables.is_empty():
		var empty := Label.new()
		empty.text = "No usable items."
		empty.add_theme_font_size_override("font_size", 14)
		empty.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		empty.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		item_list.add_child(empty)
		return

	for entry in consumables:
		var item: ItemData = entry["item"]
		var qty: int = entry["quantity"]
		item_list.add_child(_create_item_row(item, qty))


func _create_item_row(item: ItemData, qty: int) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)

	var name_lbl := Label.new()
	name_lbl.text = item.display_name
	name_lbl.custom_minimum_size = Vector2(160, 0)
	name_lbl.add_theme_font_size_override("font_size", 14)
	row.add_child(name_lbl)

	var qty_lbl := Label.new()
	qty_lbl.text = "x%d" % qty
	qty_lbl.custom_minimum_size = Vector2(40, 0)
	qty_lbl.add_theme_font_size_override("font_size", 13)
	qty_lbl.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	row.add_child(qty_lbl)

	var effect_lbl := Label.new()
	effect_lbl.text = item.get_stat_summary()
	effect_lbl.custom_minimum_size = Vector2(160, 0)
	effect_lbl.add_theme_font_size_override("font_size", 12)
	effect_lbl.add_theme_color_override("font_color", Color(0.5, 0.9, 0.5))
	row.add_child(effect_lbl)

	match item.consumable_effect:
		Enums.ConsumableEffect.FULL_REST_ALL:
			var use_btn := Button.new()
			use_btn.text = "Use"
			use_btn.custom_minimum_size = Vector2(60, 28)
			use_btn.add_theme_font_size_override("font_size", 12)
			use_btn.pressed.connect(func(): _use_full_rest(item))
			row.add_child(use_btn)
		Enums.ConsumableEffect.HEAL_HP, Enums.ConsumableEffect.RESTORE_MANA:
			var use_btn := Button.new()
			use_btn.text = "Use"
			use_btn.custom_minimum_size = Vector2(60, 28)
			use_btn.add_theme_font_size_override("font_size", 12)
			use_btn.pressed.connect(func(): _show_target_select(item))
			row.add_child(use_btn)
		Enums.ConsumableEffect.BUFF_STAT:
			var battle_lbl := Label.new()
			battle_lbl.text = "(Battle only)"
			battle_lbl.add_theme_font_size_override("font_size", 11)
			battle_lbl.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
			row.add_child(battle_lbl)

	row.mouse_entered.connect(func(): detail_label.text = item.description)
	return row


func _use_full_rest(item: ItemData) -> void:
	GameState.remove_item(item.item_id)
	GameState.full_rest_party()
	_refresh_list()
	detail_label.text = "Party fully restored."


func _show_target_select(item: ItemData) -> void:
	for child in item_list.get_children():
		child.queue_free()
	detail_label.text = "Choose a party member to use %s on:" % item.display_name

	var back_btn := Button.new()
	back_btn.text = "← Back"
	back_btn.add_theme_font_size_override("font_size", 13)
	back_btn.pressed.connect(_refresh_list)
	item_list.add_child(back_btn)

	for member in GameState.party_members:
		var name_str: String = member.get("name", "???")
		var max_hp: int = GameState.get_member_max_hp(member)
		var max_mp: int = GameState.get_member_max_mp(member)
		var cur_hp: int = member.get("current_hp", -1)
		var cur_mp: int = member.get("current_mp", -1)
		if cur_hp < 0:
			cur_hp = max_hp
		if cur_mp < 0:
			cur_mp = max_mp

		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 12)

		var name_lbl := Label.new()
		name_lbl.text = name_str
		name_lbl.custom_minimum_size = Vector2(140, 0)
		name_lbl.add_theme_font_size_override("font_size", 14)
		row.add_child(name_lbl)

		var stat_lbl := Label.new()
		if item.consumable_effect == Enums.ConsumableEffect.HEAL_HP:
			stat_lbl.text = "HP %d/%d" % [cur_hp, max_hp]
		else:
			stat_lbl.text = "MP %d/%d" % [cur_mp, max_mp]
		stat_lbl.custom_minimum_size = Vector2(100, 0)
		stat_lbl.add_theme_font_size_override("font_size", 13)
		stat_lbl.add_theme_color_override("font_color", Color(0.7, 0.9, 0.7))
		row.add_child(stat_lbl)

		var use_btn := Button.new()
		use_btn.text = "Use"
		use_btn.custom_minimum_size = Vector2(60, 28)
		use_btn.add_theme_font_size_override("font_size", 12)
		var member_copy: Dictionary = member
		use_btn.pressed.connect(func(): _apply_to_member(item, member_copy))
		row.add_child(use_btn)

		item_list.add_child(row)


func _apply_to_member(item: ItemData, member: Dictionary) -> void:
	if not GameState.remove_item(item.item_id):
		return
	var unit_name: String = member.get("name", "")
	match item.consumable_effect:
		Enums.ConsumableEffect.HEAL_HP:
			GameState.heal_unit(unit_name, item.consumable_value)
		Enums.ConsumableEffect.RESTORE_MANA:
			GameState.restore_mana(unit_name, item.consumable_value)
	_refresh_list()
