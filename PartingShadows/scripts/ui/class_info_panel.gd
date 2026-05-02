class_name ClassInfoPanel extends PanelContainer

## Detail panel showing class role, flavor text, and abilities.
## Updates dynamically as the player focuses on different class options.

const FighterDB := preload("res://scripts/data/fighter_db.gd")
const FighterDBRoles := preload("res://scripts/data/fighter_db_roles.gd")
const Enums := preload("res://scripts/data/enums.gd")

var _vbox: VBoxContainer
var _name_label: Label
var _role_label: Label
var _flavor_label: Label
var _abilities_container: VBoxContainer


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
	_vbox = VBoxContainer.new()
	_vbox.add_theme_constant_override("separation", 4)
	add_child(_vbox)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 12)
	_vbox.add_child(header)

	_name_label = Label.new()
	_name_label.add_theme_font_size_override("font_size", 18)
	_name_label.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	header.add_child(_name_label)

	_role_label = Label.new()
	_role_label.add_theme_font_size_override("font_size", 14)
	_role_label.add_theme_color_override("font_color", Color(0.2, 0.9, 0.8))
	_role_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_role_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	header.add_child(_role_label)

	_flavor_label = Label.new()
	_flavor_label.add_theme_font_size_override("font_size", maxi(SettingsManager.font_size - 2, 14))
	_flavor_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.8))
	_flavor_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_vbox.add_child(_flavor_label)

	var sep := HSeparator.new()
	_vbox.add_child(sep)

	var abilities_header := Label.new()
	abilities_header.text = "Abilities"
	abilities_header.add_theme_font_size_override("font_size", maxi(SettingsManager.font_size - 2, 14))
	abilities_header.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	_vbox.add_child(abilities_header)

	_abilities_container = VBoxContainer.new()
	_abilities_container.add_theme_constant_override("separation", 1)
	_vbox.add_child(_abilities_container)


func show_class(class_id: String, show_name: bool = true) -> void:
	# Clear previous abilities
	for child: Node in _abilities_container.get_children():
		child.queue_free()

	# Name
	if show_name:
		_name_label.text = FighterDB.get_display_name(class_id)
	else:
		_name_label.text = "???"

	# Roles
	var roles: Array = FighterDBRoles.get_roles(class_id)
	var role_names: Array[String] = []
	for role in roles:
		match role:
			Enums.Role.DPS: role_names.append("Striker")
			Enums.Role.FIGHTER: role_names.append("Fighter")
			Enums.Role.BURST: role_names.append("Nuker")
			Enums.Role.TANK: role_names.append("Tank")
			Enums.Role.SUPPORT: role_names.append("Support")
			Enums.Role.CASTER: role_names.append("Caster")
			Enums.Role.HYBRID: role_names.append("Hybrid")
	_role_label.text = " / ".join(role_names)

	# Flavor text
	var flavor: String = FighterDB.get_flavor_text(class_id)
	_flavor_label.text = flavor
	_flavor_label.visible = not flavor.is_empty()

	# Abilities
	var abilities: Array = FighterDB.get_abilities_for_class(class_id)
	for a: RefCounted in abilities:
		var line_label := Label.new()
		var line: String = "  %s" % a.ability_name
		if a.mana_cost > 0:
			line += "  (%d MP)" % a.mana_cost
		line += "  -  %s" % a.get_compendium_description()
		line_label.text = line
		line_label.add_theme_font_size_override("font_size", maxi(SettingsManager.font_size - 2, 14))
		line_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.85))
		line_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_abilities_container.add_child(line_label)

	visible = true
