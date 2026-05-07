class_name TownUltimateHandler extends Control

## Self-contained ultimate ability selection phase for town stops.
## Eligible fighters: T2, all 3 equipment slots upgraded, no ultimate yet.
## Only offered at designated stop-4 battles (after all equipment upgrades).

const DialoguePanel := preload("res://scripts/ui/dialogue_panel.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const TipOverlay := preload("res://scripts/ui/tip_overlay.gd")
const ReadyGate := preload("res://scripts/ui/ready_gate.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")
const UltimateDB := preload("res://scripts/data/ultimate_db.gd")

signal phase_finished

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
var _ult_options: Array = []

var _dialogue: DialoguePanel
var _choice_menu: ChoiceMenu
var _header_label: Label
var _tip_overlay: TipOverlay
var _ready_gate: ReadyGate
var _player_indicator: Label


func _init(params: Dictionary) -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_party = params.get("party", [])
	_battle_id = params.get("battle_id", "")


func _ready() -> void:
	_build_ui()
	_start()


func _build_ui() -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 80)
	margin.add_theme_constant_override("margin_right", 80)
	margin.add_theme_constant_override("margin_top", 60)
	margin.add_theme_constant_override("margin_bottom", 20)
	add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(vbox)

	_dialogue = DialoguePanel.new()
	_dialogue.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_dialogue.all_text_finished.connect(_on_text_finished)
	_dialogue.visible = false
	vbox.add_child(_dialogue)

	_header_label = Label.new()
	_header_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_header_label.add_theme_font_size_override("font_size", 28)
	_header_label.visible = false
	vbox.add_child(_header_label)

	_choice_menu = ChoiceMenu.new()
	_choice_menu.visible = false
	_choice_menu.choice_selected.connect(_on_choice_selected)
	vbox.add_child(_choice_menu)

	_ready_gate = ReadyGate.new()
	_ready_gate.visible = false
	_ready_gate.all_ready.connect(_on_all_ready)
	vbox.add_child(_ready_gate)

	_tip_overlay = TipOverlay.new()
	add_child(_tip_overlay)

	_player_indicator = Label.new()
	_player_indicator.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_player_indicator.add_theme_font_size_override("font_size", 22)
	_player_indicator.add_theme_color_override("font_color", Color(0.3, 0.9, 0.5))
	_player_indicator.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_player_indicator.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_player_indicator.offset_left = -200
	_player_indicator.offset_right = 200
	_player_indicator.offset_top = 16
	_player_indicator.visible = false
	add_child(_player_indicator)


func _start() -> void:
	_char_index = 0
	if _battle_id not in _ULTIMATE_STOPS or not _any_eligible():
		phase_finished.emit()
		return
	_dialogue.visible = true
	_dialogue.show_text(_get_narration_text())


func _on_text_finished() -> void:
	if LocalCoop.is_active:
		_ready_gate.start_local(LocalCoop.player_count)
		return
	_dialogue.visible = false
	_show_ultimate_selection()


func _on_all_ready() -> void:
	_dialogue.visible = false
	_show_ultimate_selection()


func _on_choice_selected(index: int) -> void:
	if index < 0 or index >= _ult_options.size():
		return

	var fighter: FighterData = _party[_char_index]
	var chosen: RefCounted = _ult_options[index]
	fighter.ultimate = chosen
	fighter.ultimate_charge = 0
	GameLog.info("Ultimate: selected %s" % chosen.ultimate_name)

	if LocalCoop.is_active:
		LocalCoop.clear_active_player()
		_player_indicator.visible = false

	_char_index += 1
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
		_choice_menu.hide_menu()
		_header_label.visible = false
		_player_indicator.visible = false
		phase_finished.emit()
		return

	var fighter: FighterData = _party[_char_index]
	_ult_options = UltimateDB.get_ultimates_for_class(fighter.class_id)

	if LocalCoop.is_active:
		var owner: int = LocalCoop.get_player_for_slot(_char_index)
		LocalCoop.set_active_player(owner)
		_player_indicator.text = "Player %d" % (owner + 1)
		_player_indicator.visible = true

	var options: Array[Dictionary] = []
	for ult: RefCounted in _ult_options:
		options.append({
			"label": ult.ultimate_name,
			"description": ult.description,
		})

	_header_label.text = "Choose an ultimate for %s the %s:" % [
		fighter.character_name, fighter.character_type]
	_header_label.visible = true
	_choice_menu.show_choices(options)


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
