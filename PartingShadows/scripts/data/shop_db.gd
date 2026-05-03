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
		"S2_B_SafeHaven":
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


## Returns story-specific narration lines shown before the shop menu.
static func get_shop_text(battle_id: String) -> Array[String]:
	match battle_id:
		# Story 1
		"ForestWaypoint":
			return ["A peddler has set up a modest stall by the waypoint. 'Dangerous road ahead. Stock up while you can.'"]
		"CityOutskirtsStop":
			return ["An arms dealer has a cart parked outside the city walls. Business has been good lately."]
		"CopperMugStop":
			return ["The Copper Mug's back room doubles as a black market. The barkeep slides a price list across the counter."]
		# Story 2
		"S2_CaveMerchant":
			return ["A figure crouches by a dim lantern, surrounded by trinkets and vials. 'Trade? I have things. You have gold. Simple.'"]
		"S2_HarborTown":
			return ["The harbor market is chaos. Salt-crusted merchants hawk their wares over the crash of waves."]
		"S2_CoastalCamp":
			return ["A quiet trader has laid out supplies on a weathered blanket. 'Last chance before the deep.'"]
		"S2_B_SafeHaven":
			return ["Sera rummages through a cache hidden in the ruins. 'I stashed supplies here months ago. Take what you need.'"]
		# Story 3
		"S3_WearyTraveler":
			return ["The innkeeper gestures to a shelf behind the bar. 'Not just rooms and meals. I keep a few things on hand for travelers like you.'"]
		"S3_TownMorning":
			return ["The morning market is alive with voices. A vendor catches your eye with a knowing look."]
		"S3_TownInvestigation":
			return ["A hooded merchant tugs your sleeve. 'You're the ones asking questions. You'll need more than answers.'"]
		"S3_B_CallumsTruth":
			return ["Callum opens a hidden compartment in the wall. 'Take what you need. I won't be needing it.'"]
		"S3_C_LirasConfession":
			return ["Lira presses a small pouch into your hands. 'From my own supplies. It's the least I can do.'"]
	return []
