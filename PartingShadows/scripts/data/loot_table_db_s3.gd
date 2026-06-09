class_name LootTableDBS3

## Loot drop entries for Story 3 enemies.
## Entry format matches LootTableDB: ["item", pool] or ["gold", min, max]

const ItemDB := preload("res://scripts/data/item_db.gd")
const ItemData := preload("res://scripts/data/item_data.gd")
const LootTableDB := preload("res://scripts/data/loot_table_db.gd")

const _TABLE: Dictionary = {
	# ==== ACTS I-II (dream onset) ====
	"Dream Wisp": ["item", [["shimmer_oil", 3], ["clarity_tonic", 1]]],
	"Phantasm": ["item", [["clarity_tonic", 2], ["whetstone", 2]]],
	"Shade Moth": ["item", [["swiftroot", 2], ["shimmer_oil", 2]]],
	"Sleep Stalker": ["item", [["antidote", 2], ["swiftroot", 2]]],
	"Mirror Shade": ["item", [["clarity_tonic", 2], ["whetstone", 2]]],
	"Slumber Beast": ["item", [["whetstone", 2], ["shimmer_oil", 2]]],
	"Fog Wraith": ["item", [["clarity_tonic", 2], ["mind_fog", 2]]],
	"Thorn Dreamer": ["item", [["antidote", 2], ["whetstone", 2]]],
	"Nightmare Hound": ["item", [["swiftroot", 2], ["whetstone", 2]]],
	"Dream Weaver": ["item", [["shimmer_oil", 2], ["clarity_tonic", 2]]],
	"Hollow Echo": ["item", [["clarity_tonic", 2], ["shimmer_oil", 2]]],
	"Somnolent Serpent": ["item", [["antidote", 3], ["swiftroot", 1]]],
	"Twilight Stalker": ["item", [["swiftroot", 2], ["whetstone", 2]]],
	"Waking Terror": ["item", [["whetstone", 2], ["clarity_tonic", 2]]],
	"Dusk Sentinel": ["item", [["galeroot", 2], ["whetstone", 2]]],
	"Shattered Hourglass": ["item", [["ether_shard", 2], ["clarity_tonic", 2]]],
	"Clock Specter": ["item", [["swiftroot", 2], ["ether_shard", 2]]],
	"The Nightmare": ["gold", 60, 100],
	"Nightmare Guard": ["item", [["galeroot", 2], ["whetstone", 2]]],
	"Void Echo": ["item", [["clarity_tonic", 2], ["ether_shard", 2]]],

	# ==== ACT II EXPANSION (dream + waking) ====
	"Thread Lurker": ["item", [["swiftroot", 2], ["whetstone", 2]]],
	"Dream Sentinel": ["item", [["galeroot", 2], ["whetstone", 2]]],
	"Gloom Spinner": ["item", [["mind_fog", 2], ["hex_powder", 2]]],
	"Drowned Reverie": ["item", [["clarity_tonic", 2], ["whetstone", 2]]],
	"Riptide Beast": ["item", [["whetstone", 2], ["shimmer_oil", 2]]],
	"Depth Crawler": ["item", [["whetstone", 2], ["swiftroot", 2]]],
	"Fragment Golem": ["item", [["galeroot", 2], ["whetstone", 2]]],
	"Portrait Wight": ["item", [["clarity_tonic", 2], ["ether_shard", 2]]],
	"Gallery Shade": ["item", [["clarity_tonic", 2], ["whetstone", 2]]],
	"Shadow Pursuer": ["item", [["swiftroot", 2], ["whetstone", 2]]],
	"Dread Tendril": ["item", [["antidote", 2], ["whetstone", 2]]],
	"Faded Voice": ["item", [["shimmer_oil", 2], ["clarity_tonic", 2]]],
	"Market Watcher": ["gold", 30, 50],
	"Thread Smith": ["gold", 30, 50],
	"Hex Herbalist": ["item", [["antidote", 2], ["whetstone", 2]]],
	"Cellar Watcher": ["mixed", 0.5, [["whetstone", 2], ["galeroot", 2]], 25, 40],
	"Thread Construct": ["item", [["galeroot", 2], ["ether_shard", 2]]],
	"Ink Shade": ["item", [["ether_shard", 2], ["clarity_tonic", 2]]],

	# ==== ACT III (cult sanctum) ====
	"Lucid Phantom": ["item", [["clarity_tonic", 2], ["keen_edge", 2]]],
	"Thread Spinner": ["item", [["ether_shard", 2], ["whetstone", 2]]],
	"Loom Sentinel": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Cult Shade": ["item", [["clarity_tonic", 2], ["keen_edge", 2]]],
	"Dream Warden": ["item", [["keen_edge", 2], ["galeroot", 2]]],
	"Thought Leech": ["item", [["enfeebling_dust", 2], ["void_salt", 2]]],
	"Void Spinner": ["item", [["smoke_bomb", 2], ["ether_shard", 2]]],
	"Void Phantom": ["item", [["clarity_tonic", 2], ["keen_edge", 2]]],
	"Rift Mender": ["item", [["keen_edge", 2], ["ether_shard", 2]]],
	"Sanctum Shade": ["item", [["clarity_tonic", 2], ["smoke_bomb", 2]]],
	"Loom Warden": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Sanctum Guardian": ["gold", 60, 90],

	# ==== ACTS IV-V (cult lair) ====
	"Cult Acolyte": ["gold", 40, 60],
	"Cult Enforcer": ["gold", 45, 65],
	"Cult Hexer": ["item", [["enfeebling_dust", 2], ["void_salt", 2]]],
	"Thread Guard": ["gold", 40, 60],
	"Dream Hound": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Ritual Guardian": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Cult Ritualist": ["gold", 50, 70],
	"High Weaver": ["gold", 60, 80],
	"Dread Tailor": ["item", [["smoke_bomb", 2], ["keen_edge", 2]]],
	"Needle Wraith": ["item", [["keen_edge", 2], ["keen_edge", 2]]],
	"Loom Crusher": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Thread Stitcher": ["item", [["ether_shard", 2], ["keen_edge", 2]]],
	"Shadow Fragment": ["item", [["clarity_tonic", 2], ["smoke_bomb", 2]]],
	"The Threadmaster": ["gold", 80, 120],

	# ==== PATH B (suspicion route) ====
	"Cellar Sentinel": ["item", [["galeroot", 2], ["whetstone", 2]]],
	"Bound Stalker": ["item", [["galeroot", 2], ["whetstone", 2]]],
	"Thread Disciple": ["gold", 35, 55],
	"Thread Warden": ["gold", 40, 60],
	"Tunnel Sentinel": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Thread Sniper": ["gold", 40, 55],
	"Pale Devotee": ["gold", 40, 60],
	"Thread Ritualist": ["gold", 45, 65],
	"Passage Guardian": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Warding Shadow": ["item", [["clarity_tonic", 2], ["keen_edge", 2]]],
	"Shadow Innkeeper": ["gold", 50, 70],
	"Astral Weaver": ["item", [["ether_shard", 2], ["smoke_bomb", 2]]],
	"Loom Tendril": ["item", [["keen_edge", 2], ["clarity_tonic", 2]]],
	"Loom Parasite": ["item", [["antidote", 2], ["keen_edge", 2]]],
	"Cathedral Warden": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Dream Binder": ["item", [["clarity_tonic", 2], ["smoke_bomb", 2]]],
	"Thread Anchor": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Weft Stalker": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Lira, the Threadmaster": ["gold", 80, 120],
	"Tattered Deception": ["item", [["clarity_tonic", 2], ["smoke_bomb", 2]]],
	"Dream Bastion": ["item", [["galeroot", 2], ["keen_edge", 2]]],

	# ==== PATH C (Lira's confession) ====
	"Abyssal Dreamer": ["item", [["clarity_tonic", 2], ["keen_edge", 2]]],
	"Thread Devourer": ["item", [["keen_edge", 2], ["smoke_bomb", 2]]],
	"Slumbering Colossus": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Dream Priest": ["gold", 50, 70],
	"Astral Enforcer": ["gold", 50, 70],
	"Oneiric Hexer": ["gold", 45, 65],
	"Oneiric Guardian": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Memory Eater": ["item", [["clarity_tonic", 2], ["ether_shard", 2]]],
	"Nightmare Sentinel": ["item", [["galeroot", 2], ["smoke_bomb", 2]]],
	"Anchor Chain": ["item", [["galeroot", 3], ["keen_edge", 1]]],
	"The Ancient Threadmaster": ["gold", 100, 120],
	"Dream Shackle": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Loom Heart": ["item", [["keen_edge", 2], ["smoke_bomb", 2]]],
}


static func roll_drop(enemy_type: String) -> Dictionary:
	if enemy_type not in _TABLE:
		return LootTableDB.roll_drop(enemy_type)
	var entry: Array = _TABLE[enemy_type]
	var drop_type: String = entry[0]

	match drop_type:
		"gold":
			return {"type": "gold", "amount": randi_range(entry[1], entry[2])}
		"item":
			return {"type": "item", "item": LootTableDB._pick_weighted(entry[1])}
		"mixed":
			if randf() < entry[1]:
				return {"type": "item", "item": LootTableDB._pick_weighted(entry[2])}
			else:
				return {"type": "gold", "amount": randi_range(entry[3], entry[4])}
	return {"type": "item", "item": preload("res://scripts/data/item_db.gd").fire_bomb()}
