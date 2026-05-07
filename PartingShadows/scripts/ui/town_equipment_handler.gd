class_name TownEquipmentHandler extends Control

## Self-contained equipment upgrade phase for town stops.
## Shows slot selection and upgrade options per character.

const DialoguePanel := preload("res://scripts/ui/dialogue_panel.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const TipOverlay := preload("res://scripts/ui/tip_overlay.gd")
const ReadyGate := preload("res://scripts/ui/ready_gate.gd")
const EquipmentDB := preload("res://scripts/data/equipment_db.gd")
const EquipmentData := preload("res://scripts/data/equipment_data.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")

signal phase_finished

var _party: Array = []
var _story_id: String = ""
var _char_index: int = 0
var _upgrade_options: Array[Dictionary] = []
var _upgrade_option_ids: Array[String] = []
var _selected_equip: EquipmentData = null
var _equip_slot_indices: Array[int] = []
var _sub_phase: String = "slot"

var _dialogue: DialoguePanel
var _choice_menu: ChoiceMenu
var _header_label: Label
var _tip_overlay: TipOverlay
var _ready_gate: ReadyGate
var _player_indicator: Label


func _init(params: Dictionary) -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_party = params.get("party", [])
	_story_id = params.get("story_id", "")


func _ready() -> void:
	_build_ui()
	_start()


func _build_ui() -> void:
	var margin := MarginContainer.new()
	margin.anchor_left = 0.0
	margin.anchor_top = 0.0
	margin.anchor_right = 1.0
	margin.anchor_bottom = 0.5
	margin.clip_contents = true
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
	if not _any_upgradeable():
		phase_finished.emit()
		return
	var lines: Array[String] = EquipmentDB.get_upgrade_text(_story_id)
	_dialogue.visible = true
	_dialogue.show_text(lines)


func _on_text_finished() -> void:
	if LocalCoop.is_active:
		_ready_gate.start_local(LocalCoop.player_count)
		return
	_dialogue.visible = false
	_show_slot_selection()


func _on_all_ready() -> void:
	_dialogue.visible = false
	_show_slot_selection()


func _on_choice_selected(index: int) -> void:
	if _sub_phase == "slot":
		_on_slot_selected(index)
	else:
		_on_upgrade_selected(index)


func _any_upgradeable() -> bool:
	for fighter: FighterData in _party:
		if not fighter.is_user_controlled:
			continue
		for equip: EquipmentData in fighter.equipment:
			if equip.upgrade_level < 1:
				return true
	return false


func _show_slot_selection() -> void:
	while _char_index < _party.size():
		var fighter: FighterData = _party[_char_index]
		if fighter.is_user_controlled and _has_upgradeable(fighter):
			break
		_char_index += 1

	if _char_index >= _party.size():
		_choice_menu.hide_menu()
		_header_label.visible = false
		_player_indicator.visible = false
		phase_finished.emit()
		return

	var fighter: FighterData = _party[_char_index]
	_sub_phase = "slot"

	if LocalCoop.is_active:
		var owner: int = LocalCoop.get_player_for_slot(_char_index)
		LocalCoop.set_active_player(owner)
		_player_indicator.text = "Player %d" % (owner + 1)
		_player_indicator.visible = true

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

	_header_label.text = "Select equipment for %s:" % fighter.character_name
	_header_label.visible = true
	_choice_menu.show_choices(options)


func _on_slot_selected(index: int) -> void:
	if index < 0 or index >= _equip_slot_indices.size():
		return

	var fighter: FighterData = _party[_char_index]
	var equip_idx: int = _equip_slot_indices[index]
	_selected_equip = fighter.equipment[equip_idx]

	if _selected_equip.upgrade_level >= 1:
		return

	_upgrade_options = EquipmentDB.get_upgrade_options(_selected_equip)
	_upgrade_option_ids.clear()
	var options: Array[Dictionary] = []
	for opt: Dictionary in _upgrade_options:
		_upgrade_option_ids.append(opt.id)
		options.append({"label": opt.label, "description": opt.description})

	_sub_phase = "upgrade"
	_header_label.text = "Select %s:" % _selected_equip.get_slot_name()
	_header_label.visible = true
	_choice_menu.show_choices(options)


func _on_upgrade_selected(index: int) -> void:
	if index < 0 or index >= _upgrade_option_ids.size():
		return

	var fighter: FighterData = _party[_char_index]
	var choice_id: String = _upgrade_option_ids[index]
	var slot_name: String = _selected_equip.get_slot_name()
	EquipmentDB.apply_upgrade(_selected_equip, fighter, choice_id)
	GameLog.info("Equipment: upgraded %s (%s)" % [_selected_equip.display_name, slot_name])

	if LocalCoop.is_active:
		LocalCoop.clear_active_player()
		_player_indicator.visible = false

	_char_index += 1
	_selected_equip = null
	_show_slot_selection()


func _has_upgradeable(fighter: FighterData) -> bool:
	for equip: EquipmentData in fighter.equipment:
		if equip.upgrade_level < 1:
			return true
	return false
