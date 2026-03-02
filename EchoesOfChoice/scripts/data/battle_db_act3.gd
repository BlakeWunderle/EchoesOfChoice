class_name BattleDBACT3

## Act III battle configurations — The Return (Battles 9-10 + CityOutskirtsStop).

const BattleData := preload("res://scripts/data/battle_data.gd")
const EnemyDB := preload("res://scripts/data/enemy_db.gd")


# =============================================================================
# City Outskirts (T1 → T2 upgrade town stop)
# =============================================================================

static func city_outskirts_stop() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "CityOutskirtsStop"
	b.is_town_stop = true
	b.pre_battle_text = [
		"The party reaches the outskirts of the city. Something is wrong.",
		"Smoke rises from the market district and the streets are too quiet. No merchants calling out, no children running between the stalls.",
		"An old armory sits abandoned near the gate, its door hanging open. Inside, racks of weapons and armor gather dust — but not all of it.",
		"Each member of the party finds equipment that suits them perfectly, as if it were waiting for them.",
	]
	b.post_battle_text = [
		"The city skyline looks wrong. Dark shapes move on the walls. Whatever happened here, it happened fast.",
	]
	b.next_battle_id = "ReturnToCityStreetBattle"
	return b


# =============================================================================
# Battle 9: Ravaged Streets
# =============================================================================

static func return_to_city_street_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "ReturnToCityStreetBattle"
	b.enemies = [
		EnemyDB.create_royal_guard("Aldric"),
		EnemyDB.create_guard_sergeant("Brennan"),
		EnemyDB.create_guard_archer("Tamsin"),
		EnemyDB.create_guard_archer("Corwin"),
	]
	b.pre_battle_text = [
		"The party enters the city and finds it changed. The streets are empty, shops shuttered. Lanterns that once lit the cobblestone roads hang dark and cold.",
		"The royal guard — the city's protectors — block their path with weapons drawn. Their eyes are glazed, their movements mechanical. They don't speak. They don't blink.",
		"Someone is controlling them. The stranger is nowhere to be seen.",
	]
	b.post_battle_text = [
		"The guards collapse, released from whatever held them. Their eyes clear and they stare at their own drawn weapons in confusion.",
		"The party pushes deeper into the city. Most doors are barred, most windows dark.",
		"At The Copper Mug tavern, the barkeep is hiding behind the counter. He peers over the edge when the door opens.",
		"'Your friend? The stranger? He went to the tower. Always paid in that weird coin — blank on one side. I should have known something was wrong.'",
		"The tower looms ahead, its peak lost in a sky that shouldn't be that dark this time of day.",
	]
	b.next_battle_id = "StrangerTowerBattle"
	return b


# =============================================================================
# Battle 10: The Tower (THE REVEAL — Stranger escapes at ≤30% HP)
# =============================================================================

static func stranger_tower_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "StrangerTowerBattle"
	b.escape_hp_pct = 0.3
	b.enemies = [
		EnemyDB.create_stranger("The Stranger"),
	]
	b.pre_battle_text = [
		"The tower door stands open. Inside, the walls are covered in the same sigil from the forest — the circle with a slash through it — carved into every surface, floor to ceiling.",
		"The stranger stands at the center of the room, no longer pretending. No smile. No easy charm.",
		"'You served your purpose beautifully. Every battle, every mile — you carried my influence deeper into the wilds. The mirrors, the shadows, the chaos spreading across the land. All me.'",
		"The stranger's form shifts, darkness crackling around them like a storm contained in skin.",
		"'But I'm not done yet.'",
	]
	b.post_battle_text = [
		"The stranger staggers, dark energy bleeding from their wounds. But they don't fall.",
		"They press a hand to the wall and the sigils flare to life, every carved line burning white-hot.",
		"'This isn't over. The ritual is already complete.'",
		"The floor cracks open and shadow pours upward like smoke from a furnace. The stranger steps backward into the void and vanishes.",
		"The tower shudders. Dust rains from the ceiling and the stones groan.",
		"Outside, the sky has turned the color of ash. The horizon ripples like heat off a forge, but the air is cold.",
		"The world is breaking.",
	]
	b.choices = [
		{"label": "City — The city center pulses with necrotic energy.", "battle_id": "CorruptedCityBattle"},
		{"label": "Wilds — The wilderness writhes with darkness.", "battle_id": "CorruptedWildsBattle"},
	]
	return b
