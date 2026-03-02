class_name BattleDB

## Static factory for battle configurations.
## Narrative text copied from C# battle classes.


static func create_battle(battle_id: String) -> BattleData:
	match battle_id:
		"CityStreetBattle": return city_street_battle()
		_:
			push_error("Unknown battle: %s" % battle_id)
			return city_street_battle()


static func city_street_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "CityStreetBattle"
	b.enemies = [
		FighterDB.create_thug("Alexander"),
		FighterDB.create_ruffian("Jenna"),
		FighterDB.create_pickpocket("Ella"),
	]
	b.pre_battle_text = [
		"Our newly formed party leaves the tavern happy and full of drink and food, ready to set out on an adventure.",
		"The city streets are quiet this late at night. Lanterns flicker along the cobblestone road toward the forest gate.",
		"A little too quiet. After walking a few blocks a handful of street urchins step out of the shadows and surround the party.",
		"Looks like the adventure is starting early.",
	]
	b.post_battle_text = [
		"The street gang scatters into the alleyways and the party dusts themselves off.",
		"The stranger nods approvingly. 'See? The darkness is already here, in the city itself. Imagine what waits beyond the walls.'",
		"They push through the city gate and the tree line swallows the road ahead.",
	]
	b.is_final_battle = false
	b.next_battle_id = "WolfForestBattle"
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Weeping Walls.ogg"
	return b
