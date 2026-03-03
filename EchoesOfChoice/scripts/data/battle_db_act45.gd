class_name BattleDBAct45

## Act IV-V battle configurations — Chaos and The Reckoning.
## Flow: CopperMugStop → [CorruptedCity | CorruptedWilds] → Depths → Gate → StrangerFinal

const BattleData := preload("res://scripts/data/battle_data.gd")
const EnemyDB := preload("res://scripts/data/enemy_db.gd")


# =============================================================================
# The Copper Mug (Act IV hub — town stop after Tower reveal)
# =============================================================================

static func copper_mug_stop() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "CopperMugStop"
	b.is_town_stop = true
	b.pre_battle_text = [
		"The tower is silent behind them. The stranger is gone but the damage is done — the sky is ash, the air cold, and the city is breaking apart.",
		"The party makes for The Copper Mug. It's the only place they know is still standing.",
		"The barkeep is behind the counter, same as before, but he's not hiding this time. A dozen survivors crowd the tables. A woman holds a sleeping child. An old man stares at nothing.",
		"'You're alive,' the barkeep says. 'That makes you the best news I've had all week.'",
		"He sets out cups without being asked. 'Sit down. You need to hear what people have been telling me.'",
	]
	b.post_battle_text = [
		"The barkeep refills his own cup. 'Two places. That's where the worst of it is.'",
		"'The market square — the dead are walking. A thing in robes is pulling them out of the ground like weeds. Nobody who went to look came back.'",
		"'And the wilds. The forest is eating itself. Trees moving, ground splitting open. A hunter came in this morning — said the stranger's mark is carved into every tree out there.'",
		"He looks at the party. 'I don't know where your friend went after the tower. But wherever he is, those two places are keeping him strong. Cut them off and maybe you've got a chance.'",
		"'Be careful. And come back. This place could use some good news.'",
	]
	b.choices = [
		{"label": "City — The market square pulses with necrotic energy.", "battle_id": "CorruptedCityBattle"},
		{"label": "Wilds — The stranger's mark is carved into every tree.", "battle_id": "CorruptedWildsBattle"},
	]
	return b


# =============================================================================
# Act IV — Choice: Corrupted City or Corrupted Wilds
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
		"The party cuts through the city toward the market square. These are the same streets they walked that first night — cobblestones they know by feel — but the lanterns are shattered and the air smells of ash and something older.",
		"The market square is unrecognizable. Stalls are overturned, awnings shredded. The fountain that once ran clear is dry and cracked, dark energy seeping from the basin like fog.",
		"A lich stands atop the ruined fountain, arms raised, pulling the dead toward it from every alley and doorway.",
		"A ghast lurches from the wreckage of a flower cart, its bulk filling the road. Behind it, another lich drifts through the carnage.",
	]
	b.post_battle_text = [
		"The lich crumbles to dust and the ghast collapses. The necrotic energy fades but doesn't disappear — it's being fed from somewhere else.",
		"In a basement beneath a bakery, a handful of survivors huddle around a candle. An old woman with flour still on her apron looks up when the door opens.",
		"'Three days ago the fog rolled in from the tower and the dead started walking. We barred the doors and prayed.'",
		"'One more thing. At night, the ground shakes. Not much, but you can feel it in the floor. Something under the city. Something big.'",
		"She points toward a crack in the basement wall. Cold air seeps through it, carrying the smell of old stone and something alive.",
		"Whatever the stranger is building, it's underground.",
	]
	b.next_battle_id = "DepthsBattle"
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
		"The party pushes back into the wilderness. The path feels familiar — they've walked it before — but everything is wrong.",
		"Trees they passed days ago are twisted into unnatural shapes, bark blackened and split, sap running dark. The air smells of rot where it once smelled of pine and earth.",
		"The stranger's sigil is carved into every third trunk. Circle with a slash. Fresh cuts, still weeping.",
		"A demon perches on a corrupted treant, riding it like a throne. The forest groans with every step the treant takes, roots tearing free from the ground.",
	]
	b.post_battle_text = [
		"The demon dissolves into smoke and the treant splinters apart. The corruption recedes slightly but the land remains scarred.",
		"In a cave nearby, a woodcutter and his two children sit around a dying fire. His hands are shaking.",
		"'The animals went first. Then the trees started moving. Then came the things with wings.'",
		"'A man came through before it started. Polite. Asked for directions. Paid with a coin that was blank on one side.' He pauses. 'I should have known.'",
		"'He asked about the old tunnels under the city. Whether they still connected to anything. I told him I didn't know. He smiled like he already had the answer.'",
		"The tunnels under the city. That's where the stranger went.",
	]
	b.next_battle_id = "DepthsBattle"
	return b


# =============================================================================
# Depths (mandatory — underground pursuit)
# =============================================================================

static func depths_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "DepthsBattle"
	b.enemies = [
		EnemyDB.create_sigil_wretch("Skritch"),
		EnemyDB.create_tunnel_lurker("Silkfang"),
		EnemyDB.create_tunnel_lurker("Webweaver"),
	]
	b.pre_battle_text = [
		"A crack in the cobblestones near the old well leads to tunnels beneath the city. The party drops down one by one.",
		"The walls are covered in webs thick as rope. The air is stale and carries the smell of old stone and something alive and waiting.",
		"Deeper in, the stranger's sigils appear on the tunnel walls, carved with care. They pulse faintly, marking the path like lanterns. An invitation.",
		"A sigil wretch peels itself from the tunnel wall with a screech — a twisted thing, all limbs and teeth, born from the stranger's carved marks.",
		"A tunnel lurker fills the passage ahead, pale and eyeless, its clawed limbs clicking on stone.",
		"The stranger knows they're coming.",
	]
	b.post_battle_text = [
		"The sigil wretch shrieks and dissolves back into the wall. The tunnel lurker curls and goes still.",
		"The webs thin and the tunnel opens wider. Ahead, the passage ends at a massive gate set into the stone — old, heavy, and sealed.",
		"The stranger's sigil covers every surface of it, glowing faintly. The same symbol from the abandoned house in the forest, from the tower walls. It's followed them since the beginning.",
		"Something moves on the other side. The sound of metal on stone. A low growl.",
		"The gate is guarded.",
	]
	b.next_battle_id = "GateBattle"
	return b


# =============================================================================
# Gate (mandatory — last guardian before the sanctum)
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
		"The gate stands sealed with sigils. The air coming through the cracks is cold and hums with power.",
		"A knight in armor so dark it seems to drink the light stands before the gate. The metal doesn't shine — it absorbs. At his feet, a hound made of pure shadow growls with a sound like cloth tearing slowly.",
		"'None pass.' The voice echoes inside the helmet, hollow and wrong.",
		"These aren't people. They're constructs — the stranger's last guardians, standing between the party and whatever lies beyond.",
	]
	b.post_battle_text = [
		"The dark knight crumbles and the fell hound evaporates. The sigils on the gate crack one by one until the stone swings open.",
		"Beyond, stairs lead down into darkness. The air rising from below thrums with power so thick it presses against the skin.",
		"This is it. Whatever the stranger has been building toward, it's down there.",
		"The party descends.",
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
		"The passage opens into a vast cavern. The ceiling is lost in darkness above.",
		"Sigils cover every surface, pulsing in rhythm like a heartbeat. The stranger's heartbeat.",
		"The stranger stands at the center, wreathed in shadow so thick it moves like smoke. Their form has changed — taller, edges blurring into darkness, eyes burning with void light. Barely human.",
		"'You made it.' The voice comes from everywhere. 'I'm genuinely impressed. Most puppets don't cut their strings.'",
		"'But it doesn't matter. Every mile you walked, every battle you fought — it fed the shadow. This world is mine now.'",
		"They raise their hands and darkness surges from every sigil in the cavern.",
		"'One last fight. For old times' sake.'",
	]
	b.post_battle_text = [
		"The stranger's form shatters like glass. The darkness fractures and light pours in from above — real light, sunlight, impossibly bright after so long in shadow.",
		"The sigils die one by one, their glow fading like embers. The cavern shakes.",
		"The party runs. Stone falls behind them. The tunnel collapses in their wake.",
		"They burst into the open air and stop. The sky is clearing. Ash-colored clouds break apart and sunlight hits the city for the first time in days.",
		"Warmth. Real warmth.",
		"People emerge from basements and barred rooms, blinking and shielding their eyes. A child runs across the market square. Somewhere, a dog barks.",
		"The door of The Copper Mug swings open and the barkeep steps out, looking up at the sky. He sees the party and nods. No words needed.",
		"The party stands on the same cobblestone streets they walked that first night, leaving the tavern full of drink and ready for adventure. They're not the same people who left.",
		"The stranger is gone. The shadow is gone. The world will heal — slowly, with scars — but it will heal.",
		"Whatever comes next, they'll face it together.",
	]
	return b
