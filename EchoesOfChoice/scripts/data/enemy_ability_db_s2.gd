class_name EnemyAbilityDBS2

## Story 2 enemy abilities (cave + surface).

const AbilityData := preload("res://scripts/data/ability_data.gd")
const Enums := preload("res://scripts/data/enums.gd")
const AbilityDB := preload("res://scripts/data/ability_db.gd")


static func _make(p_name: String, flavor: String, stat: Enums.StatType, mod: int,
		turns: int, on_enemy: bool, cost: int, all: bool = false,
		dot: int = 0, steal: float = 0.0, cd: int = 0) -> AbilityData:
	return AbilityDB._make(p_name, flavor, stat, mod, turns, on_enemy, cost, all, dot, steal, cd)


# =============================================================================
# Act I: Cave creature abilities
# =============================================================================

# --- Glow Worm ---

static func luminous_pulse() -> AbilityData:
	return _make("Luminous Pulse", "A blinding pulse of bioluminescence.", Enums.StatType.MAGIC_ATTACK, 3, 0, true, 2, false, 0, 0.0, 1)

static func glare() -> AbilityData:
	return _make("Glare", "Intense light sears the eyes.", Enums.StatType.MAGIC_ATTACK, 4, 0, true, 3, false, 0, 0.0, 2)

# --- Crystal Spider ---

static func crystal_fang() -> AbilityData:
	return _make("Crystal Fang", "Crystalline mandibles pierce deep.", Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 2, false, 0, 0.0, 1)

static func refract() -> AbilityData:
	return _make("Refract", "Light bends around the crystal body.", Enums.StatType.DEFENSE, 3, 2, false, 2, false, 0, 0.0, 2)

# --- Shade Crawler ---

static func shadow_lash() -> AbilityData:
	return _make("Shadow Lash", "A tendril of darkness whips forward.", Enums.StatType.MIXED_ATTACK, 4, 0, true, 3, false, 0, 0.0, 1)

static func dissolve() -> AbilityData:
	return _make("Dissolve", "The crawler's form blurs and shifts.", Enums.StatType.DODGE_CHANCE, 10, 2, false, 2, false, 0, 0.0, 2)

# --- Echo Wisp ---

static func resonance() -> AbilityData:
	return _make("Resonance", "Sound warps into a concussive blast.", Enums.StatType.MAGIC_ATTACK, 5, 0, true, 3, false, 0, 0.0, 2)

static func distortion() -> AbilityData:
	return _make("Distortion", "Reality warps, slowing all enemies.", Enums.StatType.SPEED, 4, 2, true, 4, true, 0, 0.0, 3)

# --- Cave Maw ---

static func gnash() -> AbilityData:
	return _make("Gnash", "Rows of stone teeth grind together.", Enums.StatType.PHYSICAL_ATTACK, 6, 0, true, 3, false, 0, 0.0, 2)

static func swallow() -> AbilityData:
	return _make("Swallow", "The maw tries to consume its prey.", Enums.StatType.PHYSICAL_ATTACK, 8, 0, true, 4, false, 0, 0.0, 2)

static func tremor() -> AbilityData:
	return _make("Tremor", "The cave shakes violently.", Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 4, true, 0, 0.0, 3)

# --- Vein Leech ---

static func latch() -> AbilityData:
	return _make("Latch", "Barbed tendrils dig into flesh and drain.", Enums.StatType.PHYSICAL_ATTACK, 5, 0, true, 3, false, 0, 0.3, 1)

static func siphon_glow() -> AbilityData:
	return _make("Siphon Glow", "Stolen light weakens the target's defenses.", Enums.StatType.DEFENSE, 3, 2, true, 2, false, 0, 0.0, 2)

# --- Stone Moth ---

static func wing_dust() -> AbilityData:
	return _make("Wing Dust", "A cloud of mineral dust slows reflexes.", Enums.StatType.SPEED, 4, 2, true, 3, true, 0, 0.0, 3)

static func petrify_pulse() -> AbilityData:
	return _make("Petrify Pulse", "A flash of stone-grey light.", Enums.StatType.MAGIC_ATTACK, 5, 0, true, 3, false, 0, 0.0, 2)

# --- Spore Stalker ---

static func toxic_dart() -> AbilityData:
	return _make("Toxic Dart", "A barb dripping with fungal venom.", Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 3, false, 0, 0.0, 1)

static func spore_burst() -> AbilityData:
	return _make("Spore Burst", "A cloud of toxic spores settles over the target.", Enums.StatType.MAGIC_ATTACK, 3, 3, true, 3, false, 3, 0.0, 2)

# --- Fungal Hulk ---

static func fungal_slam() -> AbilityData:
	return _make("Fungal Slam", "A massive fungal limb crashes down.", Enums.StatType.PHYSICAL_ATTACK, 6, 0, true, 3, false, 0, 0.0, 2)

static func mycelium_shield() -> AbilityData:
	return _make("Mycelium Shield", "Fibrous growth hardens into armor.", Enums.StatType.DEFENSE, 4, 2, false, 3, false, 0, 0.0, 2)

# --- Cap Wisp ---

static func hallucinate() -> AbilityData:
	return _make("Hallucinate", "Spores cloud the mind with visions.", Enums.StatType.MAGIC_ATTACK, 5, 0, true, 3, false, 0, 0.0, 2)

static func befuddle() -> AbilityData:
	return _make("Befuddle", "A wave of confusion dulls reflexes.", Enums.StatType.SPEED, 4, 2, true, 3, true, 0, 0.0, 3)

# --- Cave Eel ---

static func jolt() -> AbilityData:
	return _make("Jolt", "An electric snap from the darkness.", Enums.StatType.PHYSICAL_ATTACK, 5, 0, true, 3, false, 0, 0.0, 1)

static func arc_flash() -> AbilityData:
	return _make("Arc Flash", "Electricity arcs through the water.", Enums.StatType.MAGIC_ATTACK, 4, 0, true, 3, true, 0, 0.0, 3)

# --- Blind Angler ---

static func lure_light() -> AbilityData:
	return _make("Lure Light", "A hypnotic glow draws the unwary close.", Enums.StatType.MAGIC_ATTACK, 5, 0, true, 3, false, 0, 0.0, 2)

static func abyssal_gaze() -> AbilityData:
	return _make("Abyssal Gaze", "Empty eyes strip away defenses.", Enums.StatType.DEFENSE, 4, 2, true, 3, false, 0, 0.0, 2)

# --- Pale Crayfish ---

static func pincer_crush() -> AbilityData:
	return _make("Pincer Crush", "Armored claws close with terrible force.", Enums.StatType.PHYSICAL_ATTACK, 6, 0, true, 3, false, 0, 0.0, 2)

static func shell_up() -> AbilityData:
	return _make("Shell Up", "The crayfish withdraws into its shell.", Enums.StatType.DEFENSE, 5, 2, false, 2, false, 0, 0.0, 2)

# --- Cave Dweller ---

static func crude_axe() -> AbilityData:
	return _make("Crude Axe", "A rough-hewn axe swings with brute force.", Enums.StatType.PHYSICAL_ATTACK, 5, 0, true, 2, false, 0, 0.0, 1)

static func rock_toss() -> AbilityData:
	return _make("Rock Toss", "Stones rain down from the darkness.", Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 3, true, 0, 0.0, 3)

# --- Tunnel Shaman ---

static func hex_flame() -> AbilityData:
	return _make("Hex Flame", "Cursed fire leaps from painted fingers.", Enums.StatType.MAGIC_ATTACK, 6, 0, true, 3, false, 0, 0.0, 2)

static func ward_bones() -> AbilityData:
	return _make("Ward Bones", "Bone totems flare with protective light.", Enums.StatType.MAGIC_DEFENSE, 4, 2, false, 3, true, 0, 0.0, 3)

# --- Burrow Scout ---

static func dart_strike() -> AbilityData:
	return _make("Dart Strike", "A quick jab from the shadows.", Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 2, false, 0, 0.0, 1)

static func smoke_bomb() -> AbilityData:
	return _make("Smoke Bomb", "Acrid smoke obscures the scout's movements.", Enums.StatType.DODGE_CHANCE, 12, 2, false, 2, false, 0, 0.0, 2)


# =============================================================================
# Act II: Coastal/surface abilities
# =============================================================================

# --- Driftwood Bandit ---

static func cutlass_slash() -> AbilityData:
	return _make("Cutlass Slash", "A rusted blade bites deep.", Enums.StatType.PHYSICAL_ATTACK, 5, 0, true, 2, false, 0, 0.0, 1)

static func pillage_strike() -> AbilityData:
	return _make("Pillage Strike", "Take what you can, give nothing back.", Enums.StatType.PHYSICAL_ATTACK, 7, 0, true, 3, false, 0, 0.3, 2)

# --- Saltrunner Smuggler ---

static func throwing_knife() -> AbilityData:
	return _make("Throwing Knife", "A glint of steel from the shadows.", Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 2, false, 0, 0.0, 1)

static func salt_blind() -> AbilityData:
	return _make("Salt Blind", "Coarse salt thrown in the eyes.", Enums.StatType.SPEED, 5, 2, true, 3, false, 0, 0.0, 2)

# --- Tide Warden ---

static func harpoon_thrust() -> AbilityData:
	return _make("Harpoon Thrust", "A barbed spear punches through armor.", Enums.StatType.PHYSICAL_ATTACK, 6, 0, true, 3, false, 0, 0.0, 2)

static func brace_formation() -> AbilityData:
	return _make("Brace Formation", "Shields lock together against the storm.", Enums.StatType.DEFENSE, 5, 2, false, 4, true, 0, 0.0, 3)

# --- Blighted Gull ---

static func peck_frenzy() -> AbilityData:
	return _make("Peck Frenzy", "A flurry of razor-sharp pecks.", Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 2, false, 0, 0.0, 1)

static func dive_screech() -> AbilityData:
	return _make("Dive Screech", "Black wings blot out the sky.", Enums.StatType.MAGIC_ATTACK, 4, 0, true, 3, true, 0, 0.0, 3)

# --- Shore Crawler ---

static func crushing_claw() -> AbilityData:
	return _make("Crushing Claw", "Armored pincers close with terrible force.", Enums.StatType.PHYSICAL_ATTACK, 7, 0, true, 3, false, 0, 0.0, 2)

static func chitin_shell() -> AbilityData:
	return _make("Chitin Shell", "The creature withdraws into hardened shell.", Enums.StatType.DEFENSE, 5, 2, false, 3, false, 0, 0.0, 2)

# --- Warped Hound ---

static func feral_lunge() -> AbilityData:
	return _make("Feral Lunge", "A wild leap ends in tearing teeth.", Enums.StatType.PHYSICAL_ATTACK, 5, 0, true, 2, false, 0, 0.0, 1)

static func brackish_howl() -> AbilityData:
	return _make("Brackish Howl", "A howl that echoes wrong, sapping courage.", Enums.StatType.ATTACK, 4, 2, true, 4, true, 0, 0.0, 3)

# --- Blackwater Captain ---

static func boarding_axe() -> AbilityData:
	return _make("Boarding Axe", "A heavy axe blow from a seasoned fighter.", Enums.StatType.PHYSICAL_ATTACK, 9, 0, true, 4, false, 0, 0.0, 2)

static func captains_orders() -> AbilityData:
	return _make("Captain's Orders", "The captain rallies the crew.", Enums.StatType.ATTACK, 5, 2, false, 4, true, 0, 0.0, 3)

# --- Corsair Hexer ---

static func brine_curse() -> AbilityData:
	return _make("Brine Curse", "Saltwater burns from the inside.", Enums.StatType.MAGIC_ATTACK, 8, 0, true, 4, false, 0, 0.0, 2)

static func corrode_ward() -> AbilityData:
	return _make("Corrode Ward", "Magic eats through magical protections.", Enums.StatType.MAGIC_DEFENSE, 5, 2, true, 3, false, 0, 0.0, 2)

# --- Abyssal Lurker ---

static func depth_pulse() -> AbilityData:
	return _make("Depth Pulse", "A shockwave from the ocean floor.", Enums.StatType.MAGIC_ATTACK, 9, 0, true, 4, false, 0, 0.0, 2)

static func tidal_drain() -> AbilityData:
	return _make("Tidal Drain", "The sea takes back what it gave.", Enums.StatType.MAGIC_ATTACK, 7, 0, true, 4, false, 0, 0.4, 2)

# --- Stormwrack Raptor ---

static func lightning_dive() -> AbilityData:
	return _make("Lightning Dive", "Thunder and talons strike as one.", Enums.StatType.MIXED_ATTACK, 8, 0, true, 4, false, 0, 0.0, 2)

static func static_screech() -> AbilityData:
	return _make("Static Screech", "Lightning crackles along nerve endings.", Enums.StatType.SPEED, 5, 2, true, 5, true, 0, 0.0, 3)

# --- Tidecaller Revenant ---

static func storm_surge() -> AbilityData:
	return _make("Storm Surge", "The sea rises in impossible fury.", Enums.StatType.MAGIC_ATTACK, 10, 0, true, 5, true, 0, 0.0, 3)

static func drowning_grasp() -> AbilityData:
	return _make("Drowning Grasp", "Spectral hands pull you under.", Enums.StatType.MAGIC_ATTACK, 8, 0, true, 4, false, 0, 0.3, 2)

static func mist_veil() -> AbilityData:
	return _make("Mist Veil", "Sea fog wraps around the form.", Enums.StatType.DODGE_CHANCE, 15, 2, false, 3, false, 0, 0.0, 2)

# --- Salt Phantom ---

static func spectral_chill() -> AbilityData:
	return _make("Spectral Chill", "Cold beyond cold seeps into bones.", Enums.StatType.MAGIC_ATTACK, 6, 0, true, 3, false, 0, 0.0, 2)

static func memory_fog() -> AbilityData:
	return _make("Memory Fog", "A mist that erodes the will to fight.", Enums.StatType.ATTACK, 5, 2, true, 5, true, 0, 0.0, 3)


# =============================================================================
# Act III: Memory sanctum abilities
# =============================================================================

# --- Memory Wisp ---

static func recall_bolt() -> AbilityData:
	return _make("Recall Bolt", "A shard of stolen memory strikes like lightning.", Enums.StatType.MAGIC_ATTACK, 7, 0, true, 3, false, 0, 0.0, 1)

static func memory_drain() -> AbilityData:
	return _make("Memory Drain", "The wisp pulls at the edges of thought.", Enums.StatType.MAGIC_DEFENSE, 4, 2, true, 3, false, 0, 0.0, 2)

# --- Echo Sentinel ---

static func crystal_strike() -> AbilityData:
	return _make("Crystal Strike", "A crystalline fist crashes down with resonant force.", Enums.StatType.PHYSICAL_ATTACK, 7, 0, true, 3, false, 0, 0.0, 1)

static func ward_of_echoes() -> AbilityData:
	return _make("Ward of Echoes", "Layered reverberations harden into a shield.", Enums.StatType.DEFENSE, 5, 2, false, 3, false, 0, 0.0, 2)

# --- Thought Eater ---

static func mind_rend() -> AbilityData:
	return _make("Mind Rend", "Psychic jaws tear through mental defenses.", Enums.StatType.MAGIC_ATTACK, 8, 0, true, 4, false, 0, 0.0, 2)

static func psychic_leech() -> AbilityData:
	return _make("Psychic Leech", "The eater feeds on consciousness itself.", Enums.StatType.MAGIC_ATTACK, 6, 0, true, 3, false, 0, 0.3, 2)

# --- Grief Shade ---

static func sorrows_touch() -> AbilityData:
	return _make("Sorrow's Touch", "A caress of pure sadness numbs the body.", Enums.StatType.MAGIC_ATTACK, 6, 0, true, 3, false, 0, 0.0, 1)

static func wail_of_loss() -> AbilityData:
	return _make("Wail of Loss", "A cry that drains the will to fight from all who hear it.", Enums.StatType.ATTACK, 4, 2, true, 4, true, 0, 0.0, 3)

# --- Hollow Watcher ---

static func blind_strike() -> AbilityData:
	return _make("Blind Strike", "Eyeless, it strikes with unerring precision.", Enums.StatType.PHYSICAL_ATTACK, 7, 0, true, 3, false, 0, 0.0, 1)

static func sense_intent() -> AbilityData:
	return _make("Sense Intent", "It reads your movements before you make them.", Enums.StatType.DEFENSE, 4, 2, true, 3, false, 0, 0.0, 2)

# --- Mirror Self ---

static func mirrored_slash() -> AbilityData:
	return _make("Mirrored Slash", "Your own fighting style turned against you.", Enums.StatType.PHYSICAL_ATTACK, 9, 0, true, 4, false, 0, 0.0, 2)

static func reflected_spell() -> AbilityData:
	return _make("Reflected Spell", "A stolen incantation cast with hollow precision.", Enums.StatType.MAGIC_ATTACK, 9, 0, true, 4, false, 0, 0.0, 2)

# --- Void Weaver ---

static func void_bolt() -> AbilityData:
	return _make("Void Bolt", "A lance of nothingness tears through everything.", Enums.StatType.MAGIC_ATTACK, 8, 0, true, 4, true, 0, 0.0, 3)

static func unravel() -> AbilityData:
	return _make("Unravel", "Reality frays at the seams, weakening all defenses.", Enums.StatType.MAGIC_DEFENSE, 5, 2, true, 4, false, 0, 0.0, 2)

# --- Mnemonic Golem ---

static func memory_slam() -> AbilityData:
	return _make("Memory Slam", "A fist of crystallized memories crashes down.", Enums.StatType.PHYSICAL_ATTACK, 10, 0, true, 4, false, 0, 0.0, 2)

static func crystallize() -> AbilityData:
	return _make("Crystallize", "Memories harden into impenetrable armor.", Enums.StatType.DEFENSE, 6, 2, false, 4, false, 0, 0.0, 2)

# --- The Warden (boss) ---

static func sanctum_judgment() -> AbilityData:
	return _make("Sanctum Judgment", "The sanctum itself passes sentence on intruders.", Enums.StatType.MAGIC_ATTACK, 12, 0, true, 5, true, 0, 0.0, 3)

static func barrier_of_ages() -> AbilityData:
	return _make("Barrier of Ages", "Centuries of accumulated memory form an unbreakable wall.", Enums.StatType.MAGIC_DEFENSE, 6, 2, false, 4, false, 0, 0.0, 2)

static func purge_thought() -> AbilityData:
	return _make("Purge Thought", "A targeted erasure that strips away magical strength.", Enums.StatType.MAGIC_ATTACK, 10, 0, true, 4, false, 0, 0.0, 2)

# --- Fractured Protector (boss) ---

static func desperate_strike() -> AbilityData:
	return _make("Desperate Strike", "A blow struck not in anger but in fear.", Enums.StatType.PHYSICAL_ATTACK, 11, 0, true, 4, false, 0, 0.0, 2)

static func memory_seal() -> AbilityData:
	return _make("Memory Seal", "A pulse that clouds the mind and slows all thought.", Enums.StatType.SPEED, 5, 2, true, 5, true, 0, 0.0, 3)

static func forgetting_touch() -> AbilityData:
	return _make("Forgetting Touch", "One touch and something important slips away.", Enums.StatType.MAGIC_ATTACK, 9, 0, true, 4, false, 0, 0.3, 2)


# =============================================================================
# Act IV: The Eye's domain abilities
# =============================================================================

# --- Gaze Stalker ---

static func piercing_gaze_strike() -> AbilityData:
	return _make("Piercing Gaze", "Eyes that cut deeper than any blade.", Enums.StatType.PHYSICAL_ATTACK, 8, 0, true, 3, false, 0, 0.0, 1)

static func focus_break() -> AbilityData:
	return _make("Focus Break", "A psychic jab that shatters concentration.", Enums.StatType.MAGIC_DEFENSE, 5, 2, true, 3, false, 0, 0.0, 2)

# --- Memory Harvester ---

static func harvest_thought() -> AbilityData:
	return _make("Harvest Thought", "It plucks a memory and feeds.", Enums.StatType.MAGIC_ATTACK, 10, 0, true, 4, false, 0, 0.35, 2)

static func mass_extraction() -> AbilityData:
	return _make("Mass Extraction", "A wave of hunger tears at every mind at once.", Enums.StatType.MAGIC_ATTACK, 7, 0, true, 5, true, 0, 0.0, 3)

# --- Oblivion Shade ---

static func wave_of_oblivion() -> AbilityData:
	return _make("Wave of Oblivion", "A tide of nothing that drains the will to fight.", Enums.StatType.ATTACK, 5, 2, true, 5, true, 0, 0.0, 3)

static func nihil_bolt() -> AbilityData:
	return _make("Nihil Bolt", "A bolt of pure emptiness.", Enums.StatType.MAGIC_ATTACK, 9, 0, true, 4, false, 0, 0.0, 2)

# --- Thoughtform Knight ---

static func memory_blade() -> AbilityData:
	return _make("Memory Blade", "A sword forged from ten thousand stolen recollections.", Enums.StatType.PHYSICAL_ATTACK, 10, 0, true, 3, false, 0, 0.0, 2)

static func ironclad_will() -> AbilityData:
	return _make("Ironclad Will", "Thought hardens into unbreakable armor.", Enums.StatType.DEFENSE, 6, 2, false, 3, false, 0, 0.0, 2)

# --- The Iris (Phase 1 boss) ---

static func prismatic_blast() -> AbilityData:
	return _make("Prismatic Blast", "The Iris fractures light into a storm of burning color.", Enums.StatType.MAGIC_ATTACK, 12, 0, true, 6, true, 0, 0.0, 3)

static func refraction_beam() -> AbilityData:
	return _make("Refraction Beam", "A focused beam that burns through all defenses.", Enums.StatType.MAGIC_ATTACK, 14, 0, true, 5, false, 0, 0.0, 2)

static func crystalline_ward() -> AbilityData:
	return _make("Crystalline Ward", "The Iris wraps itself in layers of stolen light.", Enums.StatType.MAGIC_DEFENSE, 7, 2, false, 4, false, 0, 0.0, 2)

# --- The Lidless Eye (Phase 2 final boss) ---

static func gaze_of_forgetting() -> AbilityData:
	return _make("Gaze of Forgetting", "Its stare peels away everything you are.", Enums.StatType.ATTACK, 6, 2, true, 6, true, 0, 0.0, 3)

static func memory_devour() -> AbilityData:
	return _make("Memory Devour", "It eats what makes you whole.", Enums.StatType.MAGIC_ATTACK, 12, 0, true, 5, false, 0, 0.35, 2)

static func final_blink() -> AbilityData:
	return _make("Final Blink", "The last thing it sees, it destroys.", Enums.StatType.MAGIC_ATTACK, 10, 0, true, 5, true, 0, 0.0, 3)
