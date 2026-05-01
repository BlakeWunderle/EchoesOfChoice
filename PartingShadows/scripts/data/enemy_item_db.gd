class_name EnemyItemDB

## Maps enemy character_type to battle items they carry.
## Only humanoid/intelligent enemies carry items. Beasts, constructs,
## and dream creatures do not.
## Items scale with story progression: early = minor, late = potent.

const ItemDB := preload("res://scripts/data/item_db.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")


static func assign_items(fighter: FighterData) -> void:
	var items: Array = _get_items(fighter.character_type)
	if not items.is_empty():
		fighter.battle_items = items


static func _get_items(character_type: String) -> Array:
	match character_type:
		# ==================================================================
		# Story 1 - Act I (early: minor salves)
		# ==================================================================
		"Thug": return [ItemDB.minor_salve()]
		"Ruffian": return [ItemDB.minor_salve()]
		"Bandit": return [ItemDB.minor_salve()]

		# ==================================================================
		# Story 1 - Act II (mid: healing potions, some buffs)
		# ==================================================================
		"Raider": return [ItemDB.whetstone()]
		"Orc": return [ItemDB.minor_salve()]
		"Captain": return [ItemDB.healing_potion(), ItemDB.whetstone()]
		"Pirate": return [ItemDB.healing_potion()]
		"Commander": return [ItemDB.healing_potion(), ItemDB.whetstone()]
		"Chaplain": return [ItemDB.healing_potion()]
		"Ringmaster": return [ItemDB.healing_potion()]

		# ==================================================================
		# Story 1 - Acts III-V (late: better items)
		# ==================================================================
		"Royal Guard": return [ItemDB.healing_potion()]
		"Guard Sergeant": return [ItemDB.healing_potion(), ItemDB.bark_charm()]
		"Guard Archer": return [ItemDB.healing_potion()]
		"Dark Knight": return [ItemDB.healing_potion(), ItemDB.whetstone()]
		"Stranger": return [ItemDB.healing_potion(), ItemDB.healing_potion()]
		"StrangerFinal": return [ItemDB.greater_potion()]
		"StrangerUndone": return [ItemDB.greater_potion()]
		"Lich": return [ItemDB.mana_shard()]

		# ==================================================================
		# Story 2 - Act I (cave humanoids)
		# ==================================================================
		"Cave Dweller": return [ItemDB.minor_salve()]
		"Tunnel Shaman": return [ItemDB.mana_shard()]
		"Burrow Scout": return [ItemDB.minor_salve()]

		# ==================================================================
		# Story 2 - Act II (coastal humanoids)
		# ==================================================================
		"Driftwood Bandit": return [ItemDB.minor_salve()]
		"Saltrunner Smuggler": return [ItemDB.healing_potion()]
		"Tide Warden": return [ItemDB.bark_charm()]
		"Blackwater Captain": return [ItemDB.healing_potion(), ItemDB.whetstone()]
		"Corsair Hexer": return [ItemDB.mana_shard()]
		"Drowned Sailor": return [ItemDB.minor_salve()]

		# ==================================================================
		# Story 2 - Acts III-IV (sanctum/memory enemies)
		# ==================================================================
		"Silent Archivist": return [ItemDB.mana_shard()]
		"Fractured Protector": return [ItemDB.healing_potion()]
		"Thoughtform Knight": return [ItemDB.bark_charm()]
		"The Warden": return [ItemDB.healing_potion()]
		"The Iris": return [ItemDB.healing_potion()]
		"The Lidless Eye": return [ItemDB.greater_potion()]

		# ==================================================================
		# Story 2 - Path B
		# ==================================================================
		"Fractured Scholar": return [ItemDB.healing_potion()]
		"The Unblinking Eye": return [ItemDB.greater_potion()]

		# ==================================================================
		# Story 3 - Acts I-II (town/investigation humanoids)
		# ==================================================================
		"Market Watcher": return [ItemDB.healing_potion()]
		"Thread Smith": return [ItemDB.whetstone()]
		"Hex Herbalist": return [ItemDB.antidote()]

		# ==================================================================
		# Story 3 - Acts III-V (cult members)
		# ==================================================================
		"Cult Acolyte": return [ItemDB.healing_potion()]
		"Cult Enforcer": return [ItemDB.bark_charm()]
		"Cult Hexer": return [ItemDB.mana_shard()]
		"Cult Ritualist": return [ItemDB.mana_shard()]
		"Thread Guard": return [ItemDB.whetstone()]
		"High Weaver": return [ItemDB.healing_potion()]
		"The Threadmaster": return [ItemDB.greater_potion()]

		# ==================================================================
		# Story 3 - Path B
		# ==================================================================
		"Thread Disciple": return [ItemDB.healing_potion()]
		"Thread Warden": return [ItemDB.bark_charm()]
		"Pale Devotee": return [ItemDB.mana_shard()]
		"Shadow Innkeeper": return [ItemDB.healing_potion()]
		"Lira, the Threadmaster": return [ItemDB.greater_potion()]

		# ==================================================================
		# Story 3 - Path C
		# ==================================================================
		"Dream Priest": return [ItemDB.mana_shard()]
		"Astral Enforcer": return [ItemDB.whetstone()]
		"The Ancient Threadmaster": return [ItemDB.greater_potion()]

	return []
