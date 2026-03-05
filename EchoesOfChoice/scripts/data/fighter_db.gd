class_name FighterDB

## Static factory for creating fighters with randomized stats.
## C# random.Next(min, max) is exclusive upper bound.
## GDScript randi_range(min, max) is inclusive, so we use max-1.

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
	f.mana = randi_range(4, 8); f.max_mana = f.mana
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
	f.mana = randi_range(8, 12); f.max_mana = f.mana
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
	f.mana = randi_range(8, 12); f.max_mana = f.mana
	f.physical_attack = randi_range(10, 16)
	f.physical_defense = randi_range(10, 14)
	f.magic_attack = randi_range(12, 19)
	f.magic_defense = randi_range(15, 19)
	f.speed = randi_range(16, 20)
	f.crit_chance = 10
	f.crit_damage = 1
	f.dodge_chance = 5
	f.abilities = [AbilityDB.mockery(), AbilityDB.demoralize()]
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
	f.mana = randi_range(8, 12); f.max_mana = f.mana
	f.physical_attack = randi_range(9, 12)
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
	f.mana = randi_range(6, 9); f.max_mana = f.mana
	f.physical_attack = randi_range(10, 13)
	f.physical_defense = randi_range(10, 13)
	f.magic_attack = randi_range(12, 15)
	f.magic_defense = randi_range(12, 15)
	f.speed = randi_range(22, 26)
	f.crit_chance = 10
	f.crit_damage = 1
	f.dodge_chance = 15
	f.abilities = [AbilityDB.thorn_whip(), AbilityDB.bark_skin()]
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
	f.mana = randi_range(6, 10); f.max_mana = f.mana
	f.physical_attack = randi_range(10, 14)
	f.physical_defense = randi_range(8, 11)
	f.magic_attack = randi_range(9, 12)
	f.magic_defense = randi_range(14, 18)
	f.speed = randi_range(21, 25)
	f.crit_chance = 15
	f.crit_damage = 2
	f.dodge_chance = 15
	f.abilities = [AbilityDB.wild_strike(), AbilityDB.natures_ward()]
	f.upgrade_items = ["Shield", "Compass"]
	return f


# =============================================================================
# Level up: chains through T0 → T1 → T2/T2B
# =============================================================================

static func level_up(fighter: FighterData) -> void:
	match fighter.class_id:
		"Squire": _level_up_squire(fighter)
		"Mage": _level_up_mage(fighter)
		"Entertainer": _level_up_entertainer(fighter)
		"Tinker": _level_up_scholar(fighter)
		"Wildling": _level_up_wildling(fighter)
		"Wanderer": _level_up_wanderer(fighter)
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
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)


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
	f.speed += randi_range(1, 1)
	f.dodge_chance += randi_range(0, 1)


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
	f.speed += randi_range(1, 2)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)


static func _level_up_wanderer(f: FighterData) -> void:
	f.level += 1
	var hp: int = randi_range(6, 8); f.health += hp; f.max_health += hp
	var mp: int = randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2)
	f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(1, 2)
	f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 2)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)


static func _level_up_generic(f: FighterData) -> void:
	f.level += 1
	var hp: int = randi_range(5, 8); f.health += hp; f.max_health += hp
	var mp: int = randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2)
	f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(1, 2)
	f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(1, 1)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(0, 1)


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
		"Wanderer": return create_wanderer(fighter_name)
		_:
			push_error("Unknown player class: %s" % class_id)
			return create_squire(fighter_name)


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
		"Cosmologist": return ["TimeMachine", "Telescope"]
		"Arithmancer": return ["ClockworkCore", "Computer"]
		"Herbalist": return ["Venom", "Seedling"]
		"Shaman": return ["Shrunkenhead", "SpiritOrb"]
		"Beastcaller": return ["Feather", "Pelt"]
		"Sentinel": return ["Fortress", "Mirror"]
		"Pathfinder": return ["Torch", "Waterskin"]
	# T2 and Royal classes have no upgrades
	return []


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
		"Tinker:Textbook": T1.upgrade_to_cosmologist(fighter)
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
		# T1 → T2 (Wanderer tree)
		"Sentinel:Fortress": T2.upgrade_to_bulwark(fighter)
		"Sentinel:Mirror": T2.upgrade_to_aegis(fighter)
		"Pathfinder:Torch": T2B.upgrade_to_trailblazer(fighter)
		"Pathfinder:Waterskin": T2B.upgrade_to_survivalist(fighter)
		_:
			push_error("Unknown upgrade: %s" % key)
			return false
	return true


# =============================================================================
# Save/load helpers
# =============================================================================

static func get_display_name(class_id: String) -> String:
	match class_id:
		# T0
		"Squire": return "Squire"
		"Mage": return "Mage"
		"Entertainer": return "Entertainer"
		"Tinker": return "Tinker"
		"Wildling": return "Wildling"
		# T1:Squire
		"Duelist": return "Duelist"
		"Ranger": return "Ranger"
		"MartialArtist": return "Martial Artist"
		# T1:Mage
		"Invoker": return "Invoker"
		"Acolyte": return "Acolyte"
		# T1:Entertainer
		"Bard": return "Bard"
		"Dervish": return "Dervish"
		"Orator": return "Orator"
		# T1:Tinker
		"Artificer": return "Artificer"
		"Cosmologist": return "Philosopher"
		"Arithmancer": return "Arithmancer"
		# T1:Wildling
		"Herbalist": return "Herbalist"
		"Shaman": return "Shaman"
		"Beastcaller": return "Beastcaller"
		# T0:Wanderer
		"Wanderer": return "Wanderer"
		# T1:Wanderer
		"Sentinel": return "Sentinel"
		"Pathfinder": return "Pathfinder"
		# T2:Squire
		"Cavalry": return "Cavalry"
		"Dragoon": return "Dragoon"
		"Mercenary": return "Mercenary"
		"Hunter": return "Hunter"
		"Ninja": return "Ninja"
		"Monk": return "Monk"
		# T2:Mage
		"Infernalist": return "Infernalist"
		"Tidecaller": return "Tidecaller"
		"Tempest": return "Tempest"
		"Paladin": return "Paladin"
		"Priest": return "Priest"
		"Warlock": return "Warlock"
		# T2:Entertainer
		"Warcrier": return "Warcrier"
		"Minstrel": return "Minstrel"
		"Illusionist": return "Illusionist"
		"Mime": return "Mime"
		"Laureate": return "Laureate"
		"Elegist": return "Elegist"
		# T2:Tinker
		"Alchemist": return "Alchemist"
		"Bombardier": return "Bombardier"
		"Chronomancer": return "Chronomancer"
		"Astronomer": return "Astronomer"
		"Automaton": return "Automaton"
		"Technomancer": return "Technomancer"
		# T2:Wildling
		"Blighter": return "Blighter"
		"GroveKeeper": return "Grove Keeper"
		"WitchDoctor": return "Witch Doctor"
		"Spiritwalker": return "Spiritwalker"
		"Falconer": return "Falconer"
		"Shapeshifter": return "Shapeshifter"
		# T2:Wanderer
		"Bulwark": return "Bulwark"
		"Aegis": return "Aegis"
		"Trailblazer": return "Trailblazer"
		"Survivalist": return "Survivalist"
		_: return class_id


static func get_abilities_for_class(class_id: String) -> Array:
	var PAB := preload("res://scripts/data/ability_db_player.gd")
	match class_id:
		# T0
		"Squire": return [AbilityDB.slash(), AbilityDB.guard()]
		"Mage": return [AbilityDB.arcane_bolt()]
		"Entertainer": return [AbilityDB.mockery(), AbilityDB.demoralize()]
		"Tinker": return [AbilityDB.proof(), AbilityDB.energy_blast()]
		"Wildling": return [AbilityDB.thorn_whip(), AbilityDB.bark_skin()]
		"Wanderer": return [AbilityDB.wild_strike(), AbilityDB.natures_ward()]
		# T1:Squire
		"Duelist": return [AbilityDB.slash(), PAB.feint()]
		"Ranger": return [PAB.pierce(), PAB.double_arrow()]
		"MartialArtist": return [PAB.punch(), PAB.topple()]
		# T1:Mage
		"Invoker": return [AbilityDB.arcane_bolt(), PAB.elemental_surge()]
		"Acolyte": return [PAB.cure(), PAB.protect(), PAB.radiance()]
		# T1:Entertainer
		"Bard": return [PAB.seduce(), PAB.melody(), PAB.encourage()]
		"Dervish": return [PAB.seduce(), PAB.dance()]
		"Orator": return [PAB.oration(), PAB.encourage()]
		# T1:Tinker
		"Artificer": return [AbilityDB.energy_blast(), PAB.magical_tinkering()]
		"Cosmologist": return [PAB.time_warp(), PAB.black_hole(), PAB.gravity()]
		"Arithmancer": return [PAB.recite(), PAB.calculate()]
		# T1:Wildling
		"Herbalist": return [PAB.mending_herbs(), PAB.sapping_vine()]
		"Shaman": return [PAB.spectral_lance(), PAB.player_hex()]
		"Beastcaller": return [PAB.feral_strike(), PAB.pack_howl()]
		# T1:Wanderer
		"Sentinel": return [PAB.shield_bash(), PAB.barrier(), PAB.fortify()]
		"Pathfinder": return [PAB.keen_strike(), PAB.exploit_weakness()]
		# T2:Squire
		"Cavalry": return [PAB.lance(), PAB.trample(), AbilityDB.rally()]
		"Dragoon": return [PAB.jump(), PAB.wyvern_strike(), PAB.dragon_ward()]
		"Mercenary": return [PAB.gun_shot(), PAB.called_shot(), PAB.quick_draw()]
		"Hunter": return [PAB.triple_arrow(), PAB.snare(), PAB.hunters_mark()]
		"Ninja": return [PAB.sweeping_slash(), PAB.dash(), PAB.smoke_bomb()]
		"Monk": return [PAB.spirit_attack(), PAB.precise_strike(), PAB.meditate()]
		# T2:Mage
		"Infernalist": return [PAB.fire_ball(), PAB.burning_brand(), PAB.cauterize()]
		"Tidecaller": return [PAB.purify(), PAB.tsunami(), PAB.undertow()]
		"Tempest": return [PAB.hurricane(), PAB.tornado(), PAB.eye_of_the_storm()]
		"Paladin": return [PAB.cure(), AbilityDB.smash(), PAB.smite()]
		"Priest": return [PAB.restoration(), PAB.heavenly_body(), PAB.holy()]
		"Warlock": return [PAB.shadow_bolt(), PAB.curse(), PAB.drain_life()]
		# T2:Entertainer
		"Warcrier": return [PAB.battle_cry(), PAB.encore(), PAB.rally_cry()]
		"Minstrel": return [PAB.ballad(), AbilityDB.frustrate(), PAB.serenade()]
		"Illusionist": return [AbilityDB.shadow_attack(), PAB.mirage(), PAB.bewilderment()]
		"Mime": return [PAB.invisible_wall(), PAB.anvil(), PAB.invisible_box()]
		"Laureate": return [PAB.ovation(), PAB.recite(), PAB.eulogy()]
		"Elegist": return [PAB.nightfall(), PAB.inspire(), PAB.dirge()]
		# T2:Tinker
		"Alchemist": return [PAB.transmute(), PAB.corrosive_acid(), PAB.elixir()]
		"Bombardier": return [PAB.shrapnel(), PAB.explosion(), PAB.field_repair()]
		"Chronomancer": return [PAB.warp_speed(), PAB.time_bomb(), PAB.time_freeze()]
		"Astronomer": return [PAB.starfall(), PAB.meteor_shower(), PAB.eclipse()]
		"Automaton": return [PAB.servo_strike(), PAB.program_defense(), PAB.overclock()]
		"Technomancer": return [PAB.circuit_blast(), PAB.arcane_shield(), PAB.emp_pulse()]
		# T2:Wildling
		"Blighter": return [PAB.blight(), PAB.life_siphon(), PAB.poison_sting()]
		"GroveKeeper": return [PAB.thorn_burst(), PAB.root_trap(), PAB.draining_vines()]
		"WitchDoctor": return [PAB.voodoo_bolt(), PAB.dark_hex(), PAB.creeping_rot()]
		"Spiritwalker": return [PAB.spirit_shield(), PAB.ancestral_blessing(), PAB.spirit_mend()]
		"Falconer": return [PAB.falcon_strike(), PAB.talon_rend(), PAB.raptor_mend()]
		"Shapeshifter": return [PAB.savage_maul(), PAB.frenzy(), PAB.primal_roar()]
		# T2:Wanderer
		"Bulwark": return [PAB.iron_wall(), PAB.repel(), PAB.sanctuary()]
		"Aegis": return [PAB.spell_mirror(), PAB.arcane_counter(), PAB.nullify()]
		"Trailblazer": return [PAB.blaze_trail(), PAB.ambush(), PAB.expose()]
		"Survivalist": return [PAB.endure(), PAB.resourceful_strike(), PAB.adapt()]
		_:
			push_error("Unknown class_id for abilities: %s" % class_id)
			return []
