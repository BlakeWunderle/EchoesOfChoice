class_name ItemData extends RefCounted

## Defines a single consumable item's properties.

const Enums := preload("res://scripts/data/enums.gd")

var item_id: String
var item_name: String
var description: String
var effect_type: Enums.ItemEffect
var target_ally: bool = true
var target_all: bool = false
var magnitude: int = 0
var duration: int = 0  ## 0 = instant, >0 = buff/debuff turns
var stat_type: Enums.StatType = Enums.StatType.ATTACK
var rarity: Enums.ItemRarity = Enums.ItemRarity.COMMON
var shop_price: int = 0  ## Gold cost in shops (0 = not sold)


func get_use_description() -> String:
	match effect_type:
		Enums.ItemEffect.HEAL_HP:
			var scope: String = " to all allies" if target_all else ""
			if magnitude >= 100:
				return "Fully restores HP%s" % scope
			return "Restores %d%% HP%s" % [magnitude, scope]
		Enums.ItemEffect.HEAL_MP:
			return "Restores %d MP" % magnitude
		Enums.ItemEffect.CURE_DEBUFF:
			if magnitude > 0:
				return "Removes %d debuff(s)" % magnitude
			return "Removes all debuffs"
		Enums.ItemEffect.BUFF:
			var stat_name: String = _stat_name()
			var scope: String = " (all allies)" if target_all else ""
			return "+%s for %d turn(s)%s" % [stat_name, duration, scope]
		Enums.ItemEffect.DAMAGE:
			var scope: String = " to all enemies" if target_all else ""
			return "Deals %d damage%s" % [magnitude, scope]
	return description


func _stat_name() -> String:
	match stat_type:
		Enums.StatType.ATTACK: return "ATK"
		Enums.StatType.DEFENSE: return "DEF"
		Enums.StatType.PHYSICAL_ATTACK: return "P.ATK"
		Enums.StatType.PHYSICAL_DEFENSE: return "P.DEF"
		Enums.StatType.MAGIC_ATTACK: return "M.ATK"
		Enums.StatType.MAGIC_DEFENSE: return "M.DEF"
		Enums.StatType.SPEED: return "SPD"
		Enums.StatType.DODGE_CHANCE: return "DODGE"
		Enums.StatType.CRIT_CHANCE: return "CRIT"
	return "STAT"


func to_save_data() -> String:
	return item_id


static func from_save_id(id: String) -> ItemData:
	var ItemDB := preload("res://scripts/data/item_db.gd")
	return ItemDB.create_by_id(id)
