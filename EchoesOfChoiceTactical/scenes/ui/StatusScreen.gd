class_name StatusScreen extends Control

signal status_closed

var _selected_name: String = ""
var _member_list: VBoxContainer
var _detail_panel: VBoxContainer


func _ready() -> void:
	_build_ui()
	_select_member(GameState.player_name)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
		status_closed.emit()
		get_viewport().set_input_as_handled()


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.0, 0.0, 0.0, 0.85)
	bg.set_anchors_preset(PRESET_FULL_RECT)
	add_child(bg)

	var panel := PanelContainer.new()
	panel.set_anchors_preset(PRESET_FULL_RECT)
	panel.offset_left = 40
	panel.offset_top = 30
	panel.offset_right = -40
	panel.offset_bottom = -30
	add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	margin.add_child(vbox)

	# Header
	var header := HBoxContainer.new()
	var title := Label.new()
	title.text = "Party Status"
	title.add_theme_font_size_override("font_size", 22)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)

	var close_btn := Button.new()
	close_btn.text = "Close"
	close_btn.custom_minimum_size = Vector2(80, 30)
	close_btn.pressed.connect(func():
		SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
		status_closed.emit()
	)
	header.add_child(close_btn)
	vbox.add_child(header)

	vbox.add_child(HSeparator.new())

	# Content: left member list + right detail
	var content := HBoxContainer.new()
	content.add_theme_constant_override("separation", 16)
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(content)

	var left_scroll := ScrollContainer.new()
	left_scroll.custom_minimum_size = Vector2(200, 0)
	content.add_child(left_scroll)

	_member_list = VBoxContainer.new()
	_member_list.add_theme_constant_override("separation", 4)
	left_scroll.add_child(_member_list)

	_populate_member_list()

	var detail_scroll := ScrollContainer.new()
	detail_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(detail_scroll)

	_detail_panel = VBoxContainer.new()
	_detail_panel.add_theme_constant_override("separation", 4)
	detail_scroll.add_child(_detail_panel)


func _populate_member_list() -> void:
	for child in _member_list.get_children():
		child.queue_free()
	_add_member_button(GameState.player_name, GameState.player_class_id, GameState.player_level, true)
	for member in GameState.party_members:
		_add_member_button(member["name"], member["class_id"], member.get("level", 1), false)


func _add_member_button(unit_name: String, class_id: String, level: int, is_leader: bool) -> void:
	var btn := Button.new()
	var text := "%s\n%s Lv%d" % [unit_name, class_id.capitalize(), level]
	if is_leader:
		text += " *"
	btn.text = text
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.custom_minimum_size = Vector2(180, 40)
	btn.pressed.connect(_select_member.bind(unit_name))
	_member_list.add_child(btn)


func _select_member(unit_name: String) -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_selected_name = unit_name
	_show_member_detail(unit_name)


func _show_member_detail(unit_name: String) -> void:
	for child in _detail_panel.get_children():
		child.queue_free()

	var class_id: String
	var level: int
	var xp: int
	var jp: int
	if unit_name == GameState.player_name:
		class_id = GameState.player_class_id
		level = GameState.player_level
		xp = GameState.player_xp
		jp = GameState.player_jp
	else:
		class_id = ""
		level = 1
		xp = 0
		jp = 0
		for member in GameState.party_members:
			if member["name"] == unit_name:
				class_id = member["class_id"]
				level = member.get("level", 1)
				xp = member.get("xp", 0)
				jp = member.get("jp", 0)
				break

	if class_id.is_empty():
		return
	var data: FighterData = BattleConfig.load_class(class_id)
	if not data:
		return
	var stats := data.get_stats_at_level(level)

	# Title
	var title := Label.new()
	title.text = "%s — %s" % [unit_name, data.class_display_name]
	title.add_theme_font_size_override("font_size", 18)
	_detail_panel.add_child(title)

	var tier_names := ["Base", "Tier 1", "Tier 2"]
	var info := Label.new()
	info.text = "%s  |  [%s]  |  Level %d" % [tier_names[clampi(data.tier, 0, 2)], data.get_role_tag(), level]
	info.add_theme_font_size_override("font_size", 13)
	info.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	_detail_panel.add_child(info)

	_detail_panel.add_child(HSeparator.new())

	# XP / JP progress
	var xp_needed := XpConfig.xp_to_next_level(level)
	_add_progress_row("XP", xp, xp_needed, Color(0.3, 0.6, 1.0))

	var jp_threshold := GameState.get_jp_threshold(data.tier)
	if jp_threshold > 0:
		_add_progress_row("JP", jp, jp_threshold, Color(0.9, 0.7, 0.2))
	else:
		var jp_lbl := Label.new()
		jp_lbl.text = "JP: %d (Max Tier)" % jp
		jp_lbl.add_theme_font_size_override("font_size", 12)
		jp_lbl.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		_detail_panel.add_child(jp_lbl)

	_detail_panel.add_child(HSeparator.new())

	# Stats grid (2 columns of name+value)
	var equip_bonuses := _get_equipment_bonuses(unit_name)
	var stat_entries := [
		["HP", "max_health"], ["MP", "max_mana"],
		["P.Atk", "physical_attack"], ["P.Def", "physical_defense"],
		["M.Atk", "magic_attack"], ["M.Def", "magic_defense"],
		["Speed", "speed"], ["Crit%", "crit_chance"],
		["CritDmg", "crit_damage"], ["Dodge", "dodge_chance"],
		["Move", "movement"], ["Jump", "jump"],
	]

	var grid := GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 2)

	for entry in stat_entries:
		var sname := Label.new()
		sname.text = entry[0]
		sname.custom_minimum_size = Vector2(50, 0)
		sname.add_theme_font_size_override("font_size", 12)
		sname.add_theme_color_override("font_color", Color(0.6, 0.7, 0.8))
		grid.add_child(sname)

		var base_val: int = stats.get(entry[1], 0)
		var bonus: int = equip_bonuses.get(entry[1], 0)
		var sval := Label.new()
		if bonus > 0:
			sval.text = "%d (+%d)" % [base_val, bonus]
			sval.add_theme_color_override("font_color", Color(0.5, 0.9, 0.5))
		else:
			sval.text = str(base_val)
		sval.custom_minimum_size = Vector2(80, 0)
		sval.add_theme_font_size_override("font_size", 12)
		grid.add_child(sval)
	_detail_panel.add_child(grid)

	# Current HP/MP
	var hp_mp := GameState.get_tracked_hp_mp(unit_name)
	if hp_mp["hp"] >= 0:
		var hp_cur := Label.new()
		hp_cur.text = "HP: %d/%d  |  MP: %d/%d" % [hp_mp["hp"], stats["max_health"], hp_mp["mp"], stats["max_mana"]]
		hp_cur.add_theme_font_size_override("font_size", 12)
		hp_cur.add_theme_color_override("font_color", Color(0.5, 0.8, 0.5))
		_detail_panel.add_child(hp_cur)

	_detail_panel.add_child(HSeparator.new())
	_add_equipment_section(unit_name)
	_detail_panel.add_child(HSeparator.new())
	_add_abilities_section(data)
	_add_reactions_section(data)


func _add_progress_row(label_text: String, current: int, total: int, bar_color: Color) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)

	var lbl := Label.new()
	lbl.text = "%s:" % label_text
	lbl.custom_minimum_size = Vector2(30, 0)
	lbl.add_theme_font_size_override("font_size", 13)
	row.add_child(lbl)

	var bar := ProgressBar.new()
	bar.custom_minimum_size = Vector2(150, 16)
	bar.min_value = 0
	bar.max_value = maxi(total, 1)
	bar.value = mini(current, total)
	bar.show_percentage = false
	var bar_style := StyleBoxFlat.new()
	bar_style.bg_color = bar_color
	bar.add_theme_stylebox_override("fill", bar_style)
	row.add_child(bar)

	var val_lbl := Label.new()
	val_lbl.text = "%d / %d" % [current, total]
	val_lbl.add_theme_font_size_override("font_size", 12)
	row.add_child(val_lbl)

	_detail_panel.add_child(row)


func _add_equipment_section(unit_name: String) -> void:
	var title := Label.new()
	title.text = "Equipment"
	title.add_theme_font_size_override("font_size", 15)
	_detail_panel.add_child(title)

	var equipped := GameState.get_all_equipped(unit_name)
	var max_slots := GameState.get_max_slots(unit_name)

	if equipped.is_empty():
		var none := Label.new()
		none.text = "(No equipment)"
		none.add_theme_font_size_override("font_size", 12)
		none.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		_detail_panel.add_child(none)
	else:
		for item_id in equipped:
			var item := GameState.get_item_resource(item_id)
			if item:
				var item_lbl := Label.new()
				item_lbl.text = "  %s  %s" % [item.display_name, item.get_stat_summary()]
				item_lbl.add_theme_font_size_override("font_size", 12)
				_detail_panel.add_child(item_lbl)

	var slot_lbl := Label.new()
	slot_lbl.text = "Slots: %d / %d" % [equipped.size(), max_slots]
	slot_lbl.add_theme_font_size_override("font_size", 11)
	slot_lbl.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	_detail_panel.add_child(slot_lbl)


func _add_abilities_section(data: FighterData) -> void:
	if data.abilities.is_empty():
		return
	var title := Label.new()
	title.text = "Abilities"
	title.add_theme_font_size_override("font_size", 15)
	_detail_panel.add_child(title)

	for ability in data.abilities:
		var lbl := Label.new()
		lbl.text = "  %s  (MP:%d  R:%d  %s)" % [ability.ability_name, ability.mana_cost, ability.ability_range, _ability_type_str(ability)]
		lbl.add_theme_font_size_override("font_size", 12)
		_detail_panel.add_child(lbl)

	_detail_panel.add_child(HSeparator.new())


func _add_reactions_section(data: FighterData) -> void:
	if data.reaction_types.is_empty():
		return
	var title := Label.new()
	title.text = "Reactions"
	title.add_theme_font_size_override("font_size", 15)
	_detail_panel.add_child(title)

	for rt in data.reaction_types:
		var lbl := Label.new()
		lbl.text = "  %s" % _reaction_name(rt)
		lbl.add_theme_font_size_override("font_size", 12)
		_detail_panel.add_child(lbl)


func _get_equipment_bonuses(unit_name: String) -> Dictionary:
	var bonuses: Dictionary = {}
	var equipped := GameState.get_all_equipped(unit_name)
	for item_id in equipped:
		var item := GameState.get_item_resource(item_id)
		if item and item.is_equipment():
			for stat_key in item.stat_bonuses:
				var mapped := _map_stat_key(stat_key)
				bonuses[mapped] = bonuses.get(mapped, 0) + int(item.stat_bonuses[stat_key])
	return bonuses


static func _map_stat_key(key) -> String:
	if key is int:
		match key:
			Enums.StatType.MAX_HEALTH: return "max_health"
			Enums.StatType.MAX_MANA: return "max_mana"
			Enums.StatType.PHYSICAL_ATTACK: return "physical_attack"
			Enums.StatType.PHYSICAL_DEFENSE: return "physical_defense"
			Enums.StatType.MAGIC_ATTACK: return "magic_attack"
			Enums.StatType.MAGIC_DEFENSE: return "magic_defense"
			Enums.StatType.SPEED: return "speed"
			Enums.StatType.CRIT_CHANCE: return "crit_chance"
			Enums.StatType.CRIT_DAMAGE: return "crit_damage"
			Enums.StatType.DODGE_CHANCE: return "dodge_chance"
			Enums.StatType.MOVEMENT: return "movement"
			Enums.StatType.JUMP: return "jump"
	return str(key)


static func _ability_type_str(ability: AbilityData) -> String:
	match ability.ability_type:
		Enums.AbilityType.DAMAGE: return "Dmg"
		Enums.AbilityType.HEAL: return "Heal"
		Enums.AbilityType.BUFF: return "Buff"
		Enums.AbilityType.DEBUFF: return "Debuff"
		Enums.AbilityType.TERRAIN: return "Terrain"
	return ""


static func _reaction_name(rt: Enums.ReactionType) -> String:
	match rt:
		Enums.ReactionType.OPPORTUNITY_ATTACK: return "Opportunity Attack"
		Enums.ReactionType.FLANKING_STRIKE: return "Flanking Strike"
		Enums.ReactionType.SNAP_SHOT: return "Snap Shot"
		Enums.ReactionType.REACTIVE_HEAL: return "Reactive Heal"
		Enums.ReactionType.DAMAGE_MITIGATION: return "Damage Mitigation"
		Enums.ReactionType.BODYGUARD: return "Bodyguard"
	return "Unknown"
