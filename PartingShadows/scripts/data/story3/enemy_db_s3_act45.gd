class_name EnemyDBS3Act45

## Story 3 Acts IV-V enemy factory. Cult members and the Threadmaster.
## T2 rebalance: stats scaled to match T2 player power levels.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const EAB := preload("res://scripts/data/story3/enemy_ability_db_s3.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# Acts IV-V: Cult members (Progression 14-17)
# Prog 14 (S3_CultUnderbelly): target 61%, 15 level-ups
# Prog 15 (S3_CultCatacombs): target 59%, 16 level-ups
# Prog 16 (S3_CultRitualChamber): target 56%, 17 level-ups
# Prog 17 (S3_DreamNexus): target 55%, 18 level-ups (final boss)
# =============================================================================

# Prog 14 -- mage acolyte (level 15)
static func create_cult_acolyte(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Cult Acolyte", lvl)
	f.health = EH.es(543, 616, 5, 8, lvl, 15); f.max_health = f.health
	f.mana = EH.es(38, 46, 1, 2, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(22, 26, 0, 2, lvl, 15)
	f.physical_defense = EH.es(38, 47, 2, 3, lvl, 15)
	f.magic_attack = EH.es(144, 158, 3, 5, lvl, 15)
	f.magic_defense = EH.es(47, 57, 2, 4, lvl, 15)
	f.speed = EH.es(37, 44, 2, 3, lvl, 15)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 25
	f.abilities = [EAB.thread_sear(), EAB.zealots_fervor()]
	f.flavor_text = "A junior member of the Thread cult, burning with fanatical devotion. Their searing thread-magic is crude but powerful, fueled by unshakable belief in the Threadmaster's vision."
	return f


# Prog 14 -- physical enforcer (level 15)
static func create_cult_enforcer(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Cult Enforcer", lvl)
	f.health = EH.es(664, 751, 6, 9, lvl, 15); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(128, 143, 3, 5, lvl, 15)
	f.physical_defense = EH.es(59, 67, 2, 4, lvl, 15)
	f.magic_attack = EH.es(20, 24, 0, 1, lvl, 15)
	f.magic_defense = EH.es(37, 45, 2, 3, lvl, 15)
	f.speed = EH.es(29, 35, 2, 3, lvl, 15)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.thread_laced_fist(), EAB.threaded_sinew()]
	f.flavor_text = "A heavily muscled enforcer whose body is laced with dream-threads that harden like steel beneath the skin. The cult sends them to silence anyone who asks too many questions."
	return f


# Prog 14 -- glass cannon hexer (level 15)
static func create_cult_hexer(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Cult Hexer", lvl)
	f.health = EH.es(478, 544, 4, 7, lvl, 15); f.max_health = f.health
	f.mana = EH.es(38, 46, 1, 2, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(19, 23, 0, 2, lvl, 15)
	f.physical_defense = EH.es(28, 36, 1, 3, lvl, 15)
	f.magic_attack = EH.es(150, 164, 3, 5, lvl, 15)
	f.magic_defense = EH.es(49, 59, 2, 4, lvl, 15)
	f.speed = EH.es(43, 49, 2, 3, lvl, 15)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 25
	f.abilities = [EAB.hex_bolt(), EAB.curse()]
	f.flavor_text = "A spellcaster who has traded sanity for power, channeling hexes drawn from the darkest layers of the dream. Their curses linger long after the battle ends."
	return f


# Prog 15 (CultCatacombs) only -- physical guard
static func create_thread_guard(n: String, lvl: int = 16) -> FighterData:
	var f := EH.base(n, "Thread Guard", lvl)
	f.health = EH.es(384, 440, 5, 8, lvl, 16); f.max_health = f.health
	f.mana = EH.es(42, 51, 1, 1, lvl, 16); f.max_mana = f.mana
	f.physical_attack = EH.es(155, 173, 4, 6, lvl, 16)
	f.physical_defense = EH.es(28, 36, 2, 3, lvl, 16)
	f.magic_attack = EH.es(20, 24, 0, 1, lvl, 16)
	f.magic_defense = EH.es(48, 56, 2, 4, lvl, 16)
	f.speed = EH.es(35, 41, 1, 2, lvl, 16)
	f.crit_chance = 22; f.crit_damage = 4; f.dodge_chance = 10
	f.abilities = [EAB.rending_weave(), EAB.thread_impale()]
	f.flavor_text = "A hulking enforcer who channels the Loom's power into single, devastating strikes. What it lacks in resilience it makes up for in the sheer ruin of each blow."
	return f


# Prog 15 -- MIXED life-draining hound (level 16)
static func create_dream_hound(n: String, lvl: int = 16) -> FighterData:
	var f := EH.base(n, "Dream Hound", lvl)
	f.health = EH.es(439, 498, 5, 8, lvl, 16); f.max_health = f.health
	f.mana = EH.es(30, 39, 1, 1, lvl, 16); f.max_mana = f.mana
	f.physical_attack = EH.es(106, 116, 2, 4, lvl, 16)
	f.magic_attack = EH.es(105, 115, 2, 4, lvl, 16)
	f.physical_defense = EH.es(50, 58, 2, 4, lvl, 16)
	f.magic_defense = EH.es(28, 35, 2, 3, lvl, 16)
	f.speed = EH.es(45, 51, 3, 4, lvl, 16)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.dream_siphon(), EAB.spectral_lunge()]
	f.flavor_text = "A sleek beast bred in the cult's dream kennels. It feeds on the boundary between waking and sleeping, draining life force with every bite."
	return f


# Prog 16 (CultRitualChamber) only -- physical guard (ritual chamber elite)
static func create_ritual_guardian(n: String, lvl: int = 16) -> FighterData:
	var f := EH.base(n, "Ritual Guardian", lvl)
	f.health = EH.es(528, 603, 6, 9, lvl, 16); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 16); f.max_mana = f.mana
	f.physical_attack = EH.es(124, 138, 3, 5, lvl, 16)
	f.physical_defense = EH.es(61, 70, 2, 4, lvl, 16)
	f.magic_attack = EH.es(17, 21, 0, 1, lvl, 16)
	f.magic_defense = EH.es(38, 47, 2, 3, lvl, 16)
	f.speed = EH.es(27, 33, 1, 2, lvl, 16)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.ritual_chant(), EAB.threaded_blade()]
	f.flavor_text = "A guardian stationed specifically to protect the ritual chamber during the Loom's most sacred ceremonies. It chants as it fights, reinforcing the ceremony's power with every blow it lands against those who would defile the rite."
	return f


# Prog 16 -- mage ritualist (level 17)
static func create_cult_ritualist(n: String, lvl: int = 17) -> FighterData:
	var f := EH.base(n, "Cult Ritualist", lvl)
	f.health = EH.es(458, 527, 5, 8, lvl, 17); f.max_health = f.health
	f.mana = EH.es(40, 48, 1, 2, lvl, 17); f.max_mana = f.mana
	f.physical_attack = EH.es(24, 28, 0, 2, lvl, 17)
	f.physical_defense = EH.es(44, 54, 2, 4, lvl, 17)
	f.magic_attack = EH.es(135, 150, 3, 6, lvl, 17)
	f.magic_defense = EH.es(56, 64, 2, 4, lvl, 17)
	f.speed = EH.es(48, 54, 2, 3, lvl, 17)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.ritual_chant(), EAB.ancient_rite(), EAB.blood_weaving()]
	f.flavor_text = "A senior cultist who leads the binding rituals at the heart of the Thread cult's operations. Their chants strengthen the weave and lash at any who would disrupt the ceremony."
	return f


# Prog 16 -- mage glass cannon (level 17)
static func create_high_weaver(n: String, lvl: int = 17) -> FighterData:
	var f := EH.base(n, "High Weaver", lvl)
	f.health = EH.es(406, 468, 5, 8, lvl, 17); f.max_health = f.health
	f.mana = EH.es(44, 50, 2, 3, lvl, 17); f.max_mana = f.mana
	f.physical_attack = EH.es(25, 29, 0, 2, lvl, 17)
	f.physical_defense = EH.es(38, 46, 2, 3, lvl, 17)
	f.magic_attack = EH.es(153, 170, 3, 6, lvl, 17)
	f.magic_defense = EH.es(54, 62, 2, 4, lvl, 17)
	f.speed = EH.es(40, 46, 2, 3, lvl, 17)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 20
	f.abilities = [EAB.loom_blast(), EAB.unweave()]
	f.flavor_text = "One of the Threadmaster's inner circle, a master of the loom's destructive potential. They can unweave the protections of their enemies with a gesture and blast them with raw dream-force."
	return f


# =============================================================================
# Physical attacker additions: high-mDef cult/weaving enemies (T2 rework pass)
# =============================================================================

# Prog 14 -- DreadTailor: cult seamstress with dream-shears (level 15)
# High pAtk + very high mDef, magic passes through the blades
static func create_dread_tailor(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "DreadTailor", lvl)
	f.health = EH.es(460, 530, 5, 8, lvl, 15); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(114, 127, 3, 5, lvl, 15)
	f.physical_defense = EH.es(31, 39, 1, 3, lvl, 15)
	f.magic_attack = EH.es(20, 24, 0, 1, lvl, 15)
	f.magic_defense = EH.es(51, 59, 2, 3, lvl, 15)
	f.speed = EH.es(38, 44, 2, 3, lvl, 15)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.shear(), EAB.snip_away()]
	f.flavor_text = "A cultist who gave up her name and replaced it with a title. She fights with oversized dream-shears, each blade honed at the intersection of cloth and nightmare. Magic slides off the enchanted steel without leaving a mark."
	return f


# Prog 15 -- NeedleWraith: construct of animated bone-needles (level 16)
# High pAtk + high mDef, moderate HP, fragile
static func create_needle_wraith(n: String, lvl: int = 16) -> FighterData:
	var f := EH.base(n, "NeedleWraith", lvl)
	f.health = EH.es(438, 505, 5, 8, lvl, 16); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 16); f.max_mana = f.mana
	f.physical_attack = EH.es(126, 141, 3, 5, lvl, 16)
	f.physical_defense = EH.es(37, 45, 2, 3, lvl, 16)
	f.magic_attack = EH.es(17, 21, 0, 1, lvl, 16)
	f.magic_defense = EH.es(59, 69, 2, 4, lvl, 16)
	f.speed = EH.es(36, 42, 2, 3, lvl, 16)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.pin_barrage(), EAB.puncture()]
	f.flavor_text = "A construct assembled from the bones of failed cult initiates, each shard sharpened to a point and animated by loom-thread. Every strike is a dozen tiny stabs. Magic passes between the gaps in its lattice form."
	return f


# Prog 16 -- LoomCrusher: massive compacted-thread construct (level 17)
# Very high HP + pAtk + mDef, very slow, magic passes through the weave
static func create_loom_crusher(n: String, lvl: int = 17) -> FighterData:
	var f := EH.base(n, "LoomCrusher", lvl)
	f.health = EH.es(627, 722, 7, 10, lvl, 17); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 17); f.max_mana = f.mana
	f.physical_attack = EH.es(136, 152, 4, 6, lvl, 17)
	f.physical_defense = EH.es(47, 55, 2, 4, lvl, 17)
	f.magic_attack = EH.es(23, 27, 0, 1, lvl, 17)
	f.magic_defense = EH.es(75, 86, 3, 5, lvl, 17)
	f.speed = EH.es(24, 30, 1, 2, lvl, 17)
	f.crit_chance = 10; f.crit_damage = 4; f.dodge_chance = 10
	f.abilities = [EAB.thread_crush(), EAB.weave_brace()]
	f.flavor_text = "An enormous dream-construct whose body is formed from thousands of threads compressed so tightly they became solid matter. Magic passes through the weave harmlessly. It moves with ponderous, inevitable force."
	return f


# Prog 15 -- magical DoT specialist (level 16)
static func create_thread_stitcher(n: String, lvl: int = 16) -> FighterData:
	var f := EH.base(n, "Thread Stitcher", lvl)
	f.health = EH.es(416, 478, 5, 8, lvl, 16); f.max_health = f.health
	f.mana = EH.es(40, 50, 1, 2, lvl, 16); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 25, 0, 2, lvl, 16)
	f.physical_defense = EH.es(45, 52, 2, 3, lvl, 16)
	f.magic_attack = EH.es(104, 117, 3, 5, lvl, 16)
	f.magic_defense = EH.es(52, 60, 2, 4, lvl, 16)
	f.speed = EH.es(43, 49, 2, 3, lvl, 16)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.thread_mend(), EAB.lacerating_thread()]
	f.flavor_text = "A cult mender who stitches torn dream-threads back together. In battle, those same mending skills sustain wounded allies — or lash out at those who threaten the weave."
	return f


# Prog 17 boss minion -- fast magic DPS (level 18)
static func create_shadow_fragment(n: String, lvl: int = 18) -> FighterData:
	var f := EH.base(n, "Shadow Fragment", lvl)
	f.health = EH.es(374, 431, 5, 8, lvl, 18); f.max_health = f.health
	f.mana = EH.es(36, 44, 1, 2, lvl, 18); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 25, 0, 2, lvl, 18)
	f.physical_defense = EH.es(31, 39, 2, 3, lvl, 18)
	f.magic_attack = EH.es(136, 149, 3, 6, lvl, 18)
	f.magic_defense = EH.es(51, 60, 2, 4, lvl, 18)
	f.speed = EH.es(39, 45, 3, 4, lvl, 18)
	f.crit_chance = 25; f.crit_damage = 3; f.dodge_chance = 30
	f.abilities = [EAB.shadow_lash(), EAB.consume_light()]
	f.flavor_text = "A splinter of the Threadmaster's own shadow, given independent will. It devours light and hope in equal measure, weakening enemies before the final confrontation."
	return f


# Prog 17 boss -- The Threadmaster (level 18)
static func create_the_threadmaster(n: String, lvl: int = 18) -> FighterData:
	var f := EH.base(n, "The Threadmaster", lvl)
	f.health = EH.es(1441, 1628, 16, 25, lvl, 18); f.max_health = f.health
	f.mana = EH.es(50, 60, 2, 3, lvl, 18); f.max_mana = f.mana
	f.physical_attack = EH.es(127, 140, 4, 6, lvl, 18)
	f.physical_defense = EH.es(53, 61, 2, 4, lvl, 18)
	f.magic_attack = EH.es(133, 148, 3, 5, lvl, 18)
	f.magic_defense = EH.es(55, 63, 2, 4, lvl, 18)
	f.speed = EH.es(46, 52, 3, 4, lvl, 18)
	f.crit_chance = 25; f.crit_damage = 4; f.dodge_chance = 25
	f.abilities = [EAB.thread_lash(), EAB.loom_crush(), EAB.sever(), EAB.thread_bind(), EAB.puppets_drain()]
	f.flavor_text = "The architect of the Woven Night, a figure who has spent a lifetime learning to reshape reality through the fabric of dreams. To face them is to challenge the dreaming world itself."
	return f
