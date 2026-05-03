class_name TownUltimateHandler extends RefCounted

## Manages the ultimate ability selection phase at town stops.
## Delegated from town_stop.gd following the TownEquipmentHandler pattern.
## Eligible fighters: T2, all 3 equipment slots upgraded, no ultimate yet.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const UltimateDB := preload("res://scripts/data/ultimate_db.gd")

var _party: Array = []
var _char_index: int = 0
var _ult_options: Array = []  ## Array of UltimateData for current fighter

signal narration_requested(lines: Array)
signal choices_requested(options: Array, header: String)
signal selection_complete(char_index: int, ultimate_name: String)
signal phase_finished


func start(party: Array) -> void:
	_party = party
	_char_index = 0

	if not _any_eligible():
		phase_finished.emit()
		return

	var lines: Array[String] = [
		"Your party has grown strong. Each warrior now stands ready to unlock a powerful technique.",
		"Choose an ultimate ability for each companion. Once chosen, it cannot be changed.",
	]
	narration_requested.emit(lines)


func on_narration_done() -> void:
	_show_ultimate_selection()


func _any_eligible() -> bool:
	for fighter: FighterData in _party:
		if _is_eligible(fighter):
			return true
	return false


func _is_eligible(fighter: FighterData) -> bool:
	if not fighter.is_user_controlled:
		return false
	if fighter.ultimate != null:
		return false
	if fighter.equipment.size() < 3:
		return false
	for equip: RefCounted in fighter.equipment:
		if equip.upgrade_level < 1:
			return false
	var ults: Array = UltimateDB.get_ultimates_for_class(fighter.class_id)
	return not ults.is_empty()


func _show_ultimate_selection() -> void:
	while _char_index < _party.size():
		var fighter: FighterData = _party[_char_index]
		if _is_eligible(fighter):
			break
		_char_index += 1

	if _char_index >= _party.size():
		phase_finished.emit()
		return

	var fighter: FighterData = _party[_char_index]
	_ult_options = UltimateDB.get_ultimates_for_class(fighter.class_id)

	var options: Array[Dictionary] = []
	for ult: RefCounted in _ult_options:
		options.append({
			"label": ult.ultimate_name,
			"description": ult.description,
		})

	var header: String = "Choose an ultimate for %s the %s:" % [
		fighter.character_name, fighter.character_type]
	choices_requested.emit(options, header)


func on_choice_selected(index: int) -> void:
	if index < 0 or index >= _ult_options.size():
		return

	var fighter: FighterData = _party[_char_index]
	var chosen: RefCounted = _ult_options[index]
	fighter.ultimate = chosen
	fighter.ultimate_charge = 0

	selection_complete.emit(_char_index, chosen.ultimate_name)

	_char_index += 1
	_show_ultimate_selection()


func get_current_char_index() -> int:
	return _char_index
