class_name NarrativeEndings

## Pure text-returning helpers for story endings and unlock notifications.
## No scene dependencies; all methods are static and take only primitive parameters.


static func get_ending_text_story_1(game_won: bool, battle_id: String = "") -> Array[String]:
	var is_path_b: bool = battle_id == "StrangerUndoneBattle"
	if game_won:
		if is_path_b:
			return _get_ending_text_story_1_path_b()
		return [
			"The stranger is gone and with them, the shadow that covered the land.",
			"The sky clears. The city stirs. People emerge from hiding.",
			"It will take time, but the world will heal.",
			"Our heroes stand in the light, bruised and exhausted and alive.",
			"Every choice left an echo, and theirs will ring through the ages.",
		]
	else:
		return _get_defeat_text_story_1(battle_id)


static func _get_defeat_text_story_1(battle_id: String) -> Array[String]:
	# Acts I-II: Stranger is still an ally, player doesn't know he's the villain
	const ACT_1_2: Array = [
		"CityStreetBattle", "WolfForestBattle", "WaypointDefenseBattle",
		"HighlandBattle", "MountainPassBattle", "DeepForestBattle", "CaveBattle",
		"ShoreBattle", "BeachBattle", "CircusBattle", "LabBattle", "ArmyBattle",
		"CemeteryBattle", "OutpostDefenseBattle", "MirrorBattle",
	]
	# Act III: The reveal — Stranger is the villain
	const ACT_3: Array = ["ReturnToCityStreetBattle", "StrangerTowerBattle"]
	if battle_id in ACT_1_2:
		return [
			"The road was long and the wilds unforgiving. Our heroes fought bravely, but the world had more teeth than they had steel.",
			"Somewhere, a stranger waits by a fire, wondering why his friends never returned.",
			"This journey may be over, but every great story deserves another telling.",
		]
	if battle_id in ACT_3:
		return [
			"The Stranger's betrayal cut deeper than any blade. His shadow stretches across the city, unchallenged.",
			"The tower stands. The sigils glow. And the people below learn to live in the dark.",
			"This journey may be over, but every great story deserves another telling.",
		]
	if battle_id == "StrangerUndoneBattle":
		return [
			"The Stranger stands alone in the ruins of his sanctum, broken but undefeated.",
			"Without his ritual he is diminished. Without challengers he is uncontested. The shadow grows slowly, quietly, the way it always has.",
			"This journey may be over, but every great story deserves another telling.",
		]
	# Acts IV-V Path A (default): hunting the Stranger
	return [
		"Our heroes fall and the darkness grows a little stronger.",
		"The Stranger's sigils pulse beneath the city. Whatever he is building down there, no one is left to stop it.",
		"This journey may be over, but every great story deserves another telling.",
	]


static func _get_defeat_text_story_2(battle_id: String) -> Array[String]:
	# Act I: No memories, trapped in a strange cave
	const ACT_1: Array = [
		"S2_CaveAwakening", "S2_DeepCavern", "S2_FungalHollow",
		"S2_TranquilPool", "S2_TorchChamber", "S2_CaveExit",
	]
	# Act II: Surface, discovering clues about memory theft
	const ACT_2: Array = [
		"S2_CoastalDescent", "S2_FishingVillage", "S2_SmugglersBluff",
		"S2_WreckersCove", "S2_CoastalRuins", "S2_BlackwaterBay",
		"S2_LighthouseStorm",
	]
	# Act III: Learning the truth about Sera and the Eye
	const ACT_3: Array = [
		"S2_BeneathTheLighthouse", "S2_MemoryVault", "S2_EchoGallery",
		"S2_ShatteredSanctum", "S2_GuardiansThreshold", "S2_ForgottenArchive",
		"S2_TheReveal",
	]
	# Path B: Save Sera route
	const PATH_B: Array = [
		"S2_B_ArchiveAwakening", "S2_B_LighthouseCore",
		"S2_B_ResonanceChamber", "S2_B_MemoryFlood",
	]
	if battle_id in ACT_1:
		return [
			"The cave does not let go. The light at the edge of memory fades, and the darkness settles back in, patient and absolute.",
			"Three strangers lie still in the deep. They will not remember why they came here. They will not remember anything at all.",
			"This journey may be over, but every great story deserves another telling.",
		]
	if battle_id in ACT_2:
		return [
			"The trail goes cold. The questions remain, carved into driftwood and whispered by strangers who remember too little and fear too much.",
			"Somewhere beneath the lighthouse, something watches the coast and waits for the next dreamers to wash ashore.",
			"This journey may be over, but every great story deserves another telling.",
		]
	if battle_id in ACT_3:
		return [
			"The truth was not enough to set them free. Sera's name echoes in the broken sanctum, unanswered.",
			"The Eye's machinery hums on. The memories do not return. And somewhere in the dark, a woman who erased herself stands guard over secrets no one will ever read.",
			"This journey may be over, but every great story deserves another telling.",
		]
	if battle_id in PATH_B:
		return [
			"Sera's failsafe was not enough. The resonance fades, the overload stalls, and the Eye turns its gaze on the four who dared to look back.",
			"The memories scatter. Sera falls to her knees in the machinery she built, watching her second chance slip through her fingers.",
			"This journey may be over, but every great story deserves another telling.",
		]
	if battle_id == "S2_B_EyeUnblinking":
		return [
			"The Eye remains open. The overload was not enough.",
			"Sera's failsafe failed, and the Eye turns its full, undiminished attention on the four who dared to challenge it. This time, there is nowhere to run.",
			"This journey may be over, but every great story deserves another telling.",
		]
	# Act IV Path A (default): fighting the Eye after Sera's sacrifice
	return [
		"The Eye remains open. The memories do not return.",
		"Sera's sacrifice was not enough. In the darkness below the world, something watches. Something waits. Something remembers everything it has taken.",
		"This journey may be over, but every great story deserves another telling.",
	]


static func _get_defeat_text_story_3(battle_id: String) -> Array[String]:
	# Acts I-II early: Strange dreams, something is wrong
	const ACT_1_2_EARLY: Array = [
		"S3_DreamMeadow", "S3_DreamMirrorHall", "S3_DreamFogGarden",
		"S3_DreamReturn", "S3_DreamThreads", "S3_DreamDrownedCorridor",
		"S3_DreamShatteredGallery", "S3_DreamShadowChase",
	]
	# Acts I-II late: Deeper dreams + waking investigation
	const ACT_2_LATE: Array = [
		"S3_DreamLabyrinth", "S3_DreamClockTower", "S3_DreamNightmare",
		"S3_MarketConfrontation", "S3_CellarDiscovery",
	]
	# Act III: Lira revealed, cult discovered, lucid dreaming
	const ACT_3: Array = [
		"S3_LucidDream", "S3_DreamTemple", "S3_DreamVoid", "S3_DreamSanctum",
	]
	# Path B: Suspicion route
	const PATH_B: Array = [
		"S3_B_InnSearch", "S3_B_CultConfrontation", "S3_B_TunnelBreach",
		"S3_B_ThornesWard", "S3_B_LoomHeart", "S3_B_DreamInvasion",
	]
	# Path C: Lira's confession route
	const PATH_C: Array = [
		"S3_C_DreamDescent", "S3_C_CultInterception", "S3_C_ThreadmasterLair",
	]
	if battle_id in ACT_1_2_EARLY:
		return [
			"The dream does not release its hold. The travelers sink deeper into sleep, and the weariness they carried into the inn settles into their bones like lead.",
			"At The Weary Traveler, a kind face smiles and pours ale for the next guest. Rest well. Everyone rests well here.",
			"This journey may be over, but every great story deserves another telling.",
		]
	if battle_id in ACT_2_LATE:
		return [
			"The town keeps its secrets. The threads pull tight, the cellar door locks, and the questions that surfaced in the market sink back into silence.",
			"The travelers sleep. The dreams return, familiar and warm and not their own. By morning, they will have forgotten they ever thought to ask.",
			"This journey may be over, but every great story deserves another telling.",
		]
	if battle_id in ACT_3:
		return [
			"The Loom tightens. The lucid dream collapses, and the travelers fall back into the woven night. They knew the truth for a moment. That moment is gone.",
			"In the sanctum below the inn, threads pulse and mend. The cult tends the Loom. The innkeeper smiles.",
			"This journey may be over, but every great story deserves another telling.",
		]
	if battle_id in PATH_B:
		return [
			"The threads hold. The girl smiles. She was always going to smile.",
			"Somewhere in a quiet town, a serving girl pours ale for the next weary traveler. She has done this for centuries. She will do it for centuries more.",
			"This journey may be over, but every great story deserves another telling.",
		]
	if battle_id == "S3_B_DreamNexus":
		return [
			"The threads hold. The girl smiles. She was always going to smile.",
			"Somewhere in a quiet town, a serving girl pours ale for the next weary traveler. She has done this for centuries. She will do it for centuries more.",
			"This journey may be over, but every great story deserves another telling.",
		]
	if battle_id in PATH_C:
		return [
			"The Threadmaster pulls Lira back into the threads. Her scream fades into the hum of the Loom. The dream tightens, and the travelers forget they ever heard her voice.",
			"Somewhere in a quiet town, a serving girl pours ale with trembling hands. The chains beneath her skin pulse, and she cannot remember why she is crying.",
			"This journey may be over, but every great story deserves another telling.",
		]
	if battle_id == "S3_C_DreamNexus":
		return [
			"The Threadmaster pulls Lira back into the threads. Her scream fades into the hum of the Loom. The dream tightens, and the travelers forget they ever heard her voice.",
			"Somewhere in a quiet town, a serving girl pours ale with trembling hands. The chains beneath her skin pulse, and she cannot remember why she is crying.",
			"This journey may be over, but every great story deserves another telling.",
		]
	# Acts IV-V Path A (default): direct assault on the Threadmaster
	return [
		"The Loom holds. The threads tighten. The dream does not end.",
		"Somewhere in a quiet town, a kind face smiles and pours ale for the next weary traveler. She was never real, but no one will ever know.",
		"This journey may be over, but every great story deserves another telling.",
	]


static func _get_ending_text_story_1_path_b() -> Array[String]:
	return [
		"The Stranger crumbles quietly. No shattering glass, no dramatic burst of light. He simply falls, and the shadow falls with him.",
		"The sky clears slowly, like fog lifting from a lake. Not the triumphant dawn of a villain's defeat but the gradual return of something that was always there, waiting.",
		"The journal weighs heavy in a pocket. A scholar's handwriting, growing more frantic with every page. A man who believed he was saving the world, one sigil at a time, until the world became his enemy.",
		"People emerge from hiding. They do not cheer. They blink at the sky and hold each other and try to remember what normal felt like.",
		"The barkeep pours cups at The Copper Mug. He does not ask what happened below. Some questions are better left in the dark.",
		"The world will heal. The scars will remain. And somewhere in a collapsed tunnel beneath the city, a journal full of unanswered questions gathers dust.",
	]


static func get_ending_text_story_2(game_won: bool, battle_id: String = "") -> Array[String]:
	var is_path_b: bool = battle_id == "S2_B_EyeUnblinking"
	if game_won:
		if is_path_b:
			return _get_ending_text_story_2_path_b()
		return [
			"The Eye closes for the last time. The crystallized memories shatter, and light rises from the depths like a thousand lanterns set free.",
			"Across the coast, people stop mid-sentence. A name they forgot. A face they lost. A moment that was taken, returned without explanation.",
			"The old woman in the fishing village remembers the dinner. The blacksmith remembers why the sword was urgent. The barkeep remembers the conversations.",
			"Deep below, in the place where the Eye once watched, the party stands in silence. The machinery is dark. The crystals are empty.",
			"A voice, faint as breath, echoes through the chamber. Sera's voice, carried on the last of the light.",
			"'Thank you.'",
			"They carry her memory with them. Not because they have to. Because they choose to.",
		]
	else:
		return _get_defeat_text_story_2(battle_id)


static func _get_ending_text_story_2_path_b() -> Array[String]:
	return [
		"The Eye closes. The crystallized memories shatter, and light rises from the depths like a thousand lanterns set free.",
		"Across the coast, people stop mid-sentence. A name they forgot. A face they lost. A moment that was taken, returned without explanation.",
		"The old woman in the fishing village remembers the dinner. The blacksmith remembers why the sword was urgent. The barkeep remembers the conversations.",
		"Deep below, in the place where the Eye once watched, four people stand in silence. The machinery is dark. The crystals are empty. No voice echoes in the chamber. There is no ghost here. Just four living, breathing people.",
		"Sera stands in the sunlight for the first time in years. She squints. She has forgotten how bright the world can be.",
		"'I thought I would never see this again,' she says quietly. She touches her face, surprised to find it wet.",
		"Someone hands her a cup of water from a well. She drinks it and laughs, short and startled, surprised that something so simple can still feel good.",
		"She does not know what to do next. She has centuries of guilt to carry and a lifetime to figure out how. But she is alive, and that is more than she planned for.",
		"Four of them walked in. Four of them walk out.",
	]


static func get_ending_text_story_3(game_won: bool, battle_id: String) -> Array[String]:
	var is_path_b: bool = battle_id == "S3_B_DreamNexus"
	var is_path_c: bool = battle_id == "S3_C_DreamNexus"
	if game_won:
		if is_path_c:
			return _get_ending_text_story_3_path_c()
		if is_path_b:
			return _get_ending_text_story_3_path_b()
		return _get_ending_text_story_3_path_a()
	else:
		return _get_defeat_text_story_3(battle_id)


static func _get_ending_text_story_3_path_a() -> Array[String]:
	return [
		"The Loom is broken. The threads dissolve into the morning light, carrying with them every stolen dream, every pilfered night of rest.",
		"Across the town, people wake feeling something they cannot name. A lightness. A clarity. As if a weight they never knew they carried has been lifted.",
		"Where the innkeeper stood, there is nothing. No body, no trace. She was never real. Just another thread in the Loom, a familiar face woven from stolen dreams to lure the weary inside.",
		"The travelers stand in the street as the sun rises. For the first time in days, they are not tired. The weariness is gone, truly gone, and the road ahead feels possible again.",
		"'The Weary Traveler,' one of them reads aloud from the sign, shaking their head. 'She named the inn after what she was doing to people.'",
		"Lira watches from the doorway as they leave. Her hand rests on the doorframe, fingers tracing a pattern they cannot see.",
		"They leave the town behind. Their dreams that night are their own.",
	]


static func _get_ending_text_story_3_path_b() -> Array[String]:
	return [
		"The Loom is broken. Not by trust. By suspicion. By the courage to look at a kind face and ask what it was hiding.",
		"Across the town, people wake differently. Not gently. Sharply, like cold water. The fog lifts and what remains is a town that must learn what it is without the lie that sustained it.",
		"There is no serving girl to pour the morning ale. No innkeeper to smile and ask if they slept well. The woman behind every face this town has ever known is gone, unraveled with the threads she wove.",
		"Brother Callum stands in the town square as the sun rises. He does not look away from the questions.",
		"The travelers leave by midmorning. Their dreams that night are quiet, and empty, and entirely their own.",
	]


static func _get_ending_text_story_3_path_c() -> Array[String]:
	return [
		"The Loom is broken. Not by force. Not by suspicion. By the simplest thing in the world: one person asking another to tell the truth.",
		"Across the town, people wake lighter than they have in years. The fog lifts. The cult members stir and look at their hands as if seeing them for the first time.",
		"Lira stands in the doorway of the inn. She is not the innkeeper. She never was. But she pours the morning ale for those who want it, and this time, the smile is her own.",
		"She looks different in the daylight. The centuries of the Loom's weight have lifted, and what remains is a woman who has been fighting alone for a very long time and has finally, at last, stopped running.",
		"'I do not know what I am now,' she says. 'I have been the Threadmaster's prisoner for so long that I forgot what it felt like to just be a person.'",
		"One of the travelers sets a cup of ale in front of her. 'Start with breakfast,' they say. 'Figure the rest out later.'",
		"They leave the town by midmorning, truly rested. Their dreams that night are kind.",
	]


static func get_unlock_notification_lines(story_id: String) -> Array[String]:
	match story_id:
		"story_1":
			return [
				"",
				"New content unlocked!",
				"A new story awaits: \"Echoes in the Dark.\" Three strangers wake in a cave with no memory.",
				"A new class has emerged: the Wanderer. A wilderness fighter who learned to endure the land's magic.",
			]
		"story_2":
			return [
				"",
				"New content unlocked!",
				"A new story awaits: \"The Woven Night.\" Three travelers rest at a quiet inn. Their dreams are not their own.",
			]
		"story_3":
			return [
				"",
				"New content unlocked!",
				"You have completed all available stories. More adventures may follow.",
			]
		_:
			return []


static func get_demo_ending_text() -> Array[String]:
	return [
		"Thank you for playing the Parting Shadows demo!",
		"You have completed the first chapter of \"The Stranger's Shadow.\"",
		"The full game features three complete stories with branching paths, dozens of class upgrades, and mysteries to unravel.",
		"We hope you enjoyed the journey so far. The road ahead holds much more.",
		"Parting Shadows is available now on Steam.",
	]
