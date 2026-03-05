class_name BattleStageDB

## All battle stages with enemy compositions and balance targets.
## Each stage has a story field (1 or 2) for filtering by story.

const EnemyDB := preload("res://scripts/data/enemy_db.gd")
const EnemyDBS2 := preload("res://scripts/data/enemy_db_s2.gd")
const EnemyDBS2Act2 := preload("res://scripts/data/enemy_db_s2_act2.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")


static func get_all_stages() -> Array:
	return [
		# Prog 0: Base classes, no level ups
		_s("CityStreetBattle", 0, "base", 0.90, 0),
		# Prog 1: Base classes, 1 level up
		_s("WolfForestBattle", 1, "base", 0.88, 1),
		# Prog 2: Base classes, 2 level ups
		_s("WaypointDefenseBattle", 2, "base", 0.85, 2),
		# Prog 3: Tier 1, 4 total level ups
		_s("HighlandBattle", 4, "tier1", 0.83, 3),
		_s("DeepForestBattle", 4, "tier1", 0.83, 3),
		_s("ShoreBattle", 4, "tier1", 0.83, 3),
		# Prog 4: Tier 1, 5 total level ups
		_s("MountainPassBattle", 5, "tier1", 0.81, 4),
		_s("CaveBattle", 5, "tier1", 0.81, 4),
		_s("BeachBattle", 5, "tier1", 0.81, 4),
		# Prog 5: Tier 1, 6 total level ups
		_s("CircusBattle", 6, "tier1", 0.79, 5),
		_s("LabBattle", 6, "tier1", 0.79, 5),
		_s("ArmyBattle", 6, "tier1", 0.79, 5),
		_s("CemeteryBattle", 6, "tier1", 0.79, 5),
		# Prog 6: Tier 1, 7 total level ups
		_s("OutpostDefenseBattle", 7, "tier1", 0.77, 6),
		# Prog 7: Tier 1, 8 total level ups (mirror)
		_s("MirrorBattle", 8, "tier1", 0.75, 7),
		# Prog 8: Tier 2, 10 total level ups
		_s("ReturnToCityStreetBattle", 10, "tier2", 0.80, 8),
		# Prog 9: Tier 2, 11 total level ups
		_s("StrangerTowerBattle", 11, "tier2", 0.78, 9),
		# Prog 10: Tier 2, 12 total level ups
		_s("CorruptedCityBattle", 12, "tier2", 0.75, 10),
		_s("CorruptedWildsBattle", 12, "tier2", 0.75, 10),
		# Prog 11: Tier 2, 13 total level ups (underground pursuit)
		_s("DepthsBattle", 13, "tier2", 0.72, 11),
		# Prog 12: Tier 2, 14 total level ups (last guardian)
		_s("GateBattle", 14, "tier2", 0.69, 12),
		# Prog 13: Tier 2, 15 total level ups (final boss)
		_s("StrangerFinalBattle", 15, "tier2", 0.65, 13),
		# --- Story 2: Echoes in the Dark ---
		# Prog 0: Base classes, no level ups
		_s("S2_CaveAwakening", 0, "base", 0.85, 0, 2),
		# Prog 1: Base classes, 1 level up (branch pair)
		_s("S2_DeepCavern", 1, "base", 0.83, 1, 2),
		_s("S2_FungalHollow", 1, "base", 0.83, 1, 2),
		# Prog 2: Base classes, 2 level ups (branch pair)
		_s("S2_TranquilPool", 2, "base", 0.80, 2, 2),
		_s("S2_TorchChamber", 2, "base", 0.80, 2, 2),
		# Prog 3: Tier 1, 4 level ups (post-merchant upgrade)
		_s("S2_CaveExit", 4, "tier1", 0.76, 3, 2),
		# --- Story 2 Act II: The Shore ---
		# Prog 4: Tier 1, 5 level ups (first surface battle)
		_s("S2_CoastalDescent", 5, "tier1", 0.74, 4, 2),
		# Prog 5: Tier 1, 6 level ups (branch pair)
		_s("S2_FishingVillage", 6, "tier1", 0.72, 5, 2),
		_s("S2_SmugglersBluff", 6, "tier1", 0.72, 5, 2),
		# Prog 6: Tier 2, 8 level ups (post-harbor upgrade, branch pair)
		_s("S2_WreckersCove", 8, "tier2", 0.70, 6, 2),
		_s("S2_CoastalRuins", 8, "tier2", 0.70, 6, 2),
		# Prog 7: Tier 2, 9 level ups (convergence)
		_s("S2_BlackwaterBay", 9, "tier2", 0.68, 7, 2),
		# Prog 8: Tier 2, 10 level ups (Act II boss)
		_s("S2_LighthouseStorm", 10, "tier2", 0.66, 8, 2),
	]


static func get_story_stages(story: int) -> Array:
	return get_all_stages().filter(
		func(s: Dictionary) -> bool: return s.story == story)


static func _s(n: String, lu: int, tier: String, target: float,
		prog: int, story: int = 1) -> Dictionary:
	return {
		"name": n, "level_ups": lu, "tier": tier,
		"target_win_rate": target, "progression_stage": prog,
		"story": story,
	}


# =============================================================================
# Enemy factories, one per stage
# =============================================================================

static func create_enemies(stage_name: String, party: Array = []) -> Array:
	match stage_name:
		"CityStreetBattle":
			return [EnemyDB.create_thug("Alexander"),
				EnemyDB.create_ruffian("Jenna"),
				EnemyDB.create_pickpocket("Ella")]
		"WolfForestBattle":
			return [EnemyDB.create_wolf("Greyfang"),
				EnemyDB.create_boar("Tusker")]
		"WaypointDefenseBattle":
			return [EnemyDB.create_bandit("Riggs"),
				EnemyDB.create_goblin("Snitch"),
				EnemyDB.create_hound("Fang")]
		"HighlandBattle":
			return [EnemyDB.create_raider("Wulfric"),
				EnemyDB.create_raider("Bjorn"),
				EnemyDB.create_orc("Grath")]
		"DeepForestBattle":
			return [EnemyDB.create_witch("Morwen"),
				EnemyDB.create_wisp("Flicker"),
				EnemyDB.create_sprite("Briar")]
		"ShoreBattle":
			return [EnemyDB.create_siren("Lorelei"),
				EnemyDB.create_merfolk("Thalassa"),
				EnemyDB.create_merfolk("Nereus")]
		"MountainPassBattle":
			return [EnemyDB.create_troll("Grendal"),
				EnemyDB.create_harpy("Screecher"),
				EnemyDB.create_harpy("Shrieker")]
		"CaveBattle":
			return [EnemyDB.create_fire_wyrmling("Raysses"),
				EnemyDB.create_frost_wyrmling("Sythara"),
				EnemyDB.create_fire_wyrmling("Cindrak")]
		"BeachBattle":
			return [EnemyDB.create_captain("Greybeard"),
				EnemyDB.create_pirate("Flint"),
				EnemyDB.create_pirate("Bonny")]
		"CircusBattle":
			return [EnemyDB.create_harlequin("Louis"),
				EnemyDB.create_chanteuse("Erembour"),
				EnemyDB.create_ringmaster("Gaspard")]
		"LabBattle":
			return [EnemyDB.create_android("Deus"),
				EnemyDB.create_machinist("Ananiah"),
				EnemyDB.create_ironclad("Acrid")]
		"ArmyBattle":
			return [EnemyDB.create_commander("Varro"),
				EnemyDB.create_draconian("Theron"),
				EnemyDB.create_chaplain("Cristole")]
		"CemeteryBattle":
			return [EnemyDB.create_zombie("Mort"),
				EnemyDB.create_ghoul("Rave"),
				EnemyDB.create_zombie("Dredge")]
		"OutpostDefenseBattle":
			return [EnemyDB.create_shade("Umbra"),
				EnemyDB.create_wraith("Revenant"),
				EnemyDB.create_shade("Penumbra"),
				EnemyDB.create_wraith("Specter")]
		"MirrorBattle":
			return _mirror_enemies(party)
		"ReturnToCityStreetBattle":
			return [EnemyDB.create_royal_guard("Aldric"),
				EnemyDB.create_guard_sergeant("Brennan"),
				EnemyDB.create_guard_archer("Tamsin"),
				EnemyDB.create_guard_archer("Corwin")]
		"StrangerTowerBattle":
			return [EnemyDB.create_stranger("The Stranger")]
		"CorruptedCityBattle":
			return [EnemyDB.create_lich("Mortuus"),
				EnemyDB.create_ghast("Putrefax"),
				EnemyDB.create_ghast("Bloatus"),
				EnemyDB.create_lich("Necrus")]
		"CorruptedWildsBattle":
			return [EnemyDB.create_demon("Bael"),
				EnemyDB.create_corrupted_treant("Rothollow"),
				EnemyDB.create_corrupted_treant("Blightsnarl"),
				EnemyDB.create_demon("Moloch")]
		"GateBattle":
			return [EnemyDB.create_dark_knight("Ser Malachar"),
				EnemyDB.create_fell_hound("Duskfang"),
				EnemyDB.create_fell_hound("Gloomjaw"),
				EnemyDB.create_dark_knight("Ser Dravus")]
		"DepthsBattle":
			return [EnemyDB.create_sigil_wretch("Skritch"),
				EnemyDB.create_tunnel_lurker("Silkfang"),
				EnemyDB.create_tunnel_lurker("Webweaver")]
		"StrangerFinalBattle":
			return [EnemyDB.create_stranger_final("The Stranger")]
		# Story 2
		"S2_CaveAwakening":
			return [EnemyDBS2.create_glow_worm("Luminara"),
				EnemyDBS2.create_glow_worm("Flicker"),
				EnemyDBS2.create_crystal_spider("Prism")]
		"S2_DeepCavern":
			return [EnemyDBS2.create_shade_crawler("Umbral"),
				EnemyDBS2.create_shade_crawler("Murk"),
				EnemyDBS2.create_echo_wisp("Resonance")]
		"S2_FungalHollow":
			return [EnemyDBS2.create_spore_stalker("Creeper"),
				EnemyDBS2.create_fungal_hulk("Mossback"),
				EnemyDBS2.create_cap_wisp("Drifter")]
		"S2_TranquilPool":
			return [EnemyDBS2.create_cave_eel("Voltfin"),
				EnemyDBS2.create_blind_angler("The Lure"),
				EnemyDBS2.create_pale_crayfish("Old Shell")]
		"S2_TorchChamber":
			return [EnemyDBS2.create_cave_dweller("Grimjaw"),
				EnemyDBS2.create_tunnel_shaman("Ember Eye"),
				EnemyDBS2.create_burrow_scout("Quickfoot")]
		"S2_CaveExit":
			return [EnemyDBS2.create_cave_maw("The Threshold", 5),
				EnemyDBS2.create_vein_leech("Gnawer", 5),
				EnemyDBS2.create_stone_moth("Dustwing", 5)]
		# Story 2 Act II
		"S2_CoastalDescent":
			return [EnemyDBS2Act2.create_blighted_gull("Blackwing"),
				EnemyDBS2Act2.create_shore_crawler("Ironshell"),
				EnemyDBS2Act2.create_warped_hound("Brine")]
		"S2_FishingVillage":
			return [EnemyDBS2Act2.create_driftwood_bandit("Scarhand"),
				EnemyDBS2Act2.create_driftwood_bandit("Rust"),
				EnemyDBS2Act2.create_saltrunner_smuggler("Quicksilver")]
		"S2_SmugglersBluff":
			return [EnemyDBS2Act2.create_saltrunner_smuggler("Duskrunner"),
				EnemyDBS2Act2.create_tide_warden("Breakwater"),
				EnemyDBS2Act2.create_driftwood_bandit("Splinter")]
		"S2_WreckersCove":
			return [EnemyDBS2Act2.create_blackwater_captain("Captain Korr"),
				EnemyDBS2Act2.create_corsair_hexer("Saltweave"),
				EnemyDBS2Act2.create_driftwood_bandit("Barnacle")]
		"S2_CoastalRuins":
			return [EnemyDBS2Act2.create_abyssal_lurker("Depthcrawl"),
				EnemyDBS2Act2.create_stormwrack_raptor("Voltwing"),
				EnemyDBS2Act2.create_blighted_gull("Shriek")]
		"S2_BlackwaterBay":
			return [EnemyDBS2Act2.create_salt_phantom("The Drowned"),
				EnemyDBS2Act2.create_salt_phantom("The Forgotten"),
				EnemyDBS2Act2.create_abyssal_lurker("Undertow")]
		"S2_LighthouseStorm":
			return [EnemyDBS2Act2.create_tidecaller_revenant("The Keeper"),
				EnemyDBS2Act2.create_salt_phantom("The Watcher")]
		_:
			push_error("Unknown stage: %s" % stage_name)
			return []


static func _mirror_enemies(party: Array) -> Array:
	var enemies := []
	for f: FighterData in party:
		var c := f.clone()
		c.character_name = "Shadow " + f.character_name
		c.is_user_controlled = false
		c.health = int(c.health * 0.99); c.max_health = c.health
		c.physical_attack = int(c.physical_attack * 0.99)
		c.magic_attack = int(c.magic_attack * 0.99)
		c.speed = int(c.speed * 0.97)
		enemies.append(c)
	return enemies
