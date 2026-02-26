class_name AbilityTooltip extends PanelContainer

const TYPE_NAMES := ["Damage", "Heal", "Buff", "Debuff", "Terrain"]
const AOE_NAMES := ["Single", "Line", "Cross", "Diamond", "Square", "Global"]


static func create(ability: AbilityData) -> AbilityTooltip:
	var tooltip := AbilityTooltip.new()
	tooltip._build(ability)
	return tooltip


func _build(ability: AbilityData) -> void:
	custom_minimum_size = Vector2(240, 0)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 6)
	add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 3)
	margin.add_child(vbox)

	# Ability name
	var name_lbl := Label.new()
	name_lbl.text = ability.ability_name
	name_lbl.add_theme_font_size_override("font_size", 14)
	name_lbl.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
	vbox.add_child(name_lbl)

	# Info line: Type | Range | AoE | MP
	var info_parts: Array[String] = [TYPE_NAMES[ability.ability_type]]
	info_parts.append("Range: %d" % ability.ability_range)
	if ability.aoe_shape != Enums.AoEShape.SINGLE:
		info_parts.append("AoE: %s %d" % [AOE_NAMES[ability.aoe_shape], ability.aoe_size])
	if ability.mana_cost > 0:
		info_parts.append("MP: %d" % ability.mana_cost)
	if ability.modifier > 0:
		info_parts.append("Power: %d" % ability.modifier)

	var info_lbl := Label.new()
	info_lbl.text = " | ".join(info_parts)
	info_lbl.add_theme_font_size_override("font_size", 10)
	info_lbl.add_theme_color_override("font_color", Color(0.5, 0.7, 0.85))
	vbox.add_child(info_lbl)

	# Flavor text
	if not ability.flavor_text.is_empty():
		var flavor := Label.new()
		flavor.text = ability.flavor_text
		flavor.add_theme_font_size_override("font_size", 10)
		flavor.add_theme_color_override("font_color", Color(0.65, 0.65, 0.55))
		flavor.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox.add_child(flavor)
