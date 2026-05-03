class_name BattleDBS2PathB

## Story 2 Path B battle configurations: Save Sera.
## Flow: ForgottenArchive → ArchiveAwakening → SafeHaven (town)
##   → LighthouseCore → ResonanceChamber → MemoryFlood → EyeUnblinking

const BattleData := preload("res://scripts/data/battle_data.gd")
const EnemyDB := preload("res://scripts/data/story2/enemy_db_s2_pathb.gd")


static func create_battle(battle_id: String) -> BattleData:
	match battle_id:
		"S2_B_ArchiveAwakening": return s2_b_archive_awakening()
		"S2_B_SafeHaven": return s2_b_safe_haven()
		"S2_B_LighthouseCore": return s2_b_lighthouse_core()
		"S2_B_ResonanceChamber": return s2_b_resonance_chamber()
		"S2_B_MemoryFlood": return s2_b_memory_flood()
		"S2_B_EyeUnblinking": return s2_b_eye_unblinking()
		_:
			push_error("Unknown Story 2 Path B battle: %s" % battle_id)
			return s2_b_archive_awakening()


# =============================================================================
# Prog 13B: Archive Awakening (Sera fight in archive context)
# =============================================================================

static func s2_b_archive_awakening() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_B_ArchiveAwakening"
	b.scene_image = "res://assets/art/battles/forgotten_archive.png"
	b.enemies = [
		EnemyDB.create_fractured_scholar("Sera"),
		EnemyDB.create_archive_sentinel("The Cataloger"),
	]
	b.pre_battle_text = [
		"The archive's deeper chambers hold more than records. Behind a shelf of crystallized memories, a hidden room. Schematics cover the walls: diagrams of resonance chambers, extraction pipelines, a failsafe mechanism.",
		"Notes in a woman's careful hand: 'If the Eye must be destroyed, this is how. Overload the resonance with its own harvest. Feed it so much at once that it chokes.'",
		"Movement. A woman stands in the doorway, dark hair, kind eyes gone hard with suspicion. The wave-and-eye pendant hangs heavy around her neck.",
		"She does not recognize the party. But she knows this room. She came here the way a person comes home in a dream, following a path her body remembers even if her mind does not.",
		"'These are mine,' she says, touching the schematics. 'I don't know how I know that, but I know it.' She draws her weapon. 'And you are not taking them.'",
	]
	b.post_battle_text = [
		"The sentinel crumbles. Sera drops to her knees, breathing hard.",
		"Something in the battle broke loose. Contact, proximity, the resonance of the archive itself. Memories cascade through her in a torrent.",
		"She looks up. Sees their faces. Remembers.",
		"'Oh.' Just that, at first. Then their names, one by one. Then the tears.",
		"She turns to the schematics on the wall, and her expression changes. Recognition. Not just of the diagrams but of the handwriting.",
		"'I designed this failsafe.' She presses her palm against the wall. 'I forgot I designed it. I built a way to kill the Eye using its own stored memories. Feed them back faster than it can process them.'",
		"She pulls the wave-and-eye pendant from her neck. 'We don't have to go in blind this time. We don't have to sacrifice anything. Follow me.'",
	]
	b.next_battle_id = "S2_B_SafeHaven"
	b.music_track = "res://assets/audio/music/boss/Impending Terror_FULL.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/#15 Dark Strings Swell.wav"
	return b


# =============================================================================
# Town Stop: Safe Haven (post-T2, equipment upgrades, ultimates, shop)
# =============================================================================

static func s2_b_safe_haven() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_B_SafeHaven"
	b.scene_image = "res://assets/art/battles/coastal_ruins.png"
	b.is_town_stop = true
	b.pre_battle_text = [
		"Beyond the archive, a sheltered cove. Crumbling stone walls form a natural windbreak. Someone lived here once, long ago, before the Eye claimed this stretch of coast.",
		"Sera kneels by a fire pit and coaxes a flame from driftwood. Her hands are steadier now. The memories have settled, not fully sorted but no longer a storm.",
		"'We should rest,' she says. 'What comes next will not be gentle.'",
		"The cove is quiet. Waves lap against dark stone. For a few hours, the coast feels like it belongs to them.",
	]
	b.post_battle_text = [
		"The fire burns low. Sera stands and looks toward the lighthouse, its beam sweeping the horizon in slow, hungry arcs.",
		"'The core is below the lighthouse. I built the extraction systems down there.' She pauses. 'I also built the way to break them.'",
		"She tightens her pack. 'Ready when you are.'",
	]
	b.next_battle_id = "S2_B_LighthouseCore"
	b.cutscene_track = "res://assets/audio/music/cutscene/#9.wav"
	return b


# =============================================================================
# Prog 14B: Lighthouse Core (deep machinery)
# =============================================================================

static func s2_b_lighthouse_core() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_B_LighthouseCore"
	b.scene_image = "res://assets/art/battles/memory_depths.png"
	b.enemies = [
		EnemyDB.create_pipeline_warden("Ironflow"),
		EnemyDB.create_maintenance_drone("Calibrator"),
		EnemyDB.create_resonance_node("Harmonic"),
	]
	b.pre_battle_text = [
		"Sera leads them through a passage hidden behind the archive's deepest shelves. Down, then deeper down, into the lighthouse's true heart.",
		"The walls change from stone to metal. Pipes run along the ceiling, pulsing with crystallized light. The air hums with a frequency that makes teeth ache.",
		"'This is the extraction infrastructure,' Sera says, running her hand along a pipe. 'Memories flow through these conduits from the lighthouse above to the Eye below. Every person who ever entered the lighthouse's light had something taken.'",
		"She stops at a junction where three pipes merge. 'The resonance chamber is below this. If I can reverse the flow, every stored memory floods back into the Eye at once.'",
		"The machinery's automated guardians activate. The lighthouse protects its own systems.",
	]
	b.post_battle_text = [
		"The guardians fall and the pipes ring with the impact. Sera is already moving, hands working controls that she designed and forgot.",
		"'The resonance chamber is one level deeper. That is where I need to be.' She pauses. 'The Eye will feel what we are doing. It will send everything it has to stop us.'",
		"She looks at the party. 'I spent months building these systems before I understood what they were for. Before I understood the Eye was alive. I am going to use my own work to destroy it.'",
		"The passage descends further. The humming grows louder.",
	]
	b.next_battle_id = "S2_B_ResonanceChamber"
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Circle of the Serpent.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/#9.wav"
	return b


# =============================================================================
# Prog 15B: Resonance Chamber (activate the overload)
# =============================================================================

static func s2_b_resonance_chamber() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_B_ResonanceChamber"
	b.scene_image = "res://assets/art/battles/memory_sanctum.png"
	b.enemies = [
		EnemyDB.create_eyes_fist("The Will"),
		EnemyDB.create_null_sentinel("Voidguard"),
		EnemyDB.create_overload_spark("Cascade"),
	]
	b.pre_battle_text = [
		"The resonance chamber. A vast space of polished crystal and humming metal, the lighthouse's deepest secret. Thousands of memory-filled conduits converge here before feeding downward to the Eye.",
		"Sera moves to a control panel built into the far wall. Her hands remember the sequence even if her mind is still catching up.",
		"'I need time,' she says. 'The overload sequence is complex. If I get it wrong, the feedback will destroy the chamber and us with it.'",
		"The floor shakes. Something has noticed. The Eye's direct enforcers materialize from the conduits: a construct of crushing will, a sentinel of pure negation, and a crackling spark of overloaded energy.",
		"'Hold them off,' Sera says. 'I only need a few minutes.'",
	]
	b.post_battle_text = [
		"The last guardian dissolves. Behind the party, Sera slams a final lever into position.",
		"'It's done.' The conduits reverse. Light flows upward, then stutters, then floods backward through the pipes. Thousands of stolen memories rushing back toward their source.",
		"The chamber shakes violently. From far below, a sound that is not a sound but a pressure, a rage, a hunger that has never been denied.",
		"'It felt that,' Sera says. She's pale but steady. 'Every memory it ever took, returning at once. It cannot digest this much. It is choking on its own harvest.'",
		"The pipes groan. Light pours through cracks in the metal. The memories are loose and angry.",
	]
	b.next_battle_id = "S2_B_MemoryFlood"
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Bloody Night.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/#10.wav"
	return b


# =============================================================================
# Prog 16B: Memory Flood (unleashed memories attack)
# =============================================================================

static func s2_b_memory_flood() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_B_MemoryFlood"
	b.scene_image = "res://assets/art/battles/the_eye.png"
	b.enemies = [
		EnemyDB.create_memory_torrent("The Deluge"),
		EnemyDB.create_unleashed_recollection("Avalanche"),
		EnemyDB.create_rage_fragment("Fury"),
	]
	b.pre_battle_text = [
		"The overloaded memories burst free from the pipes. Not gentle drifting lights but a violent torrent of stolen lives demanding to be felt.",
		"Birthdays, funerals, first words, last breaths. Hundreds of lifetimes compressed into moments of raw, undirected emotion that strikes like a physical force.",
		"The memories are not targeting the Eye. They are targeting everything. Rage and grief and joy so concentrated they have become hostile entities.",
		"Sera grabs the party's arm. 'We need to push through to the Eye. It is weakened but not defeated. The memories are clearing a path, but they will hurt us too.'",
		"A wall of unleashed recollection crashes toward them.",
	]
	b.post_battle_text = [
		"The torrent subsides. The memories, spent and freed, drift upward through the stone like a thousand lanterns ascending.",
		"'They are going home,' Sera says quietly. 'Every stolen memory, returning to where it belongs.'",
		"Below, the Eye is exposed. Not hidden behind walls of light, not shielded by its stolen harvest. Just the Eye itself, vast and ancient and gorged on more than it can hold.",
		"But not weakened the way Sera's sacrifice would have weakened it. Fed, not poisoned. Enraged, not diminished.",
		"Sera stands beside the party. 'It is at full strength. The overload hurt it but it did not break it. We finish this the old way. Together.'",
	]
	b.next_battle_id = "S2_B_EyeUnblinking"
	b.music_track = "res://assets/audio/music/boss/Awakening of the Juggernaut_FULL.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/#11.wav"
	return b


# =============================================================================
# Prog 17B: The Unblinking Eye (final boss -- full strength)
# =============================================================================

static func s2_b_eye_unblinking() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_B_EyeUnblinking"
	b.scene_image = "res://assets/art/battles/eye_of_oblivion.png"
	b.is_final_battle = true
	b.is_boss = true
	b.enemies = [
		EnemyDB.create_the_unblinking_eye("The Unblinking Eye"),
		EnemyDB.create_perception_tendril("Perception Tendril"),
		EnemyDB.create_void_lens("Void Lens"),
	]
	b.pre_battle_text = [
		"The Eye. Not diminished. Not weakened by sacrifice. Gorged on its own harvest and furious.",
		"It fills the chamber, vast and ancient, its iris shifting through colors that have no names. Light bends around it. The air itself retreats from its gaze.",
		"It speaks. Not with sound. The word arrives fully formed, vibrating with rage.",
		"'You. Again. And you brought her back.'",
		"Its attention turns to Sera. She flinches but holds her ground.",
		"'I remember everything you built for me. Every system. Every extraction. Every person you delivered to my hunger. And now you turn my own work against me?'",
		"Sera's voice is steady. 'I built it. I get to break it.'",
		"The Eye's iris contracts to a point of absolute focus.",
		"'Then I will eat you last.'",
	]
	b.post_battle_text = [
		"The Eye closes. Not shattering. Not exploding. It simply closes, like a lid settling over a candle flame, and the light goes out.",
		"The chamber is dark. Then, slowly, a different light. Warm. Natural. Sunlight filtering down through cracks in the stone above.",
		"Across the coast, people stop mid-sentence. A name they forgot. A face they lost. A moment that was taken, returned without explanation.",
		"The old woman in the fishing village remembers the dinner. The blacksmith remembers why the sword was urgent. The barkeep remembers the conversations.",
		"Deep below, in the place where the Eye once watched, the party stands in silence. All four of them.",
		"Sera is shaking. Not from cold. Not from fear. From the weight of centuries lifting all at once.",
		"'I thought I would die down here,' she says. 'I was ready for it. I had a whole plan for how it would end.' She laughs, short and surprised. 'I don't know what to do with a life I expected to give away.'",
		"They climb together. The tunnels are quiet. The machinery is dark. The crystals are empty.",
		"Sera squints when they reach the surface. Sunlight. She has not seen the sun in years.",
		"Someone hands her a cup of water from a well. She drinks it and laughs again, surprised that something so simple can still feel good.",
		"Four of them walked in. Four of them walk out.",
	]
	b.post_scene_image = "res://assets/art/battles/lighthouse_approach.png"
	b.music_track = "res://assets/audio/music/boss/The Battle of Ages_FULL.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/#14.wav"
	return b
