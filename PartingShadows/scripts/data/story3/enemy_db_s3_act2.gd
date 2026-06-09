class_name EnemyDBS3Act2

## Story 3 expanded Act II + waking investigation enemies.
## 9 dream entities (Progs 4-6) + 6 waking cult/cellar enemies (Progs 9-10).

const FighterData := preload("res://scripts/data/fighter_data.gd")
const EAB := preload("res://scripts/data/story3/enemy_ability_db_s3_act2.gd")
const EH := preload("res://scripts/data/enemy_helpers.gd")


# =============================================================================
# Prog 4: Thread-visible dream entities (S3_DreamThreads)
# =============================================================================

static func create_thread_lurker(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Thread Lurker", lvl)
	f.health = EH.es(95, 112, 3, 5, lvl, 5); f.max_health = f.health
	f.mana = EH.es(5, 7, 1, 1, lvl, 5); f.max_mana = f.mana
	f.physical_attack = EH.es(32, 36, 1, 3, lvl, 5)
	f.physical_defense = EH.es(13, 16, 1, 2, lvl, 5)
	f.magic_attack = EH.es(11, 14, 0, 2, lvl, 5)
	f.magic_defense = EH.es(12, 15, 1, 2, lvl, 5)
	f.speed = EH.es(31, 36, 1, 3, lvl, 5)
	f.crit_chance = 20; f.crit_damage = 2; f.dodge_chance = 12
	f.abilities = [EAB.thread_ambush(), EAB.web_snare()]
	f.flavor_text = "A spindly predator that clings to the threads woven through the dream. It waits in stillness until prey draws near, then strikes from the tangled weave."
	return f


static func create_dream_sentinel(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Dream Sentinel", lvl)
	f.health = EH.es(108, 128, 3, 6, lvl, 5); f.max_health = f.health
	f.mana = EH.es(5, 8, 1, 1, lvl, 5); f.max_mana = f.mana
	f.physical_attack = EH.es(30, 34, 1, 2, lvl, 5)
	f.physical_defense = EH.es(18, 22, 1, 3, lvl, 5)
	f.magic_attack = EH.es(12, 15, 0, 2, lvl, 5)
	f.magic_defense = EH.es(13, 16, 1, 2, lvl, 5)
	f.speed = EH.es(24, 29, 1, 2, lvl, 5)
	f.crit_chance = 16; f.crit_damage = 1; f.dodge_chance = 15
	f.abilities = [EAB.sentinel_strike(), EAB.woven_guard()]
	f.flavor_text = "A towering guardian woven from layered dream-thread. It was placed here by the cult to keep the deeper passages sealed against intruders."
	return f


static func create_gloom_spinner(n: String, lvl: int = 5) -> FighterData:
	var f := EH.base(n, "Gloom Spinner", lvl)
	f.health = EH.es(90, 106, 3, 5, lvl, 5); f.max_health = f.health
	f.mana = EH.es(8, 11, 1, 2, lvl, 5); f.max_mana = f.mana
	f.physical_attack = EH.es(11, 14, 0, 2, lvl, 5)
	f.physical_defense = EH.es(8, 11, 1, 2, lvl, 5)
	f.magic_attack = EH.es(30, 36, 1, 3, lvl, 5)
	f.magic_defense = EH.es(16, 19, 1, 2, lvl, 5)
	f.speed = EH.es(27, 32, 1, 2, lvl, 5)
	f.crit_chance = 15; f.crit_damage = 1; f.dodge_chance = 14
	f.abilities = [EAB.shadow_thread(), EAB.gloom_web()]
	f.flavor_text = "A caster that draws darkness from the dream's frayed edges and spins it into sticky webs of gloom. Anything caught in its threads loses the will to fight."
	return f


# =============================================================================
# Prog 5: Drowned Corridor enemies (S3_DreamDrownedCorridor)
# =============================================================================

static func create_drowned_reverie(n: String, lvl: int = 6) -> FighterData:
	var f := EH.base(n, "Drowned Reverie", lvl)
	f.health = EH.es(152, 177, 3, 6, lvl, 6); f.max_health = f.health
	f.mana = EH.es(9, 11, 1, 2, lvl, 6); f.max_mana = f.mana
	f.physical_attack = EH.es(12, 15, 0, 2, lvl, 6)
	f.physical_defense = EH.es(10, 13, 1, 2, lvl, 6)
	f.magic_attack = EH.es(32, 36, 1, 3, lvl, 6)
	f.magic_defense = EH.es(17, 20, 1, 2, lvl, 6)
	f.speed = EH.es(28, 33, 1, 2, lvl, 6)
	f.crit_chance = 14; f.crit_damage = 1; f.dodge_chance = 12
	f.abilities = [EAB.memory_surge(), EAB.deep_pulse()]
	f.flavor_text = "A spectral figure that drifts through flooded corridors, trailing memories like bubbles. It unleashes surges of recalled emotion that overwhelm the mind."
	return f


static func create_riptide_beast(n: String, lvl: int = 6) -> FighterData:
	var f := EH.base(n, "Riptide Beast", lvl)
	f.health = EH.es(154, 179, 3, 6, lvl, 6); f.max_health = f.health
	f.mana = EH.es(5, 7, 1, 1, lvl, 6); f.max_mana = f.mana
	f.physical_attack = EH.es(32, 36, 1, 3, lvl, 6)
	f.physical_defense = EH.es(16, 19, 1, 2, lvl, 6)
	f.magic_attack = EH.es(11, 14, 0, 2, lvl, 6)
	f.magic_defense = EH.es(10, 13, 1, 2, lvl, 6)
	f.speed = EH.es(31, 36, 1, 3, lvl, 6)
	f.crit_chance = 18; f.crit_damage = 2; f.dodge_chance = 13
	f.abilities = [EAB.riptide_slash(), EAB.swift_current()]
	f.flavor_text = "A ferocious aquatic predator that surges through dream-water with blinding speed. Its claws carry the force of a riptide, dragging victims under."
	return f


static func create_depth_crawler(n: String, lvl: int = 6) -> FighterData:
	var f := EH.base(n, "Depth Crawler", lvl)
	f.health = EH.es(166, 190, 3, 6, lvl, 6); f.max_health = f.health
	f.mana = EH.es(6, 8, 1, 1, lvl, 6); f.max_mana = f.mana
	f.physical_attack = EH.es(28, 32, 1, 3, lvl, 6)
	f.physical_defense = EH.es(16, 19, 1, 2, lvl, 6)
	f.magic_attack = EH.es(22, 26, 1, 2, lvl, 6)
	f.magic_defense = EH.es(14, 17, 1, 2, lvl, 6)
	f.speed = EH.es(24, 29, 1, 2, lvl, 6)
	f.crit_chance = 14; f.crit_damage = 1; f.dodge_chance = 11
	f.abilities = [EAB.thread_burn(), EAB.latch()]
	f.flavor_text = "A many-legged thing that scuttles through the drowned depths, burning through dream-threads with caustic secretions. Once it latches on, it does not let go."
	return f


# =============================================================================
# Prog 5: Shattered Gallery enemies (S3_DreamShatteredGallery)
# =============================================================================

static func create_fragment_golem(n: String, lvl: int = 6) -> FighterData:
	var f := EH.base(n, "Fragment Golem", lvl)
	f.health = EH.es(150, 175, 3, 6, lvl, 6); f.max_health = f.health
	f.mana = EH.es(4, 6, 1, 1, lvl, 6); f.max_mana = f.mana
	f.physical_attack = EH.es(33, 37, 1, 3, lvl, 6)
	f.physical_defense = EH.es(18, 22, 1, 3, lvl, 6)
	f.magic_attack = EH.es(10, 13, 0, 1, lvl, 6)
	f.magic_defense = EH.es(13, 17, 1, 2, lvl, 6)
	f.speed = EH.es(23, 28, 1, 2, lvl, 6)
	f.crit_chance = 16; f.crit_damage = 2; f.dodge_chance = 11
	f.abilities = [EAB.dream_crush(), EAB.fragment_surge()]
	f.flavor_text = "A hulking construct assembled from shattered dream-fragments. Each piece remembers a different sleeper, and the golem fights with their collective, fractured will."
	return f


static func create_portrait_wight(n: String, lvl: int = 6) -> FighterData:
	var f := EH.base(n, "Portrait Wight", lvl)
	f.health = EH.es(130, 152, 3, 5, lvl, 6); f.max_health = f.health
	f.mana = EH.es(10, 13, 1, 2, lvl, 6); f.max_mana = f.mana
	f.physical_attack = EH.es(11, 14, 0, 1, lvl, 6)
	f.physical_defense = EH.es(13, 16, 1, 2, lvl, 6)
	f.magic_attack = EH.es(30, 34, 1, 3, lvl, 6)
	f.magic_defense = EH.es(16, 20, 1, 3, lvl, 6)
	f.speed = EH.es(26, 31, 1, 2, lvl, 6)
	f.crit_chance = 11; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.gilded_veil(), EAB.faded_gaze()]
	f.flavor_text = "The undead remnant of a dreamer who died in their sleep, now trapped inside a gilded portrait frame. It reaches through cracked canvas to shield the gallery's other creatures, guarding the stolen memories it can no longer reclaim."
	return f


static func create_gallery_shade(n: String, lvl: int = 6) -> FighterData:
	var f := EH.base(n, "Gallery Shade", lvl)
	f.health = EH.es(130, 150, 3, 5, lvl, 6); f.max_health = f.health
	f.mana = EH.es(8, 11, 1, 2, lvl, 6); f.max_mana = f.mana
	f.physical_attack = EH.es(35, 39, 1, 3, lvl, 6)
	f.physical_defense = EH.es(15, 18, 1, 2, lvl, 6)
	f.magic_attack = EH.es(13, 16, 0, 2, lvl, 6)
	f.magic_defense = EH.es(12, 15, 1, 2, lvl, 6)
	f.speed = EH.es(30, 35, 1, 3, lvl, 6)
	f.crit_chance = 18; f.crit_damage = 2; f.dodge_chance = 13
	f.abilities = [EAB.gallery_bolt(), EAB.shatter_ward()]
	f.flavor_text = "A dark silhouette that steps out of painted portraits in the shattered gallery. It hurls splinters of broken frames and conjures wards from cracked canvas."
	return f


# =============================================================================
# Prog 6: Shadow Chase convergence (S3_DreamShadowChase)
# =============================================================================

static func create_shadow_pursuer(n: String, lvl: int = 7) -> FighterData:
	var f := EH.base(n, "Shadow Pursuer", lvl)
	f.health = EH.es(200, 235, 3, 7, lvl, 7); f.max_health = f.health
	f.mana = EH.es(5, 8, 1, 1, lvl, 7); f.max_mana = f.mana
	f.physical_attack = EH.es(37, 42, 1, 3, lvl, 7)
	f.physical_defense = EH.es(15, 18, 1, 2, lvl, 7)
	f.magic_attack = EH.es(13, 16, 0, 2, lvl, 7)
	f.magic_defense = EH.es(14, 17, 1, 2, lvl, 7)
	f.speed = EH.es(34, 39, 1, 3, lvl, 7)
	f.crit_chance = 22; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EAB.phantom_strike(), EAB.shadow_shroud(), EAB.dream_terror(), EAB.nightmare_lunge(), EAB.fading_grasp()]
	f.flavor_text = "A relentless shadow that gives chase through the dream's winding corridors. It strikes from angles that should not exist and vanishes before you can react."
	return f


static func create_dread_tendril(n: String, lvl: int = 7) -> FighterData:
	var f := EH.base(n, "Dread Tendril", lvl)
	f.health = EH.es(175, 205, 3, 6, lvl, 7); f.max_health = f.health
	f.mana = EH.es(10, 13, 1, 2, lvl, 7); f.max_mana = f.mana
	f.physical_attack = EH.es(13, 16, 0, 2, lvl, 7)
	f.physical_defense = EH.es(11, 14, 1, 2, lvl, 7)
	f.magic_attack = EH.es(33, 38, 1, 3, lvl, 7)
	f.magic_defense = EH.es(19, 22, 1, 2, lvl, 7)
	f.speed = EH.es(29, 34, 1, 2, lvl, 7)
	f.crit_chance = 21; f.crit_damage = 1; f.dodge_chance = 15
	f.abilities = [EAB.constrict(), EAB.dread_lash(), EAB.thrash()]
	f.flavor_text = "A writhing appendage of pure dread that reaches from the cracks in the dream. It binds the whole party in place while its companion closes in for the kill."
	return f


static func create_faded_voice(n: String, lvl: int = 7) -> FighterData:
	var f := EH.base(n, "Faded Voice", lvl)
	f.health = EH.es(170, 200, 3, 5, lvl, 7); f.max_health = f.health
	f.mana = EH.es(9, 11, 1, 2, lvl, 7); f.max_mana = f.mana
	f.physical_attack = EH.es(28, 33, 1, 3, lvl, 7)
	f.physical_defense = EH.es(10, 13, 1, 2, lvl, 7)
	f.magic_attack = EH.es(15, 18, 0, 2, lvl, 7)
	f.magic_defense = EH.es(18, 21, 1, 2, lvl, 7)
	f.speed = EH.es(30, 35, 1, 2, lvl, 7)
	f.crit_chance = 21; f.crit_damage = 1; f.dodge_chance = 18
	f.abilities = [EAB.echoed_cry(), EAB.fade()]
	f.flavor_text = "The remnant of a voice that once belonged to a real person, now stripped of meaning and body. It cries out in fragments, and each echo saps the strength of those who hear it."
	return f


# =============================================================================
# Prog 9: Waking market confrontation (S3_MarketConfrontation)
# Target 58%, 10 level-ups. Calibrated against S2 P9 reference.
# =============================================================================

static func create_market_watcher(n: String, lvl: int = 10) -> FighterData:
	var f := EH.base(n, "Market Watcher", lvl)
	f.health = EH.es(350, 403, 4, 7, lvl, 10); f.max_health = f.health
	f.mana = EH.es(28, 34, 2, 3, lvl, 10); f.max_mana = f.mana
	f.physical_attack = EH.es(77, 88, 2, 4, lvl, 10)
	f.physical_defense = EH.es(41, 48, 2, 3, lvl, 10)
	f.magic_attack = EH.es(20, 24, 0, 2, lvl, 10)
	f.magic_defense = EH.es(24, 32, 1, 3, lvl, 10)
	f.speed = EH.es(29, 35, 2, 3, lvl, 10)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EAB.hidden_blade(), EAB.merchant_guard()]
	f.flavor_text = "A keen-eyed operative disguised among the market crowd. Behind a merchant's pleasant smile hides a blade and the Thread cult's unwavering loyalty."
	return f


static func create_thread_smith(n: String, lvl: int = 10) -> FighterData:
	var f := EH.base(n, "Thread Smith", lvl)
	f.health = EH.es(413, 475, 5, 8, lvl, 10); f.max_health = f.health
	f.mana = EH.es(28, 34, 2, 3, lvl, 10); f.max_mana = f.mana
	f.physical_attack = EH.es(71, 82, 2, 4, lvl, 10)
	f.physical_defense = EH.es(26, 33, 2, 3, lvl, 10)
	f.magic_attack = EH.es(18, 22, 0, 1, lvl, 10)
	f.magic_defense = EH.es(34, 41, 1, 3, lvl, 10)
	f.speed = EH.es(25, 31, 2, 3, lvl, 10)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.hammer_blow(), EAB.forge_hardened()]
	f.flavor_text = "A burly artisan who hammers dream-threads into weapons and armor for the cult. Years at the forge have tempered both body and resolve into unyielding steel."
	return f


static func create_hex_herbalist(n: String, lvl: int = 10) -> FighterData:
	var f := EH.base(n, "Hex Herbalist", lvl)
	f.health = EH.es(278, 326, 4, 7, lvl, 10); f.max_health = f.health
	f.mana = EH.es(32, 38, 2, 3, lvl, 10); f.max_mana = f.mana
	f.physical_attack = EH.es(20, 24, 0, 2, lvl, 10)
	f.physical_defense = EH.es(19, 25, 1, 3, lvl, 10)
	f.magic_attack = EH.es(70, 78, 2, 4, lvl, 10)
	f.magic_defense = EH.es(34, 41, 2, 3, lvl, 10)
	f.speed = EH.es(28, 34, 2, 3, lvl, 10)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EAB.tainted_salve(), EAB.numbing_dust()]
	f.flavor_text = "A healer whose remedies conceal darker purposes. The herbs she grows are laced with thread-essence, and her salves cloud the mind as often as they mend the body."
	return f


# =============================================================================
# Prog 10: Cellar discovery (S3_CellarDiscovery)
# Target 56%, 11 level-ups.
# =============================================================================

static func create_cellar_watcher(n: String, lvl: int = 11) -> FighterData:
	var f := EH.base(n, "Cellar Watcher", lvl)
	f.health = EH.es(347, 399, 4, 7, lvl, 11); f.max_health = f.health
	f.mana = EH.es(30, 36, 2, 3, lvl, 11); f.max_mana = f.mana
	f.physical_attack = EH.es(73, 82, 2, 4, lvl, 11)
	f.physical_defense = EH.es(32, 39, 2, 3, lvl, 11)
	f.magic_attack = EH.es(69, 79, 2, 4, lvl, 11)
	f.magic_defense = EH.es(29, 37, 1, 3, lvl, 11)
	f.speed = EH.es(32, 38, 2, 3, lvl, 11)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 17
	f.abilities = [EAB.bound_strike(), EAB.tether_pull()]
	f.flavor_text = "A guard stationed in the cellar beneath the inn, bound to the cult's hidden operations. It fights with the desperate fury of someone protecting a terrible secret."
	return f


static func create_thread_construct(n: String, lvl: int = 11) -> FighterData:
	var f := EH.base(n, "Thread Construct", lvl)
	f.health = EH.es(407, 466, 5, 8, lvl, 11); f.max_health = f.health
	f.mana = EH.es(30, 39, 3, 4, lvl, 11); f.max_mana = f.mana
	f.physical_attack = EH.es(78, 91, 2, 4, lvl, 11)
	f.physical_defense = EH.es(37, 43, 2, 3, lvl, 11)
	f.magic_attack = EH.es(18, 22, 0, 1, lvl, 11)
	f.magic_defense = EH.es(23, 29, 1, 3, lvl, 11)
	f.speed = EH.es(24, 30, 1, 2, lvl, 11)
	f.crit_chance = 10; f.crit_damage = 2; f.dodge_chance = 10
	f.abilities = [EAB.woven_fist(), EAB.reinforced_threads()]
	f.flavor_text = "A humanoid frame assembled entirely from braided dream-threads. It moves with mechanical precision, reinforcing itself with fresh strands torn from the surrounding weave."
	return f


static func create_ink_shade(n: String, lvl: int = 11) -> FighterData:
	var f := EH.base(n, "Ink Shade", lvl)
	f.health = EH.es(296, 344, 4, 7, lvl, 11); f.max_health = f.health
	f.mana = EH.es(36, 42, 2, 3, lvl, 11); f.max_mana = f.mana
	f.physical_attack = EH.es(20, 24, 0, 2, lvl, 11)
	f.physical_defense = EH.es(20, 26, 1, 3, lvl, 11)
	f.magic_attack = EH.es(92, 102, 2, 4, lvl, 11)
	f.magic_defense = EH.es(36, 43, 2, 3, lvl, 11)
	f.speed = EH.es(32, 38, 2, 3, lvl, 11)
	f.crit_chance = 17; f.crit_damage = 2; f.dodge_chance = 20
	f.abilities = [EAB.ink_bolt(), EAB.ink_pool()]
	f.flavor_text = "A shadow that bleeds ink from the cult's hidden ledgers and forbidden texts. It pools darkness beneath its enemies and strikes with bolts of living blackness."
	return f
