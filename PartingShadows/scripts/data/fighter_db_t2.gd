class_name FighterDBT2

## Tier 2 class upgrades and level-up growth rates (Squire and Mage trees).

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")
const PAB := preload("res://scripts/data/ability_db_player.gd")
const PAB_B := preload("res://scripts/data/ability_db_player_b.gd")


# =============================================================================
# Squire tree:Duelist branch
# =============================================================================

static func upgrade_to_cavalry(f: FighterData) -> void:
	f.class_id = "Cavalry"; f.character_type = "Cavalry"
	f.health += 17; f.max_health += 17; f.mana += 1; f.max_mana += 1
	f.physical_attack += 14; f.physical_defense += 5; f.magic_attack += 2; f.magic_defense += 4
	f.speed += 5; f.crit_chance += 6; f.crit_damage += 2; f.dodge_chance += 3
	f.abilities = [PAB.lance(), PAB.trample(), PAB.spur()]
	f.upgrade_items = []

static func upgrade_to_dragoon(f: FighterData) -> void:
	f.class_id = "Dragoon"; f.character_type = "Dragoon"
	f.health += 17; f.max_health += 17; f.mana += 2; f.max_mana += 2
	f.physical_attack += 13; f.physical_defense += 6; f.magic_attack += 10; f.magic_defense += 7
	f.speed += 4; f.crit_chance += 5; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB.dragon_scales(), PAB.wyvern_strike(), PAB.dragon_dive()]
	f.upgrade_items = []

static func _lu_cavalry(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(5, 7); f.physical_defense += randi_range(2, 4)
	f.magic_attack += randi_range(1, 2); f.magic_defense += randi_range(3, 4)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(1, 2)
	f.crit_chance += randi_range(1, 2)

static func _lu_dragoon(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(13, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(7, 9); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(4, 6); f.magic_defense += randi_range(6, 7)
	f.speed += randi_range(1, 2)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Squire tree:Ranger branch
# =============================================================================

static func upgrade_to_mercenary(f: FighterData) -> void:
	f.class_id = "Mercenary"; f.character_type = "Mercenary"
	f.health += 13; f.max_health += 13; f.mana += 1; f.max_mana += 1
	f.physical_attack += 14; f.physical_defense += 5; f.magic_attack += 2; f.magic_defense += 6
	f.speed += 7; f.crit_chance += 8; f.crit_damage += 4; f.dodge_chance += 2
	f.abilities = [PAB.gun_shot(), PAB.called_shot(), PAB.suppressing_fire()]
	f.upgrade_items = []

static func upgrade_to_hunter(f: FighterData) -> void:
	f.class_id = "Hunter"; f.character_type = "Hunter"
	f.health += 13; f.max_health += 13; f.mana += 1; f.max_mana += 1
	f.physical_attack += 12; f.physical_defense += 6; f.magic_attack += 2; f.magic_defense += 6
	f.speed += 8; f.crit_chance += 3; f.crit_damage += 2; f.dodge_chance += 4
	f.abilities = [PAB.triple_arrow(), PAB.snare(), PAB.hunters_mark()]
	f.upgrade_items = []

static func _lu_mercenary(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(13, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(5, 7); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(0, 1); f.magic_defense += randi_range(4, 5)
	f.speed += randi_range(2, 3)
	f.crit_chance += randi_range(2, 3)

static func _lu_hunter(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(13, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(6, 8); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(1, 2); f.magic_defense += randi_range(4, 5)
	f.speed += randi_range(2, 2)
	f.dodge_chance += randi_range(1, 2)
	f.crit_chance += randi_range(1, 2)


# =============================================================================
# Squire tree:Martial Artist branch
# =============================================================================

static func upgrade_to_ninja(f: FighterData) -> void:
	f.class_id = "Ninja"; f.character_type = "Ninja"
	f.health += 10; f.max_health += 10; f.mana += 1; f.max_mana += 1
	f.physical_attack += 14; f.physical_defense += 6; f.magic_attack += 2; f.magic_defense += 6
	f.speed += 9; f.crit_chance += 3; f.crit_damage += 3; f.dodge_chance += 7
	f.abilities = [PAB.shadow_strike(), PAB.smoke_bomb(), PAB.blade_flurry()]
	f.upgrade_items = []

static func upgrade_to_monk(f: FighterData) -> void:
	f.class_id = "Monk"; f.character_type = "Monk"
	f.health += 15; f.max_health += 15; f.mana += 1; f.max_mana += 1
	f.physical_attack += 11; f.physical_defense += 6; f.magic_attack += 11; f.magic_defense += 6
	f.speed += 4; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 5
	f.abilities = [PAB.spirit_attack(), PAB.precise_strike(), PAB.inner_peace()]
	f.upgrade_items = []

static func _lu_ninja(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(15, 17); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(4, 6); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(0, 1); f.magic_defense += randi_range(4, 5)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(2, 3)
	f.crit_chance += randi_range(1, 2)

static func _lu_monk(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(5, 7); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 5); f.magic_defense += randi_range(4, 5)
	f.speed += randi_range(2, 2)
	f.dodge_chance += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Mage tree:Invoker branch
# =============================================================================

static func upgrade_to_infernalist(f: FighterData) -> void:
	f.class_id = "Infernalist"; f.character_type = "Infernalist"
	f.health += 8; f.max_health += 8; f.mana += 2; f.max_mana += 2
	f.physical_attack += 2; f.physical_defense += 5; f.magic_attack += 17; f.magic_defense += 7
	f.speed += 8; f.crit_chance += 5; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB.fire_ball(), PAB.burning_brand(), PAB.conflagration()]
	f.upgrade_items = []

static func upgrade_to_tidecaller(f: FighterData) -> void:
	f.class_id = "Tidecaller"; f.character_type = "Tidecaller"
	f.health += 15; f.max_health += 15; f.mana += 2; f.max_mana += 2
	f.physical_attack += 2; f.physical_defense += 5; f.magic_attack += 13; f.magic_defense += 6
	f.speed += 4; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB.purify(), PAB.tsunami(), PAB.water_whip()]
	f.upgrade_items = []

static func upgrade_to_tempest(f: FighterData) -> void:
	f.class_id = "Tempest"; f.character_type = "Tempest"
	f.health += 15; f.max_health += 15; f.mana += 2; f.max_mana += 2
	f.physical_attack += 2; f.physical_defense += 4; f.magic_attack += 14; f.magic_defense += 5
	f.speed += 7; f.crit_chance += 3; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB.hurricane(), PAB.lightning_strike(), PAB.storm_surge()]
	f.upgrade_items = []

static func _lu_infernalist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(9, 11); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(7, 9); f.magic_defense += randi_range(4, 5)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)

static func _lu_tidecaller(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(11, 13); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(5, 7); f.magic_defense += randi_range(4, 5)
	f.speed += randi_range(2, 3)
	f.crit_chance += randi_range(0, 1)

static func _lu_tempest(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(0, 1); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(7, 9); f.magic_defense += randi_range(4, 5)
	f.speed += randi_range(3, 3)
	f.dodge_chance += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Mage tree:Acolyte branch
# =============================================================================

static func upgrade_to_paladin(f: FighterData) -> void:
	f.class_id = "Paladin"; f.character_type = "Paladin"
	f.health += 17; f.max_health += 17; f.mana += 2; f.max_mana += 2
	f.physical_attack += 13; f.physical_defense += 6; f.magic_attack += 16; f.magic_defense += 4
	f.speed += 3; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB.lay_on_hands(), PAB.holy_strike(), PAB.smite()]
	f.upgrade_items = []

static func upgrade_to_priest(f: FighterData) -> void:
	f.class_id = "Priest"; f.character_type = "Priest"
	f.health += 13; f.max_health += 13; f.mana += 2; f.max_mana += 2
	f.physical_attack += 2; f.physical_defense += 5; f.magic_attack += 19; f.magic_defense += 7
	f.speed += 5; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB.restoration(), PAB.heavenly_body(), PAB.holy()]
	f.upgrade_items = []

static func upgrade_to_warlock(f: FighterData) -> void:
	f.class_id = "Warlock"; f.character_type = "Warlock"
	f.health += 14; f.max_health += 14; f.mana += 2; f.max_mana += 2
	f.physical_attack += 2; f.physical_defense += 4; f.magic_attack += 20; f.magic_defense += 6
	f.speed += 5; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB.shadow_bolt(), PAB.hex(), PAB.drain_life()]
	f.upgrade_items = []

static func _lu_paladin(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(13, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(7, 9); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(6, 8); f.magic_defense += randi_range(4, 6)
	f.speed += randi_range(2, 3)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)

static func _lu_priest(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(13, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(7, 9); f.magic_defense += randi_range(4, 5)
	f.speed += randi_range(2, 3)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)

static func _lu_warlock(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(13, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(0, 1); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(8, 10); f.magic_defense += randi_range(5, 6)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Wanderer tree:Sentinel branch
# =============================================================================

static func upgrade_to_bulwark(f: FighterData) -> void:
	f.class_id = "Bulwark"; f.character_type = "Bulwark"
	f.health += 22; f.max_health += 22; f.mana += 1; f.max_mana += 1
	f.physical_attack += 8; f.physical_defense += 5; f.magic_attack += 3; f.magic_defense += 6
	f.speed += 3; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 5
	f.abilities = [PAB_B.spell_ward(), PAB_B.iron_fist(), PAB_B.ironclad_challenge()]
	f.upgrade_items = []

static func upgrade_to_aegis(f: FighterData) -> void:
	f.class_id = "Aegis"; f.character_type = "Aegis"
	f.health += 18; f.max_health += 18; f.mana += 1; f.max_mana += 1
	f.physical_attack += 10; f.physical_defense += 5; f.magic_attack += 10; f.magic_defense += 5
	f.speed += 5; f.crit_chance += 4; f.crit_damage += 2; f.dodge_chance += 3
	f.abilities = [PAB_B.arcane_edge(), PAB_B.ward_breaker(), PAB_B.spell_counter()]
	f.upgrade_items = []

static func _lu_bulwark(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(14, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(5, 6); f.physical_defense += randi_range(3, 5)
	f.magic_attack += randi_range(0, 1); f.magic_defense += randi_range(4, 5)
	f.speed += randi_range(2, 3)
	f.crit_chance += randi_range(0, 1)

static func _lu_aegis(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(14, 16); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(5, 7); f.physical_defense += randi_range(2, 4)
	f.magic_attack += randi_range(6, 8); f.magic_defense += randi_range(5, 6)
	f.speed += randi_range(2, 3)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Level-up router
# =============================================================================

static func level_up(f: FighterData) -> bool:
	match f.class_id:
		"Cavalry": _lu_cavalry(f)
		"Dragoon": _lu_dragoon(f)
		"Mercenary": _lu_mercenary(f)
		"Hunter": _lu_hunter(f)
		"Ninja": _lu_ninja(f)
		"Monk": _lu_monk(f)
		"Infernalist": _lu_infernalist(f)
		"Tidecaller": _lu_tidecaller(f)
		"Tempest": _lu_tempest(f)
		"Paladin": _lu_paladin(f)
		"Priest": _lu_priest(f)
		"Warlock": _lu_warlock(f)
		"Bulwark": _lu_bulwark(f)
		"Aegis": _lu_aegis(f)
		_: return false
	return true
