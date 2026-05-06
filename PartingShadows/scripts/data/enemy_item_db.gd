class_name EnemyItemDB

## Maps battle_id to the enemy team's shared item loadout.
## Items are shared across all enemies (like player party inventory).
## Design target: -2 to -3pp win rate delta per battle when items are active.
## No healing items. All items are combat effects (buffs, damage, cures).

const ItemDB := preload("res://scripts/data/item_db.gd")


static func get_battle_items(battle_id: String) -> Array:
	match battle_id:
		# ==============================================================
		# Story 1 - Act I (T0: minor items)
		# ==============================================================
		"BeachBattle": return [ItemDB.swiftroot()]
		"WaypointDefenseBattle": return [ItemDB.cinder_bomb()]

		# ==============================================================
		# Story 1 - Act II (T1: standard buffs)
		# ==============================================================
		"HighlandBattle": return [ItemDB.cinder_bomb()]
		"CircusBattle": return [ItemDB.smoke_bomb()]
		"ArmyBattle": return [ItemDB.whetstone()]
		"CemeteryBattle": return [ItemDB.shimmer_oil()]
		"OutpostDefenseBattle": return [ItemDB.hex_powder()]

		# ==============================================================
		# Story 1 - Acts III-V (T2: potent items)
		# ==============================================================
		"GateBattle": return [ItemDB.war_drum()]
		"StrangerFinalBattle": return [ItemDB.ether_shard()]

		# ==============================================================
		# Story 1 - Path B
		# ==============================================================

		# ==============================================================
		# Story 2 - Act I (T0: cave items)
		# ==============================================================
		"S2_FungalHollow": return [ItemDB.hex_powder()]
		"S2_CaveExit": return [ItemDB.swiftroot()]

		# ==============================================================
		# Story 2 - Act II (T1: coastal items)
		# ==============================================================
		"S2_SmugglersBluff": return [ItemDB.whetstone()]
		"S2_WreckersCove": return [ItemDB.fire_bomb()]
		"S2_CoastalRuins": return [ItemDB.mind_fog()]

		# ==============================================================
		# Story 2 - Acts III-IV (T2: sanctum items)
		# ==============================================================
		"S2_EchoGallery": return [ItemDB.ether_shard()]
		"S2_GuardiansThreshold": return [ItemDB.enfeebling_dust()]

		# ==============================================================
		# Story 2 - Path B
		# ==============================================================
		"S2_B_ResonanceChamber": return [ItemDB.keen_edge()]
		"S2_B_EyeUnblinking": return [ItemDB.war_drum()]

		# ==============================================================
		# Story 3 - Acts I-II (T0-T1: investigation items)
		# ==============================================================
		"S3_DreamShadowChase": return [ItemDB.swiftroot()]
		"S3_DreamNightmare": return [ItemDB.mind_fog()]
		"S3_DreamClockTower": return [ItemDB.whetstone()]

		# ==============================================================
		# Story 3 - Acts III-V (T2: cult items)
		# ==============================================================
		"S3_CultCatacombs": return [ItemDB.blast_powder()]
		"S3_DreamVoid": return [ItemDB.ether_shard()]
		"S3_DreamNexus": return [ItemDB.war_drum()]

		# ==============================================================
		# Story 3 - Path B
		# ==============================================================
		"S3_B_DreamNexus": return [ItemDB.galeroot()]

		# ==============================================================
		# Story 3 - Path C
		# ==============================================================
		"S3_C_CultInterception": return [ItemDB.keen_edge()]
		"S3_C_DreamNexus": return [ItemDB.spell_prism()]

	return []
