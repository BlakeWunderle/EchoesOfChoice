class_name EnemyDBS2Act4

## Story 2 Act IV enemy factory: the Eye's domain.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const EABL := preload("res://scripts/data/story2/enemy_ability_db_s2_late.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# The Eye's servants (level 14)
# =============================================================================

static func create_pupil_leech(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Pupil Leech", lvl)
	f.health = EH.es(620, 710, 5, 8, lvl, 14); f.max_health = f.health
	f.mana = EH.es(16, 20, 1, 2, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(25, 31, 1, 2, lvl, 14)
	f.physical_defense = EH.es(48, 57, 2, 4, lvl, 14)
	f.magic_attack = EH.es(106, 119, 3, 5, lvl, 14)
	f.magic_defense = EH.es(46, 55, 2, 3, lvl, 14)
	f.speed = EH.es(39, 46, 1, 3, lvl, 14)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EABL.memory_siphon(), EABL.festering_gaze()]
	f.flavor_text = "A bloated parasite that clings to the Eye's victims, feeding on their drained memories. A single stolen eye stares from its translucent body."
	return f


static func create_gaze_stalker(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Gaze Stalker", lvl)
	f.health = EH.es(492, 558, 5, 8, lvl, 14); f.max_health = f.health
	f.mana = EH.es(11, 14, 1, 2, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(94, 106, 3, 5, lvl, 14)
	f.physical_defense = EH.es(38, 46, 2, 3, lvl, 14)
	f.magic_attack = EH.es(88, 99, 3, 5, lvl, 14)
	f.magic_defense = EH.es(33, 42, 2, 3, lvl, 14)
	f.speed = EH.es(56, 62, 2, 3, lvl, 14)
	f.crit_chance = 25; f.crit_damage = 4; f.dodge_chance = 25
	f.abilities = [EABL.piercing_gaze_strike(), EABL.focus_break()]
	f.flavor_text = "A swift predator that serves as the Eye's hunting hound. It locks onto its prey with an unblinking stare that shatters concentration."
	return f


static func create_memory_harvester(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Memory Harvester", lvl)
	f.health = EH.es(521, 590, 5, 8, lvl, 14); f.max_health = f.health
	f.mana = EH.es(19, 23, 1, 2, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(29, 37, 1, 2, lvl, 14)
	f.physical_defense = EH.es(31, 40, 2, 3, lvl, 14)
	f.magic_attack = EH.es(131, 146, 3, 5, lvl, 14)
	f.magic_defense = EH.es(49, 57, 2, 4, lvl, 14)
	f.speed = EH.es(48, 55, 2, 3, lvl, 14)
	f.crit_chance = 20; f.crit_damage = 4; f.dodge_chance = 17
	f.abilities = [EABL.harvest_thought(), EABL.mass_extraction()]
	f.flavor_text = "A grotesque collector that reaps thoughts like grain. The memories it steals are fed directly to the Eye, fueling its terrible awareness."
	return f


static func create_oblivion_shade(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Oblivion Shade", lvl)
	f.health = EH.es(333, 377, 4, 7, lvl, 14); f.max_health = f.health
	f.mana = EH.es(17, 20, 1, 2, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(30, 38, 1, 2, lvl, 14)
	f.physical_defense = EH.es(21, 30, 1, 3, lvl, 14)
	f.magic_attack = EH.es(120, 136, 3, 4, lvl, 14)
	f.magic_defense = EH.es(45, 54, 2, 4, lvl, 14)
	f.speed = EH.es(51, 58, 2, 4, lvl, 14)
	f.crit_chance = 17; f.crit_damage = 4; f.dodge_chance = 25
	f.abilities = [EABL.wave_of_oblivion(), EABL.nihil_bolt()]
	f.flavor_text = "A wraith woven from pure forgetting. Where it passes, all sense of self dissolves, leaving only a hollow ache where identity once lived."
	return f


static func create_memory_reaper(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Memory Reaper", lvl)
	f.health = EH.es(630, 705, 5, 8, lvl, 14); f.max_health = f.health
	f.mana = EH.es(19, 23, 1, 2, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(30, 38, 1, 2, lvl, 14)
	f.physical_defense = EH.es(28, 37, 2, 3, lvl, 14)
	f.magic_attack = EH.es(136, 154, 3, 5, lvl, 14)
	f.magic_defense = EH.es(52, 60, 2, 4, lvl, 14)
	f.speed = EH.es(43, 50, 2, 3, lvl, 14)
	f.crit_chance = 20; f.crit_damage = 4; f.dodge_chance = 17
	f.abilities = [EABL.harvesting_scythe(), EABL.accumulated_toll()]
	f.flavor_text = "A harvester that has gorged on the Eye's overflow of stolen memories. It reaps with terrible efficiency, each thought it claims adding to the Eye's power."
	return f


static func create_void_iris(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Void Iris", lvl)
	f.health = EH.es(620, 695, 4, 7, lvl, 14); f.max_health = f.health
	f.mana = EH.es(17, 20, 1, 2, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(29, 37, 1, 2, lvl, 14)
	f.physical_defense = EH.es(38, 48, 1, 3, lvl, 14)
	f.magic_attack = EH.es(122, 137, 3, 4, lvl, 14)
	f.magic_defense = EH.es(65, 75, 2, 4, lvl, 14)
	f.speed = EH.es(63, 70, 2, 4, lvl, 14)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EABL.void_lash(), EABL.refraction_link(), EABL.dispel_will(), EABL.null_mending()]
	f.flavor_text = "A fragment of the Eye itself, torn loose and given independent hunger. It amplifies its master's power and scatters void light across all who stand before the Eye."
	return f


static func create_thoughtform_knight(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Thoughtform Knight", lvl)
	f.health = EH.es(677, 770, 7, 10, lvl, 14); f.max_health = f.health
	f.mana = EH.es(14, 17, 1, 2, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(153, 172, 3, 5, lvl, 14)
	f.physical_defense = EH.es(64, 75, 3, 5, lvl, 14)
	f.magic_attack = EH.es(26, 33, 1, 2, lvl, 14)
	f.magic_defense = EH.es(52, 61, 2, 4, lvl, 14)
	f.speed = EH.es(49, 57, 2, 4, lvl, 14)
	f.crit_chance = 17; f.crit_damage = 4; f.dodge_chance = 10
	f.abilities = [EABL.memory_blade(), EABL.ironclad_will()]
	f.flavor_text = "A warrior conjured from stolen memories of great knights. It fights with borrowed valor and an unshakable conviction that it is real."
	return f


# =============================================================================
# The Eye (level 15 bosses)
# =============================================================================

static func create_the_iris(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "The Iris", lvl)
	f.health = EH.es(738, 842, 8, 11, lvl, 15); f.max_health = f.health
	f.mana = EH.es(30, 35, 2, 3, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(36, 45, 1, 3, lvl, 15)
	f.physical_defense = EH.es(61, 72, 3, 5, lvl, 15)
	f.magic_attack = EH.es(162, 181, 4, 7, lvl, 15)
	f.magic_defense = EH.es(77, 87, 3, 5, lvl, 15)
	f.speed = EH.es(57, 63, 1, 3, lvl, 15)
	f.crit_chance = 20; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EABL.prismatic_blast(), EABL.refraction_beam(), EABL.crystalline_ward(), EABL.oppressive_gaze(), EABL.memory_erosion()]
	f.flavor_text = "The Eye's outer defense, a blazing lens of concentrated perception. Light bends and shatters around it in prismatic fury."
	return f


static func create_the_lidless_eye(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "The Lidless Eye", lvl)
	f.health = EH.es(1008, 1146, 9, 13, lvl, 15); f.max_health = f.health
	f.mana = EH.es(43, 49, 2, 3, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(188, 208, 5, 8, lvl, 15)
	f.physical_defense = EH.es(64, 76, 3, 5, lvl, 15)
	f.magic_attack = EH.es(62, 72, 1, 3, lvl, 15)
	f.magic_defense = EH.es(82, 96, 4, 6, lvl, 15)
	f.speed = EH.es(62, 68, 2, 3, lvl, 15)
	f.crit_chance = 22; f.crit_damage = 4; f.dodge_chance = 17
	f.abilities = [EABL.crushing_gaze(), EABL.desperate_lunge(), EABL.death_throes(), EABL.collapse(), EABL.last_tremor()]
	f.flavor_text = "The Eye of Oblivion, stripped bare by Sera's sacrifice. Its armor is gone, its reserves burned away. What remains is pure, desperate hunger. It has nothing left but the will to take everything with it."
	return f
