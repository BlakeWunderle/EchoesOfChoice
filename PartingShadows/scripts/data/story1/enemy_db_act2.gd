class_name EnemyDBAct2

## Act II enemy factory (Progression 3-7): wilderness, shore, branch battles, cemetery.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")
const EAB := preload("res://scripts/data/story1/enemy_ability_db.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# Act II enemies (Progression 3-7)
# HP buffed +10-14% to compensate for CD 2 minimum / 3rd base ability changes.
# =============================================================================

static func create_raider(n: String, lvl: int = 4) -> FighterData:
	var f := EH.base(n, "Raider", lvl)
	f.health = EH.es(140, 161, 4, 7, lvl, 4); f.max_health = f.health
	f.mana = EH.es(6, 8, 1, 2, lvl, 4); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 30, 2, 3, lvl, 4)
	f.physical_defense = EH.es(11, 15, 1, 2, lvl, 4)
	f.magic_attack = EH.es(4, 8, 0, 2, lvl, 4)
	f.magic_defense = EH.es(12, 16, 1, 2, lvl, 4)
	f.speed = EH.es(24, 33, 1, 3, lvl, 4)
	f.crit_chance = 24; f.crit_damage = 2; f.dodge_chance = 15
	f.abilities = [EAB.cleave(), EAB.war_cry()]
	f.flavor_text = "Hardened marauders who pillage the borderlands without mercy."
	return f

static func create_orc(n: String, lvl: int = 4) -> FighterData:
	var f := EH.base(n, "Orc", lvl)
	f.health = EH.es(170, 198, 5, 8, lvl, 4); f.max_health = f.health
	f.mana = EH.es(5, 7, 1, 2, lvl, 4); f.max_mana = f.mana
	f.physical_attack = EH.es(27, 35, 2, 4, lvl, 4)
	f.physical_defense = EH.es(14, 18, 1, 3, lvl, 4)
	f.magic_attack = EH.es(4, 7, 0, 1, lvl, 4)
	f.magic_defense = EH.es(13, 17, 1, 2, lvl, 4)
	f.speed = EH.es(23, 29, 1, 2, lvl, 4)
	f.crit_chance = 20; f.crit_damage = 3; f.dodge_chance = 12
	f.abilities = [EAB.crush(), EAB.thick_skin()]
	f.flavor_text = "Towering brutes whose raw strength can crack stone. Slow to think, quick to rage."
	return f

static func create_troll(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Troll", lvl)
	f.health = EH.es(170, 195, 6, 10, lvl, 5); f.max_health = f.health
	f.mana = EH.es(16, 19, 1, 2, lvl, 5); f.max_mana = f.mana
	f.physical_attack = EH.es(40, 49, 2, 3, lvl, 5)
	f.physical_defense = EH.es(12, 16, 1, 3, lvl, 5)
	f.magic_attack = EH.es(5, 9, 0, 1, lvl, 5)
	f.magic_defense = EH.es(10, 14, 1, 2, lvl, 5)
	f.speed = EH.es(27, 34, 1, 2, lvl, 5)
	f.crit_chance = 16; f.crit_damage = 2; f.dodge_chance = 11
	f.abilities = [EAB.boulder_fist(), EAB.stomp()]
	f.flavor_text = "A massive brute that swings boulders like fists. What it lacks in wit it makes up in raw, crushing force."
	return f

static func create_harpy(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Harpy", lvl)
	f.health = EH.es(115, 134, 4, 7, lvl, 5); f.max_health = f.health
	f.mana = EH.es(10, 13, 1, 2, lvl, 5); f.max_mana = f.mana
	f.physical_attack = EH.es(18, 24, 2, 3, lvl, 5)
	f.physical_defense = EH.es(11, 15, 1, 2, lvl, 5)
	f.magic_attack = EH.es(31, 37, 2, 3, lvl, 5)
	f.magic_defense = EH.es(14, 18, 1, 2, lvl, 5)
	f.speed = EH.es(31, 39, 2, 3, lvl, 5)
	f.crit_chance = 16; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [EAB.talon_rake(), EAB.gale_buffet(), EAB.shriek()]
	f.flavor_text = "Winged terrors that dive from above, raking with razor talons and hurling cutting wind."
	return f

static func create_witch(n: String, lvl: int = 4) -> FighterData:
	var f := EH.base(n, "Witch", lvl)
	f.health = EH.es(105, 130, 4, 8, lvl, 4); f.max_health = f.health
	f.mana = EH.es(14, 20, 2, 4, lvl, 4); f.max_mana = f.mana
	f.physical_attack = EH.es(16, 21, 1, 2, lvl, 4)
	f.physical_defense = EH.es(8, 12, 1, 2, lvl, 4)
	f.magic_attack = EH.es(31, 40, 3, 6, lvl, 4)
	f.magic_defense = EH.es(18, 26, 2, 4, lvl, 4)
	f.speed = EH.es(26, 32, 1, 2, lvl, 4)
	f.crit_chance = 13; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.enemy_hex(), EAB.bramble(), EAB.dark_blessing()]
	f.flavor_text = "Reclusive casters who draw power from the deep woods. Their curses linger long after battle."
	return f

static func create_wisp(n: String, lvl: int = 4) -> FighterData:
	var f := EH.base(n, "Wisp", lvl)
	f.health = EH.es(75, 95, 4, 8, lvl, 4); f.max_health = f.health
	f.mana = EH.es(10, 17, 1, 3, lvl, 4); f.max_mana = f.mana
	f.physical_attack = EH.es(13, 18, 1, 2, lvl, 4)
	f.physical_defense = EH.es(6, 10, 1, 2, lvl, 4)
	f.magic_attack = EH.es(31, 37, 3, 5, lvl, 4)
	f.magic_defense = EH.es(14, 20, 1, 3, lvl, 4)
	f.speed = EH.es(28, 38, 2, 3, lvl, 4)
	f.crit_chance = 10; f.crit_damage = 1; f.dodge_chance = 11
	f.abilities = [EAB.lure(), EAB.bewitch()]
	f.flavor_text = "Flickering motes of pale light that drift through the marshes, leading the unwary astray."
	return f

static func create_treant(n: String, lvl: int = 4) -> FighterData:
	var f := EH.base(n, "Treant", lvl)
	f.health = EH.es(80, 100, 3, 8, lvl, 4); f.max_health = f.health
	f.mana = EH.es(14, 23, 1, 3, lvl, 4); f.max_mana = f.mana
	f.physical_attack = EH.es(25, 30, 2, 4, lvl, 4)
	f.physical_defense = EH.es(7, 12, 1, 2, lvl, 4)
	f.magic_attack = EH.es(13, 19, 1, 2, lvl, 4)
	f.magic_defense = EH.es(15, 21, 1, 2, lvl, 4)
	f.speed = EH.es(25, 36, 1, 3, lvl, 4)
	f.crit_chance = 16; f.crit_damage = 1; f.dodge_chance = 14
	f.abilities = [EAB.thorn(), EAB.pollen()]
	f.flavor_text = "A walking tangle of roots and branches, ancient and territorial. It lashes out with barbed limbs to guard its grove."
	return f

static func create_siren(n: String, lvl: int = 4) -> FighterData:
	var f := EH.base(n, "Siren", lvl)
	f.health = EH.es(100, 121, 5, 10, lvl, 4); f.max_health = f.health
	f.mana = EH.es(12, 21, 1, 3, lvl, 3); f.max_mana = f.mana
	f.physical_attack = EH.es(15, 22, 1, 3, lvl, 4)
	f.physical_defense = EH.es(11, 18, 1, 3, lvl, 4)
	f.magic_attack = EH.es(29, 42, 3, 6, lvl, 4)
	f.magic_defense = EH.es(16, 25, 2, 4, lvl, 4)
	f.speed = EH.es(25, 32, 1, 2, lvl, 3)
	f.crit_chance = 11; f.crit_damage = 2; f.dodge_chance = 11
	f.abilities = [EAB.siren_song(), EAB.drowning_wave()]
	f.flavor_text = "Enchanting voices rise from the shore, luring travelers into the crushing tide."
	return f

static func create_merfolk(n: String, lvl: int = 4) -> FighterData:
	var f := EH.base(n, "Merfolk", lvl)
	f.health = EH.es(106, 127, 4, 7, lvl, 4); f.max_health = f.health
	f.mana = EH.es(7, 10, 1, 2, lvl, 4); f.max_mana = f.mana
	f.physical_attack = EH.es(27, 33, 2, 3, lvl, 4)
	f.physical_defense = EH.es(11, 16, 1, 2, lvl, 4)
	f.magic_attack = EH.es(21, 27, 2, 3, lvl, 4)
	f.magic_defense = EH.es(13, 17, 1, 2, lvl, 4)
	f.speed = EH.es(21, 27, 1, 3, lvl, 4)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 9
	f.abilities = [EAB.trident_thrust(), EAB.tidal_splash()]
	f.flavor_text = "Amphibious warriors who guard the coastal shallows with trident and wave."
	return f

static func create_captain(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Captain", lvl)
	f.health = EH.es(175, 213, 5, 11, lvl, 5); f.max_health = f.health
	f.mana = EH.es(14, 30, 1, 4, lvl, 5); f.max_mana = f.mana
	f.physical_attack = EH.es(29, 38, 2, 5, lvl, 5)
	f.physical_defense = EH.es(21, 29, 2, 5, lvl, 5)
	f.magic_attack = EH.es(9, 17, 1, 3, lvl, 5)
	f.magic_defense = EH.es(9, 17, 1, 3, lvl, 5)
	f.speed = EH.es(19, 28, 1, 2, lvl, 5)
	f.crit_chance = 30; f.crit_damage = 2; f.dodge_chance = 12
	f.abilities = [EAB.flintlock(), EAB.cannon_barrage(), EAB.bravado()]
	f.flavor_text = "A seasoned officer who commands through firepower and sheer bravado."
	return f

static func create_pirate(n: String, lvl: int = 4) -> FighterData:
	var f := EH.base(n, "Pirate", lvl)
	f.health = EH.es(137, 171, 5, 11, lvl, 4); f.max_health = f.health
	f.mana = EH.es(10, 23, 1, 4, lvl, 4); f.max_mana = f.mana
	f.physical_attack = EH.es(25, 33, 2, 5, lvl, 4)
	f.physical_defense = EH.es(17, 24, 2, 5, lvl, 4)
	f.magic_attack = EH.es(9, 17, 1, 3, lvl, 4)
	f.magic_defense = EH.es(8, 16, 1, 3, lvl, 4)
	f.speed = EH.es(19, 29, 1, 3, lvl, 4)
	f.crit_chance = 27; f.crit_damage = 3; f.dodge_chance = 10
	f.abilities = [EAB.flintlock(), EAB.dirty_trick()]
	f.flavor_text = "Sea rogues who fight without honor, armed with flintlocks and dirty tricks."
	return f

# --- Prog 5-6: Branch battles ---

static func create_fire_wyrmling(n: String) -> FighterData:
	var f := EH.base(n, "Fire Wyrmling", 6)
	f.health = EH.fixed(135, 152); f.max_health = f.health
	f.mana = EH.fixed(11, 14); f.max_mana = f.mana
	f.physical_attack = EH.fixed(14, 18); f.physical_defense = EH.fixed(15, 19)
	f.magic_attack = EH.fixed(26, 34); f.magic_defense = EH.fixed(19, 23)
	f.speed = EH.fixed(26, 34)
	f.crit_chance = 14; f.crit_damage = 2; f.dodge_chance = 12
	f.abilities = [EAB.dragon_breath(), EAB.tail_strike(), EAB.searing_hiss()]
	f.flavor_text = "Young dragons wreathed in flame. Though small, their breath can melt steel."
	return f

static func create_frost_wyrmling(n: String) -> FighterData:
	var f := EH.base(n, "Frost Wyrmling", 6)
	f.health = EH.fixed(135, 152); f.max_health = f.health
	f.mana = EH.fixed(11, 14); f.max_mana = f.mana
	f.physical_attack = EH.fixed(25, 33); f.physical_defense = EH.fixed(19, 23)
	f.magic_attack = EH.fixed(14, 18); f.magic_defense = EH.fixed(16, 20)
	f.speed = EH.fixed(27, 34)
	f.crit_chance = 13; f.crit_damage = 2; f.dodge_chance = 12
	f.abilities = [EAB.claw(), EAB.tail_strike(), EAB.frost_chains()]
	f.flavor_text = "Icy-scaled dragonkin that freeze the ground beneath their claws."
	return f

static func create_ringmaster(n: String) -> FighterData:
	var f := EH.base(n, "Ringmaster", 6)
	f.health = EH.fixed(128, 144); f.max_health = f.health
	f.mana = EH.fixed(12, 15); f.max_mana = f.mana
	f.physical_attack = EH.fixed(26, 32); f.physical_defense = EH.fixed(12, 16)
	f.magic_attack = EH.fixed(34, 38); f.magic_defense = EH.fixed(12, 16)
	f.speed = EH.fixed(32, 37)
	f.crit_chance = 11; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [EAB.whip_crack(), EAB.showstopper(), EAB.center_ring()]
	f.flavor_text = "The master of ceremonies commands the stage with a crack of his whip and a showman's grin."
	return f

static func create_harlequin(n: String) -> FighterData:
	var f := EH.base(n, "Harlequin", 6)
	f.health = EH.fixed(135, 152); f.max_health = f.health
	f.mana = EH.fixed(12, 15); f.max_mana = f.mana
	f.physical_attack = EH.fixed(20, 24); f.physical_defense = EH.fixed(11, 15)
	f.magic_attack = EH.fixed(39, 45); f.magic_defense = EH.fixed(13, 17)
	f.speed = EH.fixed(30, 35)
	f.crit_chance = 12; f.crit_damage = 2; f.dodge_chance = 19
	f.abilities = [EAB.pantomime_wall(), EAB.prop_drop(), EAB.mime_trap()]
	f.flavor_text = "A grinning performer whose silent antics mask deadly illusions."
	return f

static func create_chanteuse(n: String) -> FighterData:
	var f := EH.base(n, "Chanteuse", 6)
	f.health = EH.fixed(137, 153); f.max_health = f.health
	f.mana = EH.fixed(14, 17); f.max_mana = f.mana
	f.physical_attack = EH.fixed(20, 25); f.physical_defense = EH.fixed(13, 17)
	f.magic_attack = EH.fixed(37, 42); f.magic_defense = EH.fixed(18, 23)
	f.speed = EH.fixed(36, 42)
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 12
	f.abilities = [EAB.aria(), EAB.crescendo(), EAB.cadence()]
	f.flavor_text = "Her voice carries both beauty and ruin. Each note can heal allies or shatter resolve."
	return f

static func create_android(n: String) -> FighterData:
	var f := EH.base(n, "Android", 6)
	f.health = EH.fixed(140, 155); f.max_health = f.health
	f.mana = EH.fixed(12, 15); f.max_mana = f.mana
	f.physical_attack = EH.fixed(31, 37); f.physical_defense = EH.fixed(20, 24)
	f.magic_attack = EH.fixed(33, 37); f.magic_defense = EH.fixed(11, 15)
	f.speed = EH.fixed(35, 41)
	f.crit_chance = 14; f.crit_damage = 2; f.dodge_chance = 5
	f.abilities = [EAB.circuit_burst(), EAB.firewall(), EAB.overdrive()]
	f.flavor_text = "A mechanical soldier powered by arcane circuitry. It feels neither pain nor mercy."
	return f

static func create_machinist(n: String) -> FighterData:
	var f := EH.base(n, "Machinist", 6)
	f.health = EH.fixed(140, 153); f.max_health = f.health
	f.mana = EH.fixed(11, 14); f.max_mana = f.mana
	f.physical_attack = EH.fixed(38, 44); f.physical_defense = EH.fixed(19, 23)
	f.magic_attack = EH.fixed(26, 30); f.magic_defense = EH.fixed(11, 15)
	f.speed = EH.fixed(33, 39)
	f.crit_chance = 13; f.crit_damage = 2; f.dodge_chance = 5
	f.abilities = [EAB.seismic_charge(), EAB.reinforce(), EAB.dismantle()]
	f.flavor_text = "An engineer of war who deploys explosive charges and reinforced plating in equal measure."
	return f

static func create_ironclad(n: String) -> FighterData:
	var f := EH.base(n, "Ironclad", 6)
	f.health = EH.fixed(140, 153); f.max_health = f.health
	f.mana = EH.fixed(11, 15); f.max_mana = f.mana
	f.physical_attack = EH.fixed(37, 41); f.physical_defense = EH.fixed(22, 26)
	f.magic_attack = EH.fixed(20, 24); f.magic_defense = EH.fixed(13, 17)
	f.speed = EH.fixed(28, 33)
	f.crit_chance = 11; f.crit_damage = 2; f.dodge_chance = 5
	f.abilities = [EAB.hammer_blow(), EAB.temper(), EAB.seismic_charge()]
	f.flavor_text = "A walking fortress of hammered steel. Each blow of its hammer rings like a forge bell."
	return f

static func create_commander(n: String) -> FighterData:
	var f := EH.base(n, "Commander", 6)
	f.health = EH.fixed(148, 165); f.max_health = f.health
	f.mana = EH.fixed(11, 15); f.max_mana = f.mana
	f.physical_attack = EH.fixed(29, 41); f.physical_defense = EH.fixed(23, 27)
	f.magic_attack = EH.fixed(12, 16); f.magic_defense = EH.fixed(22, 27)
	f.speed = EH.fixed(29, 37)
	f.crit_chance = 12; f.crit_damage = 2; f.dodge_chance = 6
	f.abilities = [EAB.shield_wall(), EAB.rally_strike(), EAB.war_cry()]
	f.flavor_text = "A veteran field officer whose presence steadies the ranks and turns the tide of battle."
	return f

static func create_draconian(n: String) -> FighterData:
	var f := EH.base(n, "Draconian", 6)
	f.health = EH.fixed(114, 126); f.max_health = f.health
	f.mana = EH.fixed(11, 14); f.max_mana = f.mana
	f.physical_attack = EH.fixed(31, 43); f.physical_defense = EH.fixed(20, 24)
	f.magic_attack = EH.fixed(27, 37); f.magic_defense = EH.fixed(23, 28)
	f.speed = EH.fixed(26, 33)
	f.crit_chance = 12; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.skewer(), EAB.drake_strike(), EAB.scale_guard()]
	f.flavor_text = "Dragonblood warriors whose scaled hides and savage spears make them fearsome on any battlefield."
	return f

static func create_chaplain(n: String) -> FighterData:
	var f := EH.base(n, "Chaplain", 6)
	f.health = EH.fixed(155, 171); f.max_health = f.health
	f.mana = EH.fixed(12, 15); f.max_mana = f.mana
	f.physical_attack = EH.fixed(16, 20); f.physical_defense = EH.fixed(17, 21)
	f.magic_attack = EH.fixed(28, 37); f.magic_defense = EH.fixed(19, 23)
	f.speed = EH.fixed(26, 33)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 6
	f.abilities = [EAB.blessing(), EAB.mace_strike(), EAB.enemy_consecrate()]
	f.flavor_text = "A battle priest who bolsters allies with holy rites while swinging a heavy mace."
	return f

static func create_zombie(n: String, lvl: int = 6) -> FighterData:
	var f := EH.base(n, "Zombie", lvl)
	f.health = EH.es(152, 182, 5, 9, lvl, 6); f.max_health = f.health
	f.mana = EH.es(10, 13, 1, 2, lvl, 6); f.max_mana = f.mana
	f.physical_attack = EH.es(30, 44, 3, 5, lvl, 6)
	f.physical_defense = EH.es(14, 19, 1, 2, lvl, 6)
	f.magic_attack = EH.es(24, 38, 3, 5, lvl, 6)
	f.magic_defense = EH.es(12, 17, 1, 2, lvl, 6)
	f.speed = EH.es(27, 39, 1, 2, lvl, 6)
	f.crit_chance = 14; f.crit_damage = 2; f.dodge_chance = 21
	f.abilities = [EAB.rend(), EAB.putrid_touch(), EAB.devour()]
	f.flavor_text = "Shambling corpses that claw at the living with rotting hands. They feel nothing but hunger."
	return f

static func create_ghoul(n: String, lvl: int = 6) -> FighterData:
	var f := EH.base(n, "Ghoul", lvl)
	f.health = EH.es(142, 161, 3, 6, lvl, 6); f.max_health = f.health
	f.mana = EH.es(10, 13, 1, 2, lvl, 6); f.max_mana = f.mana
	f.physical_attack = EH.es(26, 30, 2, 3, lvl, 6)
	f.physical_defense = EH.es(16, 21, 1, 2, lvl, 6)
	f.magic_attack = EH.es(19, 27, 2, 3, lvl, 6)
	f.magic_defense = EH.es(15, 19, 1, 2, lvl, 6)
	f.speed = EH.es(26, 34, 2, 3, lvl, 6)
	f.crit_chance = 14; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [EAB.claw(), EAB.paralyze(), EAB.devour()]
	f.flavor_text = "Faster and crueler than common undead. Their paralyzing touch leaves victims helpless."
	return f

static func create_shade(n: String, lvl: int = 7) -> FighterData:
	var f := EH.base(n, "Shade", lvl)
	f.health = EH.es(167, 199, 5, 9, lvl, 7); f.max_health = f.health
	f.mana = EH.es(13, 16, 1, 2, lvl, 7); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 27, 1, 3, lvl, 7)
	f.physical_defense = EH.es(11, 15, 1, 2, lvl, 7)
	f.magic_attack = EH.es(35, 46, 3, 5, lvl, 7)
	f.magic_defense = EH.es(19, 25, 2, 4, lvl, 7)
	f.speed = EH.es(33, 41, 2, 4, lvl, 7)
	f.crit_chance = 12; f.crit_damage = 2; f.dodge_chance = 23
	f.abilities = [EAB.umbral_lash(), EAB.shadow_rot(), EAB.dread_whisper()]
	f.flavor_text = "Remnants of souls consumed by darkness. They slip between shadows, whispering despair."
	return f

static func create_wraith(n: String, lvl: int = 7) -> FighterData:
	var f := EH.base(n, "Wraith", lvl)
	f.health = EH.es(189, 221, 5, 9, lvl, 7); f.max_health = f.health
	f.mana = EH.es(14, 17, 1, 2, lvl, 7); f.max_mana = f.mana
	f.physical_attack = EH.es(21, 26, 0, 2, lvl, 7)
	f.physical_defense = EH.es(9, 13, 1, 2, lvl, 7)
	f.magic_attack = EH.es(32, 45, 3, 5, lvl, 7)
	f.magic_defense = EH.es(18, 24, 2, 3, lvl, 7)
	f.speed = EH.es(29, 37, 2, 4, lvl, 7)
	f.crit_chance = 14; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [EAB.soul_drain(), EAB.death_wither(), EAB.terrify()]
	f.flavor_text = "Spectral horrors that drain the life force of the living. Even seasoned warriors tremble at their approach."
	return f

static func create_boneguard(n: String, lvl: int = 7) -> FighterData:
	var f := EH.base(n, "Boneguard", lvl)
	f.health = EH.es(194, 226, 5, 9, lvl, 7); f.max_health = f.health
	f.mana = EH.es(10, 13, 1, 2, lvl, 7); f.max_mana = f.mana
	f.physical_attack = EH.es(34, 45, 2, 4, lvl, 7)
	f.physical_defense = EH.es(22, 28, 2, 4, lvl, 7)
	f.magic_attack = EH.es(12, 16, 1, 2, lvl, 7)
	f.magic_defense = EH.es(12, 16, 1, 2, lvl, 7)
	f.speed = EH.es(27, 35, 1, 3, lvl, 7)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EAB.rusted_cleave(), EAB.grave_charge(), EAB.deathless_guard()]
	f.flavor_text = "The remains of an outpost guard, still clutching its weapon. Whatever raised it kept the muscle memory intact."
	return f
