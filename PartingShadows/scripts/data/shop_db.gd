class_name ShopDB

## Maps town stop battle_id to shop inventory.
## Each entry is an array of {item_id, price} dictionaries.


static func get_shop_items(battle_id: String) -> Array:
	match battle_id:
		# ---- Story 1 ----
		"ForestWaypoint":
			return [
				{"item_id": "minor_salve", "price": 30},
				{"item_id": "mana_shard", "price": 40},
				{"item_id": "antidote", "price": 40},
				{"item_id": "whetstone", "price": 50},
			]
		"CityOutskirtsStop":
			return [
				{"item_id": "healing_potion", "price": 60},
				{"item_id": "mana_crystal", "price": 70},
				{"item_id": "clarity_tonic", "price": 50},
				{"item_id": "whetstone", "price": 50},
				{"item_id": "bark_charm", "price": 50},
				{"item_id": "battle_standard", "price": 120},
			]
		"CopperMugStop":
			return [
				{"item_id": "greater_potion", "price": 100},
				{"item_id": "mana_crystal", "price": 70},
				{"item_id": "iron_draught", "price": 70},
				{"item_id": "smoke_bomb", "price": 70},
				{"item_id": "iron_flask", "price": 150},
			]

		# ---- Story 2 ----
		"S2_CaveMerchant":
			return [
				{"item_id": "minor_salve", "price": 30},
				{"item_id": "mana_shard", "price": 40},
				{"item_id": "antidote", "price": 40},
				{"item_id": "swiftroot", "price": 50},
			]
		"S2_HarborTown":
			return [
				{"item_id": "healing_potion", "price": 60},
				{"item_id": "mana_crystal", "price": 70},
				{"item_id": "clarity_tonic", "price": 50},
				{"item_id": "bark_charm", "price": 50},
				{"item_id": "fire_bomb", "price": 60},
				{"item_id": "crystal_lens", "price": 120},
			]
		"S2_CoastalCamp":
			return [
				{"item_id": "greater_potion", "price": 100},
				{"item_id": "mana_crystal", "price": 70},
				{"item_id": "iron_draught", "price": 70},
				{"item_id": "smoke_bomb", "price": 70},
				{"item_id": "cave_moss_poultice", "price": 130},
			]

		# ---- Story 3 ----
		"S3_WearyTraveler":
			return [
				{"item_id": "minor_salve", "price": 30},
				{"item_id": "mana_shard", "price": 40},
				{"item_id": "antidote", "price": 40},
			]
		"S3_TownMorning":
			return [
				{"item_id": "healing_potion", "price": 60},
				{"item_id": "mana_shard", "price": 40},
				{"item_id": "clarity_tonic", "price": 50},
				{"item_id": "whetstone", "price": 50},
				{"item_id": "swiftroot", "price": 50},
			]
		"S3_TownInvestigation":
			return [
				{"item_id": "greater_potion", "price": 100},
				{"item_id": "mana_crystal", "price": 70},
				{"item_id": "iron_draught", "price": 70},
				{"item_id": "smoke_bomb", "price": 70},
				{"item_id": "dream_anchor", "price": 120},
				{"item_id": "thread_cutter", "price": 150},
			]
		"S3_B_CallumsTruth":
			return [
				{"item_id": "healing_potion", "price": 60},
				{"item_id": "clarity_tonic", "price": 50},
				{"item_id": "iron_draught", "price": 70},
			]
		"S3_C_LirasConfession":
			return [
				{"item_id": "greater_potion", "price": 100},
				{"item_id": "clarity_tonic", "price": 50},
				{"item_id": "dream_anchor", "price": 120},
			]
	return []


static func has_shop(battle_id: String) -> bool:
	return not get_shop_items(battle_id).is_empty()
