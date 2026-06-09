class_name FighterDBMeta

## Class metadata: display names, ability lookups, and flavor text for all 56 classes.

const AbilityDB := preload("res://scripts/data/ability_db.gd")
const PAB := preload("res://scripts/data/ability_db_player.gd")
const PAB_B := preload("res://scripts/data/ability_db_player_b.gd")


static func get_display_name(class_id: String) -> String:
	match class_id:
		# T0
		"Squire": return "Squire"
		"Mage": return "Mage"
		"Entertainer": return "Entertainer"
		"Tinker": return "Tinker"
		"Wildling": return "Wildling"
		# T1:Squire
		"Duelist": return "Duelist"
		"Ranger": return "Ranger"
		"MartialArtist": return "Martial Artist"
		# T1:Mage
		"Invoker": return "Invoker"
		"Acolyte": return "Acolyte"
		# T1:Entertainer
		"Bard": return "Bard"
		"Dervish": return "Dervish"
		"Orator": return "Orator"
		# T1:Tinker
		"Artificer": return "Artificer"
		"Philosopher": return "Philosopher"
		"Arithmancer": return "Arithmancer"
		# T1:Wildling
		"Herbalist": return "Herbalist"
		"Shaman": return "Shaman"
		"Beastcaller": return "Beastcaller"
		# T0:Wanderer
		"Wanderer": return "Wanderer"
		# T1:Wanderer
		"Sentinel": return "Sentinel"
		"Pathfinder": return "Pathfinder"
		# T2:Squire
		"Cavalry": return "Cavalry"
		"Dragoon": return "Dragoon"
		"Mercenary": return "Mercenary"
		"Hunter": return "Hunter"
		"Ninja": return "Ninja"
		"Monk": return "Monk"
		# T2:Mage
		"Infernalist": return "Infernalist"
		"Tidecaller": return "Tidecaller"
		"Tempest": return "Tempest"
		"Paladin": return "Paladin"
		"Priest": return "Priest"
		"Warlock": return "Warlock"
		# T2:Entertainer
		"Warcrier": return "Warcrier"
		"Minstrel": return "Minstrel"
		"Illusionist": return "Illusionist"
		"Mime": return "Mime"
		"Laureate": return "Laureate"
		"Elegist": return "Elegist"
		# T2:Tinker
		"Alchemist": return "Alchemist"
		"Bombardier": return "Bombardier"
		"Chronomancer": return "Chronomancer"
		"Astronomer": return "Astronomer"
		"Automaton": return "Automaton"
		"Technomancer": return "Technomancer"
		# T2:Wildling
		"Blighter": return "Blighter"
		"GroveKeeper": return "Grove Keeper"
		"WitchDoctor": return "Witch Doctor"
		"Spiritwalker": return "Spiritwalker"
		"Falconer": return "Falconer"
		"Shapeshifter": return "Shapeshifter"
		# T2:Wanderer
		"Bulwark": return "Bulwark"
		"Aegis": return "Aegis"
		"Trailblazer": return "Trailblazer"
		"Survivalist": return "Survivalist"
		_: return class_id


static func get_abilities_for_class(class_id: String) -> Array:
	match class_id:
		# T0
		"Squire": return [AbilityDB.slash(), AbilityDB.guard(), AbilityDB.rush()]
		"Mage": return [AbilityDB.arcane_bolt(), AbilityDB.arcane_shield(), AbilityDB.fire_dart()]
		"Entertainer": return [AbilityDB.mockery(), AbilityDB.demoralize(), AbilityDB.inspire()]
		"Tinker": return [AbilityDB.proof(), AbilityDB.energy_blast(), AbilityDB.spark_shot()]
		"Wildling": return [AbilityDB.thorn_whip(), AbilityDB.bark_skin(), AbilityDB.primal_swipe()]
		"Wanderer": return [AbilityDB.wild_strike(), AbilityDB.natures_ward(), AbilityDB.scout_slash()]
		# T1:Squire
		"Duelist": return [PAB.lunge(), PAB.feint(), PAB.riposte()]
		"Ranger": return [PAB.pierce(), PAB.double_arrow(), PAB.mark_prey()]
		"MartialArtist": return [PAB.punch(), PAB.topple(), PAB.inner_focus()]
		# T1:Mage
		"Invoker": return [PAB.elemental_barrage(), PAB.elemental_surge(), PAB.elemental_focus()]
		"Acolyte": return [PAB.cure(), PAB.protect(), PAB.radiance()]
		# T1:Entertainer
		"Bard": return [PAB.seduce(), PAB.melody(), PAB.encourage()]
		"Dervish": return [PAB.mesmerize(), PAB.dance(), PAB.whirling_step()]
		"Orator": return [PAB.oration(), PAB.encourage(), PAB.rebuke()]
		# T1:Tinker
		"Artificer": return [PAB_B.volatile_flask(), PAB_B.magical_tinkering(), PAB_B.healing_draught()]
		"Philosopher": return [PAB_B.time_warp(), PAB_B.black_hole(), PAB_B.gravity()]
		"Arithmancer": return [PAB_B.theorem(), PAB_B.calculate(), PAB_B.probability()]
		# T1:Wildling
		"Herbalist": return [PAB_B.mending_herbs(), PAB_B.sapping_vine(), PAB_B.thorn_spray()]
		"Shaman": return [PAB_B.spirit_bolt(), PAB_B.ancestral_curse(), PAB_B.spirit_veil()]
		"Beastcaller": return [PAB_B.feral_strike(), PAB_B.pack_howl(), PAB_B.stampede()]
		# T1:Wanderer
		"Sentinel": return [PAB_B.shield_bash(), PAB_B.barrier(), PAB_B.fortify()]
		"Pathfinder": return [PAB_B.keen_strike(), PAB_B.exploit_weakness(), PAB_B.adaptable_strike()]
		# T2:Squire
		"Cavalry": return [PAB.lance(), PAB.trample(), PAB.spur()]
		"Dragoon": return [PAB.dragon_scales(), PAB.wyvern_strike(), PAB.dragon_dive()]
		"Mercenary": return [PAB.gun_shot(), PAB.called_shot(), PAB.suppressing_fire()]
		"Hunter": return [PAB.triple_arrow(), PAB.snare(), PAB.hunters_mark()]
		"Ninja": return [PAB.shadow_strike(), PAB.smoke_bomb(), PAB.blade_flurry()]
		"Monk": return [PAB.spirit_attack(), PAB.precise_strike(), PAB.inner_peace()]
		# T2:Mage
		"Infernalist": return [PAB.fire_ball(), PAB.burning_brand(), PAB.conflagration()]
		"Tidecaller": return [PAB.purify(), PAB.tsunami(), PAB.water_whip()]
		"Tempest": return [PAB.hurricane(), PAB.lightning_strike(), PAB.storm_surge()]
		"Paladin": return [PAB.lay_on_hands(), PAB.holy_strike(), PAB.smite()]
		"Priest": return [PAB.restoration(), PAB.heavenly_body(), PAB.holy()]
		"Warlock": return [PAB.shadow_bolt(), PAB.hex(), PAB.drain_life()]
		# T2:Entertainer
		"Warcrier": return [PAB.battle_cry(), PAB.war_chant(), PAB.rally_cry()]
		"Minstrel": return [PAB.ballad(), PAB.dissonance(), PAB.serenade()]
		"Illusionist": return [PAB.phantom_strike(), PAB.mirage(), PAB.bewilderment()]
		"Mime": return [PAB.invisible_wall(), PAB.anvil(), PAB.invisible_box()]
		"Laureate": return [PAB.ovation(), PAB.recite(), PAB.magnum_opus()]
		"Elegist": return [PAB.requiem(), PAB.lament(), PAB.dirge()]
		# T2:Tinker
		"Alchemist": return [PAB_B.transmute(), PAB_B.corrosive_acid(), PAB_B.elixir()]
		"Bombardier": return [PAB_B.cluster_bomb(), PAB_B.explosion(), PAB_B.demolition_charge()]
		"Chronomancer": return [PAB_B.temporal_rift(), PAB_B.time_bomb(), PAB_B.time_freeze()]
		"Astronomer": return [PAB_B.starfall(), PAB_B.meteor_shower(), PAB_B.eclipse()]
		"Automaton": return [PAB_B.servo_strike(), PAB_B.discharge(), PAB_B.self_repair()]
		"Technomancer": return [PAB_B.circuit_blast(), PAB_B.techno_drain(), PAB_B.emp_pulse()]
		# T2:Wildling
		"Blighter": return [PAB_B.blight(), PAB_B.plague(), PAB_B.poison_sting()]
		"GroveKeeper": return [PAB_B.thorn_burst(), PAB_B.natures_mend(), PAB_B.vine_wall()]
		"WitchDoctor": return [PAB_B.voodoo_bolt(), PAB_B.dark_hex(), PAB_B.creeping_rot()]
		"Spiritwalker": return [PAB_B.soul_strike(), PAB_B.spirit_shield(), PAB_B.spirit_mend()]
		"Falconer": return [PAB_B.falcon_strike(), PAB_B.rending_talon(), PAB_B.aerial_strike()]
		"Shapeshifter": return [PAB_B.savage_maul(), PAB_B.frenzy(), PAB_B.rampage()]
		# T2:Wanderer
		"Bulwark": return [PAB_B.spell_ward(), PAB_B.iron_fist(), PAB_B.ironclad_challenge()]
		"Aegis": return [PAB_B.arcane_edge(), PAB_B.ward_breaker(), PAB_B.spell_counter()]
		"Trailblazer": return [PAB_B.blaze_trail(), PAB_B.ambush(), PAB_B.expose()]
		"Survivalist": return [PAB_B.wild_sweep(), PAB_B.resourceful_strike(), PAB_B.adapt()]
		_:
			push_error("Unknown class_id for abilities: %s" % class_id)
			return []


static func get_flavor_text(class_id: String) -> String:
	match class_id:
		# T0
		"Squire": return "A fresh recruit with more courage than skill. Every legend starts with a wooden sword and a stubborn heart."
		"Mage": return "An apprentice of the arcane, still learning to channel raw magic without singeing their robes."
		"Entertainer": return "A traveling performer whose quick wit and silver tongue are sharper than any blade."
		"Tinker": return "A curious inventor forever tinkering with gears and gadgets. Their workshop is wherever they happen to sit down."
		"Wildling": return "Raised beyond the reach of civilization, they speak the language of root and claw."
		"Wanderer": return "A seasoned traveler who has walked roads that no longer appear on any map. The wilds have taught them well."
		# T1: Squire tree
		"Duelist": return "A blade artist who treats every fight as a performance. Precision over power, always."
		"Ranger": return "A keen-eyed archer comfortable in the deep woods, where patience is the truest weapon."
		"MartialArtist": return "Fists and feet honed through years of discipline. They fight with nothing but their body and their will."
		# T1: Mage tree
		"Invoker": return "A channeler of elemental fury who bends fire, water, and lightning to their command."
		"Acolyte": return "A student of divine light, still finding their faith. Their healing hands grow steadier with each prayer."
		# T1: Entertainer tree
		"Bard": return "A musician who weaves magic through melody. Their songs can mend wounds or shatter morale."
		"Dervish": return "A whirling dancer whose movements blur the line between art and combat."
		"Orator": return "A master of rhetoric whose speeches move allies to action and enemies to doubt."
		# T1: Tinker tree
		"Artificer": return "A skilled craftsperson who turns raw materials into instruments of war and healing alike."
		"Philosopher": return "A philosopher who gazes beyond the stars, seeking the hidden laws that govern all things."
		"Arithmancer": return "A scholar who finds power in pure mathematics, solving equations that reshape reality."
		# T1: Wildling tree
		"Herbalist": return "A keeper of plant lore who can coax both remedy and ruin from the simplest garden."
		"Shaman": return "A spirit-speaker who communes with the unseen world, drawing on ancestral power."
		"Beastcaller": return "One who shares a primal bond with wild creatures, calling them to fight as family."
		# T1: Wanderer tree
		"Sentinel": return "A stoic guardian who stands between their allies and harm. Their wards hold when walls would crumble."
		"Pathfinder": return "A tactical scout who reads the battlefield like a map, finding every advantage the terrain offers."
		# T2: Squire tree
		"Cavalry": return "A mounted lancer who charges through enemy lines with devastating momentum. Few can stand before the thundering hooves."
		"Dragoon": return "A draconic warrior whose scales harden allies and whose strikes carry the fury of wyverns."
		"Mercenary": return "A gun-wielding sellsword who lets coin decide their loyalty and a well-placed shot decide the battle."
		"Hunter": return "A patient tracker who lays cunning traps and reads every broken twig. Their quarry never escapes."
		"Ninja": return "A shadow that strikes without warning and vanishes without a trace. By the time you see them, it is already too late."
		"Monk": return "A spiritual warrior who channels inner harmony into devastating strikes and mending light."
		# T2: Mage tree
		"Infernalist": return "A pyromancer consumed by the thrill of flame. Their fire burns hotter than reason, leaving only ash behind."
		"Tidecaller": return "A water mage who commands the tides to shield allies and sweep away foes in surging waves."
		"Tempest": return "A storm incarnate who crackles with lightning and howls with thunder. Standing near them makes your hair stand on end."
		"Paladin": return "A holy knight who wields faith as both sword and shield. Their conviction is as unyielding as their armor."
		"Priest": return "A devoted healer whose prayers call down radiant light, mending the broken and sanctifying the battlefield."
		"Warlock": return "A wielder of forbidden magic who draws power from the dark spaces between stars. Their curses linger long after the battle ends."
		# T2: Entertainer tree
		"Warcrier": return "A battlefield vocalist whose thunderous shouts bolster allies and shatter enemy resolve."
		"Minstrel": return "A gentle musician whose healing melodies can soothe even the deepest wounds."
		"Illusionist": return "A trickster who bends light and perception, striking from angles that should not exist."
		"Mime": return "A silent performer who shapes invisible walls and conjures phantom objects from pure imagination."
		"Laureate": return "A poet of legendary renown whose words of praise elevate allies to heights they never thought possible."
		"Elegist": return "A somber wordsmith who speaks of loss and futility, draining the will to fight from all who listen."
		# T2: Tinker tree
		"Alchemist": return "A master of transmutation who brews elixirs of restoration and vials of corrosive ruin."
		"Bombardier": return "An explosives expert who solves every problem with a bigger blast. Subtlety is not in their vocabulary."
		"Chronomancer": return "A time-bender who accelerates allies and freezes foes in moments stolen from the future."
		"Astronomer": return "A celestial scholar who calls down starfire and meteor showers, wielding the heavens as a weapon."
		"Automaton": return "A living construct of clockwork and willpower, trading flesh for steel without a moment of regret."
		"Technomancer": return "A hybrid genius who fuses arcane circuits with raw magic, creating something entirely new."
		# T2: Wildling tree
		"Blighter": return "A harbinger of decay who wields poison and rot, turning the natural cycle of death into a weapon."
		"GroveKeeper": return "A guardian of the green who commands roots and vines to shield allies and ensnare the unwary."
		"WitchDoctor": return "A hex-weaver who curses enemies with ancient rites, unraveling their strength from the inside."
		"Spiritwalker": return "A bridge between the living and the ancestral realm, channeling protective spirits to shelter their companions."
		"Falconer": return "A raptor-bonded marksman whose birds of prey strike with surgical precision from above."
		"Shapeshifter": return "A primal warrior who abandons human form to become fang and claw, embracing the beast within."
		# T2: Wanderer tree
		"Bulwark": return "An immovable fortress of magical defense. Spells break against them like waves against a cliff."
		"Aegis": return "A counter-magic warrior who turns enemy sorcery back upon its caster with devastating precision."
		"Trailblazer": return "An aggressive vanguard who carves new paths through enemy ranks with relentless mixed assaults."
		"Survivalist": return "An endurance fighter who thrives where others falter, drawing strength from hardship itself."
		_: return ""
