class_name FighterDBT2B

## Tier 2 class upgrades and level-up growth rates (Entertainer, Tinker trees).

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")
const PAB := preload("res://scripts/data/ability_db_player.gd")
const PAB_B := preload("res://scripts/data/ability_db_player_b.gd")


# =============================================================================
# Entertainer tree:Bard branch
# =============================================================================

static func upgrade_to_warcrier(f: FighterData) -> void:
	f.class_id = "Warcrier"; f.character_type = "Warcrier"
	f.health += 16; f.max_health += 16; f.mana += 1; f.max_mana += 1
	f.physical_attack += 12; f.physical_defense += 6; f.magic_attack += 2; f.magic_defense += 7
	f.speed += 4; f.crit_chance += 3; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB.battle_cry(), PAB.war_chant(), PAB.rally_cry()]
	f.upgrade_items = []

static func upgrade_to_minstrel(f: FighterData) -> void:
	f.class_id = "Minstrel"; f.character_type = "Minstrel"
	f.health += 11; f.max_health += 11; f.mana += 3; f.max_mana += 3
	f.physical_attack += 2; f.physical_defense += 5; f.magic_attack += 12; f.magic_defense += 6
	f.speed += 6; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB.ballad(), PAB.dissonance(), PAB.serenade()]
	f.upgrade_items = []

static func _lu_warcrier(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(5, 7); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(1, 2); f.magic_defense += randi_range(3, 4)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(0, 1)
	f.crit_chance += randi_range(1, 2)

static func _lu_minstrel(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(10, 12); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(0, 1); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(5, 7); f.magic_defense += randi_range(3, 5)
	f.speed += randi_range(2, 3)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)


# =============================================================================
# Entertainer tree:Dervish branch
# =============================================================================

static func upgrade_to_illusionist(f: FighterData) -> void:
	f.class_id = "Illusionist"; f.character_type = "Illusionist"
	f.health += 10; f.max_health += 10; f.mana += 2; f.max_mana += 2
	f.physical_attack += 2; f.physical_defense += 5; f.magic_attack += 14; f.magic_defense += 7
	f.speed += 9; f.crit_chance += 3; f.crit_damage += 2; f.dodge_chance += 6
	f.abilities = [PAB.phantom_strike(), PAB.mirage(), PAB.bewilderment()]
	f.upgrade_items = []

static func upgrade_to_mime(f: FighterData) -> void:
	f.class_id = "Mime"; f.character_type = "Mime"
	f.health += 16; f.max_health += 16; f.mana += 3; f.max_mana += 3
	f.physical_attack += 6; f.physical_defense += 5; f.magic_attack += 16; f.magic_defense += 7
	f.speed += 3; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 5
	f.abilities = [PAB.invisible_wall(), PAB.anvil(), PAB.invisible_box()]
	f.upgrade_items = []

static func _lu_illusionist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(1, 2); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3); f.physical_defense += randi_range(3, 5)
	f.magic_attack += randi_range(6, 8); f.magic_defense += randi_range(5, 6)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(2, 3)
	f.crit_chance += randi_range(1, 2)

static func _lu_mime(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(13, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(4, 5); f.physical_defense += randi_range(4, 5)
	f.magic_attack += randi_range(8, 9); f.magic_defense += randi_range(5, 7)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(3, 4)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Entertainer tree:Orator branch
# =============================================================================

static func upgrade_to_laureate(f: FighterData) -> void:
	f.class_id = "Laureate"; f.character_type = "Laureate"
	f.health += 15; f.max_health += 15; f.mana += 2; f.max_mana += 2
	f.physical_attack += 2; f.physical_defense += 5; f.magic_attack += 15; f.magic_defense += 7
	f.speed += 5; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB.ovation(), PAB.recite(), PAB.magnum_opus()]
	f.upgrade_items = []

static func upgrade_to_elegist(f: FighterData) -> void:
	f.class_id = "Elegist"; f.character_type = "Elegist"
	f.health += 12; f.max_health += 12; f.mana += 2; f.max_mana += 2
	f.physical_attack += 2; f.physical_defense += 5; f.magic_attack += 13; f.magic_defense += 7
	f.speed += 8; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB.requiem(), PAB.lament(), PAB.dirge()]
	f.upgrade_items = []

static func _lu_laureate(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(13, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(3, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(0, 1); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(4, 6); f.magic_defense += randi_range(4, 6)
	f.speed += randi_range(2, 3)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)

static func _lu_elegist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(11, 13); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(0, 1); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(8, 10); f.magic_defense += randi_range(5, 7)
	f.speed += randi_range(2, 3)
	f.dodge_chance += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)


# =============================================================================
# Tinker tree:Artificer branch
# =============================================================================

static func upgrade_to_alchemist(f: FighterData) -> void:
	f.class_id = "Alchemist"; f.character_type = "Alchemist"
	f.health += 14; f.max_health += 14; f.mana += 2; f.max_mana += 2
	f.physical_attack += 3; f.physical_defense += 5; f.magic_attack += 15; f.magic_defense += 6
	f.speed += 4; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB_B.transmute(), PAB_B.corrosive_acid(), PAB_B.elixir()]
	f.upgrade_items = []

static func upgrade_to_bombardier(f: FighterData) -> void:
	f.class_id = "Bombardier"; f.character_type = "Bombardier"
	f.health += 14; f.max_health += 14; f.mana += 1; f.max_mana += 1
	f.physical_attack += 2; f.physical_defense += 4; f.magic_attack += 18; f.magic_defense += 5
	f.speed += 4; f.crit_chance += 7; f.crit_damage += 5; f.dodge_chance += 2
	f.abilities = [PAB_B.cluster_bomb(), PAB_B.explosion(), PAB_B.demolition_charge()]
	f.upgrade_items = []

static func _lu_alchemist(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(10, 12); f.health += hp; f.max_health += hp
	var mp := randi_range(3, 5); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(2, 3)
	f.magic_attack += randi_range(7, 9); f.magic_defense += randi_range(3, 4)
	f.speed += randi_range(2, 3)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)

static func _lu_bombardier(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(13, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(0, 1); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(6, 8); f.magic_defense += randi_range(5, 7)
	f.speed += randi_range(2, 2)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)


# =============================================================================
# Tinker tree:Cosmologist branch
# =============================================================================

static func upgrade_to_chronomancer(f: FighterData) -> void:
	f.class_id = "Chronomancer"; f.character_type = "Chronomancer"
	f.health += 14; f.max_health += 14; f.mana += 2; f.max_mana += 2
	f.physical_attack += 2; f.physical_defense += 5; f.magic_attack += 17; f.magic_defense += 6
	f.speed += 8; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB_B.temporal_rift(), PAB_B.time_bomb(), PAB_B.time_freeze()]
	f.upgrade_items = []

static func upgrade_to_astronomer(f: FighterData) -> void:
	f.class_id = "Astronomer"; f.character_type = "Astronomer"
	f.health += 9; f.max_health += 9; f.mana += 2; f.max_mana += 2
	f.physical_attack += 2; f.physical_defense += 5; f.magic_attack += 18; f.magic_defense += 7
	f.speed += 7; f.crit_chance += 3; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB_B.starfall(), PAB_B.meteor_shower(), PAB_B.eclipse()]
	f.upgrade_items = []

static func _lu_chronomancer(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(3, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(0, 1); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(5, 6); f.magic_defense += randi_range(4, 6)
	f.speed += randi_range(2, 2)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)

static func _lu_astronomer(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(0, 1); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(6, 8); f.magic_defense += randi_range(4, 6)
	f.speed += randi_range(2, 3)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)


# =============================================================================
# Tinker tree:Arithmancer branch
# =============================================================================

static func upgrade_to_automaton(f: FighterData) -> void:
	f.class_id = "Automaton"; f.character_type = "Automaton"
	f.health += 16; f.max_health += 16; f.mana += 1; f.max_mana += 1
	f.physical_attack += 2; f.physical_defense += 7; f.magic_attack += 12; f.magic_defense += 6
	f.speed += 4; f.crit_chance += 2; f.crit_damage += 2; f.dodge_chance += 3
	f.abilities = [PAB_B.servo_strike(), PAB_B.discharge(), PAB_B.self_repair()]
	f.upgrade_items = []

static func upgrade_to_technomancer(f: FighterData) -> void:
	f.class_id = "Technomancer"; f.character_type = "Technomancer"
	f.health += 15; f.max_health += 15; f.mana += 3; f.max_mana += 3
	f.physical_attack += 9; f.physical_defense += 6; f.magic_attack += 10; f.magic_defense += 7
	f.speed += 5; f.crit_chance += 3; f.crit_damage += 2; f.dodge_chance += 2
	f.abilities = [PAB_B.circuit_blast(), PAB_B.techno_drain(), PAB_B.emp_pulse()]
	f.upgrade_items = []

static func _lu_automaton(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(13, 15); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 3); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(1, 2); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(4, 6); f.magic_defense += randi_range(3, 5)
	f.speed += randi_range(1, 2)
	f.crit_chance += randi_range(1, 2)

static func _lu_technomancer(f: FighterData) -> void:
	f.level += 1
	var hp := randi_range(12, 14); f.health += hp; f.max_health += hp
	var mp := randi_range(2, 4); f.mana += mp; f.max_mana += mp
	f.physical_attack += randi_range(2, 3); f.physical_defense += randi_range(3, 4)
	f.magic_attack += randi_range(8, 10); f.magic_defense += randi_range(4, 5)
	f.speed += randi_range(1, 2)
	f.crit_chance += randi_range(0, 1)
	f.dodge_chance += randi_range(0, 1)


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
		_: return false
	return true
