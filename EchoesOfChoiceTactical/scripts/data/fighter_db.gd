class_name FighterDB

## Static factory for creating fighters with randomized stats.
## C# random.Next(min, max) is exclusive upper bound.
## GDScript randi_range(min, max) is inclusive — so we use max-1.


# =============================================================================
# Player base classes (Tier 0)
# =============================================================================

static func create_squire(fighter_name: String) -> FighterData:
	var f := FighterData.new()
	f.character_name = fighter_name
	f.character_type = "Squire"
	f.class_id = "Squire"
	f.is_user_controlled = true
	f.level = 1
	f.health = randi_range(41, 49); f.max_health = f.health
	f.mana = randi_range(4, 12); f.max_mana = f.mana
	f.physical_attack = randi_range(13, 17)
	f.physical_defense = randi_range(10, 13)
	f.magic_attack = randi_range(7, 9)
	f.magic_defense = randi_range(10, 14)
	f.speed = randi_range(20, 24)
	f.crit_chance = 20
	f.crit_damage = 2
	f.dodge_chance = 10
	f.abilities = [AbilityDB.slash(), AbilityDB.guard()]
	f.upgrade_items = ["Sword", "Bow", "Headband"]
	return f


static func create_mage(fighter_name: String) -> FighterData:
	var f := FighterData.new()
	f.character_name = fighter_name
	f.character_type = "Mage"
	f.class_id = "Mage"
	f.is_user_controlled = true
	f.level = 1
	f.health = randi_range(45, 51); f.max_health = f.health
	f.mana = randi_range(10, 15); f.max_mana = f.mana
	f.physical_attack = randi_range(10, 16)
	f.physical_defense = randi_range(10, 14)
	f.magic_attack = randi_range(10, 13)
	f.magic_defense = randi_range(15, 19)
	f.speed = randi_range(18, 22)
	f.crit_chance = 10
	f.crit_damage = 1
	f.dodge_chance = 10
	f.abilities = [AbilityDB.arcane_bolt()]
	f.upgrade_items = ["RedStone", "WhiteStone"]
	return f


static func create_entertainer(fighter_name: String) -> FighterData:
	var f := FighterData.new()
	f.character_name = fighter_name
	f.character_type = "Entertainer"
	f.class_id = "Entertainer"
	f.is_user_controlled = true
	f.level = 1
	f.health = randi_range(45, 51); f.max_health = f.health
	f.mana = randi_range(10, 16); f.max_mana = f.mana
	f.physical_attack = randi_range(10, 16)
	f.physical_defense = randi_range(10, 14)
	f.magic_attack = randi_range(12, 19)
	f.magic_defense = randi_range(15, 19)
	f.speed = randi_range(25, 29)
	f.crit_chance = 10
	f.crit_damage = 1
	f.dodge_chance = 10
	f.abilities = [AbilityDB.sing(), AbilityDB.demoralize()]
	f.upgrade_items = ["Lyre", "Slippers", "Scroll"]
	return f


static func create_scholar(fighter_name: String) -> FighterData:
	var f := FighterData.new()
	f.character_name = fighter_name
	f.character_type = "Tinker"
	f.class_id = "Tinker"
	f.is_user_controlled = true
	f.level = 1
	f.health = randi_range(40, 46); f.max_health = f.health
	f.mana = randi_range(10, 16); f.max_mana = f.mana
	f.physical_attack = randi_range(7, 9)
	f.physical_defense = randi_range(10, 12)
	f.magic_attack = randi_range(15, 19)
	f.magic_defense = randi_range(15, 19)
	f.speed = randi_range(17, 21)
	f.crit_chance = 10
	f.crit_damage = 1
	f.dodge_chance = 10
	f.abilities = [AbilityDB.proof(), AbilityDB.energy_blast()]
	f.upgrade_items = ["Crystal", "Textbook", "Abacus"]
	return f


static func create_wildling(fighter_name: String) -> FighterData:
	var f := FighterData.new()
	f.character_name = fighter_name
	f.character_type = "Wildling"
	f.class_id = "Wildling"
	f.is_user_controlled = true
	f.level = 1
	f.health = randi_range(41, 49); f.max_health = f.health
	f.mana = randi_range(8, 11); f.max_mana = f.mana
	f.physical_attack = randi_range(10, 13)
	f.physical_defense = randi_range(10, 13)
	f.magic_attack = randi_range(12, 15)
	f.magic_defense = randi_range(12, 15)
	f.speed = randi_range(15, 19)
	f.crit_chance = 10
	f.crit_damage = 1
	f.dodge_chance = 10
	f.abilities = [AbilityDB.thorn_whip(), AbilityDB.bark_skin()]
	f.upgrade_items = ["Herbs", "Totem", "BeastClaw"]
	return f


# =============================================================================
# Enemies
# =============================================================================

## C# Stat(baseMin, baseMax, growthMin, growthMax) with baseLevel=1:
## result = random.Next(baseMin + lvl*growthMin, baseMax + lvl*(growthMax-1))
## where lvl = level - 1. At level 1, lvl=0 so it's just random.Next(baseMin, baseMax).

static func _enemy_stat(base_min: int, base_max: int, growth_min: int,
		growth_max: int, level: int) -> int:
	var lvl: int = level - 1
	var lo: int = base_min + lvl * growth_min
	var hi: int = base_max + lvl * (growth_max - 1)
	return randi_range(lo, hi - 1)  # C# Next exclusive upper


static func create_thug(fighter_name: String, level: int = 1) -> FighterData:
	var f := FighterData.new()
	f.character_name = fighter_name
	f.character_type = "Thug"
	f.class_id = "Thug"
	f.is_user_controlled = false
	f.level = level
	f.health = _enemy_stat(48, 58, 3, 7, level); f.max_health = f.health
	f.mana = _enemy_stat(4, 8, 1, 3, level); f.max_mana = f.mana
	f.physical_attack = _enemy_stat(14, 18, 1, 3, level)
	f.physical_defense = _enemy_stat(8, 12, 1, 2, level)
	f.magic_attack = _enemy_stat(3, 6, 0, 2, level)
	f.magic_defense = _enemy_stat(8, 12, 1, 2, level)
	f.speed = _enemy_stat(18, 24, 1, 2, level)
	f.crit_chance = 10
	f.crit_damage = 1
	f.dodge_chance = 10
	f.abilities = [AbilityDB.haymaker()]
	return f


static func create_ruffian(fighter_name: String, level: int = 1) -> FighterData:
	var f := FighterData.new()
	f.character_name = fighter_name
	f.character_type = "Ruffian"
	f.class_id = "Ruffian"
	f.is_user_controlled = false
	f.level = level
	f.health = _enemy_stat(44, 54, 3, 6, level); f.max_health = f.health
	f.mana = _enemy_stat(4, 8, 1, 3, level); f.max_mana = f.mana
	f.physical_attack = _enemy_stat(16, 20, 1, 3, level)
	f.physical_defense = _enemy_stat(7, 11, 1, 2, level)
	f.magic_attack = _enemy_stat(2, 5, 0, 1, level)
	f.magic_defense = _enemy_stat(6, 10, 1, 2, level)
	f.speed = _enemy_stat(16, 22, 1, 2, level)
	f.crit_chance = 10
	f.crit_damage = 1
	f.dodge_chance = 5
	f.abilities = [AbilityDB.haymaker(), AbilityDB.intimidate()]
	return f


static func create_pickpocket(fighter_name: String, level: int = 1) -> FighterData:
	var f := FighterData.new()
	f.character_name = fighter_name
	f.character_type = "Pickpocket"
	f.class_id = "Pickpocket"
	f.is_user_controlled = false
	f.level = level
	f.health = _enemy_stat(32, 41, 2, 5, level); f.max_health = f.health
	f.mana = _enemy_stat(5, 9, 1, 3, level); f.max_mana = f.mana
	f.physical_attack = _enemy_stat(12, 16, 1, 3, level)
	f.physical_defense = _enemy_stat(5, 8, 0, 2, level)
	f.magic_attack = _enemy_stat(2, 4, 0, 1, level)
	f.magic_defense = _enemy_stat(5, 9, 0, 2, level)
	f.speed = _enemy_stat(22, 28, 2, 3, level)
	f.crit_chance = 15
	f.crit_damage = 1
	f.dodge_chance = 20
	f.abilities = [AbilityDB.quick_stab(), AbilityDB.pilfer()]
	return f


# =============================================================================
# Level up — per-class growth rates matching C# IncreaseLevel()
# =============================================================================

static func level_up(fighter: FighterData) -> void:
	match fighter.class_id:
		"Squire": _level_up_squire(fighter)
		"Mage": _level_up_mage(fighter)
		"Entertainer": _level_up_entertainer(fighter)
		"Tinker": _level_up_scholar(fighter)
		"Wildling": _level_up_wildling(fighter)
		_: _level_up_generic(fighter)


static func _level_up_squire(f: FighterData) -> void:
	f.level += 1
	var hp: int = randi_range(7, 9); f.health += hp; f.max_health += hp
	var mp: int = randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2)
	f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(1, 2)
	f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(1, 2)


static func _level_up_mage(f: FighterData) -> void:
	f.level += 1
	var hp: int = randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp: int = randi_range(2, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2)
	f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(1, 2)
	f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(1, 1)


static func _level_up_entertainer(f: FighterData) -> void:
	f.level += 1
	var hp: int = randi_range(7, 9); f.health += hp; f.max_health += hp
	var mp: int = randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3)
	f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(2, 3)
	f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(1, 2)


static func _level_up_scholar(f: FighterData) -> void:
	f.level += 1
	var hp: int = randi_range(6, 8); f.health += hp; f.max_health += hp
	var mp: int = randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2)
	f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(1, 2)
	f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(1, 1)


static func _level_up_wildling(f: FighterData) -> void:
	f.level += 1
	var hp: int = randi_range(6, 7); f.health += hp; f.max_health += hp
	var mp: int = randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2)
	f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(2, 3)
	f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(1, 1)


static func _level_up_generic(f: FighterData) -> void:
	f.level += 1
	var hp: int = randi_range(5, 8); f.health += hp; f.max_health += hp
	var mp: int = randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2)
	f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(1, 2)
	f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(1, 1)


# =============================================================================
# Player class creation router
# =============================================================================

static func create_player(class_id: String, fighter_name: String) -> FighterData:
	match class_id:
		"Squire": return create_squire(fighter_name)
		"Mage": return create_mage(fighter_name)
		"Entertainer": return create_entertainer(fighter_name)
		"Tinker": return create_scholar(fighter_name)
		"Wildling": return create_wildling(fighter_name)
		_:
			push_error("Unknown player class: %s" % class_id)
			return create_squire(fighter_name)


## Returns the display name for a class_id (used when restoring from save).
static func get_display_name(class_id: String) -> String:
	match class_id:
		"Squire": return "Squire"
		"Mage": return "Mage"
		"Entertainer": return "Entertainer"
		"Tinker": return "Tinker"
		"Wildling": return "Wildling"
		_:
			push_error("Unknown class_id for display name: %s" % class_id)
			return class_id


## Returns the ability set for a class_id (used when restoring from save).
static func get_abilities_for_class(class_id: String) -> Array[AbilityData]:
	match class_id:
		"Squire": return [AbilityDB.slash(), AbilityDB.guard()]
		"Mage": return [AbilityDB.arcane_bolt()]
		"Entertainer": return [AbilityDB.sing(), AbilityDB.demoralize()]
		"Tinker": return [AbilityDB.proof(), AbilityDB.energy_blast()]
		"Wildling": return [AbilityDB.thorn_whip(), AbilityDB.bark_skin()]
		_:
			push_error("Unknown class_id for abilities: %s" % class_id)
			return []
