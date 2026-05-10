class_name AbilityDBPlayerB

## Player T1 and T2 class abilities: Tinker, Wildling, Wanderer trees.

const AbilityData := preload("res://scripts/data/ability_data.gd")
const Enums := preload("res://scripts/data/enums.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")


static func _make(p_name: String, flavor: String, stat: Enums.StatType, mod: int,
		turns: int, on_enemy: bool, cost: int, all: bool = false,
		dot: int = 0, steal: float = 0.0) -> AbilityData:
	return AbilityDB._make(p_name, flavor, stat, mod, turns, on_enemy, cost, all, dot, steal)


# =============================================================================
# Tinker tree:T1
# =============================================================================

# Artificer
static func magical_tinkering() -> AbilityData:
	return _make("Magical Tinkering", "Enhance an ally's magical potency.",
		Enums.StatType.MAGIC_ATTACK, 11, 2, false, 3, false, 0, 0.0)

static func volatile_flask() -> AbilityData:
	return _make("Volatile Flask", "A bubbling concoction hurled at the enemy.",
		Enums.StatType.MAGIC_ATTACK, 7, 0, true, 4, false, 0, 0.0)


static func healing_draught() -> AbilityData:
	var a := _make("Healing Draught", "A carefully brewed potion that mends wounds.",
		Enums.StatType.HEALTH, 4, 0, false, 5, false, 0, 0.0)
	a.heal_threshold = 0.25
	return a

# Philosopher
static func time_warp() -> AbilityData:
	return _make("Time Warp", "Bend time to hasten an ally.",
		Enums.StatType.SPEED, 9, 2, false, 3, false, 0, 0.0)

static func black_hole() -> AbilityData:
	return _make("Black Hole", "Crush the enemy with gravity.",
		Enums.StatType.MAGIC_ATTACK, 7, 0, true, 5, false, 0, 0.0)

static func gravity() -> AbilityData:
	return _make("Gravity", "Slow the enemy with crushing force.",
		Enums.StatType.SPEED, 7, 2, true, 3, false, 0, 0.0)

# Arithmancer
static func theorem() -> AbilityData:
	return _make("Theorem", "A mathematical proof made manifest.",
		Enums.StatType.MAGIC_ATTACK, 9, 0, true, 5, false, 0, 0.0)

static func calculate() -> AbilityData:
	return _make("Calculate", "Exploit mathematical weakness.",
		Enums.StatType.DEFENSE, 10, 2, true, 3, false, 0, 0.0)

static func probability() -> AbilityData:
	return _make("Probability", "Shift the odds in an ally's favor.",
		Enums.StatType.SPEED, 7, 2, false, 3, false, 0, 0.0)

# =============================================================================
# Tinker tree:T2
# =============================================================================

# Alchemist
static func transmute() -> AbilityData:
	return _make("Transmute", "Transform matter into pure energy.",
		Enums.StatType.MAGIC_ATTACK, 20, 0, true, 8, false, 0, 0.0)

static func corrosive_acid() -> AbilityData:
	return _make("Acid Blast", "A corrosive wave of acid that sears all enemies.",
		Enums.StatType.MAGIC_ATTACK, 14, 0, true, 11, true, 0, 0.0)

static func elixir() -> AbilityData:
	var a := _make("Elixir", "A carefully brewed healing potion.",
		Enums.StatType.HEALTH, 18, 0, false, 9, false, 0, 0.0)
	a.heal_threshold = 0.35
	return a

# Bombardier
static func cluster_bomb() -> AbilityData:
	return _make("Cluster Bomb", "A salvo of explosive charges scatters across the battlefield.",
		Enums.StatType.MAGIC_ATTACK, 16, 0, true, 11, true, 0, 0.0)

static func explosion() -> AbilityData:
	return _make("Explosion", "A massive detonation.",
		Enums.StatType.MAGIC_ATTACK, 18, 0, true, 8, false, 0, 0.0)

static func demolition_charge() -> AbilityData:
	return _make("Demolition Charge", "A shaped charge placed at the weakest point.",
		Enums.StatType.MAGIC_ATTACK, 22, 0, true, 9, false, 0, 0.0)

# Chronomancer
static func temporal_rift() -> AbilityData:
	return _make("Temporal Rift", "Tear open a rift in time, bombarding all enemies with temporal energy.",
		Enums.StatType.MAGIC_ATTACK, 10, 0, true, 10, true, 0, 0.0)

static func time_bomb() -> AbilityData:
	return _make("Time Bomb", "A delayed temporal explosion.",
		Enums.StatType.MAGIC_ATTACK, 12, 0, true, 7, false, 0, 0.0)

static func time_freeze() -> AbilityData:
	return _make("Time Freeze", "Stop the enemy in their tracks.",
		Enums.StatType.SPEED, 9, 2, true, 6, false, 0, 0.0)

# Astronomer
static func starfall() -> AbilityData:
	return _make("Starfall", "Call down celestial fire.",
		Enums.StatType.MAGIC_ATTACK, 8, 0, true, 7, false, 0, 0.0)

static func meteor_shower() -> AbilityData:
	return _make("Meteor Shower", "A rain of cosmic debris.",
		Enums.StatType.MAGIC_ATTACK, 5, 0, true, 10, true, 0, 0.0)

static func eclipse() -> AbilityData:
	return _make("Eclipse", "Blot out the enemy's magical senses.",
		Enums.StatType.MAGIC_DEFENSE, 10, 2, true, 5, false, 0, 0.0)

# Automaton
static func servo_strike() -> AbilityData:
	return _make("Servo Strike", "A pneumatic piston blow from mechanical limbs.",
		Enums.StatType.MAGIC_ATTACK, 16, 0, true, 7, false, 0, 0.0)

static func discharge() -> AbilityData:
	return _make("Discharge", "Release a burst of stored energy that arcs through all enemies.",
		Enums.StatType.MAGIC_ATTACK, 10, 0, true, 10, true, 0, 0.0)

static func self_repair() -> AbilityData:
	var a := _make("Self-Repair", "Reroute power to internal repair systems.",
		Enums.StatType.HEALTH, 8, 0, false, 8, false, 0, 0.0)
	a.heal_threshold = 0.35
	return a

# Technomancer
static func circuit_blast() -> AbilityData:
	return _make("Circuit Blast", "Channel magic through overcharged circuits.",
		Enums.StatType.MAGIC_ATTACK, 16, 0, true, 8, false, 0, 0.0)

static func techno_drain() -> AbilityData:
	return _make("Techno Drain", "Siphon the enemy's energy through crackling circuits.",
		Enums.StatType.MAGIC_ATTACK, 12, 0, true, 8, false, 0, 0.25)

static func emp_pulse() -> AbilityData:
	return _make("EMP Pulse", "An electromagnetic burst disrupts all enemies' reactions.",
		Enums.StatType.SPEED, 9, 2, true, 6, true, 0, 0.0)


# =============================================================================
# Wildling tree:T1
# =============================================================================

# Herbalist
static func mending_herbs() -> AbilityData:
	return _make("Mending Herbs", "Apply healing herbs to an ally.",
		Enums.StatType.HEALTH, 4, 0, false, 5, false, 0, 0.0)

static func sapping_vine() -> AbilityData:
	return _make("Sapping Vine", "Lash out with life-draining vines.",
		Enums.StatType.MAGIC_ATTACK, 5, 0, true, 4, false, 0, 0.0)

static func thorn_spray() -> AbilityData:
	return _make("Thorn Spray", "A spray of enchanted thorns that disrupts magical defenses.",
		Enums.StatType.MAGIC_DEFENSE, 9, 2, true, 3, false, 0, 0.0)

# Shaman
static func spectral_lance() -> AbilityData:
	return _make("Spectral Lance", "A ghostly spear of spirit energy.",
		Enums.StatType.MAGIC_ATTACK, 5, 0, true, 4, false, 0, 0.0)

static func player_hex() -> AbilityData:
	return _make("Hex", "A curse that saps the enemy's power.",
		Enums.StatType.ATTACK, 11, 2, true, 4, false, 0, 0.0)

static func spirit_bolt() -> AbilityData:
	return _make("Spirit Bolt", "A crackling bolt of ancestral energy.",
		Enums.StatType.MAGIC_ATTACK, 6, 0, true, 4, false, 0, 0.0)


static func ancestral_curse() -> AbilityData:
	return _make("Ancestral Curse", "Invoke the wrath of forgotten spirits upon all foes.",
		Enums.StatType.ATTACK, 9, 2, true, 5, true, 0, 0.0)


static func spirit_veil() -> AbilityData:
	return _make("Spirit Veil", "Spirits weave a protective ward against magic.",
		Enums.StatType.MAGIC_DEFENSE, 9, 2, false, 3, false, 0, 0.0)

# Beastcaller
static func feral_strike() -> AbilityData:
	return _make("Feral Strike", "Call a beast to strike the enemy.",
		Enums.StatType.PHYSICAL_ATTACK, 7, 0, true, 4, false, 0, 0.0)

static func pack_howl() -> AbilityData:
	return _make("Pack Howl", "Rally the pack for greater power.",
		Enums.StatType.ATTACK, 9, 2, false, 4, true, 0, 0.0)

static func stampede() -> AbilityData:
	return _make("Stampede", "A rampaging beast crashes through the enemy lines.",
		Enums.StatType.PHYSICAL_ATTACK, 5, 0, true, 5, true, 0, 0.0)

# =============================================================================
# Wildling tree:T2
# =============================================================================

# Blighter
static func blight() -> AbilityData:
	return _make("Blight", "Dark natural magic that corrupts.",
		Enums.StatType.MAGIC_ATTACK, 13, 0, true, 8, false, 0, 0.4)

static func plague() -> AbilityData:
	return _make("Plague", "Corruption spreads to everything it touches.",
		Enums.StatType.MAGIC_ATTACK, 14, 0, true, 11, true, 0, 0.0)

static func poison_sting() -> AbilityData:
	return _make("Poison Sting", "A venomous barb that festers.",
		Enums.StatType.HEALTH, 0, 3, true, 6, false, 5, 0.0)

# Grove Keeper
static func natures_mend() -> AbilityData:
	var a := _make("Nature's Mend", "Channel the forest's restorative power to heal an ally's wounds.",
		Enums.StatType.HEALTH, 18, 0, false, 9, false, 0, 0.0)
	a.heal_threshold = 0.35
	return a

static func thorn_burst() -> AbilityData:
	return _make("Thorn Burst", "A violent eruption of razor-sharp thorns.",
		Enums.StatType.MAGIC_ATTACK, 19, 0, true, 8, false, 0, 0.0)

static func vine_wall() -> AbilityData:
	return _make("Vine Wall", "A living wall of thorned vines shields all allies.",
		Enums.StatType.DEFENSE, 12, 3, false, 6, true, 0, 0.0)

# Witch Doctor
static func voodoo_bolt() -> AbilityData:
	return _make("Voodoo Bolt", "Dark spiritual energy strikes the enemy.",
		Enums.StatType.MAGIC_ATTACK, 7, 0, true, 8, false, 0, 0.3)

static func dark_hex() -> AbilityData:
	return _make("Dark Hex", "A potent curse that weakens magic resistance.",
		Enums.StatType.MAGIC_DEFENSE, 10, 3, true, 6, false, 0, 0.0)

static func creeping_rot() -> AbilityData:
	return _make("Creeping Rot", "A slow decay that rots flesh and festers long after impact.",
		Enums.StatType.HEALTH, 0, 3, true, 6, false, 3, 0.0)

# Spiritwalker
static func spirit_shield() -> AbilityData:
	return _make("Spirit Shield", "Ancestral spirits protect an ally.",
		Enums.StatType.DEFENSE, 10, 3, false, 5, false, 0, 0.0)

static func soul_strike() -> AbilityData:
	return _make("Soul Strike", "A burst of spirit energy tears through the veil.",
		Enums.StatType.MAGIC_ATTACK, 16, 0, true, 7, false, 0, 0.0)

static func spirit_mend() -> AbilityData:
	var a := _make("Spirit Mend", "Healing energy from the spirit world.",
		Enums.StatType.HEALTH, 12, 0, false, 9, false, 0, 0.0)
	a.heal_threshold = 0.35
	return a

# Falconer
static func falcon_strike() -> AbilityData:
	return _make("Falcon Strike", "A raptor dives from above.",
		Enums.StatType.PHYSICAL_ATTACK, 23, 0, true, 9, false, 0, 0.0)

static func rending_talon() -> AbilityData:
	return _make("Rending Talon", "The falcon's talons tear through the enemy's guard, leaving them exposed.",
		Enums.StatType.PHYSICAL_DEFENSE, 20, 3, true, 6, false, 0, 0.0)

static func aerial_strike() -> AbilityData:
	return _make("Aerial Strike", "The falcon sweeps low, raking talons across all enemies.",
		Enums.StatType.PHYSICAL_ATTACK, 20, 0, true, 11, true, 0, 0.0)

# Shapeshifter
static func savage_maul() -> AbilityData:
	return _make("Savage Maul", "Transform and maul the enemy.",
		Enums.StatType.MIXED_ATTACK, 20, 0, true, 9, false, 0, 0.4)

static func frenzy() -> AbilityData:
	return _make("Frenzy", "Enter a bestial rage.",
		Enums.StatType.ATTACK, 16, 3, false, 5, false, 0, 0.0)

static func rampage() -> AbilityData:
	return _make("Rampage", "Unleash the beast within, tearing through all enemies with primal fury.",
		Enums.StatType.MIXED_ATTACK, 16, 0, true, 11, true, 0, 0.0)


# =============================================================================
# Wanderer tree:T1
# =============================================================================

# Sentinel
static func shield_bash() -> AbilityData:
	return _make("Shield Bash", "Drive your shield into the foe with crushing force.",
		Enums.StatType.PHYSICAL_ATTACK, 7, 0, true, 4, false, 0, 0.0)

static func barrier() -> AbilityData:
	return _make("Barrier", "Raise a shimmering ward to protect an ally from magic.",
		Enums.StatType.MAGIC_DEFENSE, 15, 3, false, 3, false, 0, 0.0)

static func fortify() -> AbilityData:
	return _make("Fortify", "Strengthen the whole team's resolve against harm.",
		Enums.StatType.DEFENSE, 7, 3, false, 5, true, 0, 0.0)

# Pathfinder
static func keen_strike() -> AbilityData:
	return _make("Keen Strike", "Strike with precision at an exposed weakness.",
		Enums.StatType.MIXED_ATTACK, 9, 0, true, 4, false, 0, 0.0)

static func exploit_weakness() -> AbilityData:
	return _make("Exploit Weakness", "Study the enemy to find their flaw.",
		Enums.StatType.DEFENSE, 10, 2, true, 3, false, 0, 0.0)

static func adaptable_strike() -> AbilityData:
	return _make("Adaptable Strike", "A versatile blow that siphons the enemy's vitality.",
		Enums.StatType.MIXED_ATTACK, 7, 0, true, 3, false, 0, 0.15)

# =============================================================================
# Wanderer tree:T2
# =============================================================================

# Bulwark - tank/support with taunt and AoE buffs
static func spell_ward() -> AbilityData:
	return _make("Spell Ward", "Raise an anti-magic barrier that shields all allies from spells.",
		Enums.StatType.MAGIC_DEFENSE, 15, 3, false, 7, true, 0, 0.0)

static func iron_fist() -> AbilityData:
	return _make("Iron Fist", "A devastating blow that shatters defenses.",
		Enums.StatType.MIXED_ATTACK, 20, 0, true, 8, false, 0, 0.0)

static func ironclad_challenge() -> AbilityData:
	return _make("Ironclad Challenge", "Issue a thunderous challenge that forces enemies to attack you.",
		Enums.StatType.TAUNT, 0, 3, false, 5, false, 0, 0.0)

# Aegis - tanky fighter with magic-physical hybrid offense
static func arcane_edge() -> AbilityData:
	return _make("Arcane Edge", "Channel magic through your blade in a single devastating strike.",
		Enums.StatType.MIXED_ATTACK, 17, 0, true, 9, false, 0, 0.35)

static func ward_breaker() -> AbilityData:
	return _make("Ward Breaker", "Shatter enemy defenses with a surge of raw power.",
		Enums.StatType.MIXED_ATTACK, 14, 0, true, 8, false, 0, 0.35)

static func spell_counter() -> AbilityData:
	return _make("Spell Counter", "Turn the enemy's magic back upon them.",
		Enums.StatType.MAGIC_ATTACK, 20, 0, true, 8, false, 0, 0.0)

# Trailblazer
static func blaze_trail() -> AbilityData:
	return _make("Blaze Trail", "Charge forward with reckless, blazing speed.",
		Enums.StatType.MIXED_ATTACK, 14, 0, true, 9, false, 0, 0.3)

static func ambush() -> AbilityData:
	return _make("Ambush", "Strike from an unexpected angle, hitting all foes.",
		Enums.StatType.MIXED_ATTACK, 10, 0, true, 10, true, 0, 0.0)

static func expose() -> AbilityData:
	return _make("Expose", "Reveal the enemy's vulnerabilities for all to exploit.",
		Enums.StatType.DEFENSE, 12, 2, true, 6, false, 0, 0.0)

# Survivalist
static func endure() -> AbilityData:
	var a := _make("Endure", "Dig deep and restore your body through sheer willpower.",
		Enums.StatType.HEALTH, 9, 0, false, 9, false, 0, 0.0)
	a.heal_threshold = 0.35
	return a

static func resourceful_strike() -> AbilityData:
	return _make("Resourceful Strike",
		"Strike with practiced efficiency, draining the foe's vitality.",
		Enums.StatType.PHYSICAL_ATTACK, 17, 0, true, 9, false, 0, 0.4)

static func wild_sweep() -> AbilityData:
	return _make("Wild Sweep",
		"A desperate sweeping attack that strikes all nearby enemies.",
		Enums.StatType.PHYSICAL_ATTACK, 11, 0, true, 10, true, 0, 0.0)

static func adapt() -> AbilityData:
	return _make("Adapt", "Heighten your senses and reflexes to the battlefield.",
		Enums.StatType.SPEED, 5, 3, false, 5, false, 0, 0.0)
