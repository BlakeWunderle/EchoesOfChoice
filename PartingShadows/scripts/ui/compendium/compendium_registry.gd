class_name CompendiumRegistry extends RefCounted

## Pure data registry for the compendium: class/enemy/battle ID lists,
## portrait path helpers, and story-from-battle-id lookup.

const _FighterDB := preload("res://scripts/data/fighter_db.gd")


## Get all class IDs (T0, T1, T2) for the compendium.
static func get_all_class_ids() -> Array:
	return [
		# T0
		"Squire", "Mage", "Entertainer", "Tinker", "Wildling", "Wanderer",
		# T1
		"Duelist", "Ranger", "MartialArtist",
		"Invoker", "Acolyte",
		"Bard", "Dervish", "Orator",
		"Artificer", "Philosopher", "Arithmancer",
		"Herbalist", "Shaman", "Beastcaller",
		"Sentinel", "Pathfinder",
		# T2 (complete list)
		"Cavalry", "Dragoon", "Mercenary", "Hunter", "Ninja", "Monk",
		"Infernalist", "Tidecaller", "Tempest", "Paladin", "Priest", "Warlock",
		"Warcrier", "Minstrel", "Illusionist", "Mime", "Laureate", "Elegist",
		"Alchemist", "Bombardier", "Chronomancer", "Astronomer", "Automaton", "Technomancer",
		"Blighter", "GroveKeeper", "WitchDoctor", "Spiritwalker", "Falconer", "Shapeshifter",
		"Bulwark", "Aegis", "Trailblazer", "Survivalist",
	]


## Get all enemy IDs with story assignment, in story/act progression order.
static func get_all_enemy_ids() -> Array:
	var s1 := "story_1"
	var s2 := "story_2"
	var s3 := "story_3"
	return [
		# Story 1 - Act I
		{"class_id": "Thug", "story_id": s1},
		{"class_id": "Ruffian", "story_id": s1},
		{"class_id": "Pickpocket", "story_id": s1},
		{"class_id": "Wolf", "story_id": s1},
		{"class_id": "Boar", "story_id": s1},
		{"class_id": "Thornviper", "story_id": s1},
		{"class_id": "Goblin", "story_id": s1},
		{"class_id": "Hound", "story_id": s1},
		{"class_id": "Bandit", "story_id": s1},
		# Story 1 - Act II
		{"class_id": "Raider", "story_id": s1},
		{"class_id": "Orc", "story_id": s1},
		{"class_id": "Troll", "story_id": s1},
		{"class_id": "Harpy", "story_id": s1},
		{"class_id": "Witch", "story_id": s1},
		{"class_id": "Wisp", "story_id": s1},
		{"class_id": "Treant", "story_id": s1},
		{"class_id": "Siren", "story_id": s1},
		{"class_id": "Merfolk", "story_id": s1},
		{"class_id": "Captain", "story_id": s1},
		{"class_id": "Pirate", "story_id": s1},
		{"class_id": "Fire Wyrmling", "story_id": s1},
		{"class_id": "Frost Wyrmling", "story_id": s1},
		{"class_id": "Ringmaster", "story_id": s1},
		{"class_id": "Harlequin", "story_id": s1},
		{"class_id": "Chanteuse", "story_id": s1},
		{"class_id": "Android", "story_id": s1},
		{"class_id": "Machinist", "story_id": s1},
		{"class_id": "Ironclad", "story_id": s1},
		{"class_id": "Commander", "story_id": s1},
		{"class_id": "Draconian", "story_id": s1},
		{"class_id": "Chaplain", "story_id": s1},
		{"class_id": "Zombie", "story_id": s1},
		{"class_id": "Ghoul", "story_id": s1},
		{"class_id": "Shade", "story_id": s1},
		{"class_id": "Wraith", "story_id": s1},
		# Story 1 - Acts III-V
		{"class_id": "Royal Guard", "story_id": s1},
		{"class_id": "Guard Sergeant", "story_id": s1},
		{"class_id": "Guard Archer", "story_id": s1},
		{"class_id": "Stranger", "story_id": s1},
		{"class_id": "StrangerFinal", "story_id": s1},
		{"class_id": "Lich", "story_id": s1},
		{"class_id": "Ghast", "story_id": s1},
		{"class_id": "Demon", "story_id": s1},
		{"class_id": "Corrupted Treant", "story_id": s1},
		{"class_id": "Hellion", "story_id": s1},
		{"class_id": "Fiendling", "story_id": s1},
		{"class_id": "Dragon", "story_id": s1},
		{"class_id": "Blighted Stag", "story_id": s1},
		{"class_id": "Dark Knight", "story_id": s1},
		{"class_id": "Fell Hound", "story_id": s1},
		{"class_id": "Sigil Wretch", "story_id": s1},
		{"class_id": "Tunnel Lurker", "story_id": s1},
		# Story 1 - Act V Path B
		{"class_id": "Sigil Colossus", "story_id": s1},
		{"class_id": "Ritual Conduit", "story_id": s1},
		{"class_id": "Void Sentinel", "story_id": s1},
		{"class_id": "Void Horror", "story_id": s1},
		{"class_id": "Fractured Shadow", "story_id": s1},
		{"class_id": "Shadow Remnant", "story_id": s1},
		{"class_id": "StrangerUndone", "story_id": s1},
		# Story 2 - Act I
		{"class_id": "Glow Worm", "story_id": s2},
		{"class_id": "Crystal Spider", "story_id": s2},
		{"class_id": "Shade Crawler", "story_id": s2},
		{"class_id": "Echo Wisp", "story_id": s2},
		{"class_id": "Spore Stalker", "story_id": s2},
		{"class_id": "Fungal Hulk", "story_id": s2},
		{"class_id": "Cap Wisp", "story_id": s2},
		{"class_id": "Cave Eel", "story_id": s2},
		{"class_id": "Blind Angler", "story_id": s2},
		{"class_id": "Cavern Snapper", "story_id": s2},
		{"class_id": "Silt Lurker", "story_id": s2},
		{"class_id": "Cave Dweller", "story_id": s2},
		{"class_id": "Tunnel Shaman", "story_id": s2},
		{"class_id": "Burrow Scout", "story_id": s2},
		{"class_id": "Cave Maw", "story_id": s2},
		{"class_id": "Vein Leech", "story_id": s2},
		{"class_id": "Stone Moth", "story_id": s2},
		# Story 2 - Act II
		{"class_id": "Driftwood Bandit", "story_id": s2},
		{"class_id": "Saltrunner Smuggler", "story_id": s2},
		{"class_id": "Tide Warden", "story_id": s2},
		{"class_id": "Blighted Gull", "story_id": s2},
		{"class_id": "Shore Crawler", "story_id": s2},
		{"class_id": "Warped Hound", "story_id": s2},
		{"class_id": "Blackwater Captain", "story_id": s2},
		{"class_id": "Corsair Hexer", "story_id": s2},
		{"class_id": "Abyssal Lurker", "story_id": s2},
		{"class_id": "Stormwrack Raptor", "story_id": s2},
		{"class_id": "Tidecaller Revenant", "story_id": s2},
		{"class_id": "Salt Phantom", "story_id": s2},
		{"class_id": "Drowned Sailor", "story_id": s2},
		{"class_id": "Depth Horror", "story_id": s2},
		# Story 2 - Act III
		{"class_id": "Memory Wisp", "story_id": s2},
		{"class_id": "Echo Sentinel", "story_id": s2},
		{"class_id": "Thought Eater", "story_id": s2},
		{"class_id": "Grief Shade", "story_id": s2},
		{"class_id": "Hollow Watcher", "story_id": s2},
		{"class_id": "Mirror Self", "story_id": s2},
		{"class_id": "Void Weaver", "story_id": s2},
		{"class_id": "Mnemonic Golem", "story_id": s2},
		{"class_id": "The Warden", "story_id": s2},
		{"class_id": "Fractured Protector", "story_id": s2},
		{"class_id": "Fading Wisp", "story_id": s2},
		{"class_id": "Dim Guardian", "story_id": s2},
		{"class_id": "Ward Construct", "story_id": s2},
		{"class_id": "Null Phantom", "story_id": s2},
		{"class_id": "Threshold Echo", "story_id": s2},
		{"class_id": "Ink Devourer", "story_id": s2},
		{"class_id": "Silent Archivist", "story_id": s2},
		{"class_id": "Lost Record", "story_id": s2},
		{"class_id": "Maw Codex", "story_id": s2},
		# Story 2 - Act IV
		{"class_id": "Pupil Leech", "story_id": s2},
		{"class_id": "Gaze Stalker", "story_id": s2},
		{"class_id": "Memory Harvester", "story_id": s2},
		{"class_id": "Oblivion Shade", "story_id": s2},
		{"class_id": "Thoughtform Knight", "story_id": s2},
		{"class_id": "The Iris", "story_id": s2},
		{"class_id": "The Lidless Eye", "story_id": s2},
		# Story 2 - Path B (Save Sera)
		{"class_id": "Fractured Scholar", "story_id": s2},
		{"class_id": "Archive Sentinel", "story_id": s2},
		{"class_id": "Pipeline Warden", "story_id": s2},
		{"class_id": "Maintenance Drone", "story_id": s2},
		{"class_id": "Resonance Node", "story_id": s2},
		{"class_id": "Eye's Fist", "story_id": s2},
		{"class_id": "Null Sentinel", "story_id": s2},
		{"class_id": "Overload Spark", "story_id": s2},
		{"class_id": "Memory Torrent", "story_id": s2},
		{"class_id": "Unleashed Recollection", "story_id": s2},
		{"class_id": "Rage Fragment", "story_id": s2},
		{"class_id": "The Unblinking Eye", "story_id": s2},
		# Story 3 - Acts I-II
		{"class_id": "Dream Wisp", "story_id": s3},
		{"class_id": "Phantasm", "story_id": s3},
		{"class_id": "Shade Moth", "story_id": s3},
		{"class_id": "Sleep Stalker", "story_id": s3},
		{"class_id": "Mirror Shade", "story_id": s3},
		{"class_id": "Slumber Beast", "story_id": s3},
		{"class_id": "Fog Wraith", "story_id": s3},
		{"class_id": "Thorn Dreamer", "story_id": s3},
		{"class_id": "Nightmare Hound", "story_id": s3},
		{"class_id": "Dream Weaver", "story_id": s3},
		{"class_id": "Hollow Echo", "story_id": s3},
		{"class_id": "Somnolent Serpent", "story_id": s3},
		{"class_id": "Twilight Stalker", "story_id": s3},
		{"class_id": "Waking Terror", "story_id": s3},
		{"class_id": "Dusk Sentinel", "story_id": s3},
		{"class_id": "Clock Specter", "story_id": s3},
		{"class_id": "The Nightmare", "story_id": s3},
		{"class_id": "Nightmare Guard", "story_id": s3},
		{"class_id": "Void Echo", "story_id": s3},
		{"class_id": "Shattered Hourglass", "story_id": s3},
		# Story 3 - Act II expansion
		{"class_id": "Thread Lurker", "story_id": s3},
		{"class_id": "Dream Sentinel", "story_id": s3},
		{"class_id": "Gloom Spinner", "story_id": s3},
		{"class_id": "Drowned Reverie", "story_id": s3},
		{"class_id": "Riptide Beast", "story_id": s3},
		{"class_id": "Depth Crawler", "story_id": s3},
		{"class_id": "Fragment Golem", "story_id": s3},
		{"class_id": "Portrait Wight", "story_id": s3},
		{"class_id": "Gallery Shade", "story_id": s3},
		{"class_id": "Shadow Pursuer", "story_id": s3},
		{"class_id": "Dread Tendril", "story_id": s3},
		{"class_id": "Faded Voice", "story_id": s3},
		{"class_id": "Market Watcher", "story_id": s3},
		{"class_id": "Thread Smith", "story_id": s3},
		{"class_id": "Hex Herbalist", "story_id": s3},
		{"class_id": "Cellar Watcher", "story_id": s3},
		{"class_id": "Thread Construct", "story_id": s3},
		{"class_id": "Ink Shade", "story_id": s3},
		# Story 3 - Act III
		{"class_id": "Lucid Phantom", "story_id": s3},
		{"class_id": "Thread Spinner", "story_id": s3},
		{"class_id": "Loom Sentinel", "story_id": s3},
		{"class_id": "Cult Shade", "story_id": s3},
		{"class_id": "Dream Warden", "story_id": s3},
		{"class_id": "Thought Leech", "story_id": s3},
		{"class_id": "Void Spinner", "story_id": s3},
		{"class_id": "Sanctum Guardian", "story_id": s3},
		# Story 3 - Acts IV-V
		{"class_id": "Cult Acolyte", "story_id": s3},
		{"class_id": "Cult Enforcer", "story_id": s3},
		{"class_id": "Cult Hexer", "story_id": s3},
		{"class_id": "Thread Guard", "story_id": s3},
		{"class_id": "Dream Hound", "story_id": s3},
		{"class_id": "Cult Ritualist", "story_id": s3},
		{"class_id": "High Weaver", "story_id": s3},
		{"class_id": "Shadow Fragment", "story_id": s3},
		{"class_id": "The Threadmaster", "story_id": s3},
		# Story 3 - Path B
		{"class_id": "Cellar Sentinel", "story_id": s3},
		{"class_id": "Bound Stalker", "story_id": s3},
		{"class_id": "Thread Disciple", "story_id": s3},
		{"class_id": "Thread Warden", "story_id": s3},
		{"class_id": "Tunnel Sentinel", "story_id": s3},
		{"class_id": "Thread Sniper", "story_id": s3},
		{"class_id": "Pale Devotee", "story_id": s3},
		{"class_id": "Thread Ritualist", "story_id": s3},
		{"class_id": "Passage Guardian", "story_id": s3},
		{"class_id": "Warding Shadow", "story_id": s3},
		{"class_id": "Shadow Innkeeper", "story_id": s3},
		{"class_id": "Astral Weaver", "story_id": s3},
		{"class_id": "Loom Tendril", "story_id": s3},
		{"class_id": "Cathedral Warden", "story_id": s3},
		{"class_id": "Dream Binder", "story_id": s3},
		{"class_id": "Thread Anchor", "story_id": s3},
		{"class_id": "Lira, the Threadmaster", "story_id": s3},
		{"class_id": "Tattered Deception", "story_id": s3},
		{"class_id": "Dream Bastion", "story_id": s3},
		# Story 3 - Path C
		{"class_id": "Abyssal Dreamer", "story_id": s3},
		{"class_id": "Thread Devourer", "story_id": s3},
		{"class_id": "Slumbering Colossus", "story_id": s3},
		{"class_id": "Dream Priest", "story_id": s3},
		{"class_id": "Astral Enforcer", "story_id": s3},
		{"class_id": "Oneiric Hexer", "story_id": s3},
		{"class_id": "Memory Eater", "story_id": s3},
		{"class_id": "Nightmare Sentinel", "story_id": s3},
		{"class_id": "Anchor Chain", "story_id": s3},
		{"class_id": "The Ancient Threadmaster", "story_id": s3},
		{"class_id": "Dream Shackle", "story_id": s3},
		{"class_id": "Loom Heart", "story_id": s3},
	]


## Get all battle IDs in story/act progression order.
static func get_all_battle_ids() -> Array:
	return [
		# Story 1 - Act I
		"CityStreetBattle", "WolfForestBattle", "WaypointDefenseBattle",
		# Story 1 - Act II
		"HighlandBattle", "DeepForestBattle", "ShoreBattle", "MountainPassBattle",
		"CaveBattle", "BeachBattle", "WildernessOutpost", "CircusBattle",
		"LabBattle", "ArmyBattle", "CemeteryBattle", "OutpostDefenseBattle", "MirrorBattle",
		# Story 1 - Act III
		"ReturnToCityStreetBattle", "StrangerTowerBattle",
		# Story 1 - Acts IV-V
		"CorruptedCityBattle", "CorruptedWildsBattle",
		"DepthsBattle", "GateBattle", "StrangerFinalBattle",
		# Story 1 - Act V Path B
		"RitualAnchorBattle", "SanctumCollapseBattle", "StrangerUndoneBattle",
		# Story 2 - Act I
		"S2_CaveAwakening", "S2_DeepCavern", "S2_FungalHollow",
		"S2_TranquilPool", "S2_TorchChamber", "S2_CaveExit",
		# Story 2 - Act II
		"S2_CoastalDescent", "S2_FishingVillage", "S2_SmugglersBluff",
		"S2_WreckersCove", "S2_CoastalRuins",
		"S2_BlackwaterBay", "S2_LighthouseStorm",
		# Story 2 - Act III
		"S2_BeneathTheLighthouse", "S2_MemoryVault", "S2_EchoGallery",
		"S2_ShatteredSanctum", "S2_GuardiansThreshold",
		"S2_ForgottenArchive", "S2_TheReveal",
		# Story 2 - Act IV
		"S2_DepthsOfRemembrance", "S2_MawOfTheEye",
		"S2_EyeAwakening", "S2_EyeOfOblivion",
		# Story 2 - Path B (Save Sera)
		"S2_B_ArchiveAwakening", "S2_B_LighthouseCore",
		"S2_B_ResonanceChamber", "S2_B_MemoryFlood", "S2_B_EyeUnblinking",
		# Story 3 - Acts I-II
		"S3_DreamMeadow", "S3_DreamMirrorHall",
		"S3_DreamFogGarden", "S3_DreamReturn",
		"S3_DreamLabyrinth", "S3_DreamClockTower", "S3_DreamNightmare",
		# Story 3 - Act II expansion
		"S3_DreamThreads", "S3_DreamDrownedCorridor",
		"S3_DreamShatteredGallery", "S3_DreamShadowChase",
		"S3_MarketConfrontation", "S3_CellarDiscovery",
		# Story 3 - Act III
		"S3_LucidDream", "S3_DreamTemple",
		"S3_DreamVoid", "S3_DreamSanctum",
		# Story 3 - Acts IV-V
		"S3_CultUnderbelly", "S3_CultCatacombs",
		"S3_CultRitualChamber", "S3_DreamNexus",
		# Story 3 - Path B
		"S3_B_InnSearch", "S3_B_CultConfrontation",
		"S3_B_TunnelBreach", "S3_B_ThornesWard", "S3_B_LoomHeart",
		"S3_B_DreamInvasion", "S3_B_DreamNexus",
		# Story 3 - Path C
		"S3_C_DreamDescent",
		"S3_C_CultInterception", "S3_C_ThreadmasterLair", "S3_C_DreamNexus",
	]


## Get a portrait path for a player class (seeded-random M or F variant).
static func get_class_portrait_path(class_id: String) -> String:
	var key: String = to_portrait_key(_FighterDB.get_display_name(class_id))
	var suffix: String = "_f" if class_id.hash() % 2 == 0 else "_m"
	return "res://assets/art/portraits/classes/%s%s.png" % [key, suffix]


## Get both portrait paths (M and F) for a player class.
static func get_class_portrait_paths(class_id: String) -> Dictionary:
	var key: String = to_portrait_key(_FighterDB.get_display_name(class_id))
	return {
		"m": "res://assets/art/portraits/classes/%s_m.png" % key,
		"f": "res://assets/art/portraits/classes/%s_f.png" % key,
	}


## Get a portrait path for an enemy.
static func get_enemy_portrait_path(class_id: String) -> String:
	return "res://assets/art/portraits/enemies/%s.png" % to_portrait_key(class_id)


## Convert a name to a portrait filename key (snake_case, no punctuation).
## "Fire Wyrmling" -> "fire_wyrmling", "StrangerFinal" -> "stranger_final",
## "Lira, the Threadmaster" -> "lira_the_threadmaster"
static func to_portrait_key(name_str: String) -> String:
	var clean := name_str.replace(",", "").replace("'", "")
	# Insert space before uppercase letters in PascalCase words
	var spaced := ""
	for i in clean.length():
		var c := clean[i]
		if i > 0 and c >= "A" and c <= "Z" and clean[i - 1] != " ":
			spaced += " "
		spaced += c
	return spaced.to_lower().strip_edges().replace("  ", " ").replace(" ", "_")


## Guess which story a battle belongs to from its ID prefix.
static func guess_story_from_battle_id(battle_id: String) -> String:
	if battle_id.begins_with("S2_"):
		return "story_2"
	elif battle_id.begins_with("S3_"):
		return "story_3"
	return "story_1"
