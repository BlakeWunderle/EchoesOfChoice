class_name ItemDB

## Factory for all consumable items. Each method returns a fresh ItemData instance.

const Enums := preload("res://scripts/data/enums.gd")
const ItemData := preload("res://scripts/data/item_data.gd")


# ---------------------------------------------------------------------------
# Healing
# ---------------------------------------------------------------------------

static func minor_salve() -> ItemData:
	var i := ItemData.new()
	i.item_id = "minor_salve"; i.item_name = "Minor Salve"
	i.description = "A simple herbal paste that soothes minor wounds."
	i.effect_type = Enums.ItemEffect.HEAL_HP; i.magnitude = 20
	i.rarity = Enums.ItemRarity.COMMON; i.shop_price = 30
	return i

static func healing_potion() -> ItemData:
	var i := ItemData.new()
	i.item_id = "healing_potion"; i.item_name = "Healing Potion"
	i.description = "A glowing vial that mends flesh and bone."
	i.effect_type = Enums.ItemEffect.HEAL_HP; i.magnitude = 40
	i.rarity = Enums.ItemRarity.UNCOMMON; i.shop_price = 60
	return i

static func greater_potion() -> ItemData:
	var i := ItemData.new()
	i.item_id = "greater_potion"; i.item_name = "Greater Potion"
	i.description = "A potent elixir brewed from rare ingredients."
	i.effect_type = Enums.ItemEffect.HEAL_HP; i.magnitude = 70
	i.rarity = Enums.ItemRarity.RARE; i.shop_price = 100
	return i

static func mana_shard() -> ItemData:
	var i := ItemData.new()
	i.item_id = "mana_shard"; i.item_name = "Mana Shard"
	i.description = "A crystalline fragment humming with arcane energy."
	i.effect_type = Enums.ItemEffect.HEAL_MP; i.magnitude = 3
	i.rarity = Enums.ItemRarity.COMMON; i.shop_price = 40
	return i

static func mana_crystal() -> ItemData:
	var i := ItemData.new()
	i.item_id = "mana_crystal"; i.item_name = "Mana Crystal"
	i.description = "A larger crystal pulsing with deep blue light."
	i.effect_type = Enums.ItemEffect.HEAL_MP; i.magnitude = 5
	i.rarity = Enums.ItemRarity.UNCOMMON; i.shop_price = 70
	return i


# ---------------------------------------------------------------------------
# Debuff Removal
# ---------------------------------------------------------------------------

static func antidote() -> ItemData:
	var i := ItemData.new()
	i.item_id = "antidote"; i.item_name = "Antidote"
	i.description = "A bitter tincture that purges poison and corruption."
	i.effect_type = Enums.ItemEffect.CURE_DEBUFF
	i.rarity = Enums.ItemRarity.COMMON; i.shop_price = 40
	return i

static func clarity_tonic() -> ItemData:
	var i := ItemData.new()
	i.item_id = "clarity_tonic"; i.item_name = "Clarity Tonic"
	i.description = "A sharp-smelling draught that clears the mind."
	i.effect_type = Enums.ItemEffect.CURE_DEBUFF
	i.rarity = Enums.ItemRarity.UNCOMMON; i.shop_price = 50
	return i


# ---------------------------------------------------------------------------
# Buffs
# ---------------------------------------------------------------------------

static func whetstone() -> ItemData:
	var i := ItemData.new()
	i.item_id = "whetstone"; i.item_name = "Whetstone"
	i.description = "A coarse stone that hones blades to a keen edge."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 5; i.duration = 2
	i.stat_type = Enums.StatType.ATTACK
	i.rarity = Enums.ItemRarity.COMMON; i.shop_price = 50
	return i

static func bark_charm() -> ItemData:
	var i := ItemData.new()
	i.item_id = "bark_charm"; i.item_name = "Bark Charm"
	i.description = "A talisman carved from ancient ironwood."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 5; i.duration = 2
	i.stat_type = Enums.StatType.DEFENSE
	i.rarity = Enums.ItemRarity.COMMON; i.shop_price = 50
	return i

static func swiftroot() -> ItemData:
	var i := ItemData.new()
	i.item_id = "swiftroot"; i.item_name = "Swiftroot"
	i.description = "A fibrous root that quickens reflexes when chewed."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 5; i.duration = 2
	i.stat_type = Enums.StatType.SPEED
	i.rarity = Enums.ItemRarity.COMMON; i.shop_price = 50
	return i

static func iron_draught() -> ItemData:
	var i := ItemData.new()
	i.item_id = "iron_draught"; i.item_name = "Iron Draught"
	i.description = "A thick metallic brew that hardens skin like steel."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 8; i.duration = 2
	i.stat_type = Enums.StatType.DEFENSE
	i.rarity = Enums.ItemRarity.UNCOMMON; i.shop_price = 70
	return i


# ---------------------------------------------------------------------------
# Damage
# ---------------------------------------------------------------------------

static func fire_bomb() -> ItemData:
	var i := ItemData.new()
	i.item_id = "fire_bomb"; i.item_name = "Fire Bomb"
	i.description = "A clay pot packed with volatile powder."
	i.effect_type = Enums.ItemEffect.DAMAGE; i.magnitude = 25
	i.target_ally = false
	i.rarity = Enums.ItemRarity.UNCOMMON; i.shop_price = 60
	return i

static func smoke_bomb() -> ItemData:
	var i := ItemData.new()
	i.item_id = "smoke_bomb"; i.item_name = "Smoke Bomb"
	i.description = "Thick smoke that chokes and disorients."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = -5; i.duration = 2
	i.stat_type = Enums.StatType.SPEED
	i.target_ally = false; i.target_all = true
	i.rarity = Enums.ItemRarity.UNCOMMON; i.shop_price = 70
	return i


# ---------------------------------------------------------------------------
# Shop Exclusives
# ---------------------------------------------------------------------------

static func battle_standard() -> ItemData:
	var i := ItemData.new()
	i.item_id = "battle_standard"; i.item_name = "Battle Standard"
	i.description = "A war banner that inspires allies to fight harder."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 5; i.duration = 2
	i.stat_type = Enums.StatType.ATTACK; i.target_all = true
	i.rarity = Enums.ItemRarity.RARE; i.shop_price = 120
	return i

static func iron_flask() -> ItemData:
	var i := ItemData.new()
	i.item_id = "iron_flask"; i.item_name = "Iron Flask"
	i.description = "A masterwork flask containing a potent restorative."
	i.effect_type = Enums.ItemEffect.HEAL_HP; i.magnitude = 999
	i.rarity = Enums.ItemRarity.RARE; i.shop_price = 150
	return i

static func crystal_lens() -> ItemData:
	var i := ItemData.new()
	i.item_id = "crystal_lens"; i.item_name = "Crystal Lens"
	i.description = "A polished crystal that sharpens focus and precision."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 10; i.duration = 3
	i.stat_type = Enums.StatType.DODGE_CHANCE  # boosts crit via dodge stat slot
	i.rarity = Enums.ItemRarity.RARE; i.shop_price = 120
	return i

static func cave_moss_poultice() -> ItemData:
	var i := ItemData.new()
	i.item_id = "cave_moss_poultice"; i.item_name = "Cave Moss Poultice"
	i.description = "Damp cave moss with remarkable healing properties."
	i.effect_type = Enums.ItemEffect.HEAL_HP; i.magnitude = 40
	i.rarity = Enums.ItemRarity.RARE; i.shop_price = 130
	return i

static func dream_anchor() -> ItemData:
	var i := ItemData.new()
	i.item_id = "dream_anchor"; i.item_name = "Dream Anchor"
	i.description = "A token that grounds the mind against manipulation."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 8; i.duration = 2
	i.stat_type = Enums.StatType.DEFENSE; i.target_all = true
	i.rarity = Enums.ItemRarity.RARE; i.shop_price = 120
	return i

static func thread_cutter() -> ItemData:
	var i := ItemData.new()
	i.item_id = "thread_cutter"; i.item_name = "Thread Cutter"
	i.description = "A sharp blade infused with anti-magic runes."
	i.effect_type = Enums.ItemEffect.DAMAGE; i.magnitude = 30
	i.target_ally = false; i.target_all = true
	i.rarity = Enums.ItemRarity.RARE; i.shop_price = 150
	return i


# ---------------------------------------------------------------------------
# Lookup
# ---------------------------------------------------------------------------

static func create_by_id(id: String) -> ItemData:
	match id:
		"minor_salve": return minor_salve()
		"healing_potion": return healing_potion()
		"greater_potion": return greater_potion()
		"mana_shard": return mana_shard()
		"mana_crystal": return mana_crystal()
		"antidote": return antidote()
		"clarity_tonic": return clarity_tonic()
		"whetstone": return whetstone()
		"bark_charm": return bark_charm()
		"swiftroot": return swiftroot()
		"iron_draught": return iron_draught()
		"fire_bomb": return fire_bomb()
		"smoke_bomb": return smoke_bomb()
		"battle_standard": return battle_standard()
		"iron_flask": return iron_flask()
		"crystal_lens": return crystal_lens()
		"cave_moss_poultice": return cave_moss_poultice()
		"dream_anchor": return dream_anchor()
		"thread_cutter": return thread_cutter()
	push_warning("ItemDB: unknown item_id '%s'" % id)
	return minor_salve()
