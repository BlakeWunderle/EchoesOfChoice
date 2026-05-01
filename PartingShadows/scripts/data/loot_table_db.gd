class_name LootTableDB

## Maps enemy character_type to loot drop entries for Stories 1 and 2.
## Entry format: ["item", [[id, weight], ...]]  or  ["gold", min, max]
## or  ["mixed", item_chance, [[id, weight], ...], gold_min, gold_max]

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
	"Wolf": ["item", [["minor_salve", 3], ["swiftroot", 1]]],
	"Boar": ["item", [["bark_charm", 2], ["minor_salve", 2]]],
	"Thornviper": ["item", [["antidote", 3], ["minor_salve", 1]]],
	"Goblin": ["mixed", 0.7, [["fire_bomb", 2], ["mana_shard", 2]], 10, 20],
	"Hound": ["item", [["swiftroot", 2], ["minor_salve", 2]]],
	"Bandit": ["gold", 20, 30],

	# ==== STORY 1 ACT II ====
	"Raider": ["gold", 25, 40],
	"Orc": ["mixed", 0.5, [["whetstone", 2], ["bark_charm", 2]], 25, 40],
	"Troll": ["item", [["bark_charm", 3], ["iron_draught", 1]]],
	"Harpy": ["item", [["swiftroot", 2], ["antidote", 2]]],
	"Witch": ["item", [["mana_shard", 2], ["clarity_tonic", 2]]],
	"Wisp": ["item", [["mana_shard", 3], ["mana_crystal", 1]]],
	"Treant": ["item", [["bark_charm", 2], ["antidote", 2]]],
	"Siren": ["item", [["clarity_tonic", 2], ["mana_shard", 2]]],
	"Merfolk": ["item", [["healing_potion", 2], ["antidote", 2]]],
	"Captain": ["gold", 30, 50],
	"Pirate": ["gold", 30, 50],
	"Fire Wyrmling": ["item", [["fire_bomb", 2], ["healing_potion", 2]]],
	"Frost Wyrmling": ["item", [["bark_charm", 2], ["healing_potion", 2]]],
	"Ringmaster": ["gold", 35, 50],
	"Harlequin": ["gold", 30, 45],
	"Chanteuse": ["gold", 30, 45],
	"Android": ["mixed", 0.4, [["mana_crystal", 2], ["iron_draught", 2]], 30, 45],
	"Machinist": ["gold", 30, 50],
	"Ironclad": ["item", [["iron_draught", 2], ["bark_charm", 2]]],
	"Commander": ["gold", 35, 55],
	"Draconian": ["item", [["whetstone", 2], ["fire_bomb", 2]]],
	"Chaplain": ["item", [["clarity_tonic", 2], ["healing_potion", 2]]],
	"Zombie": ["item", [["antidote", 3], ["minor_salve", 1]]],
	"Ghoul": ["item", [["antidote", 2], ["clarity_tonic", 2]]],
	"Shade": ["item", [["clarity_tonic", 2], ["mana_shard", 2]]],
	"Wraith": ["item", [["clarity_tonic", 2], ["mana_crystal", 2]]],
	"Boneguard": ["item", [["bark_charm", 2], ["iron_draught", 2]]],

	# ==== STORY 1 ACTS III-V ====
	"Royal Guard": ["gold", 40, 65],
	"Guard Sergeant": ["gold", 45, 70],
	"Guard Archer": ["gold", 40, 60],
	"Stranger": ["gold", 80, 120],
	"Lich": ["item", [["mana_crystal", 2], ["greater_potion", 2]]],
	"Ghast": ["item", [["antidote", 2], ["healing_potion", 2]]],
	"Demon": ["item", [["fire_bomb", 2], ["greater_potion", 2]]],
	"Corrupted Treant": ["item", [["antidote", 2], ["bark_charm", 2]]],
	"Hellion": ["item", [["fire_bomb", 3], ["whetstone", 1]]],
	"Fiendling": ["item", [["fire_bomb", 2], ["mana_shard", 2]]],
	"Dragon": ["item", [["greater_potion", 2], ["smoke_bomb", 2]]],
	"Blighted Stag": ["item", [["antidote", 2], ["healing_potion", 2]]],
	"Dark Knight": ["gold", 50, 80],
	"Fell Hound": ["item", [["swiftroot", 2], ["healing_potion", 2]]],
	"Sigil Wretch": ["item", [["clarity_tonic", 2], ["mana_crystal", 2]]],
	"Tunnel Lurker": ["item", [["healing_potion", 2], ["bark_charm", 2]]],

	# ==== STORY 1 PATH B ====
	"Sigil Colossus": ["item", [["greater_potion", 2], ["iron_draught", 2]]],
	"Ritual Conduit": ["item", [["mana_crystal", 2], ["clarity_tonic", 2]]],
	"Void Sentinel": ["item", [["smoke_bomb", 2], ["greater_potion", 2]]],
	"Void Horror": ["item", [["greater_potion", 3], ["smoke_bomb", 1]]],
	"Fractured Shadow": ["item", [["clarity_tonic", 2], ["healing_potion", 2]]],
	"Shadow Remnant": ["item", [["mana_crystal", 2], ["healing_potion", 2]]],
	"Stranger Undone": ["gold", 100, 120],

	# ==== STORY 2 ACT I (caves) ====
	"Glow Worm": ["item", [["mana_shard", 3], ["minor_salve", 1]]],
	"Crystal Spider": ["item", [["mana_shard", 2], ["antidote", 2]]],
	"Shade Crawler": ["item", [["antidote", 2], ["minor_salve", 2]]],
	"Echo Wisp": ["item", [["mana_shard", 3], ["clarity_tonic", 1]]],
	"Spore Stalker": ["item", [["antidote", 3], ["minor_salve", 1]]],
	"Fungal Hulk": ["item", [["bark_charm", 2], ["antidote", 2]]],
	"Cap Wisp": ["item", [["mana_shard", 2], ["antidote", 2]]],
	"Cavern Snapper": ["item", [["minor_salve", 2], ["bark_charm", 2]]],
	"Cave Eel": ["item", [["swiftroot", 2], ["minor_salve", 2]]],
	"Blind Angler": ["item", [["minor_salve", 2], ["swiftroot", 2]]],
	"Silt Lurker": ["item", [["bark_charm", 2], ["minor_salve", 2]]],
	"Cave Dweller": ["mixed", 0.5, [["whetstone", 2], ["minor_salve", 2]], 15, 25],
	"Tunnel Shaman": ["item", [["mana_shard", 2], ["clarity_tonic", 2]]],
	"Burrow Scout": ["mixed", 0.5, [["swiftroot", 2], ["minor_salve", 2]], 15, 25],
	"Cave Maw": ["item", [["healing_potion", 2], ["bark_charm", 2]]],
	"Vein Leech": ["item", [["antidote", 2], ["minor_salve", 2]]],
	"Stone Moth": ["item", [["mana_shard", 2], ["swiftroot", 2]]],

	# ==== STORY 2 ACT II (shore) ====
	"Driftwood Bandit": ["gold", 25, 40],
	"Saltrunner Smuggler": ["gold", 30, 45],
	"Tide Warden": ["gold", 30, 45],
	"Tideside Channeler": ["item", [["mana_crystal", 2], ["clarity_tonic", 2]]],
	"Reef Shaman": ["item", [["mana_shard", 2], ["healing_potion", 2]]],
	"Blighted Gull": ["item", [["swiftroot", 2], ["antidote", 2]]],
	"Shore Crawler": ["item", [["bark_charm", 2], ["healing_potion", 2]]],
	"Warped Hound": ["item", [["swiftroot", 2], ["healing_potion", 2]]],
	"Blackwater Captain": ["gold", 40, 60],
	"Corsair Hexer": ["gold", 35, 55],
	"Bilge Rat": ["gold", 25, 40],
	"Abyssal Lurker": ["item", [["healing_potion", 2], ["iron_draught", 2]]],
	"Stormwrack Raptor": ["item", [["swiftroot", 2], ["whetstone", 2]]],
	"Tidecaller Revenant": ["item", [["clarity_tonic", 2], ["mana_crystal", 2]]],
	"Salt Phantom": ["item", [["clarity_tonic", 2], ["healing_potion", 2]]],
	"Drowned Sailor": ["gold", 30, 45],
	"Depth Horror": ["item", [["greater_potion", 2], ["iron_draught", 2]]],

	# ==== STORY 2 ACT III (archive) ====
	"Memory Wisp": ["item", [["mana_crystal", 2], ["clarity_tonic", 2]]],
	"Shattered Frame": ["item", [["clarity_tonic", 2], ["healing_potion", 2]]],
	"Echo Sentinel": ["item", [["iron_draught", 2], ["healing_potion", 2]]],
	"Thought Eater": ["item", [["mana_crystal", 2], ["clarity_tonic", 2]]],
	"Grief Shade": ["item", [["clarity_tonic", 3], ["healing_potion", 1]]],
	"Sorrow Shade": ["item", [["clarity_tonic", 2], ["mana_crystal", 2]]],
	"Hollow Watcher": ["item", [["healing_potion", 2], ["bark_charm", 2]]],
	"Mirror Self": ["item", [["greater_potion", 2], ["clarity_tonic", 2]]],
	"Void Weaver": ["item", [["mana_crystal", 2], ["smoke_bomb", 2]]],
	"Mnemonic Golem": ["item", [["iron_draught", 2], ["greater_potion", 2]]],
	"The Warden": ["gold", 60, 100],
	"Fractured Protector": ["item", [["iron_draught", 2], ["healing_potion", 2]]],
	"Fading Wisp": ["item", [["mana_shard", 2], ["clarity_tonic", 2]]],
	"Dim Guardian": ["item", [["bark_charm", 2], ["healing_potion", 2]]],
	"Ward Construct": ["item", [["iron_draught", 2], ["bark_charm", 2]]],
	"Null Phantom": ["item", [["clarity_tonic", 2], ["mana_crystal", 2]]],
	"Threshold Echo": ["item", [["clarity_tonic", 2], ["healing_potion", 2]]],
	"Ink Devourer": ["item", [["mana_crystal", 2], ["greater_potion", 2]]],
	"Silent Archivist": ["item", [["mana_crystal", 2], ["clarity_tonic", 2]]],
	"Lost Record": ["item", [["clarity_tonic", 2], ["mana_shard", 2]]],
	"Maw Codex": ["item", [["greater_potion", 2], ["mana_crystal", 2]]],

	# ==== STORY 2 ACT IV (eye) ====
	"Pupil Leech": ["item", [["healing_potion", 2], ["antidote", 2]]],
	"Gaze Stalker": ["item", [["swiftroot", 2], ["greater_potion", 2]]],
	"Memory Harvester": ["item", [["clarity_tonic", 2], ["mana_crystal", 2]]],
	"Oblivion Shade": ["item", [["greater_potion", 2], ["clarity_tonic", 2]]],
	"Memory Reaper": ["item", [["greater_potion", 2], ["smoke_bomb", 2]]],
	"Void Iris": ["item", [["smoke_bomb", 2], ["greater_potion", 2]]],
	"Thoughtform Knight": ["item", [["iron_draught", 2], ["greater_potion", 2]]],
	"The Iris": ["gold", 70, 100],
	"The Lidless Eye": ["gold", 80, 120],

	# ==== STORY 2 PATH B ====
	"Fractured Scholar": ["item", [["mana_crystal", 2], ["clarity_tonic", 2]]],
	"Archive Sentinel": ["item", [["iron_draught", 2], ["greater_potion", 2]]],
	"Pipeline Warden": ["item", [["bark_charm", 2], ["healing_potion", 2]]],
	"Maintenance Drone": ["mixed", 0.4, [["mana_crystal", 2], ["iron_draught", 2]], 40, 60],
	"Resonance Node": ["item", [["mana_crystal", 3], ["clarity_tonic", 1]]],
	"Eye's Fist": ["item", [["whetstone", 2], ["greater_potion", 2]]],
	"Null Sentinel": ["item", [["iron_draught", 2], ["smoke_bomb", 2]]],
	"Overload Spark": ["item", [["mana_crystal", 2], ["fire_bomb", 2]]],
	"Memory Torrent": ["item", [["greater_potion", 2], ["clarity_tonic", 2]]],
	"Unleashed Recollection": ["item", [["clarity_tonic", 2], ["greater_potion", 2]]],
	"Rage Fragment": ["item", [["whetstone", 2], ["fire_bomb", 2]]],
	"The Unblinking Eye": ["gold", 80, 120],
	"Perception Tendril": ["item", [["clarity_tonic", 2], ["healing_potion", 2]]],
	"Void Lens": ["item", [["smoke_bomb", 2], ["mana_crystal", 2]]],
}


static func roll_drop(enemy_type: String) -> Dictionary:
	var entry: Array = _TABLE.get(enemy_type, ["item", [["minor_salve", 1]]])
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
	return {"type": "item", "item": ItemDB.minor_salve()}


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
