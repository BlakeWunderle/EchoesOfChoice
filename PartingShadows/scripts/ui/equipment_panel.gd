class_name EquipmentPanel extends PanelContainer

## Shows all party members' equipment in the pause menu.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const EquipmentData := preload("res://scripts/data/equipment_data.gd")

signal closed

var _vbox: VBoxContainer
var _close_btn: Button


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	add_child(margin)

	_vbox = VBoxContainer.new()
	_vbox.add_theme_constant_override("separation", 6)
	margin.add_child(_vbox)

	_close_btn = Button.new()
	_close_btn.text = "Back"
	_close_btn.custom_minimum_size = Vector2(120, 36)
	_close_btn.pressed.connect(func() -> void: closed.emit())


func show_party(party: Array) -> void:
	if _close_btn.get_parent() == _vbox:
		_vbox.remove_child(_close_btn)
	for child: Node in _vbox.get_children():
		child.queue_free()

	for fighter: FighterData in party:
		if not fighter.is_user_controlled:
			continue
		_add_line("%s the %s" % [fighter.character_name, fighter.character_type], 16, true)
		if fighter.equipment.is_empty():
			_add_line("  No equipment", 14, false)
		else:
			for equip: EquipmentData in fighter.equipment:
				var upgraded: String = "  [Upgraded]" if equip.upgrade_level > 0 else ""
				_add_line("  %s: %s  (%s)%s" % [
					equip.get_slot_name(), equip.display_name,
					equip.get_bonus_text(), upgraded], 14, false)
		_add_line("", 8, false)

	_vbox.add_child(_close_btn)
	visible = true
	_close_btn.grab_focus()


func _add_line(text: String, font_size: int, bold: bool) -> void:
	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", font_size)
	if bold:
		lbl.add_theme_color_override("font_color", Color(0.85, 0.95, 0.9))
	_vbox.add_child(lbl)
