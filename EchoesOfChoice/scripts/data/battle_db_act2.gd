class_name BattleDBACT2

## Act II battle configurations. The Wilds (Battles 4-8).

const BattleData := preload("res://scripts/data/battle_data.gd")
const EnemyDB := preload("res://scripts/data/enemy_db.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")


# =============================================================================
# First wilderness battle (3-way branch from ForestWaypoint)
# =============================================================================

static func highland_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "HighlandBattle"
	b.location_name = "The Highlands"
	b.scene_image = "res://assets/art/battles/highlands.png"
	b.enemies = [
		EnemyDB.create_raider("Wulfric"),
		EnemyDB.create_raider("Bjorn"),
		EnemyDB.create_orc("Grath"),
	]
	b.pre_battle_text = [
		"The western trail climbs into the highlands, rocky and wind-battered. Cairns of piled stone mark the path at uneven intervals.",
		"A raider steps out from behind a cairn, arms crossed, blocking the trail. An orc looms behind him, half again as tall and twice as wide.",
		"'Tribute,' the raider says. 'Everything you've got. Or we take it off your corpses.'",
		"The party has a different idea.",
	]
	b.post_battle_text = [
		"The raider stumbles back and the orc grunts, dragging him up the mountain path. They disappear around a bend without looking back.",
		"The highlands open ahead into a narrow pass, the wind howling through the gap between sheer rock walls.",
	]
	b.next_battle_id = "MountainPassBattle"
	return b


static func deep_forest_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "DeepForestBattle"
	b.location_name = "Old Growth Forest"
	b.scene_image = "res://assets/art/battles/old_growth_forest.png"
	b.enemies = [
		EnemyDB.create_witch("Morwen"),
		EnemyDB.create_wisp("Flicker"),
		EnemyDB.create_sprite("Briar"),
	]
	b.pre_battle_text = [
		"Pushing north, the forest grows denser. The trees here are older, thick-rooted and close-set, their canopy blocking out most of the sky. The path narrows to barely a trail.",
		"Everyone walks up on a circle of sticks, stones, and mud. Everything around them begins to shake and levitate.",
		"The sticks catch fire and a strike of lightning flashes across the sky.",
		"A cackle and two screeches fill the air as the adventurers prepare for battle.",
	]
	b.post_battle_text = [
		"With the witch and her minions defeated the forest goes still. Too still.",
		"Thunder rolls overhead and rain begins to pour through the canopy. Up ahead a cave mouth gapes open in the hillside.",
		"Claw marks line the entrance and old bones crunch underfoot. Whatever lives in there is big.",
		"The party ducks inside for cover, hoping the storm passes before the cave's occupant returns.",
	]
	b.next_battle_id = "CaveBattle"
	return b


static func shore_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "ShoreBattle"
	b.location_name = "Rocky Shore"
	b.scene_image = "res://assets/art/battles/rocky_shore.png"
	b.enemies = [
		EnemyDB.create_siren("Lorelei"),
		EnemyDB.create_merfolk("Thalassa"),
		EnemyDB.create_merfolk("Nereus"),
	]
	b.pre_battle_text = [
		"The salt air hit them before the trees even thinned. Following it southeast, the forest gives way to rocky cliffs and the sound of surf crashing far below.",
		"A strange singing drifts across the water, beautiful enough to stop everyone in their tracks.",
		"A siren emerges from the tide pools, her melody turning hostile. Beside her, a merfolk warrior rises from the shallows, trident in hand.",
	]
	b.post_battle_text = [
		"With the sirens defeated, the singing fades and the tide recedes.",
		"A sandy beach stretches out ahead, and in the distance the wreck of a ship juts from the shallows.",
	]
	b.next_battle_id = "BeachBattle"
	return b


# =============================================================================
# Second wilderness battle (follows each branch)
# =============================================================================

static func mountain_pass_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "MountainPassBattle"
	b.location_name = "Mountain Pass"
	b.scene_image = "res://assets/art/battles/mountain_pass.png"
	b.enemies = [
		EnemyDB.create_troll("Grendal"),
		EnemyDB.create_harpy("Screecher"),
		EnemyDB.create_harpy("Shrieker"),
	]
	b.pre_battle_text = [
		"The mountain pass narrows to barely a single track wide. A bridge of ancient stone spans a deep ravine, the bottom lost in mist.",
		"Halfway across, a troll lumbers out from under the bridge. Its skin is the color of wet rock and its eyes burn a dull orange.",
		"Above, a harpy circles and shrieks, diving and pulling up, testing the party's nerve.",
		"No way around. Only through.",
	]
	b.post_battle_text = [
		"The troll loses its footing and tumbles into the ravine with a fading roar. The harpy shrieks and flees into the clouds.",
		"Beyond the pass the land drops into a wide valley. Smoke from cooking fires marks an outpost ahead.",
	]
	b.next_battle_id = "WildernessOutpost"
	return b


static func cave_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "CaveBattle"
	b.location_name = "Dragon's Lair"
	b.scene_image = "res://assets/art/battles/dragons_lair.png"
	var leader_name: String = "the adventurer"
	if not GameState.party.is_empty():
		leader_name = GameState.party[0].character_name
	b.enemies = [
		EnemyDB.create_fire_wyrmling("Raysses"),
		EnemyDB.create_frost_wyrmling("Sythara"),
		EnemyDB.create_fire_wyrmling("Cindrak"),
	]
	b.pre_battle_text = [
		"After entering the cave the adventurers notice gold everywhere. Coins, goblets, and jewels are heaped in massive mounds that glitter in the dim light.",
		"The cave begins to darken as a shadow larger than anything they've seen stretches across the walls.",
		"A solemn voice speaks a grave warning before a fireball is shot in the direction of %s." % leader_name,
	]
	b.post_battle_text = [
		"The wyrmlings crash to the ground and the cave falls silent. Nothing but the sound of gold coins sliding off their scales.",
		"Twin dragons, ancient and territorial. Not the source, but old creatures don't settle near nothing. Something stirred them. Something darker than treasure hunters.",
	]
	b.next_battle_id = "WildernessOutpost"
	return b


static func beach_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "BeachBattle"
	b.location_name = "Shipwreck Beach"
	b.scene_image = "res://assets/art/battles/shipwreck_beach.png"
	b.enemies = [
		EnemyDB.create_captain("Greybeard"),
		EnemyDB.create_pirate("Flint"),
		EnemyDB.create_pirate("Bonny"),
	]
	b.pre_battle_text = [
		"The beach opens up and a wrecked ship juts out of the shallows, its hull split wide open.",
		"A tattered flag still clings to the mast, snapping in the wind. The adventurers wade out and begin searching the wreck.",
		"Crates of supplies and glittering trinkets spill from the hold. Not a bad find.",
		"That is until a voice bellows from the rocks above. 'That is our treasure!' A pirate crew drops down and the ambush begins.",
	]
	b.post_battle_text = [
		"With the pirate crew defeated the adventurers claim the ship's hold for themselves.",
		"Among the crates and barrels they find supplies worth taking. Not treasure, but enough to keep going.",
	]
	b.next_battle_id = "WildernessOutpost"
	return b


# =============================================================================
# Wilderness Outpost (narrative-only town, no upgrades, variant branching)
# =============================================================================

static func wilderness_outpost() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "WildernessOutpost"
	b.location_name = "Wilderness Outpost"
	b.scene_image = "res://assets/art/battles/wilderness_outpost.png"
	# No enemies, narrative scene will skip battle and go to post_battle_text
	var prev: String = GameState.previous_battle_id
	b.pre_battle_text = [
		"Through a break in the trees the party spots a cluster of tents and wagons, people moving away from the city, not toward it.",
		"A young scout sits apart from the others, watching the road. He waves them over.",
		"'You came from deeper in? Good. You're still alive, that's something.'",
		"'Three weeks ago things started getting strange back in the city. Market district went quiet overnight. Animals started fleeing.'",
		"'Then the fog came. Cold, wrong-smelling fog rolling out in every direction. People started leaving.'",
	]
	# Variant text based on which branch the player came from
	match prev:
		"MountainPassBattle":
			b.pre_battle_text.append("'South of here there's a military encampment. Big one. They showed up right when the fog did. East, the fog is thickest. There's a path through the hills that smells of old earth and something worse.'")
		"CaveBattle":
			b.pre_battle_text.append("'East of here I keep hearing music and laughter through the trees. No one's set up any kind of camp out there. West, a building with lights that shouldn't be there. Neither one was here a month ago.'")
		"BeachBattle":
			b.pre_battle_text.append("'Inland to the north the music's been getting louder. Something drawing people in. South the fog is thickest. There's a path through the hills that smells like old earth and something worse.'")
	b.post_battle_text = [
		"He looks toward the city in the distance. 'Whatever's happening, it's not starting out here. It's starting there. You're all just catching the edges of it.'",
		"'City's that way. Whatever you find out here, if you make it back, make it count.'",
	]
	# Variant choices
	match prev:
		"MountainPassBattle":
			b.choices = [
				{"label": "Camp: Marching boots and a barking voice echo across the plain.", "battle_id": "ArmyBattle"},
				{"label": "Fog: A fog-covered path winds into rolling hills.", "battle_id": "CemeteryBattle"},
			]
		"CaveBattle":
			b.choices = [
				{"label": "Laughter: Music drifts through the trees.", "battle_id": "CircusBattle"},
				{"label": "Static: An unnatural energy pulses in the dark.", "battle_id": "LabBattle"},
			]
		"BeachBattle":
			b.choices = [
				{"label": "Music: Laughter and music filter through the trees.", "battle_id": "CircusBattle"},
				{"label": "Fog: A fog-covered path winds into rolling hills.", "battle_id": "CemeteryBattle"},
			]
	return b


# =============================================================================
# Third wilderness battle (one of four: Circus, Lab, Army, Cemetery)
# =============================================================================

static func circus_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "CircusBattle"
	b.location_name = "Wooded Hills"
	b.scene_image = "res://assets/art/battles/wooded_hills.png"
	b.enemies = [
		EnemyDB.create_harlequin("Louis"),
		EnemyDB.create_chanteuse("Erembour"),
		EnemyDB.create_ringmaster("Gaspard"),
	]
	var prev: String = GameState.previous_battle_id
	var intro: String
	match prev:
		"BeachBattle":
			intro = "The trail leads north from the coast, winding through rolling hills with the sound of distant music growing louder. It seems peaceful enough until everyone suddenly hits something. An invisible wall."
		"CaveBattle":
			intro = "The path east from the cave threads through wooded hills. Quiet, unremarkable terrain, until everyone suddenly hits something. An invisible wall."
		_:
			intro = "Following the sound of music through the trees, the party pushes deeper into unfamiliar territory. The laughter grows louder, until everyone suddenly hits something. An invisible wall."
	b.pre_battle_text = [
		intro,
		"They turn left, then right, and finally turn back but they're boxed in. Something is trapping them and they can't see what.",
		"The air around them begins to darken, the invisible walls turning black as ink.",
		"Their attackers reveal themselves with smiles far too wide for comfort.",
	]
	b.post_battle_text = [
		"The performers crumple and the black walls shatter like glass, dissolving into nothing.",
		"Where the ringmaster fell a mirror lies face-up on the ground, perfectly clean among the dirt and debris.",
		"It catches the light in a way that shouldn't be possible. Something about it demands attention.",
		"No one knows what to make of it. They take it.",
	]
	b.next_battle_id = "OutpostDefenseBattle"
	return b


static func lab_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "LabBattle"
	b.location_name = "The Laboratory"
	b.scene_image = "res://assets/art/battles/laboratory.png"
	b.enemies = [
		EnemyDB.create_android("Deus"),
		EnemyDB.create_machinist("Ananiah"),
		EnemyDB.create_ironclad("Acrid"),
	]
	var direction: String = "west" if GameState.previous_battle_id == "CaveBattle" else "north-east"
	b.pre_battle_text = [
		"Heading %s, the air changes. There's a faint charge to it, a prickling on the skin and a taste like iron. Not magic. Something else." % direction,
		"A large structure rises from the landscape, all clean angles and dark windows. No signs, no torches. Whatever it runs on, it isn't fire.",
		"Inside, the hum is louder. Banks of machinery line the walls. On a central table, something large lies covered by a cloth, something roughly human-shaped.",
		"The cloth drops on its own. A laser beam punches through the air and the party dives clear.",
	]
	b.post_battle_text = [
		"The machines power down one by one, sparks fading to nothing. The building hums its last and goes dark.",
		"In the silence a reflection catches the party's eye. A mirror sits on the lab table, its surface impossibly clear.",
		"It doesn't reflect the room. It reflects something else entirely.",
		"No one touches it. Not yet. But no one suggests leaving it either.",
	]
	b.next_battle_id = "OutpostDefenseBattle"
	return b


static func army_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "ArmyBattle"
	b.location_name = "Military Encampment"
	b.scene_image = "res://assets/art/battles/military_encampment.png"
	b.enemies = [
		EnemyDB.create_commander("Varro"),
		EnemyDB.create_draconian("Theron"),
		EnemyDB.create_chaplain("Cristole"),
	]
	b.pre_battle_text = [
		"Heading south, the landscape opens up into a wide plain. It should be empty. It isn't.",
		"Rows of canvas tents stretch out ahead, fires burning in careful formation. A booming voice cuts through the air, barking orders. This is no bandit camp. It's a regiment, moving with discipline.",
		"The scouts spot the party before they can pull back. A commander's voice rings out and the regiment wheels toward them.",
	]
	b.post_battle_text = [
		"The regiment scatters and the commander's voice goes silent. Tents flap in the wind, abandoned.",
		"Among the scattered supplies and overturned crates the party spots something that doesn't belong.",
		"A mirror, sitting upright in the dirt, untouched by the chaos around it. Its surface gleams like it's brand new.",
		"Someone put it here on purpose. Someone who knew they'd be passing through.",
		"No one can explain it. They wrap it in cloth and carry it.",
	]
	b.next_battle_id = "OutpostDefenseBattle"
	return b


static func cemetery_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "CemeteryBattle"
	b.location_name = "Fog-covered Cemetery"
	b.scene_image = "res://assets/art/battles/cemetery.png"
	var leader_name: String = "the adventurer"
	if not GameState.party.is_empty():
		leader_name = GameState.party[0].character_name
	b.enemies = [
		EnemyDB.create_zombie("Mort--"),
		EnemyDB.create_ghoul("Rave--"),
		EnemyDB.create_zombie("Dredg--"),
	]
	b.pre_battle_text = [
		"Leaving the coast behind, the party follows the fog-covered path to the south.",
		"The mist thickens with every step until the adventurers can barely see each other.",
		"When it finally thins they find themselves standing in a cemetery. The air smells of damp earth and something old.",
		"Two graves have some writing on them and they read Mort-- and Rave--.",
		"A hand reaches up from the ground and gets a hold of %s. Something faster scrabbles out of the second grave, eyes glowing." % leader_name,
	]
	b.post_battle_text = [
		"The zombies collapse back into the earth and the cemetery goes quiet. Even the wind stops.",
		"The fog begins to lift and among the tombstones something catches the light.",
		"A mirror, propped against a weathered headstone, perfectly clean as if someone placed it there on purpose.",
		"No one wants to carry it. No one wants to leave it behind either.",
	]
	b.next_battle_id = "OutpostDefenseBattle"
	return b


# =============================================================================
# Convergence battles (all paths meet here)
# =============================================================================

static func outpost_defense_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "OutpostDefenseBattle"
	b.location_name = "Wilderness Outpost"
	b.scene_image = "res://assets/art/battles/outpost_night.png"
	b.enemies = [
		EnemyDB.create_shade("Umbra"),
		EnemyDB.create_wraith("Revenant"),
		EnemyDB.create_shade("Penumbra"),
		EnemyDB.create_wraith("Specter"),
	]
	b.pre_battle_text = [
		"Night falls at the outpost and the temperature drops unnaturally fast. Breath turns to fog. The campfires gutter and dim as though something is pulling the warmth out of the air.",
		"Two shapes materialize from the darkness at the edge of the firelight. Not animals. Not people. Shadows with substance.",
		"They move without sound, drifting toward the camp with purpose. The first real sign that something beyond nature is at work.",
		"Weapons won't help much against things without bodies. But the party has to try.",
	]
	b.post_battle_text = [
		"The shadows dissolve into wisps of dark smoke, but the unnatural cold lingers in the air.",
		"No one sleeps well. The mirror from before sits wrapped in a pack, but everyone is aware of it.",
		"In the firelight, someone swears the cloth over it is glowing. No one checks.",
	]
	b.next_battle_id = "MirrorBattle"
	return b


static func mirror_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "MirrorBattle"
	b.location_name = "Wilderness Outpost"
	b.scene_image = "res://assets/art/battles/mirror_battle.png"
	# Clone the player's party as shadow enemies at reduced stats
	var clones: Array = []
	for fighter: FighterData in GameState.party:
		var shadow: FighterData = fighter.clone()
		shadow.character_name = "Shadow " + fighter.character_name
		shadow.is_user_controlled = false
		shadow.max_health = int(shadow.max_health * 0.94); shadow.health = shadow.max_health
		shadow.physical_attack = int(shadow.physical_attack * 0.98)
		shadow.magic_attack = int(shadow.magic_attack * 0.98)
		shadow.speed = int(shadow.speed * 0.97)
		clones.append(shadow)
	b.enemies = clones
	var observer_name: String = "the adventurer"
	if GameState.party.size() > 1:
		observer_name = GameState.party[1].character_name
	elif not GameState.party.is_empty():
		observer_name = GameState.party[0].character_name
	b.pre_battle_text = [
		"Someone finally unwraps the mirror. Everyone looks into it. For a moment the reflections stare back a little too long.",
		"%s notices dark clouds forming behind them and spins around." % observer_name,
		"The clouds twist and solidify, taking the exact shape of the party. Same faces, same weapons, same stance.",
		"Fighting yourself. That's a new one.",
	]
	b.post_battle_text = [
		"The shadow clones dissolve into smoke and are pulled back into the mirror.",
		"The surface ripples and cloudy letters slowly form across the glass: 'Return to the city.'",
		"The letters pulse with urgency. Something is wrong back home and whoever left this message knew it.",
		"The adventurers exchange a look. No more detours. Time to head back.",
		"Where is the stranger? They haven't been seen since before the mirror appeared. Come to think of it, the mirror was placed too perfectly, as if someone knew exactly where they'd be.",
		"The stranger said the source of the darkness was beyond the forest. They went looking and found only chaos spreading from somewhere else.",
		"And now a mirror is pointing them home.",
		"The thought lands slowly, uncomfortably: maybe the source was never out here. Maybe it was always at the city.",
		"As they turn toward the city, something catches the eye. A faint smudge on the horizon where the skyline should be.",
		"Dark. Wrong. Moving.",
		"They run.",
	]
	b.next_battle_id = "CityOutskirtsStop"
	return b
