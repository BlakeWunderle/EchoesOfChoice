class_name UltimateDB

## Ultimate ability definitions for all 34 T2 classes (2 per class = 68 total).
## Each class gets one offensive and one utility/defensive ultimate option.

const AbilityData := preload("res://scripts/data/ability_data.gd")
const UltimateData := preload("res://scripts/data/ultimate_data.gd")
const Enums := preload("res://scripts/data/enums.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")


static func _make(p_name: String, flavor: String, stat: Enums.StatType, mod: int,
		turns: int, on_enemy: bool, cost: int, all: bool = false,
		dot: int = 0, steal: float = 0.0) -> AbilityData:
	return AbilityDB._make(p_name, flavor, stat, mod, turns, on_enemy, cost, all, dot, steal)


static func _ult(id: String, ult_name: String, desc: String,
		abil: AbilityData, charge: int) -> UltimateData:
	return UltimateData.create(id, ult_name, desc, abil, charge)


## Returns the 2 ultimate options for a given T2 class_id.
static func get_ultimates_for_class(class_id: String) -> Array:
	match class_id:
		# Squire tree
		"Cavalry": return [cavalry_thundering_charge(), cavalry_rallying_cry()]
		"Dragoon": return [dragoon_cataclysm_dive(), dragoon_draconic_aegis()]
		"Mercenary": return [mercenary_execution_shot(), mercenary_killzone()]
		"Hunter": return [hunter_perfect_shot(), hunter_predators_domain()]
		"Ninja": return [ninja_deaths_shadow(), ninja_vanishing_act()]
		"Monk": return [monk_thousand_fists(), monk_transcendence()]
		# Mage tree
		"Infernalist": return [infernalist_inferno(), infernalist_meteor_strike()]
		"Tidecaller": return [tidecaller_maelstrom(), tidecaller_deluge()]
		"Tempest": return [tempest_supercell(), tempest_eye_of_the_storm()]
		"Paladin": return [paladin_divine_judgment(), paladin_sacred_barrier()]
		"Priest": return [priest_holy_nova(), priest_salvation()]
		"Warlock": return [warlock_soul_harvest(), warlock_plague_of_shadows()]
		# Entertainer tree
		"Warcrier": return [warcrier_war_cry(), warcrier_battle_anthem()]
		"Minstrel": return [minstrel_crescendo(), minstrel_symphony_of_renewal()]
		"Illusionist": return [illusionist_grand_illusion(), illusionist_mirror_image()]
		"Mime": return [mime_perfect_copy(), mime_mimes_bulwark()]
		"Laureate": return [laureate_magnum_opus(), laureate_words_of_might()]
		"Elegist": return [elegist_requiem(), elegist_elegy_of_sorrow()]
		# Tinker tree
		"Alchemist": return [alchemist_transmutation(), alchemist_philosophers_stone()]
		"Bombardier": return [bombardier_carpet_bombing(), bombardier_precision_strike()]
		"Chronomancer": return [chronomancer_time_stop(), chronomancer_temporal_acceleration()]
		"Astronomer": return [astronomer_supernova(), astronomer_cosmic_alignment()]
		"Automaton": return [automaton_overload(), automaton_iron_fortress()]
		"Technomancer": return [technomancer_arc_lightning(), technomancer_power_surge()]
		# Wildling tree
		"Blighter": return [blighter_blight_storm(), blighter_withering_curse()]
		"GroveKeeper": return [grove_keeper_natures_embrace(), grove_keeper_overgrowth()]
		"WitchDoctor": return [witch_doctor_plague_voodoo(), witch_doctor_hex_storm()]
		"Spiritwalker": return [spiritwalker_spirit_wrath(), spiritwalker_ancestral_blessing()]
		"Falconer": return [falconer_death_from_above(), falconer_raptor_storm()]
		"Shapeshifter": return [shapeshifter_apex_predator(), shapeshifter_ironhide()]
		# Wanderer tree
		"Bulwark": return [bulwark_shield_slam(), bulwark_unbreakable()]
		"Aegis": return [aegis_counter_storm(), aegis_aegis_wall()]
		"Trailblazer": return [trailblazer_blazing_trail(), trailblazer_expose_weakness()]
		"Survivalist": return [survivalist_endurance_strike(), survivalist_will_to_live()]
		_: return []


## Lookup a single ultimate by its unique ID (for save/load).
static func get_ultimate_by_id(id: String) -> UltimateData:
	for class_id: String in _ALL_T2_IDS:
		for ult: UltimateData in get_ultimates_for_class(class_id):
			if ult.ultimate_id == id:
				return ult
	return null


const _ALL_T2_IDS: Array[String] = [
	"Cavalry", "Dragoon", "Mercenary", "Hunter", "Ninja", "Monk",
	"Infernalist", "Tidecaller", "Tempest", "Paladin", "Priest", "Warlock",
	"Warcrier", "Minstrel", "Illusionist", "Mime", "Laureate", "Elegist",
	"Alchemist", "Bombardier", "Chronomancer", "Astronomer", "Automaton", "Technomancer",
	"Blighter", "GroveKeeper", "WitchDoctor", "Spiritwalker", "Falconer", "Shapeshifter",
	"Bulwark", "Aegis", "Trailblazer", "Survivalist",
]


# =============================================================================
# Squire tree
# =============================================================================

# Cavalry -- DPS / AoE / Crit / Physical
static func cavalry_thundering_charge() -> UltimateData:
	return _ult("cavalry_thundering_charge", "Thundering Charge",
		"Ride through every foe in a devastating mounted charge.",
		_make("Thundering Charge",
			"The ground shakes as hooves thunder across the battlefield.",
			Enums.StatType.PHYSICAL_ATTACK, 30, 0, true, 0, true),
		100)

static func cavalry_rallying_cry() -> UltimateData:
	return _ult("cavalry_rallying_cry", "Rallying Cry",
		"Rally the party with a battle cry that sharpens blades and quickens feet.",
		_make("Rallying Cry",
			"A commanding shout rings across the field, steel sings in answer.",
			Enums.StatType.ATTACK, 15, 3, false, 0, true),
		80)

# Dragoon -- Fighter / AoE / Mixed
static func dragoon_cataclysm_dive() -> UltimateData:
	return _ult("dragoon_cataclysm_dive", "Cataclysm Dive",
		"Soar impossibly high and crash down with world-shattering force.",
		_make("Cataclysm Dive",
			"The sky splits open as draconic fury descends upon the battlefield.",
			Enums.StatType.MIXED_ATTACK, 35, 0, true, 0, true),
		120)

static func dragoon_draconic_aegis() -> UltimateData:
	return _ult("dragoon_draconic_aegis", "Draconic Aegis",
		"Wrap the party in dragon-scale armor that turns aside all blows.",
		_make("Draconic Aegis",
			"Ancient scales shimmer into existence around each ally.",
			Enums.StatType.DEFENSE, 18, 3, false, 0, true),
		80)

# Mercenary -- Burst / Glass Cannon / Crit / Physical
static func mercenary_execution_shot() -> UltimateData:
	return _ult("mercenary_execution_shot", "Execution Shot",
		"Line up the perfect kill shot. Devastating single-target damage.",
		_make("Execution Shot",
			"One bullet. One chance. The mercenary never misses.",
			Enums.StatType.PHYSICAL_ATTACK, 45, 0, true, 0, false),
		100)

static func mercenary_killzone() -> UltimateData:
	return _ult("mercenary_killzone", "Killzone",
		"Blanket the field in gunfire, shredding all enemies.",
		_make("Killzone",
			"Smoke and thunder fill the air as bullets tear through everything.",
			Enums.StatType.PHYSICAL_ATTACK, 28, 0, true, 0, true),
		120)

# Hunter -- Fighter / Debuffer / Physical
static func hunter_perfect_shot() -> UltimateData:
	return _ult("hunter_perfect_shot", "Perfect Shot",
		"A single arrow placed with inhuman precision.",
		_make("Perfect Shot",
			"The arrow flies true, finding the one gap in every defense.",
			Enums.StatType.PHYSICAL_ATTACK, 42, 0, true, 0, false),
		100)

static func hunter_predators_domain() -> UltimateData:
	return _ult("hunter_predators_domain", "Predator's Domain",
		"Mark all enemies, exposing every weakness at once.",
		_make("Predator's Domain",
			"Hunter's instinct surges. Every flaw and opening becomes visible.",
			Enums.StatType.DEFENSE, 16, 3, true, 0, true),
		80)

# Ninja -- DPS / Glass Cannon / Evasion / Crit / Physical
static func ninja_deaths_shadow() -> UltimateData:
	return _ult("ninja_deaths_shadow", "Death's Shadow",
		"Strike from the void with a blade that drinks the life of its target.",
		_make("Death's Shadow",
			"A shadow detaches from the darkness and strikes with lethal precision.",
			Enums.StatType.PHYSICAL_ATTACK, 40, 0, true, 0, false, 0, 0.3),
		100)

static func ninja_vanishing_act() -> UltimateData:
	return _ult("ninja_vanishing_act", "Vanishing Act",
		"Shroud the entire party in shadow, making everyone nearly impossible to hit.",
		_make("Vanishing Act",
			"Shadows swirl and engulf the party. They flicker in and out of sight.",
			Enums.StatType.DODGE_CHANCE, 15, 3, false, 0, true),
		80)

# Monk -- Fighter / Support / Healer / Mixed
static func monk_thousand_fists() -> UltimateData:
	return _ult("monk_thousand_fists", "Thousand Fists",
		"Unleash a storm of spiritual strikes on a single target.",
		_make("Thousand Fists",
			"Each blow carries the weight of a lifetime of discipline.",
			Enums.StatType.MIXED_ATTACK, 42, 0, true, 0, false),
		100)

static func monk_transcendence() -> UltimateData:
	return _ult("monk_transcendence", "Transcendence",
		"Channel inner harmony to heal the entire party.",
		_make("Transcendence",
			"A wave of spiritual calm washes over every ally, mending body and soul.",
			Enums.StatType.HEALTH, 25, 0, false, 0, true),
		80)


# =============================================================================
# Mage tree
# =============================================================================

# Infernalist -- Burst / Caster / Glass Cannon / AoE / Magical
static func infernalist_inferno() -> UltimateData:
	return _ult("infernalist_inferno", "Inferno",
		"Engulf the entire battlefield in all-consuming flame.",
		_make("Inferno",
			"Fire rises from the earth itself, consuming everything in its path.",
			Enums.StatType.MAGIC_ATTACK, 35, 0, true, 0, true),
		120)

static func infernalist_meteor_strike() -> UltimateData:
	return _ult("infernalist_meteor_strike", "Meteor Strike",
		"Call down a meteor from the heavens to obliterate a single foe.",
		_make("Meteor Strike",
			"The sky burns crimson as a star falls upon the enemy.",
			Enums.StatType.MAGIC_ATTACK, 48, 0, true, 0, false),
		100)

# Tidecaller -- Support / Caster / Healer / AoE / Magical
static func tidecaller_maelstrom() -> UltimateData:
	return _ult("tidecaller_maelstrom", "Maelstrom",
		"Summon a crushing vortex of water to batter all enemies.",
		_make("Maelstrom",
			"The sea answers the call. A roaring spiral of water descends.",
			Enums.StatType.MAGIC_ATTACK, 30, 0, true, 0, true),
		100)

static func tidecaller_deluge() -> UltimateData:
	return _ult("tidecaller_deluge", "Deluge",
		"A restorative tidal wave washes over the party, healing all wounds.",
		_make("Deluge",
			"Cool water surges through the party, knitting flesh and calming minds.",
			Enums.StatType.HEALTH, 28, 0, false, 0, true),
		80)

# Tempest -- Caster / AoE / Magical
static func tempest_supercell() -> UltimateData:
	return _ult("tempest_supercell", "Supercell",
		"Conjure a devastating storm that tears through all enemies.",
		_make("Supercell",
			"Lightning, wind, and thunder collide in a cataclysmic tempest.",
			Enums.StatType.MAGIC_ATTACK, 32, 0, true, 0, true),
		100)

static func tempest_eye_of_the_storm() -> UltimateData:
	return _ult("tempest_eye_of_the_storm", "Eye of the Storm",
		"Surround the party with charged air that amplifies all magic.",
		_make("Eye of the Storm",
			"Static crackles across every ally. Their spells burn brighter.",
			Enums.StatType.MAGIC_ATTACK, 16, 3, false, 0, true),
		80)

# Paladin -- Fighter / Support / Tank / Healer / Mixed
static func paladin_divine_judgment() -> UltimateData:
	return _ult("paladin_divine_judgment", "Divine Judgment",
		"Channel holy wrath into a single devastating blow.",
		_make("Divine Judgment",
			"Light gathers in the blade, then falls like the judgment of heaven.",
			Enums.StatType.MIXED_ATTACK, 44, 0, true, 0, false),
		100)

static func paladin_sacred_barrier() -> UltimateData:
	return _ult("paladin_sacred_barrier", "Sacred Barrier",
		"Raise a divine shield that protects the entire party.",
		_make("Sacred Barrier",
			"A wall of golden light rises around each ally, turning aside all harm.",
			Enums.StatType.DEFENSE, 18, 3, false, 0, true),
		80)

# Priest -- Support / Caster / Healer / Buffer / Magical
static func priest_holy_nova() -> UltimateData:
	return _ult("priest_holy_nova", "Holy Nova",
		"Release a burst of sacred light that sears all enemies.",
		_make("Holy Nova",
			"Pure light erupts outward, burning every shadow it touches.",
			Enums.StatType.MAGIC_ATTACK, 28, 0, true, 0, true),
		100)

static func priest_salvation() -> UltimateData:
	return _ult("priest_salvation", "Salvation",
		"A prayer of absolute devotion that restores the entire party.",
		_make("Salvation",
			"Warm light descends from above, closing every wound at once.",
			Enums.StatType.HEALTH, 30, 0, false, 0, true),
		80)

# Warlock -- Caster / Debuffer / Drain / Magical
static func warlock_soul_harvest() -> UltimateData:
	return _ult("warlock_soul_harvest", "Soul Harvest",
		"Rip the life essence from a target, healing yourself with stolen vitality.",
		_make("Soul Harvest",
			"Dark tendrils pierce the enemy, draining life to feed the caster.",
			Enums.StatType.MAGIC_ATTACK, 40, 0, true, 0, false, 0, 0.4),
		100)

static func warlock_plague_of_shadows() -> UltimateData:
	return _ult("warlock_plague_of_shadows", "Plague of Shadows",
		"Curse all enemies, sapping their offensive power.",
		_make("Plague of Shadows",
			"Dark fog creeps across the battlefield, weakening everything it touches.",
			Enums.StatType.ATTACK, 16, 3, true, 0, true),
		80)


# =============================================================================
# Entertainer tree
# =============================================================================

# Warcrier -- Support / Fighter / Buffer / Physical
static func warcrier_war_cry() -> UltimateData:
	return _ult("warcrier_war_cry", "War Cry",
		"A primal shout that batters all enemies with sheer force.",
		_make("War Cry",
			"The roar shakes the ground and rattles the bones of every foe.",
			Enums.StatType.PHYSICAL_ATTACK, 28, 0, true, 0, true),
		100)

static func warcrier_battle_anthem() -> UltimateData:
	return _ult("warcrier_battle_anthem", "Battle Anthem",
		"Sing a war song that fills the party with strength and speed.",
		_make("Battle Anthem",
			"Every ally feels their blood quicken and their arms grow strong.",
			Enums.StatType.ATTACK, 15, 3, false, 0, true),
		80)

# Minstrel -- Support / Healer / Buffer / Magical
static func minstrel_crescendo() -> UltimateData:
	return _ult("minstrel_crescendo", "Crescendo",
		"Build to a shattering musical climax that overwhelms all enemies.",
		_make("Crescendo",
			"The melody rises, higher and higher, until it shatters the air.",
			Enums.StatType.MAGIC_ATTACK, 28, 0, true, 0, true),
		100)

static func minstrel_symphony_of_renewal() -> UltimateData:
	return _ult("minstrel_symphony_of_renewal", "Symphony of Renewal",
		"Play a healing melody that restores the entire party.",
		_make("Symphony of Renewal",
			"Gentle notes drift across the field, mending wounds with every measure.",
			Enums.StatType.HEALTH, 28, 0, false, 0, true),
		80)

# Illusionist -- DPS / Debuffer / Evasion / Magical
static func illusionist_grand_illusion() -> UltimateData:
	return _ult("illusionist_grand_illusion", "Grand Illusion",
		"Shatter reality around all enemies with an overwhelming phantasm.",
		_make("Grand Illusion",
			"The world twists. What is real? Every enemy sees their worst fear.",
			Enums.StatType.MAGIC_ATTACK, 30, 0, true, 0, true),
		100)

static func illusionist_mirror_image() -> UltimateData:
	return _ult("illusionist_mirror_image", "Mirror Image",
		"Create illusory doubles that make the entire party nearly untouchable.",
		_make("Mirror Image",
			"Copies of each ally shimmer into existence. Which is real?",
			Enums.StatType.DODGE_CHANCE, 15, 3, false, 0, true),
		80)

# Mime -- Tank / Fighter / Mixed
static func mime_perfect_copy() -> UltimateData:
	return _ult("mime_perfect_copy", "Perfect Copy",
		"Mirror the battlefield's energy into a single devastating strike.",
		_make("Perfect Copy",
			"Every motion on the field is absorbed and released in one blow.",
			Enums.StatType.MIXED_ATTACK, 42, 0, true, 0, false),
		100)

static func mime_mimes_bulwark() -> UltimateData:
	return _ult("mime_mimes_bulwark", "Mime's Bulwark",
		"Mime an invisible wall that shields the entire party.",
		_make("Mime's Bulwark",
			"Hands press against nothing. Yet no attack can pass through.",
			Enums.StatType.DEFENSE, 18, 3, false, 0, true),
		80)

# Laureate -- Support / Buffer / AoE / Magical
static func laureate_magnum_opus() -> UltimateData:
	return _ult("laureate_magnum_opus", "Magnum Opus",
		"Recite the greatest work ever composed, empowering all allies.",
		_make("Magnum Opus",
			"Words of power cascade forth. Every ally stands taller, fights harder.",
			Enums.StatType.ATTACK, 16, 3, false, 0, true),
		80)

static func laureate_words_of_might() -> UltimateData:
	return _ult("laureate_words_of_might", "Words of Might",
		"Speak words of such force that they strike all enemies.",
		_make("Words of Might",
			"Each syllable lands like a hammer blow across the battlefield.",
			Enums.StatType.MAGIC_ATTACK, 30, 0, true, 0, true),
		100)

# Elegist -- Support / Debuffer / AoE / Magical
static func elegist_requiem() -> UltimateData:
	return _ult("elegist_requiem", "Requiem",
		"Sing a dirge that saps the fighting spirit from all enemies.",
		_make("Requiem",
			"A mournful song fills the air. The enemy's will to fight crumbles.",
			Enums.StatType.ATTACK, 16, 3, true, 0, true),
		80)

static func elegist_elegy_of_sorrow() -> UltimateData:
	return _ult("elegist_elegy_of_sorrow", "Elegy of Sorrow",
		"Channel grief into a wave of sorrow that overwhelms all enemies.",
		_make("Elegy of Sorrow",
			"Tears become weapons. The weight of loss crashes over every foe.",
			Enums.StatType.MAGIC_ATTACK, 30, 0, true, 0, true),
		100)


# =============================================================================
# Tinker tree
# =============================================================================

# Alchemist -- Support / Healer / DoT / Magical
static func alchemist_transmutation() -> UltimateData:
	return _ult("alchemist_transmutation", "Transmutation",
		"Hurl a volatile concoction that erupts across all enemies.",
		_make("Transmutation",
			"Glass shatters. Fumes rise. The mixture burns through everything.",
			Enums.StatType.MAGIC_ATTACK, 30, 0, true, 0, true),
		100)

static func alchemist_philosophers_stone() -> UltimateData:
	return _ult("alchemist_philosophers_stone", "Philosopher's Stone",
		"Brew the legendary elixir that restores the entire party.",
		_make("Philosopher's Stone",
			"Golden liquid pours forth, healing flesh and spirit alike.",
			Enums.StatType.HEALTH, 28, 0, false, 0, true),
		80)

# Bombardier -- Burst / Glass Cannon / AoE / Magical
static func bombardier_carpet_bombing() -> UltimateData:
	return _ult("bombardier_carpet_bombing", "Carpet Bombing",
		"Rain explosions across the entire battlefield.",
		_make("Carpet Bombing",
			"The sky fills with fire. Nowhere is safe. Everything burns.",
			Enums.StatType.MAGIC_ATTACK, 35, 0, true, 0, true),
		120)

static func bombardier_precision_strike() -> UltimateData:
	return _ult("bombardier_precision_strike", "Precision Strike",
		"Concentrate all firepower on a single devastating explosion.",
		_make("Precision Strike",
			"One perfect charge. One perfect throw. One perfect detonation.",
			Enums.StatType.MAGIC_ATTACK, 48, 0, true, 0, false),
		100)

# Chronomancer -- Support / Caster / Buffer / Debuffer / Magical
static func chronomancer_time_stop() -> UltimateData:
	return _ult("chronomancer_time_stop", "Time Stop",
		"Freeze all enemies in time, slowing them to a crawl.",
		_make("Time Stop",
			"The clock stops. Every enemy hangs suspended in frozen time.",
			Enums.StatType.SPEED, 16, 3, true, 0, true),
		80)

static func chronomancer_temporal_acceleration() -> UltimateData:
	return _ult("chronomancer_temporal_acceleration", "Temporal Acceleration",
		"Accelerate time for the party, letting everyone act faster.",
		_make("Temporal Acceleration",
			"Time bends. Every ally moves in a blur of accelerated motion.",
			Enums.StatType.SPEED, 16, 3, false, 0, true),
		80)

# Astronomer -- Burst / Caster / Glass Cannon / AoE / Magical
static func astronomer_supernova() -> UltimateData:
	return _ult("astronomer_supernova", "Supernova",
		"Channel the death of a star into a cataclysmic explosion.",
		_make("Supernova",
			"A point of impossible light collapses, then explodes outward.",
			Enums.StatType.MAGIC_ATTACK, 35, 0, true, 0, true),
		120)

static func astronomer_cosmic_alignment() -> UltimateData:
	return _ult("astronomer_cosmic_alignment", "Cosmic Alignment",
		"Align celestial forces to amplify the party's magical power.",
		_make("Cosmic Alignment",
			"Stars wheel overhead. Arcane power floods through every ally.",
			Enums.StatType.MAGIC_ATTACK, 16, 3, false, 0, true),
		80)

# Automaton -- Tank / Fighter / Mixed
static func automaton_overload() -> UltimateData:
	return _ult("automaton_overload", "Overload",
		"Push all systems past their limits for one devastating strike.",
		_make("Overload",
			"Gears scream. Steam vents. Every joule of power channels into one blow.",
			Enums.StatType.MIXED_ATTACK, 44, 0, true, 0, false),
		100)

static func automaton_iron_fortress() -> UltimateData:
	return _ult("automaton_iron_fortress", "Iron Fortress",
		"Deploy armor plating that shields the entire party.",
		_make("Iron Fortress",
			"Metal panels unfold and lock into place around every ally.",
			Enums.StatType.DEFENSE, 18, 3, false, 0, true),
		80)

# Technomancer -- Fighter / Caster / Drain / Mixed
static func technomancer_arc_lightning() -> UltimateData:
	return _ult("technomancer_arc_lightning", "Arc Lightning",
		"Release a chain of lightning that arcs through all enemies and drains their energy.",
		_make("Arc Lightning",
			"Electricity leaps from foe to foe. Each spark feeds the caster.",
			Enums.StatType.MIXED_ATTACK, 26, 0, true, 0, true, 0, 0.25),
		100)

static func technomancer_power_surge() -> UltimateData:
	return _ult("technomancer_power_surge", "Power Surge",
		"Overcharge the party's weapons with raw magical energy.",
		_make("Power Surge",
			"Crackling energy arcs across every blade and staff.",
			Enums.StatType.ATTACK, 15, 3, false, 0, true),
		80)


# =============================================================================
# Wildling tree
# =============================================================================

# Blighter -- Caster / DoT / Magical
static func blighter_blight_storm() -> UltimateData:
	return _ult("blighter_blight_storm", "Blight Storm",
		"Unleash a toxic tempest that ravages all enemies.",
		_make("Blight Storm",
			"Poisonous clouds surge across the field, corroding everything.",
			Enums.StatType.MAGIC_ATTACK, 32, 0, true, 0, true),
		100)

static func blighter_withering_curse() -> UltimateData:
	return _ult("blighter_withering_curse", "Withering Curse",
		"Curse all enemies, rotting their defenses from within.",
		_make("Withering Curse",
			"Dark spores settle on every foe. Their armor crumbles to dust.",
			Enums.StatType.DEFENSE, 16, 3, true, 0, true),
		80)

# Grove Keeper -- Support / Hybrid / Healer / Buffer / Magical
static func grove_keeper_natures_embrace() -> UltimateData:
	return _ult("grove_keeper_natures_embrace", "Nature's Embrace",
		"Call upon the forest to heal the entire party.",
		_make("Nature's Embrace",
			"Roots and vines cradle each ally, pouring life into every wound.",
			Enums.StatType.HEALTH, 28, 0, false, 0, true),
		80)

static func grove_keeper_overgrowth() -> UltimateData:
	return _ult("grove_keeper_overgrowth", "Overgrowth",
		"Surround the party in living armor of bark and thorns.",
		_make("Overgrowth",
			"The forest answers. Bark hardens around each ally like a second skin.",
			Enums.StatType.DEFENSE, 18, 3, false, 0, true),
		80)

# Witch Doctor -- Support / Caster / Debuffer / DoT / Magical
static func witch_doctor_plague_voodoo() -> UltimateData:
	return _ult("witch_doctor_plague_voodoo", "Plague Voodoo",
		"Unleash a devastating hex that strikes all enemies.",
		_make("Plague Voodoo",
			"Dolls crumble to dust. Every enemy staggers as the curse takes hold.",
			Enums.StatType.MAGIC_ATTACK, 30, 0, true, 0, true),
		100)

static func witch_doctor_hex_storm() -> UltimateData:
	return _ult("witch_doctor_hex_storm", "Hex Storm",
		"Weave a storm of hexes that weakens all enemies.",
		_make("Hex Storm",
			"Curses swirl through the air, draining power from every foe.",
			Enums.StatType.ATTACK, 16, 3, true, 0, true),
		80)

# Spiritwalker -- Support / Caster / Healer / Buffer / Magical
static func spiritwalker_spirit_wrath() -> UltimateData:
	return _ult("spiritwalker_spirit_wrath", "Spirit Wrath",
		"Summon ancestral spirits to strike all enemies.",
		_make("Spirit Wrath",
			"Ghostly warriors charge through the battlefield, striking every foe.",
			Enums.StatType.MAGIC_ATTACK, 30, 0, true, 0, true),
		100)

static func spiritwalker_ancestral_blessing() -> UltimateData:
	return _ult("spiritwalker_ancestral_blessing", "Ancestral Blessing",
		"Call upon the ancestors to heal and protect the party.",
		_make("Ancestral Blessing",
			"Whispers of the departed fill the air. Warmth and strength follow.",
			Enums.StatType.HEALTH, 28, 0, false, 0, true),
		80)

# Falconer -- DPS / Glass Cannon / Physical
static func falconer_death_from_above() -> UltimateData:
	return _ult("falconer_death_from_above", "Death From Above",
		"Command your raptor to dive with lethal precision on a single target.",
		_make("Death From Above",
			"The falcon screams and dives. Talons find their mark with terrible force.",
			Enums.StatType.PHYSICAL_ATTACK, 45, 0, true, 0, false),
		100)

static func falconer_raptor_storm() -> UltimateData:
	return _ult("falconer_raptor_storm", "Raptor Storm",
		"Call a flock of raptors to assault all enemies.",
		_make("Raptor Storm",
			"The sky darkens with wings. Talons and beaks tear at every foe.",
			Enums.StatType.PHYSICAL_ATTACK, 28, 0, true, 0, true),
		100)

# Shapeshifter -- Hybrid / Tank / Physical
static func shapeshifter_apex_predator() -> UltimateData:
	return _ult("shapeshifter_apex_predator", "Apex Predator",
		"Transform into a monstrous beast and strike with primal fury.",
		_make("Apex Predator",
			"Bones crack and reform. A creature of pure savagery lunges forward.",
			Enums.StatType.PHYSICAL_ATTACK, 44, 0, true, 0, false),
		100)

static func shapeshifter_ironhide() -> UltimateData:
	return _ult("shapeshifter_ironhide", "Ironhide",
		"Shift into an armored form that protects the entire party.",
		_make("Ironhide",
			"Thick scales spread across every ally. Nothing can pierce this hide.",
			Enums.StatType.DEFENSE, 18, 3, false, 0, true),
		80)


# =============================================================================
# Wanderer tree
# =============================================================================

# Bulwark -- Tank / Buffer / Physical
static func bulwark_shield_slam() -> UltimateData:
	return _ult("bulwark_shield_slam", "Shield Slam",
		"Put every ounce of strength behind the shield for a devastating blow.",
		_make("Shield Slam",
			"The shield connects with the force of a battering ram.",
			Enums.StatType.PHYSICAL_ATTACK, 42, 0, true, 0, false),
		100)

static func bulwark_unbreakable() -> UltimateData:
	return _ult("bulwark_unbreakable", "Unbreakable",
		"Fortify the party with an unshakable defensive stance.",
		_make("Unbreakable",
			"The bulwark plants their feet. An aura of invincibility radiates outward.",
			Enums.StatType.DEFENSE, 20, 3, false, 0, true),
		80)

# Aegis -- Fighter / Tank / Mixed
static func aegis_counter_storm() -> UltimateData:
	return _ult("aegis_counter_storm", "Counter Storm",
		"Release a burst of stored counter-energy in a devastating mixed strike.",
		_make("Counter Storm",
			"Every blocked blow returns tenfold in a single explosive release.",
			Enums.StatType.MIXED_ATTACK, 44, 0, true, 0, false),
		100)

static func aegis_aegis_wall() -> UltimateData:
	return _ult("aegis_aegis_wall", "Aegis Wall",
		"Raise an impenetrable magical barrier around the party.",
		_make("Aegis Wall",
			"Runes blaze to life. A shimmering wall surrounds every ally.",
			Enums.StatType.DEFENSE, 18, 3, false, 0, true),
		80)

# Trailblazer -- Fighter / Debuffer / Mixed
static func trailblazer_blazing_trail() -> UltimateData:
	return _ult("trailblazer_blazing_trail", "Blazing Trail",
		"Carve a path of destruction through all enemies.",
		_make("Blazing Trail",
			"A streak of fire and steel cuts across the entire enemy line.",
			Enums.StatType.MIXED_ATTACK, 30, 0, true, 0, true),
		100)

static func trailblazer_expose_weakness() -> UltimateData:
	return _ult("trailblazer_expose_weakness", "Expose Weakness",
		"Reveal every enemy's vulnerabilities to the entire party.",
		_make("Expose Weakness",
			"The trailblazer reads the battlefield. Every flaw becomes clear.",
			Enums.StatType.DEFENSE, 16, 3, true, 0, true),
		80)

# Survivalist -- Tank / Drain / Mixed
static func survivalist_endurance_strike() -> UltimateData:
	return _ult("survivalist_endurance_strike", "Endurance Strike",
		"A relentless strike that heals with every point of damage dealt.",
		_make("Endurance Strike",
			"Pain fuels power. Every wound dealt returns as strength.",
			Enums.StatType.MIXED_ATTACK, 38, 0, true, 0, false, 0, 0.35),
		100)

static func survivalist_will_to_live() -> UltimateData:
	return _ult("survivalist_will_to_live", "Will to Live",
		"Draw on sheer determination to heal the entire party.",
		_make("Will to Live",
			"Refuse to fall. That stubbornness spreads to every ally.",
			Enums.StatType.HEALTH, 25, 0, false, 0, true),
		80)
