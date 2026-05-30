class_name EnemyDBS3Act3

## Story 3 Act III enemy factory. Cult dream guardians.
## T2 rebalance: tuned via sim interpolation for T2 class power levels.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const EAB := preload("res://scripts/data/story3/enemy_ability_db_s3.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# Act III: Cult dream guardians (Progression 11-13)
# Prog 11 (S3_LucidDream): target 67%, 12 level-ups
# Prog 12 (S3_DreamTemple/DreamVoid): target 65%, 13 level-ups
# Prog 13 (S3_DreamSanctum): target 63%, 14 level-ups (boss)
# =============================================================================

# Prog 11 (LucidDream) only -- mage phantom (fast magic DPS)
static func create_lucid_phantom(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Lucid Phantom", lvl)
	f.health = EH.es(355, 409, 5, 8, lvl, 12); f.max_health = f.health
	f.mana = EH.es(36, 44, 1, 2, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(18, 22, 0, 2, lvl, 12)
	f.physical_defense = EH.es(25, 33, 2, 3, lvl, 12)
	f.magic_attack = EH.es(106, 116, 3, 5, lvl, 12)
	f.magic_defense = EH.es(42, 50, 2, 3, lvl, 12)
	f.speed = EH.es(40, 46, 2, 3, lvl, 12)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EAB.mind_spike(), EAB.phase_shift()]
	f.flavor_text = "A phantom born from a dreamer who achieved lucidity but lost themselves in it. It wields focused thought like a weapon, phasing through attacks with terrifying ease."
	return f


# Prog 11 (LucidDream) only -- support healer (mage support)
static func create_thread_spinner(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Thread Spinner", lvl)
	f.health = EH.es(398, 458, 5, 8, lvl, 12); f.max_health = f.health
	f.mana = EH.es(38, 46, 1, 2, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(18, 22, 0, 2, lvl, 12)
	f.physical_defense = EH.es(35, 43, 2, 3, lvl, 12)
	f.magic_attack = EH.es(88, 101, 2, 4, lvl, 12)
	f.magic_defense = EH.es(43, 51, 2, 3, lvl, 12)
	f.speed = EH.es(39, 45, 2, 3, lvl, 12)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.woven_mend(), EAB.thread_snare()]
	f.flavor_text = "A cult artisan who repairs the dream's fabric even as intruders tear through it. Its threads can mend allies or bind foes with equal skill."
	return f


# Prog 12 DreamTemple only -- physical tank
static func create_loom_sentinel(n: String, lvl: int = 13) -> FighterData:
	var f := EH.base(n, "Loom Sentinel", lvl)
	f.health = EH.es(490, 560, 6, 9, lvl, 13); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 13); f.max_mana = f.mana
	f.physical_attack = EH.es(110, 121, 3, 5, lvl, 13)
	f.physical_defense = EH.es(54, 63, 2, 3, lvl, 13)
	f.magic_attack = EH.es(19, 23, 0, 1, lvl, 13)
	f.magic_defense = EH.es(33, 40, 2, 3, lvl, 13)
	f.speed = EH.es(22, 28, 1, 2, lvl, 13)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.loom_strike(), EAB.woven_armor()]
	f.flavor_text = "A towering automaton built around the skeleton of a great loom. Its strikes carry the weight of compacted dream-thread, and its woven armor turns aside all but the strongest blows."
	return f


# Prog 11 (LucidDream) only -- magic DPS (glass cannon caster)
static func create_cult_shade(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Cult Shade", lvl)
	f.health = EH.es(278, 321, 4, 7, lvl, 12); f.max_health = f.health
	f.mana = EH.es(36, 44, 1, 2, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(18, 22, 0, 2, lvl, 12)
	f.physical_defense = EH.es(23, 29, 1, 3, lvl, 12)
	f.magic_attack = EH.es(99, 109, 3, 5, lvl, 12)
	f.magic_defense = EH.es(38, 45, 2, 3, lvl, 12)
	f.speed = EH.es(40, 46, 2, 3, lvl, 12)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EAB.dark_thread(), EAB.unravel_mind()]
	f.flavor_text = "A hooded cultist who channels forbidden thread-magic through rituals of devotion. It unravels the minds of its enemies, leaving them confused and vulnerable."
	return f



# Prog 12 (DreamTemple) only -- hybrid fighter
static func create_dream_warden(n: String, lvl: int = 13) -> FighterData:
	var f := EH.base(n, "Dream Warden", lvl)
	f.health = EH.es(408, 468, 5, 8, lvl, 13); f.max_health = f.health
	f.mana = EH.es(34, 40, 1, 2, lvl, 13); f.max_mana = f.mana
	f.physical_attack = EH.es(99, 108, 2, 4, lvl, 13)
	f.physical_defense = EH.es(37, 44, 2, 3, lvl, 13)
	f.magic_attack = EH.es(103, 114, 2, 4, lvl, 13)
	f.magic_defense = EH.es(37, 44, 2, 3, lvl, 13)
	f.speed = EH.es(31, 37, 2, 3, lvl, 13)
	f.crit_chance = 20; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.ward_pulse(), EAB.binding_light()]
	f.flavor_text = "An imposing guardian who patrols the border between the waking world and the cult's dream domain. It fights with both blade and binding light to repel all trespassers."
	return f


# Prog 12 DreamTemple only -- magic DPS
static func create_thought_leech(n: String, lvl: int = 13) -> FighterData:
	var f := EH.base(n, "Thought Leech", lvl)
	f.health = EH.es(368, 423, 5, 8, lvl, 13); f.max_health = f.health
	f.mana = EH.es(36, 44, 1, 2, lvl, 13); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 25, 0, 2, lvl, 13)
	f.physical_defense = EH.es(25, 33, 1, 3, lvl, 13)
	f.magic_attack = EH.es(106, 116, 3, 5, lvl, 13)
	f.magic_defense = EH.es(44, 51, 2, 3, lvl, 13)
	f.speed = EH.es(30, 36, 2, 3, lvl, 13)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.psychic_siphon(), EAB.mind_fog()]
	f.flavor_text = "A parasitic entity that attaches to the psyche and drains thought and willpower. Its victims stumble in a fog of confusion, unable to think clearly or act decisively."
	return f


# Prog 12 DreamVoid only -- magic DPS (void caster)
# Buffed significantly to compensate for weakened shared enemies
static func create_void_spinner(n: String, lvl: int = 13) -> FighterData:
	var f := EH.base(n, "Void Spinner", lvl)
	f.health = EH.es(390, 448, 5, 8, lvl, 13); f.max_health = f.health
	f.mana = EH.es(38, 46, 1, 2, lvl, 13); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 25, 0, 2, lvl, 13)
	f.physical_defense = EH.es(29, 37, 2, 3, lvl, 13)
	f.magic_attack = EH.es(109, 121, 3, 5, lvl, 13)
	f.magic_defense = EH.es(48, 56, 2, 4, lvl, 13)
	f.speed = EH.es(42, 48, 2, 3, lvl, 13)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.void_thread(), EAB.nullify()]
	f.flavor_text = "A caster that draws power from the void between dreams, where nothing exists and all things unravel. Its threads nullify magic and dissolve protections on contact."
	return f


# =============================================================================
# Prog 12 (DreamVoid) unique enemies
# =============================================================================

# Prog 12 DreamVoid only -- fast magic DPS (void-infused phantom)
static func create_void_phantom(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Void Phantom", lvl)
	f.health = EH.es(350, 402, 5, 8, lvl, 12); f.max_health = f.health
	f.mana = EH.es(36, 44, 1, 2, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 25, 0, 2, lvl, 12)
	f.physical_defense = EH.es(28, 36, 2, 3, lvl, 12)
	f.magic_attack = EH.es(98, 107, 3, 5, lvl, 12)
	f.magic_defense = EH.es(39, 47, 2, 3, lvl, 12)
	f.speed = EH.es(38, 44, 2, 3, lvl, 12)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.void_siphon(), EAB.phase_shift()]
	f.flavor_text = "A phantom that has slipped into the void between dreams and returned changed. It drains vitality through rifts in the weave and phases through attacks with unsettling ease."
	return f


# Prog 12 DreamVoid only -- mage support (rift-repairing healer)
static func create_rift_mender(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Rift Mender", lvl)
	f.health = EH.es(393, 452, 5, 8, lvl, 12); f.max_health = f.health
	f.mana = EH.es(38, 46, 1, 2, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 25, 0, 2, lvl, 12)
	f.physical_defense = EH.es(35, 43, 2, 3, lvl, 12)
	f.magic_attack = EH.es(86, 99, 2, 4, lvl, 12)
	f.magic_defense = EH.es(43, 51, 2, 3, lvl, 12)
	f.speed = EH.es(35, 41, 2, 3, lvl, 12)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.woven_mend(), EAB.void_thread()]
	f.flavor_text = "A cult weaver stationed in the void to frantically repair the tears intruders leave behind. It stitches the fraying dream back together with threads drawn from the void itself."
	return f


# =============================================================================
# Prog 13 (DreamSanctum) unique enemies
# =============================================================================

# Prog 13 DreamSanctum only -- magic DPS (sanctum glass cannon)
static func create_sanctum_shade(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Sanctum Shade", lvl)
	f.health = EH.es(320, 368, 4, 7, lvl, 12); f.max_health = f.health
	f.mana = EH.es(36, 44, 1, 2, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(20, 24, 0, 2, lvl, 12)
	f.physical_defense = EH.es(23, 29, 1, 3, lvl, 12)
	f.magic_attack = EH.es(98, 107, 3, 5, lvl, 12)
	f.magic_defense = EH.es(38, 45, 2, 3, lvl, 12)
	f.speed = EH.es(36, 42, 2, 3, lvl, 12)
	f.crit_chance = 25; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EAB.loom_blast(), EAB.nullify()]
	f.flavor_text = "A shade bound to the sanctum's innermost chamber, woven into the loom's defenses since the cult's founding. It blasts intruders with raw loom-force and nullifies their protections before they can reach the core."
	return f


# Prog 13 DreamSanctum only -- hybrid fighter (loom-bound guardian)
static func create_loom_warden(n: String, lvl: int = 13) -> FighterData:
	var f := EH.base(n, "Loom Warden", lvl)
	f.health = EH.es(401, 460, 5, 8, lvl, 13); f.max_health = f.health
	f.mana = EH.es(34, 40, 1, 2, lvl, 13); f.max_mana = f.mana
	f.physical_attack = EH.es(102, 113, 2, 4, lvl, 13)
	f.physical_defense = EH.es(37, 44, 2, 3, lvl, 13)
	f.magic_attack = EH.es(101, 111, 2, 4, lvl, 13)
	f.magic_defense = EH.es(37, 44, 2, 3, lvl, 13)
	f.speed = EH.es(37, 43, 2, 3, lvl, 13)
	f.crit_chance = 20; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.loom_strike(), EAB.woven_armor()]
	f.flavor_text = "A guardian woven directly into the sanctum's core, its existence inseparable from the loom itself. Its strikes carry the full weight of the loom's power, and its armor reforms from dream-thread with every blow it absorbs."
	return f


# Prog 13 boss -- balanced boss (Sanctum Guardian)
static func create_sanctum_guardian(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Sanctum Guardian", lvl)
	f.health = EH.es(590, 662, 6, 9, lvl, 14); f.max_health = f.health
	f.mana = EH.es(38, 46, 1, 2, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(103, 114, 3, 5, lvl, 14)
	f.physical_defense = EH.es(44, 53, 2, 3, lvl, 14)
	f.magic_attack = EH.es(102, 113, 3, 5, lvl, 14)
	f.magic_defense = EH.es(44, 53, 2, 3, lvl, 14)
	f.speed = EH.es(41, 47, 2, 3, lvl, 14)
	f.crit_chance = 25; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.loom_slam(), EAB.thread_storm(), EAB.guardians_veil()]
	f.flavor_text = "The final ward of the dream sanctum, a colossal being of interwoven threads and crystallized will. It fights with the combined resolve of every cultist who has prayed at the loom."
	return f
