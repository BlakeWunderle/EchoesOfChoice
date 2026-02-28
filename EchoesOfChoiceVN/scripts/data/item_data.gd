class_name ItemData extends Resource

@export var item_id: String
@export var display_name: String
@export_multiline var description: String
@export var item_type: Enums.ItemType = Enums.ItemType.CONSUMABLE

@export_group("Shop")
@export var buy_price: int = 0
@export var sell_price_override: int = -1

@export_group("Equipment")
@export var stat_bonuses: Dictionary = {}
@export var unlock_tier: int = 0
@export var unlock_class_ids: PackedStringArray = []

@export_group("Consumable")
@export var consumable_effect: Enums.ConsumableEffect = Enums.ConsumableEffect.HEAL_HP
@export var consumable_value: int = 0
@export var buff_stat: Enums.StatType = Enums.StatType.PHYSICAL_ATTACK
@export var buff_turns: int = 0


func get_sell_price() -> int:
	if sell_price_override >= 0:
		return sell_price_override
	return int(buy_price * 0.5)


func is_equipment() -> bool:
	return item_type == Enums.ItemType.EQUIPMENT


func is_consumable() -> bool:
	return item_type == Enums.ItemType.CONSUMABLE


func get_stat_summary() -> String:
	if is_consumable():
		match consumable_effect:
			Enums.ConsumableEffect.HEAL_HP:
				return "Heal %d HP" % consumable_value
			Enums.ConsumableEffect.RESTORE_MANA:
				return "Restore %d MP" % consumable_value
			Enums.ConsumableEffect.BUFF_STAT:
				return "+%d %s (%d turns)" % [consumable_value, _stat_name(buff_stat), buff_turns]
	var parts: Array[String] = []
	for stat_key in stat_bonuses:
		var val: int = stat_bonuses[stat_key]
		if val != 0:
			var sign_str := "+" if val > 0 else ""
			parts.append("%s%d %s" % [sign_str, val, _stat_name(stat_key)])
	return ", ".join(parts) if parts.size() > 0 else ""


static func _stat_name(stat) -> String:
	var stat_val: int
	if stat is String:
		stat_val = Enums.StatType.get(stat.to_upper(), -1)
	else:
		stat_val = int(stat)
	match stat_val:
		Enums.StatType.PHYSICAL_ATTACK: return "P.Atk"
		Enums.StatType.PHYSICAL_DEFENSE: return "P.Def"
		Enums.StatType.MAGIC_ATTACK: return "M.Atk"
		Enums.StatType.MAGIC_DEFENSE: return "M.Def"
		Enums.StatType.ATTACK: return "Atk"
		Enums.StatType.DEFENSE: return "Def"
		Enums.StatType.SPEED: return "Spd"
		Enums.StatType.DODGE_CHANCE: return "Dodge"
		Enums.StatType.MAX_HEALTH: return "HP"
		Enums.StatType.MAX_MANA: return "MP"
		Enums.StatType.CRIT_CHANCE: return "Crit%"
		Enums.StatType.CRIT_DAMAGE: return "CritDmg"
	return "???"
