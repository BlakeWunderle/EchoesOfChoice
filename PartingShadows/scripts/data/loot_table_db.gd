class_name LootTableDB

## Maps enemy character_type to loot drop entries for Stories 1 and 2.
## Entry format: ["item", [[id, weight], ...]]  or  ["gold", min, max]
## or  ["mixed", item_chance, [[id, weight], ...], gold_min, gold_max]
## No healing items. All item drops are combat effects.

const ItemDB := preload("res://scripts/data/item_db.gd")
const ItemData := preload("res://scripts/data/item_data.gd")

# -- Story 1 Act I (Prog 0-2) ------------------------------------------------
# -- Story 1 Act II (Prog 3-7) -----------------------------------------------
# -- Story 1 Acts III-V (Prog 8-13) ------------------------------------------
# -- Story 1 Path B -----------------------------------------------------------
# -- Story 2 Act I (caves) ----------------------------------------------------
# -- Story 2 Act II (shore) ---------------------------------------------------
# -- Story 2 Act III (archive) ------------------------------------------------
# -- Story 2 Act IV (eye) -----------------------------------------------------
# -- Story 2 Path B -----------------------------------------------------------

const _TABLE: Dictionary = {
	# ==== STORY 1 ACT I ====
	"Thug": ["gold", 15, 25],
	"Ruffian": ["gold", 15, 25],
	"Pickpocket": ["gold", 20, 30],
	"Wolf": ["item", [["swiftroot", 3], ["whetstone", 1]]],
	"Boar": ["item", [["whetstone", 3], ["whetstone", 1]]],
	"Thornviper": ["item", [["antidote", 3], ["swiftroot", 1]]],
	"Goblin": ["mixed", 0.7, [["cinder_bomb", 2], ["shimmer_oil", 2]], 10, 20],
	"Hound": ["item", [["swiftroot", 3], ["whetstone", 1]]],
	"Bandit": ["gold", 20, 30],

	# ==== STORY 1 ACT II ====
	"Raider": ["gold", 25, 40],
	"Orc": ["mixed", 0.5, [["whetstone", 2], ["shimmer_oil", 2]], 25, 40],
	"Troll": ["item", [["whetstone", 3], ["galeroot", 1]]],
	"Harpy": ["item", [["swiftroot", 2], ["antidote", 2]]],
	"Witch": ["item", [["hex_powder", 2], ["clarity_tonic", 2]]],
	"Wisp": ["item", [["shimmer_oil", 3], ["ether_shard", 1]]],
	"Treant": ["item", [["whetstone", 2], ["antidote", 2]]],
	"Siren": ["item", [["clarity_tonic", 2], ["shimmer_oil", 2]]],
	"Merfolk": ["item", [["shimmer_oil", 2], ["antidote", 2]]],
	"Captain": ["gold", 30, 50],
	"Pirate": ["gold", 30, 50],
	"Fire Wyrmling": ["item", [["cinder_bomb", 2], ["fire_bomb", 2]]],
	"Frost Wyrmling": ["item", [["whetstone", 2], ["shimmer_oil", 2]]],
	"Ringmaster": ["gold", 35, 50],
	"Harlequin": ["gold", 30, 45],
	"Chanteuse": ["gold", 30, 45],
	"Android": ["mixed", 0.4, [["ether_shard", 2], ["galeroot", 2]], 30, 45],
	"Machinist": ["gold", 30, 50],
	"Ironclad": ["item", [["galeroot", 2], ["whetstone", 2]]],
	"Commander": ["gold", 35, 55],
	"Draconian": ["item", [["whetstone", 2], ["fire_bomb", 2]]],
	"Chaplain": ["item", [["clarity_tonic", 3], ["antidote", 1]]],
	"Zombie": ["item", [["antidote", 3], ["whetstone", 1]]],
	"Ghoul": ["item", [["antidote", 2], ["clarity_tonic", 2]]],
	"Shade": ["item", [["clarity_tonic", 2], ["mind_fog", 2]]],
	"Wraith": ["item", [["clarity_tonic", 2], ["ether_shard", 2]]],
	"Boneguard": ["item", [["whetstone", 2], ["galeroot", 2]]],

	# ==== STORY 1 ACTS III-V ====
	"Royal Guard": ["gold", 40, 65],
	"Guard Sergeant": ["gold", 45, 70],
	"Guard Archer": ["gold", 40, 60],
	"Stranger": ["gold", 80, 120],
	"Lich": ["item", [["enfeebling_dust", 2], ["void_salt", 2]]],
	"Ghast": ["item", [["antidote", 2], ["clarity_tonic", 2]]],
	"Demon": ["item", [["fire_bomb", 2], ["keen_edge", 2]]],
	"Corrupted Treant": ["item", [["antidote", 2], ["galeroot", 2]]],
	"Hellion": ["item", [["fire_bomb", 3], ["keen_edge", 1]]],
	"Fiendling": ["item", [["fire_bomb", 2], ["ether_shard", 2]]],
	"Dragon": ["item", [["smoke_bomb", 2], ["galeroot", 2]]],
	"Blighted Stag": ["item", [["antidote", 2], ["swiftroot", 2]]],
	"Dark Knight": ["gold", 50, 80],
	"Fell Hound": ["item", [["galeroot", 2], ["whetstone", 2]]],
	"Sigil Wretch": ["item", [["clarity_tonic", 2], ["ether_shard", 2]]],
	"Tunnel Lurker": ["item", [["galeroot", 2], ["whetstone", 2]]],

	# ==== STORY 1 PATH B ====
	"Sigil Colossus": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Ritual Conduit": ["item", [["ether_shard", 2], ["clarity_tonic", 2]]],
	"Void Sentinel": ["item", [["smoke_bomb", 2], ["galeroot", 2]]],
	"Void Horror": ["item", [["smoke_bomb", 3], ["keen_edge", 1]]],
	"Fractured Shadow": ["item", [["clarity_tonic", 2], ["ether_shard", 2]]],
	"Shadow Remnant": ["item", [["ether_shard", 2], ["galeroot", 2]]],
	"Stranger Undone": ["gold", 100, 120],

	# ==== STORY 2 ACT I (caves) ====
	"Glow Worm": ["item", [["shimmer_oil", 3], ["swiftroot", 1]]],
	"Crystal Spider": ["item", [["shimmer_oil", 2], ["antidote", 2]]],
	"Shade Crawler": ["item", [["antidote", 2], ["whetstone", 2]]],
	"Echo Wisp": ["item", [["shimmer_oil", 3], ["clarity_tonic", 1]]],
	"Spore Stalker": ["item", [["antidote", 3], ["swiftroot", 1]]],
	"Fungal Hulk": ["item", [["whetstone", 2], ["antidote", 2]]],
	"Cap Wisp": ["item", [["shimmer_oil", 2], ["antidote", 2]]],
	"Cavern Snapper": ["item", [["whetstone", 2], ["shimmer_oil", 2]]],
	"Cave Eel": ["item", [["swiftroot", 2], ["shimmer_oil", 2]]],
	"Blind Angler": ["item", [["swiftroot", 2], ["whetstone", 2]]],
	"Silt Lurker": ["item", [["whetstone", 2], ["swiftroot", 2]]],
	"Cave Dweller": ["mixed", 0.5, [["whetstone", 2], ["shimmer_oil", 2]], 15, 25],
	"Tunnel Shaman": ["item", [["hex_powder", 2], ["mind_fog", 2]]],
	"Burrow Scout": ["mixed", 0.5, [["swiftroot", 2], ["whetstone", 2]], 15, 25],
	"Cave Maw": ["item", [["whetstone", 2], ["galeroot", 2]]],
	"Vein Leech": ["item", [["antidote", 2], ["swiftroot", 2]]],
	"Stone Moth": ["item", [["shimmer_oil", 2], ["swiftroot", 2]]],

	# ==== STORY 2 ACT II (shore) ====
	"Driftwood Bandit": ["gold", 25, 40],
	"Saltrunner Smuggler": ["gold", 30, 45],
	"Tide Warden": ["gold", 30, 45],
	"Tideside Channeler": ["item", [["ether_shard", 2], ["clarity_tonic", 2]]],
	"Reef Shaman": ["item", [["shimmer_oil", 2], ["fire_bomb", 2]]],
	"Blighted Gull": ["item", [["swiftroot", 2], ["antidote", 2]]],
	"Shore Crawler": ["item", [["whetstone", 2], ["shimmer_oil", 2]]],
	"Warped Hound": ["item", [["swiftroot", 2], ["galeroot", 2]]],
	"Blackwater Captain": ["gold", 40, 60],
	"Corsair Hexer": ["item", [["hex_powder", 2], ["mind_fog", 2]]],
	"Bilge Rat": ["gold", 25, 40],
	"Abyssal Lurker": ["item", [["galeroot", 2], ["whetstone", 2]]],
	"Stormwrack Raptor": ["item", [["swiftroot", 2], ["whetstone", 2]]],
	"Tidecaller Revenant": ["item", [["clarity_tonic", 2], ["ether_shard", 2]]],
	"Salt Phantom": ["item", [["clarity_tonic", 2], ["ether_shard", 2]]],
	"Drowned Sailor": ["gold", 30, 45],
	"Depth Horror": ["item", [["galeroot", 2], ["keen_edge", 2]]],

	# ==== STORY 2 ACT III (archive) ====
	"Memory Wisp": ["item", [["ether_shard", 2], ["clarity_tonic", 2]]],
	"Shattered Frame": ["item", [["clarity_tonic", 2], ["galeroot", 2]]],
	"Echo Sentinel": ["item", [["galeroot", 2], ["whetstone", 2]]],
	"Thought Eater": ["item", [["enfeebling_dust", 2], ["clarity_tonic", 2]]],
	"Grief Shade": ["item", [["mind_fog", 3], ["void_salt", 1]]],
	"Sorrow Shade": ["item", [["hex_powder", 2], ["mind_fog", 2]]],
	"Hollow Watcher": ["item", [["galeroot", 2], ["smoke_bomb", 2]]],
	"Mirror Self": ["item", [["keen_edge", 2], ["clarity_tonic", 2]]],
	"Void Weaver": ["item", [["ether_shard", 2], ["smoke_bomb", 2]]],
	"Mnemonic Golem": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"The Warden": ["gold", 60, 100],
	"Fractured Protector": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Fading Wisp": ["item", [["shimmer_oil", 2], ["clarity_tonic", 2]]],
	"Dim Guardian": ["item", [["galeroot", 2], ["whetstone", 2]]],
	"Ward Construct": ["item", [["galeroot", 2], ["whetstone", 2]]],
	"Null Phantom": ["item", [["clarity_tonic", 2], ["ether_shard", 2]]],
	"Threshold Echo": ["item", [["clarity_tonic", 2], ["smoke_bomb", 2]]],
	"Ink Devourer": ["item", [["ether_shard", 2], ["keen_edge", 2]]],
	"Silent Archivist": ["item", [["ether_shard", 2], ["clarity_tonic", 2]]],
	"Lost Record": ["item", [["clarity_tonic", 2], ["ether_shard", 2]]],
	"Maw Codex": ["item", [["ether_shard", 2], ["smoke_bomb", 2]]],

	# ==== STORY 2 ACT IV (eye) ====
	"Pupil Leech": ["item", [["antidote", 2], ["clarity_tonic", 2]]],
	"Gaze Stalker": ["item", [["swiftroot", 2], ["galeroot", 2]]],
	"Memory Harvester": ["item", [["clarity_tonic", 2], ["ether_shard", 2]]],
	"Oblivion Shade": ["item", [["smoke_bomb", 2], ["clarity_tonic", 2]]],
	"Memory Reaper": ["item", [["smoke_bomb", 2], ["keen_edge", 2]]],
	"Void Iris": ["item", [["smoke_bomb", 2], ["ether_shard", 2]]],
	"Thoughtform Knight": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"The Iris": ["gold", 70, 100],
	"The Lidless Eye": ["gold", 80, 120],

	# ==== STORY 2 PATH B ====
	"Fractured Scholar": ["item", [["ether_shard", 2], ["clarity_tonic", 2]]],
	"Archive Sentinel": ["item", [["galeroot", 2], ["keen_edge", 2]]],
	"Pipeline Warden": ["item", [["galeroot", 2], ["smoke_bomb", 2]]],
	"Maintenance Drone": ["mixed", 0.4, [["ether_shard", 2], ["galeroot", 2]], 40, 60],
	"Resonance Node": ["item", [["ether_shard", 3], ["clarity_tonic", 1]]],
	"Eye's Fist": ["item", [["keen_edge", 2], ["galeroot", 2]]],
	"Null Sentinel": ["item", [["galeroot", 2], ["smoke_bomb", 2]]],
	"Overload Spark": ["item", [["ether_shard", 2], ["fire_bomb", 2]]],
	"Memory Torrent": ["item", [["keen_edge", 2], ["clarity_tonic", 2]]],
	"Unleashed Recollection": ["item", [["clarity_tonic", 2], ["galeroot", 2]]],
	"Rage Fragment": ["item", [["keen_edge", 2], ["fire_bomb", 2]]],
	"The Unblinking Eye": ["gold", 80, 120],
	"Perception Tendril": ["item", [["clarity_tonic", 2], ["ether_shard", 2]]],
	"Void Lens": ["item", [["smoke_bomb", 2], ["ether_shard", 2]]],
}


static func roll_drop(enemy_type: String) -> Dictionary:
	var entry: Array = _TABLE.get(enemy_type, ["item", [["fire_bomb", 1]]])
	var drop_type: String = entry[0]

	match drop_type:
		"gold":
			var amount: int = randi_range(entry[1], entry[2])
			return {"type": "gold", "amount": amount}
		"item":
			var item: ItemData = _pick_weighted(entry[1])
			return {"type": "item", "item": item}
		"mixed":
			if randf() < entry[1]:
				var item: ItemData = _pick_weighted(entry[2])
				return {"type": "item", "item": item}
			else:
				var amount: int = randi_range(entry[3], entry[4])
				return {"type": "gold", "amount": amount}
	return {"type": "item", "item": ItemDB.fire_bomb()}


static func _pick_weighted(pool: Array) -> ItemData:
	var total: int = 0
	for p: Array in pool:
		total += p[1]
	var roll: int = randi_range(0, total - 1)
	var acc: int = 0
	for p: Array in pool:
		acc += p[1]
		if roll < acc:
			return ItemDB.create_by_id(p[0])
	return ItemDB.create_by_id(pool[0][0])
