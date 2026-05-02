class_name EnemyDBS2

## Story 2 enemy factory. Separate from EnemyDB to avoid touching Story 1 balance.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const EAB := preload("res://scripts/data/story2/enemy_ability_db_s2.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# Cave creatures (Progression 0)
# =============================================================================

static func create_glow_worm(n: String, lvl: int = 1) -> FighterData:
	var f := EH.base(n, "Glow Worm", lvl)
	f.health = EH.es(29, 38, 2, 4, lvl, 1); f.max_health = f.health
	f.mana = EH.es(8, 11, 1, 2, lvl, 1); f.max_mana = f.mana
	f.physical_attack = EH.es(12, 15, 0, 2, lvl, 1)
	f.physical_defense = EH.es(5, 8, 0, 1, lvl, 1)
	f.magic_attack = EH.es(19, 22, 1, 3, lvl, 1)
	f.magic_defense = EH.es(9, 12, 1, 2, lvl, 1)
	f.speed = EH.es(21, 26, 1, 3, lvl, 1)
	f.crit_chance = 9; f.crit_damage = 2; f.dodge_chance = 6
	f.abilities = [EAB.luminous_pulse(), EAB.dazzle()]
	f.flavor_text = "A blind, segmented worm that navigates by bioluminescence. Its pulsing glow disorients prey before it strikes."
	return f


static func create_crystal_spider(n: String, lvl: int = 1) -> FighterData:
	var f := EH.base(n, "Crystal Spider", lvl)
	f.health = EH.es(51, 61, 3, 6, lvl, 1); f.max_health = f.health
	f.mana = EH.es(6, 8, 1, 1, lvl, 1); f.max_mana = f.mana
	f.physical_attack = EH.es(20, 23, 1, 3, lvl, 1)
	f.physical_defense = EH.es(10, 13, 1, 2, lvl, 1)
	f.magic_attack = EH.es(7, 10, 0, 1, lvl, 1)
	f.magic_defense = EH.es(8, 11, 1, 2, lvl, 1)
	f.speed = EH.es(19, 24, 1, 2, lvl, 1)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 5
	f.abilities = [EAB.crystal_fang(), EAB.refract()]
	f.flavor_text = "A translucent arachnid with mineral-encrusted legs. Light scatters through its crystalline body, making it hard to track."
	return f


# =============================================================================
# Deep Cavern creatures (Progression 1)
# =============================================================================

static func create_shade_crawler(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Shade Crawler", lvl)
	f.health = EH.es(50, 60, 3, 5, lvl, 2); f.max_health = f.health
	f.mana = EH.es(4, 7, 1, 2, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(18, 22, 1, 3, lvl, 2)
	f.physical_defense = EH.es(10, 13, 1, 2, lvl, 2)
	f.magic_attack = EH.es(16, 19, 1, 2, lvl, 2)
	f.magic_defense = EH.es(6, 9, 1, 2, lvl, 2)
	f.speed = EH.es(26, 32, 2, 3, lvl, 2)
	f.crit_chance = 9; f.crit_damage = 1; f.dodge_chance = 12
	f.abilities = [EAB.shadow_lash(), EAB.dissolve()]
	f.flavor_text = "A flat, many-legged predator that clings to cavern ceilings. It drops silently onto its prey from the darkness above."
	return f


static func create_echo_wisp(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Echo Wisp", lvl)
	f.health = EH.es(37, 45, 2, 4, lvl, 2); f.max_health = f.health
	f.mana = EH.es(7, 9, 1, 2, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(10, 13, 0, 1, lvl, 2)
	f.physical_defense = EH.es(6, 9, 0, 1, lvl, 2)
	f.magic_attack = EH.es(21, 25, 1, 3, lvl, 2)
	f.magic_defense = EH.es(11, 14, 1, 2, lvl, 2)
	f.speed = EH.es(27, 33, 2, 3, lvl, 2)
	f.crit_chance = 9; f.crit_damage = 1; f.dodge_chance = 13
	f.abilities = [EAB.resonance(), EAB.distortion()]
	f.flavor_text = "A flickering orb of sound made visible. It mimics voices of the lost, luring travelers deeper into the caverns."
	return f


# =============================================================================
# Fungal Hollow creatures (Progression 1, alt branch)
# =============================================================================

static func create_spore_stalker(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Spore Stalker", lvl)
	f.health = EH.es(41, 49, 2, 4, lvl, 2); f.max_health = f.health
	f.mana = EH.es(5, 8, 1, 2, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(17, 20, 1, 3, lvl, 2)
	f.physical_defense = EH.es(7, 10, 0, 1, lvl, 2)
	f.magic_attack = EH.es(14, 18, 1, 2, lvl, 2)
	f.magic_defense = EH.es(7, 10, 0, 1, lvl, 2)
	f.speed = EH.es(27, 33, 2, 3, lvl, 2)
	f.crit_chance = 6; f.crit_damage = 1; f.dodge_chance = 10
	f.abilities = [EAB.toxic_dart(), EAB.spore_burst()]
	f.flavor_text = "A gaunt, fungus-riddled creature that moves with unsettling precision. Poisonous barbs line its elongated limbs."
	return f


static func create_fungal_hulk(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Fungal Hulk", lvl)
	f.health = EH.es(62, 73, 4, 6, lvl, 2); f.max_health = f.health
	f.mana = EH.es(4, 7, 1, 1, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(19, 23, 1, 3, lvl, 2)
	f.physical_defense = EH.es(11, 15, 1, 2, lvl, 2)
	f.magic_attack = EH.es(8, 11, 0, 1, lvl, 2)
	f.magic_defense = EH.es(9, 12, 1, 2, lvl, 2)
	f.speed = EH.es(19, 23, 1, 2, lvl, 2)
	f.crit_chance = 5; f.crit_damage = 1; f.dodge_chance = 1
	f.abilities = [EAB.fungal_slam(), EAB.mycelium_shield()]
	f.flavor_text = "A massive creature overgrown with shelf mushrooms and hardened mycelia. Each thundering step shakes loose clouds of spores."
	return f


static func create_cap_wisp(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Cap Wisp", lvl)
	f.health = EH.es(35, 43, 2, 4, lvl, 2); f.max_health = f.health
	f.mana = EH.es(8, 10, 1, 2, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(10, 13, 0, 1, lvl, 2)
	f.physical_defense = EH.es(6, 9, 0, 1, lvl, 2)
	f.magic_attack = EH.es(20, 24, 1, 3, lvl, 2)
	f.magic_defense = EH.es(11, 14, 1, 2, lvl, 2)
	f.speed = EH.es(25, 31, 2, 3, lvl, 2)
	f.crit_chance = 6; f.crit_damage = 1; f.dodge_chance = 7
	f.abilities = [EAB.hallucinate(), EAB.phantasmal_haze()]
	f.flavor_text = "A drifting mushroom cap wreathed in hallucinogenic mist. Those who breathe its spores see things that were never there."
	return f


# =============================================================================
# Deep Cavern creatures - alt (Progression 1)
# =============================================================================

static func create_cavern_snapper(n: String, lvl: int = 2) -> FighterData:
	var f := EH.base(n, "Cavern Snapper", lvl)
	f.health = EH.es(56, 66, 3, 5, lvl, 2); f.max_health = f.health
	f.mana = EH.es(3, 6, 0, 1, lvl, 2); f.max_mana = f.mana
	f.physical_attack = EH.es(20, 24, 1, 3, lvl, 2)
	f.physical_defense = EH.es(13, 16, 1, 2, lvl, 2)
	f.magic_attack = EH.es(7, 10, 0, 1, lvl, 2)
	f.magic_defense = EH.es(5, 8, 1, 2, lvl, 2)
	f.speed = EH.es(17, 21, 1, 2, lvl, 2)
	f.crit_chance = 8; f.crit_damage = 2; f.dodge_chance = 3
	f.abilities = [EAB.jaw_clamp(), EAB.stone_shell()]
	f.flavor_text = "An armored reptile the size of a barrel, half-buried in gravel. Its jaws are slow to open but impossible to pry apart once they close."
	return f


# =============================================================================
# Tranquil Pool creatures (Progression 2, alt branch)
# =============================================================================

static func create_cave_eel(n: String, lvl: int = 3) -> FighterData:
	var f := EH.base(n, "Cave Eel", lvl)
	f.health = EH.es(41, 49, 2, 4, lvl, 3); f.max_health = f.health
	f.mana = EH.es(9, 11, 1, 2, lvl, 3); f.max_mana = f.mana
	f.physical_attack = EH.es(20, 23, 1, 3, lvl, 3)
	f.physical_defense = EH.es(4, 7, 0, 1, lvl, 3)
	f.magic_attack = EH.es(19, 22, 1, 2, lvl, 3)
	f.magic_defense = EH.es(11, 14, 1, 2, lvl, 3)
	f.speed = EH.es(30, 36, 2, 3, lvl, 3)
	f.crit_chance = 14; f.crit_damage = 2; f.dodge_chance = 12
	f.abilities = [EAB.jolt(), EAB.arc_flash()]
	f.flavor_text = "A sinuous, eyeless fish that slithers through subterranean pools. Bioelectric organs along its flanks discharge painful jolts."
	return f


static func create_blind_angler(n: String, lvl: int = 3) -> FighterData:
	var f := EH.base(n, "Blind Angler", lvl)
	f.health = EH.es(52, 63, 3, 5, lvl, 3); f.max_health = f.health
	f.mana = EH.es(6, 8, 1, 2, lvl, 3); f.max_mana = f.mana
	f.physical_attack = EH.es(12, 14, 0, 2, lvl, 3)
	f.physical_defense = EH.es(6, 9, 1, 2, lvl, 3)
	f.magic_attack = EH.es(20, 24, 1, 3, lvl, 3)
	f.magic_defense = EH.es(12, 16, 1, 2, lvl, 3)
	f.speed = EH.es(20, 26, 1, 2, lvl, 3)
	f.crit_chance = 7; f.crit_damage = 1; f.dodge_chance = 8
	f.abilities = [EAB.lure_light(), EAB.abyssal_gaze()]
	f.flavor_text = "A deep-water predator that dangles a glowing lure from its head. Its blank, milky eyes conceal a piercing psychic awareness."
	return f


static func create_silt_lurker(n: String, lvl: int = 3) -> FighterData:
	var f := EH.base(n, "Silt Lurker", lvl)
	f.health = EH.es(58, 68, 3, 5, lvl, 3); f.max_health = f.health
	f.mana = EH.es(4, 7, 1, 1, lvl, 3); f.max_mana = f.mana
	f.physical_attack = EH.es(23, 27, 2, 3, lvl, 3)
	f.physical_defense = EH.es(10, 13, 1, 2, lvl, 3)
	f.magic_attack = EH.es(7, 10, 0, 1, lvl, 3)
	f.magic_defense = EH.es(8, 11, 0, 1, lvl, 3)
	f.speed = EH.es(30, 36, 2, 3, lvl, 3)
	f.crit_chance = 14; f.crit_damage = 2; f.dodge_chance = 14
	f.abilities = [EAB.ambush_bite(), EAB.murky_retreat()]
	f.flavor_text = "A flat, mud-colored predator that lies motionless on the pool floor. When prey wades close, it strikes with terrifying speed and vanishes back into the silt."
	return f


# =============================================================================
# Torch Chamber dwellers (Progression 2, alt branch)
# =============================================================================

static func create_cave_dweller(n: String, lvl: int = 3) -> FighterData:
	var f := EH.base(n, "Cave Dweller", lvl)
	f.health = EH.es(63, 78, 3, 5, lvl, 3); f.max_health = f.health
	f.mana = EH.es(4, 7, 1, 1, lvl, 3); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 25, 2, 3, lvl, 3)
	f.physical_defense = EH.es(12, 16, 1, 2, lvl, 3)
	f.magic_attack = EH.es(9, 12, 0, 1, lvl, 3)
	f.magic_defense = EH.es(8, 11, 1, 2, lvl, 3)
	f.speed = EH.es(20, 26, 1, 2, lvl, 3)
	f.crit_chance = 7; f.crit_damage = 1; f.dodge_chance = 7
	f.abilities = [EAB.crude_axe(), EAB.rock_toss()]
	f.flavor_text = "A hunched, pale humanoid adapted to perpetual darkness. It fashions crude weapons from bone and stone."
	return f


static func create_tunnel_shaman(n: String, lvl: int = 3) -> FighterData:
	var f := EH.base(n, "Tunnel Shaman", lvl)
	f.health = EH.es(51, 60, 2, 4, lvl, 3); f.max_health = f.health
	f.mana = EH.es(9, 11, 1, 2, lvl, 3); f.max_mana = f.mana
	f.physical_attack = EH.es(10, 13, 0, 1, lvl, 3)
	f.physical_defense = EH.es(8, 11, 0, 2, lvl, 3)
	f.magic_attack = EH.es(21, 25, 1, 3, lvl, 3)
	f.magic_defense = EH.es(13, 17, 1, 2, lvl, 3)
	f.speed = EH.es(23, 29, 1, 2, lvl, 3)
	f.crit_chance = 9; f.crit_damage = 1; f.dodge_chance = 11
	f.abilities = [EAB.hex_flame(), EAB.ward_bones()]
	f.flavor_text = "An elder cave dweller draped in carved bone fetishes. It channels the strange energies that seep through the deep rock."
	return f


static func create_burrow_scout(n: String, lvl: int = 3) -> FighterData:
	var f := EH.base(n, "Burrow Scout", lvl)
	f.health = EH.es(45, 53, 2, 4, lvl, 3); f.max_health = f.health
	f.mana = EH.es(5, 8, 1, 1, lvl, 3); f.max_mana = f.mana
	f.physical_attack = EH.es(20, 24, 1, 3, lvl, 3)
	f.physical_defense = EH.es(7, 10, 0, 1, lvl, 3)
	f.magic_attack = EH.es(8, 11, 0, 1, lvl, 3)
	f.magic_defense = EH.es(7, 10, 0, 1, lvl, 3)
	f.speed = EH.es(29, 35, 2, 3, lvl, 3)
	f.crit_chance = 11; f.crit_damage = 2; f.dodge_chance = 21
	f.abilities = [EAB.dart_strike(), EAB.smoke_bomb()]
	f.flavor_text = "A wiry, quick-footed cave dweller that patrols the outer tunnels. It strikes from the shadows and vanishes before retaliation."
	return f


# =============================================================================
# Cave Exit creatures (Progression 3, post-T1 upgrade)
# =============================================================================

static func create_cave_maw(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Cave Maw", lvl)
	f.health = EH.es(134, 154, 5, 8, lvl, 3); f.max_health = f.health
	f.mana = EH.es(5, 8, 1, 2, lvl, 3); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 27, 2, 3, lvl, 3)
	f.physical_defense = EH.es(15, 19, 1, 3, lvl, 3)
	f.magic_attack = EH.es(5, 8, 0, 2, lvl, 3)
	f.magic_defense = EH.es(11, 15, 1, 2, lvl, 3)
	f.speed = EH.es(18, 25, 1, 2, lvl, 3)
	f.crit_chance = 14; f.crit_damage = 2; f.dodge_chance = 12
	f.abilities = [EAB.gnash(), EAB.swallow(), EAB.tremor()]
	f.flavor_text = "A gargantuan lamprey-like beast that lurks near the cave exit. Its circular jaws can swallow a person whole."
	return f


static func create_vein_leech(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Vein Leech", lvl)
	f.health = EH.es(90, 105, 3, 5, lvl, 3); f.max_health = f.health
	f.mana = EH.es(4, 7, 1, 2, lvl, 3); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 27, 2, 3, lvl, 3)
	f.physical_defense = EH.es(9, 12, 1, 2, lvl, 3)
	f.magic_attack = EH.es(6, 9, 0, 2, lvl, 3)
	f.magic_defense = EH.es(8, 11, 1, 2, lvl, 3)
	f.speed = EH.es(23, 29, 1, 3, lvl, 3)
	f.crit_chance = 11; f.crit_damage = 2; f.dodge_chance = 16
	f.abilities = [EAB.latch(), EAB.siphon_glow()]
	f.flavor_text = "A bloated parasitic worm that clings to mineral veins. It drains both blood and the faint luminescence from living things."
	return f


static func create_stone_moth(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Stone Moth", lvl)
	f.health = EH.es(70, 80, 2, 4, lvl, 3); f.max_health = f.health
	f.mana = EH.es(7, 9, 1, 2, lvl, 3); f.max_mana = f.mana
	f.physical_attack = EH.es(9, 12, 0, 2, lvl, 3)
	f.physical_defense = EH.es(7, 10, 0, 1, lvl, 3)
	f.magic_attack = EH.es(21, 27, 1, 3, lvl, 3)
	f.magic_defense = EH.es(13, 17, 1, 2, lvl, 3)
	f.speed = EH.es(26, 32, 2, 3, lvl, 3)
	f.crit_chance = 9; f.crit_damage = 1; f.dodge_chance = 18
	f.abilities = [EAB.petrify_pulse(), EAB.wing_dust()]
	f.flavor_text = "A large moth with wings of calcite and granite dust. Its petrifying scales turn flesh to stone on contact."
	return f
