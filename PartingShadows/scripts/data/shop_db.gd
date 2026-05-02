class_name ShopDB

## Maps town stop battle_id to shop inventory.
## Each entry is an array of {item_id, price} dictionaries.
## No healing items. All items are combat effects (buffs, damage, cures).


static func get_shop_items(battle_id: String) -> Array:
	match battle_id:
		# ---- Story 1 ----
		"ForestWaypoint":
			return [
				{"item_id": "antidote", "price": 40},
				{"item_id": "cinder_bomb", "price": 40},
				{"item_id": "whetstone", "price": 50},
				{"item_id": "shimmer_oil", "price": 50},
				{"item_id": "fire_bomb", "price": 60},
			]
		"CityOutskirtsStop":
			return [
				{"item_id": "clarity_tonic", "price": 50},
				{"item_id": "whetstone", "price": 50},
				{"item_id": "shimmer_oil", "price": 50},
				{"item_id": "hex_powder", "price": 50},
				{"item_id": "war_drum", "price": 120},
			]
		"CopperMugStop":
			return [
				{"item_id": "keen_edge", "price": 80},
				{"item_id": "ether_shard", "price": 80},
				{"item_id": "galeroot", "price": 80},
				{"item_id": "enfeebling_dust", "price": 80},
				{"item_id": "void_salt", "price": 80},
				{"item_id": "smoke_bomb", "price": 70},
				{"item_id": "crystal_lens", "price": 120},
				{"item_id": "war_drum", "price": 120},
				{"item_id": "spell_prism", "price": 120},
				{"item_id": "blast_powder", "price": 150},
			]

		# ---- Story 2 ----
		"S2_CaveMerchant":
			return [
				{"item_id": "antidote", "price": 40},
				{"item_id": "cinder_bomb", "price": 40},
				{"item_id": "swiftroot", "price": 50},
				{"item_id": "shimmer_oil", "price": 50},
				{"item_id": "fire_bomb", "price": 60},
			]
		"S2_HarborTown":
			return [
				{"item_id": "clarity_tonic", "price": 50},
				{"item_id": "shimmer_oil", "price": 50},
				{"item_id": "hex_powder", "price": 50},
				{"item_id": "mind_fog", "price": 50},
				{"item_id": "fire_bomb", "price": 60},
				{"item_id": "crystal_lens", "price": 120},
				{"item_id": "war_drum", "price": 120},
			]
		"S2_CoastalCamp":
			return [
				{"item_id": "keen_edge", "price": 80},
				{"item_id": "ether_shard", "price": 80},
				{"item_id": "galeroot", "price": 80},
				{"item_id": "enfeebling_dust", "price": 80},
				{"item_id": "void_salt", "price": 80},
				{"item_id": "smoke_bomb", "price": 70},
				{"item_id": "crystal_lens", "price": 120},
				{"item_id": "war_drum", "price": 120},
				{"item_id": "spell_prism", "price": 120},
				{"item_id": "blast_powder", "price": 150},
			]

		# ---- Story 3 ----
		"S3_WearyTraveler":
			return [
				{"item_id": "antidote", "price": 40},
				{"item_id": "cinder_bomb", "price": 40},
				{"item_id": "shimmer_oil", "price": 50},
				{"item_id": "fire_bomb", "price": 60},
			]
		"S3_TownMorning":
			return [
				{"item_id": "clarity_tonic", "price": 50},
				{"item_id": "whetstone", "price": 50},
				{"item_id": "shimmer_oil", "price": 50},
				{"item_id": "swiftroot", "price": 50},
				{"item_id": "hex_powder", "price": 50},
				{"item_id": "mind_fog", "price": 50},
				{"item_id": "war_drum", "price": 120},
			]
		"S3_TownInvestigation":
			return [
				{"item_id": "keen_edge", "price": 80},
				{"item_id": "ether_shard", "price": 80},
				{"item_id": "galeroot", "price": 80},
				{"item_id": "enfeebling_dust", "price": 80},
				{"item_id": "void_salt", "price": 80},
				{"item_id": "smoke_bomb", "price": 70},
				{"item_id": "crystal_lens", "price": 120},
				{"item_id": "war_drum", "price": 120},
				{"item_id": "spell_prism", "price": 120},
				{"item_id": "blast_powder", "price": 150},
			]
		"S3_B_CallumsTruth":
			return [
				{"item_id": "clarity_tonic", "price": 50},
				{"item_id": "keen_edge", "price": 80},
			]
		"S3_C_LirasConfession":
			return [
				{"item_id": "clarity_tonic", "price": 50},
				{"item_id": "ether_shard", "price": 80},
				{"item_id": "void_salt", "price": 80},
			]
	return []


static func has_shop(battle_id: String) -> bool:
	return not get_shop_items(battle_id).is_empty()
