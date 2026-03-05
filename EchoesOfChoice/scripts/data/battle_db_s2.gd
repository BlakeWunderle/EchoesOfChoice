class_name BattleDBS2

## Story 2 battle configurations: "Echoes in the Dark"
## Branching structure: Awakening → (DeepCavern | FungalHollow)
##   → (TranquilPool | TorchChamber) → CaveMerchant → CaveExit

const BattleData := preload("res://scripts/data/battle_data.gd")
const EnemyDBS2 := preload("res://scripts/data/enemy_db_s2.gd")


static func create_battle(battle_id: String) -> BattleData:
	match battle_id:
		"S2_CaveAwakening": return s2_cave_awakening()
		"S2_DeepCavern": return s2_deep_cavern()
		"S2_FungalHollow": return s2_fungal_hollow()
		"S2_TranquilPool": return s2_tranquil_pool()
		"S2_TorchChamber": return s2_torch_chamber()
		"S2_CaveMerchant": return s2_cave_merchant()
		"S2_CaveExit": return s2_cave_exit()
		_:
			push_error("Unknown Story 2 battle: %s" % battle_id)
			return s2_cave_awakening()


# =============================================================================
# Prog 0: Cave Awakening
# =============================================================================

static func s2_cave_awakening() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_CaveAwakening"
	b.scene_image = "res://assets/art/battles/void_cavern.png"
	b.enemies = [
		EnemyDBS2.create_glow_worm("Luminara"),
		EnemyDBS2.create_glow_worm("Flicker"),
		EnemyDBS2.create_crystal_spider("Prism"),
	]
	b.pre_battle_text = [
		"The cave stretches ahead, lit only by veins of faintly glowing crystal running through the walls.",
		"The group moves cautiously. Every sound echoes strangely, as if the cave is listening.",
		"A wet, pulsing glow rounds a corner ahead. Two worm-like creatures, each longer than an arm, cling to the ceiling. Their bodies throb with bioluminescent light.",
		"Behind them, something clicks across the stone. A spider, but wrong. Its body is translucent crystal, refracting the worms' glow into sharp prismatic shards.",
		"They turn toward the party in unison, as if guided by a single mind.",
	]
	b.post_battle_text = [
		"The creatures dissolve into fading light and broken crystal. No blood. No bodies. Just... nothing.",
		"The air hums for a moment, then goes silent.",
		"Whatever these things were, they weren't natural. Nothing about this place is.",
		"A flash of something. The taste of salt. A warm breeze on skin. Gone before it can be placed.",
		"The tunnel ahead splits in two.",
	]
	b.choices = [
		{"label": "Left: The shadows deepen, and strange symbols line the walls.", "battle_id": "S2_DeepCavern"},
		{"label": "Right: A faint glow pulses from somewhere deeper, warm and organic.", "battle_id": "S2_FungalHollow"},
	]
	b.music_track = "res://assets/audio/music/battle/Unknown Creatures LOOP.wav"
	b.cutscene_track = "res://assets/audio/music/cutscene/#12 Cave Horn.wav"
	return b


# =============================================================================
# Prog 1: Branch A — Deep Cavern
# =============================================================================

static func s2_deep_cavern() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_DeepCavern"
	b.scene_image = "res://assets/art/battles/tunnels.png"
	b.enemies = [
		EnemyDBS2.create_shade_crawler("Umbral"),
		EnemyDBS2.create_shade_crawler("Murk"),
		EnemyDBS2.create_echo_wisp("Resonance"),
	]
	b.pre_battle_text = [
		"The tunnel narrows and the crystal light fades. Darkness presses in from all sides.",
		"Someone notices markings on the wall. Not natural formations. Symbols, scratched deep into the rock. None of them are recognizable.",
		"A sound rises from deeper in the cave. Not words. Not music. Something between the two, distorted and wrong.",
		"Shadows peel away from the walls and begin to move. Two formless shapes slither across the floor toward the party.",
		"Above them, a sphere of warped light hovers, the source of the sound. It pulses, and the shadows surge forward.",
	]
	b.post_battle_text = [
		"The shadows disperse like smoke and the floating sphere winks out with a sharp pop.",
		"In the silence that follows, the symbols on the walls are everywhere. Floor, ceiling, every surface.",
		"One of the party traces a symbol and feels a jolt. Not pain. Recognition. A face surfaces unbidden. Someone smiling. Someone important. Then it's gone.",
		"The tunnel widens into a chamber where several passages meet. Two ways lead onward.",
	]
	b.choices = [
		{"label": "Follow the distant sound of running water.", "battle_id": "S2_TranquilPool"},
		{"label": "Follow a flicker of warm firelight.", "battle_id": "S2_TorchChamber"},
	]
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - The Tomb of Mystery.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/#15 Dark Strings Swell.wav"
	return b


# =============================================================================
# Prog 1: Branch B — Fungal Hollow
# =============================================================================

static func s2_fungal_hollow() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_FungalHollow"
	b.scene_image = "res://assets/art/battles/tunnels.png"
	b.enemies = [
		EnemyDBS2.create_spore_stalker("Creeper"),
		EnemyDBS2.create_fungal_hulk("Mossback"),
		EnemyDBS2.create_cap_wisp("Drifter"),
	]
	b.pre_battle_text = [
		"The right tunnel slopes downward. The air grows warm and damp.",
		"Mushrooms line the walls, first small, then enormous. Some glow with an inner light. Others pulse like breathing lungs.",
		"The floor is spongy underfoot. Roots or tendrils, it's hard to tell. Something moves in the canopy of fungal caps overhead.",
		"A shape detaches from the ceiling. Then another. Then something massive shifts in the dark behind them.",
	]
	b.post_battle_text = [
		"The fungal creatures collapse into spore clouds that settle like dust.",
		"The largest one's cap splits open as it falls, revealing hollow chambers inside. Something lived in there once. Something smarter than a mushroom.",
		"A scent cuts through the rot. Bread baking. Fresh and warm. Someone's kitchen, somewhere far from here. The memory vanishes as quickly as it came.",
		"The tunnel widens into a chamber where several passages meet. Two ways lead onward.",
	]
	b.choices = [
		{"label": "Follow the distant sound of running water.", "battle_id": "S2_TranquilPool"},
		{"label": "Follow a flicker of warm firelight.", "battle_id": "S2_TorchChamber"},
	]
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Duskfall Requiem.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 04.wav"
	return b


# =============================================================================
# Prog 2: Branch A — Tranquil Pool
# =============================================================================

static func s2_tranquil_pool() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_TranquilPool"
	b.scene_image = "res://assets/art/battles/rocky_shore.png"
	b.enemies = [
		EnemyDBS2.create_cave_eel("Voltfin"),
		EnemyDBS2.create_blind_angler("The Lure"),
		EnemyDBS2.create_pale_crayfish("Old Shell"),
	]
	b.pre_battle_text = [
		"The passage descends to a subterranean pool fed by a waterfall from a crack in the ceiling.",
		"The water is perfectly clear, lit from below by veins of crystal that run through the pool bed. Beautiful and deeply wrong.",
		"The party pauses to rest. Someone cups water in their hands and drinks. It tastes of stone and something electric.",
		"Something long and dark moves beneath the surface. Then a light appears in the depths. Soft. Inviting. The light is attached to something with teeth.",
		"The water erupts.",
	]
	b.post_battle_text = [
		"The pool goes still. The creatures sink below the surface and don't return.",
		"In the silence, someone remembers rain. Standing outside, face turned up, laughing at the sky. The joy of it is overwhelming and alien.",
		"The cave doesn't care about rain. The cave has never seen the sky.",
		"A dry passage leads upward from the pool's edge.",
	]
	b.next_battle_id = "S2_CaveMerchant"
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Fallen Realm.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 06.wav"
	return b


# =============================================================================
# Prog 2: Branch B — Torch Chamber
# =============================================================================

static func s2_torch_chamber() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_TorchChamber"
	b.scene_image = "res://assets/art/battles/dragons_lair.png"
	b.enemies = [
		EnemyDBS2.create_cave_dweller("Grimjaw"),
		EnemyDBS2.create_tunnel_shaman("Ember Eye"),
		EnemyDBS2.create_burrow_scout("Quickfoot"),
	]
	b.pre_battle_text = [
		"The passage opens into a chamber lit by crude torches jammed into cracks in the walls.",
		"This place is lived in. Bones are piled in one corner. Rough-hewn tools lean against the far wall. Something sleeps here.",
		"A figure steps into the torchlight. Humanoid, but hunched and wrong-proportioned. It wears scraps of armor that don't match.",
		"Behind it, a smaller figure with painted markings mutters words that make the torchlight flare. A third shape drops from a ledge above, silent as dust.",
		"They don't speak. They don't negotiate. They charge.",
	]
	b.post_battle_text = [
		"The cave dwellers scatter into side tunnels too narrow to follow.",
		"Among the debris left behind, someone finds a wooden toy. A carved horse, painted blue. The paint is fresh.",
		"One of the party stares at it for too long. A child's laughter echoes in their mind. Their child? Someone else's?",
		"The torches gutter and die one by one. Time to move on.",
	]
	b.next_battle_id = "S2_CaveMerchant"
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Twilight Monastery.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 10.wav"
	return b


# =============================================================================
# Town stop: Cave Merchant (T0 → T1 upgrades)
# =============================================================================

static func s2_cave_merchant() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_CaveMerchant"
	b.scene_image = "res://assets/art/battles/tunnels.png"
	b.is_town_stop = true
	b.pre_battle_text = [
		"The passage widens into a small alcove. A fire burns in a shallow pit, impossibly steady. No smoke.",
		"A figure sits cross-legged beside a battered pack, humming a melody that almost sounds familiar.",
		"They look up. No surprise. No fear. They wave the party over as if expecting visitors.",
		"'Ah. There you are. I've been holding onto some things that I think belong to you.'",
		"They open the pack. Inside, objects that feel strangely right. Tools. Tokens. Things that fit the hand as if they were made for it.",
		"How did this person get here? Why don't the creatures bother them? The questions hang in the air, unanswered.",
	]
	b.post_battle_text = [
		"Instincts sharpen. Memories of training flood back. Not who taught them, or where, but the muscle memory itself.",
		"A stance. A word of power. A reflex honed over years they can't remember.",
		"The merchant smiles. 'You'd better get going. The way out isn't far now. But it won't let you leave easily.'",
		"Before anyone can ask what that means, the merchant is packing up, already fading into the dark.",
	]
	b.next_battle_id = "S2_CaveExit"
	b.music_track = "res://assets/audio/music/cutscene/Sad Despair 08.wav"
	return b


# =============================================================================
# Prog 3: Cave Exit (tier 1, final Act I battle)
# =============================================================================

static func s2_cave_exit() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_CaveExit"
	b.scene_image = "res://assets/art/battles/void_cavern.png"
	b.enemies = [
		EnemyDBS2.create_cave_maw("The Threshold", 5),
		EnemyDBS2.create_vein_leech("Gnawer", 5),
		EnemyDBS2.create_stone_moth("Dustwing", 5),
	]
	b.pre_battle_text = [
		"The exit is close. A ragged circle of daylight glows at the end of the chamber.",
		"But between the party and the light, the cave itself moves.",
		"The stone floor splits open. Rows of crystalline teeth line the gap, grinding slowly. The cave has a mouth.",
		"A bloated leech clings to the wall beside it, pulsing with stolen light. Above, a grey moth the size of a shield hovers on stone-dust wings.",
		"The message is clear. This cave does not want them to leave.",
	]
	b.post_battle_text = [
		"The maw in the floor shudders and goes still. The teeth crack and crumble. The guardians shatter.",
		"The party stumbles toward the light and emerges into open air.",
		"Blinding sunlight. Wind. The smell of grass and earth. Warmth on skin that has forgotten what the sun feels like.",
		"Behind them, the cave entrance is barely visible. A crack in a hillside, easy to miss. Easy to forget.",
		"No one remembers how they got here. No one knows where 'here' is.",
		"But they're alive. And they have names, skills, and each other. That will have to be enough for now.",
	]
	b.is_final_battle = true
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Chamber of the Occult.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/Sad Despair 02.wav"
	return b
