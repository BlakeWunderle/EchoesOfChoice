class_name BattleStageDBs2s3

## Battle stages and enemy factories for Story 2 and Story 3.

const EnemyDBS2 := preload("res://scripts/data/story2/enemy_db_s2.gd")
const EnemyDBS2Act2 := preload("res://scripts/data/story2/enemy_db_s2_act2.gd")
const EnemyDBS2Act3 := preload("res://scripts/data/story2/enemy_db_s2_act3.gd")
const EnemyDBS2Act4 := preload("res://scripts/data/story2/enemy_db_s2_act4.gd")
const EnemyDBS2PathB := preload("res://scripts/data/story2/enemy_db_s2_pathb.gd")
const EnemyDBS3 := preload("res://scripts/data/story3/enemy_db_s3.gd")
const EnemyDBS3Act2 := preload("res://scripts/data/story3/enemy_db_s3_act2.gd")
const EnemyDBS3Act3 := preload("res://scripts/data/story3/enemy_db_s3_act3.gd")
const EnemyDBS3Act45 := preload("res://scripts/data/story3/enemy_db_s3_act45.gd")
const EnemyDBS3PathB := preload("res://scripts/data/story3/enemy_db_s3_pathb.gd")
const EnemyDBS3PathC := preload("res://scripts/data/story3/enemy_db_s3_pathc.gd")


static func get_story2_stages() -> Array:
	return [
		# --- Story 2: Echoes in the Dark (85% -> 55%, -2pp/prog, breather at tier transitions) ---
		# Prog 0: Base classes, no level ups
		_s("S2_CaveAwakening", 0, "base", 0.85, 0, 2),
		# Prog 1: Base classes, 1 level up (branch pair)
		_s("S2_DeepCavern", 1, "base", 0.83, 1, 2),
		_s("S2_FungalHollow", 1, "base", 0.83, 1, 2),
		# Prog 2: Base classes, 2 level ups (branch pair)
		_s("S2_TranquilPool", 2, "base", 0.81, 2, 2),
		_s("S2_TorchChamber", 2, "base", 0.81, 2, 2),
		# Prog 3: Tier 1 (breather — same as P2)
		_s("S2_CaveExit", 4, "tier1", 0.81, 3, 2),
		# --- Story 2 Act II: The Shore ---
		# Prog 4: Tier 1, -2pp
		_s("S2_CoastalDescent", 5, "tier1", 0.79, 4, 2),
		# Prog 5: Tier 1, -2pp (branch pair)
		_s("S2_FishingVillage", 6, "tier1", 0.77, 5, 2),
		_s("S2_SmugglersBluff", 6, "tier1", 0.77, 5, 2),
		# Prog 6: Tier 2 (breather — same as P5, branch pair)
		_s("S2_WreckersCove", 8, "tier2", 0.77, 6, 2),
		_s("S2_CoastalRuins", 8, "tier2", 0.77, 6, 2),
		# Prog 7: Tier 2, -1pp (convergence)
		_s("S2_BlackwaterBay", 9, "tier2", 0.76, 7, 2),
		# Prog 8: Tier 2, -2pp (Act II boss)
		_s("S2_LighthouseStorm", 10, "tier2", 0.74, 8, 2),
		# --- Story 2 Act III: The Truth ---
		# Prog 9: Tier 2, -1pp
		_s("S2_BeneathTheLighthouse", 11, "tier2", 0.73, 9, 2),
		# Prog 10: Tier 2, -2pp (branch pair)
		_s("S2_MemoryVault", 12, "tier2", 0.71, 10, 2),
		_s("S2_EchoGallery", 12, "tier2", 0.71, 10, 2),
		# Prog 11: Tier 2, -1pp (convergence + reveal, 3 equipment upgrades)
		_s("S2_ShatteredSanctum", 13, "tier2", 0.70, 11, 2, "", 3),
		# Prog 12: Tier 2, -2pp (branch pair — Path A vs Path B)
		_s("S2_GuardiansThreshold", 14, "tier2", 0.68, 12, 2, "a", 3),
		_s("S2_ForgottenArchive", 14, "tier2", 0.68, 12, 2, "b", 3),
		# Prog 13: Tier 2, -1pp (Act III boss)
		_s("S2_TheReveal", 15, "tier2", 0.67, 13, 2, "a", 3),
		# --- Story 2 Act IV: The Reckoning (Path A continues) ---
		# Prog 14: Tier 2, -1pp
		_s("S2_DepthsOfRemembrance", 16, "tier2", 0.66, 14, 2, "a", 3),
		# Prog 15: Tier 2, -1pp
		_s("S2_MawOfTheEye", 17, "tier2", 0.65, 15, 2, "a", 3),
		# Prog 16: Tier 2, -2pp (Phase 1 boss)
		_s("S2_EyeAwakening", 18, "tier2", 0.63, 16, 2, "a", 3),
		# Prog 17: Tier 2, -1pp (final boss)
		_s("S2_EyeOfOblivion", 19, "tier2", 0.62, 17, 2, "a", 3),
		# --- Story 2 Path B: Save Sera (branches from ShatteredSanctum, same progs) ---
		_s("S2_B_ArchiveAwakening", 15, "tier2", 0.67, 13, 2, "b", 3),
		_s("S2_B_LighthouseCore", 16, "tier2", 0.66, 14, 2, "b", 3),
		_s("S2_B_ResonanceChamber", 17, "tier2", 0.65, 15, 2, "b", 3),
		_s("S2_B_MemoryFlood", 18, "tier2", 0.63, 16, 2, "b", 3),
		_s("S2_B_EyeUnblinking", 19, "tier2", 0.62, 17, 2, "b", 3),
	]


static func get_story3_stages() -> Array:
	return [
		# --- Story 3: The Woven Night (85% -> 62%, breather at tier transitions) ---
		# Prog 0: Base classes, no level ups (first dream)
		_s("S3_DreamMeadow", 0, "base", 0.85, 0, 3),
		# Prog 1: Base classes, 1 level up (branch pair)
		_s("S3_DreamMirrorHall", 1, "base", 0.83, 1, 3),
		_s("S3_DreamFogGarden", 1, "base", 0.83, 1, 3),
		# --- TownMorning: T0 -> T1 upgrade (implicit P2 drop to 81%, then breather) ---
		# Prog 3: Tier 1 (breather — same as implicit P2 = 81%)
		_s("S3_DreamReturn", 3, "tier1", 0.81, 3, 3),
		# Prog 4: Tier 1, -2pp
		_s("S3_DreamThreads", 4, "tier1", 0.79, 4, 3),
		# Prog 5: Tier 1, -2pp (branch pair)
		_s("S3_DreamDrownedCorridor", 5, "tier1", 0.77, 5, 3),
		_s("S3_DreamShatteredGallery", 5, "tier1", 0.77, 5, 3),
		# Prog 6: Tier 1, -2pp (shadow chase convergence)
		_s("S3_DreamShadowChase", 6, "tier1", 0.75, 6, 3),
		# Prog 7: Tier 1, -2pp (branch pair)
		_s("S3_DreamLabyrinth", 7, "tier1", 0.73, 7, 3),
		_s("S3_DreamClockTower", 7, "tier1", 0.73, 7, 3),
		# Prog 8: Tier 1, -2pp (Act II boss)
		_s("S3_DreamNightmare", 8, "tier1", 0.71, 8, 3),
		# --- TownInvestigation: T1 -> T2 upgrade ---
		# Prog 9: Tier 2 (breather — same as P8 = 71%)
		_s("S3_MarketConfrontation", 10, "tier2", 0.71, 9, 3),
		# Prog 10: Tier 2, -1pp (cellar discovery)
		_s("S3_CellarDiscovery", 11, "tier2", 0.70, 10, 3),
		# --- TownRealization: Lira reveal, rest only ---
		# Prog 11: Tier 2, -1pp (lucid dream — shared by Path A and C)
		_s("S3_LucidDream", 12, "tier2", 0.69, 11, 3, "ac"),
		# Prog 12: Tier 2, -1pp (branch pair — shared by Path A and C, 3 equipment upgrades)
		_s("S3_DreamTemple", 13, "tier2", 0.68, 12, 3, "ac", 3),
		_s("S3_DreamVoid", 13, "tier2", 0.68, 12, 3, "ac", 3),
		# Prog 13: Tier 2, -1pp (Act III boss — shared by Path A and C)
		_s("S3_DreamSanctum", 14, "tier2", 0.67, 13, 3, "ac", 3),
		# Prog 14: Tier 2, -1pp (cult investigation — Path A only, Path C diverges)
		_s("S3_CultUnderbelly", 15, "tier2", 0.66, 14, 3, "a", 3),
		# Prog 15: Tier 2, -1pp
		_s("S3_CultCatacombs", 16, "tier2", 0.65, 15, 3, "a", 3),
		# Prog 16: Tier 2, -2pp
		_s("S3_CultRitualChamber", 17, "tier2", 0.63, 16, 3, "a", 3),
		# Prog 17: Tier 2, -1pp (final boss)
		_s("S3_DreamNexus", 18, "tier2", 0.62, 17, 3, "a", 3),
		# --- Story 3 Path B: Suspicion route (branches at prog 11, same progs) ---
		_s("S3_B_InnSearch", 12, "tier2", 0.69, 11, 3, "b"),
		_s("S3_B_CultConfrontation", 13, "tier2", 0.68, 12, 3, "b", 3),
		_s("S3_B_TunnelBreach", 14, "tier2", 0.67, 13, 3, "b", 3),
		_s("S3_B_ThornesWard", 15, "tier2", 0.66, 14, 3, "b", 3),
		_s("S3_B_LoomHeart", 16, "tier2", 0.65, 15, 3, "b", 3),
		_s("S3_B_DreamInvasion", 17, "tier2", 0.63, 16, 3, "b", 3),
		_s("S3_B_DreamNexus", 18, "tier2", 0.62, 17, 3, "b", 3),
		# --- Story 3 Path C: Lira's confession route (branches at prog 14) ---
		_s("S3_C_DreamDescent", 15, "tier2", 0.66, 14, 3, "c", 3),
		_s("S3_C_CultInterception", 16, "tier2", 0.65, 15, 3, "c", 3),
		_s("S3_C_ThreadmasterLair", 17, "tier2", 0.63, 16, 3, "c", 3),
		_s("S3_C_DreamNexus", 18, "tier2", 0.62, 17, 3, "c", 3),
	]


static func _s(n: String, lu: int, tier: String, target: float,
		prog: int, story: int = 1, path: String = "",
		eu: int = -1) -> Dictionary:
	var equip_ups := eu
	if eu == -1:
		match tier:
			"base": equip_ups = 0
			"tier1": equip_ups = 1
			"tier2": equip_ups = 2
	return {
		"name": n, "level_ups": lu, "tier": tier,
		"target_win_rate": target, "progression_stage": prog,
		"story": story, "path": path, "equip_upgrades": equip_ups,
	}


# =============================================================================
# Enemy factories for Story 2 and Story 3
# =============================================================================

static func create_enemies(stage_name: String) -> Array:
	match stage_name:
		# Story 2
		"S2_CaveAwakening":
			return [EnemyDBS2.create_glow_worm("Luminara"),
				EnemyDBS2.create_glow_worm("Flicker"),
				EnemyDBS2.create_crystal_spider("Prism")]
		"S2_DeepCavern":
			return [EnemyDBS2.create_shade_crawler("Umbral"),
				EnemyDBS2.create_cavern_snapper("Ironjaw"),
				EnemyDBS2.create_echo_wisp("Resonance")]
		"S2_FungalHollow":
			return [EnemyDBS2.create_spore_stalker("Creeper"),
				EnemyDBS2.create_fungal_hulk("Mossback"),
				EnemyDBS2.create_cap_wisp("Drifter")]
		"S2_TranquilPool":
			return [EnemyDBS2.create_cave_eel("Voltfin"),
				EnemyDBS2.create_blind_angler("The Lure"),
				EnemyDBS2.create_silt_lurker("Ambush")]
		"S2_TorchChamber":
			return [EnemyDBS2.create_cave_dweller("Grimjaw"),
				EnemyDBS2.create_tunnel_shaman("Ember Eye"),
				EnemyDBS2.create_burrow_scout("Quickfoot")]
		"S2_CaveExit":
			return [EnemyDBS2.create_cave_maw("The Threshold", 5),
				EnemyDBS2.create_vein_leech("Gnawer", 5),
				EnemyDBS2.create_stone_moth("Dustwing", 5)]
		# Story 2 Act II
		"S2_CoastalDescent":
			return [EnemyDBS2Act2.create_blighted_gull("Blackwing"),
				EnemyDBS2Act2.create_shore_crawler("Ironshell"),
				EnemyDBS2Act2.create_warped_hound("Brine")]
		"S2_FishingVillage":
			return [EnemyDBS2Act2.create_driftwood_bandit("Scarhand"),
				EnemyDBS2Act2.create_driftwood_bandit("Rust"),
				EnemyDBS2Act2.create_tideside_channeler("Riptide")]
		"S2_SmugglersBluff":
			return [EnemyDBS2Act2.create_saltrunner_smuggler("Duskrunner"),
				EnemyDBS2Act2.create_tide_warden("Breakwater"),
				EnemyDBS2Act2.create_reef_shaman("Coralwhisper")]
		"S2_WreckersCove":
			return [EnemyDBS2Act2.create_blackwater_captain("Captain Korr"),
				EnemyDBS2Act2.create_corsair_hexer("Saltweave"),
				EnemyDBS2Act2.create_bilge_rat("Scuttle")]
		"S2_CoastalRuins":
			return [EnemyDBS2Act2.create_abyssal_lurker("Depthcrawl"),
				EnemyDBS2Act2.create_stormwrack_raptor("Voltwing"),
				EnemyDBS2Act2.create_blighted_gull("Shriek")]
		"S2_BlackwaterBay":
			return [EnemyDBS2Act2.create_drowned_sailor("The Drowned"),
				EnemyDBS2Act2.create_drowned_sailor("The Forgotten"),
				EnemyDBS2Act2.create_depth_horror("Undertow")]
		"S2_LighthouseStorm":
			return [EnemyDBS2Act2.create_tidecaller_revenant("The Keeper"),
				EnemyDBS2Act2.create_salt_phantom("The Watcher")]
		# Story 2 Act III
		"S2_BeneathTheLighthouse":
			return [EnemyDBS2Act3.create_fading_wisp("Glimmer"),
				EnemyDBS2Act3.create_fading_wisp("Shimmer"),
				EnemyDBS2Act3.create_dim_guardian("Resonance")]
		"S2_MemoryVault":
			return [EnemyDBS2Act3.create_thought_eater("Gnaw"),
				EnemyDBS2Act3.create_memory_wisp("Shimmer"),
				EnemyDBS2Act3.create_echo_sentinel("Vigil")]
		"S2_EchoGallery":
			return [EnemyDBS2Act3.create_hollow_watcher("Flicker"),
				EnemyDBS2Act3.create_grief_shade("Reverb"),
				EnemyDBS2Act3.create_shattered_frame("Whisper")]
		"S2_ShatteredSanctum":
			return [EnemyDBS2Act3.create_mirror_self("Reflection"),
				EnemyDBS2Act3.create_void_weaver("Unmaker"),
				EnemyDBS2Act3.create_sorrow_shade("Mourning")]
		"S2_GuardiansThreshold":
			return [EnemyDBS2Act3.create_ward_construct("Remembrance"),
				EnemyDBS2Act3.create_null_phantom("Erasure"),
				EnemyDBS2Act3.create_threshold_echo("Echo")]
		"S2_ForgottenArchive":
			return [EnemyDBS2Act3.create_ink_devourer("Blotch"),
				EnemyDBS2Act3.create_silent_archivist("Cataloger"),
				EnemyDBS2Act3.create_maw_codex("Gnawledge")]
		"S2_TheReveal":
			return [EnemyDBS2Act3.create_the_warden("The Warden"),
				EnemyDBS2Act3.create_fractured_protector("Sera")]
		# Story 2 Act IV
		"S2_DepthsOfRemembrance":
			return [EnemyDBS2Act4.create_gaze_stalker("Lidwatch"),
				EnemyDBS2Act4.create_pupil_leech("Gorger"),
				EnemyDBS2Act4.create_memory_harvester("The Gleaner")]
		"S2_MawOfTheEye":
			return [EnemyDBS2Act4.create_thoughtform_knight("Oathbound"),
				EnemyDBS2Act4.create_oblivion_shade("The Hollow"),
				EnemyDBS2Act4.create_memory_reaper("The Reaper")]
		"S2_EyeAwakening":
			return [EnemyDBS2Act4.create_the_iris("The Iris"),
				EnemyDBS2Act4.create_void_iris("Nullsight")]
		"S2_EyeOfOblivion":
			return [EnemyDBS2Act4.create_the_lidless_eye("The Lidless Eye")]
		# Story 2 Path B
		"S2_B_ArchiveAwakening":
			return [EnemyDBS2PathB.create_fractured_scholar("Sera"),
				EnemyDBS2PathB.create_archive_sentinel("Archivist")]
		"S2_B_LighthouseCore":
			return [EnemyDBS2PathB.create_pipeline_warden("Ironpipe"),
				EnemyDBS2PathB.create_maintenance_drone("Sparkfly"),
				EnemyDBS2PathB.create_resonance_node("Harmonic")]
		"S2_B_ResonanceChamber":
			return [EnemyDBS2PathB.create_eyes_fist("Crushing Gaze"),
				EnemyDBS2PathB.create_null_sentinel("Voidwatch"),
				EnemyDBS2PathB.create_overload_spark("Feedback")]
		"S2_B_MemoryFlood":
			return [EnemyDBS2PathB.create_memory_torrent("The Torrent"),
				EnemyDBS2PathB.create_unleashed_recollection("The Surge"),
				EnemyDBS2PathB.create_rage_fragment("The Shard")]
		"S2_B_EyeUnblinking":
			return [EnemyDBS2PathB.create_the_unblinking_eye("The Unblinking Eye"),
				EnemyDBS2PathB.create_perception_tendril("Perception Tendril"),
				EnemyDBS2PathB.create_void_lens("Void Lens")]
		# Story 3
		"S3_DreamMeadow":
			return [EnemyDBS3.create_dream_wisp("Glimmer"),
				EnemyDBS3.create_dream_wisp("Flicker"),
				EnemyDBS3.create_phantasm("The Unseen")]
		"S3_DreamMirrorHall":
			return [EnemyDBS3.create_mirror_shade("Reflected Self"),
				EnemyDBS3.create_sleep_stalker("Prowler"),
				EnemyDBS3.create_shade_moth("Duskwing")]
		"S3_DreamFogGarden":
			return [EnemyDBS3.create_fog_wraith("Pale Mist"),
				EnemyDBS3.create_thorn_dreamer("Brambleshade"),
				EnemyDBS3.create_slumber_beast("Drowsy Bear")]
		"S3_DreamReturn":
			return [EnemyDBS3.create_nightmare_hound("Gnasher"),
				EnemyDBS3.create_dream_weaver("Silken One"),
				EnemyDBS3.create_hollow_echo("Fading Voice")]
		# Story 3 Act II expansion
		"S3_DreamThreads":
			return [EnemyDBS3Act2.create_thread_lurker("Ceiling Crawler"),
				EnemyDBS3Act2.create_dream_sentinel("Still Guard"),
				EnemyDBS3Act2.create_gloom_spinner("Dark Weaver")]
		"S3_DreamDrownedCorridor":
			return [EnemyDBS3Act2.create_drowned_reverie("Lost Dreamer"),
				EnemyDBS3Act2.create_riptide_beast("Current Fang"),
				EnemyDBS3Act2.create_depth_crawler("Thread Dredger")]
		"S3_DreamShatteredGallery":
			return [EnemyDBS3Act2.create_fragment_golem("Dream Husk"),
				EnemyDBS3Act2.create_portrait_wight("Faded Dreamer"),
				EnemyDBS3Act2.create_gallery_shade("Frame Shadow")]
		"S3_DreamShadowChase":
			return [EnemyDBS3Act2.create_shadow_pursuer("The Hunter"),
				EnemyDBS3Act2.create_dread_tendril("Dark Arm"),
				EnemyDBS3Act2.create_faded_voice("Whisper")]
		"S3_MarketConfrontation":
			return [EnemyDBS3Act2.create_market_watcher("Shopkeeper Voss"),
				EnemyDBS3Act2.create_thread_smith("Smith Hagen"),
				EnemyDBS3Act2.create_hex_herbalist("Herbalist Wren")]
		"S3_CellarDiscovery":
			return [EnemyDBS3Act2.create_cellar_watcher("Bound Sentinel"),
				EnemyDBS3Act2.create_thread_construct("Woven Golem"),
				EnemyDBS3Act2.create_ink_shade("Cellar Shadow")]
		"S3_DreamLabyrinth":
			return [EnemyDBS3.create_twilight_stalker("Duskfang"),
				EnemyDBS3.create_waking_terror("Screamer"),
				EnemyDBS3.create_somnolent_serpent("Coilshadow")]
		"S3_DreamClockTower":
			return [EnemyDBS3.create_clock_specter("Frozen Hand"),
				EnemyDBS3.create_shattered_hourglass("Broken Glass"),
				EnemyDBS3.create_dusk_sentinel("Twilight Warden")]
		"S3_DreamNightmare":
			return [EnemyDBS3.create_the_nightmare("The Nightmare"),
				EnemyDBS3.create_nightmare_guard("Dread Sentinel"),
				EnemyDBS3.create_void_echo("Fading Cry")]
		"S3_LucidDream":
			return [EnemyDBS3Act3.create_lucid_phantom("Aware One"),
				EnemyDBS3Act3.create_thread_spinner("Spindle"),
				EnemyDBS3Act3.create_cult_shade("Dark Strand")]
		"S3_DreamTemple":
			return [EnemyDBS3Act3.create_dream_warden("Temple Guard"),
				EnemyDBS3Act3.create_thought_leech("Mind Eater"),
				EnemyDBS3Act3.create_loom_sentinel("Stone Thread")]
		"S3_DreamVoid":
			return [EnemyDBS3Act3.create_void_spinner("Thread Ripper"),
				EnemyDBS3Act3.create_void_phantom("Watcher"),
				EnemyDBS3Act3.create_rift_mender("Mender")]
		"S3_DreamSanctum":
			return [EnemyDBS3Act3.create_sanctum_guardian("Loom Guardian"),
				EnemyDBS3Act3.create_sanctum_shade("Shadow Weaver"),
				EnemyDBS3Act3.create_loom_warden("Core Defender")]
		"S3_CultUnderbelly":
			return [EnemyDBS3Act45.create_cult_acolyte("Brother Voss"),
				EnemyDBS3Act45.create_cult_enforcer("Sister Maren"),
				EnemyDBS3Act45.create_dread_tailor("Loom's Seamstress")]
		"S3_CultCatacombs":
			return [EnemyDBS3Act45.create_thread_guard("Loom Watcher"),
				EnemyDBS3Act45.create_dream_hound("Bound Hound"),
				EnemyDBS3Act45.create_thread_stitcher("Cult Mender")]
		"S3_CultRitualChamber":
			return [EnemyDBS3Act45.create_cult_ritualist("High Ritualist Thorne"),
				EnemyDBS3Act45.create_high_weaver("Weaver Aldric"),
				EnemyDBS3Act45.create_loom_crusher("The Loom's Fist")]
		"S3_DreamNexus":
			return [EnemyDBS3Act45.create_the_threadmaster("The Threadmaster"),
				EnemyDBS3Act45.create_shadow_fragment("Tattered Shadow"),
				EnemyDBS3Act45.create_shadow_fragment("Fraying Darkness")]
		# Story 3 Path B
		"S3_B_InnSearch":
			return [EnemyDBS3PathB.create_cellar_sentinel("Bound Sentinel"),
				EnemyDBS3PathB.create_bound_stalker("Chain Stalker"),
				EnemyDBS3PathB.create_bound_stalker("Ink Stalker")]
		"S3_B_CultConfrontation":
			return [EnemyDBS3PathB.create_thread_disciple("Disciple Venn"),
				EnemyDBS3PathB.create_thread_warden("Warden Thorne")]
		"S3_B_TunnelBreach":
			return [EnemyDBS3PathB.create_tunnel_sentinel("Tunnel Guard"),
				EnemyDBS3PathB.create_thread_sniper("Thread Sniper"),
				EnemyDBS3PathB.create_pale_devotee("Pale Acolyte")]
		"S3_B_ThornesWard":
			return [EnemyDBS3PathB.create_thread_ritualist("Ward Ritualist"),
				EnemyDBS3PathB.create_passage_guardian("Passage Ward"),
				EnemyDBS3PathB.create_warding_shadow("Dark Ward")]
		"S3_B_LoomHeart":
			return [EnemyDBS3PathB.create_shadow_innkeeper("The Innkeeper"),
				EnemyDBS3PathB.create_astral_weaver("Weaver Aldric"),
				EnemyDBS3PathB.create_loom_parasite("Thread Leech")]
		"S3_B_DreamInvasion":
			return [EnemyDBS3PathB.create_cathedral_warden("Loom Warden"),
				EnemyDBS3PathB.create_dream_binder("Thread Binder"),
				EnemyDBS3PathB.create_weft_stalker("The Weft Predator")]
		"S3_B_DreamNexus":
			return [EnemyDBS3PathB.create_lira_threadmaster("Lira, the Threadmaster"),
				EnemyDBS3PathB.create_tattered_deception("Tattered Deception"),
				EnemyDBS3PathB.create_dream_bastion("Dream Bastion")]
		# Story 3 Path C
		"S3_C_DreamDescent":
			return [EnemyDBS3PathC.create_abyssal_dreamer("Abyssal Dreamer"),
				EnemyDBS3PathC.create_thread_devourer("Thread Devourer"),
				EnemyDBS3PathC.create_slumbering_colossus("Slumbering Colossus")]
		"S3_C_CultInterception":
			return [EnemyDBS3PathC.create_dream_priest("High Priest Thorne"),
				EnemyDBS3PathC.create_astral_enforcer("Astral Blade"),
				EnemyDBS3PathC.create_oneiric_guardian("Dream Wall")]
		"S3_C_ThreadmasterLair":
			return [EnemyDBS3PathC.create_nightmare_sentinel("Nightmare Sentinel"),
				EnemyDBS3PathC.create_memory_eater("Memory Eater"),
				EnemyDBS3PathC.create_anchor_chain("Anchor Chain")]
		"S3_C_DreamNexus":
			return [EnemyDBS3PathC.create_ancient_threadmaster("The Ancient Threadmaster"),
				EnemyDBS3PathC.create_dream_shackle("Dream Shackle"),
				EnemyDBS3PathC.create_loom_heart("Loom Heart")]
		_:
			return []
