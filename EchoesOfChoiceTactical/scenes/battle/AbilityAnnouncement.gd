class_name AbilityAnnouncement extends PanelContainer

const SLIDE_DURATION := 0.15
const HOLD_DURATION := 0.4
const FADE_DURATION := 0.2

const COLOR_DAMAGE := Color(1.0, 0.4, 0.3)
const COLOR_HEAL := Color(0.4, 1.0, 0.5)
const COLOR_BUFF := Color(0.4, 0.8, 1.0)
const COLOR_DEBUFF := Color(0.9, 0.4, 0.9)
const COLOR_TERRAIN := Color(0.9, 0.8, 0.5)
const COLOR_PLAYER := Color(0.5, 0.7, 1.0)
const COLOR_ENEMY := Color(1.0, 0.5, 0.4)
const COLOR_VERB := Color(0.55, 0.52, 0.48)


static func announce(parent: CanvasLayer, unit: Unit, ability: AbilityData) -> AbilityAnnouncement:
	var ann := AbilityAnnouncement.new()
	ann._setup(unit, ability)
	parent.add_child(ann)
	return ann


func _setup(unit: Unit, ability: AbilityData) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.13, 0.11, 0.16, 0.92)
	style.border_color = Color(0.55, 0.45, 0.3, 0.6)
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	add_theme_stylebox_override("panel", style)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 6)
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(hbox)

	var name_label := Label.new()
	name_label.text = unit.unit_name
	var team_color := COLOR_PLAYER if unit.team == Enums.Team.PLAYER else COLOR_ENEMY
	name_label.add_theme_color_override("font_color", team_color)
	name_label.add_theme_font_size_override("font_size", 15)
	hbox.add_child(name_label)

	var verb_label := Label.new()
	verb_label.text = "uses"
	verb_label.add_theme_color_override("font_color", COLOR_VERB)
	verb_label.add_theme_font_size_override("font_size", 14)
	hbox.add_child(verb_label)

	var ability_label := Label.new()
	ability_label.text = ability.ability_name
	ability_label.add_theme_color_override("font_color", _get_type_color(ability.ability_type))
	ability_label.add_theme_font_size_override("font_size", 18)
	hbox.add_child(ability_label)

	z_index = 50
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _ready() -> void:
	await get_tree().process_frame
	var vp_size := get_viewport_rect().size
	position = Vector2((vp_size.x - size.x) / 2.0, 100)

	var start_y := position.y - 20.0
	position.y = start_y
	modulate.a = 0.0

	var tween := create_tween()
	tween.tween_property(self, "position:y", start_y + 20.0, SLIDE_DURATION).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 1.0, SLIDE_DURATION)
	tween.tween_interval(HOLD_DURATION)
	tween.tween_property(self, "modulate:a", 0.0, FADE_DURATION)
	tween.tween_callback(queue_free)


static func _get_type_color(ability_type: Enums.AbilityType) -> Color:
	match ability_type:
		Enums.AbilityType.DAMAGE:
			return COLOR_DAMAGE
		Enums.AbilityType.HEAL:
			return COLOR_HEAL
		Enums.AbilityType.BUFF:
			return COLOR_BUFF
		Enums.AbilityType.DEBUFF:
			return COLOR_DEBUFF
		Enums.AbilityType.TERRAIN:
			return COLOR_TERRAIN
	return Color.WHITE
