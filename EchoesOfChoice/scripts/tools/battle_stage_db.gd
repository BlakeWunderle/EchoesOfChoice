class_name BattleStageDB

## All 22 battle stages with enemy compositions and balance targets.
## Port of C# EchoesOfChoice/BattleSimulator/BattleStage.cs.

const EnemyDB := preload("res://scripts/data/enemy_db.gd")
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
	]


static func _s(n: String, lu: int, tier: String, target: float,
		prog: int) -> Dictionary:
	return {
		"name": n, "level_ups": lu, "tier": tier,
		"target_win_rate": target, "progression_stage": prog,
	}


# =============================================================================
# Enemy factories — one per stage
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
				EnemyDB.create_tunnel_lurker("Webweaver"),
				EnemyDB.create_sigil_wretch("Gnash")]
		"StrangerFinalBattle":
			return [EnemyDB.create_stranger_final("The Stranger")]
		_:
			push_error("Unknown stage: %s" % stage_name)
			return []


static func _mirror_enemies(party: Array) -> Array:
	var enemies := []
	for f: FighterData in party:
		var c := f.clone()
		c.character_name = "Shadow " + f.character_name
		c.is_user_controlled = false
		c.health = int(c.health * 0.94); c.max_health = c.health
		c.physical_attack = int(c.physical_attack * 0.98)
		c.magic_attack = int(c.magic_attack * 0.98)
		c.speed = int(c.speed * 0.97)
		enemies.append(c)
	return enemies
