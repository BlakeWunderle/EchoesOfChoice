class_name EnemyDB

## Act I enemy factory (Progression 0-2): city thugs, forest beasts, bandits.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")
const EAB := preload("res://scripts/data/story1/enemy_ability_db.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# Act I enemies (Progression 0-1)
# =============================================================================

static func create_thug(n: String, lvl: int = 1) -> FighterData:
	var f := EH.base(n, "Thug", lvl)
	f.health = EH.es(50, 58, 3, 6, lvl, 1); f.max_health = f.health
	f.mana = EH.es(2, 5, 1, 2, lvl, 1); f.max_mana = f.mana
	f.physical_attack = EH.es(19, 22, 1, 3, lvl, 1)
	f.physical_defense = EH.es(9, 12, 1, 2, lvl, 1)
	f.magic_attack = EH.es(6, 9, 0, 2, lvl, 1)
	f.magic_defense = EH.es(7, 10, 1, 2, lvl, 1)
	f.speed = EH.es(20, 26, 1, 2, lvl, 1)
	f.crit_chance = 7; f.crit_damage = 1; f.dodge_chance = 3
	f.abilities = [AbilityDB.haymaker()]
	f.flavor_text = "Street toughs who prey on travelers after dark."
	return f

static func create_ruffian(n: String, lvl: int = 1) -> FighterData:
	var f := EH.base(n, "Ruffian", lvl)
	f.health = EH.es(47, 56, 3, 5, lvl, 1); f.max_health = f.health
	f.mana = EH.es(2, 5, 1, 2, lvl, 1); f.max_mana = f.mana
	f.physical_attack = EH.es(17, 21, 1, 3, lvl, 1)
	f.physical_defense = EH.es(7, 10, 1, 2, lvl, 1)
	f.magic_attack = EH.es(5, 8, 0, 1, lvl, 1)
	f.magic_defense = EH.es(7, 10, 1, 2, lvl, 1)
	f.speed = EH.es(18, 24, 1, 2, lvl, 1)
	f.crit_chance = 7; f.crit_damage = 1; f.dodge_chance = 2
	f.abilities = [EAB.headbutt(), AbilityDB.intimidate()]
	f.flavor_text = "Brawlers with more muscle than sense, spoiling for a fight."
	return f

static func create_pickpocket(n: String, lvl: int = 1) -> FighterData:
	var f := EH.base(n, "Pickpocket", lvl)
	f.health = EH.es(35, 43, 2, 4, lvl, 1); f.max_health = f.health
	f.mana = EH.es(3, 5, 1, 2, lvl, 1); f.max_mana = f.mana
	f.physical_attack = EH.es(15, 18, 1, 3, lvl, 1)
	f.physical_defense = EH.es(5, 7, 0, 2, lvl, 1)
	f.magic_attack = EH.es(5, 7, 0, 1, lvl, 1)
	f.magic_defense = EH.es(4, 7, 0, 2, lvl, 1)
	f.speed = EH.es(22, 28, 2, 3, lvl, 1)
	f.crit_chance = 11; f.crit_damage = 1; f.dodge_chance = 8
	f.abilities = [AbilityDB.quick_stab(), AbilityDB.pilfer()]
	f.flavor_text = "Nimble thieves who strike fast and vanish into the crowd."
	return f


# =============================================================================
# Act I enemies (Progression 2)
# =============================================================================

static func create_wolf(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Wolf", lvl)
	f.health = EH.es(52, 61, 3, 5, lvl, 2); f.max_health = f.health
	f.mana = EH.es(4, 6, 1, 2, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(22, 25, 2, 3, lvl, 2)
	f.physical_defense = EH.es(7, 10, 1, 2, lvl, 2)
	f.magic_attack = EH.es(5, 7, 0, 1, lvl, 2)
	f.magic_defense = EH.es(7, 10, 1, 2, lvl, 2)
	f.speed = EH.es(24, 28, 2, 3, lvl, 2)
	f.crit_chance = 7; f.crit_damage = 1; f.dodge_chance = 11
	f.abilities = [EAB.bite(), EAB.howl()]
	f.flavor_text = "Forest predators that hunt in packs, emboldened by moonlight."
	return f

static func create_boar(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Boar", lvl)
	f.health = EH.es(63, 72, 4, 6, lvl, 2); f.max_health = f.health
	f.mana = EH.es(4, 6, 1, 2, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(23, 26, 2, 3, lvl, 2)
	f.physical_defense = EH.es(10, 13, 1, 2, lvl, 2)
	f.magic_attack = EH.es(5, 7, 0, 1, lvl, 2)
	f.magic_defense = EH.es(8, 11, 1, 2, lvl, 2)
	f.speed = EH.es(18, 23, 1, 2, lvl, 2)
	f.crit_chance = 7; f.crit_damage = 2; f.dodge_chance = 3
	f.abilities = [EAB.gore(), EAB.charge()]
	f.flavor_text = "Thick-skinned beasts that charge without warning. Their tusks can shatter bone."
	return f

static func create_thornviper(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Thornviper", lvl)
	f.health = EH.es(35, 42, 2, 4, lvl, 2); f.max_health = f.health
	f.mana = EH.es(6, 8, 1, 2, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(17, 20, 1, 2, lvl, 2)
	f.physical_defense = EH.es(7, 10, 0, 1, lvl, 2)
	f.magic_attack = EH.es(17, 20, 1, 2, lvl, 2)
	f.magic_defense = EH.es(5, 8, 1, 2, lvl, 2)
	f.speed = EH.es(26, 31, 2, 3, lvl, 2)
	f.crit_chance = 9; f.crit_damage = 1; f.dodge_chance = 13
	f.abilities = [EAB.fang_strike(), EAB.venom()]
	f.flavor_text = "A sleek forest serpent with barbed scales and venom that burns like fire. It strikes from the undergrowth without warning."
	return f


static func create_goblin(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Goblin", lvl)
	f.health = EH.es(41, 53, 3, 5, lvl, 2); f.max_health = f.health
	f.mana = EH.es(4, 6, 1, 2, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(20, 24, 2, 3, lvl, 2)
	f.physical_defense = EH.es(9, 12, 1, 2, lvl, 2)
	f.magic_attack = EH.es(6, 9, 0, 2, lvl, 2)
	f.magic_defense = EH.es(3, 6, 0, 2, lvl, 2)
	f.speed = EH.es(25, 32, 2, 4, lvl, 2)
	f.crit_chance = 9; f.crit_damage = 1; f.dodge_chance = 18
	f.abilities = [EAB.stab(), EAB.throw_rock(), EAB.scurry()]
	f.flavor_text = "Small, vicious, and surprisingly quick. What they lack in strength they make up for in cunning."
	return f

static func create_hound(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Hound", lvl)
	f.health = EH.es(49, 57, 3, 5, lvl, 2); f.max_health = f.health
	f.mana = EH.es(5, 7, 1, 2, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(11, 14, 0, 2, lvl, 2)
	f.physical_defense = EH.es(7, 10, 1, 2, lvl, 2)
	f.magic_attack = EH.es(20, 26, 2, 3, lvl, 2)
	f.magic_defense = EH.es(8, 11, 1, 2, lvl, 2)
	f.speed = EH.es(26, 31, 2, 3, lvl, 2)
	f.crit_chance = 9; f.crit_damage = 1; f.dodge_chance = 11
	f.abilities = [EAB.baleful_howl(), EAB.shadow_bite()]
	f.flavor_text = "Not a stray. Something is wrong with this animal. Its eyes flicker with a pale light and its snarl reverberates in ways that have nothing to do with sound."
	return f

static func create_bandit(n: String, lvl: int = 3) -> FighterData:
	var f := EH.base(n, "Bandit", lvl)
	f.health = EH.es(60, 72, 4, 7, lvl, 3); f.max_health = f.health
	f.mana = EH.es(5, 7, 1, 2, lvl, 3); f.max_mana = f.mana
	f.physical_attack = EH.es(26, 33, 2, 3, lvl, 3)
	f.physical_defense = EH.es(12, 15, 1, 2, lvl, 3)
	f.magic_attack = EH.es(7, 10, 0, 2, lvl, 3)
	f.magic_defense = EH.es(5, 9, 1, 2, lvl, 3)
	f.speed = EH.es(25, 31, 1, 3, lvl, 3)
	f.crit_chance = 15; f.crit_damage = 2; f.dodge_chance = 8
	f.abilities = [EAB.bushwhack(), EAB.ambush()]
	f.flavor_text = "Outlaws who lurk along forest roads, striking from the cover of the trees."
	return f
