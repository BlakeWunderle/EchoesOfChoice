class_name EnemyDBS3

## Story 3 Acts I-II enemy factory. Dream fauna and nightmare entities.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const EAB := preload("res://scripts/data/story3/enemy_ability_db_s3.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# Act I: Dream fauna (Progression 0-2)
# =============================================================================

# Prog 0 (+8%)
static func create_dream_wisp(n: String, lvl: int = 1) -> FighterData:
	var f := EH.base(n, "Dream Wisp", lvl)
	f.health = EH.es(32, 42, 2, 5, lvl, 1); f.max_health = f.health
	f.mana = EH.es(7, 10, 1, 2, lvl, 1); f.max_mana = f.mana
	f.physical_attack = EH.es(13, 17, 0, 2, lvl, 1)
	f.physical_defense = EH.es(6, 9, 0, 1, lvl, 1)
	f.magic_attack = EH.es(18, 21, 1, 3, lvl, 1)
	f.magic_defense = EH.es(6, 9, 1, 2, lvl, 1)
	f.speed = EH.es(25, 30, 1, 3, lvl, 1)
	f.crit_chance = 6; f.crit_damage = 1; f.dodge_chance = 12
	f.abilities = [EAB.shimmer_bolt(), EAB.daze()]
	f.flavor_text = "A flickering mote of dream-light that drifts through the sleeping mind. Its glow entrances the unwary before striking with bursts of raw thought."
	return f


static func create_phantasm(n: String, lvl: int = 1) -> FighterData:
	var f := EH.base(n, "Phantasm", lvl)
	f.health = EH.es(37, 48, 2, 5, lvl, 1); f.max_health = f.health
	f.mana = EH.es(5, 8, 1, 1, lvl, 1); f.max_mana = f.mana
	f.physical_attack = EH.es(19, 22, 1, 2, lvl, 1)
	f.physical_defense = EH.es(7, 10, 0, 1, lvl, 1)
	f.magic_attack = EH.es(19, 22, 1, 2, lvl, 1)
	f.magic_defense = EH.es(7, 10, 1, 2, lvl, 1)
	f.speed = EH.es(23, 29, 1, 3, lvl, 1)
	f.crit_chance = 6; f.crit_damage = 1; f.dodge_chance = 13
	f.abilities = [EAB.phase_strike(), EAB.unnerve()]
	f.flavor_text = "A translucent figure that flickers between presence and absence. It strikes from angles that should not exist, leaving a cold dread in its wake."
	return f


# Prog 1 MirrorHall enemies
static func create_shade_moth(n: String, lvl: int = 1) -> FighterData:
	var f := EH.base(n, "Shade Moth", lvl)
	f.health = EH.es(29, 37, 2, 3, lvl, 1); f.max_health = f.health
	f.mana = EH.es(4, 7, 1, 1, lvl, 1); f.max_mana = f.mana
	f.physical_attack = EH.es(14, 17, 1, 2, lvl, 1)
	f.physical_defense = EH.es(5, 9, 0, 1, lvl, 1)
	f.magic_attack = EH.es(12, 15, 0, 2, lvl, 1)
	f.magic_defense = EH.es(5, 8, 0, 1, lvl, 1)
	f.speed = EH.es(30, 36, 1, 3, lvl, 1)
	f.crit_chance = 8; f.crit_damage = 1; f.dodge_chance = 14
	f.abilities = [EAB.dust_wing(), EAB.flit()]
	f.flavor_text = "A dark-winged insect born from forgotten memories. Its scales scatter a soporific dust that clouds the senses."
	return f


static func create_sleep_stalker(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Sleep Stalker", lvl)
	f.health = EH.es(52, 61, 3, 6, lvl, 2); f.max_health = f.health
	f.mana = EH.es(4, 7, 1, 1, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(22, 26, 1, 3, lvl, 2)
	f.physical_defense = EH.es(12, 15, 1, 2, lvl, 2)
	f.magic_attack = EH.es(10, 13, 0, 1, lvl, 2)
	f.magic_defense = EH.es(5, 8, 0, 1, lvl, 2)
	f.speed = EH.es(29, 35, 1, 3, lvl, 2)
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 8
	f.abilities = [EAB.dream_fang(), EAB.shadow_lunge()]
	f.flavor_text = "A gaunt predator that prowls the border between waking and sleep. It hunts by sensing the fear of dreamers who linger too long."
	return f


static func create_mirror_shade(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Mirror Shade", lvl)
	f.health = EH.es(42, 51, 2, 4, lvl, 2); f.max_health = f.health
	f.mana = EH.es(5, 8, 1, 1, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(16, 20, 1, 2, lvl, 2)
	f.physical_defense = EH.es(10, 13, 1, 2, lvl, 2)
	f.magic_attack = EH.es(16, 20, 1, 2, lvl, 2)
	f.magic_defense = EH.es(7, 10, 1, 2, lvl, 2)
	f.speed = EH.es(25, 31, 1, 2, lvl, 2)
	f.crit_chance = 12; f.crit_damage = 1; f.dodge_chance = 6
	f.abilities = [EAB.reflected_strike(), EAB.mimic_stance()]
	f.flavor_text = "A distorted reflection that has stepped free of its mirror. It copies the movements of those it faces, turning their own strength against them."
	return f


# Prog 1 FogGarden enemies
static func create_slumber_beast(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Slumber Beast", lvl)
	f.health = EH.es(55, 66, 3, 6, lvl, 2); f.max_health = f.health
	f.mana = EH.es(5, 8, 1, 1, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(22, 26, 1, 3, lvl, 2)
	f.physical_defense = EH.es(12, 16, 1, 2, lvl, 2)
	f.magic_attack = EH.es(9, 12, 0, 1, lvl, 2)
	f.magic_defense = EH.es(5, 8, 1, 2, lvl, 2)
	f.speed = EH.es(21, 26, 1, 2, lvl, 2)
	f.crit_chance = 5; f.crit_damage = 1; f.dodge_chance = 6
	f.abilities = [EAB.heavy_paw(), EAB.drowsy_roar()]
	f.flavor_text = "A massive creature wrapped in matted fur and the haze of deep sleep. Its roar carries the weight of oblivion, dragging listeners toward unconsciousness."
	return f


static func create_fog_wraith(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Fog Wraith", lvl)
	f.health = EH.es(33, 42, 2, 4, lvl, 2); f.max_health = f.health
	f.mana = EH.es(7, 10, 1, 2, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(11, 14, 0, 2, lvl, 2)
	f.physical_defense = EH.es(5, 8, 0, 1, lvl, 2)
	f.magic_attack = EH.es(22, 26, 1, 3, lvl, 2)
	f.magic_defense = EH.es(5, 8, 1, 2, lvl, 2)
	f.speed = EH.es(25, 30, 1, 3, lvl, 2)
	f.crit_chance = 5; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [EAB.mist_tendril(), EAB.chill_fog()]
	f.flavor_text = "A wisp of sentient fog that coils through the dream garden. It chills everything it touches, feeding on the warmth of living thought."
	return f


static func create_thorn_dreamer(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Thorn Dreamer", lvl)
	f.health = EH.es(48, 57, 3, 5, lvl, 2); f.max_health = f.health
	f.mana = EH.es(6, 9, 1, 2, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 24, 1, 2, lvl, 2)
	f.physical_defense = EH.es(9, 12, 1, 2, lvl, 2)
	f.magic_attack = EH.es(15, 19, 1, 2, lvl, 2)
	f.magic_defense = EH.es(9, 12, 1, 2, lvl, 2)
	f.speed = EH.es(22, 27, 1, 2, lvl, 2)
	f.crit_chance = 5; f.crit_damage = 1; f.dodge_chance = 7
	f.abilities = [EAB.briar_lash(), EAB.spore_cloud()]
	f.flavor_text = "A humanoid figure tangled in thorny vines that grow from its own dreaming flesh. It scatters toxic spores drawn from nightmares of wild, choking growth."
	return f


# =============================================================================
# Act II: Nightmare entities (Progression 3-8)
# =============================================================================

# Prog 3 enemies (DreamReturn only, decoupled from DreamNightmare)
static func create_nightmare_hound(n: String, lvl: int = 4) -> FighterData:
	var f := EH.base(n, "Nightmare Hound", lvl)
	f.health = EH.es(100, 120, 4, 7, lvl, 4); f.max_health = f.health
	f.mana = EH.es(5, 7, 1, 1, lvl, 4); f.max_mana = f.mana
	f.physical_attack = EH.es(26, 31, 1, 3, lvl, 4)
	f.physical_defense = EH.es(13, 16, 1, 2, lvl, 4)
	f.magic_attack = EH.es(10, 13, 0, 2, lvl, 4)
	f.magic_defense = EH.es(9, 12, 1, 2, lvl, 4)
	f.speed = EH.es(26, 31, 1, 3, lvl, 4)
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [EAB.savage_bite(), EAB.howl()]
	f.flavor_text = "A slavering beast shaped from primal terror, with eyes like smoldering coals. Its howl reverberates through the dreamscape and shakes the courage of all who hear it."
	return f


static func create_dream_weaver(n: String, lvl: int = 4) -> FighterData:
	var f := EH.base(n, "Dream Weaver", lvl)
	f.health = EH.es(95, 115, 3, 6, lvl, 4); f.max_health = f.health
	f.mana = EH.es(8, 11, 1, 2, lvl, 4); f.max_mana = f.mana
	f.physical_attack = EH.es(10, 13, 0, 2, lvl, 4)
	f.physical_defense = EH.es(7, 10, 1, 2, lvl, 4)
	f.magic_attack = EH.es(25, 30, 1, 3, lvl, 4)
	f.magic_defense = EH.es(15, 18, 1, 2, lvl, 4)
	f.speed = EH.es(24, 29, 1, 2, lvl, 4)
	f.crit_chance = 11; f.crit_damage = 1; f.dodge_chance = 9
	f.abilities = [EAB.thread_bolt(), EAB.woven_ward()]
	f.flavor_text = "A robed figure that pulls shimmering threads from the fabric of dreams. It weaves protective wards and hurls bolts of concentrated dream-stuff at intruders."
	return f


static func create_hollow_echo(n: String, lvl: int = 4) -> FighterData:
	var f := EH.base(n, "Hollow Echo", lvl)
	f.health = EH.es(83, 98, 3, 5, lvl, 4); f.max_health = f.health
	f.mana = EH.es(7, 10, 1, 2, lvl, 4); f.max_mana = f.mana
	f.physical_attack = EH.es(24, 28, 1, 3, lvl, 4)
	f.physical_defense = EH.es(12, 15, 1, 2, lvl, 4)
	f.magic_attack = EH.es(10, 13, 0, 2, lvl, 4)
	f.magic_defense = EH.es(9, 12, 1, 2, lvl, 4)
	f.speed = EH.es(24, 29, 1, 2, lvl, 4)
	f.crit_chance = 11; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [EAB.echo_drain(), EAB.dissonance()]
	f.flavor_text = "The empty husk of a dreamer who never woke. It repeats fragments of stolen voices and drains vitality from those who listen too closely."
	return f


# Prog 7 Labyrinth enemies (+15% over original)
static func create_somnolent_serpent(n: String, lvl: int = 8) -> FighterData:
	var f := EH.base(n, "Somnolent Serpent", lvl)
	f.health = EH.es(200, 232, 4, 7, lvl, 8); f.max_health = f.health
	f.mana = EH.es(6, 8, 1, 2, lvl, 8); f.max_mana = f.mana
	f.physical_attack = EH.es(37, 42, 1, 3, lvl, 8)
	f.physical_defense = EH.es(24, 28, 1, 2, lvl, 8)
	f.magic_attack = EH.es(17, 21, 1, 2, lvl, 8)
	f.magic_defense = EH.es(15, 19, 1, 2, lvl, 8)
	f.speed = EH.es(31, 36, 1, 3, lvl, 8)
	f.crit_chance = 23; f.crit_damage = 1; f.dodge_chance = 12
	f.abilities = [EAB.venom_coil(), EAB.sleep_fang()]
	f.flavor_text = "A great serpent that glides through the labyrinth of slumber. Its venom induces a sleep within sleep, trapping victims in layers of dream they cannot escape."
	return f


static func create_twilight_stalker(n: String, lvl: int = 8) -> FighterData:
	var f := EH.base(n, "Twilight Stalker", lvl)
	f.health = EH.es(192, 224, 4, 7, lvl, 8); f.max_health = f.health
	f.mana = EH.es(5, 7, 1, 1, lvl, 8); f.max_mana = f.mana
	f.physical_attack = EH.es(38, 43, 1, 3, lvl, 8)
	f.physical_defense = EH.es(17, 21, 1, 2, lvl, 8)
	f.magic_attack = EH.es(14, 17, 0, 2, lvl, 8)
	f.magic_defense = EH.es(16, 19, 1, 2, lvl, 8)
	f.speed = EH.es(32, 37, 1, 3, lvl, 8)
	f.crit_chance = 23; f.crit_damage = 2; f.dodge_chance = 14
	f.abilities = [EAB.dusk_blade(), EAB.vanish_strike()]
	f.flavor_text = "A silent hunter cloaked in the half-light between dreams. It vanishes mid-stride and reappears behind its prey with lethal precision."
	return f


static func create_waking_terror(n: String, lvl: int = 8) -> FighterData:
	var f := EH.base(n, "Waking Terror", lvl)
	f.health = EH.es(198, 230, 4, 7, lvl, 8); f.max_health = f.health
	f.mana = EH.es(8, 11, 1, 2, lvl, 8); f.max_mana = f.mana
	f.physical_attack = EH.es(16, 19, 0, 2, lvl, 8)
	f.physical_defense = EH.es(14, 18, 1, 2, lvl, 8)
	f.magic_attack = EH.es(37, 42, 1, 3, lvl, 8)
	f.magic_defense = EH.es(24, 28, 1, 2, lvl, 8)
	f.speed = EH.es(30, 35, 1, 2, lvl, 8)
	f.crit_chance = 24; f.crit_damage = 1; f.dodge_chance = 12
	f.abilities = [EAB.scream_blast(), EAB.terror_wave()]
	f.flavor_text = "A towering horror that bleeds into the waking world, born where nightmares press too hard against reality. Its screams carry the force of raw, unfiltered panic."
	return f


# Prog 7 ClockTower enemies
static func create_dusk_sentinel(n: String, lvl: int = 8) -> FighterData:
	var f := EH.base(n, "Dusk Sentinel", lvl)
	f.health = EH.es(220, 256, 4, 7, lvl, 8); f.max_health = f.health
	f.mana = EH.es(8, 11, 1, 1, lvl, 8); f.max_mana = f.mana
	f.physical_attack = EH.es(38, 43, 1, 3, lvl, 8)
	f.physical_defense = EH.es(24, 28, 1, 3, lvl, 8)
	f.magic_attack = EH.es(12, 15, 0, 1, lvl, 8)
	f.magic_defense = EH.es(14, 18, 1, 2, lvl, 8)
	f.speed = EH.es(33, 38, 1, 2, lvl, 8)
	f.crit_chance = 22; f.crit_damage = 3; f.dodge_chance = 5
	f.abilities = [EAB.shield_bash(), EAB.dusk_toll(), EAB.sentinel_stasis()]
	f.flavor_text = "An armored guardian forged from the dying light of dusk. It stands vigil at the clock tower's threshold, unyielding and tireless in its purpose."
	return f


static func create_shattered_hourglass(n: String, lvl: int = 8) -> FighterData:
	var f := EH.base(n, "Shattered Hourglass", lvl)
	f.health = EH.es(180, 212, 4, 6, lvl, 8); f.max_health = f.health
	f.mana = EH.es(10, 13, 1, 2, lvl, 8); f.max_mana = f.mana
	f.physical_attack = EH.es(10, 14, 0, 2, lvl, 8)
	f.physical_defense = EH.es(11, 15, 1, 2, lvl, 8)
	f.magic_attack = EH.es(36, 41, 1, 3, lvl, 8)
	f.magic_defense = EH.es(19, 23, 1, 2, lvl, 8)
	f.speed = EH.es(32, 37, 1, 3, lvl, 8)
	f.crit_chance = 13; f.crit_damage = 1; f.dodge_chance = 12
	f.abilities = [EAB.grain_siphon(), EAB.eroding_sand()]
	f.flavor_text = "A broken hourglass floating in the void, its glass cracked and splintered. The sand hangs suspended mid-spill, forming the faint suggestion of a face with hollow, glowing eyes. Every grain is a stolen second from a dreamer who slept too long."
	return f


static func create_clock_specter(n: String, lvl: int = 8) -> FighterData:
	var f := EH.base(n, "Clock Specter", lvl)
	f.health = EH.es(180, 220, 4, 6, lvl, 8); f.max_health = f.health
	f.mana = EH.es(7, 10, 1, 2, lvl, 8); f.max_mana = f.mana
	f.physical_attack = EH.es(28, 33, 1, 3, lvl, 8)
	f.physical_defense = EH.es(13, 17, 1, 2, lvl, 8)
	f.magic_attack = EH.es(38, 43, 1, 3, lvl, 8)
	f.magic_defense = EH.es(22, 26, 1, 2, lvl, 8)
	f.speed = EH.es(36, 41, 1, 3, lvl, 8)
	f.crit_chance = 30; f.crit_damage = 2; f.dodge_chance = 12
	f.abilities = [EAB.time_rend(), EAB.temporal_rupture()]
	f.flavor_text = "A spectral figure bound to a shattered clock face, its limbs moving in fractured time. It tears at the flow of moments, freezing enemies in temporal stasis."
	return f


# Prog 8 boss (-3%)
static func create_the_nightmare(n: String, lvl: int = 9) -> FighterData:
	var f := EH.base(n, "The Nightmare", lvl)
	f.health = EH.es(555, 640, 5, 9, lvl, 9); f.max_health = f.health
	f.mana = EH.es(17, 19, 1, 2, lvl, 9); f.max_mana = f.mana
	f.physical_attack = EH.es(41, 46, 2, 3, lvl, 9)
	f.physical_defense = EH.es(16, 21, 2, 3, lvl, 9)
	f.magic_attack = EH.es(33, 38, 2, 3, lvl, 9)
	f.magic_defense = EH.es(16, 21, 2, 3, lvl, 9)
	f.speed = EH.es(33, 38, 2, 3, lvl, 9)
	f.crit_chance = 21; f.crit_damage = 3; f.dodge_chance = 15
	f.abilities = [EAB.nightmare_crush(), EAB.dream_rend(), EAB.dread_aura()]
	f.flavor_text = "The collective dread of an entire town given form and will. It is the dark heart of the shared dream, a shape that shifts with every fear it consumes."
	return f


# Prog 8 boss minion (physical guardian)
static func create_nightmare_guard(n: String, lvl: int = 9) -> FighterData:
	var f := EH.base(n, "Nightmare Guard", lvl)
	f.health = EH.es(115, 140, 4, 7, lvl, 9); f.max_health = f.health
	f.mana = EH.es(9, 11, 1, 1, lvl, 9); f.max_mana = f.mana
	f.physical_attack = EH.es(29, 35, 1, 3, lvl, 9)
	f.physical_defense = EH.es(16, 20, 1, 2, lvl, 9)
	f.magic_attack = EH.es(10, 14, 0, 2, lvl, 9)
	f.magic_defense = EH.es(13, 17, 1, 2, lvl, 9)
	f.speed = EH.es(29, 34, 1, 3, lvl, 9)
	f.crit_chance = 19; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EAB.dread_fang(), EAB.guardian_howl()]
	f.flavor_text = "A corrupted sentinel twisted by the Nightmare's will. Once a dream's protector, it now guards the heart of terror with savage devotion."
	return f


# Prog 8 boss minion (magic drainer)
static func create_void_echo(n: String, lvl: int = 9) -> FighterData:
	var f := EH.base(n, "Void Echo", lvl)
	f.health = EH.es(90, 112, 3, 6, lvl, 9); f.max_health = f.health
	f.mana = EH.es(11, 14, 1, 2, lvl, 9); f.max_mana = f.mana
	f.physical_attack = EH.es(10, 14, 0, 2, lvl, 9)
	f.physical_defense = EH.es(12, 16, 1, 2, lvl, 9)
	f.magic_attack = EH.es(27, 33, 1, 3, lvl, 9)
	f.magic_defense = EH.es(15, 19, 1, 2, lvl, 9)
	f.speed = EH.es(26, 31, 1, 2, lvl, 9)
	f.crit_chance = 21; f.crit_damage = 1; f.dodge_chance = 17
	f.abilities = [EAB.void_echo_drain(), EAB.hollow_wail()]
	f.flavor_text = "The psychic residue left by the Nightmare's passage through the dreamscape. It repeats fragments of devoured thoughts and feeds on the vitality of the living."
	return f
