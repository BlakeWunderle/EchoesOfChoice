class_name FighterDBT2C

## Tier 2 class upgrades and level-up growth rates (Wildling, Wanderer trees).

const FighterData := preload("res://scripts/data/fighter_data.gd")
const PAB_B := preload("res://scripts/data/ability_db_player_b.gd")


# =============================================================================
# Wildling tree:Herbalist branch
# =============================================================================

static func upgrade_to_blighter(f: FighterData) -> void:
	f.class_id = "Blighter"; f.character_type = "Blighter"
	f.health += 18; f.max_health += 18; f.mana += 2; f.max_mana += 2
	f.physical_attack += 2; f.physical_defense += 5; f.magic_attack += 13; f.magic_defense += 5
	f.speed += 4; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB_B.blight(), PAB_B.plague(), PAB_B.poison_sting()]
	f.upgrade_items = []

static func upgrade_to_grove_keeper(f: FighterData) -> void:
	f.class_id = "GroveKeeper"; f.character_type = "Grove Keeper"
	f.health += 20; f.max_health += 20; f.mana += 2; f.max_mana += 2
	f.physical_attack += 2; f.physical_defense += 5; f.magic_attack += 16; f.magic_defense += 5
	f.speed += 3; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 4
	f.abilities = [PAB_B.thorn_burst(), PAB_B.natures_mend(), PAB_B.vine_wall()]
	f.upgrade_items = []

static func _lu_blighter(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(0, 1); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(6, 8); f.magic_defense += randi_range(4, 5)
	f.speed += randi_range(3, 4)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)

static func _lu_grove_keeper(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(13, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(4, 5)
	f.magic_attack += randi_range(6, 8); f.magic_defense += randi_range(3, 4)
	f.speed += randi_range(2, 3)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Wildling tree:Shaman branch
# =============================================================================

static func upgrade_to_witch_doctor(f: FighterData) -> void:
	f.class_id = "WitchDoctor"; f.character_type = "Witch Doctor"
	f.health += 15; f.max_health += 15; f.mana += 2; f.max_mana += 2
	f.physical_attack += 2; f.physical_defense += 4; f.magic_attack += 13; f.magic_defense += 6
	f.speed += 7; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB_B.voodoo_bolt(), PAB_B.dark_hex(), PAB_B.creeping_rot()]
	f.upgrade_items = []

static func upgrade_to_spiritwalker(f: FighterData) -> void:
	f.class_id = "Spiritwalker"; f.character_type = "Spiritwalker"
	f.health += 14; f.max_health += 14; f.mana += 2; f.max_mana += 2
	f.physical_attack += 1; f.physical_defense += 5; f.magic_attack += 11; f.magic_defense += 6
	f.speed += 6; f.crit_chance += 2; f.crit_damage += 3; f.dodge_chance += 1
	f.abilities = [PAB_B.soul_strike(), PAB_B.spirit_shield(), PAB_B.spirit_mend()]
	f.upgrade_items = []

static func _lu_witch_doctor(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(0, 1); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(7, 9); f.magic_defense += randi_range(4, 5)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)

static func _lu_spiritwalker(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(0, 1); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(7, 9); f.magic_defense += randi_range(4, 5)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(0, 1)


# =============================================================================
# Wildling tree:Beastcaller branch
# =============================================================================

static func upgrade_to_falconer(f: FighterData) -> void:
	f.class_id = "Falconer"; f.character_type = "Falconer"
	f.health += 12; f.max_health += 12; f.mana += 2; f.max_mana += 2
	f.physical_attack += 17; f.physical_defense += 5; f.magic_attack += 2; f.magic_defense += 4
	f.speed += 7; f.crit_chance += 5; f.crit_damage += 6; f.dodge_chance += 2
	f.abilities = [PAB_B.falcon_strike(), PAB_B.rending_talon(), PAB_B.aerial_strike()]
	f.upgrade_items = []

static func upgrade_to_shapeshifter(f: FighterData) -> void:
	f.class_id = "Shapeshifter"; f.character_type = "Shapeshifter"
	f.health += 16; f.max_health += 16; f.mana += 2; f.max_mana += 2
	f.physical_attack += 12; f.physical_defense += 5; f.magic_attack += 10; f.magic_defense += 4
	f.speed += 6; f.crit_chance += 3; f.crit_damage += 2; f.dodge_chance += 4
	f.abilities = [PAB_B.savage_maul(), PAB_B.frenzy(), PAB_B.rampage()]
	f.upgrade_items = []

static func _lu_falconer(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(9, 11); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(8, 10); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(1, 2); f.magic_defense += randi_range(4, 5)
	f.speed += randi_range(3, 3)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(1, 2)

static func _lu_shapeshifter(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(14, 16); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(5, 7); f.physical_defense += randi_range(4, 5)
	f.magic_attack += randi_range(2, 4); f.magic_defense += randi_range(3, 4)
	f.speed += randi_range(3, 4)
	f.dodge_chance += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Wanderer tree:Pathfinder branch
# =============================================================================

static func upgrade_to_trailblazer(f: FighterData) -> void:
	f.class_id = "Trailblazer"; f.character_type = "Trailblazer"
	f.health += 14; f.max_health += 14; f.mana += 1; f.max_mana += 1
	f.physical_attack += 10; f.physical_defense += 5; f.magic_attack += 9; f.magic_defense += 7
	f.speed += 8; f.crit_chance += 4; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB_B.blaze_trail(), PAB_B.ambush(), PAB_B.expose()]
	f.upgrade_items = []

static func upgrade_to_survivalist(f: FighterData) -> void:
	f.class_id = "Survivalist"; f.character_type = "Survivalist"
	f.health += 15; f.max_health += 15; f.mana += 1; f.max_mana += 1
	f.physical_attack += 12; f.physical_defense += 6; f.magic_attack += 8; f.magic_defense += 7
	f.speed += 5; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 6
	f.abilities = [PAB_B.wild_sweep(), PAB_B.resourceful_strike(), PAB_B.adapt()]
	f.upgrade_items = []

static func _lu_trailblazer(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(13, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(6, 8); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(4, 6); f.magic_defense += randi_range(5, 6)
	f.speed += randi_range(2, 3)
	f.crit_chance += randi_range(1, 2)

static func _lu_survivalist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(13, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 5); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 5); f.magic_defense += randi_range(4, 6)
	f.speed += randi_range(2, 2)
	f.dodge_chance += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Level-up router
# =============================================================================

static func level_up(f: FighterData) -> bool:
	match f.class_id:
		"Blighter": _lu_blighter(f)
		"GroveKeeper": _lu_grove_keeper(f)
		"WitchDoctor": _lu_witch_doctor(f)
		"Spiritwalker": _lu_spiritwalker(f)
		"Falconer": _lu_falconer(f)
		"Shapeshifter": _lu_shapeshifter(f)
		"Trailblazer": _lu_trailblazer(f)
		"Survivalist": _lu_survivalist(f)
		_: return false
	return true
