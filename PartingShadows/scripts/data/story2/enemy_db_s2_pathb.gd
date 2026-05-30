class_name EnemyDBS2PathB

## Story 2 Path B enemy factory: Save Sera route (archive through Unblinking Eye).

const FighterData := preload("res://scripts/data/fighter_data.gd")
const EAB := preload("res://scripts/data/story2/enemy_ability_db_s2_pathb.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# Archive Awakening (Prog 13B) -- Sera fight + archive defender
# =============================================================================

static func create_fractured_scholar(n: String, lvl: int = 13) -> FighterData:
	var f := EH.base(n, "Fractured Scholar", lvl)
	f.health = EH.es(598, 678, 4, 6, lvl, 13); f.max_health = f.health
	f.mana = EH.es(34, 40, 2, 4, lvl, 13); f.max_mana = f.mana
	f.physical_attack = EH.es(105, 116, 2, 4, lvl, 13)
	f.physical_defense = EH.es(43, 52, 2, 3, lvl, 13)
	f.magic_attack = EH.es(90, 102, 2, 4, lvl, 13)
	f.magic_defense = EH.es(47, 55, 2, 3, lvl, 13)
	f.speed = EH.es(51, 57, 2, 3, lvl, 13)
	f.crit_chance = 20; f.crit_damage = 4; f.dodge_chance = 20
	f.abilities = [EAB.scholar_strike(), EAB.forgotten_knowledge(), EAB.archive_ward()]
	f.flavor_text = "Sera, driven by instincts she cannot name. She guards the archive's deepest secrets with desperate ferocity, unaware of why they matter."
	return f


static func create_archive_sentinel(n: String, lvl: int = 13) -> FighterData:
	var f := EH.base(n, "Archive Sentinel", lvl)
	f.health = EH.es(546, 617, 4, 6, lvl, 13); f.max_health = f.health
	f.mana = EH.es(30, 39, 3, 4, lvl, 13); f.max_mana = f.mana
	f.physical_attack = EH.es(106, 118, 3, 5, lvl, 13)
	f.physical_defense = EH.es(53, 62, 2, 4, lvl, 13)
	f.magic_attack = EH.es(23, 27, 0, 2, lvl, 13)
	f.magic_defense = EH.es(46, 54, 2, 3, lvl, 13)
	f.speed = EH.es(42, 49, 1, 3, lvl, 13)
	f.crit_chance = 10; f.crit_damage = 4; f.dodge_chance = 10
	f.abilities = [EAB.tome_crush(), EAB.index_lock()]
	f.flavor_text = "A massive automaton built from bound volumes and filing cabinets. It enforces the archive's silence with mechanical precision."
	return f


# =============================================================================
# Lighthouse Core (Prog 14B) -- phys tank / mixed / magic
# =============================================================================

static func create_pipeline_warden(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Pipeline Warden", lvl)
	f.health = EH.es(672, 764, 4, 6, lvl, 14); f.max_health = f.health
	f.mana = EH.es(36, 45, 3, 4, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(124, 137, 3, 5, lvl, 14)
	f.physical_defense = EH.es(66, 77, 3, 4, lvl, 14)
	f.magic_attack = EH.es(22, 27, 0, 2, lvl, 14)
	f.magic_defense = EH.es(42, 52, 2, 3, lvl, 14)
	f.speed = EH.es(39, 45, 1, 3, lvl, 14)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.pipe_smash(), EAB.pressure_seal(), EAB.steam_burst()]
	f.flavor_text = "A hulking construct of iron pipes and crystalline conduits. It patrols the lighthouse's deep machinery with tireless vigilance."
	return f


static func create_maintenance_drone(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Maintenance Drone", lvl)
	f.health = EH.es(436, 498, 4, 6, lvl, 14); f.max_health = f.health
	f.mana = EH.es(36, 44, 2, 4, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(80, 88, 2, 4, lvl, 14)
	f.physical_defense = EH.es(35, 44, 2, 3, lvl, 14)
	f.magic_attack = EH.es(83, 91, 2, 4, lvl, 14)
	f.magic_defense = EH.es(41, 50, 2, 3, lvl, 14)
	f.speed = EH.es(48, 55, 2, 3, lvl, 14)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 20
	f.abilities = [EAB.calibration_beam(), EAB.repair_pulse()]
	f.flavor_text = "A floating construct designed to maintain the Eye's extraction machinery. Its repair beams are equally effective as weapons."
	return f


static func create_resonance_node(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Resonance Node", lvl)
	f.health = EH.es(373, 426, 3, 6, lvl, 14); f.max_health = f.health
	f.mana = EH.es(44, 52, 4, 6, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(22, 27, 0, 2, lvl, 14)
	f.physical_defense = EH.es(33, 41, 2, 3, lvl, 14)
	f.magic_attack = EH.es(117, 129, 3, 5, lvl, 14)
	f.magic_defense = EH.es(53, 63, 2, 4, lvl, 14)
	f.speed = EH.es(44, 51, 2, 3, lvl, 14)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.resonance_bolt(), EAB.harmonic_disrupt()]
	f.flavor_text = "A crystal amplifier that channels the lighthouse's resonance frequencies. It hums with barely contained power."
	return f


# =============================================================================
# Resonance Chamber (Prog 15B) -- phys / magic / mixed debuffer
# =============================================================================

static func create_eyes_fist(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Eye's Fist", lvl)
	f.health = EH.es(647, 734, 5, 7, lvl, 14); f.max_health = f.health
	f.mana = EH.es(33, 42, 3, 4, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(128, 145, 3, 5, lvl, 14)
	f.physical_defense = EH.es(65, 76, 3, 5, lvl, 14)
	f.magic_attack = EH.es(24, 30, 1, 2, lvl, 14)
	f.magic_defense = EH.es(52, 61, 2, 4, lvl, 14)
	f.speed = EH.es(42, 49, 1, 3, lvl, 14)
	f.crit_chance = 10; f.crit_damage = 4; f.dodge_chance = 10
	f.abilities = [EAB.crushing_will(), EAB.attention_lock()]
	f.flavor_text = "The Eye's physical enforcement, a construct of compressed perception given crushing weight. It draws all aggression toward itself."
	return f


static func create_null_sentinel(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Null Sentinel", lvl)
	f.health = EH.es(479, 546, 4, 6, lvl, 14); f.max_health = f.health
	f.mana = EH.es(42, 50, 4, 6, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(24, 30, 1, 2, lvl, 14)
	f.physical_defense = EH.es(34, 42, 2, 3, lvl, 14)
	f.magic_attack = EH.es(116, 130, 3, 5, lvl, 14)
	f.magic_defense = EH.es(62, 72, 3, 4, lvl, 14)
	f.speed = EH.es(49, 57, 2, 3, lvl, 14)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.erasure_beam(), EAB.void_shroud()]
	f.flavor_text = "A sentinel woven from pure negation. It erases incoming attacks with the same ease it erases minds."
	return f


static func create_overload_spark(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Overload Spark", lvl)
	f.health = EH.es(394, 447, 3, 6, lvl, 14); f.max_health = f.health
	f.mana = EH.es(38, 46, 2, 4, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(66, 73, 2, 4, lvl, 14)
	f.physical_defense = EH.es(32, 41, 2, 3, lvl, 14)
	f.magic_attack = EH.es(66, 74, 2, 4, lvl, 14)
	f.magic_defense = EH.es(40, 48, 2, 3, lvl, 14)
	f.speed = EH.es(52, 59, 2, 4, lvl, 14)
	f.crit_chance = 25; f.crit_damage = 3; f.dodge_chance = 25
	f.abilities = [EAB.feedback_arc(), EAB.system_shock()]
	f.flavor_text = "A crackling entity born from the resonance overload. It arcs between targets, leaving weakened defenses in its wake."
	return f


# =============================================================================
# Memory Flood (Prog 16B) -- magic AoE / phys / mixed
# =============================================================================

static func create_memory_torrent(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Memory Torrent", lvl)
	f.health = EH.es(358, 408, 4, 6, lvl, 15); f.max_health = f.health
	f.mana = EH.es(48, 56, 4, 6, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(26, 32, 1, 2, lvl, 15)
	f.physical_defense = EH.es(33, 41, 2, 3, lvl, 15)
	f.magic_attack = EH.es(160, 176, 4, 6, lvl, 15)
	f.magic_defense = EH.es(55, 64, 3, 4, lvl, 15)
	f.speed = EH.es(51, 58, 2, 3, lvl, 15)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 20
	f.abilities = [EAB.torrent_blast(), EAB.overwhelming_recall()]
	f.flavor_text = "A raging current of unleashed memories, each one a stolen life surging with anguish and confusion."
	return f


static func create_unleashed_recollection(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Unleashed Recollection", lvl)
	f.health = EH.es(378, 431, 4, 6, lvl, 15); f.max_health = f.health
	f.mana = EH.es(36, 45, 3, 4, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(145, 158, 3, 5, lvl, 15)
	f.physical_defense = EH.es(46, 55, 2, 4, lvl, 15)
	f.magic_attack = EH.es(26, 32, 1, 2, lvl, 15)
	f.magic_defense = EH.es(40, 47, 2, 3, lvl, 15)
	f.speed = EH.es(49, 55, 2, 3, lvl, 15)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.memory_fist(), EAB.shatter_recall()]
	f.flavor_text = "A solid mass of crystallized memory broken free from storage. It crashes through anything in its path with mindless fury."
	return f


static func create_rage_fragment(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Rage Fragment", lvl)
	f.health = EH.es(323, 369, 4, 6, lvl, 15); f.max_health = f.health
	f.mana = EH.es(34, 40, 2, 4, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(118, 128, 3, 5, lvl, 15)
	f.physical_defense = EH.es(31, 39, 2, 3, lvl, 15)
	f.magic_attack = EH.es(120, 131, 3, 5, lvl, 15)
	f.magic_defense = EH.es(35, 43, 2, 3, lvl, 15)
	f.speed = EH.es(57, 63, 3, 4, lvl, 15)
	f.crit_chance = 25; f.crit_damage = 3; f.dodge_chance = 25
	f.abilities = [EAB.fury_spike(), EAB.frenzied_pulse()]
	f.flavor_text = "A shard of pure anger torn from the Eye's psyche. It lashes out at everything, unable to distinguish friend from foe."
	return f


# =============================================================================
# The Unblinking Eye (Prog 17B, solo boss -- stronger than Lidless Eye)
# =============================================================================

static func create_the_unblinking_eye(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "The Unblinking Eye", lvl)
	f.health = EH.es(1060, 1204, 9, 12, lvl, 15); f.max_health = f.health
	f.mana = EH.es(92, 106, 4, 6, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(36, 44, 1, 3, lvl, 15)
	f.physical_defense = EH.es(56, 66, 3, 5, lvl, 15)
	f.magic_attack = EH.es(162, 180, 5, 8, lvl, 15)
	f.magic_defense = EH.es(70, 79, 4, 6, lvl, 15)
	f.speed = EH.es(68, 74, 2, 4, lvl, 15)
	f.crit_chance = 22; f.crit_damage = 4; f.dodge_chance = 17
	f.abilities = [EAB.gaze_of_annihilation(), EAB.memory_maelstrom(), EAB.ancient_fury(), EAB.devour_identity(), EAB.unblinking_focus()]
	f.flavor_text = "The Eye of Oblivion at full, terrible power. Not weakened by sacrifice, not diminished by poison. It sees everything and forgets nothing."
	return f


# =============================================================================
# Perception Tendril (Prog 17B, buffer/healer support for Unblinking Eye)
# =============================================================================

static func create_perception_tendril(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Perception Tendril", lvl)
	f.health = EH.es(200, 232, 2, 3, lvl, 15); f.max_health = f.health
	f.mana = EH.es(34, 40, 2, 4, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(20, 26, 1, 2, lvl, 15)
	f.physical_defense = EH.es(18, 24, 1, 2, lvl, 15)
	f.magic_attack = EH.es(57, 65, 2, 3, lvl, 15)
	f.magic_defense = EH.es(35, 42, 2, 3, lvl, 15)
	f.speed = EH.es(59, 66, 2, 4, lvl, 15)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 8
	f.abilities = [EAB.tendril_ward(), EAB.tendril_lash(), EAB.perceptive_mending()]
	f.flavor_text = "A tendril of the Eye's vast awareness, given form. It mends what the party tears away and shields its master."
	return f


# =============================================================================
# Void Lens (Prog 17B, debuffer/offense support for Unblinking Eye)
# =============================================================================

static func create_void_lens(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Void Lens", lvl)
	f.health = EH.es(184, 216, 2, 3, lvl, 15); f.max_health = f.health
	f.mana = EH.es(34, 40, 2, 4, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(22, 28, 1, 2, lvl, 15)
	f.physical_defense = EH.es(16, 22, 1, 2, lvl, 15)
	f.magic_attack = EH.es(63, 72, 2, 3, lvl, 15)
	f.magic_defense = EH.es(32, 40, 2, 3, lvl, 15)
	f.speed = EH.es(64, 71, 3, 4, lvl, 15)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 8
	f.abilities = [EAB.refracted_gaze(), EAB.null_pulse(), EAB.void_shimmer()]
	f.flavor_text = "A lens of concentrated void light, broken free from the Eye's corona. It bends perception and strips away the will to resist."
	return f
