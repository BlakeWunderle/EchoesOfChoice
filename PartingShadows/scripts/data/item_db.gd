class_name ItemDB

## Factory for all consumable items. Each method returns a fresh ItemData instance.
## Design: no healing items. All items are combat effects (buffs, damage, cures).

const Enums := preload("res://scripts/data/enums.gd")
const ItemData := preload("res://scripts/data/item_data.gd")


# ---------------------------------------------------------------------------
# Debuff Removal
# ---------------------------------------------------------------------------

static func antidote() -> ItemData:
	var i := ItemData.new()
	i.item_id = "antidote"; i.item_name = "Antidote"
	i.description = "A bitter tincture that purges a single affliction."
	i.effect_type = Enums.ItemEffect.CURE_DEBUFF; i.magnitude = 1
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
# Buffs (T1: +25%, COMMON, 50g)
# ---------------------------------------------------------------------------

static func shimmer_oil() -> ItemData:
	var i := ItemData.new()
	i.item_id = "shimmer_oil"; i.item_name = "Shimmer Oil"
	i.description = "A shimmering oil that channels arcane energy through weapons."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 25; i.duration = 3
	i.stat_type = Enums.StatType.MAGIC_ATTACK
	i.rarity = Enums.ItemRarity.COMMON; i.shop_price = 50
	return i

static func whetstone() -> ItemData:
	var i := ItemData.new()
	i.item_id = "whetstone"; i.item_name = "Whetstone"
	i.description = "A coarse stone that hones blades to a keen edge."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 25; i.duration = 3
	i.stat_type = Enums.StatType.ATTACK
	i.rarity = Enums.ItemRarity.COMMON; i.shop_price = 50
	return i


static func swiftroot() -> ItemData:
	var i := ItemData.new()
	i.item_id = "swiftroot"; i.item_name = "Swiftroot"
	i.description = "A fibrous root that quickens reflexes when chewed."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 25; i.duration = 3
	i.stat_type = Enums.StatType.SPEED
	i.rarity = Enums.ItemRarity.COMMON; i.shop_price = 50
	return i


# ---------------------------------------------------------------------------
# Buffs (T2: +40%, UNCOMMON, 70-80g)
# ---------------------------------------------------------------------------

static func ether_shard() -> ItemData:
	var i := ItemData.new()
	i.item_id = "ether_shard"; i.item_name = "Ether Shard"
	i.description = "A crystal shard that amplifies magical power."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 40; i.duration = 3
	i.stat_type = Enums.StatType.MAGIC_ATTACK
	i.rarity = Enums.ItemRarity.UNCOMMON; i.shop_price = 80
	return i


static func keen_edge() -> ItemData:
	var i := ItemData.new()
	i.item_id = "keen_edge"; i.item_name = "Keen Edge"
	i.description = "A blade oil that makes every cut bite deeper."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 40; i.duration = 3
	i.stat_type = Enums.StatType.ATTACK
	i.rarity = Enums.ItemRarity.UNCOMMON; i.shop_price = 80
	return i

static func galeroot() -> ItemData:
	var i := ItemData.new()
	i.item_id = "galeroot"; i.item_name = "Galeroot"
	i.description = "A wind-dried root that makes the body feel weightless."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 40; i.duration = 3
	i.stat_type = Enums.StatType.SPEED
	i.rarity = Enums.ItemRarity.UNCOMMON; i.shop_price = 80
	return i


# ---------------------------------------------------------------------------
# AoE Buffs (RARE, 120g)
# ---------------------------------------------------------------------------

static func smoke_bomb() -> ItemData:
	var i := ItemData.new()
	i.item_id = "smoke_bomb"; i.item_name = "Smoke Bomb"
	i.description = "Thick smoke that makes your party harder to hit."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 20; i.duration = 3
	i.stat_type = Enums.StatType.DODGE_CHANCE
	i.target_ally = true; i.target_all = true
	i.rarity = Enums.ItemRarity.UNCOMMON; i.shop_price = 70
	return i

static func war_drum() -> ItemData:
	var i := ItemData.new()
	i.item_id = "war_drum"; i.item_name = "War Drum"
	i.description = "A thunderous drum that drives allies into a fighting frenzy."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 15; i.duration = 3
	i.stat_type = Enums.StatType.ATTACK; i.target_all = true
	i.rarity = Enums.ItemRarity.RARE; i.shop_price = 120
	return i

static func spell_prism() -> ItemData:
	var i := ItemData.new()
	i.item_id = "spell_prism"; i.item_name = "Spell Prism"
	i.description = "A prismatic crystal that refracts and amplifies arcane power."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 15; i.duration = 3
	i.stat_type = Enums.StatType.MAGIC_ATTACK; i.target_all = true
	i.rarity = Enums.ItemRarity.RARE; i.shop_price = 120
	return i

static func crystal_lens() -> ItemData:
	var i := ItemData.new()
	i.item_id = "crystal_lens"; i.item_name = "Crystal Lens"
	i.description = "A polished crystal that sharpens focus and precision."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 15; i.duration = 3
	i.stat_type = Enums.StatType.CRIT
	i.rarity = Enums.ItemRarity.RARE; i.shop_price = 120
	return i



# ---------------------------------------------------------------------------
# Debuffs (T1: -15%, COMMON, 50g)
# ---------------------------------------------------------------------------

static func hex_powder() -> ItemData:
	var i := ItemData.new()
	i.item_id = "hex_powder"; i.item_name = "Hex Powder"
	i.description = "A cursed dust that saps the strength from muscles."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 15; i.duration = 3
	i.stat_type = Enums.StatType.ATTACK; i.target_ally = false
	i.rarity = Enums.ItemRarity.COMMON; i.shop_price = 50
	return i

static func mind_fog() -> ItemData:
	var i := ItemData.new()
	i.item_id = "mind_fog"; i.item_name = "Mind Fog"
	i.description = "An acrid vapor that clouds concentration and dulls spellcraft."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 15; i.duration = 3
	i.stat_type = Enums.StatType.MAGIC_ATTACK; i.target_ally = false
	i.rarity = Enums.ItemRarity.COMMON; i.shop_price = 50
	return i


# ---------------------------------------------------------------------------
# Debuffs (T2: -30%, UNCOMMON, 70-80g)
# ---------------------------------------------------------------------------

static func enfeebling_dust() -> ItemData:
	var i := ItemData.new()
	i.item_id = "enfeebling_dust"; i.item_name = "Enfeebling Dust"
	i.description = "A potent toxin that drains all physical power."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 30; i.duration = 3
	i.stat_type = Enums.StatType.ATTACK; i.target_ally = false
	i.rarity = Enums.ItemRarity.UNCOMMON; i.shop_price = 80
	return i

static func void_salt() -> ItemData:
	var i := ItemData.new()
	i.item_id = "void_salt"; i.item_name = "Void Salt"
	i.description = "Crystals that dissolve magical resonance on contact."
	i.effect_type = Enums.ItemEffect.BUFF; i.magnitude = 30; i.duration = 3
	i.stat_type = Enums.StatType.MAGIC_ATTACK; i.target_ally = false
	i.rarity = Enums.ItemRarity.UNCOMMON; i.shop_price = 80
	return i


# ---------------------------------------------------------------------------
# Damage
# ---------------------------------------------------------------------------

static func cinder_bomb() -> ItemData:
	var i := ItemData.new()
	i.item_id = "cinder_bomb"; i.item_name = "Cinder Bomb"
	i.description = "A small clay pot with a weak incendiary charge."
	i.effect_type = Enums.ItemEffect.DAMAGE; i.magnitude = 12
	i.target_ally = false
	i.rarity = Enums.ItemRarity.COMMON; i.shop_price = 40
	return i

static func fire_bomb() -> ItemData:
	var i := ItemData.new()
	i.item_id = "fire_bomb"; i.item_name = "Fire Bomb"
	i.description = "A clay pot packed with volatile powder."
	i.effect_type = Enums.ItemEffect.DAMAGE; i.magnitude = 25
	i.target_ally = false
	i.rarity = Enums.ItemRarity.UNCOMMON; i.shop_price = 60
	return i

static func blast_powder() -> ItemData:
	var i := ItemData.new()
	i.item_id = "blast_powder"; i.item_name = "Blast Powder"
	i.description = "A volatile compound that detonates in a wide radius."
	i.effect_type = Enums.ItemEffect.DAMAGE; i.magnitude = 30
	i.target_ally = false; i.target_all = true
	i.rarity = Enums.ItemRarity.RARE; i.shop_price = 150
	return i


# ---------------------------------------------------------------------------
# Lookup
# ---------------------------------------------------------------------------

static func create_by_id(id: String) -> ItemData:
	match id:
		"antidote": return antidote()
		"clarity_tonic": return clarity_tonic()
		"shimmer_oil": return shimmer_oil()
		"ether_shard": return ether_shard()
		"whetstone": return whetstone()
		"swiftroot": return swiftroot()
		"keen_edge": return keen_edge()
		"galeroot": return galeroot()
		"cinder_bomb": return cinder_bomb()
		"fire_bomb": return fire_bomb()
		"smoke_bomb": return smoke_bomb()
		"war_drum": return war_drum()
		"crystal_lens": return crystal_lens()
		"blast_powder": return blast_powder()
		"spell_prism": return spell_prism()
		"hex_powder": return hex_powder()
		"mind_fog": return mind_fog()
		"enfeebling_dust": return enfeebling_dust()
		"void_salt": return void_salt()
	push_warning("ItemDB: unknown item_id '%s'" % id)
	return fire_bomb()
