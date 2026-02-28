class_name CursorInfoPanel extends PanelContainer

const BUFF_COLOR := Color(0.2, 0.7, 0.3)
const DEBUFF_COLOR := Color(0.8, 0.2, 0.3)
const PLAYER_NAME_COLOR := Color(0.7, 0.85, 1.0)
const ENEMY_NAME_COLOR := Color(1.0, 0.75, 0.7)
const PLAYER_HP_COLOR := Color(0.25, 0.55, 0.9)
const ENEMY_HP_COLOR := Color(0.85, 0.25, 0.25)
const DIM_TEXT := Color(0.5, 0.5, 0.55)

const STAT_LETTERS: Dictionary = {
	Enums.StatType.PHYSICAL_ATTACK: "P.Atk",
	Enums.StatType.PHYSICAL_DEFENSE: "P.Def",
	Enums.StatType.MAGIC_ATTACK: "M.Atk",
	Enums.StatType.MAGIC_DEFENSE: "M.Def",
	Enums.StatType.ATTACK: "ATK",
	Enums.StatType.DEFENSE: "DEF",
	Enums.StatType.MIXED_ATTACK: "MixAtk",
	Enums.StatType.SPEED: "SPD",
	Enums.StatType.DODGE_CHANCE: "Dodge",
}

const REACTION_COLORS: Dictionary = {
	Enums.ReactionType.OPPORTUNITY_ATTACK: Color(0.9, 0.4, 0.2),
	Enums.ReactionType.FLANKING_STRIKE: Color(0.9, 0.8, 0.2),
	Enums.ReactionType.SNAP_SHOT: Color(0.3, 0.8, 0.9),
	Enums.ReactionType.REACTIVE_HEAL: Color(0.3, 0.9, 0.4),
	Enums.ReactionType.DAMAGE_MITIGATION: Color(0.5, 0.6, 0.8),
	Enums.ReactionType.BODYGUARD: Color(0.8, 0.65, 0.3),
}

const REACTION_NAMES: Dictionary = {
	Enums.ReactionType.OPPORTUNITY_ATTACK: "Opportunity",
	Enums.ReactionType.FLANKING_STRIKE: "Flanking",
	Enums.ReactionType.SNAP_SHOT: "Snap Shot",
	Enums.ReactionType.REACTIVE_HEAL: "Heal",
	Enums.ReactionType.DAMAGE_MITIGATION: "Mitigate",
	Enums.ReactionType.BODYGUARD: "Bodyguard",
}

var _icon: TextureRect
var _name_label: Label
var _class_label: Label
var _hp_bar: ProgressBar
var _hp_label: Label
var _mp_label: Label
var _status_container: HBoxContainer
var _reaction_container: HBoxContainer
var _status_row: HBoxContainer
var _reaction_row: HBoxContainer
var _content: VBoxContainer
var _current_unit: Unit = null


func _ready() -> void:
	# Anchor bottom-left
	set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	offset_left = 10.0
	offset_bottom = -10.0
	offset_right = 310.0
	offset_top = -160.0
	grow_vertical = Control.GROW_DIRECTION_BEGIN

	_build_ui()
	visible = false


func _build_ui() -> void:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 6)
	add_child(margin)

	_content = VBoxContainer.new()
	_content.add_theme_constant_override("separation", 4)
	margin.add_child(_content)

	# Row 1: icon + name + class
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	_content.add_child(header)

	_icon = TextureRect.new()
	_icon.custom_minimum_size = Vector2(32, 32)
	_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	header.add_child(_icon)

	var name_col := VBoxContainer.new()
	name_col.add_theme_constant_override("separation", 0)
	header.add_child(name_col)

	_name_label = Label.new()
	_name_label.add_theme_font_size_override("font_size", 14)
	name_col.add_child(_name_label)

	_class_label = Label.new()
	_class_label.add_theme_font_size_override("font_size", 10)
	_class_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.7))
	name_col.add_child(_class_label)

	# Row 2: HP bar + MP
	var hp_row := HBoxContainer.new()
	hp_row.add_theme_constant_override("separation", 8)
	_content.add_child(hp_row)

	var hp_label_prefix := Label.new()
	hp_label_prefix.text = "HP"
	hp_label_prefix.add_theme_font_size_override("font_size", 10)
	hp_label_prefix.add_theme_color_override("font_color", Color(0.6, 0.7, 0.8))
	hp_row.add_child(hp_label_prefix)

	_hp_bar = ProgressBar.new()
	_hp_bar.custom_minimum_size = Vector2(100, 10)
	_hp_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_hp_bar.show_percentage = false
	_hp_bar.value = 100.0
	hp_row.add_child(_hp_bar)

	_hp_label = Label.new()
	_hp_label.add_theme_font_size_override("font_size", 10)
	_hp_label.custom_minimum_size = Vector2(60, 0)
	hp_row.add_child(_hp_label)

	var mp_prefix := Label.new()
	mp_prefix.text = "MP"
	mp_prefix.add_theme_font_size_override("font_size", 10)
	mp_prefix.add_theme_color_override("font_color", Color(0.5, 0.6, 0.8))
	hp_row.add_child(mp_prefix)

	_mp_label = Label.new()
	_mp_label.add_theme_font_size_override("font_size", 10)
	_mp_label.custom_minimum_size = Vector2(40, 0)
	hp_row.add_child(_mp_label)

	# Row 3: status effects
	_status_row = HBoxContainer.new()
	_status_row.add_theme_constant_override("separation", 4)
	_content.add_child(_status_row)

	var status_prefix := Label.new()
	status_prefix.text = "Status:"
	status_prefix.add_theme_font_size_override("font_size", 10)
	status_prefix.add_theme_color_override("font_color", Color(0.6, 0.6, 0.7))
	_status_row.add_child(status_prefix)

	_status_container = HBoxContainer.new()
	_status_container.add_theme_constant_override("separation", 6)
	_status_row.add_child(_status_container)

	# Row 4: reactions
	_reaction_row = HBoxContainer.new()
	_reaction_row.add_theme_constant_override("separation", 4)
	_content.add_child(_reaction_row)

	var react_prefix := Label.new()
	react_prefix.text = "React:"
	react_prefix.add_theme_font_size_override("font_size", 10)
	react_prefix.add_theme_color_override("font_color", Color(0.6, 0.6, 0.7))
	_reaction_row.add_child(react_prefix)

	_reaction_container = HBoxContainer.new()
	_reaction_container.add_theme_constant_override("separation", 4)
	_reaction_row.add_child(_reaction_container)


func show_unit(unit: Unit) -> void:
	_current_unit = unit
	visible = true

	# Header
	var tex := _get_unit_icon(unit)
	_icon.texture = tex

	var is_player := unit.team == Enums.Team.PLAYER
	_name_label.text = unit.unit_name
	_name_label.add_theme_color_override("font_color", PLAYER_NAME_COLOR if is_player else ENEMY_NAME_COLOR)

	var team_text := "ALLY" if is_player else "ENEMY"
	_class_label.text = "%s  %s  Lv %d" % [unit.unit_class, team_text, unit.level]

	# HP
	var hp_pct := 0.0
	if unit.max_health > 0:
		hp_pct = float(unit.health) / float(unit.max_health) * 100.0
	_hp_bar.value = hp_pct
	_hp_label.text = "%d/%d" % [unit.health, unit.max_health]

	var fill_color := PLAYER_HP_COLOR if is_player else ENEMY_HP_COLOR
	var fill_style := StyleBoxFlat.new()
	fill_style.bg_color = fill_color
	fill_style.set_corner_radius_all(2)
	_hp_bar.add_theme_stylebox_override("fill", fill_style)

	# MP
	_mp_label.text = "%d/%d" % [unit.mana, unit.max_mana]

	# Status effects
	_refresh_status(unit)

	# Reactions
	_refresh_reactions(unit)


func refresh_current() -> void:
	if _current_unit and _current_unit.is_alive:
		show_unit(_current_unit)


func clear() -> void:
	_current_unit = null
	visible = false


func _refresh_status(unit: Unit) -> void:
	for child in _status_container.get_children():
		child.queue_free()

	if unit.modified_stats.is_empty():
		_status_row.visible = false
		return
	_status_row.visible = true

	for ms in unit.modified_stats:
		var lbl := Label.new()
		var stat_name: String = STAT_LETTERS.get(ms.stat, "?")
		var sign_str := "+" if not ms.is_negative else "-"
		lbl.text = "%s%d %s (%dt)" % [sign_str, ms.modifier, stat_name, ms.turns_remaining]
		lbl.add_theme_font_size_override("font_size", 10)
		lbl.add_theme_color_override("font_color", BUFF_COLOR if not ms.is_negative else DEBUFF_COLOR)
		_status_container.add_child(lbl)


func _refresh_reactions(unit: Unit) -> void:
	for child in _reaction_container.get_children():
		child.queue_free()

	if unit.reaction_types.is_empty():
		_reaction_row.visible = false
		return
	_reaction_row.visible = true

	for rt in unit.reaction_types:
		var badge := Label.new()
		badge.text = " %s " % REACTION_NAMES.get(rt, "?")
		badge.add_theme_font_size_override("font_size", 9)
		var color: Color = REACTION_COLORS.get(rt, Color.GRAY)
		if not unit.has_reaction:
			color = color.darkened(0.5)
			badge.add_theme_color_override("font_color", DIM_TEXT)
		else:
			badge.add_theme_color_override("font_color", Color.WHITE)

		var bg := StyleBoxFlat.new()
		bg.bg_color = color
		bg.set_corner_radius_all(3)
		bg.content_margin_left = 4
		bg.content_margin_right = 4
		bg.content_margin_top = 1
		bg.content_margin_bottom = 1
		badge.add_theme_stylebox_override("normal", bg)
		_reaction_container.add_child(badge)

	if not unit.has_reaction:
		var used_lbl := Label.new()
		used_lbl.text = "(used)"
		used_lbl.add_theme_font_size_override("font_size", 9)
		used_lbl.add_theme_color_override("font_color", DIM_TEXT)
		_reaction_container.add_child(used_lbl)


func _get_unit_icon(unit: Unit) -> Texture2D:
	if unit.sprite and unit.sprite.sprite_frames:
		if unit.sprite.sprite_frames.has_animation("idle_down"):
			return unit.sprite.sprite_frames.get_frame_texture("idle_down", 0)
		var anims := unit.sprite.sprite_frames.get_animation_names()
		if anims.size() > 0:
			return unit.sprite.sprite_frames.get_frame_texture(anims[0], 0)
	return null
