class_name EnemyDBAct5B

## Story 1 Act V Path B enemy factory: ritual anchors, sanctum collapse, stranger undone.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const EAB := preload("res://scripts/data/story1/enemy_ability_db_act5b.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# Ritual Anchor Battle (Prog 12) -- phys tank / magic healer / mixed DPS
# =============================================================================

static func create_sigil_colossus(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Sigil Colossus", lvl)
	f.health = EH.es(580, 640, 7, 9, lvl, 14); f.max_health = f.health
	f.mana = EH.es(32, 38, 2, 3, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(90, 98, 4, 6, lvl, 14)
	f.physical_defense = EH.es(60, 70, 3, 5, lvl, 14)
	f.magic_attack = EH.es(22, 27, 0, 2, lvl, 14)
	f.magic_defense = EH.es(37, 45, 2, 4, lvl, 14)
	f.speed = EH.es(44, 51, 1, 3, lvl, 14)
	f.crit_chance = 10; f.crit_damage = 6; f.dodge_chance = 8
	f.abilities = [EAB.sigil_crush(), EAB.anchor_pulse(), EAB.sigil_ward()]
	f.flavor_text = "A massive construct of carved stone and living sigils. It guards the ritual pillars with relentless force."
	return f


static func create_ritual_conduit(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Ritual Conduit", lvl)
	f.health = EH.es(410, 465, 6, 9, lvl, 14); f.max_health = f.health
	f.mana = EH.es(45, 52, 3, 4, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(22, 27, 0, 2, lvl, 14)
	f.physical_defense = EH.es(31, 39, 2, 3, lvl, 14)
	f.magic_attack = EH.es(84, 92, 3, 5, lvl, 14)
	f.magic_defense = EH.es(51, 59, 3, 5, lvl, 14)
	f.speed = EH.es(54, 61, 2, 4, lvl, 14)
	f.crit_chance = 17; f.crit_damage = 4; f.dodge_chance = 17
	f.abilities = [EAB.conduit_beam(), EAB.mending_sigil(), EAB.ritual_shield()]
	f.flavor_text = "A crystalline pillar that channels ritual energy. It mends damage to the anchors and shields its allies."
	return f


static func create_void_sentinel(n: String, lvl: int = 14) -> FighterData:
	var f := EH.base(n, "Void Sentinel", lvl)
	f.health = EH.es(465, 525, 7, 10, lvl, 14); f.max_health = f.health
	f.mana = EH.es(38, 44, 3, 4, lvl, 14); f.max_mana = f.mana
	f.physical_attack = EH.es(76, 84, 3, 5, lvl, 14)
	f.physical_defense = EH.es(40, 48, 2, 4, lvl, 14)
	f.magic_attack = EH.es(77, 84, 3, 5, lvl, 14)
	f.magic_defense = EH.es(42, 49, 2, 4, lvl, 14)
	f.speed = EH.es(54, 61, 2, 4, lvl, 14)
	f.crit_chance = 20; f.crit_damage = 6; f.dodge_chance = 17
	f.abilities = [EAB.void_slash(), EAB.nullfield()]
	f.flavor_text = "A silent guardian of void energy. Its blade cuts through both armor and magic with equal ease."
	return f


# =============================================================================
# Sanctum Collapse Battle (Prog 13) -- magic burst / fast phys / debuffer
# =============================================================================

static func create_void_horror(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Void Horror", lvl)
	f.health = EH.es(460, 515, 6, 9, lvl, 15); f.max_health = f.health
	f.mana = EH.es(48, 55, 3, 4, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(24, 28, 0, 2, lvl, 15)
	f.physical_defense = EH.es(35, 43, 2, 4, lvl, 15)
	f.magic_attack = EH.es(109, 119, 4, 7, lvl, 15)
	f.magic_defense = EH.es(50, 58, 3, 5, lvl, 15)
	f.speed = EH.es(52, 58, 2, 4, lvl, 15)
	f.crit_chance = 20; f.crit_damage = 5; f.dodge_chance = 15
	f.abilities = [EAB.void_eruption(), EAB.terror_gaze()]
	f.flavor_text = "A howling mass of void energy given terrible form. Its eruptions leave nothing but silence."
	return f


static func create_fractured_shadow(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Fractured Shadow", lvl)
	f.health = EH.es(420, 475, 6, 8, lvl, 15); f.max_health = f.health
	f.mana = EH.es(32, 38, 2, 3, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(107, 117, 3, 5, lvl, 15)
	f.physical_defense = EH.es(29, 36, 2, 3, lvl, 15)
	f.magic_attack = EH.es(24, 28, 0, 2, lvl, 15)
	f.magic_defense = EH.es(32, 40, 2, 3, lvl, 15)
	f.speed = EH.es(61, 69, 3, 5, lvl, 15)
	f.crit_chance = 25; f.crit_damage = 5; f.dodge_chance = 30
	f.abilities = [EAB.shadow_rend(), EAB.flickerstrike(), EAB.speed_siphon()]
	f.flavor_text = "A splintering fragment of the Stranger's essence. It moves faster than sight, striking from every angle."
	return f


static func create_shadow_remnant(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Shadow Remnant", lvl)
	f.health = EH.es(415, 470, 6, 8, lvl, 15); f.max_health = f.health
	f.mana = EH.es(42, 50, 3, 4, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(24, 28, 0, 2, lvl, 15)
	f.physical_defense = EH.es(37, 45, 2, 3, lvl, 15)
	f.magic_attack = EH.es(98, 108, 4, 6, lvl, 15)
	f.magic_defense = EH.es(46, 54, 2, 4, lvl, 15)
	f.speed = EH.es(56, 63, 2, 4, lvl, 15)
	f.crit_chance = 20; f.crit_damage = 5; f.dodge_chance = 17
	f.abilities = [EAB.fading_curse(), EAB.remnant_bolt(), EAB.dissolution()]
	f.flavor_text = "The decaying afterimage of the Stranger's power. It weakens everything it touches, draining strength and resolve."
	return f


# =============================================================================
# Stranger Undone (Prog 13, solo boss -- weaker but faster/crittier)
# =============================================================================

static func create_stranger_undone(n: String, lvl: int = 15) -> FighterData:
	var f := EH.base(n, "Stranger Undone", lvl)
	f.class_id = "StrangerUndone"
	f.health = EH.es(810, 900, 10, 14, lvl, 15); f.max_health = f.health
	f.mana = EH.es(70, 80, 4, 5, lvl, 15); f.max_mana = f.mana
	f.physical_attack = EH.es(78, 88, 2, 4, lvl, 15)
	f.physical_defense = EH.es(55, 64, 2, 4, lvl, 15)
	f.magic_attack = EH.es(88, 98, 3, 5, lvl, 15)
	f.magic_defense = EH.es(58, 67, 2, 4, lvl, 15)
	f.speed = EH.es(79, 89, 3, 5, lvl, 15)
	f.crit_chance = 25; f.crit_damage = 7; f.dodge_chance = 20
	f.abilities = [EAB.shadow_remnant_strike(), EAB.void_drain(), EAB.crumbling_shield(), EAB.final_echo(), EAB.desperation()]
	f.flavor_text = "The Stranger, stripped of ritual power, smaller and more human than ever before. Desperate, fast, and unpredictable."
	return f
