class_name BattleDBS2Act3

## Story 2 Act III battle configurations: "The Truth"
## Structure: BeneathTheLighthouse -> (MemoryVault | EchoGallery)
##   -> ShatteredSanctum -> (GuardiansThreshold | ForgottenArchive)
##   -> TheReveal

const BattleData := preload("res://scripts/data/battle_data.gd")
const EnemyDBS2Act3 := preload("res://scripts/data/enemy_db_s2_act3.gd")


static func create_battle(battle_id: String) -> BattleData:
	match battle_id:
		"S2_BeneathTheLighthouse": return s2_beneath_the_lighthouse()
		"S2_MemoryVault": return s2_memory_vault()
		"S2_EchoGallery": return s2_echo_gallery()
		"S2_ShatteredSanctum": return s2_shattered_sanctum()
		"S2_GuardiansThreshold": return s2_guardians_threshold()
		"S2_ForgottenArchive": return s2_forgotten_archive()
		"S2_TheReveal": return s2_the_reveal()
		_:
			push_error("Unknown Story 2 Act III battle: %s" % battle_id)
			return s2_beneath_the_lighthouse()


# =============================================================================
# Prog 9: Beneath the Lighthouse (entry point)
# =============================================================================

static func s2_beneath_the_lighthouse() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_BeneathTheLighthouse"
	b.scene_image = "res://assets/art/battles/memory_sanctum.png"
	b.enemies = [
		EnemyDBS2Act3.create_memory_wisp("Glimmer"),
		EnemyDBS2Act3.create_memory_wisp("Shimmer"),
		EnemyDBS2Act3.create_echo_sentinel("Resonance"),
	]
	b.pre_battle_text = [
		"The key with the wave-and-eye symbol fits the door beneath the lighthouse foundation. A staircase spirals downward into blue-lit stone.",
		"The air changes immediately. Heavy, still, tasting of copper and old paper. Crystalline structures line the walls, pulsing with a light that has nothing to do with fire or sun.",
		"Not decorations. Containers. Each one holds a shimmer of something that feels like it should be recognized.",
		"The first memories bloom without warning. A workshop. Ink-stained hands. Maps of something forbidden spread across a table. A woman's voice, calm and certain: 'You were never supposed to find this.'",
		"The crystals flare and something detaches from the walls. Guardians. Left here to protect whatever lies below.",
	]
	b.post_battle_text = [
		"The guardians dissolve into motes of light that drift back into the crystalline walls. The staircase continues deeper.",
		"Two passages branch ahead. One pulses with crystallized light, rows of containers stretching into the distance. The other hums with sound, fragments of voices layered over each other.",
		"A memory surfaces: walking these halls before, alone, late at night, carrying something important.",
	]
	b.choices = [
		{"label": "Follow the crystallized light deeper into the sanctum.", "battle_id": "S2_MemoryVault"},
		{"label": "Follow the echoing voices down the humming corridor.", "battle_id": "S2_EchoGallery"},
	]
	b.music_track = "res://assets/audio/music/battle_dark/01_Static_Presence.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/#12 Cave Horn.wav"
	return b


# =============================================================================
# Prog 10: Branch A - Memory Vault
# =============================================================================

static func s2_memory_vault() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_MemoryVault"
	b.scene_image = "res://assets/art/battles/memory_vault.png"
	b.enemies = [
		EnemyDBS2Act3.create_thought_eater("Gnaw"),
		EnemyDBS2Act3.create_grief_shade("Weeping"),
		EnemyDBS2Act3.create_memory_wisp("Flicker"),
	]
	b.pre_battle_text = [
		"Rows of crystalline containers stretch into darkness, each holding a shimmer of captured light. Hundreds of them. Thousands.",
		"One container bears a name. One of the party's names, scratched into the crystal in careful handwriting.",
		"Touching it is like being struck by lightning. Not pain. Memory.",
		"They were investigators. Hired by a merchant guild to find missing people. People who vanished without a trace, leaving behind families who couldn't quite remember what the missing looked like.",
		"The containers stir. Something feeds here, drawn by the act of remembering.",
	]
	b.post_battle_text = [
		"The creatures retreat into the deeper shelves, trailing wisps of stolen light.",
		"More memories flood back as the party moves through the vault. All the missing people visited the same place before they vanished. A lighthouse.",
		"A logbook sits on a stone lectern, written in a woman's precise hand. 'Subjects contained. Extraction complete. Memory residue within acceptable parameters.'",
		"Below that, a different entry, same handwriting, shakier: 'They're getting too close. The three of them. I have to do something before the Eye finds out what they know.'",
	]
	b.next_battle_id = "S2_ShatteredSanctum"
	b.music_track = "res://assets/audio/music/battle_dark/08_Rotten_Memories.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 06.wav"
	return b


# =============================================================================
# Prog 10: Branch B - Echo Gallery
# =============================================================================

static func s2_echo_gallery() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_EchoGallery"
	b.scene_image = "res://assets/art/battles/echo_gallery.png"
	b.enemies = [
		EnemyDBS2Act3.create_hollow_watcher("The Silent"),
		EnemyDBS2Act3.create_echo_sentinel("Reverb"),
		EnemyDBS2Act3.create_thought_eater("Whisper"),
	]
	b.pre_battle_text = [
		"A long corridor where the walls are not walls but windows into moments that already happened. Voices repeat in fragments, layered and overlapping.",
		"The party hears themselves. Conversations they do not remember having.",
		"'We have to tell someone.' Their own voice, urgent, afraid.",
		"'No one will believe us. We need proof.' Another party member, steadier, already planning.",
		"The echoes solidify. Guardians that have no eyes but see everything, constructs that feed on replayed moments.",
	]
	b.post_battle_text = [
		"The guardians shatter and the corridor falls silent for a moment before the echoes resume, quieter now.",
		"One scene plays out in full on the wall. The party, weeks or months ago, watching from a rooftop. Below, people in grey cloaks bearing the wave-and-eye symbol lead a procession of blank-eyed villagers into a building. The villagers walk in. They do not walk out.",
		"The woman's voice again, crying this time: 'I tried to warn you. I told you to stop looking. Why didn't you stop?'",
		"The corridor opens into a wider chamber ahead. The air smells of ozone and regret.",
	]
	b.next_battle_id = "S2_ShatteredSanctum"
	b.music_track = "res://assets/audio/music/battle_dark/04_Eyes_in_the_Woods.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 08.wav"
	return b


# =============================================================================
# Prog 11: Shattered Sanctum (convergence + THE REVEAL)
# =============================================================================

static func s2_shattered_sanctum() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_ShatteredSanctum"
	b.scene_image = "res://assets/art/battles/shattered_sanctum.png"
	b.enemies = [
		EnemyDBS2Act3.create_mirror_self("Reflection"),
		EnemyDBS2Act3.create_void_weaver("Unmaker"),
		EnemyDBS2Act3.create_grief_shade("Mourning"),
	]
	b.pre_battle_text = [
		"The sanctum is broken. Something tore through here. The crystalline walls are fractured, memories leaking like water from cracked vessels, pooling on the floor in shimmering puddles.",
		"Reflections form in the broken crystal. The party's own faces, but harder. Older. These were people who had seen terrible things and kept looking.",
		"A journal lies open on a stone table, written in one of the party member's own handwriting. The words hit like a physical blow.",
		"'Sera took our memories. She said the Eye would kill us if we remembered. She said forgetting was the only way to survive. We agreed. All three of us agreed. God help us, we asked her to do it.'",
		"A portrait hangs on the far wall, untouched by the destruction. A woman with kind eyes and dark hair, wearing the wave-and-eye pendant not as a badge but as a chain around her neck. Sera. She was the fourth in their party.",
	]
	b.post_battle_text = [
		"The reflections shatter. The void collapses. Silence settles over the ruined sanctum.",
		"More of the journal, scattered across the floor. Sera was not their enemy. She was their closest ally. She worked inside the Eye's organization, feeding them information, helping them get close to the truth.",
		"When the Eye discovered the leak, Sera had hours to act. She could not destroy the organization alone. She could not protect the party while they slept. The only option she saw was to make them invisible. Unmemorable. Empty.",
		"She erased them. Then, because the Eye would come for her too, she erased herself.",
		"Two passages lead deeper. One toward the inner ward, where the sanctum's guardians stand watch. The other toward a forgotten archive, where records of every extraction are kept.",
	]
	b.choices = [
		{"label": "Press toward the inner ward.", "battle_id": "S2_GuardiansThreshold"},
		{"label": "Search the forgotten archive.", "battle_id": "S2_ForgottenArchive"},
	]
	b.music_track = "res://assets/audio/music/battle_dark/MUSC_Black_Moon_52BPM_Eminor_1644_Full_Loop.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 10.wav"
	return b


# =============================================================================
# Prog 12: Branch A - Guardian's Threshold
# =============================================================================

static func s2_guardians_threshold() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_GuardiansThreshold"
	b.scene_image = "res://assets/art/battles/shattered_sanctum.png"
	b.enemies = [
		EnemyDBS2Act3.create_mnemonic_golem("Remembrance"),
		EnemyDBS2Act3.create_void_weaver("Erasure"),
		EnemyDBS2Act3.create_mirror_self("Echo"),
	]
	b.pre_battle_text = [
		"The inner ward. Massive crystalline constructs stand sentinel before the sanctum core, inert until the party crosses an invisible threshold.",
		"Sera's handwriting covers the walls in desperate repetition. 'Forgive me. Forgive me. Forgive me.' Written in ink, in chalk, in scratches from bare fingernails.",
		"She left these guardians here. Not to trap anyone. To stop anyone from undoing what she did. To protect the forgetting she gave them.",
		"The constructs activate with a sound like breaking glass played in reverse.",
	]
	b.post_battle_text = [
		"The constructs crumble, their crystalline bodies dissolving into motes of light that drift upward and vanish.",
		"Beyond the ward, the sanctum core. And carved into the doorframe, a final message in Sera's hand:",
		"'If you're reading this, I failed. The Eye found you anyway, or you found yourselves. I'm sorry. I'm at the place where it started, where we first met. Come find me, or don't. You were happier not knowing.'",
		"The door to the core stands open.",
	]
	b.next_battle_id = "S2_TheReveal"
	b.music_track = "res://assets/audio/music/battle_dark/MUSC_Secret_Garden_76BPM_Eminor_1644_Full_Loop.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 01.wav"
	return b


# =============================================================================
# Prog 12: Branch B - Forgotten Archive
# =============================================================================

static func s2_forgotten_archive() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_ForgottenArchive"
	b.scene_image = "res://assets/art/battles/forgotten_archive.png"
	b.enemies = [
		EnemyDBS2Act3.create_mnemonic_golem("Archivist"),
		EnemyDBS2Act3.create_hollow_watcher("Cataloger"),
		EnemyDBS2Act3.create_grief_shade("Lost Entry"),
	]
	b.pre_battle_text = [
		"The archive stretches into shadow. Shelf after shelf of records, each one a life unmade. Hundreds of names. Hundreds of people who walked into the Eye's reach and walked out empty.",
		"The party finds their own entries. Three files, thick with notes, annotated in Sera's careful hand.",
		"The annotation on each file is the same, underlined twice: 'Too close. Extraction voluntary.'",
		"Voluntary. They chose this. They walked into this room, sat in that chair, and asked Sera to take everything that made them who they were.",
		"The archive's guardians do not appreciate the intrusion.",
	]
	b.post_battle_text = [
		"The guardians fall and the archive settles into silence.",
		"The files contain the full truth. The party discovered the Eye's network: memory extraction facilities beneath lighthouses along the coast, feeding stolen memories to something at the center. Something hungry.",
		"They could not stop it alone. They tried. They failed. People died.",
		"Sera offered the only escape she could think of. Forget everything. Become no one. The Eye cannot hunt what it cannot remember.",
		"They agreed. But Sera, unable to live with what she had done, erased herself too. Neither side remembers why.",
		"The archive connects to the sanctum core through a narrow passage.",
	]
	b.next_battle_id = "S2_TheReveal"
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Dark Fables.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 02.wav"
	return b


# =============================================================================
# Prog 13: The Reveal (Act III boss)
# =============================================================================

static func s2_the_reveal() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_TheReveal"
	b.scene_image = "res://assets/art/battles/sanctum_core.png"
	b.enemies = [
		EnemyDBS2Act3.create_the_warden("The Warden"),
		EnemyDBS2Act3.create_fractured_protector("Sera"),
	]
	b.pre_battle_text = [
		"The sanctum core. A chamber of polished stone and crystalline machinery, beautiful and terrible. This is where it happened. Where memories were taken, processed, stored. Where the party sat down and let themselves be unmade.",
		"A woman stands at the center, weapons drawn, back against the machinery. Dark hair, kind eyes gone hard with suspicion. The wave-and-eye pendant hangs heavy around her neck.",
		"She does not recognize them.",
		"'Stay back. I don't know who you are, but this place is mine to protect.' Her voice wavers. 'I don't remember why, but I know that much. I know I have to keep everyone out.'",
		"Beside her, the sanctum's ancient warden stirs to life, responding to her distress. There is no reasoning past it.",
	]
	b.post_battle_text = [
		"The warden crumbles. Sera drops to her knees, breathing hard.",
		"Something in the battle broke loose. Contact, proximity, the resonance of the sanctum itself. Memories cascade through her in a torrent.",
		"She looks up. Sees their faces. Remembers.",
		"'Oh.' Just that, at first. Then their names, one by one. Then the tears.",
		"'I thought it would hold. I thought you'd be safe. I thought...' She presses her palms against her eyes. 'The Eye is still out there. The network, the lighthouses, the thing at the center. If it finds out you remember, it will come for all of us.'",
		"She pulls the wave-and-eye pendant from her neck and presses it into their hands alongside the lighthouse key.",
		"'Then we finish what we started. All four of us, this time.'",
		"A door opens behind the machinery, leading up and out into grey daylight. The truth is theirs again. But so is the danger.",
	]
	b.next_battle_id = "S2_DepthsOfRemembrance"
	b.music_track = "res://assets/audio/music/boss/Impending Terror_FULL.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/#15 Dark Strings Swell.wav"
	return b
