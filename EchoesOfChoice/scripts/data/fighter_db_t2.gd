class_name FighterDBT2

## Tier 2 class upgrades and level-up growth rates (Squire and Mage trees).

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")
const PAB := preload("res://scripts/data/ability_db_player.gd")


# =============================================================================
# Squire tree:Duelist branch
# =============================================================================

static func upgrade_to_cavalry(f: FighterData) -> void:
	f.class_id = "Cavalry"; f.character_type = "Cavalry"
	f.health += 4; f.max_health += 4; f.physical_attack += 3; f.speed += 3
	f.crit_chance = 30; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [PAB.lance(), PAB.trample(), AbilityDB.rally()]
	f.upgrade_items = []

static func upgrade_to_dragoon(f: FighterData) -> void:
	f.class_id = "Dragoon"; f.character_type = "Dragoon"
	f.health += 8; f.max_health += 8; f.physical_attack += 5; f.magic_attack += 3
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [PAB.jump(), PAB.wyvern_strike(), PAB.dragon_ward()]
	f.upgrade_items = []

static func _lu_cavalry(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(14, 16); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(5, 7); f.physical_defense += randi_range(2, 4)
	f.magic_attack += randi_range(1, 2); f.magic_defense += randi_range(3, 4)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(1, 2)
	f.crit_chance += randi_range(1, 2)

static func _lu_dragoon(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(14, 16); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(4, 6); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(4, 6); f.magic_defense += randi_range(4, 6)
	f.speed += randi_range(1, 2)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Squire tree:Ranger branch
# =============================================================================

static func upgrade_to_mercenary(f: FighterData) -> void:
	f.class_id = "Mercenary"; f.character_type = "Mercenary"
	f.physical_attack += 7; f.speed += 5
	f.health += 5; f.max_health += 5
	f.crit_chance = 40; f.crit_damage = 7; f.dodge_chance = 10
	f.abilities = [PAB.gun_shot(), PAB.called_shot(), PAB.quick_draw()]
	f.upgrade_items = []

static func upgrade_to_hunter(f: FighterData) -> void:
	f.class_id = "Hunter"; f.character_type = "Hunter"
	f.health += 3; f.max_health += 3; f.physical_attack += 2; f.speed += 4
	f.crit_chance = 30; f.crit_damage = 3; f.dodge_chance = 25
	f.abilities = [PAB.triple_arrow(), PAB.snare(), PAB.hunters_mark()]
	f.upgrade_items = []

static func _lu_mercenary(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(5, 7); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(2, 4); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(2, 2)
	f.crit_chance += randi_range(1, 3)

static func _lu_hunter(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(13, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(5, 7); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(4, 6); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(1, 2); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(2, 2)
	f.dodge_chance += randi_range(1, 2)
	f.crit_chance += randi_range(1, 2)


# =============================================================================
# Squire tree:Martial Artist branch
# =============================================================================

static func upgrade_to_ninja(f: FighterData) -> void:
	f.class_id = "Ninja"; f.character_type = "Ninja"
	f.physical_attack += 5; f.speed += 7
	f.crit_chance = 30; f.crit_damage = 3; f.dodge_chance = 30
	f.abilities = [PAB.sweeping_slash(), PAB.dash(), PAB.smoke_bomb()]
	f.upgrade_items = []

static func upgrade_to_monk(f: FighterData) -> void:
	f.class_id = "Monk"; f.character_type = "Monk"
	f.health += 5; f.max_health += 5; f.physical_attack += 3; f.magic_attack += 5
	f.crit_chance = 30; f.crit_damage = 3; f.dodge_chance = 20
	f.abilities = [PAB.spirit_attack(), PAB.precise_strike(), PAB.meditate()]
	f.upgrade_items = []

static func _lu_ninja(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(4, 6); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(2, 3); f.magic_defense += randi_range(3, 4)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(1, 3)
	f.crit_chance += randi_range(1, 2)

static func _lu_monk(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(4, 6); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(4, 6); f.magic_defense += randi_range(5, 7)
	f.speed += randi_range(2, 2)
	f.dodge_chance += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Mage tree:Invoker branch
# =============================================================================

static func upgrade_to_infernalist(f: FighterData) -> void:
	f.class_id = "Infernalist"; f.character_type = "Infernalist"
	f.magic_attack += 5; f.speed += 4
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 25
	f.abilities = [PAB.fire_ball(), PAB.burning_brand(), PAB.cauterize()]
	f.upgrade_items = []

static func upgrade_to_tidecaller(f: FighterData) -> void:
	f.class_id = "Tidecaller"; f.character_type = "Tidecaller"
	f.health += 3; f.max_health += 3; f.magic_attack += 4; f.magic_defense += 4
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [PAB.purify(), PAB.tsunami(), PAB.undertow()]
	f.upgrade_items = []

static func upgrade_to_tempest(f: FighterData) -> void:
	f.class_id = "Tempest"; f.character_type = "Tempest"
	f.magic_attack += 5; f.magic_defense += 3; f.speed += 7
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 25
	f.abilities = [PAB.hurricane(), PAB.tornado(), PAB.eye_of_the_storm()]
	f.upgrade_items = []

static func _lu_infernalist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(7, 9); f.health += hp; f.max_health += hp
	var mp := randi_range(3, 5); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(5, 7); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 2)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)

static func _lu_tidecaller(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(6, 8); f.health += hp; f.max_health += hp
	var mp := randi_range(3, 5); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(4, 6); f.magic_defense += randi_range(3, 4)
	f.speed += randi_range(1, 1)
	f.crit_chance += randi_range(0, 1)

static func _lu_tempest(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(7, 9); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(5, 7); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(2, 2)
	f.dodge_chance += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Mage tree:Acolyte branch
# =============================================================================

static func upgrade_to_paladin(f: FighterData) -> void:
	f.class_id = "Paladin"; f.character_type = "Paladin"
	f.health += 10; f.max_health += 10
	f.physical_attack += 5; f.physical_defense += 3; f.magic_attack += 3
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.cure(), AbilityDB.smash(), PAB.smite()]
	f.upgrade_items = []

static func upgrade_to_priest(f: FighterData) -> void:
	f.class_id = "Priest"; f.character_type = "Priest"
	f.health += 5; f.max_health += 5; f.mana += 8; f.max_mana += 8
	f.physical_defense += 2; f.magic_attack += 8; f.magic_defense += 3
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.restoration(), PAB.heavenly_body(), PAB.holy()]
	f.upgrade_items = []

static func upgrade_to_warlock(f: FighterData) -> void:
	f.class_id = "Warlock"; f.character_type = "Warlock"
	f.magic_attack += 8; f.magic_defense += 4; f.speed += 4
	f.health += 5; f.max_health += 5
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [PAB.shadow_bolt(), PAB.curse(), PAB.drain_life()]
	f.upgrade_items = []

static func _lu_paladin(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(9, 11); f.health += hp; f.max_health += hp
	var mp := randi_range(4, 6); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(5, 7); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(4, 5); f.magic_defense += randi_range(3, 5)
	f.speed += randi_range(1, 1)

static func _lu_priest(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(10, 12); f.health += hp; f.max_health += hp
	var mp := randi_range(6, 8); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(5, 7); f.magic_defense += randi_range(4, 6)
	f.speed += randi_range(1, 1)

static func _lu_warlock(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(9, 11); f.health += hp; f.max_health += hp
	var mp := randi_range(3, 5); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(5, 7); f.magic_defense += randi_range(3, 4)
	f.speed += randi_range(2, 2)
	f.dodge_chance += randi_range(0, 1)
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
		_: return false
	return true
