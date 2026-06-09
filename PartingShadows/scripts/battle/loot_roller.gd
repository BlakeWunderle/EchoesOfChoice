class_name LootRoller

## Rolls post-battle loot drops using an escalating pity timer.
## Each enemy is rolled in sequence: 33% base chance, escalating to
## 50% then 67% on consecutive failures, resetting on success.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const ItemData := preload("res://scripts/data/item_data.gd")
const LootTableDB := preload("res://scripts/data/loot_table_db.gd")
const LootTableDBS3 := preload("res://scripts/data/loot_table_db_s3.gd")


static func roll_drops(enemies: Array, story_id: String = "") -> Dictionary:
	## Returns {"items": Array of ItemData, "gold": int}
	var items: Array = []
	var gold: int = 0
	var chance: float = 0.3333
	var use_s3: bool = story_id == "story_3"

	for enemy: FighterData in enemies:
		if randf() < chance:
			var drop: Dictionary
			if use_s3:
				drop = LootTableDBS3.roll_drop(enemy.character_type)
			else:
				drop = LootTableDB.roll_drop(enemy.character_type)
			match drop.type:
				"item":
					items.append(drop.item)
				"gold":
					gold += drop.amount
			chance = 0.3333
		else:
			if chance < 0.34:
				chance = 0.50
			elif chance < 0.51:
				chance = 0.6667
	return {"items": items, "gold": gold}
