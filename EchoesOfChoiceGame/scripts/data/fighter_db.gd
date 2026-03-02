class_name FighterDB

## Static factory for creating fighters with randomized stats.
## C# random.Next(min, max) is exclusive upper bound.
## GDScript randi_range(min, max) is inclusive — so we use max-1.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")
const T1 := preload("res://scripts/data/fighter_db_t1.gd")
const T2 := preload("res://scripts/data/fighter_db_t2.gd")
const T2B := preload("res://scripts/data/fighter_db_t2b.gd")


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
	f.upgrade_items = ["Guitar", "Slippers", "Scroll"]
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
# Level up — chains through T0 → T1 → T2/T2B
# =============================================================================

static func level_up(fighter: FighterData) -> void:
	match fighter.class_id:
		"Squire": _level_up_squire(fighter)
		"Mage": _level_up_mage(fighter)
		"Entertainer": _level_up_entertainer(fighter)
		"Tinker": _level_up_scholar(fighter)
		"Wildling": _level_up_wildling(fighter)
		_:
			if T1.level_up(fighter): return
			if T2.level_up(fighter): return
			if T2B.level_up(fighter): return
			_level_up_generic(fighter)


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


# =============================================================================
# Class upgrade — item determines new class, keeps accumulated stats
# =============================================================================

static func upgrade_class(fighter: FighterData, item: String) -> bool:
	var key := fighter.class_id + ":" + item
	match key:
		# T0 → T1
		"Squire:Sword": T1.upgrade_to_duelist(fighter)
		"Squire:Bow": T1.upgrade_to_ranger(fighter)
		"Squire:Headband": T1.upgrade_to_martial_artist(fighter)
		"Mage:RedStone": T1.upgrade_to_invoker(fighter)
		"Mage:WhiteStone": T1.upgrade_to_acolyte(fighter)
		"Entertainer:Guitar": T1.upgrade_to_bard(fighter)
		"Entertainer:Slippers": T1.upgrade_to_dervish(fighter)
		"Entertainer:Scroll": T1.upgrade_to_orator(fighter)
		"Tinker:Crystal": T1.upgrade_to_artificer(fighter)
		"Tinker:Textbook": T1.upgrade_to_cosmologist(fighter)
		"Tinker:Abacus": T1.upgrade_to_arithmancer(fighter)
		"Wildling:Herbs": T1.upgrade_to_herbalist(fighter)
		"Wildling:Totem": T1.upgrade_to_shaman(fighter)
		"Wildling:BeastClaw": T1.upgrade_to_beastcaller(fighter)
		# T1 → T2 (Squire tree)
		"Duelist:Horse": T2.upgrade_to_cavalry(fighter)
		"Duelist:Spear": T2.upgrade_to_dragoon(fighter)
		"Ranger:Gun": T2.upgrade_to_mercenary(fighter)
		"Ranger:Trap": T2.upgrade_to_hunter(fighter)
		"MartialArtist:Sword": T2.upgrade_to_ninja(fighter)
		"MartialArtist:Staff": T2.upgrade_to_monk(fighter)
		# T1 → T2 (Mage tree)
		"Invoker:FireStone": T2.upgrade_to_infernalist(fighter)
		"Invoker:WaterStone": T2.upgrade_to_tidecaller(fighter)
		"Invoker:LightningStone": T2.upgrade_to_tempest(fighter)
		"Acolyte:Hammer": T2.upgrade_to_paladin(fighter)
		"Acolyte:HolyBook": T2.upgrade_to_priest(fighter)
		"Acolyte:DarkOrb": T2.upgrade_to_warlock(fighter)
		# T1 → T2 (Entertainer tree)
		"Bard:WarHorn": T2B.upgrade_to_warcrier(fighter)
		"Bard:Hat": T2B.upgrade_to_minstrel(fighter)
		"Dervish:Light": T2B.upgrade_to_illusionist(fighter)
		"Dervish:Paint": T2B.upgrade_to_mime(fighter)
		"Orator:Medal": T2B.upgrade_to_laureate(fighter)
		"Orator:Pen": T2B.upgrade_to_elegist(fighter)
		# T1 → T2 (Tinker tree)
		"Artificer:Potion": T2B.upgrade_to_alchemist(fighter)
		"Artificer:Hammer": T2B.upgrade_to_bombardier(fighter)
		"Cosmologist:TimeMachine": T2B.upgrade_to_chronomancer(fighter)
		"Cosmologist:Telescope": T2B.upgrade_to_astronomer(fighter)
		"Arithmancer:ClockworkCore": T2B.upgrade_to_automaton(fighter)
		"Arithmancer:Computer": T2B.upgrade_to_technomancer(fighter)
		# T1 → T2 (Wildling tree)
		"Herbalist:Venom": T2B.upgrade_to_blighter(fighter)
		"Herbalist:Seedling": T2B.upgrade_to_grove_keeper(fighter)
		"Shaman:Shrunkenhead": T2B.upgrade_to_witch_doctor(fighter)
		"Shaman:SpiritOrb": T2B.upgrade_to_spiritwalker(fighter)
		"Beastcaller:Feather": T2B.upgrade_to_falconer(fighter)
		"Beastcaller:Pelt": T2B.upgrade_to_shapeshifter(fighter)
		_:
			push_error("Unknown upgrade: %s" % key)
			return false
	return true
