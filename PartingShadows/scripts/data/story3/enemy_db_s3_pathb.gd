class_name EnemyDBS3PathB

## Story 3 Path B enemy factory. All unique types for the investigation path.
## T2 rebalance: stats scaled to match T2 player power levels.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const EAB := preload("res://scripts/data/story3/enemy_ability_db_s3_pathb.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# Prog 11: Bound dream creatures guarding the inn cellar (S3_B_InnSearch)
# Target 67%, 12 level-ups
# =============================================================================

static func create_cellar_sentinel(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Cellar Sentinel", lvl)
	f.health = EH.es(453, 518, 5, 8, lvl, 12); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(93, 104, 3, 5, lvl, 12)
	f.physical_defense = EH.es(47, 55, 2, 4, lvl, 12)
	f.magic_attack = EH.es(18, 22, 0, 1, lvl, 12)
	f.magic_defense = EH.es(30, 36, 2, 3, lvl, 12)
	f.speed = EH.es(27, 33, 2, 3, lvl, 12)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.petrified_slam(), EAB.stagnant_chill()]
	f.flavor_text = "A stone-like guardian that has stood watch in the cellar for so long it has calcified into the walls. It attacks with petrifying force and radiates an unnatural cold."
	return f


static func create_bound_stalker(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Bound Stalker", lvl)
	f.health = EH.es(340, 391, 4, 7, lvl, 12); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(84, 94, 3, 5, lvl, 12)
	f.physical_defense = EH.es(32, 39, 2, 3, lvl, 12)
	f.magic_attack = EH.es(18, 22, 0, 1, lvl, 12)
	f.magic_defense = EH.es(30, 36, 2, 3, lvl, 12)
	f.speed = EH.es(35, 41, 2, 3, lvl, 12)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EAB.tethered_lunge(), EAB.fraying_bite()]
	f.flavor_text = "A lean creature bound by fraying threads to the cellar's hidden sanctum. It lunges at intruders with desperate speed, its bite unraveling both flesh and resolve."
	return f


# =============================================================================
# Prog 12: Cult members at early strength (S3_B_CultConfrontation)
# Target 65%, 13 level-ups. NOTE: only 2 enemies -- needs strong stats.
# =============================================================================

static func create_thread_disciple(n: String, lvl: int = 13) -> FighterData:
	var f := EH.base(n, "Thread Disciple", lvl)
	f.health = EH.es(468, 538, 5, 8, lvl, 13); f.max_health = f.health
	f.mana = EH.es(38, 46, 1, 2, lvl, 13); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 25, 0, 2, lvl, 13)
	f.physical_defense = EH.es(38, 45, 2, 3, lvl, 13)
	f.magic_attack = EH.es(126, 139, 3, 5, lvl, 13)
	f.magic_defense = EH.es(44, 53, 2, 4, lvl, 13)
	f.speed = EH.es(32, 38, 2, 3, lvl, 13)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.unstable_channeling(), EAB.siphon_faith()]
	f.flavor_text = "A young cultist whose devotion outpaces their skill. Their channeling is unstable and volatile, but their faith in the Thread grants them power beyond their training."
	return f


static func create_thread_warden(n: String, lvl: int = 13) -> FighterData:
	var f := EH.base(n, "Thread Warden", lvl)
	f.health = EH.es(558, 639, 6, 9, lvl, 13); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 13); f.max_mana = f.mana
	f.physical_attack = EH.es(127, 141, 3, 5, lvl, 13)
	f.physical_defense = EH.es(58, 66, 2, 4, lvl, 13)
	f.magic_attack = EH.es(19, 23, 0, 1, lvl, 13)
	f.magic_defense = EH.es(36, 44, 2, 3, lvl, 13)
	f.speed = EH.es(23, 29, 2, 3, lvl, 13)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.shielding_blow(), EAB.guardians_oath()]
	f.flavor_text = "A seasoned warrior sworn to protect the Thread cult's sanctum. Bound by an oath woven into their very being, they fight with unwavering purpose and crushing strength."
	return f


# =============================================================================
# Prog 13: Tunnel breach outer guard (S3_B_TunnelBreach)
# Target 63%, 14 level-ups
# =============================================================================

static func create_tunnel_sentinel(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Tunnel Sentinel", lvl)
	f.health = EH.es(498, 569, 6, 9, lvl, 14); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(117, 130, 3, 5, lvl, 14)
	f.physical_defense = EH.es(56, 65, 2, 4, lvl, 14)
	f.magic_attack = EH.es(23, 27, 0, 1, lvl, 14)
	f.magic_defense = EH.es(36, 44, 2, 3, lvl, 14)
	f.speed = EH.es(32, 38, 2, 3, lvl, 14)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.chokepoint_crush(), EAB.passage_block()]
	f.flavor_text = "A massive guard stationed at the tunnel's narrowest point. It uses the confined space to devastating effect, crushing those who try to force their way through."
	return f


static func create_thread_sniper(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Thread Sniper", lvl)
	f.health = EH.es(366, 422, 5, 8, lvl, 14); f.max_health = f.health
	f.mana = EH.es(36, 44, 1, 2, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(25, 29, 0, 2, lvl, 14)
	f.physical_defense = EH.es(32, 39, 2, 3, lvl, 14)
	f.magic_attack = EH.es(120, 132, 3, 5, lvl, 14)
	f.magic_defense = EH.es(42, 50, 2, 4, lvl, 14)
	f.speed = EH.es(38, 44, 2, 3, lvl, 14)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.piercing_thread(), EAB.expose_weakness()]
	f.flavor_text = "A cult marksman who fires needles of hardened dream-thread from the shadows. Each piercing shot reveals weaknesses in the target's defenses for allies to exploit."
	return f


static func create_pale_devotee(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Pale Devotee", lvl)
	f.health = EH.es(402, 462, 5, 8, lvl, 14); f.max_health = f.health
	f.mana = EH.es(36, 44, 1, 2, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(25, 29, 0, 2, lvl, 14)
	f.physical_defense = EH.es(31, 39, 2, 3, lvl, 14)
	f.magic_attack = EH.es(115, 127, 3, 5, lvl, 14)
	f.magic_defense = EH.es(49, 58, 2, 4, lvl, 14)
	f.speed = EH.es(34, 40, 2, 3, lvl, 14)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EAB.burning_devotion(), EAB.martyrs_gift()]
	f.flavor_text = "A pale, gaunt cultist who has given everything to the Thread. Their devotion burns like a fever, and in death they offer their remaining life-force as a gift to their allies."
	return f


# =============================================================================
# Prog 14: Thorne's ward in the passages (S3_B_ThornesWard)
# Target 61%, 15 level-ups
# =============================================================================

static func create_thread_ritualist(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Thread Ritualist", lvl)
	f.health = EH.es(463, 534, 5, 8, lvl, 14); f.max_health = f.health
	f.mana = EH.es(38, 46, 1, 2, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 25, 0, 2, lvl, 14)
	f.physical_defense = EH.es(42, 51, 2, 4, lvl, 14)
	f.magic_attack = EH.es(125, 138, 3, 5, lvl, 14)
	f.magic_defense = EH.es(48, 58, 2, 4, lvl, 14)
	f.speed = EH.es(38, 44, 2, 3, lvl, 14)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.binding_rite(), EAB.enervation_chant()]
	f.flavor_text = "A ritualist who maintains Thorne's protective ward through constant chanting. Their binding rites sap the strength of intruders while reinforcing the dream's barriers."
	return f


static func create_passage_guardian(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Passage Guardian", lvl)
	f.health = EH.es(549, 628, 6, 9, lvl, 14); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(124, 139, 3, 5, lvl, 14)
	f.physical_defense = EH.es(63, 71, 2, 4, lvl, 14)
	f.magic_attack = EH.es(19, 23, 0, 1, lvl, 14)
	f.magic_defense = EH.es(39, 49, 2, 3, lvl, 14)
	f.speed = EH.es(33, 39, 2, 3, lvl, 14)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.champions_cleave(), EAB.loom_aegis()]
	f.flavor_text = "A champion of the hidden passages, clad in armor woven from the loom itself. Their cleaving strikes and impenetrable aegis make them the cult's most formidable gatekeeper."
	return f


static func create_warding_shadow(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Warding Shadow", lvl)
	f.health = EH.es(406, 467, 4, 7, lvl, 14); f.max_health = f.health
	f.mana = EH.es(36, 44, 1, 2, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 25, 0, 2, lvl, 14)
	f.physical_defense = EH.es(31, 38, 2, 3, lvl, 14)
	f.magic_attack = EH.es(117, 130, 3, 5, lvl, 14)
	f.magic_defense = EH.es(49, 59, 2, 4, lvl, 14)
	f.speed = EH.es(39, 45, 2, 3, lvl, 14)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [EAB.flickering_grasp(), EAB.shadow_veil()]
	f.flavor_text = "A flickering shade that guards the passages with elusive, ghost-like movements. It cloaks itself in shadow and reaches through the veil to grasp at the living."
	return f


# =============================================================================
# Prog 15: Shadow Innkeeper and Aldric projection (S3_B_LoomHeart)
# Target 59%, 16 level-ups
# =============================================================================

static func create_shadow_innkeeper(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Shadow Innkeeper", lvl)
	f.health = EH.es(519, 585, 6, 9, lvl, 15); f.max_health = f.health
	f.mana = EH.es(38, 46, 1, 2, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(119, 130, 3, 5, lvl, 15)
	f.physical_defense = EH.es(44, 52, 2, 4, lvl, 15)
	f.magic_attack = EH.es(129, 141, 3, 5, lvl, 15)
	f.magic_defense = EH.es(44, 52, 2, 4, lvl, 15)
	f.speed = EH.es(42, 48, 2, 3, lvl, 15)
	f.crit_chance = 25; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.borrowed_face(), EAB.thread_drain()]
	f.flavor_text = "The innkeeper's shadow given terrible purpose, wearing a stolen face that shifts between hospitality and menace. It drains life through threads hidden beneath a veneer of warmth."
	return f


static func create_astral_weaver(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Astral Weaver", lvl)
	f.health = EH.es(424, 481, 5, 8, lvl, 15); f.max_health = f.health
	f.mana = EH.es(40, 48, 1, 2, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(19, 23, 0, 2, lvl, 15)
	f.physical_defense = EH.es(32, 39, 2, 3, lvl, 15)
	f.magic_attack = EH.es(130, 144, 3, 5, lvl, 15)
	f.magic_defense = EH.es(50, 58, 2, 4, lvl, 15)
	f.speed = EH.es(51, 57, 2, 3, lvl, 15)
	f.crit_chance = 25; f.crit_damage = 3; f.dodge_chance = 20
	f.abilities = [EAB.astral_barrage(), EAB.cosmic_unraveling()]
	f.flavor_text = "A weaver who has touched the astral plane beyond the dream and returned with terrible knowledge. Their barrages of cosmic energy unravel the fabric of reality itself."
	return f


static func create_loom_tendril(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Loom Tendril", lvl)
	f.health = EH.es(392, 444, 5, 8, lvl, 15); f.max_health = f.health
	f.mana = EH.es(34, 40, 1, 2, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(18, 22, 0, 2, lvl, 15)
	f.physical_defense = EH.es(32, 39, 2, 3, lvl, 15)
	f.magic_attack = EH.es(121, 136, 3, 5, lvl, 15)
	f.magic_defense = EH.es(40, 48, 2, 4, lvl, 15)
	f.speed = EH.es(37, 43, 2, 3, lvl, 15)
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.siphon_pulse(), EAB.constricting_weave(), EAB.slow_crush()]
	f.flavor_text = "A living extension of the great loom, a tendril of woven dream-stuff that lashes out at those who approach. It siphons energy and constricts with suffocating pressure."
	return f


# Prog 15 -- physical DoT/drain parasite (level 15)
static func create_loom_parasite(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Loom Parasite", lvl)
	f.health = EH.es(352, 405, 5, 8, lvl, 15); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(113, 125, 3, 5, lvl, 15)
	f.physical_defense = EH.es(34, 41, 2, 3, lvl, 15)
	f.magic_attack = EH.es(17, 21, 0, 1, lvl, 15)
	f.magic_defense = EH.es(36, 43, 2, 3, lvl, 15)
	f.speed = EH.es(44, 50, 2, 3, lvl, 15)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EAB.parasitic_bite(), EAB.infesting_spores()]
	f.flavor_text = "A creature spawned from the Loom's waste threads, living off the energy of others. It latches onto victims, draining their life while planting spores that keep feeding long after it lets go."
	return f


# =============================================================================
# Prog 16: Lira's dream cathedral guardians (S3_B_DreamInvasion)
# Target 56%, 17 level-ups
# =============================================================================

static func create_cathedral_warden(n: String, lvl: int = 16) -> FighterData:
	var f := EH.base(n, "Cathedral Warden", lvl)
	f.health = EH.es(620, 700, 6, 9, lvl, 16); f.max_health = f.health
	f.mana = EH.es(36, 44, 1, 2, lvl, 16); f.max_mana = f.mana
	f.physical_attack = EH.es(121, 136, 3, 5, lvl, 16)
	f.physical_defense = EH.es(52, 61, 2, 4, lvl, 16)
	f.magic_attack = EH.es(135, 151, 3, 5, lvl, 16)
	f.magic_defense = EH.es(52, 61, 2, 4, lvl, 16)
	f.speed = EH.es(41, 47, 2, 3, lvl, 16)
	f.crit_chance = 20; f.crit_damage = 3; f.dodge_chance = 20
	f.abilities = [EAB.consecrated_strike(), EAB.cathedrals_blessing()]
	f.flavor_text = "A guardian consecrated to Lira's dream cathedral, sworn to protect the sacred space where the Thread cult weaves its deepest designs. It fights with holy zeal and unyielding faith."
	return f


static func create_dream_binder(n: String, lvl: int = 16) -> FighterData:
	var f := EH.base(n, "Dream Binder", lvl)
	f.health = EH.es(524, 597, 5, 8, lvl, 16); f.max_health = f.health
	f.mana = EH.es(38, 46, 1, 2, lvl, 16); f.max_mana = f.mana
	f.physical_attack = EH.es(19, 23, 0, 2, lvl, 16)
	f.physical_defense = EH.es(35, 42, 2, 3, lvl, 16)
	f.magic_attack = EH.es(140, 156, 3, 5, lvl, 16)
	f.magic_defense = EH.es(55, 63, 2, 4, lvl, 16)
	f.speed = EH.es(45, 51, 2, 3, lvl, 16)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 20
	f.abilities = [EAB.binding_chains(), EAB.dreamlock()]
	f.flavor_text = "A specialist in containment, weaving chains of dream-thread that lock the mind in place. Those caught in its dreamlock cannot flee, attack, or even think of escape."
	return f


static func create_thread_anchor(n: String, lvl: int = 16) -> FighterData:
	var f := EH.base(n, "Thread Anchor", lvl)
	f.health = EH.es(587, 668, 5, 8, lvl, 16); f.max_health = f.health
	f.mana = EH.es(34, 40, 1, 2, lvl, 16); f.max_mana = f.mana
	f.physical_attack = EH.es(18, 22, 0, 2, lvl, 16)
	f.physical_defense = EH.es(48, 58, 2, 4, lvl, 16)
	f.magic_attack = EH.es(112, 126, 3, 5, lvl, 16)
	f.magic_defense = EH.es(56, 65, 2, 4, lvl, 16)
	f.speed = EH.es(38, 45, 2, 3, lvl, 16)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 25
	f.abilities = [EAB.anchor_pulse(), EAB.fortifying_thread()]
	f.flavor_text = "A massive knot of condensed dream-thread that anchors the cathedral to the waking world. It pulses with stabilizing energy and fortifies all nearby cult forces."
	return f


# Prog 16 physical attacker addition (T2 rework pass)
# WeftStalker: fast hunting predator woven from dream-loom weft threads (level 16)
# Elevated mDef, high speed, MIXED AoE + speed debuff kit
static func create_weft_stalker(n: String, lvl: int = 16) -> FighterData:
	var f := EH.base(n, "WeftStalker", lvl)
	f.health = EH.es(464, 534, 5, 8, lvl, 16); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 16); f.max_mana = f.mana
	f.physical_attack = EH.es(129, 143, 3, 5, lvl, 16)
	f.physical_defense = EH.es(38, 46, 2, 3, lvl, 16)
	f.magic_attack = EH.es(55, 65, 2, 3, lvl, 16)
	f.magic_defense = EH.es(60, 69, 2, 4, lvl, 16)
	f.speed = EH.es(48, 54, 2, 3, lvl, 16)
	f.crit_chance = 20; f.crit_damage = 3; f.dodge_chance = 20
	f.abilities = [EAB.weft_lash(), EAB.stalk()]
	f.flavor_text = "A predator woven from the weft threads of Lira's loom, designed to hunt. It moves with terrifying speed, lashing out in all directions and slowing anything it marks as prey. Magic sinks into the weave without effect."
	return f


# =============================================================================
# Prog 17: Lira boss and minions (S3_B_DreamNexus)
# Target 55%, 18 level-ups (final boss)
# =============================================================================

static func create_lira_threadmaster(n: String, lvl: int = 18) -> FighterData:
	var f := EH.base(n, "Lira, the Threadmaster", lvl)
	f.health = EH.es(1211, 1362, 12, 18, lvl, 18); f.max_health = f.health
	f.mana = EH.es(50, 60, 2, 3, lvl, 18); f.max_mana = f.mana
	f.physical_attack = EH.es(127, 143, 3, 5, lvl, 18)
	f.physical_defense = EH.es(53, 61, 2, 4, lvl, 18)
	f.magic_attack = EH.es(132, 149, 4, 6, lvl, 18)
	f.magic_defense = EH.es(55, 63, 2, 4, lvl, 18)
	f.speed = EH.es(41, 47, 3, 4, lvl, 18)
	f.crit_chance = 20; f.crit_damage = 4; f.dodge_chance = 20
	f.abilities = [EAB.inn_keepers_embrace(), EAB.veil_of_lies(), EAB.shattered_trust(), EAB.charm_of_ages(), EAB.stolen_warmth()]
	f.flavor_text = "Lira revealed as the true Threadmaster, her gentle demeanor shed to expose the master weaver beneath. She commands the loom with absolute authority, puppeting dreams and harvesting the sleeping minds of an entire town."
	return f


static func create_tattered_deception(n: String, lvl: int = 18) -> FighterData:
	var f := EH.base(n, "Tattered Deception", lvl)
	f.health = EH.es(430, 494, 5, 8, lvl, 18); f.max_health = f.health
	f.mana = EH.es(36, 44, 1, 2, lvl, 18); f.max_mana = f.mana
	f.physical_attack = EH.es(19, 23, 0, 2, lvl, 18)
	f.physical_defense = EH.es(36, 44, 2, 3, lvl, 18)
	f.magic_attack = EH.es(134, 150, 3, 6, lvl, 18)
	f.magic_defense = EH.es(46, 55, 2, 4, lvl, 18)
	f.speed = EH.es(45, 51, 3, 4, lvl, 18)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 20
	f.abilities = [EAB.mirrored_assault(), EAB.unraveling_touch()]
	f.flavor_text = "A conjured illusion woven from stolen faces and borrowed memories. It mimics the party's own tactics with uncanny precision, unraveling defenses with every touch."
	return f


static func create_dream_bastion(n: String, lvl: int = 18) -> FighterData:
	var f := EH.base(n, "Dream Bastion", lvl)
	f.health = EH.es(541, 622, 6, 9, lvl, 18); f.max_health = f.health
	f.mana = EH.es(24, 33, 1, 1, lvl, 18); f.max_mana = f.mana
	f.physical_attack = EH.es(147, 164, 3, 5, lvl, 18)
	f.physical_defense = EH.es(65, 73, 2, 4, lvl, 18)
	f.magic_attack = EH.es(17, 21, 0, 1, lvl, 18)
	f.magic_defense = EH.es(40, 49, 2, 4, lvl, 18)
	f.speed = EH.es(33, 39, 2, 3, lvl, 18)
	f.crit_chance = 10; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.bastion_slam(), EAB.nexus_shield()]
	f.flavor_text = "A fortress of solidified dream-thread that guards the nexus of Lira's power. It absorbs punishment meant for its master and retaliates with devastating force."
	return f
