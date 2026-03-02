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
# Squire tree — T1
# =============================================================================

# Duelist
static func feint() -> AbilityData:
	return _make("Feint", "A deceptive strike that lowers defenses.",
		Enums.StatType.DEFENSE, 3, 2, true, 2)

# Ranger
static func pierce() -> AbilityData:
	return _make("Pierce", "A precise arrow that finds the gap.",
		Enums.StatType.PHYSICAL_ATTACK, 3, 0, true, 2)

static func double_arrow() -> AbilityData:
	return _make("Double Arrow", "Two arrows fly in rapid succession.",
		Enums.StatType.PHYSICAL_ATTACK, 6, 0, true, 3)

# Martial Artist
static func punch() -> AbilityData:
	return _make("Punch", "A powerful unarmed strike.",
		Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 2)

static func topple() -> AbilityData:
	return _make("Topple", "Sweep the enemy off their feet.",
		Enums.StatType.SPEED, 3, 2, true, 2)

# =============================================================================
# Squire tree — T2
# =============================================================================

# Cavalry
static func lance() -> AbilityData:
	return _make("Lance", "A devastating mounted charge.",
		Enums.StatType.PHYSICAL_ATTACK, 6, 0, true, 3)

static func trample() -> AbilityData:
	return _make("Trample", "Charge through the enemy lines.",
		Enums.StatType.PHYSICAL_ATTACK, 5, 0, true, 3)

# Dragoon
static func jump() -> AbilityData:
	return _make("Jump", "Leap high and crash down with crushing force.",
		Enums.StatType.PHYSICAL_ATTACK, 8, 0, true, 4)

static func wyvern_strike() -> AbilityData:
	return _make("Wyvern Strike", "A strike infused with draconic power.",
		Enums.StatType.MIXED_ATTACK, 7, 0, true, 4)

static func dragon_ward() -> AbilityData:
	return _make("Dragon Ward", "Draconic scales shield an ally.",
		Enums.StatType.DEFENSE, 5, 2, false, 3)

# Mercenary
static func gun_shot() -> AbilityData:
	return _make("Gun Shot", "A reliable shot from a flintlock.",
		Enums.StatType.PHYSICAL_ATTACK, 5, 0, true, 3)

static func called_shot() -> AbilityData:
	return _make("Called Shot", "Take careful aim for a devastating hit.",
		Enums.StatType.PHYSICAL_ATTACK, 8, 0, true, 5)

static func quick_draw() -> AbilityData:
	return _make("Quick Draw", "Lightning-fast reflexes boost speed.",
		Enums.StatType.SPEED, 5, 2, false, 2)

# Hunter
static func triple_arrow() -> AbilityData:
	return _make("Triple Arrow", "Three arrows fan out to hit all enemies.",
		Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 4, true)

static func snare() -> AbilityData:
	return _make("Snare", "A trap that slows the enemy.",
		Enums.StatType.SPEED, 5, 2, true, 2)

static func hunters_mark() -> AbilityData:
	return _make("Hunter's Mark", "Mark a target, exposing its weakness.",
		Enums.StatType.DEFENSE, 3, 2, true, 2)

# Ninja
static func sweeping_slash() -> AbilityData:
	return _make("Sweeping Slash", "A wide arc of the blade.",
		Enums.StatType.PHYSICAL_ATTACK, 5, 0, true, 3)

static func dash() -> AbilityData:
	return _make("Dash", "Blur across the battlefield.",
		Enums.StatType.SPEED, 3, 2, false, 1)

static func smoke_bomb() -> AbilityData:
	return _make("Smoke Bomb", "Vanish in a cloud of smoke.",
		Enums.StatType.DODGE_CHANCE, 3, 1, false, 2)

# Monk
static func spirit_attack() -> AbilityData:
	return _make("Spirit Attack", "Channel inner energy into a focused strike.",
		Enums.StatType.MIXED_ATTACK, 6, 0, true, 3)

static func precise_strike() -> AbilityData:
	return _make("Precise Strike", "Find the exact point of weakness.",
		Enums.StatType.PHYSICAL_ATTACK, 7, 0, true, 4)

static func meditate() -> AbilityData:
	return _make("Meditate", "Center the mind against magical attacks.",
		Enums.StatType.MAGIC_DEFENSE, 5, 2, false, 3)


# =============================================================================
# Mage tree — T1
# =============================================================================

# Invoker
static func elemental_surge() -> AbilityData:
	return _make("Elemental Surge", "Raw elemental power unleashed.",
		Enums.StatType.MAGIC_ATTACK, 5, 0, true, 3)

# Acolyte
static func cure() -> AbilityData:
	return _make("Cure", "Mend wounds with holy light.",
		Enums.StatType.HEALTH, 3, 0, false, 7)

static func protect() -> AbilityData:
	return _make("Protect", "A ward of light shields an ally.",
		Enums.StatType.DEFENSE, 2, 2, false, 2)

static func radiance() -> AbilityData:
	return _make("Radiance", "A flash of searing light.",
		Enums.StatType.MAGIC_ATTACK, 4, 0, true, 3)

# =============================================================================
# Mage tree — T2
# =============================================================================

# Infernalist
static func fire_ball() -> AbilityData:
	return _make("Fire Ball", "A massive sphere of flame.",
		Enums.StatType.MAGIC_ATTACK, 10, 0, true, 5)

static func burning_brand() -> AbilityData:
	return _make("Burning Brand", "Sear the enemy with lasting flames.",
		Enums.StatType.HEALTH, 0, 2, true, 4, false, 4)

static func enrage() -> AbilityData:
	return _make("Enrage", "Stoke the inner fire for greater magic.",
		Enums.StatType.MAGIC_ATTACK, 5, 2, false, 3)

# Tidecaller
static func purify() -> AbilityData:
	return _make("Purify", "Cleansing waters restore vitality.",
		Enums.StatType.HEALTH, 20, 0, false, 5)

static func tsunami() -> AbilityData:
	return _make("Tsunami", "A towering wave crashes down.",
		Enums.StatType.MAGIC_ATTACK, 8, 0, true, 5)

static func undertow() -> AbilityData:
	return _make("Undertow", "Drag the enemy into slow currents.",
		Enums.StatType.SPEED, 5, 2, true, 2)

# Tempest
static func hurricane() -> AbilityData:
	return _make("Hurricane", "A storm that strikes all enemies.",
		Enums.StatType.MAGIC_ATTACK, 4, 0, true, 4, true)

static func tornado() -> AbilityData:
	return _make("Tornado", "A focused vortex of destruction.",
		Enums.StatType.MAGIC_ATTACK, 8, 0, true, 6)

static func knockdown() -> AbilityData:
	return _make("Knockdown", "Blow the enemy off their feet.",
		Enums.StatType.SPEED, 5, 2, true, 2)

# Paladin
static func smite() -> AbilityData:
	return _make("Smite", "Holy wrath made manifest.",
		Enums.StatType.MIXED_ATTACK, 9, 0, true, 5)

# Priest
static func restoration() -> AbilityData:
	return _make("Restoration", "A powerful prayer of healing.",
		Enums.StatType.HEALTH, 30, 0, false, 7)

static func heavenly_body() -> AbilityData:
	return _make("Heavenly Body", "Divine protection for all allies.",
		Enums.StatType.DEFENSE, 4, 2, false, 4, true)

static func holy() -> AbilityData:
	return _make("Holy", "A ray of pure divine energy.",
		Enums.StatType.MAGIC_ATTACK, 7, 0, true, 4)

# Warlock
static func shadow_bolt() -> AbilityData:
	return _make("Shadow Bolt", "A bolt of concentrated darkness.",
		Enums.StatType.MAGIC_ATTACK, 9, 0, true, 5)

static func curse() -> AbilityData:
	return _make("Curse", "Dark magic that weakens magical resistance.",
		Enums.StatType.MAGIC_DEFENSE, 4, 2, true, 4)

static func drain_life() -> AbilityData:
	return _make("Drain Life", "Steal the enemy's life force.",
		Enums.StatType.MIXED_ATTACK, 4, 0, true, 3, false, 0, 0.5)


# =============================================================================
# Entertainer tree — T1
# =============================================================================

# Bard
static func seduce() -> AbilityData:
	return _make("Seduce", "A captivating performance that lowers guard.",
		Enums.StatType.DEFENSE, 3, 2, true, 2)

static func melody() -> AbilityData:
	return _make("Melody", "A haunting tune that cuts like a blade.",
		Enums.StatType.MAGIC_ATTACK, 5, 0, true, 3)

static func encourage() -> AbilityData:
	return _make("Encourage", "Inspiring words that bolster attack.",
		Enums.StatType.ATTACK, 5, 2, false, 2)

# Dervish
static func dance() -> AbilityData:
	return _make("Dance", "A whirling strike of blades and grace.",
		Enums.StatType.MIXED_ATTACK, 5, 0, true, 3)

# Orator
static func oration() -> AbilityData:
	return _make("Oration", "Words sharp enough to wound.",
		Enums.StatType.MAGIC_ATTACK, 5, 0, true, 3)

# =============================================================================
# Entertainer tree — T2
# =============================================================================

# Warcrier
static func battle_cry() -> AbilityData:
	return _make("Battle Cry", "A thunderous shout that devastates.",
		Enums.StatType.MIXED_ATTACK, 8, 0, true, 5)

static func encore() -> AbilityData:
	return _make("Encore", "Demand a repeat performance -- boost attack.",
		Enums.StatType.ATTACK, 5, 2, false, 2)

# Minstrel
static func ballad() -> AbilityData:
	return _make("Ballad", "A sorrowful melody turned weapon.",
		Enums.StatType.MAGIC_ATTACK, 6, 0, true, 4)

static func serenade() -> AbilityData:
	return _make("Serenade", "A soothing song that mends wounds.",
		Enums.StatType.HEALTH, 15, 0, false, 4)

# Illusionist
static func mirage() -> AbilityData:
	return _make("Mirage", "Bend light to shield an ally.",
		Enums.StatType.DEFENSE, 5, 2, false, 3)

static func bewilderment() -> AbilityData:
	return _make("Bewilderment", "Confuse the enemy's magical senses.",
		Enums.StatType.MAGIC_DEFENSE, 4, 2, true, 2)

# Mime
static func invisible_wall() -> AbilityData:
	return _make("Invisible Wall", "Nothing can get through.",
		Enums.StatType.DEFENSE, 5, 2, false, 3)

static func anvil() -> AbilityData:
	return _make("Anvil", "Drop something very heavy. From nowhere.",
		Enums.StatType.MIXED_ATTACK, 7, 0, true, 3)

static func invisible_box() -> AbilityData:
	return _make("Invisible Box", "Trap the enemy in an unseen prison.",
		Enums.StatType.SPEED, 4, 2, true, 2)

# Laureate
static func ovation() -> AbilityData:
	return _make("Ovation", "A masterful speech that empowers.",
		Enums.StatType.ATTACK, 5, 2, false, 3)

static func recite() -> AbilityData:
	return _make("Recite", "Words of power that wound.",
		Enums.StatType.MAGIC_ATTACK, 6, 0, true, 4)

static func eulogy() -> AbilityData:
	return _make("Eulogy", "Speak their end into being.",
		Enums.StatType.MAGIC_DEFENSE, 4, 2, true, 3)

# Elegist
static func nightfall() -> AbilityData:
	return _make("Nightfall", "Darkness descends on the enemy.",
		Enums.StatType.MAGIC_ATTACK, 7, 0, true, 5)

static func inspire() -> AbilityData:
	return _make("Inspire", "Lift the spirits of an ally.",
		Enums.StatType.ATTACK, 7, 2, false, 3)

static func dirge() -> AbilityData:
	return _make("Dirge", "A funeral march that slows all it touches.",
		Enums.StatType.SPEED, 4, 2, true, 2)


# =============================================================================
# Tinker tree — T1
# =============================================================================

# Artificer
static func magical_tinkering() -> AbilityData:
	return _make("Magical Tinkering", "Enhance an ally's magical potency.",
		Enums.StatType.MAGIC_ATTACK, 5, 2, false, 2)

# Cosmologist (Philosopher)
static func time_warp() -> AbilityData:
	return _make("Time Warp", "Bend time to hasten an ally.",
		Enums.StatType.SPEED, 5, 2, false, 2)

static func black_hole() -> AbilityData:
	return _make("Black Hole", "Crush the enemy with gravity.",
		Enums.StatType.MAGIC_ATTACK, 7, 0, true, 5)

static func gravity() -> AbilityData:
	return _make("Gravity", "Slow the enemy with crushing force.",
		Enums.StatType.SPEED, 4, 2, true, 2)

# Arithmancer
static func calculate() -> AbilityData:
	return _make("Calculate", "Exploit mathematical weakness.",
		Enums.StatType.DEFENSE, 3, 2, true, 2)

# =============================================================================
# Tinker tree — T2
# =============================================================================

# Alchemist
static func transmute() -> AbilityData:
	return _make("Transmute", "Transform matter into pure energy.",
		Enums.StatType.MIXED_ATTACK, 10, 0, true, 5)

static func corrosive_acid() -> AbilityData:
	return _make("Corrosive Acid", "Acid that burns over time.",
		Enums.StatType.HEALTH, 0, 3, true, 4, false, 4)

static func elixir() -> AbilityData:
	return _make("Elixir", "A carefully brewed healing potion.",
		Enums.StatType.HEALTH, 12, 0, false, 5)

# Bombardier
static func shrapnel() -> AbilityData:
	return _make("Shrapnel", "Razor-sharp metal fragments.",
		Enums.StatType.PHYSICAL_ATTACK, 5, 0, true, 3)

static func explosion() -> AbilityData:
	return _make("Explosion", "A massive detonation.",
		Enums.StatType.MIXED_ATTACK, 10, 0, true, 6)

static func detonate() -> AbilityData:
	return _make("Detonate", "A blast that weakens defenses.",
		Enums.StatType.DEFENSE, 5, 2, true, 3)

# Chronomancer
static func warp_speed() -> AbilityData:
	return _make("Warp Speed", "Accelerate an ally through time.",
		Enums.StatType.SPEED, 10, 2, false, 4)

static func time_bomb() -> AbilityData:
	return _make("Time Bomb", "A delayed temporal explosion.",
		Enums.StatType.MAGIC_ATTACK, 5, 0, true, 3)

static func time_freeze() -> AbilityData:
	return _make("Time Freeze", "Stop the enemy in their tracks.",
		Enums.StatType.SPEED, 7, 2, true, 3)

# Astronomer
static func starfall() -> AbilityData:
	return _make("Starfall", "Call down celestial fire.",
		Enums.StatType.MAGIC_ATTACK, 8, 0, true, 5)

static func meteor_shower() -> AbilityData:
	return _make("Meteor Shower", "A rain of cosmic debris.",
		Enums.StatType.MAGIC_ATTACK, 4, 0, true, 5, true)

static func eclipse() -> AbilityData:
	return _make("Eclipse", "Blot out the enemy's magical senses.",
		Enums.StatType.MAGIC_DEFENSE, 5, 2, true, 3)

# Automaton
static func servo_strike() -> AbilityData:
	return _make("Servo Strike", "A mechanized magical strike.",
		Enums.StatType.MAGIC_ATTACK, 5, 0, true, 3)

static func program_defense() -> AbilityData:
	var mod: int = randi_range(-5, 9)
	var cost: int = randi_range(3, 6)
	return _make("Program Defense", "Run a defensive subroutine. Results vary.",
		Enums.StatType.DEFENSE, mod, 2, false, cost)

static func overclock() -> AbilityData:
	return _make("Overclock", "Push systems beyond safe limits.",
		Enums.StatType.SPEED, 7, 2, false, 3)

# Technomancer
static func random_attack() -> AbilityData:
	var mod: int = randi_range(-5, 19)
	var cost: int = randi_range(5, 9)
	return _make("Random", "Unpredictable magical burst.",
		Enums.StatType.MAGIC_ATTACK, mod, 0, true, cost)

static func program_offense() -> AbilityData:
	var mod: int = randi_range(-3, 9)
	var cost: int = randi_range(3, 6)
	return _make("Program Offense", "Run an offensive subroutine. Results vary.",
		Enums.StatType.ATTACK, mod, 2, false, cost)


# =============================================================================
# Wildling tree — T1
# =============================================================================

# Herbalist
static func mending_herbs() -> AbilityData:
	return _make("Mending Herbs", "Apply healing herbs to an ally.",
		Enums.StatType.HEALTH, 4, 0, false, 3)

static func sapping_vine() -> AbilityData:
	return _make("Sapping Vine", "Drain life through thorny vines.",
		Enums.StatType.MAGIC_ATTACK, 4, 0, true, 3, false, 0, 0.5)

# Shaman
static func spectral_lance() -> AbilityData:
	return _make("Spectral Lance", "A ghostly spear of spirit energy.",
		Enums.StatType.MAGIC_ATTACK, 5, 0, true, 3)

static func player_hex() -> AbilityData:
	return _make("Hex", "A curse that saps the enemy's power.",
		Enums.StatType.ATTACK, 5, 2, true, 3)

# Beastcaller
static func feral_strike() -> AbilityData:
	return _make("Feral Strike", "Call a beast to strike the enemy.",
		Enums.StatType.PHYSICAL_ATTACK, 5, 0, true, 2)

static func pack_howl() -> AbilityData:
	return _make("Pack Howl", "Rally the pack for greater power.",
		Enums.StatType.ATTACK, 3, 2, false, 2, true)

# =============================================================================
# Wildling tree — T2
# =============================================================================

# Blighter
static func blight() -> AbilityData:
	return _make("Blight", "Dark natural magic that corrupts.",
		Enums.StatType.MAGIC_ATTACK, 6, 0, true, 4)

static func life_siphon() -> AbilityData:
	return _make("Life Siphon", "Drain the enemy's essence.",
		Enums.StatType.MAGIC_ATTACK, 6, 0, true, 4, false, 0, 0.5)

static func poison_sting() -> AbilityData:
	return _make("Poison Sting", "A venomous barb that festers.",
		Enums.StatType.HEALTH, 0, 3, true, 3, false, 3)

# Grove Keeper
static func vine_wall() -> AbilityData:
	return _make("Vine Wall", "Thick vines shield an ally.",
		Enums.StatType.DEFENSE, 3, 2, false, 4)

static func root_trap() -> AbilityData:
	return _make("Root Trap", "Roots that entangle the enemy.",
		Enums.StatType.SPEED, 4, 2, true, 3)

static func overgrowth() -> AbilityData:
	return _make("Overgrowth", "Nature's vitality heals all allies.",
		Enums.StatType.HEALTH, 6, 0, false, 5, true)

# Witch Doctor
static func voodoo_bolt() -> AbilityData:
	return _make("Voodoo Bolt", "Dark spiritual energy strikes the enemy.",
		Enums.StatType.MAGIC_ATTACK, 7, 0, true, 4)

static func dark_hex() -> AbilityData:
	return _make("Dark Hex", "A potent curse that weakens magic resistance.",
		Enums.StatType.MAGIC_DEFENSE, 5, 3, true, 4)

static func creeping_rot() -> AbilityData:
	return _make("Creeping Rot", "A slow decay that saps strength.",
		Enums.StatType.ATTACK, 2, 3, true, 4, false, 3)

# Spiritwalker
static func spirit_shield() -> AbilityData:
	return _make("Spirit Shield", "Ancestral spirits protect an ally.",
		Enums.StatType.DEFENSE, 5, 2, false, 3)

static func ancestral_blessing() -> AbilityData:
	return _make("Ancestral Blessing", "The ancestors empower all allies.",
		Enums.StatType.ATTACK, 4, 2, false, 5, true)

static func spirit_mend() -> AbilityData:
	return _make("Spirit Mend", "Healing energy from the spirit world.",
		Enums.StatType.HEALTH, 7, 0, false, 4)

# Falconer
static func falcon_strike() -> AbilityData:
	return _make("Falcon Strike", "A raptor dives from above.",
		Enums.StatType.PHYSICAL_ATTACK, 7, 0, true, 3)

static func sky_dive() -> AbilityData:
	return _make("Sky Dive", "A devastating aerial assault.",
		Enums.StatType.PHYSICAL_ATTACK, 8, 0, true, 5)

static func raptors_mark() -> AbilityData:
	return _make("Raptor's Mark", "The falcon marks its prey.",
		Enums.StatType.PHYSICAL_DEFENSE, 4, 2, true, 3)

# Shapeshifter
static func savage_maul() -> AbilityData:
	return _make("Savage Maul", "Transform and maul the enemy.",
		Enums.StatType.PHYSICAL_ATTACK, 8, 0, true, 3)

static func frenzy() -> AbilityData:
	return _make("Frenzy", "Enter a bestial rage.",
		Enums.StatType.ATTACK, 5, 2, false, 2)

static func primal_roar() -> AbilityData:
	return _make("Primal Roar", "A roar that shakes all enemies.",
		Enums.StatType.DEFENSE, 4, 2, true, 4, true)
