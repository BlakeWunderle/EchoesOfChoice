class_name FighterDBRoles

## Combat role, subtype, and damage type metadata for all 56 player classes.
## Used by sim diagnostics, party composer, and balance reports.

const Meta := preload("res://scripts/data/fighter_db_meta.gd")


# =============================================================================
# Role assignments — keyed by class_id
# =============================================================================

static func get_roles(class_id: String) -> Array:
	match class_id:
		# T0
		"Squire": return [Enums.Role.FIGHTER, Enums.Role.TANK]
		"Mage": return [Enums.Role.CASTER]
		"Entertainer": return [Enums.Role.SUPPORT]
		"Tinker": return [Enums.Role.CASTER]
		"Wildling": return [Enums.Role.HYBRID]
		"Wanderer": return [Enums.Role.FIGHTER, Enums.Role.TANK]
		# T1: Squire
		"Duelist": return [Enums.Role.FIGHTER]
		"Ranger": return [Enums.Role.FIGHTER]
		"MartialArtist": return [Enums.Role.DPS]
		# T1: Mage
		"Invoker": return [Enums.Role.CASTER]
		"Acolyte": return [Enums.Role.SUPPORT, Enums.Role.CASTER]
		# T1: Entertainer
		"Bard": return [Enums.Role.SUPPORT]
		"Dervish": return [Enums.Role.DPS]
		"Orator": return [Enums.Role.SUPPORT]
		# T1: Tinker
		"Artificer": return [Enums.Role.SUPPORT, Enums.Role.FIGHTER]
		"Cosmologist": return [Enums.Role.CASTER]
		"Arithmancer": return [Enums.Role.FIGHTER]
		# T1: Wildling
		"Herbalist": return [Enums.Role.SUPPORT, Enums.Role.HYBRID]
		"Shaman": return [Enums.Role.CASTER]
		"Beastcaller": return [Enums.Role.HYBRID]
		# T1: Wanderer
		"Sentinel": return [Enums.Role.TANK, Enums.Role.SUPPORT]
		"Pathfinder": return [Enums.Role.FIGHTER]
		# T2: Squire
		"Cavalry": return [Enums.Role.DPS]
		"Dragoon": return [Enums.Role.FIGHTER]
		"Mercenary": return [Enums.Role.BURST]
		"Hunter": return [Enums.Role.FIGHTER]
		"Ninja": return [Enums.Role.DPS]
		"Monk": return [Enums.Role.FIGHTER, Enums.Role.SUPPORT]
		# T2: Mage
		"Infernalist": return [Enums.Role.BURST, Enums.Role.CASTER]
		"Tidecaller": return [Enums.Role.SUPPORT, Enums.Role.CASTER]
		"Tempest": return [Enums.Role.CASTER]
		"Paladin": return [Enums.Role.FIGHTER, Enums.Role.SUPPORT, Enums.Role.TANK]
		"Priest": return [Enums.Role.SUPPORT, Enums.Role.CASTER]
		"Warlock": return [Enums.Role.CASTER]
		# T2: Entertainer
		"Warcrier": return [Enums.Role.SUPPORT, Enums.Role.FIGHTER]
		"Minstrel": return [Enums.Role.SUPPORT]
		"Illusionist": return [Enums.Role.DPS]
		"Mime": return [Enums.Role.TANK, Enums.Role.FIGHTER]
		"Laureate": return [Enums.Role.SUPPORT]
		"Elegist": return [Enums.Role.SUPPORT]
		# T2: Tinker
		"Alchemist": return [Enums.Role.SUPPORT]
		"Bombardier": return [Enums.Role.BURST]
		"Chronomancer": return [Enums.Role.SUPPORT, Enums.Role.CASTER]
		"Astronomer": return [Enums.Role.BURST, Enums.Role.CASTER]
		"Automaton": return [Enums.Role.TANK, Enums.Role.FIGHTER]
		"Technomancer": return [Enums.Role.FIGHTER, Enums.Role.CASTER]
		# T2: Wildling
		"Blighter": return [Enums.Role.CASTER]
		"GroveKeeper": return [Enums.Role.SUPPORT, Enums.Role.HYBRID]
		"WitchDoctor": return [Enums.Role.SUPPORT, Enums.Role.CASTER]
		"Spiritwalker": return [Enums.Role.SUPPORT, Enums.Role.CASTER]
		"Falconer": return [Enums.Role.DPS]
		"Shapeshifter": return [Enums.Role.HYBRID, Enums.Role.TANK]
		# T2: Wanderer
		"Bulwark": return [Enums.Role.TANK]
		"Aegis": return [Enums.Role.FIGHTER, Enums.Role.TANK]
		"Trailblazer": return [Enums.Role.FIGHTER]
		"Survivalist": return [Enums.Role.TANK]
		_:
			push_error("Unknown class_id for roles: %s" % class_id)
			return [Enums.Role.FIGHTER]


# =============================================================================
# Subtype assignments
# =============================================================================

static func get_subtypes(class_id: String) -> Array:
	match class_id:
		# T0
		"Squire": return []
		"Mage": return []
		"Entertainer": return [Enums.Subtype.BUFFER]
		"Tinker": return []
		"Wildling": return []
		"Wanderer": return []
		# T1: Squire
		"Duelist": return []
		"Ranger": return []
		"MartialArtist": return []
		# T1: Mage
		"Invoker": return [Enums.Subtype.AOE]
		"Acolyte": return [Enums.Subtype.HEALER, Enums.Subtype.BUFFER]
		# T1: Entertainer
		"Bard": return [Enums.Subtype.HEALER, Enums.Subtype.BUFFER]
		"Dervish": return [Enums.Subtype.DEBUFFER]
		"Orator": return [Enums.Subtype.BUFFER, Enums.Subtype.DEBUFFER]
		# T1: Tinker
		"Artificer": return [Enums.Subtype.HEALER]
		"Cosmologist": return [Enums.Subtype.DEBUFFER]
		"Arithmancer": return []
		# T1: Wildling
		"Herbalist": return [Enums.Subtype.HEALER, Enums.Subtype.DOT]
		"Shaman": return [Enums.Subtype.DEBUFFER]
		"Beastcaller": return []
		# T1: Wanderer
		"Sentinel": return [Enums.Subtype.BUFFER]
		"Pathfinder": return []
		# T2: Squire
		"Cavalry": return [Enums.Subtype.AOE, Enums.Subtype.CRIT]
		"Dragoon": return [Enums.Subtype.AOE]
		"Mercenary": return [Enums.Subtype.GLASS_CANNON, Enums.Subtype.CRIT]
		"Hunter": return [Enums.Subtype.DEBUFFER]
		"Ninja": return [Enums.Subtype.GLASS_CANNON, Enums.Subtype.EVASION, Enums.Subtype.CRIT]
		"Monk": return [Enums.Subtype.HEALER]
		# T2: Mage
		"Infernalist": return [Enums.Subtype.GLASS_CANNON, Enums.Subtype.AOE]
		"Tidecaller": return [Enums.Subtype.HEALER, Enums.Subtype.AOE]
		"Tempest": return [Enums.Subtype.AOE]
		"Paladin": return [Enums.Subtype.HEALER]
		"Priest": return [Enums.Subtype.HEALER, Enums.Subtype.BUFFER]
		"Warlock": return [Enums.Subtype.DEBUFFER, Enums.Subtype.DRAIN]
		# T2: Entertainer
		"Warcrier": return [Enums.Subtype.BUFFER]
		"Minstrel": return [Enums.Subtype.HEALER, Enums.Subtype.BUFFER]
		"Illusionist": return [Enums.Subtype.DEBUFFER, Enums.Subtype.EVASION]
		"Mime": return []
		"Laureate": return [Enums.Subtype.BUFFER, Enums.Subtype.AOE]
		"Elegist": return [Enums.Subtype.DEBUFFER, Enums.Subtype.AOE]
		# T2: Tinker
		"Alchemist": return [Enums.Subtype.HEALER, Enums.Subtype.DOT]
		"Bombardier": return [Enums.Subtype.GLASS_CANNON, Enums.Subtype.AOE]
		"Chronomancer": return [Enums.Subtype.BUFFER, Enums.Subtype.DEBUFFER]
		"Astronomer": return [Enums.Subtype.GLASS_CANNON, Enums.Subtype.AOE]
		"Automaton": return []
		"Technomancer": return [Enums.Subtype.DRAIN]
		# T2: Wildling
		"Blighter": return [Enums.Subtype.DOT]
		"GroveKeeper": return [Enums.Subtype.HEALER, Enums.Subtype.BUFFER]
		"WitchDoctor": return [Enums.Subtype.DEBUFFER, Enums.Subtype.DOT]
		"Spiritwalker": return [Enums.Subtype.HEALER, Enums.Subtype.BUFFER]
		"Falconer": return [Enums.Subtype.GLASS_CANNON]
		"Shapeshifter": return []
		# T2: Wanderer
		"Bulwark": return [Enums.Subtype.BUFFER]
		"Aegis": return []
		"Trailblazer": return [Enums.Subtype.DEBUFFER]
		"Survivalist": return [Enums.Subtype.DRAIN]
		_: return []


# =============================================================================
# Damage type assignments
# =============================================================================

static func get_damage_type(class_id: String) -> Enums.DamageType:
	match class_id:
		# T0
		"Squire": return Enums.DamageType.PHYSICAL
		"Mage": return Enums.DamageType.MAGICAL
		"Entertainer": return Enums.DamageType.MIXED
		"Tinker": return Enums.DamageType.MAGICAL
		"Wildling": return Enums.DamageType.MIXED
		"Wanderer": return Enums.DamageType.PHYSICAL
		# T1: Squire
		"Duelist": return Enums.DamageType.PHYSICAL
		"Ranger": return Enums.DamageType.PHYSICAL
		"MartialArtist": return Enums.DamageType.PHYSICAL
		# T1: Mage
		"Invoker": return Enums.DamageType.MAGICAL
		"Acolyte": return Enums.DamageType.MAGICAL
		# T1: Entertainer
		"Bard": return Enums.DamageType.MIXED
		"Dervish": return Enums.DamageType.MIXED
		"Orator": return Enums.DamageType.MIXED
		# T1: Tinker
		"Artificer": return Enums.DamageType.MIXED
		"Cosmologist": return Enums.DamageType.MAGICAL
		"Arithmancer": return Enums.DamageType.MAGICAL
		# T1: Wildling
		"Herbalist": return Enums.DamageType.MAGICAL
		"Shaman": return Enums.DamageType.MAGICAL
		"Beastcaller": return Enums.DamageType.MIXED
		# T1: Wanderer
		"Sentinel": return Enums.DamageType.PHYSICAL
		"Pathfinder": return Enums.DamageType.MIXED
		# T2: Squire
		"Cavalry": return Enums.DamageType.PHYSICAL
		"Dragoon": return Enums.DamageType.MIXED
		"Mercenary": return Enums.DamageType.PHYSICAL
		"Hunter": return Enums.DamageType.PHYSICAL
		"Ninja": return Enums.DamageType.PHYSICAL
		"Monk": return Enums.DamageType.MIXED
		# T2: Mage
		"Infernalist": return Enums.DamageType.MAGICAL
		"Tidecaller": return Enums.DamageType.MAGICAL
		"Tempest": return Enums.DamageType.MAGICAL
		"Paladin": return Enums.DamageType.MIXED
		"Priest": return Enums.DamageType.MAGICAL
		"Warlock": return Enums.DamageType.MAGICAL
		# T2: Entertainer
		"Warcrier": return Enums.DamageType.PHYSICAL
		"Minstrel": return Enums.DamageType.MAGICAL
		"Illusionist": return Enums.DamageType.MAGICAL
		"Mime": return Enums.DamageType.MIXED
		"Laureate": return Enums.DamageType.MAGICAL
		"Elegist": return Enums.DamageType.MAGICAL
		# T2: Tinker
		"Alchemist": return Enums.DamageType.MAGICAL
		"Bombardier": return Enums.DamageType.MAGICAL
		"Chronomancer": return Enums.DamageType.MAGICAL
		"Astronomer": return Enums.DamageType.MAGICAL
		"Automaton": return Enums.DamageType.MAGICAL
		"Technomancer": return Enums.DamageType.MIXED
		# T2: Wildling
		"Blighter": return Enums.DamageType.MAGICAL
		"GroveKeeper": return Enums.DamageType.MAGICAL
		"WitchDoctor": return Enums.DamageType.MAGICAL
		"Spiritwalker": return Enums.DamageType.MAGICAL
		"Falconer": return Enums.DamageType.PHYSICAL
		"Shapeshifter": return Enums.DamageType.PHYSICAL
		# T2: Wanderer
		"Bulwark": return Enums.DamageType.PHYSICAL
		"Aegis": return Enums.DamageType.MIXED
		"Trailblazer": return Enums.DamageType.MIXED
		"Survivalist": return Enums.DamageType.MIXED
		_: return Enums.DamageType.PHYSICAL


# =============================================================================
# Defense type assignments (computed from phys_def/mag_def using 60/40 rule)
# =============================================================================

static func get_defense_type(class_id: String) -> Enums.DamageType:
	match class_id:
		# T0
		"Squire": return Enums.DamageType.PHYSICAL
		"Mage": return Enums.DamageType.MAGICAL
		"Entertainer": return Enums.DamageType.MIXED
		"Tinker": return Enums.DamageType.MAGICAL
		"Wildling": return Enums.DamageType.MIXED
		"Wanderer": return Enums.DamageType.MIXED
		# T1: Squire
		"Duelist": return Enums.DamageType.PHYSICAL
		"Ranger": return Enums.DamageType.MIXED
		"MartialArtist": return Enums.DamageType.PHYSICAL
		# T1: Mage
		"Invoker": return Enums.DamageType.MIXED
		"Acolyte": return Enums.DamageType.MIXED
		# T1: Entertainer
		"Bard": return Enums.DamageType.MIXED
		"Dervish": return Enums.DamageType.MIXED
		"Orator": return Enums.DamageType.MIXED
		# T1: Tinker
		"Artificer": return Enums.DamageType.PHYSICAL
		"Cosmologist": return Enums.DamageType.MIXED
		"Arithmancer": return Enums.DamageType.MIXED
		# T1: Wildling
		"Herbalist": return Enums.DamageType.PHYSICAL
		"Shaman": return Enums.DamageType.MIXED
		"Beastcaller": return Enums.DamageType.MIXED
		# T1: Wanderer
		"Sentinel": return Enums.DamageType.MIXED
		"Pathfinder": return Enums.DamageType.MIXED
		# T2: Squire
		"Cavalry": return Enums.DamageType.PHYSICAL
		"Dragoon": return Enums.DamageType.MIXED
		"Mercenary": return Enums.DamageType.PHYSICAL
		"Hunter": return Enums.DamageType.PHYSICAL
		"Ninja": return Enums.DamageType.MIXED
		"Monk": return Enums.DamageType.MIXED
		# T2: Mage
		"Infernalist": return Enums.DamageType.MIXED
		"Tidecaller": return Enums.DamageType.PHYSICAL
		"Tempest": return Enums.DamageType.MIXED
		"Paladin": return Enums.DamageType.MIXED
		"Priest": return Enums.DamageType.PHYSICAL
		"Warlock": return Enums.DamageType.MIXED
		# T2: Entertainer
		"Warcrier": return Enums.DamageType.MIXED
		"Minstrel": return Enums.DamageType.MIXED
		"Illusionist": return Enums.DamageType.PHYSICAL
		"Mime": return Enums.DamageType.MIXED
		"Laureate": return Enums.DamageType.MIXED
		"Elegist": return Enums.DamageType.MIXED
		# T2: Tinker
		"Alchemist": return Enums.DamageType.MIXED
		"Bombardier": return Enums.DamageType.MIXED
		"Chronomancer": return Enums.DamageType.MIXED
		"Astronomer": return Enums.DamageType.MIXED
		"Automaton": return Enums.DamageType.MIXED
		"Technomancer": return Enums.DamageType.MIXED
		# T2: Wildling
		"Blighter": return Enums.DamageType.MIXED
		"GroveKeeper": return Enums.DamageType.PHYSICAL
		"WitchDoctor": return Enums.DamageType.PHYSICAL
		"Spiritwalker": return Enums.DamageType.MIXED
		"Falconer": return Enums.DamageType.PHYSICAL
		"Shapeshifter": return Enums.DamageType.PHYSICAL
		# T2: Wanderer
		"Bulwark": return Enums.DamageType.MIXED
		"Aegis": return Enums.DamageType.MIXED
		"Trailblazer": return Enums.DamageType.MIXED
		"Survivalist": return Enums.DamageType.MIXED
		_: return Enums.DamageType.MIXED


# =============================================================================
# Helpers
# =============================================================================

static func has_role(class_id: String, role: Enums.Role) -> bool:
	return role in get_roles(class_id)


static func has_subtype(class_id: String, subtype: Enums.Subtype) -> bool:
	return subtype in get_subtypes(class_id)


## True if the class has no damage role (no DPS, FIGHTER, or BURST).
## Pure SUPPORT or TANK classes are expected to have low offense.
static func is_low_offense_expected(class_id: String) -> bool:
	var roles := get_roles(class_id)
	for r: Enums.Role in roles:
		if r == Enums.Role.DPS or r == Enums.Role.FIGHTER or r == Enums.Role.BURST:
			return false
	return true


## True if the class has the GLASS_CANNON subtype (expected to take high damage).
static func is_high_damage_taken_expected(class_id: String) -> bool:
	return Enums.Subtype.GLASS_CANNON in get_subtypes(class_id)


## Display label like "Fighter / Support (Healer) - Magical".
static func get_label(class_id: String) -> String:
	var role_names := PackedStringArray()
	for r: Enums.Role in get_roles(class_id):
		role_names.append(_role_name(r))
	var label: String = " / ".join(role_names)

	var sub_names := PackedStringArray()
	for s: Enums.Subtype in get_subtypes(class_id):
		sub_names.append(_subtype_name(s))
	if not sub_names.is_empty():
		label += " (%s)" % ", ".join(sub_names)

	label += " - %s" % _damage_type_name(get_damage_type(class_id))
	return label


## Reverse lookup: display name -> class_id.
## Needed because sim diagnostics key on character_type (display name).
static var _reverse_map: Dictionary = {}

static func get_class_id_from_display_name(display_name: String) -> String:
	if _reverse_map.is_empty():
		for cid: String in _ALL_CLASS_IDS:
			_reverse_map[Meta.get_display_name(cid)] = cid
	return _reverse_map.get(display_name, display_name)


const _ALL_CLASS_IDS: Array[String] = [
	"Squire", "Mage", "Entertainer", "Tinker", "Wildling", "Wanderer",
	"Duelist", "Ranger", "MartialArtist",
	"Invoker", "Acolyte",
	"Bard", "Dervish", "Orator",
	"Artificer", "Cosmologist", "Arithmancer",
	"Herbalist", "Shaman", "Beastcaller",
	"Sentinel", "Pathfinder",
	"Cavalry", "Dragoon", "Mercenary", "Hunter", "Ninja", "Monk",
	"Infernalist", "Tidecaller", "Tempest", "Paladin", "Priest", "Warlock",
	"Warcrier", "Minstrel", "Illusionist", "Mime", "Laureate", "Elegist",
	"Alchemist", "Bombardier", "Chronomancer", "Astronomer", "Automaton", "Technomancer",
	"Blighter", "GroveKeeper", "WitchDoctor", "Spiritwalker", "Falconer", "Shapeshifter",
	"Bulwark", "Aegis", "Trailblazer", "Survivalist",
]


static func _role_name(role: Enums.Role) -> String:
	match role:
		Enums.Role.DPS: return "DPS"
		Enums.Role.FIGHTER: return "Fighter"
		Enums.Role.BURST: return "Burst"
		Enums.Role.TANK: return "Tank"
		Enums.Role.SUPPORT: return "Support"
		_: return "Unknown"


static func _subtype_name(subtype: Enums.Subtype) -> String:
	match subtype:
		Enums.Subtype.GLASS_CANNON: return "Glass Cannon"
		Enums.Subtype.HEALER: return "Healer"
		Enums.Subtype.BUFFER: return "Buffer"
		Enums.Subtype.DEBUFFER: return "Debuffer"
		Enums.Subtype.DOT: return "DoT"
		Enums.Subtype.DRAIN: return "Drain"
		Enums.Subtype.AOE: return "AoE"
		Enums.Subtype.EVASION: return "Evasion"
		Enums.Subtype.CRIT: return "Crit"
		_: return "Unknown"


static func _damage_type_name(dt: Enums.DamageType) -> String:
	match dt:
		Enums.DamageType.PHYSICAL: return "Physical"
		Enums.DamageType.MAGICAL: return "Magical"
		Enums.DamageType.MIXED: return "Mixed"
		_: return "Unknown"
