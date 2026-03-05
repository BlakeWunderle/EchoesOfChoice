class_name BattleDBS2Act2

## Story 2 Act II battle configurations: "The Shore"
## Structure: CoastalDescent -> (FishingVillage | SmugglersBluff)
##   -> HarborTown -> (WreckersCove | CoastalRuins) -> BlackwaterBay
##   -> LighthouseStorm

const BattleData := preload("res://scripts/data/battle_data.gd")
const EnemyDBS2Act2 := preload("res://scripts/data/enemy_db_s2_act2.gd")


static func create_battle(battle_id: String) -> BattleData:
	match battle_id:
		"S2_CoastalDescent": return s2_coastal_descent()
		"S2_FishingVillage": return s2_fishing_village()
		"S2_SmugglersBluff": return s2_smugglers_bluff()
		"S2_HarborTown": return s2_harbor_town()
		"S2_WreckersCove": return s2_wreckers_cove()
		"S2_CoastalRuins": return s2_coastal_ruins()
		"S2_BlackwaterBay": return s2_blackwater_bay()
		"S2_LighthouseStorm": return s2_lighthouse_storm()
		_:
			push_error("Unknown Story 2 Act II battle: %s" % battle_id)
			return s2_coastal_descent()


# =============================================================================
# Prog 4: Coastal Descent (first surface battle)
# =============================================================================

static func s2_coastal_descent() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_CoastalDescent"
	b.scene_image = "res://assets/art/battles/rocky_shore.png"
	b.enemies = [
		EnemyDBS2Act2.create_blighted_gull("Blackwing"),
		EnemyDBS2Act2.create_shore_crawler("Ironshell"),
		EnemyDBS2Act2.create_warped_hound("Brine"),
	]
	b.pre_battle_text = [
		"Daylight. Real, burning, overwhelming daylight.",
		"The party stumbles down a rocky hillside, blinking against a sun they forgot existed. Below, a coastline stretches in both directions. Waves crash against dark stone.",
		"The relief lasts about ten seconds.",
		"Overhead, gulls circle. Not white. Oil-black, with feathers that glisten like something rotting. Their cries sound like metal scraping metal.",
		"A dog-shaped thing crawls out from behind a boulder. Its body bends in ways no hound should bend, and saltwater drools from its jaw in long, ropy strands.",
		"Whatever touched the cave has reached the surface too.",
	]
	b.post_battle_text = [
		"The corrupted creatures scatter, the hound dragging itself into a tide pool, the gulls wheeling inland with ragged shrieks.",
		"From the hilltop, two columns of smoke are visible. To the south, clustered chimneys and the faint sound of voices. To the north, scuff marks and heavy cargo tracks worn into the bluff.",
		"A memory surfaces without warning. A pier. Weathered wood under bare feet. Someone waving from a boat. The feeling of belonging somewhere.",
		"Gone before it can be placed.",
	]
	b.choices = [
		{"label": "South: Chimney smoke and distant voices.", "battle_id": "S2_FishingVillage"},
		{"label": "North: Scuff marks and heavy cargo tracks along the bluff.", "battle_id": "S2_SmugglersBluff"},
	]
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Cursed Kingdoms.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 05.wav"
	return b


# =============================================================================
# Prog 5: Branch A - Fishing Village
# =============================================================================

static func s2_fishing_village() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_FishingVillage"
	b.scene_image = "res://assets/art/battles/wanderers_rest.png"
	b.enemies = [
		EnemyDBS2Act2.create_driftwood_bandit("Scarhand"),
		EnemyDBS2Act2.create_driftwood_bandit("Rust"),
		EnemyDBS2Act2.create_saltrunner_smuggler("Quicksilver"),
	]
	b.pre_battle_text = [
		"A small fishing village. Nets hang drying between the houses. Smoke curls from a dozen chimneys.",
		"An old woman sorting fish on the dock looks up, drops her basket, and stares. 'You. You're alive.'",
		"Before anyone can respond, the tavern door crashes open. Three armed figures stride out, blades drawn.",
		"They have been shaking down the village for weeks. They do not appreciate newcomers.",
	]
	b.post_battle_text = [
		"The bandits flee down the coast road, boots splashing through tide pools.",
		"The old woman clutches a party member's arm. 'I made you dinner once. You sat right there.' She points at a bench near the dock. 'I can't remember what we ate. Isn't that strange? I remember the table, the plates, your face, but the rest is...' She trails off, confused by her own gaps.",
		"She presses a coin into their hand. A name is scratched into it, but not theirs.",
		"'Someone gave me this for you. I don't remember who.'",
		"The coin feels right. Weight, temperature, the way it sits in the palm. Someone gave this as a promise.",
	]
	b.next_battle_id = "S2_HarborTown"
	b.music_track = "res://assets/audio/music/battle/Side Quest Battle LOOP.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 09.wav"
	return b


# =============================================================================
# Prog 5: Branch B - Smugglers Bluff
# =============================================================================

static func s2_smugglers_bluff() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_SmugglersBluff"
	b.scene_image = "res://assets/art/battles/shipwreck_beach.png"
	b.enemies = [
		EnemyDBS2Act2.create_saltrunner_smuggler("Duskrunner"),
		EnemyDBS2Act2.create_tide_warden("Breakwater"),
		EnemyDBS2Act2.create_driftwood_bandit("Splinter"),
	]
	b.pre_battle_text = [
		"The bluff path descends to a hidden cove. Crates marked with unfamiliar symbols sit stacked behind camouflage netting.",
		"Smugglers. Their captain takes one look at the party and goes pale.",
		"'No. You're supposed to be gone.' He pauses, confused. 'At least... I think you're supposed to be gone. Someone told me that. I can't remember who.'",
		"His confusion turns to anger. He signals his crew to attack.",
	]
	b.post_battle_text = [
		"The smugglers scatter into sea caves too narrow to follow.",
		"The captain drops a journal in his retreat. Most pages are water-damaged, but one is clear: 'Package delivered to cave mouth, three sleeping. Payment received from...'",
		"The name after 'from' is not scratched out. The ink is simply gone, as if the memory of the name left the page the same way it left the captain's mind.",
		"One party member recognizes the handwriting. Not the words, but the slant of the letters, the way the ink bleeds at the end of each line. Someone they knew wrote this.",
	]
	b.next_battle_id = "S2_HarborTown"
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Altar of the Forgotten.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 11.wav"
	return b


# =============================================================================
# Town stop: Harbor Town (T1 -> T2 upgrades)
# =============================================================================

static func s2_harbor_town() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_HarborTown"
	b.scene_image = "res://assets/art/battles/city_streets.png"
	b.is_town_stop = true
	b.pre_battle_text = [
		"The coastal road leads to a harbor town. Not large, but busy. Ships crowd the harbor, a market lines the waterfront, and the air smells of tar, fish, and spice.",
		"A blacksmith looks up from her forge and nearly drops her hammer.",
		"'Your sword. I made that sword.' She pauses. 'Three years ago? Four? The details keep slipping. I remember your face and I remember the weight of the blade, but I can't remember what you told me it was for.'",
		"She pulls gear from a locked cabinet. Perfectly fitted, clearly set aside.",
		"'I knew I was keeping these for someone. Now I know who.'",
	]
	b.post_battle_text = [
		"At the tavern, the barkeep sets three drinks on the counter without being asked.",
		"'Your usual. At least I think it is. I remember making them, but not what we talked about while you drank.'",
		"He scratches his head. 'A woman came through. In grey. Asked about you. I told her no, but...' He frowns. 'I can't remember what she looked like. Just the grey. That's not normal, is it?'",
		"Two threads emerge from the conversations in town. The smuggler's journal mentioned a meeting place. The blacksmith remembers which direction the party always arrived from.",
	]
	b.choices = [
		{"label": "The smuggler's journal mentions a meeting at the wreckers' cove.", "battle_id": "S2_WreckersCove"},
		{"label": "The blacksmith remembers you arriving from the old coastal ruins.", "battle_id": "S2_CoastalRuins"},
	]
	b.music_track = "res://assets/audio/music/town/Town Village 02(L).wav"
	return b


# =============================================================================
# Prog 6: Branch A - Wreckers Cove (WHO did this)
# =============================================================================

static func s2_wreckers_cove() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_WreckersCove"
	b.scene_image = "res://assets/art/battles/shipwreck_beach.png"
	b.enemies = [
		EnemyDBS2Act2.create_blackwater_captain("Captain Korr"),
		EnemyDBS2Act2.create_corsair_hexer("Saltweave"),
		EnemyDBS2Act2.create_driftwood_bandit("Barnacle"),
	]
	b.pre_battle_text = [
		"The wreckers' cove is a graveyard of ships. Hulls stacked and broken, masts pointing at the sky like dead trees.",
		"Blackwater mercenaries guard the smuggler's meeting point. Their captain squints at the party.",
		"'I know your faces. We were told you wouldn't be a problem anymore.' He hesitates. 'Who told us that? I should know that.'",
		"His confusion turns to anger. 'Doesn't matter. Orders are orders.'",
	]
	b.post_battle_text = [
		"Among the mercenaries' belongings, a sealed letter. 'The three are secured. Memories processed. No recovery expected.'",
		"Sealed with a symbol. A wave cresting over a closed eye.",
		"The captain, defeated, slumps against a hull. 'I can't remember who hired us. I can't remember the briefing. Just the job. Just the money. Something took the rest.'",
		"One party member traces the symbol on the seal and gasps. Not a memory. Recognition. Primal fear of whoever wears that mark.",
	]
	b.next_battle_id = "S2_BlackwaterBay"
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - War Ready.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 12.wav"
	return b


# =============================================================================
# Prog 6: Branch B - Coastal Ruins (WHERE they came from)
# =============================================================================

static func s2_coastal_ruins() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_CoastalRuins"
	b.scene_image = "res://assets/art/battles/highlands.png"
	b.enemies = [
		EnemyDBS2Act2.create_abyssal_lurker("Depthcrawl"),
		EnemyDBS2Act2.create_stormwrack_raptor("Voltwing"),
		EnemyDBS2Act2.create_blighted_gull("Shriek"),
	]
	b.pre_battle_text = [
		"The coastal ruins are older than the town. Crumbling stone walls covered in salt lichen. According to the blacksmith, this is where the party always came from.",
		"Inside the largest ruin, someone has been living here. Recently. Bedrolls, a cold fire pit, journals filled with the party's own handwriting.",
		"They were researching something before the memory loss.",
		"An abyssal lurker rises from a tidal pool in the center of the ruin. The corruption has been here for a while.",
	]
	b.post_battle_text = [
		"The journals are mostly water-damaged, but fragments survive.",
		"'The source is beneath the lighthouse. The corruption spreads from the lamp.'",
		"'She knows we're close. We need to move before...' The rest of the page is torn.",
		"The party was investigating the corruption. They were close to finding the source. That is why their memories were taken. To stop them.",
		"One party member opens a journal and reads their own handwriting. Not the content. The feeling of writing it. Late at night, by candlelight, urgency in every stroke. They were afraid. They were running out of time.",
	]
	b.next_battle_id = "S2_BlackwaterBay"
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Elegy of the Fallen.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 13.wav"
	return b


# =============================================================================
# Prog 7: Blackwater Bay (convergence)
# =============================================================================

static func s2_blackwater_bay() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_BlackwaterBay"
	b.scene_image = "res://assets/art/battles/rocky_shore.png"
	b.enemies = [
		EnemyDBS2Act2.create_salt_phantom("The Drowned"),
		EnemyDBS2Act2.create_salt_phantom("The Forgotten"),
		EnemyDBS2Act2.create_abyssal_lurker("Undertow"),
	]
	b.pre_battle_text = [
		"Blackwater Bay. A stretch of dark-sand beach where the town's fishing boats do not go.",
		"The water is wrong. Too still, too dark, faintly luminescent. The lighthouse stands on a spit of rock at the bay's far end, its lamp dark.",
		"As the party approaches, the water begins to churn. Shapes rise from the surf. Not creatures from the deep. Human shapes, translucent and cold, wearing the faces of people the party almost recognizes.",
	]
	b.post_battle_text = [
		"The phantoms dissolve into sea spray. One whispers a party member's name. Their real name, the one they chose in the cave. Somehow these things knew it before they did.",
		"The lighthouse looms ahead. The lamp is dark but something flickers inside. A presence. Something waiting.",
		"A full vision, not a fragment. Standing on this very beach, in daylight, with someone whose face keeps sliding out of focus. 'Don't go to the lighthouse,' they say. 'Promise me.'",
		"But the party went anyway. And then they forgot everything.",
	]
	b.next_battle_id = "S2_LighthouseStorm"
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - The Darkness.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 14.wav"
	return b


# =============================================================================
# Prog 8: Lighthouse Storm (Act II boss)
# =============================================================================

static func s2_lighthouse_storm() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_LighthouseStorm"
	b.scene_image = "res://assets/art/battles/stranger_tower.png"
	b.enemies = [
		EnemyDBS2Act2.create_tidecaller_revenant("The Keeper"),
		EnemyDBS2Act2.create_salt_phantom("The Watcher"),
	]
	b.pre_battle_text = [
		"The lighthouse stairs spiral upward. The walls are covered in symbols. The same symbols from the cave, from the smuggler's crates, from the ruins.",
		"At the top, the lamp chamber. A figure stands at the lantern, wreathed in mist and dripping saltwater.",
		"A drowned revenant with a face that flickers between recognition and nothing.",
		"'I'm sorry,' it says. 'I was supposed to make sure you never remembered. She said...' It pauses, confused. 'She said it was the only way. I can't remember why. I used to know. I used to know everything.'",
	]
	b.post_battle_text = [
		"The revenant collapses into water that runs down the stairs and out to sea.",
		"In its hand, a key with the wave-and-eye symbol. Below the lighthouse, hidden beneath the foundation, a door that the key fits.",
		"The party knows they have opened this door before.",
		"The revenant's last whisper, barely audible: 'She will know you're coming. She always does. I think... I think she was afraid of you.'",
		"A name surfaces at last. Not theirs. The person who took their memories. A face, a voice, and the sickening certainty that they once trusted this person completely.",
	]
	b.next_battle_id = "S2_BeneathTheLighthouse"
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - The Last Crusade.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 15.wav"
	return b
