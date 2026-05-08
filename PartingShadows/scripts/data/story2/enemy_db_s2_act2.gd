class_name EnemyDBS2Act2

## Story 2 Act II enemy factory: coastal and surface threats.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const EAB := preload("res://scripts/data/story2/enemy_ability_db_s2.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# Pre-upgrade enemies (Tier 1, levels 5-6)
# =============================================================================

static func create_driftwood_bandit(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Driftwood Bandit", lvl)
	f.health = EH.es(196, 226, 4, 7, lvl, 5); f.max_health = f.health
	f.mana = EH.es(5, 7, 1, 2, lvl, 5); f.max_mana = f.mana
	f.physical_attack = EH.es(30, 43, 2, 3, lvl, 5)
	f.physical_defense = EH.es(17, 21, 1, 2, lvl, 5)
	f.magic_attack = EH.es(4, 7, 0, 1, lvl, 5)
	f.magic_defense = EH.es(12, 16, 1, 2, lvl, 5)
	f.speed = EH.es(23, 32, 1, 3, lvl, 5)
	f.crit_chance = 25; f.crit_damage = 2; f.dodge_chance = 21
	f.abilities = [EAB.cutlass_slash(), EAB.pillage_strike()]
	f.flavor_text = "A weathered scavenger who builds weapons from shipwreck debris. Desperate and violent, they prey on anyone who washes ashore."
	return f


static func create_saltrunner_smuggler(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Saltrunner Smuggler", lvl)
	f.health = EH.es(142, 164, 3, 5, lvl, 5); f.max_health = f.health
	f.mana = EH.es(6, 8, 1, 2, lvl, 5); f.max_mana = f.mana
	f.physical_attack = EH.es(30, 42, 2, 3, lvl, 5)
	f.physical_defense = EH.es(15, 18, 1, 2, lvl, 5)
	f.magic_attack = EH.es(6, 9, 0, 1, lvl, 5)
	f.magic_defense = EH.es(9, 12, 1, 2, lvl, 5)
	f.speed = EH.es(28, 38, 2, 3, lvl, 5)
	f.crit_chance = 21; f.crit_damage = 2; f.dodge_chance = 23
	f.abilities = [EAB.throwing_knife(), EAB.salt_blind()]
	f.flavor_text = "A quick-handed smuggler who runs contraband through the coastal caves. They fight dirty and never hesitate to blind their foes with salt."
	return f


static func create_tide_warden(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Tide Warden", lvl)
	f.health = EH.es(200, 228, 4, 7, lvl, 5); f.max_health = f.health
	f.mana = EH.es(6, 8, 1, 2, lvl, 5); f.max_mana = f.mana
	f.physical_attack = EH.es(28, 45, 2, 3, lvl, 5)
	f.physical_defense = EH.es(25, 30, 1, 3, lvl, 5)
	f.magic_attack = EH.es(6, 11, 0, 1, lvl, 5)
	f.magic_defense = EH.es(15, 19, 1, 2, lvl, 5)
	f.speed = EH.es(22, 31, 1, 2, lvl, 5)
	f.crit_chance = 21; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [EAB.harpoon_thrust(), EAB.brace_formation()]
	f.flavor_text = "A heavily armored sentinel who guards the coastal passages. Their loyalty to the sea is absolute, and their harpoon strikes are precise."
	return f


static func create_tideside_channeler(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Tideside Channeler", lvl)
	f.health = EH.es(135, 156, 3, 5, lvl, 5); f.max_health = f.health
	f.mana = EH.es(8, 11, 1, 2, lvl, 5); f.max_mana = f.mana
	f.physical_attack = EH.es(6, 9, 0, 1, lvl, 5)
	f.physical_defense = EH.es(10, 14, 1, 2, lvl, 5)
	f.magic_attack = EH.es(33, 39, 2, 3, lvl, 5)
	f.magic_defense = EH.es(15, 19, 1, 2, lvl, 5)
	f.speed = EH.es(30, 36, 2, 3, lvl, 5)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 16
	f.abilities = [EAB.tidewater_bolt(), EAB.tainted_spray()]
	f.flavor_text = "A recluse who draws power from the corrupted tides. Seawater bends to their whispered commands, leaving sickness in its wake."
	return f


static func create_reef_shaman(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Reef Shaman", lvl)
	f.health = EH.es(160, 184, 3, 6, lvl, 5); f.max_health = f.health
	f.mana = EH.es(10, 13, 1, 2, lvl, 5); f.max_mana = f.mana
	f.physical_attack = EH.es(5, 8, 0, 1, lvl, 5)
	f.physical_defense = EH.es(13, 17, 1, 2, lvl, 5)
	f.magic_attack = EH.es(37, 43, 2, 3, lvl, 5)
	f.magic_defense = EH.es(14, 18, 1, 2, lvl, 5)
	f.speed = EH.es(29, 35, 2, 3, lvl, 5)
	f.crit_chance = 14; f.crit_damage = 2; f.dodge_chance = 14
	f.abilities = [EAB.coral_blast(), EAB.coral_barrage()]
	f.flavor_text = "A hermit who communes with the living reef. Coral answers their call, erupting as both blade and storm."
	return f


static func create_blighted_gull(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Blighted Gull", lvl)
	f.health = EH.es(105, 125, 3, 5, lvl, 5); f.max_health = f.health
	f.mana = EH.es(7, 10, 1, 2, lvl, 5); f.max_mana = f.mana
	f.physical_attack = EH.es(8, 11, 0, 2, lvl, 5)
	f.physical_defense = EH.es(9, 12, 0, 1, lvl, 5)
	f.magic_attack = EH.es(26, 33, 1, 3, lvl, 5)
	f.magic_defense = EH.es(11, 14, 1, 2, lvl, 5)
	f.speed = EH.es(30, 37, 2, 3, lvl, 5)
	f.crit_chance = 15; f.crit_damage = 1; f.dodge_chance = 23
	f.abilities = [EAB.peck_frenzy(), EAB.dive_screech()]
	f.flavor_text = "A seabird twisted by the dark influence bleeding from the lighthouse. Its feathers are matted with tar-like corruption."
	return f


static func create_shore_crawler(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Shore Crawler", lvl)
	f.health = EH.es(148, 170, 4, 7, lvl, 5); f.max_health = f.health
	f.mana = EH.es(5, 7, 1, 1, lvl, 5); f.max_mana = f.mana
	f.physical_attack = EH.es(38, 47, 2, 4, lvl, 5)
	f.physical_defense = EH.es(19, 24, 1, 3, lvl, 5)
	f.magic_attack = EH.es(4, 7, 0, 1, lvl, 5)
	f.magic_defense = EH.es(14, 18, 1, 2, lvl, 5)
	f.speed = EH.es(18, 25, 1, 2, lvl, 5)
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 15
	f.abilities = [EAB.crushing_claw(), EAB.chitin_shell()]
	f.flavor_text = "A massive crustacean that drags itself along the rocky shore. Its barnacle-encrusted shell can withstand tremendous punishment."
	return f


static func create_warped_hound(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Warped Hound", lvl)
	f.health = EH.es(131, 152, 3, 5, lvl, 5); f.max_health = f.health
	f.mana = EH.es(6, 8, 1, 2, lvl, 5); f.max_mana = f.mana
	f.physical_attack = EH.es(35, 44, 2, 4, lvl, 5)
	f.physical_defense = EH.es(14, 18, 1, 2, lvl, 5)
	f.magic_attack = EH.es(25, 32, 2, 3, lvl, 5)
	f.magic_defense = EH.es(9, 12, 0, 1, lvl, 5)
	f.speed = EH.es(29, 36, 2, 3, lvl, 5)
	f.crit_chance = 22; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [EAB.feral_lunge(), EAB.brackish_howl()]
	f.flavor_text = "A feral dog warped by prolonged exposure to corrupted tidewater. Its body is gaunt and its eyes burn with unnatural hunger."
	return f


# =============================================================================
# Post-upgrade enemies (Tier 2, levels 8-10)
# =============================================================================

static func create_blackwater_captain(n: String, lvl: int = 8) -> FighterData:
	var f := EH.base(n, "Blackwater Captain", lvl)
	f.health = EH.es(360, 411, 6, 9, lvl, 8); f.max_health = f.health
	f.mana = EH.es(8, 11, 1, 2, lvl, 8); f.max_mana = f.mana
	f.physical_attack = EH.es(67, 75, 3, 5, lvl, 8)
	f.physical_defense = EH.es(39, 45, 2, 3, lvl, 8)
	f.magic_attack = EH.es(14, 17, 0, 1, lvl, 8)
	f.magic_defense = EH.es(19, 24, 1, 2, lvl, 8)
	f.speed = EH.es(35, 42, 1, 3, lvl, 8)
	f.crit_chance = 30; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.boarding_axe(), EAB.captains_orders()]
	f.flavor_text = "A ruthless pirate captain who commands the Blackwater fleet. Scars and sea salt have hardened both body and will."
	return f


static func create_corsair_hexer(n: String, lvl: int = 8) -> FighterData:
	var f := EH.base(n, "Corsair Hexer", lvl)
	f.health = EH.es(272, 308, 5, 7, lvl, 8); f.max_health = f.health
	f.mana = EH.es(11, 13, 1, 2, lvl, 8); f.max_mana = f.mana
	f.physical_attack = EH.es(16, 19, 0, 2, lvl, 8)
	f.physical_defense = EH.es(15, 19, 1, 2, lvl, 8)
	f.magic_attack = EH.es(62, 70, 3, 5, lvl, 8)
	f.magic_defense = EH.es(34, 40, 2, 3, lvl, 8)
	f.speed = EH.es(36, 43, 2, 3, lvl, 8)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EAB.brine_curse(), EAB.corrode_ward()]
	f.flavor_text = "A sea-witch who sails with the corsair fleet, dealing in curses drawn from the deep. Saltwater itself bends to their hexes."
	return f


static func create_bilge_rat(n: String, lvl: int = 8) -> FighterData:
	var f := EH.base(n, "Bilge Rat", lvl)
	f.health = EH.es(235, 268, 4, 6, lvl, 8); f.max_health = f.health
	f.mana = EH.es(7, 9, 1, 2, lvl, 8); f.max_mana = f.mana
	f.physical_attack = EH.es(45, 52, 2, 3, lvl, 8)
	f.physical_defense = EH.es(14, 19, 1, 2, lvl, 8)
	f.magic_attack = EH.es(15, 18, 0, 1, lvl, 8)
	f.magic_defense = EH.es(12, 17, 1, 2, lvl, 8)
	f.speed = EH.es(29, 35, 2, 3, lvl, 8)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.filthy_shiv(), EAB.festering_wound()]
	f.flavor_text = "A wiry scavenger who haunts the lower decks of wrecked ships. Their weapons are filthy and their cuts never heal clean."
	return f


static func create_abyssal_lurker(n: String, lvl: int = 9) -> FighterData:
	var f := EH.base(n, "Abyssal Lurker", lvl)
	f.health = EH.es(309, 352, 6, 9, lvl, 9); f.max_health = f.health
	f.mana = EH.es(14, 16, 1, 2, lvl, 9); f.max_mana = f.mana
	f.physical_attack = EH.es(18, 22, 0, 2, lvl, 9)
	f.physical_defense = EH.es(30, 37, 2, 3, lvl, 9)
	f.magic_attack = EH.es(68, 75, 3, 5, lvl, 9)
	f.magic_defense = EH.es(28, 35, 2, 3, lvl, 9)
	f.speed = EH.es(33, 40, 1, 3, lvl, 9)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.depth_pulse(), EAB.tidal_drain()]
	f.flavor_text = "A deep-sea horror that surfaces near the coast when storms roll in. Its form is barely visible, a suggestion of tentacles and teeth in dark water."
	return f


static func create_stormwrack_raptor(n: String, lvl: int = 8) -> FighterData:
	var f := EH.base(n, "Stormwrack Raptor", lvl)
	f.health = EH.es(266, 302, 5, 8, lvl, 8); f.max_health = f.health
	f.mana = EH.es(11, 14, 1, 2, lvl, 8); f.max_mana = f.mana
	f.physical_attack = EH.es(61, 69, 3, 5, lvl, 8)
	f.physical_defense = EH.es(20, 25, 1, 2, lvl, 8)
	f.magic_attack = EH.es(45, 51, 2, 4, lvl, 8)
	f.magic_defense = EH.es(20, 25, 1, 2, lvl, 8)
	f.speed = EH.es(46, 52, 2, 4, lvl, 8)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 25
	f.abilities = [EAB.lightning_dive(), EAB.static_screech()]
	f.flavor_text = "A massive bird of prey that nests in storm clouds above the coast. Lightning crackles along its wingfeathers as it dives."
	return f


static func create_tidecaller_revenant(n: String, lvl: int = 10) -> FighterData:
	var f := EH.base(n, "Tidecaller Revenant", lvl)
	f.health = EH.es(388, 439, 7, 10, lvl, 10); f.max_health = f.health
	f.mana = EH.es(14, 17, 1, 2, lvl, 10); f.max_mana = f.mana
	f.physical_attack = EH.es(19, 23, 0, 2, lvl, 10)
	f.physical_defense = EH.es(31, 37, 2, 3, lvl, 10)
	f.magic_attack = EH.es(85, 94, 4, 6, lvl, 10)
	f.magic_defense = EH.es(43, 50, 3, 5, lvl, 10)
	f.speed = EH.es(44, 50, 2, 3, lvl, 10)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 17
	f.abilities = [EAB.storm_surge(), EAB.drowning_grasp(), EAB.mist_veil()]
	f.flavor_text = "The restless spirit of a drowned tidecaller, still commanding the waves in death. Storm and sea answer its hollow voice."
	return f


static func create_salt_phantom(n: String, lvl: int = 9) -> FighterData:
	var f := EH.base(n, "Salt Phantom", lvl)
	f.health = EH.es(260, 299, 4, 7, lvl, 9); f.max_health = f.health
	f.mana = EH.es(10, 12, 1, 2, lvl, 9); f.max_mana = f.mana
	f.physical_attack = EH.es(17, 20, 0, 2, lvl, 9)
	f.physical_defense = EH.es(18, 23, 1, 2, lvl, 9)
	f.magic_attack = EH.es(70, 78, 3, 5, lvl, 9)
	f.magic_defense = EH.es(32, 39, 2, 4, lvl, 9)
	f.speed = EH.es(43, 49, 2, 3, lvl, 9)
	f.crit_chance = 17; f.crit_damage = 3; f.dodge_chance = 25
	f.abilities = [EAB.spectral_chill(), EAB.memory_fog()]
	f.flavor_text = "A translucent specter formed from crystallized sea salt and lost grief. It drifts through fog, erasing the memories of those it touches."
	return f


# =============================================================================
# P7: Blackwater Bay (unique enemies)
# Mixed ghost-fighters with DoT and AoE defense shred
# =============================================================================

static func create_drowned_sailor(n: String, lvl: int = 9) -> FighterData:
	var f := EH.base(n, "Drowned Sailor", lvl)
	f.health = EH.es(309, 352, 5, 8, lvl, 9); f.max_health = f.health
	f.mana = EH.es(10, 12, 1, 2, lvl, 9); f.max_mana = f.mana
	f.physical_attack = EH.es(53, 61, 2, 3, lvl, 9)
	f.physical_defense = EH.es(18, 23, 1, 2, lvl, 9)
	f.magic_attack = EH.es(56, 63, 2, 4, lvl, 9)
	f.magic_defense = EH.es(35, 42, 2, 4, lvl, 9)
	f.speed = EH.es(45, 51, 2, 3, lvl, 9)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [EAB.spectral_cutlass(), EAB.waterlogged_grasp()]
	f.flavor_text = "The waterlogged ghost of a sailor claimed by the bay. It fights with the remembered motions of a life spent at sea."
	return f


static func create_depth_horror(n: String, lvl: int = 9) -> FighterData:
	var f := EH.base(n, "Depth Horror", lvl)
	f.health = EH.es(298, 341, 5, 7, lvl, 9); f.max_health = f.health
	f.mana = EH.es(10, 13, 1, 2, lvl, 9); f.max_mana = f.mana
	f.physical_attack = EH.es(38, 45, 2, 3, lvl, 9)
	f.physical_defense = EH.es(30, 36, 2, 3, lvl, 9)
	f.magic_attack = EH.es(65, 73, 3, 5, lvl, 9)
	f.magic_defense = EH.es(28, 34, 2, 3, lvl, 9)
	f.speed = EH.es(45, 51, 2, 3, lvl, 9)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.tentacle_crush(), EAB.abyssal_terror()]
	f.flavor_text = "An ancient thing from the ocean floor, drawn to the surface by the Eye's growing influence. Its mere presence fills the mind with dread."
	return f
