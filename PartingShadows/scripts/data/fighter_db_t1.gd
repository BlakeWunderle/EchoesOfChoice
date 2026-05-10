class_name FighterDBT1

## Tier 1 class upgrades and level-up growth rates.
## Upgrade functions apply bonuses from C# ApplyUpgradeBonuses().
## Growth rates from C# IncreaseLevel(). random.Next(min, max) → randi_range(min, max-1).

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")
const PAB := preload("res://scripts/data/ability_db_player.gd")
const PAB_B := preload("res://scripts/data/ability_db_player_b.gd")


# =============================================================================
# Squire tree
# =============================================================================

static func upgrade_to_duelist(f: FighterData) -> void:
	f.class_id = "Duelist"; f.character_type = "Duelist"
	f.health += 3; f.max_health += 3; f.mana += 1; f.max_mana += 1
	f.physical_attack += 3; f.physical_defense += 2; f.magic_attack += 1; f.magic_defense += 2
	f.speed += 3; f.crit_chance += 5; f.crit_damage += 1; f.dodge_chance += 1
	f.abilities = [PAB.lunge(), PAB.feint(), PAB.riposte()]
	f.upgrade_items = ["Horse", "Spear"]

static func upgrade_to_ranger(f: FighterData) -> void:
	f.class_id = "Ranger"; f.character_type = "Ranger"
	f.health += 3; f.max_health += 3; f.mana += 1; f.max_mana += 1
	f.physical_attack += 3; f.physical_defense += 2; f.magic_attack += 1; f.magic_defense += 2
	f.speed += 4; f.crit_chance += 5; f.crit_damage += 1; f.dodge_chance += 1
	f.abilities = [PAB.pierce(), PAB.double_arrow(), PAB.mark_prey()]
	f.upgrade_items = ["Gun", "Trap"]

static func upgrade_to_martial_artist(f: FighterData) -> void:
	f.class_id = "MartialArtist"; f.character_type = "Martial Artist"
	f.health += 4; f.max_health += 4; f.mana += 1; f.max_mana += 1
	f.physical_attack += 2; f.physical_defense += 2; f.magic_attack += 1; f.magic_defense += 1
	f.speed += 3; f.crit_chance += 2; f.crit_damage += 1; f.dodge_chance += 3
	f.abilities = [PAB.punch(), PAB.topple(), PAB.inner_focus()]
	f.upgrade_items = ["Sword", "Staff"]

static func _lu_duelist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(9, 11); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 5); f.physical_defense += randi_range(2, 4)
	f.magic_attack += randi_range(1, 2); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(2, 2)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(1, 2)

static func _lu_ranger(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(9, 11); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 5); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(1, 2); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(2, 2)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(1, 2)

static func _lu_martial_artist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(10, 12); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 5); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(3, 4); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(2, 2)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Mage tree
# =============================================================================

static func upgrade_to_invoker(f: FighterData) -> void:
	f.class_id = "Invoker"; f.character_type = "Invoker"
	f.health += 3; f.max_health += 3; f.mana += 2; f.max_mana += 2
	f.physical_attack += 1; f.physical_defense += 1; f.magic_attack += 4; f.magic_defense += 2
	f.speed += 1; f.crit_chance += 1; f.crit_damage += 1; f.dodge_chance += 1
	f.abilities = [PAB.elemental_barrage(), PAB.elemental_surge(), PAB.elemental_focus()]
	f.upgrade_items = ["FireStone", "WaterStone", "LightningStone"]

static func upgrade_to_acolyte(f: FighterData) -> void:
	f.class_id = "Acolyte"; f.character_type = "Acolyte"
	f.health += 3; f.max_health += 3; f.mana += 2; f.max_mana += 2
	f.physical_attack += 1; f.physical_defense += 1; f.magic_attack += 2; f.magic_defense += 2
	f.speed += 1; f.crit_chance += 1; f.crit_damage += 1; f.dodge_chance += 1
	f.abilities = [PAB.cure(), PAB.protect(), PAB.radiance()]
	f.upgrade_items = ["Hammer", "HolyBook", "DarkOrb"]

static func _lu_invoker(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(7, 9); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(4, 5); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)

static func _lu_acolyte(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 5); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)


# =============================================================================
# Entertainer tree
# =============================================================================

static func upgrade_to_bard(f: FighterData) -> void:
	f.class_id = "Bard"; f.character_type = "Bard"
	f.health += 3; f.max_health += 3; f.mana += 1; f.max_mana += 1
	f.physical_attack += 1; f.physical_defense += 1; f.magic_attack += 3; f.magic_defense += 1
	f.speed += 3; f.crit_chance += 1; f.crit_damage += 1; f.dodge_chance += 2
	f.abilities = [PAB.seduce(), PAB.melody(), PAB.encourage()]
	f.upgrade_items = ["WarHorn", "Hat"]

static func upgrade_to_dervish(f: FighterData) -> void:
	f.class_id = "Dervish"; f.character_type = "Dervish"
	f.health += 3; f.max_health += 3; f.mana += 1; f.max_mana += 1
	f.physical_attack += 2; f.physical_defense += 1; f.magic_attack += 1; f.magic_defense += 2
	f.speed += 2; f.crit_chance += 1; f.crit_damage += 1; f.dodge_chance += 2
	f.abilities = [PAB.mesmerize(), PAB.dance(), PAB.whirling_step()]
	f.upgrade_items = ["Light", "Paint"]

static func upgrade_to_orator(f: FighterData) -> void:
	f.class_id = "Orator"; f.character_type = "Orator"
	f.health += 3; f.max_health += 3; f.mana += 1; f.max_mana += 1
	f.physical_attack += 1; f.physical_defense += 1; f.magic_attack += 4; f.magic_defense += 3
	f.speed += 1; f.crit_chance += 1; f.crit_damage += 1; f.dodge_chance += 1
	f.abilities = [PAB.oration(), PAB.encourage(), PAB.rebuke()]
	f.upgrade_items = ["Medal", "Pen"]

static func _lu_bard(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 5); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 2)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)

static func _lu_dervish(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 4); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 5); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)

static func _lu_orator(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(4, 5); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)


# =============================================================================
# Tinker tree
# =============================================================================

static func upgrade_to_artificer(f: FighterData) -> void:
	f.class_id = "Artificer"; f.character_type = "Artificer"
	f.health += 3; f.max_health += 3; f.mana += 1; f.max_mana += 1
	f.physical_attack += 1; f.physical_defense += 1; f.magic_attack += 3; f.magic_defense += 2
	f.speed += 1; f.crit_chance += 1; f.crit_damage += 1; f.dodge_chance += 1
	f.abilities = [PAB_B.volatile_flask(), PAB_B.magical_tinkering(), PAB_B.healing_draught()]
	f.upgrade_items = ["Potion", "Hammer"]

static func upgrade_to_philosopher(f: FighterData) -> void:
	f.class_id = "Philosopher"; f.character_type = "Philosopher"
	f.health += 3; f.max_health += 3; f.mana += 2; f.max_mana += 2
	f.physical_attack += 1; f.physical_defense += 1; f.magic_attack += 4; f.magic_defense += 1
	f.speed += 4; f.crit_chance += 1; f.crit_damage += 1; f.dodge_chance += 1
	f.abilities = [PAB_B.time_warp(), PAB_B.black_hole(), PAB_B.gravity()]
	f.upgrade_items = ["TimeMachine", "Telescope"]

static func upgrade_to_arithmancer(f: FighterData) -> void:
	f.class_id = "Arithmancer"; f.character_type = "Arithmancer"
	f.health += 3; f.max_health += 3; f.mana += 2; f.max_mana += 2
	f.physical_attack += 1; f.physical_defense += 1; f.magic_attack += 4; f.magic_defense += 2
	f.speed += 2; f.crit_chance += 1; f.crit_damage += 1; f.dodge_chance += 1
	f.abilities = [PAB_B.theorem(), PAB_B.calculate(), PAB_B.probability()]
	f.upgrade_items = ["ClockworkCore", "Computer"]

static func _lu_artificer(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(6, 8); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(4, 6); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)

static func _lu_philosopher(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(8, 10); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(5, 6); f.magic_defense += randi_range(3, 5)
	f.speed += randi_range(1, 1)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)

static func _lu_arithmancer(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(10, 12); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(4, 6); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)


# =============================================================================
# Wildling tree
# =============================================================================

static func upgrade_to_herbalist(f: FighterData) -> void:
	f.class_id = "Herbalist"; f.character_type = "Herbalist"
	f.health += 3; f.max_health += 3; f.mana += 1; f.max_mana += 1
	f.physical_attack += 1; f.physical_defense += 1; f.magic_attack += 2; f.magic_defense += 2
	f.speed += 1; f.crit_chance += 1; f.crit_damage += 1; f.dodge_chance += 1
	f.abilities = [PAB_B.mending_herbs(), PAB_B.sapping_vine(), PAB_B.thorn_spray()]
	f.upgrade_items = ["Venom", "Seedling"]

static func upgrade_to_shaman(f: FighterData) -> void:
	f.class_id = "Shaman"; f.character_type = "Shaman"
	f.health += 6; f.max_health += 6; f.mana += 1; f.max_mana += 1
	f.physical_attack += 2; f.physical_defense += 2; f.magic_attack += 4; f.magic_defense += 2
	f.speed += 1; f.crit_chance += 1; f.crit_damage += 1; f.dodge_chance += 1
	f.abilities = [PAB_B.spirit_bolt(), PAB_B.ancestral_curse(), PAB_B.spirit_veil()]
	f.upgrade_items = ["Shrunkenhead", "SpiritOrb"]

static func upgrade_to_beastcaller(f: FighterData) -> void:
	f.class_id = "Beastcaller"; f.character_type = "Beastcaller"
	f.health += 4; f.max_health += 4; f.mana += 1; f.max_mana += 1
	f.physical_attack += 3; f.physical_defense += 1; f.magic_attack += 1; f.magic_defense += 1
	f.speed += 3; f.crit_chance += 2; f.crit_damage += 1; f.dodge_chance += 2
	f.abilities = [PAB_B.feral_strike(), PAB_B.pack_howl(), PAB_B.stampede()]
	f.upgrade_items = ["Feather", "Pelt"]

static func _lu_herbalist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(4, 5); f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)

static func _lu_shaman(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(7, 9); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(4, 5); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 2)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)

static func _lu_beastcaller(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(7, 9); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 4); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(1, 2); f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(1, 2)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Wanderer tree
# =============================================================================

static func upgrade_to_sentinel(f: FighterData) -> void:
	f.class_id = "Sentinel"; f.character_type = "Sentinel"
	f.health += 5; f.max_health += 5; f.mana += 1; f.max_mana += 1
	f.physical_attack += 1; f.physical_defense += 2; f.magic_attack += 1; f.magic_defense += 4
	f.speed += 1; f.crit_chance += 2; f.crit_damage += 1; f.dodge_chance += 2
	f.abilities = [PAB_B.shield_bash(), PAB_B.barrier(), PAB_B.fortify()]
	f.upgrade_items = ["Fortress", "Mirror"]

static func upgrade_to_pathfinder(f: FighterData) -> void:
	f.class_id = "Pathfinder"; f.character_type = "Pathfinder"
	f.health += 3; f.max_health += 3; f.mana += 1; f.max_mana += 1
	f.physical_attack += 2; f.physical_defense += 1; f.magic_attack += 2; f.magic_defense += 1
	f.speed += 2; f.crit_chance += 3; f.crit_damage += 1; f.dodge_chance += 2
	f.abilities = [PAB_B.keen_strike(), PAB_B.exploit_weakness(), PAB_B.adaptable_strike()]
	f.upgrade_items = ["Torch", "Waterskin"]

static func _lu_sentinel(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(10, 13); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3); f.physical_defense += randi_range(3, 5)
	f.magic_attack += randi_range(1, 2); f.magic_defense += randi_range(3, 5)
	f.speed += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)

static func _lu_pathfinder(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(7, 9); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 4); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 4); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(2, 3)
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
		"Philosopher": _lu_philosopher(f)
		"Arithmancer": _lu_arithmancer(f)
		"Herbalist": _lu_herbalist(f)
		"Shaman": _lu_shaman(f)
		"Beastcaller": _lu_beastcaller(f)
		"Sentinel": _lu_sentinel(f)
		"Pathfinder": _lu_pathfinder(f)
		_: return false
	return true
