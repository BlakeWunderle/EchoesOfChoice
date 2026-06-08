class_name FighterDB

## Static factory for creating fighters with randomized stats.
## C# random.Next(min, max) is exclusive upper bound.
## GDScript randi_range(min, max) is inclusive, so we use max-1.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")
const T1 := preload("res://scripts/data/fighter_db_t1.gd")
const T2 := preload("res://scripts/data/fighter_db_t2.gd")
const T2B := preload("res://scripts/data/fighter_db_t2b.gd")
const T2C := preload("res://scripts/data/fighter_db_t2c.gd")
const Meta := preload("res://scripts/data/fighter_db_meta.gd")
const Roles := preload("res://scripts/data/fighter_db_roles.gd")


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
	f.health = randi_range(44, 50); f.max_health = f.health
	f.mana = randi_range(2, 5); f.max_mana = f.mana
	f.physical_attack = randi_range(14, 18)
	f.physical_defense = randi_range(12, 15)
	f.magic_attack = randi_range(6, 9)
	f.magic_defense = randi_range(8, 12)
	f.speed = randi_range(18, 22)
	f.crit_chance = 10
	f.crit_damage = 1
	f.dodge_chance = 5
	f.abilities = [AbilityDB.slash(), AbilityDB.guard(), AbilityDB.rush()]
	f.upgrade_items = ["Sword", "Bow", "Headband"]
	return f


static func create_mage(fighter_name: String) -> FighterData:
	var f := FighterData.new()
	f.character_name = fighter_name
	f.character_type = "Mage"
	f.class_id = "Mage"
	f.is_user_controlled = true
	f.level = 1
	f.health = randi_range(42, 48); f.max_health = f.health
	f.mana = randi_range(8, 10); f.max_mana = f.mana
	f.physical_attack = randi_range(9, 12)
	f.physical_defense = randi_range(8, 11)
	f.magic_attack = randi_range(15, 19)
	f.magic_defense = randi_range(14, 18)
	f.speed = randi_range(18, 22)
	f.crit_chance = 8
	f.crit_damage = 1
	f.dodge_chance = 5
	f.abilities = [AbilityDB.arcane_bolt(), AbilityDB.arcane_shield(), AbilityDB.fire_dart()]
	f.upgrade_items = ["RedStone", "WhiteStone"]
	return f


static func create_entertainer(fighter_name: String) -> FighterData:
	var f := FighterData.new()
	f.character_name = fighter_name
	f.character_type = "Entertainer"
	f.class_id = "Entertainer"
	f.is_user_controlled = true
	f.level = 1
	f.health = randi_range(44, 50); f.max_health = f.health
	f.mana = randi_range(4, 7); f.max_mana = f.mana
	f.physical_attack = randi_range(11, 14)
	f.physical_defense = randi_range(10, 13)
	f.magic_attack = randi_range(13, 16)
	f.magic_defense = randi_range(11, 14)
	f.speed = randi_range(22, 26)
	f.crit_chance = 5
	f.crit_damage = 1
	f.dodge_chance = 5
	f.abilities = [AbilityDB.mockery(), AbilityDB.demoralize(), AbilityDB.inspire()]
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
	f.mana = randi_range(5, 7); f.max_mana = f.mana
	f.physical_attack = randi_range(9, 12)
	f.physical_defense = randi_range(10, 13)
	f.magic_attack = randi_range(13, 17)
	f.magic_defense = randi_range(13, 17)
	f.speed = randi_range(18, 22)
	f.crit_chance = 5
	f.crit_damage = 1
	f.dodge_chance = 5
	f.abilities = [AbilityDB.proof(), AbilityDB.energy_blast(), AbilityDB.spark_shot()]
	f.upgrade_items = ["Crystal", "Textbook", "Abacus"]
	return f


static func create_wildling(fighter_name: String) -> FighterData:
	var f := FighterData.new()
	f.character_name = fighter_name
	f.character_type = "Wildling"
	f.class_id = "Wildling"
	f.is_user_controlled = true
	f.level = 1
	f.health = randi_range(42, 48); f.max_health = f.health
	f.mana = randi_range(4, 6); f.max_mana = f.mana
	f.physical_attack = randi_range(11, 15)
	f.physical_defense = randi_range(10, 13)
	f.magic_attack = randi_range(11, 15)
	f.magic_defense = randi_range(12, 15)
	f.speed = randi_range(20, 24)
	f.crit_chance = 5
	f.crit_damage = 1
	f.dodge_chance = 8
	f.abilities = [AbilityDB.thorn_whip(), AbilityDB.bark_skin(), AbilityDB.primal_swipe()]
	f.upgrade_items = ["Herbs", "Totem", "BeastClaw"]
	return f


static func create_wanderer(fighter_name: String) -> FighterData:
	var f := FighterData.new()
	f.character_name = fighter_name
	f.character_type = "Wanderer"
	f.class_id = "Wanderer"
	f.is_user_controlled = true
	f.level = 1
	f.health = randi_range(41, 49); f.max_health = f.health
	f.mana = randi_range(4, 6); f.max_mana = f.mana
	f.physical_attack = randi_range(13, 17)
	f.physical_defense = randi_range(8, 11)
	f.magic_attack = randi_range(6, 9)
	f.magic_defense = randi_range(13, 17)
	f.speed = randi_range(21, 25)
	f.crit_chance = 10
	f.crit_damage = 1
	f.dodge_chance = 8
	f.abilities = [AbilityDB.wild_strike(), AbilityDB.natures_ward(), AbilityDB.scout_slash()]
	f.upgrade_items = ["Shield", "Compass"]
	return f


# =============================================================================
# Level up: chains through T0 → T1 → T2/T2B/T2C
# =============================================================================

static func level_up(fighter: FighterData) -> void:
	if fighter.class_id in _GROWTH:
		_apply_level_up(fighter, _GROWTH[fighter.class_id])
		return
	if T1.level_up(fighter): return
	if T2.level_up(fighter): return
	if T2B.level_up(fighter): return
	if T2C.level_up(fighter): return
	_apply_level_up(fighter, _GROWTH["_generic"])


# Growth rates: [hp, mp, patk, pdef, matk, mdef, spd, dodge, crit] as [min, max] pairs
const _GROWTH := {
	#                  hp     mp     patk   pdef   matk   mdef   spd    dodge  crit
	"Squire":      [[7,9], [1,2], [1,2], [1,2], [1,2], [1,2], [1,2], [0,1], [0,1]],
	"Mage":        [[5,7], [1,2], [1,2], [1,2], [1,2], [1,2], [1,1], [0,1], [0,1]],
	"Entertainer": [[7,9], [1,2], [2,3], [1,2], [2,3], [1,2], [1,1], [0,1], [0,1]],
	"Tinker":      [[6,8], [1,2], [1,2], [1,2], [1,2], [1,2], [1,1], [0,1], [0,1]],
	"Wildling":    [[6,7], [1,2], [1,2], [1,2], [2,3], [1,2], [1,2], [0,1], [0,1]],
	"Wanderer":    [[6,8], [1,2], [1,2], [1,2], [1,2], [2,3], [1,2], [0,1], [0,1]],
	"_generic":    [[5,8], [1,2], [1,2], [1,2], [1,2], [1,2], [1,1], [0,1], [0,1]],
}

static func _apply_level_up(f: FighterData, g: Array) -> void:
	f.level += 1
	var hp: int = randi_range(g[0][0], g[0][1]); f.health += hp; f.max_health += hp
	var mp: int = randi_range(g[1][0], g[1][1]); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(g[2][0], g[2][1])
	f.physical_defense += randi_range(g[3][0], g[3][1])
	f.magic_attack += randi_range(g[4][0], g[4][1])
	f.magic_defense += randi_range(g[5][0], g[5][1])
	f.speed += randi_range(g[6][0], g[6][1])
	f.dodge_chance += randi_range(g[7][0], g[7][1])
	f.crit_chance += randi_range(g[8][0], g[8][1])


# =============================================================================
# Player class creation router
# =============================================================================

static func create_player(class_id: String, fighter_name: String, portrait_variant: String = "m") -> FighterData:
	var f: FighterData
	match class_id:
		"Squire": f = create_squire(fighter_name)
		"Mage": f = create_mage(fighter_name)
		"Entertainer": f = create_entertainer(fighter_name)
		"Tinker": f = create_scholar(fighter_name)
		"Wildling": f = create_wildling(fighter_name)
		"Wanderer": f = create_wanderer(fighter_name)
		_:
			push_error("Unknown player class: %s" % class_id)
			f = create_squire(fighter_name)
	f.portrait_variant = portrait_variant
	return f


# =============================================================================
# Default upgrade items by class_id (for save migration)
# =============================================================================

static func get_default_upgrade_items(class_id: String) -> Array[String]:
	match class_id:
		# T0
		"Squire": return ["Sword", "Bow", "Headband"]
		"Mage": return ["RedStone", "WhiteStone"]
		"Entertainer": return ["Lyre", "Slippers", "Scroll"]
		"Tinker": return ["Crystal", "Textbook", "Abacus"]
		"Wildling": return ["Herbs", "Totem", "BeastClaw"]
		"Wanderer": return ["Shield", "Compass"]
		# T1
		"Duelist": return ["Horse", "Spear"]
		"Ranger": return ["Gun", "Trap"]
		"MartialArtist": return ["Sword", "Staff"]
		"Invoker": return ["FireStone", "WaterStone", "LightningStone"]
		"Acolyte": return ["Hammer", "HolyBook", "DarkOrb"]
		"Bard": return ["WarHorn", "Hat"]
		"Dervish": return ["Light", "Paint"]
		"Orator": return ["Medal", "Pen"]
		"Artificer": return ["Potion", "Hammer"]
		"Philosopher": return ["TimeMachine", "Telescope"]
		"Arithmancer": return ["ClockworkCore", "Computer"]
		"Herbalist": return ["Venom", "Seedling"]
		"Shaman": return ["Shrunkenhead", "SpiritOrb"]
		"Beastcaller": return ["Feather", "Pelt"]
		"Sentinel": return ["Fortress", "Mirror"]
		"Pathfinder": return ["Torch", "Waterskin"]
	# T2 and Royal classes have no upgrades
	return []


static func get_class_tier(class_id: String) -> int:
	## Returns 0 for T0 (base), 1 for T1, 2 for T2.
	match class_id:
		"Squire", "Mage", "Entertainer", "Tinker", "Wildling", "Wanderer":
			return 0
		"Duelist", "Ranger", "MartialArtist", "Invoker", "Acolyte", \
		"Bard", "Dervish", "Orator", "Artificer", "Philosopher", \
		"Arithmancer", "Herbalist", "Shaman", "Beastcaller", \
		"Sentinel", "Pathfinder":
			return 1
	return 2


# =============================================================================
# Class upgrade: item determines new class, keeps accumulated stats
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
		"Entertainer:Lyre": T1.upgrade_to_bard(fighter)
		"Entertainer:Slippers": T1.upgrade_to_dervish(fighter)
		"Entertainer:Scroll": T1.upgrade_to_orator(fighter)
		"Tinker:Crystal": T1.upgrade_to_artificer(fighter)
		"Tinker:Textbook": T1.upgrade_to_philosopher(fighter)
		"Tinker:Abacus": T1.upgrade_to_arithmancer(fighter)
		"Wildling:Herbs": T1.upgrade_to_herbalist(fighter)
		"Wildling:Totem": T1.upgrade_to_shaman(fighter)
		"Wildling:BeastClaw": T1.upgrade_to_beastcaller(fighter)
		"Wanderer:Shield": T1.upgrade_to_sentinel(fighter)
		"Wanderer:Compass": T1.upgrade_to_pathfinder(fighter)
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
		"Philosopher:TimeMachine": T2B.upgrade_to_chronomancer(fighter)
		"Philosopher:Telescope": T2B.upgrade_to_astronomer(fighter)
		"Arithmancer:ClockworkCore": T2B.upgrade_to_automaton(fighter)
		"Arithmancer:Computer": T2B.upgrade_to_technomancer(fighter)
		# T1 → T2 (Wildling tree)
		"Herbalist:Venom": T2C.upgrade_to_blighter(fighter)
		"Herbalist:Seedling": T2C.upgrade_to_grove_keeper(fighter)
		"Shaman:Shrunkenhead": T2C.upgrade_to_witch_doctor(fighter)
		"Shaman:SpiritOrb": T2C.upgrade_to_spiritwalker(fighter)
		"Beastcaller:Feather": T2C.upgrade_to_falconer(fighter)
		"Beastcaller:Pelt": T2C.upgrade_to_shapeshifter(fighter)
		# T1 → T2 (Wanderer tree)
		"Sentinel:Fortress": T2.upgrade_to_bulwark(fighter)
		"Sentinel:Mirror": T2.upgrade_to_aegis(fighter)
		"Pathfinder:Torch": T2C.upgrade_to_trailblazer(fighter)
		"Pathfinder:Waterskin": T2C.upgrade_to_survivalist(fighter)
		_:
			push_error("Unknown upgrade: %s" % key)
			return false
	return true


# =============================================================================
# Upgrade preview (non-destructive)
# =============================================================================

static func preview_upgrade(fighter: FighterData, item: String) -> Dictionary:
	var c: FighterData = fighter.clone()
	var old_stats: Dictionary = _snapshot_stats(c)
	if not upgrade_class(c, item):
		return {}
	var new_stats: Dictionary = _snapshot_stats(c)
	var deltas: Dictionary = {}
	for key: String in old_stats:
		var diff: int = new_stats[key] - old_stats[key]
		if diff != 0:
			deltas[key] = diff
	var ability_names: Array[String] = []
	var ability_details: Array[Dictionary] = []
	for a: RefCounted in c.abilities:
		ability_names.append(a.ability_name)
		ability_details.append({
			"name": a.ability_name,
			"description": a.get_compendium_description(),
			"mana_cost": a.mana_cost,
		})
	var role_labels: Array[String] = []
	for role in Roles.get_roles(c.class_id):
		match role:
			Enums.Role.DPS: role_labels.append("Striker")
			Enums.Role.FIGHTER: role_labels.append("Fighter")
			Enums.Role.BURST: role_labels.append("Nuker")
			Enums.Role.TANK: role_labels.append("Tank")
			Enums.Role.SUPPORT: role_labels.append("Support")
			Enums.Role.CASTER: role_labels.append("Caster")
			Enums.Role.HYBRID: role_labels.append("Hybrid")
	return {"new_class": c.character_type, "new_class_id": c.class_id, "deltas": deltas,
		"abilities": ability_names, "ability_details": ability_details, "roles": role_labels}


static func _snapshot_stats(f: FighterData) -> Dictionary:
	return {
		"HP": f.max_health, "MP": f.max_mana,
		"P.ATK": f.physical_attack, "P.DEF": f.physical_defense,
		"M.ATK": f.magic_attack, "M.DEF": f.magic_defense,
		"SPD": f.speed, "CRIT": f.crit_chance, "DODGE": f.dodge_chance,
	}


# =============================================================================
# Metadata wrappers (delegated to fighter_db_meta.gd)
# =============================================================================

static func get_display_name(class_id: String) -> String:
	return Meta.get_display_name(class_id)

static func get_abilities_for_class(class_id: String) -> Array:
	return Meta.get_abilities_for_class(class_id)

static func get_flavor_text(class_id: String) -> String:
	return Meta.get_flavor_text(class_id)
