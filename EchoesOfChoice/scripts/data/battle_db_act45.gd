class_name BattleDBAct45

## Act IV-V battle configurations — Chaos and The Reckoning (Battles 11-14).

const BattleData := preload("res://scripts/data/battle_data.gd")
const EnemyDB := preload("res://scripts/data/enemy_db.gd")


# =============================================================================
# Act IV — Choice 1: Corrupted City or Corrupted Wilds
# =============================================================================

static func corrupted_city_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "CorruptedCityBattle"
	b.enemies = [
		EnemyDB.create_lich("Mortuus"),
		EnemyDB.create_ghast("Putrefax"),
		EnemyDB.create_ghast("Bloatus"),
		EnemyDB.create_lich("Necrus"),
	]
	b.pre_battle_text = [
		"The city center has become a necropolis. The dead walk openly, drawn by a lich that has claimed the old market square as its throne.",
		"The ground is cracked and leaking dark energy. A ghast lurches forward, its bulk blocking the road.",
	]
	b.post_battle_text = [
		"The lich crumbles to dust and the ghast collapses. The necrotic energy fades but doesn't disappear — it's being fed from somewhere else.",
		"Among the ruins, survivors huddle in a basement. They speak of more horrors spreading.",
	]
	b.choices = [
		{"label": "Temple — A corrupted temple radiates hellfire.", "battle_id": "TempleBattle"},
		{"label": "Blight — The eastern fields are rotting.", "battle_id": "BlightBattle"},
	]
	return b


static func corrupted_wilds_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "CorruptedWildsBattle"
	b.enemies = [
		EnemyDB.create_demon("Bael"),
		EnemyDB.create_corrupted_treant("Rothollow"),
		EnemyDB.create_corrupted_treant("Blightsnarl"),
		EnemyDB.create_demon("Moloch"),
	]
	b.pre_battle_text = [
		"The wilderness has turned against itself. Trees twist into unnatural shapes, their bark blackened and weeping sap.",
		"A demon perches on a corrupted treant as if riding a throne. The forest groans with every step the treant takes.",
	]
	b.post_battle_text = [
		"The demon dissolves into smoke and the treant splinters apart. The corruption recedes slightly but the land remains scarred.",
		"Somewhere deeper, more darkness stirs. Survivors found sheltering in a cave point toward the next crisis.",
	]
	b.choices = [
		{"label": "Temple — A corrupted temple radiates hellfire.", "battle_id": "TempleBattle"},
		{"label": "Blight — The eastern fields are rotting.", "battle_id": "BlightBattle"},
	]
	return b


# =============================================================================
# Act IV — Choice 2: Temple or Blight
# =============================================================================

static func temple_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "TempleBattle"
	b.enemies = [
		EnemyDB.create_hellion("Ashara"),
		EnemyDB.create_fiendling("Cinder"),
		EnemyDB.create_fiendling("Ember"),
		EnemyDB.create_hellion("Pyrath"),
	]
	b.pre_battle_text = [
		"The old temple on the hill has been consumed by hellfire. Its walls glow red from within and the air shimmers with heat.",
		"Inside, a hellion stands at the altar channeling infernal energy while a fiendling scurries between the pews, setting everything ablaze.",
	]
	b.post_battle_text = [
		"The hellfire dies and the temple goes dark. The stone cools slowly.",
		"Whatever portal was being opened here has collapsed — for now. But the stranger's influence runs deeper.",
		"One more threat must be dealt with before the final confrontation.",
	]
	b.choices = [
		{"label": "Gate — An armored figure guards the sealed city gate.", "battle_id": "GateBattle"},
		{"label": "Depths — Something skitters in the tunnels below.", "battle_id": "DepthsBattle"},
	]
	return b


static func blight_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "BlightBattle"
	b.enemies = [
		EnemyDB.create_dragon("Vexaris"),
		EnemyDB.create_blighted_stag("Withered Crown"),
		EnemyDB.create_blighted_stag("Rotted Tine"),
		EnemyDB.create_dragon("Malachar"),
	]
	b.pre_battle_text = [
		"The eastern fields have become a wasteland. Crops are ash, the ground cracked and oozing.",
		"A dragon circles overhead, scales dulled by corruption. Below it, a stag twice its natural size staggers forward, its antlers dripping with blight.",
		"Both have been twisted by the stranger's magic.",
	]
	b.post_battle_text = [
		"The dragon crashes to the earth and the stag collapses. The blight begins to recede from the edges of the field, but the center remains poisoned.",
		"The stranger's power is waning, but they still have defenses.",
	]
	b.choices = [
		{"label": "Gate — An armored figure guards the sealed city gate.", "battle_id": "GateBattle"},
		{"label": "Depths — Something skitters in the tunnels below.", "battle_id": "DepthsBattle"},
	]
	return b


# =============================================================================
# Act IV — Choice 3: Gate or Depths
# =============================================================================

static func gate_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "GateBattle"
	b.enemies = [
		EnemyDB.create_dark_knight("Ser Malachar"),
		EnemyDB.create_fell_hound("Duskfang"),
		EnemyDB.create_fell_hound("Gloomjaw"),
		EnemyDB.create_dark_knight("Ser Dravus"),
	]
	b.pre_battle_text = [
		"The old city gate has been sealed with dark sigils — the same symbol from the forest, from the tower.",
		"A knight in blackened armor stands before it, sword drawn. At his side, a hound made of shadow growls with a sound like tearing cloth.",
		"The stranger's last guardians.",
	]
	b.post_battle_text = [
		"The dark knight falls and the fell hound evaporates. The sigils on the gate crack and fade.",
		"Beyond lies a passage leading down — to wherever the stranger has gone to complete their work. The sanctum.",
	]
	b.next_battle_id = "StrangerFinalBattle"
	return b


static func depths_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "DepthsBattle"
	b.enemies = [
		EnemyDB.create_imp("Skritch"),
		EnemyDB.create_cave_spider("Silkfang"),
		EnemyDB.create_cave_spider("Webweaver"),
		EnemyDB.create_imp("Gnash"),
	]
	b.pre_battle_text = [
		"Beneath the city, the tunnels wind downward. The walls are covered in webs thick as rope.",
		"An imp darts between the shadows, cackling, while a spider the size of a cart blocks the tunnel ahead.",
		"The stranger's last line of defense before the sanctum.",
	]
	b.post_battle_text = [
		"The imp shrieks and vanishes. The spider curls and goes still.",
		"The webs part to reveal a passage carved with sigils, leading deeper. The air hums with power. The stranger is close.",
	]
	b.next_battle_id = "StrangerFinalBattle"
	return b


# =============================================================================
# Act V — Final Battle
# =============================================================================

static func stranger_final_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "StrangerFinalBattle"
	b.is_final_battle = true
	b.enemies = [
		EnemyDB.create_stranger_final("The Stranger"),
	]
	b.pre_battle_text = [
		"The sanctum is a cavern of pure darkness. Sigils cover every surface, pulsing in rhythm like a heartbeat.",
		"The stranger stands at the center, wreathed in shadow. Their true form is barely human now — taller, darker, their eyes burning with void light.",
		"'You made it. I'm impressed. But you're too late. The ritual is complete. This world belongs to the shadow now.'",
		"They raise their hands and the darkness surges.",
		"'Let's finish this.'",
	]
	b.post_battle_text = [
		"The stranger's form shatters. The darkness fractures and light pours in from above.",
		"The sigils die one by one. The cavern begins to collapse. The party runs.",
		"Outside, the sky is clearing. The ash-colored clouds break apart and sunlight hits the land for the first time in days.",
		"The city stirs. People emerge from hiding. It's over.",
		"The stranger is gone and with them, the shadow. The world will heal. It will take time, but it will heal.",
		"The party stands in the light, bruised and exhausted and alive. Whatever comes next, they'll face it together.",
	]
	return b
