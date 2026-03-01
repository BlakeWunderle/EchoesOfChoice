class_name DamagePreview extends Node2D

var _bg: ColorRect
var _label: Label

const Combat = preload("res://scripts/systems/combat.gd")


func _ready() -> void:
	# Build floating preview label
	var container := Control.new()
	container.set_anchors_preset(Control.PRESET_TOP_LEFT)
	add_child(container)

	_bg = ColorRect.new()
	_bg.color = Color(0.08, 0.08, 0.12, 0.8)
	container.add_child(_bg)

	_label = Label.new()
	_label.add_theme_font_size_override("font_size", 13)
	_label.position = Vector2(4, 2)
	container.add_child(_label)

	visible = false


func show_at(unit: Unit, text: String, color: Color) -> void:
	_label.text = text
	_label.add_theme_color_override("font_color", color)
	# Position above the target unit
	position = unit.position + Vector2(-40, -58)
	# Resize background to fit text
	await get_tree().process_frame
	_bg.size = Vector2(_label.size.x + 8, _label.size.y + 4)
	visible = true


func hide_preview() -> void:
	visible = false


static func get_preview_text(ability: AbilityData, attacker: Unit, target: Unit) -> Dictionary:
	match ability.ability_type:
		Enums.AbilityType.DAMAGE:
			var dmg := Combat.calculate_ability_damage(
				ability, attacker.get_stats_dict(), target.get_stats_dict()
			)
			var text := "~%d dmg" % dmg
			if attacker.crit_chance > 0:
				var crit_dmg := dmg + attacker.crit_damage
				text += " (%d crit)" % crit_dmg
			if target.dodge_chance > 0:
				text += " [%d%% dodge]" % (target.dodge_chance * 10)
			return {"text": text, "color": Color(1.0, 0.3, 0.2)}

		Enums.AbilityType.HEAL:
			var heal := Combat.calculate_heal(
				ability, attacker.magic_attack, attacker.physical_attack
			)
			return {"text": "+%d HP" % heal, "color": Color(0.3, 1.0, 0.4)}

		Enums.AbilityType.BUFF:
			var stat_name := _stat_short_name(ability.modified_stat)
			return {
				"text": "+%d %s (%dt)" % [ability.modifier, stat_name, ability.impacted_turns],
				"color": Color(0.4, 0.8, 1.0),
			}

		Enums.AbilityType.DEBUFF:
			var stat_name := _stat_short_name(ability.modified_stat)
			return {
				"text": "-%d %s (%dt)" % [ability.modifier, stat_name, ability.impacted_turns],
				"color": Color(0.9, 0.4, 0.9),
			}

	return {"text": "", "color": Color.WHITE}


static func _stat_short_name(stat: Enums.StatType) -> String:
	match stat:
		Enums.StatType.PHYSICAL_ATTACK: return "P.Atk"
		Enums.StatType.PHYSICAL_DEFENSE: return "P.Def"
		Enums.StatType.MAGIC_ATTACK: return "M.Atk"
		Enums.StatType.MAGIC_DEFENSE: return "M.Def"
		Enums.StatType.ATTACK: return "Atk"
		Enums.StatType.DEFENSE: return "Def"
		Enums.StatType.MIXED_ATTACK: return "Mix"
		Enums.StatType.SPEED: return "Spd"
		Enums.StatType.DODGE_CHANCE: return "Dodge"
	return "?"
