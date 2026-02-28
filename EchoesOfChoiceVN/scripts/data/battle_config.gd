class_name BattleConfig

const _Enums = preload("res://scripts/data/enums.gd")
const F := _Enums.RowPosition.FRONT
const B := _Enums.RowPosition.BACK


static func load_config(battle_id: String) -> Dictionary:
	match battle_id:
		"city_street": return _city_street()
		"forest": return _forest()
		"smoke": return _smoke()
		"portal": return _portal()
		"deep_forest": return _deep_forest()
		"cave": return _cave()
		"clearing": return _clearing()
		"ruins": return _ruins()
		"inn_ambush": return _inn_ambush()
		"cemetery": return _cemetery()
		"carnival": return _carnival()
		"shore": return _shore()
		"beach": return _beach()
		"encampment": return _encampment()
		"lab": return _lab()
		"mirror": return _mirror()
		"city_gate": return _city_gate()
		"return_city_1": return _return_city_1()
		"shrine_fire": return _shrine_fire()
		"shrine_water": return _shrine_water()
		"shrine_wind": return _shrine_wind()
		"shrine_earth": return _shrine_earth()
		"final_castle": return _final_castle()
		_:
			push_warning("BattleConfig: Unknown battle '%s', using default" % battle_id)
			return _default_battle()


static func load_class(class_id: String) -> FighterData:
	var path := "res://resources/classes/%s.tres" % class_id
	if ResourceLoader.exists(path):
		return load(path) as FighterData
	return null


static func load_enemy(enemy_id: String) -> FighterData:
	var path := "res://resources/enemies/%s.tres" % enemy_id
	if ResourceLoader.exists(path):
		return load(path) as FighterData
	return null


# --- Prog 0: City Street ---
static func _city_street() -> Dictionary:
	return {
		"name": "City Street Ambush",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 50,
		"enemies": [
			{"id": "street_tough", "level": 1, "row": F},
			{"id": "street_tough", "level": 1, "row": F},
			{"id": "thug", "level": 1, "row": F},
			{"id": "hedge_mage", "level": 1, "row": B},
		],
	}

# --- Prog 1: Forest ---
static func _forest() -> Dictionary:
	return {
		"name": "Forest Encounter",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 75,
		"enemies": [
			{"id": "forest_guardian", "level": 1, "row": F},
			{"id": "gnoll_raider", "level": 1, "row": F},
			{"id": "gnoll_raider", "level": 1, "row": F},
			{"id": "grove_sprite", "level": 1, "row": B},
		],
	}

# --- Prog 2: Branch path ---
static func _smoke() -> Dictionary:
	return {
		"name": "The Smoke",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 100,
		"enemies": [
			{"id": "goblin_firestarter", "level": 2, "row": F},
			{"id": "goblin_firestarter", "level": 2, "row": F},
			{"id": "blood_fiend", "level": 2, "row": F},
			{"id": "ogre", "level": 2, "row": F},
		],
	}

static func _portal() -> Dictionary:
	return {
		"name": "The Portal",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 150,
		"enemies": [
			{"id": "blood_imp", "level": 3, "row": F},
			{"id": "blood_imp", "level": 3, "row": F},
			{"id": "hellion", "level": 3, "row": F},
			{"id": "hellion", "level": 3, "row": B},
		],
	}

static func _deep_forest() -> Dictionary:
	return {
		"name": "Deep Forest",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 100,
		"enemies": [
			{"id": "witch", "level": 2, "row": B},
			{"id": "wisp", "level": 2, "row": B},
			{"id": "sprite", "level": 2, "row": F},
			{"id": "wild_huntsman", "level": 2, "row": F},
		],
	}

static func _cave() -> Dictionary:
	return {
		"name": "The Cave",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 150,
		"enemies": [
			{"id": "orc_scout", "level": 3, "row": F},
			{"id": "orc_scout", "level": 3, "row": F},
			{"id": "demon_archer", "level": 3, "row": B},
			{"id": "frost_demon", "level": 3, "row": F},
		],
	}

static func _clearing() -> Dictionary:
	return {
		"name": "The Clearing",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 100,
		"enemies": [
			{"id": "elf_ranger", "level": 2, "row": B},
			{"id": "elf_ranger", "level": 2, "row": B},
			{"id": "pixie", "level": 2, "row": B},
			{"id": "satyr", "level": 2, "row": F},
		],
	}

static func _ruins() -> Dictionary:
	return {
		"name": "The Ruins",
		"music": MusicManager.MusicContext.BATTLE_DARK,
		"gold_reward": 100,
		"enemies": [
			{"id": "shade", "level": 2, "row": F},
			{"id": "shade", "level": 2, "row": F},
			{"id": "wraith", "level": 2, "row": B},
			{"id": "bone_sentry", "level": 2, "row": F},
		],
	}

# --- Prog 3: Inn ambush (optional) ---
static func _inn_ambush() -> Dictionary:
	return {
		"name": "Inn Ambush",
		"music": MusicManager.MusicContext.BATTLE_DARK,
		"gold_reward": 125,
		"enemies": [
			{"id": "dark_elf_assassin", "level": 3, "row": F},
			{"id": "dark_elf_blade", "level": 3, "row": F},
			{"id": "shadow_fiend", "level": 3, "row": F},
			{"id": "phantom_prowler", "level": 3, "row": B},
		],
	}

# --- Prog 4: Mid-game path ---
static func _cemetery() -> Dictionary:
	return {
		"name": "The Cemetery",
		"music": MusicManager.MusicContext.BATTLE_DARK,
		"gold_reward": 200,
		"enemies": [
			{"id": "zombie", "level": 4, "row": F},
			{"id": "zombie", "level": 4, "row": F},
			{"id": "specter", "level": 4, "row": B},
			{"id": "grave_wraith", "level": 4, "row": B},
		],
	}

static func _carnival() -> Dictionary:
	return {
		"name": "Dark Carnival",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 200,
		"enemies": [
			{"id": "harlequin", "level": 4, "row": F},
			{"id": "harlequin", "level": 4, "row": F},
			{"id": "elf_enchantress", "level": 4, "row": B},
			{"id": "ringmaster", "level": 4, "row": B},
		],
	}

static func _shore() -> Dictionary:
	return {
		"name": "The Shore",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 150,
		"enemies": [
			{"id": "medusa", "level": 4, "row": F},
			{"id": "medusa", "level": 4, "row": F},
			{"id": "sea_elf", "level": 4, "row": B},
			{"id": "sea_elf", "level": 4, "row": B},
		],
	}

static func _beach() -> Dictionary:
	return {
		"name": "The Beach",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 200,
		"enemies": [
			{"id": "pirate", "level": 4, "row": F},
			{"id": "pirate", "level": 4, "row": F},
			{"id": "sea_shaman", "level": 4, "row": B},
			{"id": "captain", "level": 4, "row": F},
		],
	}

static func _encampment() -> Dictionary:
	return {
		"name": "The Encampment",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 200,
		"enemies": [
			{"id": "shadow_fiend", "level": 4, "row": F},
			{"id": "shadow_fiend", "level": 4, "row": F},
			{"id": "orc_warchanter", "level": 4, "row": B},
			{"id": "commander", "level": 4, "row": F},
		],
	}

static func _lab() -> Dictionary:
	return {
		"name": "The Crypt Laboratory",
		"music": MusicManager.MusicContext.BATTLE_DARK,
		"gold_reward": 200,
		"enemies": [
			{"id": "frost_sentinel", "level": 4, "row": F},
			{"id": "arc_golem", "level": 4, "row": F},
			{"id": "ironclad", "level": 4, "row": F},
			{"id": "skeleton_crusader", "level": 4, "row": B},
		],
	}

# --- Prog 5: Mirror ---
static func _mirror() -> Dictionary:
	return {
		"name": "The Mirror",
		"music": MusicManager.MusicContext.BATTLE_BOSS,
		"gold_reward": 250,
		"enemies": [
			{"id": "gorgon", "level": 5, "row": F},
			{"id": "ghost_corsair", "level": 5, "row": F},
			{"id": "dark_elf_blade", "level": 5, "row": F},
			{"id": "dark_seraph", "level": 5, "row": B},
		],
	}

# --- Prog 6: City gate and districts ---
static func _city_gate() -> Dictionary:
	return {
		"name": "City Gates",
		"music": MusicManager.MusicContext.BATTLE_BOSS,
		"gold_reward": 300,
		"enemies": [
			{"id": "gorgon_queen", "level": 6, "row": F},
			{"id": "dark_elf_warlord", "level": 6, "row": F},
			{"id": "city_militia", "level": 6, "row": F},
			{"id": "phantom_prowler", "level": 6, "row": B},
		],
	}

static func _return_city_1() -> Dictionary:
	return {
		"name": "East Rampart",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 300,
		"enemies": [
			{"id": "seraph", "level": 6, "row": F},
			{"id": "arch_hellion", "level": 6, "row": F},
			{"id": "phantom_prowler", "level": 6, "row": B},
			{"id": "dark_elf_warlord", "level": 6, "row": F},
		],
	}

# --- Prog 7: Elemental shrines ---
static func _shrine_fire() -> Dictionary:
	return {
		"name": "Shrine of Flames",
		"music": MusicManager.MusicContext.BATTLE_BOSS,
		"gold_reward": 400,
		"enemies": [
			{"id": "fire_elemental", "level": 8, "row": F},
			{"id": "fire_elemental", "level": 7, "row": F},
			{"id": "fire_elemental", "level": 7, "row": B},
			{"id": "fire_elemental", "level": 7, "row": B},
		],
	}

static func _shrine_water() -> Dictionary:
	return {
		"name": "Shrine of Tides",
		"music": MusicManager.MusicContext.BATTLE_BOSS,
		"gold_reward": 400,
		"enemies": [
			{"id": "water_elemental", "level": 8, "row": F},
			{"id": "water_elemental", "level": 7, "row": F},
			{"id": "water_elemental", "level": 7, "row": B},
			{"id": "water_elemental", "level": 7, "row": B},
		],
	}

static func _shrine_wind() -> Dictionary:
	return {
		"name": "Shrine of Winds",
		"music": MusicManager.MusicContext.BATTLE_BOSS,
		"gold_reward": 400,
		"enemies": [
			{"id": "air_elemental", "level": 8, "row": F},
			{"id": "air_elemental", "level": 7, "row": F},
			{"id": "air_elemental", "level": 7, "row": B},
			{"id": "air_elemental", "level": 7, "row": B},
		],
	}

static func _shrine_earth() -> Dictionary:
	return {
		"name": "Shrine of Stone",
		"music": MusicManager.MusicContext.BATTLE_BOSS,
		"gold_reward": 400,
		"enemies": [
			{"id": "earth_elemental", "level": 8, "row": F},
			{"id": "earth_elemental", "level": 7, "row": F},
			{"id": "earth_elemental", "level": 7, "row": B},
			{"id": "earth_elemental", "level": 7, "row": B},
		],
	}

# --- Prog 8: Final castle ---
static func _final_castle() -> Dictionary:
	return {
		"name": "The Final Castle",
		"music": MusicManager.MusicContext.BATTLE_BOSS,
		"gold_reward": 600,
		"enemies": [
			{"id": "the_stranger", "level": 8, "row": F},
			{"id": "elite_guard_mage", "level": 8, "row": B},
			{"id": "elite_guard_mage", "level": 8, "row": B},
			{"id": "elite_guard_squire", "level": 8, "row": F},
		],
	}

# --- Fallback ---
static func _default_battle() -> Dictionary:
	return {
		"name": "Battle",
		"music": MusicManager.MusicContext.BATTLE,
		"gold_reward": 50,
		"enemies": [
			{"id": "thug", "level": 1, "row": F},
			{"id": "thug", "level": 1, "row": F},
		],
	}
