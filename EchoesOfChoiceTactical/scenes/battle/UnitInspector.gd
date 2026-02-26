class_name UnitInspector extends PanelContainer

signal closed

const TYPE_NAMES := ["Damage", "Heal", "Buff", "Debuff", "Terrain"]
const AOE_NAMES := ["Single", "Line", "Cross", "Diamond", "Square", "Global"]
const REACTION_NAMES: Dictionary = {
	Enums.ReactionType.OPPORTUNITY_ATTACK: "Opportunity Attack",
	Enums.ReactionType.FLANKING_STRIKE: "Flanking Strike",
	Enums.ReactionType.SNAP_SHOT: "Snap Shot",
	Enums.ReactionType.REACTIVE_HEAL: "Reactive Heal",
	Enums.ReactionType.DAMAGE_MITIGATION: "Damage Mitigation",
	Enums.ReactionType.BODYGUARD: "Bodyguard",
}

var _vbox: VBoxContainer


func _ready() -> void:
	set_anchors_preset(Control.PRESET_CENTER)
	offset_left = -180.0
	offset_top = -220.0
	offset_right = 180.0
	offset_bottom = 220.0

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 10)
	add_child(margin)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(scroll)

	_vbox = VBoxContainer.new()
	_vbox.add_theme_constant_override("separation", 4)
	_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_vbox)


func show_unit(unit: Unit) -> void:
	_clear()
	_build_header(unit)
	_build_stats(unit)
	_build_abilities(unit)
	_build_reactions(unit)
	_build_status_effects(unit)
	visible = true


func _clear() -> void:
	for child in _vbox.get_children():
		child.queue_free()


func _build_header(unit: Unit) -> void:
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)
	_vbox.add_child(hbox)

	# Sprite icon
	var icon := TextureRect.new()
	icon.custom_minimum_size = Vector2(40, 40)
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	if unit.sprite and unit.sprite.sprite_frames and unit.sprite.sprite_frames.has_animation("idle_down"):
		icon.texture = unit.sprite.sprite_frames.get_frame_texture("idle_down", 0)
	hbox.add_child(icon)

	var info := VBoxContainer.new()
	hbox.add_child(info)

	var name_lbl := Label.new()
	name_lbl.text = unit.unit_name
	name_lbl.add_theme_font_size_override("font_size", 16)
	name_lbl.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	info.add_child(name_lbl)

	var is_player := unit.team == Enums.Team.PLAYER
	var team_text := "ALLY" if is_player else "ENEMY"
	var class_lbl := Label.new()
	class_lbl.text = "%s  %s Lv %d" % [unit.unit_class, team_text, unit.level]
	class_lbl.add_theme_font_size_override("font_size", 11)
	class_lbl.add_theme_color_override("font_color", Color(0.6, 0.6, 0.7))
	info.add_child(class_lbl)

	_vbox.add_child(HSeparator.new())


func _build_stats(unit: Unit) -> void:
	var grid_c := GridContainer.new()
	grid_c.columns = 4
	grid_c.add_theme_constant_override("h_separation", 8)
	grid_c.add_theme_constant_override("v_separation", 2)
	_vbox.add_child(grid_c)

	_add_stat_pair(grid_c, "HP", "%d/%d" % [unit.health, unit.max_health])
	_add_stat_pair(grid_c, "MP", "%d/%d" % [unit.mana, unit.max_mana])
	_add_stat_pair(grid_c, "P.Atk", str(unit.physical_attack))
	_add_stat_pair(grid_c, "P.Def", str(unit.physical_defense))
	_add_stat_pair(grid_c, "M.Atk", str(unit.magic_attack))
	_add_stat_pair(grid_c, "M.Def", str(unit.magic_defense))
	_add_stat_pair(grid_c, "Spd", str(unit.speed))
	_add_stat_pair(grid_c, "Mov", str(unit.movement))
	_add_stat_pair(grid_c, "Jump", str(unit.jump))
	_add_stat_pair(grid_c, "Crit", "%d%%" % (unit.crit_chance * 10))
	_add_stat_pair(grid_c, "Dodge", "%d%%" % (unit.dodge_chance * 10))
	# Empty pair for alignment
	_add_stat_pair(grid_c, "", "")

	_vbox.add_child(HSeparator.new())


func _add_stat_pair(container: GridContainer, stat_name: String, stat_val: String) -> void:
	var lbl_name := Label.new()
	lbl_name.text = stat_name
	lbl_name.add_theme_font_size_override("font_size", 11)
	lbl_name.add_theme_color_override("font_color", Color(0.6, 0.7, 0.8))
	lbl_name.custom_minimum_size = Vector2(40, 0)
	container.add_child(lbl_name)

	var lbl_val := Label.new()
	lbl_val.text = stat_val
	lbl_val.add_theme_font_size_override("font_size", 11)
	lbl_val.custom_minimum_size = Vector2(50, 0)
	container.add_child(lbl_val)


func _build_abilities(unit: Unit) -> void:
	var title := Label.new()
	title.text = "Abilities"
	title.add_theme_font_size_override("font_size", 13)
	title.add_theme_color_override("font_color", Color(0.8, 0.7, 0.5))
	_vbox.add_child(title)

	for ability in unit.abilities:
		var lbl := Label.new()
		var parts: Array[String] = [ability.ability_name]
		parts.append(TYPE_NAMES[ability.ability_type])
		if ability.ability_range > 1:
			parts.append("R:%d" % ability.ability_range)
		if ability.mana_cost > 0:
			parts.append("%dMP" % ability.mana_cost)
		if ability.aoe_shape != Enums.AoEShape.SINGLE:
			parts.append("%s%d" % [AOE_NAMES[ability.aoe_shape], ability.aoe_size])
		lbl.text = "  %s (%s)" % [parts[0], ", ".join(parts.slice(1))]
		lbl.add_theme_font_size_override("font_size", 10)
		lbl.add_theme_color_override("font_color", Color(0.75, 0.75, 0.75))
		_vbox.add_child(lbl)

	_vbox.add_child(HSeparator.new())


func _build_reactions(unit: Unit) -> void:
	if unit.reaction_types.is_empty():
		return
	var title := Label.new()
	title.text = "Reactions"
	title.add_theme_font_size_override("font_size", 13)
	title.add_theme_color_override("font_color", Color(0.8, 0.7, 0.5))
	_vbox.add_child(title)

	for rt in unit.reaction_types:
		var lbl := Label.new()
		lbl.text = "  %s" % REACTION_NAMES.get(rt, "Unknown")
		lbl.add_theme_font_size_override("font_size", 10)
		var avail_color := Color(0.75, 0.75, 0.75) if unit.has_reaction else Color(0.5, 0.4, 0.4)
		lbl.add_theme_color_override("font_color", avail_color)
		_vbox.add_child(lbl)

	_vbox.add_child(HSeparator.new())


func _build_status_effects(unit: Unit) -> void:
	if unit.modified_stats.is_empty():
		return
	var title := Label.new()
	title.text = "Status Effects"
	title.add_theme_font_size_override("font_size", 13)
	title.add_theme_color_override("font_color", Color(0.8, 0.7, 0.5))
	_vbox.add_child(title)

	for ms in unit.modified_stats:
		var lbl := Label.new()
		var stat_name := DamagePreview._stat_short_name(ms.stat)
		var sign_str := "+" if not ms.is_negative else "-"
		lbl.text = "  %s%d %s (%d turns)" % [sign_str, ms.modifier, stat_name, ms.turns_remaining]
		lbl.add_theme_font_size_override("font_size", 10)
		lbl.add_theme_color_override("font_color", Color(0.3, 0.9, 0.4) if not ms.is_negative else Color(0.9, 0.4, 0.3))
		_vbox.add_child(lbl)


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_TAB or event.keycode == KEY_ESCAPE:
			visible = false
			closed.emit()
			get_viewport().set_input_as_handled()
