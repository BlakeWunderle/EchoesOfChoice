class_name EnemyDBAct345

## Acts III-V enemy factory (Progression 8-13): city guards, stranger, corruption, final.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")
const EAB := preload("res://scripts/data/story1/enemy_ability_db.gd")
const EABL := preload("res://scripts/data/story1/enemy_ability_db_late.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# Act III enemies (Progression 8-9)
# =============================================================================

static func create_royal_guard(n: String, lvl: int = 10) -> FighterData:
	var f := EH.base(n, "Royal Guard", lvl)
	f.health = EH.es(395, 444, 8, 13, lvl, 10); f.max_health = f.health
	f.mana = EH.es(10, 13, 1, 2, lvl, 10); f.max_mana = f.mana
	f.physical_attack = EH.es(60, 67, 3, 5, lvl, 10)
	f.physical_defense = EH.es(37, 43, 3, 4, lvl, 10)
	f.magic_attack = EH.es(12, 16, 0, 2, lvl, 10)
	f.magic_defense = EH.es(33, 40, 2, 3, lvl, 10)
	f.speed = EH.es(40, 45, 2, 3, lvl, 10)
	f.crit_chance = 10; f.crit_damage = 4; f.dodge_chance = 10
	f.abilities = [EABL.bulwark_slam(), EABL.sword_strike(), EABL.defensive_formation()]
	f.flavor_text = "Elite soldiers sworn to the crown. Their discipline and heavy armor make them formidable."
	return f

static func create_guard_sergeant(n: String, lvl: int = 10) -> FighterData:
	var f := EH.base(n, "Guard Sergeant", lvl)
	f.health = EH.es(389, 440, 8, 13, lvl, 10); f.max_health = f.health
	f.mana = EH.es(11, 14, 1, 2, lvl, 10); f.max_mana = f.mana
	f.physical_attack = EH.es(67, 76, 3, 5, lvl, 10)
	f.physical_defense = EH.es(24, 31, 2, 3, lvl, 10)
	f.magic_attack = EH.es(14, 18, 0, 2, lvl, 10)
	f.magic_defense = EH.es(27, 33, 1, 2, lvl, 10)
	f.speed = EH.es(44, 49, 2, 3, lvl, 10)
	f.crit_chance = 17; f.crit_damage = 5; f.dodge_chance = 10
	f.abilities = [EABL.sword_strike(), EABL.battle_command(), EABL.decisive_blow()]
	f.flavor_text = "A hardened officer who leads from the front, rallying guards with sharp commands."
	return f

static func create_guard_archer(n: String, lvl: int = 10) -> FighterData:
	var f := EH.base(n, "Guard Archer", lvl)
	f.health = EH.es(314, 364, 7, 12, lvl, 10); f.max_health = f.health
	f.mana = EH.es(11, 14, 1, 2, lvl, 10); f.max_mana = f.mana
	f.physical_attack = EH.es(65, 72, 3, 5, lvl, 10)
	f.physical_defense = EH.es(18, 24, 1, 3, lvl, 10)
	f.magic_attack = EH.es(12, 16, 0, 2, lvl, 10)
	f.magic_defense = EH.es(25, 33, 1, 3, lvl, 10)
	f.speed = EH.es(45, 50, 3, 4, lvl, 10)
	f.crit_chance = 30; f.crit_damage = 5; f.dodge_chance = 17
	f.abilities = [EABL.arrow_shot(), EABL.volley(), EABL.pin_down()]
	f.flavor_text = "Sharpshooters stationed on the city walls. They pin targets down with precise volleys."
	return f

static func create_stranger(n: String, lvl: int = 11) -> FighterData:
	var f := EH.base(n, "Stranger", lvl)
	f.health = EH.es(851, 946, 16, 22, lvl, 11); f.max_health = f.health
	f.mana = EH.es(30, 35, 2, 3, lvl, 11); f.max_mana = f.mana
	f.physical_attack = EH.es(91, 101, 4, 6, lvl, 11)
	f.physical_defense = EH.es(41, 48, 2, 4, lvl, 11)
	f.magic_attack = EH.es(95, 107, 4, 7, lvl, 11)
	f.magic_defense = EH.es(45, 52, 2, 4, lvl, 11)
	f.speed = EH.es(57, 63, 2, 4, lvl, 11)
	f.crit_chance = 22; f.crit_damage = 4; f.dodge_chance = 17
	f.abilities = [EABL.shadow_strike(), EABL.dark_pulse(), EABL.void_shield(), EABL.drain(), EABL.soul_siphon()]
	f.flavor_text = "A cloaked figure radiating dark power. His true nature remains hidden beneath layers of shadow."
	return f


# =============================================================================
# Act IV-V enemies (Progression 10-13)
# =============================================================================

static func create_lich(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Lich", lvl)
	f.health = EH.es(431, 485, 9, 13, lvl, 12); f.max_health = f.health
	f.mana = EH.es(26, 31, 2, 3, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(22, 26, 0, 2, lvl, 12)
	f.physical_defense = EH.es(24, 29, 2, 3, lvl, 12)
	f.magic_attack = EH.es(87, 95, 4, 6, lvl, 12)
	f.magic_defense = EH.es(47, 56, 3, 5, lvl, 12)
	f.speed = EH.es(44, 50, 2, 4, lvl, 12)
	f.crit_chance = 17; f.crit_damage = 4; f.dodge_chance = 10
	f.abilities = [EABL.death_bolt(), EABL.raise_dead(), EABL.soul_cage()]
	f.flavor_text = "An undead sorcerer sustained by stolen souls. Death magic bends to its will."
	return f

static func create_ghast(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Ghast", lvl)
	f.health = EH.es(383, 433, 8, 11, lvl, 12); f.max_health = f.health
	f.mana = EH.es(13, 17, 1, 2, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(83, 89, 3, 5, lvl, 12)
	f.physical_defense = EH.es(40, 46, 2, 4, lvl, 12)
	f.magic_attack = EH.es(26, 32, 1, 2, lvl, 12)
	f.magic_defense = EH.es(24, 29, 1, 3, lvl, 12)
	f.speed = EH.es(36, 43, 2, 3, lvl, 12)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EABL.slam(), EABL.poison_cloud(), EAB.rend()]
	f.flavor_text = "A bloated horror that reeks of decay. Its poisonous miasma chokes the air around it."
	return f

static func create_demon(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Demon", lvl)
	f.health = EH.es(581, 646, 8, 11, lvl, 12); f.max_health = f.health
	f.mana = EH.es(31, 36, 2, 3, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(32, 38, 1, 3, lvl, 12)
	f.physical_defense = EH.es(22, 28, 1, 3, lvl, 12)
	f.magic_attack = EH.es(96, 106, 5, 7, lvl, 12)
	f.magic_defense = EH.es(38, 44, 2, 4, lvl, 12)
	f.speed = EH.es(30, 36, 1, 3, lvl, 12)
	f.crit_chance = 25; f.crit_damage = 5; f.dodge_chance = 17
	f.abilities = [EABL.balefire(), EABL.hellfire_nova()]
	f.flavor_text = "A fiend born from brimstone and fury. Its mere presence fills the air with dread."
	return f

static func create_corrupted_treant(n: String, lvl: int = 12) -> FighterData:
	var f := EH.base(n, "Corrupted Treant", lvl)
	f.health = EH.es(490, 544, 9, 12, lvl, 12); f.max_health = f.health
	f.mana = EH.es(14, 18, 1, 2, lvl, 12); f.max_mana = f.mana
	f.physical_attack = EH.es(65, 73, 3, 5, lvl, 12)
	f.physical_defense = EH.es(56, 62, 3, 5, lvl, 12)
	f.magic_attack = EH.es(42, 50, 2, 4, lvl, 12)
	f.magic_defense = EH.es(32, 39, 2, 4, lvl, 12)
	f.speed = EH.es(36, 42, 1, 3, lvl, 12)
	f.crit_chance = 10; f.crit_damage = 4; f.dodge_chance = 10
	f.abilities = [EABL.blighted_crush(), EABL.corruption_bloom()]
	f.flavor_text = "Once a guardian of the ancient wood, now twisted by corruption into a weapon of ruin."
	return f

static func create_hellion(n: String, lvl: int = 17) -> FighterData:
	var f := EH.base(n, "Hellion", lvl)
	f.health = EH.fixed(178, 203); f.max_health = f.health
	f.mana = EH.fixed(20, 24); f.max_mana = f.mana
	f.physical_attack = EH.fixed(48, 52); f.physical_defense = EH.fixed(29, 33)
	f.magic_attack = EH.fixed(42, 47); f.magic_defense = EH.fixed(27, 31)
	f.speed = EH.fixed(37, 43)
	f.crit_chance = 29; f.crit_damage = 4; f.dodge_chance = 18
	f.abilities = [EABL.frenzy_slash(), EABL.chaos_rend(), EABL.manic_howl()]
	f.flavor_text = "Frenzied lesser demons that slash wildly, driven by an insatiable thirst for chaos."
	return f

static func create_fiendling(n: String, lvl: int = 17) -> FighterData:
	var f := EH.base(n, "Fiendling", lvl)
	f.health = EH.fixed(161, 188); f.max_health = f.health
	f.mana = EH.fixed(24, 29); f.max_mana = f.mana
	f.physical_attack = EH.fixed(22, 26); f.physical_defense = EH.fixed(24, 29)
	f.magic_attack = EH.fixed(51, 58); f.magic_defense = EH.fixed(30, 34)
	f.speed = EH.fixed(39, 45)
	f.crit_chance = 27; f.crit_damage = 4; f.dodge_chance = 18
	f.abilities = [EABL.hellspark(), EABL.imp_curse(), EABL.fiend_mark()]
	f.flavor_text = "Impish creatures that hurl sparks and curses with gleeful malice."
	return f

static func create_dragon(n: String, lvl: int = 17) -> FighterData:
	var f := EH.base(n, "Dragon", lvl)
	f.health = EH.fixed(265, 290); f.max_health = f.health
	f.mana = EH.fixed(25, 30); f.max_mana = f.mana
	f.physical_attack = EH.fixed(34, 38); f.physical_defense = EH.fixed(33, 37)
	f.magic_attack = EH.fixed(48, 52); f.magic_defense = EH.fixed(30, 34)
	f.speed = EH.fixed(35, 41)
	f.crit_chance = 30; f.crit_damage = 4; f.dodge_chance = 16
	f.abilities = [EABL.cataclysm_breath(), EABL.rending_talons(), EABL.draconic_terror()]
	f.flavor_text = "An ancient wyrm of devastating power. Its breath reduces armies to ash."
	return f

static func create_blighted_stag(n: String, lvl: int = 17) -> FighterData:
	var f := EH.base(n, "Blighted Stag", lvl)
	f.health = EH.fixed(179, 204); f.max_health = f.health
	f.mana = EH.fixed(17, 20); f.max_mana = f.mana
	f.physical_attack = EH.fixed(44, 49); f.physical_defense = EH.fixed(26, 30)
	f.magic_attack = EH.fixed(26, 30); f.magic_defense = EH.fixed(24, 29)
	f.speed = EH.fixed(39, 45)
	f.crit_chance = 21; f.crit_damage = 4; f.dodge_chance = 17
	f.abilities = [EABL.antler_charge(), EABL.rot_aura(), EABL.blighted_breath()]
	f.flavor_text = "A noble beast warped by corruption. Rot spreads from its hooves with every step."
	return f

static func create_dark_knight(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Dark Knight", lvl)
	f.health = EH.es(528, 584, 7, 10, lvl, 14); f.max_health = f.health
	f.mana = EH.es(18, 23, 2, 3, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(91, 99, 4, 6, lvl, 14)
	f.physical_defense = EH.es(40, 49, 3, 5, lvl, 14)
	f.magic_attack = EH.es(51, 60, 2, 4, lvl, 14)
	f.magic_defense = EH.es(40, 48, 2, 4, lvl, 14)
	f.speed = EH.es(51, 58, 2, 4, lvl, 14)
	f.crit_chance = 30; f.crit_damage = 5; f.dodge_chance = 17
	f.abilities = [EABL.dark_blade(), EABL.shadow_guard(), EAB.cleave()]
	f.flavor_text = "A fallen champion clad in shadowed plate. Dark magic courses through every strike of his blade."
	return f

static func create_fell_hound(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Fell Hound", lvl)
	f.health = EH.es(442, 494, 6, 9, lvl, 14); f.max_health = f.health
	f.mana = EH.es(18, 23, 2, 3, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(30, 35, 1, 3, lvl, 14)
	f.physical_defense = EH.es(27, 34, 2, 3, lvl, 14)
	f.magic_attack = EH.es(79, 88, 3, 5, lvl, 14)
	f.magic_defense = EH.es(38, 44, 2, 4, lvl, 14)
	f.speed = EH.es(56, 62, 3, 5, lvl, 14)
	f.crit_chance = 17; f.crit_damage = 5; f.dodge_chance = 25
	f.abilities = [EABL.shadow_bite(), EABL.howl_of_dread(), EABL.corruption_fang()]
	f.flavor_text = "Spectral hounds that hunt in packs across the corrupted wastes. Their howls freeze the blood."
	return f

static func create_sigil_wretch(n: String, lvl: int = 13) -> FighterData:
	var f := EH.base(n, "Sigil Wretch", lvl)
	f.health = EH.es(427, 473, 7, 10, lvl, 13); f.max_health = f.health
	f.mana = EH.es(24, 29, 2, 3, lvl, 13); f.max_mana = f.mana
	f.physical_attack = EH.es(25, 28, 0, 2, lvl, 13)
	f.physical_defense = EH.es(28, 35, 1, 3, lvl, 13)
	f.magic_attack = EH.es(95, 105, 5, 7, lvl, 13)
	f.magic_defense = EH.es(41, 47, 2, 4, lvl, 13)
	f.speed = EH.es(51, 58, 3, 5, lvl, 13)
	f.crit_chance = 17; f.crit_damage = 5; f.dodge_chance = 17
	f.abilities = [EABL.sigil_flare(), EABL.glyph_burn(), EABL.ward_break()]
	f.flavor_text = "Twisted creatures bound to arcane sigils. They detonate glyphs of searing light at will."
	return f

static func create_tunnel_lurker(n: String, lvl: int = 13) -> FighterData:
	var f := EH.base(n, "Tunnel Lurker", lvl)
	f.health = EH.es(531, 580, 10, 14, lvl, 13); f.max_health = f.health
	f.mana = EH.es(18, 21, 1, 2, lvl, 13); f.max_mana = f.mana
	f.physical_attack = EH.es(99, 109, 5, 7, lvl, 13)
	f.physical_defense = EH.es(38, 44, 2, 4, lvl, 13)
	f.magic_attack = EH.es(26, 32, 1, 2, lvl, 13)
	f.magic_defense = EH.es(40, 46, 2, 3, lvl, 13)
	f.speed = EH.es(47, 54, 3, 5, lvl, 13)
	f.crit_chance = 25; f.crit_damage = 5; f.dodge_chance = 20
	f.abilities = [EABL.venomous_bite(), EABL.web(), EABL.poison_cloud()]
	f.flavor_text = "Massive burrowing predators that ambush from below, ensnaring prey in venomous webs."
	return f

static func create_stranger_final(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Stranger", lvl)
	f.class_id = "StrangerFinal"
	f.health = EH.es(1300, 1430, 17, 23, lvl, 15); f.max_health = f.health
	f.mana = EH.es(45, 51, 3, 4, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(104, 114, 3, 5, lvl, 15)
	f.physical_defense = EH.es(58, 66, 3, 5, lvl, 15)
	f.magic_attack = EH.es(111, 122, 4, 6, lvl, 15)
	f.magic_defense = EH.es(61, 69, 3, 5, lvl, 15)
	f.speed = EH.es(70, 77, 3, 5, lvl, 15)
	f.crit_chance = 25; f.crit_damage = 6; f.dodge_chance = 20
	f.abilities = [EABL.shadow_blast(), EABL.siphon(), EABL.dark_veil(), EABL.unmake(), EABL.entropy()]
	f.flavor_text = "The Stranger revealed in full, terrible power. Reality itself bends around him as he prepares to unmake everything."
	return f
