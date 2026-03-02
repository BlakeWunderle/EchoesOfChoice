class_name FighterDBT2B

## Tier 2 class upgrades and level-up growth rates (Entertainer, Tinker, Wildling trees).

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")
const PAB := preload("res://scripts/data/ability_db_player.gd")


# =============================================================================
# Entertainer tree — Bard branch
# =============================================================================

static func upgrade_to_warcrier(f: FighterData) -> void:
	f.class_id = "Warcrier"; f.character_type = "Warcrier"
	f.health += 8; f.max_health += 8; f.physical_attack += 5; f.physical_defense += 3
	f.crit_chance = 30; f.crit_damage = 3; f.dodge_chance = 20
	f.abilities = [PAB.battle_cry(), AbilityDB.smash(), PAB.encore()]
	f.upgrade_items = []

static func upgrade_to_minstrel(f: FighterData) -> void:
	f.class_id = "Minstrel"; f.character_type = "Minstrel"
	f.magic_attack += 5; f.magic_defense += 5; f.mana += 5; f.max_mana += 5
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.ballad(), AbilityDB.frustrate(), PAB.serenade()]
	f.upgrade_items = []

static func _lu_warcrier(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(10, 12); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(4, 6); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(2, 4); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 2)

static func _lu_minstrel(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(4, 6); f.health += hp; f.max_health += hp
	var mp := randi_range(5, 7); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 5); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(3, 5); f.magic_defense += randi_range(3, 5)
	f.speed += randi_range(2, 2)


# =============================================================================
# Entertainer tree — Dervish branch
# =============================================================================

static func upgrade_to_illusionist(f: FighterData) -> void:
	f.class_id = "Illusionist"; f.character_type = "Illusionist"
	f.health += 5; f.max_health += 5; f.magic_attack += 7; f.speed += 7
	f.crit_chance = 30; f.crit_damage = 2; f.dodge_chance = 40
	f.abilities = [AbilityDB.shadow_attack(), PAB.mirage(), PAB.bewilderment()]
	f.upgrade_items = []

static func upgrade_to_mime(f: FighterData) -> void:
	f.class_id = "Mime"; f.character_type = "Mime"
	f.magic_attack += 5; f.magic_defense += 5; f.mana += 5; f.max_mana += 5
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 30
	f.abilities = [PAB.invisible_wall(), PAB.anvil(), PAB.invisible_box()]
	f.upgrade_items = []

static func _lu_illusionist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(10, 12); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 4); f.physical_defense += randi_range(3, 5)
	f.magic_attack += randi_range(5, 7); f.magic_defense += randi_range(3, 4)
	f.speed += randi_range(2, 3)

static func _lu_mime(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(8, 10); f.health += hp; f.max_health += hp
	var mp := randi_range(5, 7); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(3, 4); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(5, 7); f.magic_defense += randi_range(5, 7)
	f.speed += randi_range(1, 2)


# =============================================================================
# Entertainer tree — Orator branch
# =============================================================================

static func upgrade_to_laureate(f: FighterData) -> void:
	f.class_id = "Laureate"; f.character_type = "Laureate"
	f.magic_attack += 8; f.magic_defense += 5
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.ovation(), PAB.recite(), PAB.eulogy()]
	f.upgrade_items = []

static func upgrade_to_elegist(f: FighterData) -> void:
	f.class_id = "Elegist"; f.character_type = "Elegist"
	f.health += 5; f.max_health += 5
	f.magic_attack += 5; f.magic_defense += 3; f.speed += 6
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [PAB.nightfall(), PAB.inspire(), PAB.dirge()]
	f.upgrade_items = []

static func _lu_laureate(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp := randi_range(6, 8); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(7, 9); f.magic_defense += randi_range(3, 5)
	f.speed += randi_range(1, 2)

static func _lu_elegist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(10, 12); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(6, 8); f.magic_defense += randi_range(7, 9)
	f.speed += randi_range(2, 2)


# =============================================================================
# Tinker tree — Artificer branch
# =============================================================================

static func upgrade_to_alchemist(f: FighterData) -> void:
	f.class_id = "Alchemist"; f.character_type = "Alchemist"
	f.health += 5; f.max_health += 5; f.physical_attack += 5; f.magic_attack += 5
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.transmute(), PAB.corrosive_acid(), PAB.elixir()]
	f.upgrade_items = []

static func upgrade_to_bombardier(f: FighterData) -> void:
	f.class_id = "Bombardier"; f.character_type = "Bombardier"
	f.health += 8; f.max_health += 8
	f.physical_attack += 5; f.physical_defense += 3; f.magic_defense += 3
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [PAB.shrapnel(), PAB.explosion(), PAB.detonate()]
	f.upgrade_items = []

static func _lu_alchemist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(8, 10); f.health += hp; f.max_health += hp
	var mp := randi_range(7, 9); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(5, 7); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(5, 7); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 1)

static func _lu_bombardier(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(14, 16); f.health += hp; f.max_health += hp
	var mp := randi_range(4, 6); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(6, 8); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(3, 5); f.magic_defense += randi_range(4, 6)
	f.speed += randi_range(1, 1)


# =============================================================================
# Tinker tree — Cosmologist branch
# =============================================================================

static func upgrade_to_chronomancer(f: FighterData) -> void:
	f.class_id = "Chronomancer"; f.character_type = "Chronomancer"
	f.magic_attack += 5; f.magic_defense += 3; f.speed += 7
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.warp_speed(), PAB.time_bomb(), PAB.time_freeze()]
	f.upgrade_items = []

static func upgrade_to_astronomer(f: FighterData) -> void:
	f.class_id = "Astronomer"; f.character_type = "Astronomer"
	f.magic_attack += 8; f.magic_defense += 3
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.starfall(), PAB.meteor_shower(), PAB.eclipse()]
	f.upgrade_items = []

static func _lu_chronomancer(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(11, 13); f.health += hp; f.max_health += hp
	var mp := randi_range(7, 9); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(5, 7); f.magic_defense += randi_range(5, 7)
	f.speed += randi_range(1, 2)

static func _lu_astronomer(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(7, 9); f.magic_defense += randi_range(5, 7)
	f.speed += randi_range(1, 1)


# =============================================================================
# Tinker tree — Arithmancer branch
# =============================================================================

static func upgrade_to_automaton(f: FighterData) -> void:
	f.class_id = "Automaton"; f.character_type = "Automaton"
	f.health += 8; f.max_health += 8; f.physical_defense += 5; f.magic_attack += 3
	f.crit_chance = 30; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [PAB.servo_strike(), PAB.program_defense(), PAB.overclock()]
	f.upgrade_items = []

static func upgrade_to_technomancer(f: FighterData) -> void:
	f.class_id = "Technomancer"; f.character_type = "Technomancer"
	f.magic_attack += 8; f.mana += 5; f.max_mana += 5
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.random_attack(), PAB.program_defense(), PAB.program_offense()]
	f.upgrade_items = []

static func _lu_automaton(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(5, 7); f.health += hp; f.max_health += hp
	var mp := randi_range(4, 6); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(4, 6)
	f.magic_attack += randi_range(6, 8); f.magic_defense += randi_range(4, 6)
	f.speed += randi_range(1, 1)

static func _lu_technomancer(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(8, 10); f.health += hp; f.max_health += hp
	var mp := randi_range(14, 16); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(7, 9); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(1, 1)


# =============================================================================
# Wildling tree — Herbalist branch
# =============================================================================

static func upgrade_to_blighter(f: FighterData) -> void:
	f.class_id = "Blighter"; f.character_type = "Blighter"
	f.health += 8; f.max_health += 8; f.magic_attack += 7
	f.magic_defense += 3; f.speed += 3
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [PAB.blight(), PAB.life_siphon(), PAB.poison_sting()]
	f.upgrade_items = []

static func upgrade_to_grove_keeper(f: FighterData) -> void:
	f.class_id = "GroveKeeper"; f.character_type = "Grove Keeper"
	f.health += 5; f.max_health += 5; f.physical_defense += 3; f.magic_defense += 3
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.vine_wall(), PAB.root_trap(), PAB.overgrowth()]
	f.upgrade_items = []

static func _lu_blighter(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(7, 10); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(5, 7); f.magic_defense += randi_range(3, 4)
	f.speed += randi_range(2, 2)

static func _lu_grove_keeper(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(8, 10); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(2, 3); f.magic_defense += randi_range(3, 4)
	f.speed += randi_range(1, 1)


# =============================================================================
# Wildling tree — Shaman branch
# =============================================================================

static func upgrade_to_witch_doctor(f: FighterData) -> void:
	f.class_id = "WitchDoctor"; f.character_type = "Witch Doctor"
	f.health += 12; f.max_health += 12; f.magic_attack += 10; f.speed += 5
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 15
	f.abilities = [PAB.voodoo_bolt(), PAB.dark_hex(), PAB.creeping_rot()]
	f.upgrade_items = []

static func upgrade_to_spiritwalker(f: FighterData) -> void:
	f.class_id = "Spiritwalker"; f.character_type = "Spiritwalker"
	f.health += 10; f.max_health += 10; f.magic_attack += 6; f.magic_defense += 6
	f.speed += 4
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [PAB.spirit_shield(), PAB.ancestral_blessing(), PAB.spirit_mend()]
	f.upgrade_items = []

static func _lu_witch_doctor(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(8, 11); f.health += hp; f.max_health += hp
	var mp := randi_range(3, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(5, 7); f.magic_defense += randi_range(2, 3)
	f.speed += randi_range(2, 2)

static func _lu_spiritwalker(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(8, 11); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(4, 5); f.magic_defense += randi_range(3, 4)
	f.speed += randi_range(2, 2)


# =============================================================================
# Wildling tree — Beastcaller branch
# =============================================================================

static func upgrade_to_falconer(f: FighterData) -> void:
	f.class_id = "Falconer"; f.character_type = "Falconer"
	f.physical_attack += 7; f.speed += 5
	f.health += 5; f.max_health += 5
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [PAB.falcon_strike(), PAB.sky_dive(), PAB.raptors_mark()]
	f.upgrade_items = []

static func upgrade_to_shapeshifter(f: FighterData) -> void:
	f.class_id = "Shapeshifter"; f.character_type = "Shapeshifter"
	f.health += 16; f.max_health += 16; f.physical_attack += 14
	f.physical_defense += 5; f.speed += 6
	f.crit_chance = 20; f.crit_damage = 3; f.dodge_chance = 20
	f.abilities = [PAB.savage_maul(), PAB.frenzy(), PAB.primal_roar()]
	f.upgrade_items = []

static func _lu_falconer(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(8, 10); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(5, 7); f.physical_defense += randi_range(1, 2)
	f.magic_attack += randi_range(1, 2); f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(2, 3)

static func _lu_shapeshifter(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(8, 10); f.physical_defense += randi_range(4, 5)
	f.magic_attack += randi_range(1, 2); f.magic_defense += randi_range(1, 2)
	f.speed += randi_range(2, 3)


# =============================================================================
# Level-up router
# =============================================================================

static func level_up(f: FighterData) -> bool:
	match f.class_id:
		"Warcrier": _lu_warcrier(f)
		"Minstrel": _lu_minstrel(f)
		"Illusionist": _lu_illusionist(f)
		"Mime": _lu_mime(f)
		"Laureate": _lu_laureate(f)
		"Elegist": _lu_elegist(f)
		"Alchemist": _lu_alchemist(f)
		"Bombardier": _lu_bombardier(f)
		"Chronomancer": _lu_chronomancer(f)
		"Astronomer": _lu_astronomer(f)
		"Automaton": _lu_automaton(f)
		"Technomancer": _lu_technomancer(f)
		"Blighter": _lu_blighter(f)
		"GroveKeeper": _lu_grove_keeper(f)
		"WitchDoctor": _lu_witch_doctor(f)
		"Spiritwalker": _lu_spiritwalker(f)
		"Falconer": _lu_falconer(f)
		"Shapeshifter": _lu_shapeshifter(f)
		_: return false
	return true
