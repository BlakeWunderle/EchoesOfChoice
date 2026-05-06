class_name TownUltimateHandler extends RefCounted

## Manages the ultimate ability selection phase at town stops.
## Delegated from town_stop.gd following the TownEquipmentHandler pattern.
## Eligible fighters: T2, all 3 equipment slots upgraded, no ultimate yet.
## Only offered at designated stop-4 battles (after all equipment upgrades).

const FighterData := preload("res://scripts/data/fighter_data.gd")
const UltimateDB := preload("res://scripts/data/ultimate_db.gd")

const _ULTIMATE_STOPS: Array[String] = [
	"TunnelCampStop",           # Story 1: post-Depths, barkeep's runner
	"S2_CoastalCamp",           # Story 2 Path A: post-Sera fight
	"S2_B_SafeHaven",           # Story 2 Path B: post-Sera fight
	"S3_TownRealization",       # Story 3 Path A
	"S3_B_CallumsTruth",        # Story 3 Path B
	"S3_C_LirasConfession",     # Story 3 Path C
]

var _party: Array = []
var _battle_id: String = ""
var _char_index: int = 0
var _ult_options: Array = []  ## Array of UltimateData for current fighter

signal narration_requested(lines: Array)
signal choices_requested(options: Array, header: String)
signal selection_complete(char_index: int, ultimate_name: String)
signal phase_finished


func start(party: Array, battle_id: String = "") -> void:
	_party = party
	_battle_id = battle_id
	_char_index = 0

	if battle_id not in _ULTIMATE_STOPS or not _any_eligible():
		phase_finished.emit()
		return

	narration_requested.emit(_get_narration_text())


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


func _get_narration_text() -> Array[String]:
	match _battle_id:
		"TunnelCampStop":
			return [
				"The barkeep's supplies are more than just provisions. They are proof that someone above still believes in the party. That faith settles into bone and muscle, quieting doubt, sharpening focus.",
				"Each companion reaches for something deeper. A technique held in reserve, waiting for the hour when nothing less would do.",
			]
		"S2_CoastalCamp":
			return [
				"Sera's recovered memories carry more than grief. They carry understanding. The Eye feeds on stolen lives, but it also reveals what those lives contained. Strength. Resilience. Purpose.",
				"That knowledge sparks something in the party. A final edge, sharpened by everything the coast has taken from them and everything they refuse to let it keep.",
			]
		"S2_B_SafeHaven":
			return [
				"Sera's clarity is contagious. Knowing the plan, knowing the failsafe exists, knowing that sacrifice is not the only option. It changes how the party holds their weapons.",
				"There is focus now where there was only grim resolve. Each companion finds a well of strength they did not know they had.",
			]
		"S3_TownRealization":
			return [
				"Lira's training goes deeper than technique. She teaches them to hold their awareness in the dream, to fight while sleeping, to trust instincts that the waking world would dismiss.",
				"Under her guidance, old limitations fall away. Each companion discovers a power that was always there, waiting for someone to show them how to reach it.",
			]
		"S3_B_CallumsTruth":
			return [
				"Callum's knowledge of the threads changes everything. Understanding the enemy reveals weaknesses that were invisible before. The party's strength reshapes itself around what they now know.",
				"Each companion finds new purpose in the fight ahead. The Threadmaster has been untouchable for centuries. That ends here.",
			]
		"S3_C_LirasConfession":
			return [
				"Lira's truth forges something between the party that was not there before. Not just trust, but a shared weight. She has carried this alone for centuries. She will not carry it alone tonight.",
				"The bond unlocks something deeper in each companion. A final reserve of strength, drawn from the knowledge that this path leads to the heart of the Loom itself.",
			]
		_:
			push_error("No ultimate narration for battle_id: %s" % _battle_id)
			return [
				"The journey has tested each companion to their limits. But limits, once reached, can be surpassed.",
				"Each warrior stands ready to unlock a powerful technique, forged from everything they have endured.",
			]
