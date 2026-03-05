class_name BattleDBS2Act4

## Story 2 Act IV battle configurations: "The Reckoning"
## Structure: DepthsOfRemembrance -> MawOfTheEye -> EyeAwakening (Phase 1)
##   -> [Sera's sacrifice] -> EyeOfOblivion (Phase 2, final)

const BattleData := preload("res://scripts/data/battle_data.gd")
const EnemyDBS2Act4 := preload("res://scripts/data/enemy_db_s2_act4.gd")


static func create_battle(battle_id: String) -> BattleData:
	match battle_id:
		"S2_DepthsOfRemembrance": return s2_depths_of_remembrance()
		"S2_MawOfTheEye": return s2_maw_of_the_eye()
		"S2_EyeAwakening": return s2_eye_awakening()
		"S2_EyeOfOblivion": return s2_eye_of_oblivion()
		_:
			push_error("Unknown Story 2 Act IV battle: %s" % battle_id)
			return s2_depths_of_remembrance()


# =============================================================================
# Prog 14: Depths of Remembrance (Sera leads the party deeper)
# =============================================================================

static func s2_depths_of_remembrance() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_DepthsOfRemembrance"
	b.scene_image = "res://assets/art/battles/memory_depths.png"
	b.enemies = [
		EnemyDBS2Act4.create_gaze_stalker("Lidwatch"),
		EnemyDBS2Act4.create_gaze_stalker("Duskpupil"),
		EnemyDBS2Act4.create_memory_harvester("The Gleaner"),
	]
	b.pre_battle_text = [
		"Sera leads them down a passage she remembers. Her hands trace the walls like she is reading something written in the stone.",
		"She stumbles twice. The rapid memory restoration has left her weakened, her body catching up to a mind suddenly full of years it forgot.",
		"'I spent months down here,' she says quietly. 'Learning how the machinery worked. Learning what the Eye wanted.' She does not elaborate on what she learned.",
		"Crystallized memories line the walls like constellations. Sera points to them as they walk. 'That one is a birthday. That one is a first kiss. That one is a mother's face. Every light is someone's life, taken and stored.'",
		"Movement ahead. Things with too many eyes, watching from the dark, already aware of the intrusion.",
	]
	b.post_battle_text = [
		"The stalkers dissolve into wisps of stolen light. Sera watches them go with an expression the party has learned to recognize: guilt.",
		"'I helped build some of these systems,' she says. 'Before I understood what they were really for. Before I understood it was alive.'",
		"She presses her hand against a cluster of crystals and closes her eyes. 'It's close. I can feel it. It knows we're here. It has always known.'",
		"The passage opens wider. The crystalline deposits grow denser, converging inward like roots reaching toward something at the center.",
	]
	b.next_battle_id = "S2_MawOfTheEye"
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Circle of the Serpent.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/#9.wav"
	return b


# =============================================================================
# Prog 15: Maw of the Eye (outer chamber)
# =============================================================================

static func s2_maw_of_the_eye() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_MawOfTheEye"
	b.scene_image = "res://assets/art/battles/eye_approach.png"
	b.enemies = [
		EnemyDBS2Act4.create_thoughtform_knight("Oathbound"),
		EnemyDBS2Act4.create_oblivion_shade("The Hollow"),
		EnemyDBS2Act4.create_memory_harvester("The Reaper"),
	]
	b.pre_battle_text = [
		"A vast underground chamber. The ceiling is darkness. The floor is a carpet of crystallized memories so dense the party walks on stolen lives.",
		"Thousands of lights converge inward like roots toward something at the center. Something that breathes without lungs, that watches without a face.",
		"Sera stops at the chamber's edge. Her voice is barely above a whisper.",
		"'It has been feeding for centuries. Every lighthouse, every extraction, every person I processed. All of it flows back here. We tried to stop it once. We almost died. Then I made us forget.'",
		"The Eye's guardians rise from the crystalline floor. A knight built from stolen thoughts, a shade woven from oblivion, a harvester still hungry.",
	]
	b.post_battle_text = [
		"The guardians fall and the crystals beneath them go dark, memories spilling free in faint trails of light that drift upward and vanish.",
		"Sera is shaking. Not from cold. From proximity. 'It's right there. Behind that wall of light. I can hear it thinking.'",
		"She turns to the party. 'Listen to me. What we are about to face is not a person. It is not a creature. It is an appetite. It has been eating memories since before this coast had a name.'",
		"'But it has a weakness. The same thing that feeds it can poison it. Memory, freely given, in quantities it cannot digest.'",
		"She touches the wave-and-eye pendant at her neck. Her eyes are calm. Too calm. 'Let's finish this.'",
	]
	b.next_battle_id = "S2_EyeAwakening"
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Bloody Night.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/#10.wav"
	return b


# =============================================================================
# Prog 16: Eye Awakening (Phase 1 boss)
# =============================================================================

static func s2_eye_awakening() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_EyeAwakening"
	b.scene_image = "res://assets/art/battles/the_eye.png"
	b.enemies = [
		EnemyDBS2Act4.create_the_iris("The Iris"),
		EnemyDBS2Act4.create_oblivion_shade("Nullsight"),
	]
	b.pre_battle_text = [
		"The wall of light parts. Beyond it, the Eye.",
		"Not a metaphor. Not a symbol. A literal eye, vast and ancient, made of crystallized memories pressed together into something that sees, thinks, and hungers. It fills the chamber. Its iris shifts through colors that have no names.",
		"It speaks. Not with sound. The word arrives inside their skulls fully formed, echoing against every memory they have reclaimed.",
		"'You.'",
		"A pause. Recognition. Hunger.",
		"'I remember you. I remember what you tasted like.'",
		"The Iris, its guardian construct of fractured light, separates from the whole and descends. Behind it, a shade born from the void between thoughts.",
	]
	b.post_battle_text = [
		"The Iris shatters into a thousand prisms of dying light. The Eye screams without sound, a pressure that drives the party to their knees.",
		"But it does not fall. It watches. It waits. It is already healing.",
		"Sera steps forward. She pulls the wave-and-eye pendant from her neck and holds it out before her like a torch.",
		"'It feeds on memory. That is its weakness too.'",
		"She turns to the party. Her eyes are wet but her voice is steady.",
		"'I remember everything now. Every person I helped it take. Every name, every face, every life I unmade. That is a lot of memory to choke on.'",
		"She says each of their names. Slowly. One last time. The way you say a word you want to remember.",
		"Then she walks into the light.",
		"The Eye convulses. Sera's memories flood it like poison, centuries of guilt and grief and love poured into something that only knows how to consume. It thrashes. It shrinks. Its true form is exposed: smaller, desperate, mortal.",
		"A shimmer where she stood. Then nothing.",
		"Her voice, faint as breath, carried on the last of the light: 'Finish it. For everyone it took.'",
	]
	b.next_battle_id = "S2_EyeOfOblivion"
	b.music_track = "res://assets/audio/music/boss/Awakening of the Juggernaut_FULL.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/#11.wav"
	return b


# =============================================================================
# Prog 17: Eye of Oblivion (Phase 2 final boss)
# =============================================================================

static func s2_eye_of_oblivion() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_EyeOfOblivion"
	b.scene_image = "res://assets/art/battles/the_eye.png"
	b.enemies = [
		EnemyDBS2Act4.create_the_lidless_eye("The Lidless Eye"),
	]
	b.pre_battle_text = [
		"The Eye is wounded. Bleeding light. Smaller now, stripped of its outer defenses, its ancient hunger laid bare.",
		"But still dangerous. It turns its full attention on the party, and the weight of it is like standing under an avalanche.",
		"It tries to feed. Tries to pull memories loose the way it has for centuries. Flashes of the cave, the shore, the lighthouse, the sanctum. Every moment reclaimed, every choice that brought them here, it reaches for all of it.",
		"But they hold on. They have something it never understood.",
		"The choice to remember.",
	]
	b.post_battle_text = [
		"The Eye closes for the last time. The crystallized memories shatter, and light rises from the depths like a thousand lanterns set free.",
		"Across the coast, people stop mid-sentence. A name they forgot. A face they lost. A moment that was taken, returned without explanation.",
		"The old woman in the fishing village remembers the dinner. The blacksmith remembers why the sword was urgent. The barkeep remembers the conversations.",
		"Deep below, in the place where the Eye once watched, the party stands in silence. The machinery is dark. The crystals are empty.",
		"A voice, faint as breath, echoes through the chamber. Sera's voice, carried on the last of the light.",
		"'Thank you.'",
		"They carry her memory with them. Not because they have to. Because they choose to.",
	]
	b.is_final_battle = true
	b.music_track = "res://assets/audio/music/boss/The Battle of Ages_FULL.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/#14.wav"
	return b
