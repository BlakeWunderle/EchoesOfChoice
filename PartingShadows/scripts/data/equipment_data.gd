class_name EquipmentData extends RefCounted

## A single piece of equipment (weapon, armor, or boots) with stat bonuses.
## Equipment is permanent and per-character. Stats are baked into the fighter.

const _Self := preload("res://scripts/data/equipment_data.gd")

enum Slot { WEAPON, ARMOR, BOOTS }

var slot: Slot
var display_name: String = ""
var base_id: String = ""          ## Factory key (e.g. "physical_weapon", "speed_boots")
var upgrade_level: int = 0        ## 0 = base, 1 = upgraded (max)
var stat_bonuses: Dictionary = {} ## {"physical_attack": 3, "crit_chance": 5}


func get_slot_name() -> String:
	match slot:
		Slot.WEAPON: return "Weapon"
		Slot.ARMOR: return "Armor"
		Slot.BOOTS: return "Boots"
	return ""


func get_bonus_text() -> String:
	if stat_bonuses.is_empty():
		return ""
	var parts: Array[String] = []
	for key: String in stat_bonuses:
		var val: int = stat_bonuses[key]
		var sign: String = "+" if val >= 0 else ""
		parts.append("%s%d %s" % [sign, val, _stat_short_name(key)])
	return ", ".join(parts)


func clone() -> RefCounted:
	var c := _Self.new()
	c.slot = slot
	c.display_name = display_name
	c.base_id = base_id
	c.upgrade_level = upgrade_level
	c.stat_bonuses = stat_bonuses.duplicate()
	return c


func to_save_data() -> Dictionary:
	return {
		"slot": slot as int,
		"display_name": display_name,
		"base_id": base_id,
		"upgrade_level": upgrade_level,
		"stat_bonuses": stat_bonuses.duplicate(),
	}


static func from_save_data(d: Dictionary) -> RefCounted:
	var e := _Self.new()
	e.slot = d.get("slot", 0) as Slot
	e.display_name = d.get("display_name", "")
	e.base_id = d.get("base_id", "")
	e.upgrade_level = d.get("upgrade_level", 0)
	var saved_bonuses: Dictionary = d.get("stat_bonuses", {})
	for key: String in saved_bonuses:
		e.stat_bonuses[key] = int(saved_bonuses[key])
	return e


static func _stat_short_name(stat: String) -> String:
	match stat:
		"physical_attack": return "P.ATK"
		"physical_defense": return "P.DEF"
		"magic_attack": return "M.ATK"
		"magic_defense": return "M.DEF"
		"speed": return "SPD"
		"crit_chance": return "Crit"
		"crit_damage": return "Crit DMG"
		"dodge_chance": return "Dodge"
		"max_health": return "HP"
		"max_mana": return "Mana"
	return stat
