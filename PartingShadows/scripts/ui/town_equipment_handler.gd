class_name TownEquipmentHandler extends RefCounted

## Manages the equipment upgrade phase at town stops.
## Delegated from town_stop.gd to keep file sizes manageable.

const EquipmentDB := preload("res://scripts/data/equipment_db.gd")
const EquipmentData := preload("res://scripts/data/equipment_data.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")

var _party: Array = []
var _char_index: int = 0
var _upgrade_options: Array[Dictionary] = []
var _upgrade_option_ids: Array[String] = []
var _selected_equip: EquipmentData = null
var _equip_slot_indices: Array[int] = []  ## Maps choice index -> equipment array index

signal narration_requested(lines: Array)
signal choices_requested(options: Array, header: String)
signal upgrade_complete(char_index: int, slot_name: String, equip_name: String)
signal phase_finished


func start(party: Array, story_id: String) -> void:
	_party = party
	_char_index = 0

	# Check if anyone has upgradeable equipment
	if not _any_upgradeable():
		phase_finished.emit()
		return

	# Show narration first
	var lines: Array[String] = EquipmentDB.get_upgrade_text(story_id)
	narration_requested.emit(lines)


func on_narration_done() -> void:
	_show_slot_selection()


func _any_upgradeable() -> bool:
	for fighter: FighterData in _party:
		if not fighter.is_user_controlled:
			continue
		for equip: EquipmentData in fighter.equipment:
			if equip.upgrade_level < 1:
				return true
	return false


func _show_slot_selection() -> void:
	# Skip non-player and fully-upgraded fighters
	while _char_index < _party.size():
		var fighter: FighterData = _party[_char_index]
		if fighter.is_user_controlled and _has_upgradeable(fighter):
			break
		_char_index += 1

	if _char_index >= _party.size():
		phase_finished.emit()
		return

	var fighter: FighterData = _party[_char_index]
	var options: Array[Dictionary] = []
	_equip_slot_indices.clear()

	for i: int in fighter.equipment.size():
		var equip: EquipmentData = fighter.equipment[i]
		var label: String = "%s (%s)" % [equip.display_name, equip.get_bonus_text()]
		if equip.upgrade_level >= 1:
			label += "  [Upgraded]"
			options.append({"label": label, "disabled": true})
		else:
			options.append({"label": label})
		_equip_slot_indices.append(i)

	var header: String = "Select equipment for %s:" % fighter.character_name
	choices_requested.emit(options, header)


func on_slot_selected(index: int) -> void:
	if index < 0 or index >= _equip_slot_indices.size():
		return

	var fighter: FighterData = _party[_char_index]
	var equip_idx: int = _equip_slot_indices[index]
	_selected_equip = fighter.equipment[equip_idx]

	if _selected_equip.upgrade_level >= 1:
		return  # Shouldn't happen with disabled options

	# Show upgrade options for this piece
	_upgrade_options = EquipmentDB.get_upgrade_options(_selected_equip)
	_upgrade_option_ids.clear()
	var options: Array[Dictionary] = []
	for opt: Dictionary in _upgrade_options:
		_upgrade_option_ids.append(opt.id)
		options.append({"label": opt.label, "description": opt.description})

	var header: String = "Select %s:" % _selected_equip.get_slot_name()
	choices_requested.emit(options, header)


func on_upgrade_selected(index: int) -> void:
	if index < 0 or index >= _upgrade_option_ids.size():
		return

	var fighter: FighterData = _party[_char_index]
	var choice_id: String = _upgrade_option_ids[index]
	var slot_name: String = _selected_equip.get_slot_name()
	EquipmentDB.apply_upgrade(_selected_equip, fighter, choice_id)

	upgrade_complete.emit(_char_index, slot_name, _selected_equip.display_name)

	# Move to next character
	_char_index += 1
	_selected_equip = null
	_show_slot_selection()


## Returns the current selection sub-phase: "slot" or "upgrade".
func get_sub_phase() -> String:
	if _selected_equip != null:
		return "upgrade"
	return "slot"


func get_current_char_index() -> int:
	return _char_index


func _has_upgradeable(fighter: FighterData) -> bool:
	for equip: EquipmentData in fighter.equipment:
		if equip.upgrade_level < 1:
			return true
	return false
