class_name EnemyDBS3PathC

## Story 3 Path C enemy factory. Deep dream entities, dream-projected cult,
## and the Ancient Threadmaster.
## T2 rebalance: stats scaled to match T2 player power levels.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const EAB := preload("res://scripts/data/story3/enemy_ability_db_s3_pathc.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# Prog 14: Deep dream entities (S3_C_DreamDescent)
# Target 61%, 15 level-ups
# =============================================================================

static func create_abyssal_dreamer(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Abyssal Dreamer", lvl)
	f.health = EH.es(409, 463, 5, 8, lvl, 15); f.max_health = f.health
	f.mana = EH.es(38, 46, 1, 2, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(20, 24, 0, 2, lvl, 15)
	f.physical_defense = EH.es(28, 36, 2, 3, lvl, 15)
	f.magic_attack = EH.es(137, 148, 3, 5, lvl, 15)
	f.magic_defense = EH.es(46, 53, 2, 4, lvl, 15)
	f.speed = EH.es(44, 50, 2, 3, lvl, 15)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.void_pulse(), EAB.deep_slumber()]
	f.flavor_text = "A figure that drifts through the deepest layers of the dream, where light never reaches. Its void pulses drag victims into a slumber from which few return."
	return f


static func create_thread_devourer(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Thread Devourer", lvl)
	f.health = EH.es(430, 489, 5, 8, lvl, 15); f.max_health = f.health
	f.mana = EH.es(34, 40, 2, 3, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(110, 121, 2, 4, lvl, 15)
	f.physical_defense = EH.es(39, 46, 2, 3, lvl, 15)
	f.magic_attack = EH.es(114, 125, 2, 4, lvl, 15)
	f.magic_defense = EH.es(35, 41, 2, 3, lvl, 15)
	f.speed = EH.es(43, 49, 2, 3, lvl, 15)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.thread_bite(), EAB.unravel_ward()]
	f.flavor_text = "A ravenous creature that feeds on dream-threads themselves, growing stronger with each strand it consumes. It tears apart protective wards with savage hunger."
	return f


static func create_slumbering_colossus(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Slumbering Colossus", lvl)
	f.health = EH.es(526, 592, 6, 9, lvl, 15); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(115, 127, 3, 5, lvl, 15)
	f.physical_defense = EH.es(57, 65, 2, 4, lvl, 15)
	f.magic_attack = EH.es(18, 22, 0, 1, lvl, 15)
	f.magic_defense = EH.es(35, 43, 2, 3, lvl, 15)
	f.speed = EH.es(28, 33, 1, 2, lvl, 15)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.crushing_dream(), EAB.ancient_yawn()]
	f.flavor_text = "An ancient titan that has slumbered in the dream's foundations since before the cult existed. When roused, its crushing weight and tremendous yawns send waves of exhaustion through all who face it."
	return f


# =============================================================================
# Prog 15: Dream-projected cult members (S3_C_CultInterception)
# Target 59%, 16 level-ups
# =============================================================================

static func create_dream_priest(n: String, lvl: int = 16) -> FighterData:
	var f := EH.base(n, "Dream Priest", lvl)
	f.health = EH.es(448, 515, 5, 8, lvl, 16); f.max_health = f.health
	f.mana = EH.es(44, 54, 1, 2, lvl, 16); f.max_mana = f.mana
	f.physical_attack = EH.es(18, 22, 0, 2, lvl, 16)
	f.physical_defense = EH.es(32, 40, 2, 3, lvl, 16)
	f.magic_attack = EH.es(102, 115, 3, 5, lvl, 16)
	f.magic_defense = EH.es(62, 72, 2, 4, lvl, 16)
	f.speed = EH.es(54, 60, 2, 3, lvl, 16)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.dream_suture(), EAB.condemning_light()]
	f.flavor_text = "A cult priest who projects their consciousness into the dream to intercept intruders. Their sacred sutures mend wounded allies while condemning light punishes the faithless."
	return f


static func create_astral_enforcer(n: String, lvl: int = 16) -> FighterData:
	var f := EH.base(n, "Astral Enforcer", lvl)
	f.health = EH.es(480, 552, 6, 9, lvl, 16); f.max_health = f.health
	f.mana = EH.es(45, 54, 1, 1, lvl, 16); f.max_mana = f.mana
	f.physical_attack = EH.es(143, 159, 3, 6, lvl, 16)
	f.physical_defense = EH.es(32, 40, 2, 3, lvl, 16)
	f.magic_attack = EH.es(16, 20, 0, 1, lvl, 16)
	f.magic_defense = EH.es(28, 36, 2, 3, lvl, 16)
	f.speed = EH.es(37, 43, 1, 2, lvl, 16)
	f.crit_chance = 22; f.crit_damage = 4; f.dodge_chance = 10
	f.abilities = [EAB.astral_cleave(), EAB.star_fracture()]
	f.flavor_text = "A hulking warrior whose astral form hits like a collapsing star. Slow and poorly armored, but each strike lands with devastating force."
	return f


static func create_oneiric_hexer(n: String, lvl: int = 16) -> FighterData:
	var f := EH.base(n, "Oneiric Hexer", lvl)
	f.health = EH.es(422, 480, 5, 8, lvl, 16); f.max_health = f.health
	f.mana = EH.es(38, 46, 1, 2, lvl, 16); f.max_mana = f.mana
	f.physical_attack = EH.es(18, 22, 0, 2, lvl, 16)
	f.physical_defense = EH.es(32, 40, 2, 3, lvl, 16)
	f.magic_attack = EH.es(134, 148, 3, 6, lvl, 16)
	f.magic_defense = EH.es(50, 59, 2, 4, lvl, 16)
	f.speed = EH.es(48, 54, 2, 3, lvl, 16)
	f.crit_chance = 20; f.crit_damage = 3; f.dodge_chance = 20
	f.abilities = [EAB.dream_bolt(), EAB.nightmare_hex()]
	f.flavor_text = "A hexer who draws power from the boundary between dreams and nightmares. Their bolts carry the sting of bad dreams, and their hexes twist perception into waking terror."
	return f


# Prog 15 -- physical tank with life steal (level 16)
static func create_oneiric_guardian(n: String, lvl: int = 16) -> FighterData:
	var f := EH.base(n, "Oneiric Guardian", lvl)
	f.health = EH.es(576, 659, 7, 10, lvl, 16); f.max_health = f.health
	f.mana = EH.es(30, 39, 1, 1, lvl, 16); f.max_mana = f.mana
	f.physical_attack = EH.es(85, 95, 2, 4, lvl, 16)
	f.physical_defense = EH.es(68, 78, 2, 4, lvl, 16)
	f.magic_attack = EH.es(16, 20, 0, 1, lvl, 16)
	f.magic_defense = EH.es(30, 36, 2, 3, lvl, 16)
	f.speed = EH.es(35, 41, 2, 3, lvl, 16)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.warden_strike(), EAB.dream_siphon()]
	f.flavor_text = "A hulking guardian conjured from the dream by a cult enforcer's will. Its stone-like hide shrugs off blades, though magic cuts deep. It sustains itself by draining the dream-essence of those it strikes."
	return f


# =============================================================================
# Prog 16: Threadmaster's personal guardians (S3_C_ThreadmasterLair)
# Target 56%, 17 level-ups
# =============================================================================

static func create_memory_eater(n: String, lvl: int = 17) -> FighterData:
	var f := EH.base(n, "Memory Eater", lvl)
	f.health = EH.es(456, 525, 5, 8, lvl, 17); f.max_health = f.health
	f.mana = EH.es(40, 48, 1, 2, lvl, 17); f.max_mana = f.mana
	f.physical_attack = EH.es(22, 26, 0, 2, lvl, 17)
	f.physical_defense = EH.es(37, 45, 2, 4, lvl, 17)
	f.magic_attack = EH.es(138, 152, 3, 6, lvl, 17)
	f.magic_defense = EH.es(58, 66, 2, 4, lvl, 17)
	f.speed = EH.es(41, 47, 2, 3, lvl, 17)
	f.crit_chance = 20; f.crit_damage = 3; f.dodge_chance = 25
	f.abilities = [EAB.devour_memory(), EAB.amnesia_fog()]
	f.flavor_text = "A predator that feeds on memories, leaving its victims hollow and disoriented. It breathes a fog of amnesia that strips away skills, names, and the will to resist."
	return f


static func create_nightmare_sentinel(n: String, lvl: int = 17) -> FighterData:
	var f := EH.base(n, "Nightmare Sentinel", lvl)
	f.health = EH.es(539, 618, 6, 9, lvl, 17); f.max_health = f.health
	f.mana = EH.es(33, 42, 1, 2, lvl, 17); f.max_mana = f.mana
	f.physical_attack = EH.es(130, 144, 3, 5, lvl, 17)
	f.physical_defense = EH.es(66, 74, 2, 4, lvl, 17)
	f.magic_attack = EH.es(20, 24, 0, 1, lvl, 17)
	f.magic_defense = EH.es(41, 50, 2, 3, lvl, 17)
	f.speed = EH.es(34, 40, 2, 3, lvl, 17)
	f.crit_chance = 25; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.nightmare_blade(), EAB.terror_ward()]
	f.flavor_text = "An armored sentinel forged from concentrated nightmare, standing guard at the Threadmaster's threshold. Its blade is edged with terror, and its ward repels all but the most resolute attackers."
	return f


static func create_anchor_chain(n: String, lvl: int = 17) -> FighterData:
	var f := EH.base(n, "Anchor Chain", lvl)
	f.health = EH.es(502, 576, 6, 9, lvl, 17); f.max_health = f.health
	f.mana = EH.es(34, 42, 2, 3, lvl, 17); f.max_mana = f.mana
	f.physical_attack = EH.es(111, 123, 3, 5, lvl, 17)
	f.physical_defense = EH.es(59, 67, 2, 4, lvl, 17)
	f.magic_attack = EH.es(126, 139, 3, 5, lvl, 17)
	f.magic_defense = EH.es(59, 67, 2, 4, lvl, 17)
	f.speed = EH.es(31, 37, 2, 3, lvl, 17)
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EAB.binding_pull(), EAB.iron_link()]
	f.flavor_text = "A massive chain of dream-forged iron that binds the Threadmaster's lair to the waking world. Each link hums with purpose, pulling intruders into its coils and refusing to let go."
	return f


# =============================================================================
# Prog 17: The Ancient Threadmaster and its servants (S3_C_DreamNexus)
# Target 55%, 18 level-ups (final boss)
# =============================================================================

static func create_ancient_threadmaster(n: String, lvl: int = 18) -> FighterData:
	var f := EH.base(n, "The Ancient Threadmaster", lvl)
	f.health = EH.es(1404, 1584, 16, 24, lvl, 18); f.max_health = f.health
	f.mana = EH.es(50, 60, 2, 3, lvl, 18); f.max_mana = f.mana
	f.physical_attack = EH.es(139, 154, 3, 5, lvl, 18)
	f.physical_defense = EH.es(53, 61, 2, 4, lvl, 18)
	f.magic_attack = EH.es(127, 140, 4, 6, lvl, 18)
	f.magic_defense = EH.es(55, 63, 2, 4, lvl, 18)
	f.speed = EH.es(44, 50, 3, 4, lvl, 18)
	f.crit_chance = 22; f.crit_damage = 4; f.dodge_chance = 22
	f.abilities = [EAB.primordial_weave(), EAB.reality_tear(), EAB.ancient_lash(), EAB.forgotten_curse(), EAB.ageless_hunger()]
	f.flavor_text = "The original weaver, ancient beyond reckoning, who first discovered how to shape reality through dreams. Their power predates the cult itself, and their dominion over the loom is absolute."
	return f


static func create_dream_shackle(n: String, lvl: int = 18) -> FighterData:
	var f := EH.base(n, "Dream Shackle", lvl)
	f.health = EH.es(421, 483, 6, 9, lvl, 18); f.max_health = f.health
	f.mana = EH.es(36, 44, 1, 2, lvl, 18); f.max_mana = f.mana
	f.physical_attack = EH.es(18, 22, 0, 2, lvl, 18)
	f.physical_defense = EH.es(32, 40, 2, 3, lvl, 18)
	f.magic_attack = EH.es(131, 144, 3, 6, lvl, 18)
	f.magic_defense = EH.es(50, 59, 2, 4, lvl, 18)
	f.speed = EH.es(41, 47, 3, 4, lvl, 18)
	f.crit_chance = 25; f.crit_damage = 3; f.dodge_chance = 25
	f.abilities = [EAB.binding_lash(), EAB.reclaim()]
	f.flavor_text = "A living restraint conjured by the Ancient Threadmaster, designed to bind intruders in place. It lashes out with threads that reclaim stolen dream-energy and return it to the loom."
	return f


static func create_loom_heart(n: String, lvl: int = 18) -> FighterData:
	var f := EH.base(n, "Loom Heart", lvl)
	f.health = EH.es(496, 570, 6, 9, lvl, 18); f.max_health = f.health
	f.mana = EH.es(40, 48, 2, 3, lvl, 18); f.max_mana = f.mana
	f.physical_attack = EH.es(18, 22, 0, 2, lvl, 18)
	f.physical_defense = EH.es(48, 57, 2, 4, lvl, 18)
	f.magic_attack = EH.es(117, 130, 3, 5, lvl, 18)
	f.magic_defense = EH.es(53, 61, 2, 4, lvl, 18)
	f.speed = EH.es(32, 38, 2, 3, lvl, 18)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.pulse_of_the_loom(), EAB.loom_storm()]
	f.flavor_text = "The beating heart of the great loom itself, exposed and pulsing with raw dream-energy. Destroying it would sever the Threadmaster's connection to the woven night forever."
	return f
