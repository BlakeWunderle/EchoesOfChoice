class_name BattleDB

## Battle router: dispatches battle_id to the appropriate act/story module.

const BattleData := preload("res://scripts/data/battle_data.gd")
const Act1 := preload("res://scripts/data/story1/battle_db_act1.gd")
const Act2 := preload("res://scripts/data/story1/battle_db_act2.gd")
const Act3 := preload("res://scripts/data/story1/battle_db_act3.gd")
const Act45 := preload("res://scripts/data/story1/battle_db_act45.gd")
const Act5B := preload("res://scripts/data/story1/battle_db_act5b.gd")
const S2 := preload("res://scripts/data/story2/battle_db_s2.gd")
const S2Act2 := preload("res://scripts/data/story2/battle_db_s2_act2.gd")
const S2Act3 := preload("res://scripts/data/story2/battle_db_s2_act3.gd")
const S2Act4 := preload("res://scripts/data/story2/battle_db_s2_act4.gd")
const S2PathB := preload("res://scripts/data/story2/battle_db_s2_pathb.gd")
const S3 := preload("res://scripts/data/story3/battle_db_s3.gd")
const S3Act3 := preload("res://scripts/data/story3/battle_db_s3_act3.gd")
const S3Act45 := preload("res://scripts/data/story3/battle_db_s3_act45.gd")
const S3Act2 := preload("res://scripts/data/story3/battle_db_s3_act2.gd")
const S3PathB := preload("res://scripts/data/story3/battle_db_s3_pathb.gd")
const S3PathC := preload("res://scripts/data/story3/battle_db_s3_pathc.gd")


static func create_battle(battle_id: String) -> BattleData:
	match battle_id:
		# Story 1 - Act I
		"CityStreetBattle": return Act1.city_street_battle()
		"WolfForestBattle": return Act1.wolf_forest_battle()
		"WaypointDefenseBattle": return Act1.waypoint_defense_battle()
		"ForestWaypoint": return Act1.forest_waypoint()
		# Story 1 - Act II
		"HighlandBattle": return Act2.highland_battle()
		"DeepForestBattle": return Act2.deep_forest_battle()
		"ShoreBattle": return Act2.shore_battle()
		"MountainPassBattle": return Act2.mountain_pass_battle()
		"CaveBattle": return Act2.cave_battle()
		"BeachBattle": return Act2.beach_battle()
		"WildernessOutpost": return Act2.wilderness_outpost()
		"CircusBattle": return Act2.circus_battle()
		"LabBattle": return Act2.lab_battle()
		"ArmyBattle": return Act2.army_battle()
		"CemeteryBattle": return Act2.cemetery_battle()
		"OutpostDefenseBattle": return Act2.outpost_defense_battle()
		"MirrorBattle": return Act2.mirror_battle()
		# Story 1 - Act III
		"CityOutskirtsStop": return Act3.city_outskirts_stop()
		"ReturnToCityStreetBattle": return Act3.return_to_city_street_battle()
		"StrangerTowerBattle": return Act3.stranger_tower_battle()
		# Story 1 - Acts IV-V
		"CopperMugStop": return Act45.copper_mug_stop()
		"CorruptedCityBattle": return Act45.corrupted_city_battle()
		"CorruptedWildsBattle": return Act45.corrupted_wilds_battle()
		"DepthsBattle": return Act45.depths_battle()
		"GateBattle": return Act45.gate_battle()
		"StrangerFinalBattle": return Act45.stranger_final_battle()
		# Story 1 - Act V Path B (sever the ritual)
		"RitualAnchorBattle", "SanctumCollapseBattle", \
		"StrangerUndoneBattle":
			return Act5B.create_battle(battle_id)
		# Story 2 - Act I
		"S2_CaveAwakening", "S2_DeepCavern", "S2_FungalHollow", \
		"S2_TranquilPool", "S2_TorchChamber", "S2_CaveMerchant", \
		"S2_CaveExit":
			return S2.create_battle(battle_id)
		# Story 2 - Act II
		"S2_CoastalDescent", "S2_FishingVillage", "S2_SmugglersBluff", \
		"S2_HarborTown", "S2_WreckersCove", "S2_CoastalRuins", \
		"S2_BlackwaterBay", "S2_LighthouseStorm":
			return S2Act2.create_battle(battle_id)
		# Story 2 - Act III
		"S2_BeneathTheLighthouse", "S2_MemoryVault", "S2_EchoGallery", \
		"S2_ShatteredSanctum", "S2_GuardiansThreshold", \
		"S2_ForgottenArchive", "S2_TheReveal":
			return S2Act3.create_battle(battle_id)
		# Story 2 - Act IV
		"S2_CoastalCamp", "S2_DepthsOfRemembrance", "S2_MawOfTheEye", \
		"S2_EyeAwakening", "S2_EyeOfOblivion":
			return S2Act4.create_battle(battle_id)
		# Story 2 - Path B (Save Sera)
		"S2_B_ArchiveAwakening", "S2_B_LighthouseCore", \
		"S2_B_ResonanceChamber", "S2_B_MemoryFlood", \
		"S2_B_EyeUnblinking":
			return S2PathB.create_battle(battle_id)
		# Story 3 - Acts I-II
		"S3_WearyTraveler", "S3_DreamMeadow", "S3_DreamMirrorHall", \
		"S3_DreamFogGarden", "S3_TownMorning", "S3_DreamReturn", \
		"S3_DreamLabyrinth", "S3_DreamClockTower", "S3_DreamNightmare":
			return S3.create_battle(battle_id)
		# Story 3 - Act II expansion (extended dream + waking investigation)
		"S3_DreamThreads", "S3_DreamDrownedCorridor", \
		"S3_DreamShatteredGallery", "S3_DreamShadowChase", \
		"S3_TownInvestigation", "S3_MarketConfrontation", \
		"S3_CellarDiscovery":
			return S3Act2.create_battle(battle_id)
		# Story 3 - Act III
		"S3_TownRealization", "S3_LucidDream", "S3_DreamTemple", \
		"S3_DreamVoid", "S3_DreamSanctum":
			return S3Act3.create_battle(battle_id)
		# Story 3 - Acts IV-V
		"S3_CultUnderbelly", "S3_CultCatacombs", \
		"S3_CultRitualChamber", "S3_DreamNexus":
			return S3Act45.create_battle(battle_id)
		# Story 3 - Path B (investigation path)
		"S3_B_InnSearch", "S3_B_CultConfrontation", "S3_B_CallumsTruth", \
		"S3_B_TunnelBreach", "S3_B_ThornesWard", "S3_B_LoomHeart", \
		"S3_B_DreamInvasion", "S3_B_DreamNexus":
			return S3PathB.create_battle(battle_id)
		# Story 3 - Path C (true ally path)
		"S3_C_LirasConfession", "S3_C_DreamDescent", \
		"S3_C_CultInterception", "S3_C_ThreadmasterLair", \
		"S3_C_DreamNexus":
			return S3PathC.create_battle(battle_id)
		_:
			push_error("Unknown battle: %s" % battle_id)
			return Act1.city_street_battle()
