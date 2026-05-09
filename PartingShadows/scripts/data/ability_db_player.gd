class_name AbilityDBPlayer

## Player T1 and T2 class abilities.

const AbilityData := preload("res://scripts/data/ability_data.gd")
const Enums := preload("res://scripts/data/enums.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")


static func _make(p_name: String, flavor: String, stat: Enums.StatType, mod: int,
		turns: int, on_enemy: bool, cost: int, all: bool = false,
		dot: int = 0, steal: float = 0.0) -> AbilityData:
	return AbilityDB._make(p_name, flavor, stat, mod, turns, on_enemy, cost, all, dot, steal)


# =============================================================================
# Squire tree:T1
# =============================================================================

# Duelist
static func lunge() -> AbilityData:
	return _make("Lunge", "A long, precise thrust that punishes distance.",
		Enums.StatType.PHYSICAL_ATTACK, 8, 0, true, 4, false, 0, 0.0)

static func feint() -> AbilityData:
	return _make("Feint", "A deceptive strike that lowers defenses.",
		Enums.StatType.DEFENSE, 10, 2, true, 3, false, 0, 0.0)

static func riposte() -> AbilityData:
	return _make("Riposte", "Counter with a precise thrust.",
		Enums.StatType.PHYSICAL_ATTACK, 9, 0, true, 5, false, 0, 0.0)

# Ranger
static func pierce() -> AbilityData:
	return _make("Pierce", "A precise arrow that finds the gap.",
		Enums.StatType.PHYSICAL_ATTACK, 6, 0, true, 3, false, 0, 0.0)

static func double_arrow() -> AbilityData:
	return _make("Double Arrow", "Two arrows fly in rapid succession.",
		Enums.StatType.PHYSICAL_ATTACK, 8, 0, true, 5, false, 0, 0.0)

static func mark_prey() -> AbilityData:
	return _make("Mark Prey", "Study weak points to lower defenses.",
		Enums.StatType.DEFENSE, 10, 2, true, 3, false, 0, 0.0)

# Martial Artist
static func punch() -> AbilityData:
	return _make("Punch", "A powerful unarmed strike.",
		Enums.StatType.PHYSICAL_ATTACK, 5, 0, true, 3, false, 0, 0.0)

static func topple() -> AbilityData:
	return _make("Topple", "Sweep the enemy off their feet.",
		Enums.StatType.SPEED, 7, 2, true, 3, false, 0, 0.0)

static func inner_focus() -> AbilityData:
	return _make("Inner Focus", "Center energy for greater strength.",
		Enums.StatType.ATTACK, 9, 2, false, 3, false, 0, 0.0)

# =============================================================================
# Squire tree:T2
# =============================================================================

# Cavalry
static func lance() -> AbilityData:
	return _make("Lance", "A devastating mounted charge.",
		Enums.StatType.PHYSICAL_ATTACK, 22, 0, true, 8, false, 0, 0.0)

static func spur() -> AbilityData:
	return _make("Spur", "Dig in the heels and surge forward.",
		Enums.StatType.SPEED, 11, 2, false, 5, false, 0, 0.0)

static func trample() -> AbilityData:
	return _make("Trample", "Charge through the enemy lines, crushing body and spirit alike.",
		Enums.StatType.PHYSICAL_ATTACK, 18, 0, true, 11, true, 0, 0.0)

# Dragoon
static func dragon_scales() -> AbilityData:
	return _make("Dragon Scales", "Draconic power hardens the party's armor.",
		Enums.StatType.DEFENSE, 12, 3, false, 6, true, 0, 0.0)

static func wyvern_strike() -> AbilityData:
	return _make("Wyvern Strike", "A strike infused with draconic power that burns long after impact.",
		Enums.StatType.MIXED_ATTACK, 24, 0, true, 9, false, 0, 0.0)

static func dragon_dive() -> AbilityData:
	return _make("Dragon Dive", "Soar skyward and plunge down wreathed in draconic flame.",
		Enums.StatType.MIXED_ATTACK, 21, 0, true, 12, true, 0, 0.0)

# Mercenary
static func gun_shot() -> AbilityData:
	return _make("Gun Shot", "A reliable shot from a flintlock.",
		Enums.StatType.PHYSICAL_ATTACK, 12, 0, true, 7, false, 0, 0.0)

static func called_shot() -> AbilityData:
	return _make("Called Shot", "Take careful aim for a devastating hit.",
		Enums.StatType.PHYSICAL_ATTACK, 18, 0, true, 8, false, 0, 0.0)

static func suppressing_fire() -> AbilityData:
	return _make("Suppressing Fire", "Lay down a hail of gunfire across all enemies.",
		Enums.StatType.PHYSICAL_ATTACK, 15, 0, true, 11, true, 0, 0.0)

# Hunter
static func triple_arrow() -> AbilityData:
	return _make("Triple Arrow", "Three arrows fan out to hit all enemies.",
		Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 10, true, 0, 0.0)

static func snare() -> AbilityData:
	return _make("Snare", "A trap that slows the enemy.",
		Enums.StatType.SPEED, 9, 2, true, 5, false, 0, 0.0)

static func hunters_mark() -> AbilityData:
	return _make("Hunter's Mark", "Mark a target, exposing its weakness.",
		Enums.StatType.DEFENSE, 10, 2, true, 5, false, 0, 0.0)

# Ninja
static func shadow_strike() -> AbilityData:
	return _make("Shadow Strike", "A precise strike from the darkness that drains vitality with every blow.",
		Enums.StatType.PHYSICAL_ATTACK, 16, 0, true, 8, false, 0, 0.2)

static func smoke_bomb() -> AbilityData:
	return _make("Smoke Bomb", "A cloud of choking smoke blankets the field, making the whole party nearly impossible to target.",
		Enums.StatType.DODGE_CHANCE, 10, 2, false, 6, true, 0, 0.0)

static func blade_flurry() -> AbilityData:
	return _make("Blade Flurry", "A whirlwind of steel that cuts through all enemies.",
		Enums.StatType.PHYSICAL_ATTACK, 12, 0, true, 10, true, 0, 0.0)

# Monk
static func spirit_attack() -> AbilityData:
	return _make("Spirit Attack", "Channel inner energy into a focused strike.",
		Enums.StatType.MIXED_ATTACK, 14, 0, true, 8, false, 0, 0.0)

static func precise_strike() -> AbilityData:
	return _make("Precise Strike", "Find the exact point of weakness.",
		Enums.StatType.PHYSICAL_ATTACK, 12, 0, true, 8, false, 0, 0.0)

static func inner_peace() -> AbilityData:
	var a := _make("Inner Peace", "Channel spiritual harmony to mend an ally's wounds.",
		Enums.StatType.HEALTH, 3, 0, false, 8, false, 0, 0.0)
	a.heal_threshold = 0.35
	return a


# =============================================================================
# Mage tree:T1
# =============================================================================

# Invoker
static func elemental_barrage() -> AbilityData:
	return _make("Elemental Barrage", "A volley of elemental bolts rains down on all enemies.",
		Enums.StatType.MAGIC_ATTACK, 6, 0, true, 5, true, 0, 0.0)

static func elemental_surge() -> AbilityData:
	return _make("Elemental Surge", "Raw elemental power unleashed.",
		Enums.StatType.MAGIC_ATTACK, 7, 0, true, 4, false, 0, 0.0)

static func elemental_focus() -> AbilityData:
	return _make("Elemental Focus", "Attune to the elements for greater magical power.",
		Enums.StatType.MAGIC_ATTACK, 11, 2, false, 3, false, 0, 0.0)

# Acolyte
static func cure() -> AbilityData:
	var a := _make("Cure", "Mend wounds with holy light.",
		Enums.StatType.HEALTH, 8, 0, false, 6, false, 0, 0.0)
	a.heal_threshold = 0.45
	return a

static func protect() -> AbilityData:
	return _make("Protect", "A ward of light shields an ally.",
		Enums.StatType.DEFENSE, 10, 2, false, 3, false, 0, 0.0)

static func radiance() -> AbilityData:
	return _make("Radiance", "A flash of searing light.",
		Enums.StatType.MAGIC_ATTACK, 6, 0, true, 3, false, 0, 0.0)

# =============================================================================
# Mage tree:T2
# =============================================================================

# Infernalist
static func fire_ball() -> AbilityData:
	return _make("Fire Ball", "A massive sphere of flame.",
		Enums.StatType.MAGIC_ATTACK, 20, 0, true, 8, false, 0, 0.0)

static func burning_brand() -> AbilityData:
	return _make("Burning Brand", "Sear the enemy with lasting flames.",
		Enums.StatType.HEALTH, 0, 3, true, 6, false, 4, 0.0)

static func conflagration() -> AbilityData:
	return _make("Conflagration", "Unleash a wave of fire that engulfs all enemies.",
		Enums.StatType.MAGIC_ATTACK, 12, 0, true, 11, true, 0, 0.0)

# Tidecaller
static func purify() -> AbilityData:
	var a := _make("Purify", "Cleansing waters restore vitality.",
		Enums.StatType.HEALTH, 8, 0, false, 9, false, 0, 0.0)
	a.heal_threshold = 0.35
	return a

static func tsunami() -> AbilityData:
	return _make("Tsunami", "A towering wave crashes down on all enemies.",
		Enums.StatType.MAGIC_ATTACK, 10, 0, true, 10, true, 0, 0.0)

static func water_whip() -> AbilityData:
	return _make("Water Whip", "A lash of pressurized water tears into a single foe.",
		Enums.StatType.MAGIC_ATTACK, 11, 0, true, 7, false, 0, 0.0)

# Tempest
static func hurricane() -> AbilityData:
	return _make("Hurricane", "A storm that strikes all enemies.",
		Enums.StatType.MAGIC_ATTACK, 12, 0, true, 11, true, 0, 0.0)

static func lightning_strike() -> AbilityData:
	return _make("Lightning Strike", "A focused bolt of lightning that annihilates a single foe.",
		Enums.StatType.MAGIC_ATTACK, 14, 0, true, 8, false, 0, 0.0)

static func storm_surge() -> AbilityData:
	return _make("Storm Surge", "Harness the storm's fury to amplify magical power.",
		Enums.StatType.MAGIC_ATTACK, 10, 3, false, 5, false, 0, 0.0)

# Paladin
static func lay_on_hands() -> AbilityData:
	var a := _make("Lay on Hands", "Channel divine grace through your touch to mend wounds.",
		Enums.StatType.HEALTH, 14, 0, false, 9, false, 0, 0.0)
	a.heal_threshold = 0.35
	return a

static func holy_strike() -> AbilityData:
	return _make("Holy Strike", "A blow charged with divine wrath.",
		Enums.StatType.MIXED_ATTACK, 20, 0, true, 8, false, 0, 0.0)

static func smite() -> AbilityData:
	return _make("Smite", "Holy wrath made manifest.",
		Enums.StatType.MAGIC_ATTACK, 14, 0, true, 7, false, 0, 0.0)

# Priest
static func restoration() -> AbilityData:
	var a := _make("Restoration", "A powerful prayer of healing.",
		Enums.StatType.HEALTH, 18, 0, false, 10, false, 0, 0.0)
	a.heal_threshold = 0.35
	return a

static func heavenly_body() -> AbilityData:
	return _make("Heavenly Body", "Divine protection for all allies.",
		Enums.StatType.DEFENSE, 5, 2, false, 7, true, 0, 0.0)

static func holy() -> AbilityData:
	return _make("Holy", "A ray of pure divine energy.",
		Enums.StatType.MAGIC_ATTACK, 7, 0, true, 7, false, 0, 0.0)

# Warlock
static func shadow_bolt() -> AbilityData:
	return _make("Shadow Bolt", "A bolt of concentrated darkness that feeds on what it destroys.",
		Enums.StatType.MAGIC_ATTACK, 15, 0, true, 8, false, 0, 0.2)

static func hex() -> AbilityData:
	return _make("Hex", "A lingering curse that eats away at the victim.",
		Enums.StatType.HEALTH, 0, 3, true, 6, false, 3, 0.0)

static func drain_life() -> AbilityData:
	return _make("Drain Life", "Steal the enemy's life force.",
		Enums.StatType.MAGIC_ATTACK, 17, 0, true, 9, false, 0, 0.35)


# =============================================================================
# Entertainer tree:T1
# =============================================================================

# Bard
static func seduce() -> AbilityData:
	return _make("Seduce", "A captivating performance that lowers guard.",
		Enums.StatType.DEFENSE, 10, 2, true, 3, false, 0, 0.0)

static func melody() -> AbilityData:
	return _make("Melody", "A haunting tune that cuts like a blade.",
		Enums.StatType.MAGIC_ATTACK, 5, 0, true, 4, false, 0, 0.0)

static func encourage() -> AbilityData:
	return _make("Encourage", "Inspiring words that bolster attack.",
		Enums.StatType.ATTACK, 7, 2, false, 4, false, 0, 0.0)

# Dervish
static func mesmerize() -> AbilityData:
	return _make("Mesmerize", "A hypnotic dance that lowers the enemy's guard.",
		Enums.StatType.DEFENSE, 10, 2, true, 3, false, 0, 0.0)

static func dance() -> AbilityData:
	return _make("Dance", "A whirling strike of blades and grace.",
		Enums.StatType.MIXED_ATTACK, 5, 0, true, 4, false, 0, 0.0)

static func whirling_step() -> AbilityData:
	return _make("Whirling Step", "Spin through the enemy ranks.",
		Enums.StatType.MAGIC_ATTACK, 4, 0, true, 4, true, 0, 0.0)

# Orator
static func oration() -> AbilityData:
	return _make("Oration", "Words sharp enough to wound.",
		Enums.StatType.MAGIC_ATTACK, 8, 0, true, 4, false, 0, 0.0)

static func rebuke() -> AbilityData:
	return _make("Rebuke", "Harsh words that slow the mind.",
		Enums.StatType.SPEED, 7, 2, true, 4, false, 0, 0.0)

# =============================================================================
# Entertainer tree:T2
# =============================================================================

# Warcrier
static func battle_cry() -> AbilityData:
	return _make("Battle Cry", "A thunderous shout that devastates.",
		Enums.StatType.MIXED_ATTACK, 16, 0, true, 8, false, 0, 0.0)

static func war_chant() -> AbilityData:
	return _make("War Chant", "A fierce war chant that ignites an ally's fighting spirit.",
		Enums.StatType.ATTACK, 16, 2, false, 5, false, 0, 0.0)

static func rally_cry() -> AbilityData:
	return _make("Rally Cry", "A rallying shout that mends wounds.",
		Enums.StatType.MIXED_ATTACK, 9, 0, false, 9, false, 0, 0.0)

# Minstrel
static func dissonance() -> AbilityData:
	return _make("Dissonance", "A grating chord that saps the will to fight.",
		Enums.StatType.ATTACK, 7, 2, true, 5, false, 0, 0.0)

static func ballad() -> AbilityData:
	return _make("Ballad", "A sorrowful melody turned weapon.",
		Enums.StatType.MAGIC_ATTACK, 10, 0, true, 7, false, 0, 0.0)

static func serenade() -> AbilityData:
	var a := _make("Serenade", "A soothing song that mends wounds.",
		Enums.StatType.HEALTH, 8, 0, false, 9, false, 0, 0.0)
	a.heal_threshold = 0.35
	return a

# Illusionist
static func phantom_strike() -> AbilityData:
	return _make("Phantom Strike", "An illusory blade that feels all too real.",
		Enums.StatType.MIXED_ATTACK, 16, 0, true, 8, false, 0, 0.0)

static func mirage() -> AbilityData:
	return _make("Mirage", "Bend light around all allies, making them harder to hit.",
		Enums.StatType.DODGE_CHANCE, 7, 3, false, 6, true, 0, 0.0)

static func bewilderment() -> AbilityData:
	return _make("Bewilderment", "A dazzling burst of illusions that strikes all enemies.",
		Enums.StatType.MAGIC_ATTACK, 5, 0, true, 10, true, 0, 0.0)

# Mime
static func invisible_wall() -> AbilityData:
	return _make("Invisible Wall", "Nothing can get through.",
		Enums.StatType.DEFENSE, 14, 3, false, 7, true, 0, 0.0)

static func anvil() -> AbilityData:
	return _make("Anvil", "Drop something very heavy. From nowhere.",
		Enums.StatType.MIXED_ATTACK, 21, 0, true, 9, false, 0, 0.0)

static func invisible_box() -> AbilityData:
	return _make("Invisible Box", "Trap the enemy in an unseen prison.",
		Enums.StatType.SPEED, 11, 3, true, 6, false, 0, 0.0)

# Laureate
static func ovation() -> AbilityData:
	return _make("Ovation", "A masterful speech that empowers all allies.",
		Enums.StatType.ATTACK, 15, 3, false, 7, true, 0, 0.0)

static func recite() -> AbilityData:
	return _make("Recite", "Words of power that wound.",
		Enums.StatType.MAGIC_ATTACK, 20, 0, true, 8, false, 0, 0.0)

static func magnum_opus() -> AbilityData:
	return _make("Magnum Opus", "The poet's greatest work. All allies feel invincible.",
		Enums.StatType.DEFENSE, 16, 3, false, 7, true, 0, 0.0)

# Elegist
static func requiem() -> AbilityData:
	return _make("Requiem", "A mournful verse that strikes the soul.",
		Enums.StatType.MAGIC_ATTACK, 7, 0, true, 7, false, 0, 0.0)

static func lament() -> AbilityData:
	return _make("Lament", "A song of sorrow so deep it saps the will to fight from all who hear it.",
		Enums.StatType.ATTACK, 9, 2, true, 6, true, 0, 0.0)

static func dirge() -> AbilityData:
	return _make("Dirge", "A funeral march that slows all it touches.",
		Enums.StatType.SPEED, 7, 2, true, 6, true, 0, 0.0)
