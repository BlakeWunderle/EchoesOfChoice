class_name FighterDBT1

## Tier 1 class upgrades and level-up growth rates.
## Upgrade functions apply bonuses from C# ApplyUpgradeBonuses().
## Growth rates from C# IncreaseLevel(). random.Next(min, max) → randi_range(min, max-1).

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")
const PAB := preload("res://scripts/data/ability_db_player.gd")


# =============================================================================
# Squire tree
# =============================================================================

static func upgrade_to_duelist(f: FighterData) -> void:
	f.class_id = "Duelist"; f.character_type = "Duelist"
	f.physical_attack += 3; f.physical_defense += 2; f.speed += 3
	f.crit_chance = 30; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [AbilityDB.slash(), PAB.feint()]
	f.upgrade_items = ["Horse", "Spear"]

static func upgrade_to_ranger(f: FighterData) -> void:
	f.class_id = "Ranger"; f.character_type = "Ranger"
	f.physical_attack += 3; f.physical_defense += 2; f.speed += 4
	f.crit_chance = 30; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [PAB.pierce(), PAB.double_arrow()]
	f.upgrade_items = ["Gun", "Trap"]

static func upgrade_to_martial_artist(f: FighterData) -> void:
	f.class_id = "MartialArtist"; f.character_type = "Martial Artist"
	f.health += 4; f.max_health += 4
	f.physical_attack += 2; f.physical_defense += 2; f.speed += 4
	f.crit_chance = 30; f.crit_damage = 3; f.dodge_chance = 20
	f.abilities = [PAB.punch(), PAB.topple()]
	f.upgrade_items = ["Sword", "Staff"]

static func _lu_duelist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(9, 11); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 5); f.physical_defense += randi_range(2, 4)
	f.magic_attack += randi_range(1, 2); f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(2, 2)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(1, 2)

static func _lu_ranger(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(9, 11); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 4); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 4); f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(1, 2)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(1, 2)

static func _lu_martial_artist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 5); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 4); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(2, 2)
	f.dodge_chance += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Mage tree
# =============================================================================

static func upgrade_to_invoker(f: FighterData) -> void:
	f.class_id = "Invoker"; f.character_type = "Invoker"
	f.health += 3; f.max_health += 3; f.magic_attack += 3; f.magic_defense += 2
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [AbilityDB.arcane_bolt(), PAB.elemental_surge()]
	f.upgrade_items = ["FireStone", "WaterStone", "LightningStone"]

static func upgrade_to_acolyte(f: FighterData) -> void:
	f.class_id = "Acolyte"; f.character_type = "Acolyte"
	f.health += 3; f.max_health += 3; f.magic_defense += 2
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.cure(), PAB.protect(), PAB.radiance()]
	f.upgrade_items = ["Hammer", "HolyBook", "DarkOrb"]

static func _lu_invoker(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp := randi_range(3, 5); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(3, 5); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 1)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)

static func _lu_acolyte(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp := randi_range(4, 6); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 4); f.magic_defense += randi_range(3, 4)
	f.speed += randi_range(1, 1)


# =============================================================================
# Entertainer tree
# =============================================================================

static func upgrade_to_bard(f: FighterData) -> void:
	f.class_id = "Bard"; f.character_type = "Bard"
	f.magic_attack += 3; f.speed += 3
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 20
	f.abilities = [PAB.seduce(), PAB.melody(), PAB.encourage()]
	f.upgrade_items = ["WarHorn", "Hat"]

static func upgrade_to_dervish(f: FighterData) -> void:
	f.class_id = "Dervish"; f.character_type = "Dervish"
	f.physical_attack += 2; f.speed += 6
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 25
	f.abilities = [PAB.seduce(), PAB.dance()]
	f.upgrade_items = ["Light", "Paint"]

static func upgrade_to_orator(f: FighterData) -> void:
	f.class_id = "Orator"; f.character_type = "Orator"
	f.magic_attack += 3; f.magic_defense += 3
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.oration(), PAB.encourage()]
	f.upgrade_items = ["Medal", "Pen"]

static func _lu_bard(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 5); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 5); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 2)
	f.dodge_chance += randi_range(0, 1)

static func _lu_dervish(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp := randi_range(3, 5); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 4); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 5); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)

static func _lu_orator(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 4); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 2)


# =============================================================================
# Tinker tree
# =============================================================================

static func upgrade_to_artificer(f: FighterData) -> void:
	f.class_id = "Artificer"; f.character_type = "Artificer"
	f.physical_attack += 3; f.magic_attack += 2
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [AbilityDB.energy_blast(), PAB.magical_tinkering()]
	f.upgrade_items = ["Potion", "Hammer"]

static func upgrade_to_cosmologist(f: FighterData) -> void:
	f.class_id = "Cosmologist"; f.character_type = "Philosopher"
	f.health += 3; f.max_health += 3; f.magic_attack += 4; f.speed += 4
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.time_warp(), PAB.black_hole(), PAB.gravity()]
	f.upgrade_items = ["TimeMachine", "Telescope"]

static func upgrade_to_arithmancer(f: FighterData) -> void:
	f.class_id = "Arithmancer"; f.character_type = "Arithmancer"
	f.magic_attack += 3; f.magic_defense += 2
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.recite(), PAB.calculate()]
	f.upgrade_items = ["ClockworkCore", "Computer"]

static func _lu_artificer(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(8, 10); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 5); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 4); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 1)

static func _lu_cosmologist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(11, 13); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 4); f.magic_defense += randi_range(3, 5)
	f.speed += randi_range(1, 1)

static func _lu_arithmancer(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(8, 10); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 5); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 1)


# =============================================================================
# Wildling tree
# =============================================================================

static func upgrade_to_herbalist(f: FighterData) -> void:
	f.class_id = "Herbalist"; f.character_type = "Herbalist"
	f.health += 3; f.max_health += 3; f.magic_attack += 3; f.magic_defense += 2
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.mending_herbs(), PAB.sapping_vine()]
	f.upgrade_items = ["Venom", "Seedling"]

static func upgrade_to_shaman(f: FighterData) -> void:
	f.class_id = "Shaman"; f.character_type = "Shaman"
	f.health += 6; f.max_health += 6; f.physical_attack += 3; f.magic_attack += 4
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.spectral_lance(), PAB.player_hex()]
	f.upgrade_items = ["Shrunkenhead", "SpiritOrb"]

static func upgrade_to_beastcaller(f: FighterData) -> void:
	f.class_id = "Beastcaller"; f.character_type = "Beastcaller"
	f.health += 4; f.max_health += 4; f.physical_attack += 3; f.speed += 3
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.feral_strike(), PAB.pack_howl()]
	f.upgrade_items = ["Feather", "Pelt"]

static func _lu_herbalist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(3, 4); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 1)

static func _lu_shaman(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(6, 8); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(2, 3); f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(1, 2)
	f.dodge_chance += randi_range(0, 1)

static func _lu_beastcaller(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(7, 9); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 4); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(1, 2); f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(1, 2)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Level-up router
# =============================================================================

static func level_up(f: FighterData) -> bool:
	match f.class_id:
		"Duelist": _lu_duelist(f)
		"Ranger": _lu_ranger(f)
		"MartialArtist": _lu_martial_artist(f)
		"Invoker": _lu_invoker(f)
		"Acolyte": _lu_acolyte(f)
		"Bard": _lu_bard(f)
		"Dervish": _lu_dervish(f)
		"Orator": _lu_orator(f)
		"Artificer": _lu_artificer(f)
		"Cosmologist": _lu_cosmologist(f)
		"Arithmancer": _lu_arithmancer(f)
		"Herbalist": _lu_herbalist(f)
		"Shaman": _lu_shaman(f)
		"Beastcaller": _lu_beastcaller(f)
		_: return false
	return true
