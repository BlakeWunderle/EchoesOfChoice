class_name EnemyDB

## Factory for all enemy fighters. Stats from C# source with level-scaled ranges.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")
const EAB := preload("res://scripts/data/enemy_ability_db.gd")


static func _es(base_min: int, base_max: int, gmin: int, gmax: int, level: int, base_level: int = 1) -> int:
	var lvl: int = level - base_level
	var lo: int = base_min + lvl * gmin
	var hi: int = base_max + lvl * (gmax - 1)
	if hi <= lo:
		return lo
	return randi_range(lo, hi - 1)

static func _fixed(base_min: int, base_max: int) -> int:
	return randi_range(base_min, base_max - 1)


static func _base(name: String, type: String, lvl: int) -> FighterData:
	var f := FighterData.new()
	f.character_name = name
	f.character_type = type
	f.class_id = type
	f.is_user_controlled = false
	f.level = lvl
	return f


# =============================================================================
# Act I enemies (Progression 0-1)
# =============================================================================

static func create_thug(n: String, lvl: int = 1) -> FighterData:
	var f := _base(n, "Thug", lvl)
	f.health = _es(48, 58, 3, 7, lvl, 1); f.max_health = f.health
	f.mana = _es(4, 8, 1, 3, lvl, 1); f.max_mana = f.mana
	f.physical_attack = _es(15, 19, 1, 3, lvl, 1)
	f.physical_defense = _es(8, 12, 1, 2, lvl, 1)
	f.magic_attack = _es(3, 6, 0, 2, lvl, 1)
	f.magic_defense = _es(8, 12, 1, 2, lvl, 1)
	f.speed = _es(18, 24, 1, 2, lvl, 1)
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [AbilityDB.haymaker()]
	return f

static func create_ruffian(n: String, lvl: int = 1) -> FighterData:
	var f := _base(n, "Ruffian", lvl)
	f.health = _es(44, 54, 3, 6, lvl, 1); f.max_health = f.health
	f.mana = _es(4, 8, 1, 3, lvl, 1); f.max_mana = f.mana
	f.physical_attack = _es(17, 21, 1, 3, lvl, 1)
	f.physical_defense = _es(7, 11, 1, 2, lvl, 1)
	f.magic_attack = _es(2, 5, 0, 1, lvl, 1)
	f.magic_defense = _es(6, 10, 1, 2, lvl, 1)
	f.speed = _es(16, 22, 1, 2, lvl, 1)
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 5
	f.abilities = [AbilityDB.haymaker(), AbilityDB.intimidate()]
	return f

static func create_pickpocket(n: String, lvl: int = 1) -> FighterData:
	var f := _base(n, "Pickpocket", lvl)
	f.health = _es(34, 43, 2, 5, lvl, 1); f.max_health = f.health
	f.mana = _es(5, 9, 1, 3, lvl, 1); f.max_mana = f.mana
	f.physical_attack = _es(12, 16, 1, 3, lvl, 1)
	f.physical_defense = _es(5, 8, 0, 2, lvl, 1)
	f.magic_attack = _es(2, 4, 0, 1, lvl, 1)
	f.magic_defense = _es(5, 9, 0, 2, lvl, 1)
	f.speed = _es(22, 28, 2, 3, lvl, 1)
	f.crit_chance = 15; f.crit_damage = 1; f.dodge_chance = 20
	f.abilities = [AbilityDB.quick_stab(), AbilityDB.pilfer()]
	return f


# =============================================================================
# Act I enemies (Progression 2)
# =============================================================================

static func create_wolf(n: String, lvl: int = 2) -> FighterData:
	var f := _base(n, "Wolf", lvl)
	f.health = _es(50, 60, 4, 7, lvl, 2); f.max_health = f.health
	f.mana = _es(6, 10, 1, 3, lvl, 2); f.max_mana = f.mana
	f.physical_attack = _es(19, 23, 2, 3, lvl, 2)
	f.physical_defense = _es(8, 12, 1, 2, lvl, 2)
	f.magic_attack = _es(2, 4, 0, 1, lvl, 2)
	f.magic_defense = _es(6, 10, 1, 2, lvl, 2)
	f.speed = _es(24, 30, 2, 3, lvl, 2)
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 15
	f.abilities = [EAB.bite(), EAB.howl()]
	return f

static func create_boar(n: String, lvl: int = 2) -> FighterData:
	var f := _base(n, "Boar", lvl)
	f.health = _es(66, 76, 5, 8, lvl, 2); f.max_health = f.health
	f.mana = _es(6, 10, 1, 3, lvl, 2); f.max_mana = f.mana
	f.physical_attack = _es(21, 25, 2, 4, lvl, 2)
	f.physical_defense = _es(12, 16, 1, 3, lvl, 2)
	f.magic_attack = _es(2, 4, 0, 1, lvl, 2)
	f.magic_defense = _es(8, 12, 1, 2, lvl, 2)
	f.speed = _es(18, 24, 1, 2, lvl, 2)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 5
	f.abilities = [EAB.gore(), EAB.charge()]
	return f

static func create_goblin(n: String, lvl: int = 2) -> FighterData:
	var f := _base(n, "Goblin", lvl)
	f.health = _es(37, 49, 3, 6, lvl, 2); f.max_health = f.health
	f.mana = _es(6, 10, 1, 3, lvl, 2); f.max_mana = f.mana
	f.physical_attack = _es(16, 20, 2, 3, lvl, 2)
	f.physical_defense = _es(7, 10, 1, 2, lvl, 2)
	f.magic_attack = _es(3, 6, 0, 2, lvl, 2)
	f.magic_defense = _es(5, 8, 0, 2, lvl, 2)
	f.speed = _es(26, 32, 2, 4, lvl, 2)
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 25
	f.abilities = [EAB.stab(), EAB.throw_rock(), EAB.scurry()]
	return f

static func create_hound(n: String, lvl: int = 2) -> FighterData:
	var f := _base(n, "Hound", lvl)
	f.health = _es(44, 54, 3, 6, lvl, 2); f.max_health = f.health
	f.mana = _es(4, 8, 1, 2, lvl, 2); f.max_mana = f.mana
	f.physical_attack = _es(18, 22, 2, 3, lvl, 2)
	f.physical_defense = _es(8, 12, 1, 2, lvl, 2)
	f.magic_attack = _es(2, 4, 0, 1, lvl, 2)
	f.magic_defense = _es(5, 8, 0, 2, lvl, 2)
	f.speed = _es(26, 32, 2, 3, lvl, 2)
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 15
	f.abilities = [EAB.bite(), EAB.tackle()]
	return f

static func create_bandit(n: String, lvl: int = 3) -> FighterData:
	var f := _base(n, "Bandit", lvl)
	f.health = _es(74, 88, 5, 8, lvl, 3); f.max_health = f.health
	f.mana = _es(8, 12, 1, 3, lvl, 3); f.max_mana = f.mana
	f.physical_attack = _es(22, 27, 2, 4, lvl, 3)
	f.physical_defense = _es(12, 16, 1, 3, lvl, 3)
	f.magic_attack = _es(4, 7, 0, 2, lvl, 3)
	f.magic_defense = _es(8, 12, 1, 2, lvl, 3)
	f.speed = _es(22, 28, 1, 3, lvl, 3)
	f.crit_chance = 15; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [AbilityDB.slash(), EAB.ambush()]
	return f

# =============================================================================
# Act II enemies (Progression 3-7)
# =============================================================================

static func create_raider(n: String, lvl: int = 4) -> FighterData:
	var f := _base(n, "Raider", lvl)
	f.health = _es(86, 100, 4, 7, lvl, 4); f.max_health = f.health
	f.mana = _es(10, 14, 1, 3, lvl, 4); f.max_mana = f.mana
	f.physical_attack = _es(22, 26, 2, 3, lvl, 4)
	f.physical_defense = _es(12, 16, 1, 2, lvl, 4)
	f.magic_attack = _es(4, 8, 0, 2, lvl, 4)
	f.magic_defense = _es(10, 14, 1, 2, lvl, 4)
	f.speed = _es(24, 30, 1, 3, lvl, 4)
	f.crit_chance = 15; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.cleave(), EAB.war_cry()]
	return f

static func create_orc(n: String, lvl: int = 4) -> FighterData:
	var f := _base(n, "Orc", lvl)
	f.health = _es(112, 130, 5, 8, lvl, 4); f.max_health = f.health
	f.mana = _es(8, 12, 1, 3, lvl, 4); f.max_mana = f.mana
	f.physical_attack = _es(25, 30, 2, 4, lvl, 4)
	f.physical_defense = _es(16, 20, 1, 3, lvl, 4)
	f.magic_attack = _es(3, 6, 0, 1, lvl, 4)
	f.magic_defense = _es(10, 14, 1, 2, lvl, 4)
	f.speed = _es(18, 24, 1, 2, lvl, 4)
	f.crit_chance = 15; f.crit_damage = 3; f.dodge_chance = 5
	f.abilities = [EAB.crush(), EAB.thick_skin()]
	return f

static func create_troll(n: String, lvl: int = 5) -> FighterData:
	var f := _base(n, "Troll", lvl)
	f.health = _es(165, 190, 6, 10, lvl, 5); f.max_health = f.health
	f.mana = _es(12, 16, 1, 3, lvl, 5); f.max_mana = f.mana
	f.physical_attack = _es(30, 35, 2, 4, lvl, 5)
	f.physical_defense = _es(18, 22, 1, 3, lvl, 5)
	f.magic_attack = _es(4, 8, 0, 1, lvl, 5)
	f.magic_defense = _es(12, 16, 1, 2, lvl, 5)
	f.speed = _es(16, 22, 1, 2, lvl, 5)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 5
	f.abilities = [AbilityDB.smash(), EAB.regenerate(), EAB.stomp()]
	return f

static func create_harpy(n: String, lvl: int = 5) -> FighterData:
	var f := _base(n, "Harpy", lvl)
	f.health = _es(96, 112, 4, 7, lvl, 5); f.max_health = f.health
	f.mana = _es(10, 14, 1, 3, lvl, 5); f.max_mana = f.mana
	f.physical_attack = _es(28, 33, 2, 4, lvl, 5)
	f.physical_defense = _es(10, 14, 1, 2, lvl, 5)
	f.magic_attack = _es(8, 12, 0, 2, lvl, 5)
	f.magic_defense = _es(12, 16, 1, 2, lvl, 5)
	f.speed = _es(28, 34, 2, 3, lvl, 5)
	f.crit_chance = 15; f.crit_damage = 2; f.dodge_chance = 25
	f.abilities = [EAB.talon_rake(), EAB.shriek()]
	return f

static func create_witch(n: String, lvl: int = 4) -> FighterData:
	var f := _base(n, "Witch", lvl)
	f.health = _es(94, 120, 5, 10, lvl, 4); f.max_health = f.health
	f.mana = _es(29, 45, 3, 6, lvl, 4); f.max_mana = f.mana
	f.physical_attack = _es(7, 11, 1, 2, lvl, 4)
	f.physical_defense = _es(9, 14, 1, 2, lvl, 4)
	f.magic_attack = _es(30, 43, 4, 7, lvl, 4)
	f.magic_defense = _es(17, 26, 2, 5, lvl, 4)
	f.speed = _es(20, 28, 1, 2, lvl, 4)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.enemy_hex(), EAB.bramble(), EAB.dark_blessing()]
	return f

static func create_wisp(n: String, lvl: int = 4) -> FighterData:
	var f := _base(n, "Wisp", lvl)
	f.health = _es(58, 82, 5, 9, lvl, 4); f.max_health = f.health
	f.mana = _es(24, 40, 2, 5, lvl, 4); f.max_mana = f.mana
	f.physical_attack = _es(6, 10, 1, 2, lvl, 4)
	f.physical_defense = _es(8, 13, 1, 2, lvl, 4)
	f.magic_attack = _es(22, 34, 3, 6, lvl, 4)
	f.magic_defense = _es(11, 18, 1, 3, lvl, 4)
	f.speed = _es(28, 38, 2, 3, lvl, 4)
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 30
	f.abilities = [EAB.lure(), EAB.bewitch()]
	return f

static func create_sprite(n: String, lvl: int = 4) -> FighterData:
	var f := _base(n, "Sprite", lvl)
	f.health = _es(60, 84, 4, 9, lvl, 4); f.max_health = f.health
	f.mana = _es(21, 37, 2, 5, lvl, 4); f.max_mana = f.mana
	f.physical_attack = _es(19, 29, 2, 5, lvl, 4)
	f.physical_defense = _es(9, 16, 1, 3, lvl, 4)
	f.magic_attack = _es(10, 18, 1, 3, lvl, 4)
	f.magic_defense = _es(11, 18, 1, 3, lvl, 4)
	f.speed = _es(24, 35, 1, 3, lvl, 4)
	f.crit_chance = 20; f.crit_damage = 1; f.dodge_chance = 30
	f.abilities = [EAB.thorn(), EAB.pollen()]
	return f

static func create_siren(n: String, lvl: int = 4) -> FighterData:
	var f := _base(n, "Siren", lvl)
	f.health = _es(86, 105, 6, 12, lvl, 4); f.max_health = f.health
	f.mana = _es(19, 33, 2, 5, lvl, 3); f.max_mana = f.mana
	f.physical_attack = _es(9, 17, 1, 3, lvl, 4)
	f.physical_defense = _es(11, 19, 1, 3, lvl, 4)
	f.magic_attack = _es(25, 36, 3, 7, lvl, 4)
	f.magic_defense = _es(17, 28, 2, 5, lvl, 4)
	f.speed = _es(22, 30, 1, 2, lvl, 3)
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 20
	f.abilities = [EAB.siren_song(), AbilityDB.torrent()]
	return f

static func create_merfolk(n: String, lvl: int = 4) -> FighterData:
	var f := _base(n, "Merfolk", lvl)
	f.health = _es(86, 102, 4, 7, lvl, 4); f.max_health = f.health
	f.mana = _es(12, 16, 1, 3, lvl, 4); f.max_mana = f.mana
	f.physical_attack = _es(22, 26, 2, 4, lvl, 4)
	f.physical_defense = _es(12, 17, 1, 3, lvl, 4)
	f.magic_attack = _es(17, 22, 2, 4, lvl, 4)
	f.magic_defense = _es(14, 19, 1, 3, lvl, 4)
	f.speed = _es(22, 28, 1, 3, lvl, 4)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 15
	f.abilities = [EAB.trident_thrust(), EAB.tidal_splash()]
	return f

static func create_captain(n: String, lvl: int = 5) -> FighterData:
	var f := _base(n, "Captain", lvl)
	f.health = _es(102, 140, 5, 11, lvl, 5); f.max_health = f.health
	f.mana = _es(23, 49, 2, 7, lvl, 5); f.max_mana = f.mana
	f.physical_attack = _es(25, 36, 2, 5, lvl, 5)
	f.physical_defense = _es(21, 32, 2, 5, lvl, 5)
	f.magic_attack = _es(8, 16, 1, 3, lvl, 5)
	f.magic_defense = _es(8, 16, 1, 3, lvl, 5)
	f.speed = _es(18, 26, 1, 2, lvl, 5)
	f.crit_chance = 30; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.flintlock(), EAB.cannon_barrage(), EAB.bravado()]
	return f

static func create_pirate(n: String, lvl: int = 4) -> FighterData:
	var f := _base(n, "Pirate", lvl)
	f.health = _es(90, 124, 5, 11, lvl, 4); f.max_health = f.health
	f.mana = _es(16, 38, 2, 7, lvl, 4); f.max_mana = f.mana
	f.physical_attack = _es(20, 29, 2, 5, lvl, 4)
	f.physical_defense = _es(16, 25, 2, 5, lvl, 4)
	f.magic_attack = _es(8, 16, 1, 3, lvl, 4)
	f.magic_defense = _es(8, 16, 1, 3, lvl, 4)
	f.speed = _es(18, 28, 1, 3, lvl, 4)
	f.crit_chance = 20; f.crit_damage = 4; f.dodge_chance = 20
	f.abilities = [EAB.flintlock(), EAB.dirty_trick()]
	return f

# --- Prog 5-6: Branch battles ---

static func create_fire_wyrmling(n: String) -> FighterData:
	var f := _base(n, "Fire Wyrmling", 6)
	f.health = _fixed(108, 119); f.max_health = f.health
	f.mana = _fixed(25, 29); f.max_mana = f.mana
	f.physical_attack = _fixed(15, 19); f.physical_defense = _fixed(15, 19)
	f.magic_attack = _fixed(27, 32); f.magic_defense = _fixed(20, 24)
	f.speed = _fixed(28, 33)
	f.crit_chance = 19; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.dragon_breath(), EAB.tail_strike(), AbilityDB.roar()]
	return f

static func create_frost_wyrmling(n: String) -> FighterData:
	var f := _base(n, "Frost Wyrmling", 6)
	f.health = _fixed(110, 121); f.max_health = f.health
	f.mana = _fixed(20, 24); f.max_mana = f.mana
	f.physical_attack = _fixed(25, 30); f.physical_defense = _fixed(19, 23)
	f.magic_attack = _fixed(15, 19); f.magic_defense = _fixed(16, 20)
	f.speed = _fixed(28, 33)
	f.crit_chance = 19; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.claw(), EAB.tail_strike(), EAB.riptide()]
	return f

static func create_ringmaster(n: String) -> FighterData:
	var f := _base(n, "Ringmaster", 6)
	f.health = _fixed(93, 103); f.max_health = f.health
	f.mana = _fixed(28, 32); f.max_mana = f.mana
	f.physical_attack = _fixed(22, 26); f.physical_defense = _fixed(20, 24)
	f.magic_attack = _fixed(23, 27); f.magic_defense = _fixed(20, 24)
	f.speed = _fixed(32, 37)
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [EAB.whip_crack(), EAB.showstopper(), EAB.center_ring()]
	return f

static func create_harlequin(n: String) -> FighterData:
	var f := _base(n, "Harlequin", 6)
	f.health = _fixed(104, 116); f.max_health = f.health
	f.mana = _fixed(33, 37); f.max_mana = f.mana
	f.physical_attack = _fixed(22, 26); f.physical_defense = _fixed(19, 23)
	f.magic_attack = _fixed(35, 39); f.magic_defense = _fixed(22, 26)
	f.speed = _fixed(31, 36)
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 23
	f.abilities = [EAB.pantomime_wall(), EAB.prop_drop(), EAB.mime_trap()]
	return f

static func create_chanteuse(n: String) -> FighterData:
	var f := _base(n, "Chanteuse", 6)
	f.health = _fixed(84, 94); f.max_health = f.health
	f.mana = _fixed(34, 38); f.max_mana = f.mana
	f.physical_attack = _fixed(15, 19); f.physical_defense = _fixed(21, 25)
	f.magic_attack = _fixed(34, 38); f.magic_defense = _fixed(19, 23)
	f.speed = _fixed(36, 41)
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 23
	f.abilities = [EAB.aria(), EAB.crescendo(), EAB.cadence()]
	return f

static func create_android(n: String) -> FighterData:
	var f := _base(n, "Android", 6)
	f.health = _fixed(100, 112); f.max_health = f.health
	f.mana = _fixed(28, 33); f.max_mana = f.mana
	f.physical_attack = _fixed(26, 30); f.physical_defense = _fixed(17, 21)
	f.magic_attack = _fixed(23, 27); f.magic_defense = _fixed(20, 25)
	f.speed = _fixed(32, 37)
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.circuit_burst(), EAB.firewall(), EAB.overdrive()]
	return f

static func create_machinist(n: String) -> FighterData:
	var f := _base(n, "Machinist", 6)
	f.health = _fixed(100, 112); f.max_health = f.health
	f.mana = _fixed(21, 26); f.max_mana = f.mana
	f.physical_attack = _fixed(26, 30); f.physical_defense = _fixed(23, 28)
	f.magic_attack = _fixed(20, 24); f.magic_defense = _fixed(20, 24)
	f.speed = _fixed(30, 35)
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [EAB.seismic_charge(), EAB.reinforce(), EAB.dismantle()]
	return f

static func create_ironclad(n: String) -> FighterData:
	var f := _base(n, "Ironclad", 6)
	f.health = _fixed(87, 97); f.max_health = f.health
	f.mana = _fixed(21, 26); f.max_mana = f.mana
	f.physical_attack = _fixed(23, 27); f.physical_defense = _fixed(26, 30)
	f.magic_attack = _fixed(15, 19); f.magic_defense = _fixed(25, 29)
	f.speed = _fixed(24, 29)
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [EAB.hammer_blow(), EAB.temper(), EAB.steel_plating()]
	return f

static func create_commander(n: String) -> FighterData:
	var f := _base(n, "Commander", 6)
	f.health = _fixed(98, 110); f.max_health = f.health
	f.mana = _fixed(22, 26); f.max_mana = f.mana
	f.physical_attack = _fixed(25, 29); f.physical_defense = _fixed(26, 30)
	f.magic_attack = _fixed(11, 15); f.magic_defense = _fixed(22, 27)
	f.speed = _fixed(28, 33)
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.shield_wall(), EAB.rally_strike(), EAB.war_ward()]
	return f

static func create_draconian(n: String) -> FighterData:
	var f := _base(n, "Draconian", 6)
	f.health = _fixed(81, 91); f.max_health = f.health
	f.mana = _fixed(25, 29); f.max_mana = f.mana
	f.physical_attack = _fixed(29, 33); f.physical_defense = _fixed(17, 21)
	f.magic_attack = _fixed(29, 33); f.magic_defense = _fixed(20, 25)
	f.speed = _fixed(30, 35)
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 16
	f.abilities = [EAB.skewer(), EAB.drake_strike(), EAB.scale_guard()]
	return f

static func create_chaplain(n: String) -> FighterData:
	var f := _base(n, "Chaplain", 6)
	f.health = _fixed(80, 90); f.max_health = f.health
	f.mana = _fixed(32, 36); f.max_mana = f.mana
	f.physical_attack = _fixed(15, 19); f.physical_defense = _fixed(22, 26)
	f.magic_attack = _fixed(24, 28); f.magic_defense = _fixed(24, 28)
	f.speed = _fixed(27, 32)
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [EAB.blessing(), EAB.mace_strike(), EAB.enemy_consecrate()]
	return f

static func create_zombie(n: String, lvl: int = 6) -> FighterData:
	var f := _base(n, "Zombie", lvl)
	f.health = _es(98, 124, 6, 11, lvl, 6); f.max_health = f.health
	f.mana = _es(22, 35, 2, 5, lvl, 6); f.max_mana = f.mana
	f.physical_attack = _es(29, 39, 3, 5, lvl, 6)
	f.physical_defense = _es(18, 28, 2, 4, lvl, 6)
	f.magic_attack = _es(29, 39, 3, 5, lvl, 6)
	f.magic_defense = _es(18, 28, 2, 4, lvl, 6)
	f.speed = _es(24, 34, 1, 2, lvl, 6)
	f.crit_chance = 28; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.rend(), EAB.enemy_blight(), EAB.devour()]
	return f

static func create_ghoul(n: String, lvl: int = 6) -> FighterData:
	var f := _base(n, "Ghoul", lvl)
	f.health = _es(92, 105, 3, 6, lvl, 6); f.max_health = f.health
	f.mana = _es(12, 16, 1, 3, lvl, 6); f.max_mana = f.mana
	f.physical_attack = _es(22, 28, 2, 3, lvl, 6)
	f.physical_defense = _es(13, 18, 1, 2, lvl, 6)
	f.magic_attack = _es(10, 15, 1, 2, lvl, 6)
	f.magic_defense = _es(12, 16, 1, 2, lvl, 6)
	f.speed = _es(26, 32, 2, 3, lvl, 6)
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 15
	f.abilities = [EAB.claw(), EAB.paralyze(), EAB.devour()]
	return f

static func create_shade(n: String, lvl: int = 7) -> FighterData:
	var f := _base(n, "Shade", lvl)
	f.health = _es(108, 128, 5, 9, lvl, 7); f.max_health = f.health
	f.mana = _es(24, 34, 2, 5, lvl, 7); f.max_mana = f.mana
	f.physical_attack = _es(16, 22, 1, 3, lvl, 7)
	f.physical_defense = _es(15, 20, 1, 3, lvl, 7)
	f.magic_attack = _es(36, 44, 3, 5, lvl, 7)
	f.magic_defense = _es(18, 24, 2, 4, lvl, 7)
	f.speed = _es(33, 39, 2, 4, lvl, 7)
	f.crit_chance = 23; f.crit_damage = 2; f.dodge_chance = 33
	f.abilities = [AbilityDB.shadow_attack(), EAB.enemy_blight(), AbilityDB.frustrate()]
	return f

static func create_wraith(n: String, lvl: int = 7) -> FighterData:
	var f := _base(n, "Wraith", lvl)
	f.health = _es(123, 143, 5, 9, lvl, 7); f.max_health = f.health
	f.mana = _es(18, 22, 2, 4, lvl, 7); f.max_mana = f.mana
	f.physical_attack = _es(10, 14, 0, 2, lvl, 7)
	f.physical_defense = _es(12, 16, 1, 2, lvl, 7)
	f.magic_attack = _es(35, 43, 3, 5, lvl, 7)
	f.magic_defense = _es(18, 24, 2, 3, lvl, 7)
	f.speed = _es(31, 37, 2, 4, lvl, 7)
	f.crit_chance = 24; f.crit_damage = 3; f.dodge_chance = 26
	f.abilities = [EAB.soul_drain(), EAB.enemy_blight(), EAB.terrify()]
	return f


# =============================================================================
# Act III enemies (Progression 8-9)
# =============================================================================

static func create_royal_guard(n: String, lvl: int = 12) -> FighterData:
	var f := _base(n, "Royal Guard", lvl)
	f.health = _es(208, 238, 8, 12, lvl, 12); f.max_health = f.health
	f.mana = _es(16, 22, 2, 4, lvl, 12); f.max_mana = f.mana
	f.physical_attack = _es(41, 49, 3, 5, lvl, 12)
	f.physical_defense = _es(34, 40, 3, 4, lvl, 12)
	f.magic_attack = _es(6, 10, 0, 2, lvl, 12)
	f.magic_defense = _es(24, 30, 2, 3, lvl, 12)
	f.speed = _es(26, 32, 2, 3, lvl, 12)
	f.crit_chance = 18; f.crit_damage = 3; f.dodge_chance = 15
	f.abilities = [AbilityDB.shield_slam(), EAB.sword_strike(), EAB.defensive_formation()]
	return f

static func create_guard_sergeant(n: String, lvl: int = 12) -> FighterData:
	var f := _base(n, "Guard Sergeant", lvl)
	f.health = _es(218, 248, 8, 12, lvl, 12); f.max_health = f.health
	f.mana = _es(18, 24, 2, 4, lvl, 12); f.max_mana = f.mana
	f.physical_attack = _es(45, 53, 3, 5, lvl, 12)
	f.physical_defense = _es(24, 30, 2, 3, lvl, 12)
	f.magic_attack = _es(8, 12, 0, 2, lvl, 12)
	f.magic_defense = _es(20, 24, 1, 2, lvl, 12)
	f.speed = _es(28, 34, 2, 3, lvl, 12)
	f.crit_chance = 22; f.crit_damage = 4; f.dodge_chance = 12
	f.abilities = [EAB.sword_strike(), AbilityDB.rally(), EAB.decisive_blow()]
	return f

static func create_guard_archer(n: String, lvl: int = 12) -> FighterData:
	var f := _base(n, "Guard Archer", lvl)
	f.health = _es(178, 208, 6, 10, lvl, 12); f.max_health = f.health
	f.mana = _es(18, 24, 2, 4, lvl, 12); f.max_mana = f.mana
	f.physical_attack = _es(43, 51, 3, 5, lvl, 12)
	f.physical_defense = _es(18, 24, 1, 3, lvl, 12)
	f.magic_attack = _es(6, 10, 0, 2, lvl, 12)
	f.magic_defense = _es(18, 24, 1, 3, lvl, 12)
	f.speed = _es(32, 38, 3, 4, lvl, 12)
	f.crit_chance = 25; f.crit_damage = 4; f.dodge_chance = 20
	f.abilities = [EAB.arrow_shot(), EAB.volley(), EAB.pin_down()]
	return f

static func create_stranger(n: String, lvl: int = 16) -> FighterData:
	var f := _base(n, "Stranger", lvl)
	f.health = _es(582, 652, 16, 22, lvl, 16); f.max_health = f.health
	f.mana = _es(50, 58, 3, 5, lvl, 16); f.max_mana = f.mana
	f.physical_attack = _es(60, 68, 4, 6, lvl, 16)
	f.physical_defense = _es(34, 40, 2, 4, lvl, 16)
	f.magic_attack = _es(66, 76, 4, 7, lvl, 16)
	f.magic_defense = _es(36, 42, 2, 4, lvl, 16)
	f.speed = _es(38, 44, 2, 4, lvl, 16)
	f.crit_chance = 26; f.crit_damage = 5; f.dodge_chance = 24
	f.abilities = [EAB.shadow_strike(), EAB.dark_pulse(), EAB.void_shield(), EAB.drain()]
	return f


# =============================================================================
# Act IV-V enemies (Progression 10-13)
# =============================================================================

static func create_lich(n: String, lvl: int = 16) -> FighterData:
	var f := _base(n, "Lich", lvl)
	f.health = _es(290, 330, 8, 12, lvl, 16); f.max_health = f.health
	f.mana = _es(44, 52, 3, 5, lvl, 16); f.max_mana = f.mana
	f.physical_attack = _es(14, 18, 0, 2, lvl, 16)
	f.physical_defense = _es(24, 30, 2, 3, lvl, 16)
	f.magic_attack = _es(57, 65, 4, 6, lvl, 16)
	f.magic_defense = _es(42, 50, 3, 5, lvl, 16)
	f.speed = _es(34, 40, 2, 4, lvl, 16)
	f.crit_chance = 23; f.crit_damage = 5; f.dodge_chance = 18
	f.abilities = [EAB.death_bolt(), EAB.raise_dead(), EAB.soul_cage()]
	return f

static func create_ghast(n: String, lvl: int = 16) -> FighterData:
	var f := _base(n, "Ghast", lvl)
	f.health = _es(250, 290, 7, 10, lvl, 16); f.max_health = f.health
	f.mana = _es(22, 28, 2, 4, lvl, 16); f.max_mana = f.mana
	f.physical_attack = _es(51, 59, 3, 5, lvl, 16)
	f.physical_defense = _es(32, 38, 2, 4, lvl, 16)
	f.magic_attack = _es(18, 24, 1, 2, lvl, 16)
	f.magic_defense = _es(22, 28, 1, 3, lvl, 16)
	f.speed = _es(28, 34, 2, 3, lvl, 16)
	f.crit_chance = 17; f.crit_damage = 4; f.dodge_chance = 8
	f.abilities = [EAB.slam(), EAB.poison_cloud(), EAB.rend()]
	return f

static func create_demon(n: String, lvl: int = 16) -> FighterData:
	var f := _base(n, "Demon", lvl)
	f.health = _es(320, 360, 8, 12, lvl, 16); f.max_health = f.health
	f.mana = _es(48, 56, 3, 5, lvl, 16); f.max_mana = f.mana
	f.physical_attack = _es(24, 30, 1, 3, lvl, 16)
	f.physical_defense = _es(30, 36, 2, 4, lvl, 16)
	f.magic_attack = _es(60, 68, 4, 6, lvl, 16)
	f.magic_defense = _es(34, 40, 2, 4, lvl, 16)
	f.speed = _es(34, 40, 2, 4, lvl, 16)
	f.crit_chance = 22; f.crit_damage = 4; f.dodge_chance = 25
	f.abilities = [EAB.brimstone(), EAB.infernal_strike(), EAB.dread()]
	return f

static func create_corrupted_treant(n: String, lvl: int = 16) -> FighterData:
	var f := _base(n, "Corrupted Treant", lvl)
	f.health = _es(300, 340, 8, 12, lvl, 16); f.max_health = f.health
	f.mana = _es(24, 30, 2, 4, lvl, 16); f.max_mana = f.mana
	f.physical_attack = _es(48, 56, 3, 5, lvl, 16)
	f.physical_defense = _es(40, 46, 3, 5, lvl, 16)
	f.magic_attack = _es(16, 22, 1, 2, lvl, 16)
	f.magic_defense = _es(30, 36, 2, 4, lvl, 16)
	f.speed = _es(26, 32, 1, 3, lvl, 16)
	f.crit_chance = 16; f.crit_damage = 4; f.dodge_chance = 11
	f.abilities = [EAB.vine_whip(), EAB.root_slam(), EAB.bark_shield()]
	return f

static func create_hellion(n: String, lvl: int = 17) -> FighterData:
	var f := _base(n, "Hellion", lvl)
	f.health = _fixed(265, 305); f.max_health = f.health
	f.mana = _fixed(34, 40); f.max_mana = f.mana
	f.physical_attack = _fixed(61, 69); f.physical_defense = _fixed(30, 36)
	f.magic_attack = _fixed(52, 60); f.magic_defense = _fixed(28, 34)
	f.speed = _fixed(36, 42)
	f.crit_chance = 27; f.crit_damage = 4; f.dodge_chance = 21
	f.abilities = [EAB.infernal_strike(), EAB.shadow_strike(), EAB.enemy_hex()]
	return f

static func create_fiendling(n: String, lvl: int = 17) -> FighterData:
	var f := _base(n, "Fiendling", lvl)
	f.health = _fixed(240, 280); f.max_health = f.health
	f.mana = _fixed(40, 48); f.max_mana = f.mana
	f.physical_attack = _fixed(20, 26); f.physical_defense = _fixed(24, 30)
	f.magic_attack = _fixed(68, 78); f.magic_defense = _fixed(32, 38)
	f.speed = _fixed(38, 44)
	f.crit_chance = 25; f.crit_damage = 4; f.dodge_chance = 21
	f.abilities = [EAB.brimstone(), EAB.dread(), EAB.enemy_hex()]
	return f

static func create_dragon(n: String, lvl: int = 17) -> FighterData:
	var f := _base(n, "Dragon", lvl)
	f.health = _fixed(402, 442); f.max_health = f.health
	f.mana = _fixed(42, 50); f.max_mana = f.mana
	f.physical_attack = _fixed(40, 48); f.physical_defense = _fixed(36, 42)
	f.magic_attack = _fixed(61, 69); f.magic_defense = _fixed(32, 38)
	f.speed = _fixed(34, 40)
	f.crit_chance = 28; f.crit_damage = 5; f.dodge_chance = 21
	f.abilities = [EAB.dragon_breath(), EAB.tail_strike(), AbilityDB.roar()]
	return f

static func create_blighted_stag(n: String, lvl: int = 17) -> FighterData:
	var f := _base(n, "Blighted Stag", lvl)
	f.health = _fixed(270, 310); f.max_health = f.health
	f.mana = _fixed(28, 34); f.max_mana = f.mana
	f.physical_attack = _fixed(56, 64); f.physical_defense = _fixed(26, 32)
	f.magic_attack = _fixed(24, 30); f.magic_defense = _fixed(24, 30)
	f.speed = _fixed(38, 44)
	f.crit_chance = 19; f.crit_damage = 4; f.dodge_chance = 20
	f.abilities = [EAB.antler_charge(), EAB.rot_aura(), EAB.enemy_blight()]
	return f

static func create_dark_knight(n: String, lvl: int = 18) -> FighterData:
	var f := _base(n, "Dark Knight", lvl)
	f.health = _es(358, 398, 8, 12, lvl, 18); f.max_health = f.health
	f.mana = _es(30, 38, 3, 5, lvl, 18); f.max_mana = f.mana
	f.physical_attack = _es(64, 72, 4, 6, lvl, 18)
	f.physical_defense = _es(40, 48, 3, 5, lvl, 18)
	f.magic_attack = _es(34, 42, 2, 4, lvl, 18)
	f.magic_defense = _es(34, 42, 2, 4, lvl, 18)
	f.speed = _es(34, 40, 2, 4, lvl, 18)
	f.crit_chance = 26; f.crit_damage = 5; f.dodge_chance = 19
	f.abilities = [EAB.dark_blade(), EAB.shadow_guard(), EAB.cleave()]
	return f

static func create_fell_hound(n: String, lvl: int = 18) -> FighterData:
	var f := _base(n, "Fell Hound", lvl)
	f.health = _es(284, 324, 7, 10, lvl, 18); f.max_health = f.health
	f.mana = _es(30, 38, 3, 5, lvl, 18); f.max_mana = f.mana
	f.physical_attack = _es(24, 30, 1, 3, lvl, 18)
	f.physical_defense = _es(26, 32, 2, 3, lvl, 18)
	f.magic_attack = _es(55, 63, 3, 5, lvl, 18)
	f.magic_defense = _es(32, 38, 2, 4, lvl, 18)
	f.speed = _es(40, 46, 3, 5, lvl, 18)
	f.crit_chance = 22; f.crit_damage = 4; f.dodge_chance = 24
	f.abilities = [EAB.shadow_bite(), EAB.howl_of_dread(), EAB.enemy_blight()]
	return f

static func create_imp(n: String, lvl: int = 18) -> FighterData:
	var f := _base(n, "Imp", lvl)
	f.health = _es(250, 290, 7, 10, lvl, 18); f.max_health = f.health
	f.mana = _es(40, 48, 3, 5, lvl, 18); f.max_mana = f.mana
	f.physical_attack = _es(14, 18, 0, 2, lvl, 18)
	f.physical_defense = _es(18, 24, 1, 3, lvl, 18)
	f.magic_attack = _es(68, 78, 5, 7, lvl, 18)
	f.magic_defense = _es(28, 34, 2, 4, lvl, 18)
	f.speed = _es(44, 50, 3, 5, lvl, 18)
	f.crit_chance = 26; f.crit_damage = 4; f.dodge_chance = 30
	f.abilities = [EAB.spark(), AbilityDB.ember(), EAB.enemy_hex()]
	return f

static func create_cave_spider(n: String, lvl: int = 18) -> FighterData:
	var f := _base(n, "Cave Spider", lvl)
	f.health = _es(362, 402, 10, 14, lvl, 18); f.max_health = f.health
	f.mana = _es(26, 32, 2, 4, lvl, 18); f.max_mana = f.mana
	f.physical_attack = _es(70, 80, 5, 7, lvl, 18)
	f.physical_defense = _es(30, 36, 2, 4, lvl, 18)
	f.magic_attack = _es(16, 22, 1, 2, lvl, 18)
	f.magic_defense = _es(26, 32, 2, 3, lvl, 18)
	f.speed = _es(38, 44, 3, 5, lvl, 18)
	f.crit_chance = 28; f.crit_damage = 4; f.dodge_chance = 24
	f.abilities = [EAB.venomous_bite(), EAB.web(), EAB.poison_cloud()]
	return f

static func create_stranger_final(n: String, lvl: int = 20) -> FighterData:
	var f := _base(n, "Stranger", lvl)
	f.class_id = "StrangerFinal"
	f.health = _es(890, 990, 18, 24, lvl, 20); f.max_health = f.health
	f.mana = _es(70, 80, 5, 7, lvl, 20); f.max_mana = f.mana
	f.physical_attack = _es(76, 86, 4, 6, lvl, 20)
	f.physical_defense = _es(52, 60, 3, 5, lvl, 20)
	f.magic_attack = _es(83, 93, 5, 7, lvl, 20)
	f.magic_defense = _es(52, 60, 3, 5, lvl, 20)
	f.speed = _es(49, 55, 3, 5, lvl, 20)
	f.crit_chance = 29; f.crit_damage = 6; f.dodge_chance = 26
	f.abilities = [EAB.shadow_blast(), EAB.siphon(), EAB.dark_veil(), EAB.unmake(), AbilityDB.corruption()]
	return f
