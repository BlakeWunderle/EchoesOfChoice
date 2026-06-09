class_name UltimateInfoPanel extends PanelContainer

## Detail panel showing ultimate charge cost, flavor text, and mechanical effect.
## Updates dynamically as the player focuses on different ultimate options.

const Enums := preload("res://scripts/data/enums.gd")

var _name_label: Label
var _charge_label: Label
var _flavor_label: Label
var _effect_label: Label


func _init() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.1, 0.14, 0.9)
	style.border_color = Color(0.2, 0.9, 0.8, 0.3)
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)
	style.set_content_margin_all(12)
	add_theme_stylebox_override("panel", style)
	visible = false


func _ready() -> void:
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	add_child(vbox)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 12)
	vbox.add_child(header)

	_name_label = Label.new()
	_name_label.add_theme_font_size_override("font_size", 18)
	_name_label.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	header.add_child(_name_label)

	_charge_label = Label.new()
	_charge_label.add_theme_font_size_override("font_size", 14)
	_charge_label.add_theme_color_override("font_color", Color(0.2, 0.9, 0.8))
	_charge_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_charge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	header.add_child(_charge_label)

	_flavor_label = Label.new()
	_flavor_label.add_theme_font_size_override("font_size", maxi(SettingsManager.font_size - 2, 14))
	_flavor_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.8))
	_flavor_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_flavor_label)

	var sep := HSeparator.new()
	vbox.add_child(sep)

	var effect_header := Label.new()
	effect_header.text = "Effect"
	effect_header.add_theme_font_size_override("font_size", maxi(SettingsManager.font_size - 2, 14))
	effect_header.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	vbox.add_child(effect_header)

	_effect_label = Label.new()
	_effect_label.add_theme_font_size_override("font_size", maxi(SettingsManager.font_size - 2, 14))
	_effect_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.85))
	_effect_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_effect_label)


func show_ultimate(ult: RefCounted) -> void:
	_name_label.text = ult.ultimate_name

	var speed: String
	if ult.charge_cost <= 55:
		speed = "Fast"
	elif ult.charge_cost <= 75:
		speed = "Standard"
	elif ult.charge_cost <= 95:
		speed = "Slow"
	else:
		speed = "Very Slow"
	_charge_label.text = "Charge: %d (%s)" % [ult.charge_cost, speed]

	_flavor_label.text = ult.description
	_flavor_label.visible = not ult.description.is_empty()

	_effect_label.text = ult.ability.get_compendium_description()

	visible = true
