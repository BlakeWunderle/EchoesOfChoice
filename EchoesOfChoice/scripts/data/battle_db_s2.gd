class_name BattleDBS2

## Story 2 battle configurations. Placeholder content for framework testing.

const BattleData := preload("res://scripts/data/battle_data.gd")
const EnemyDB := preload("res://scripts/data/enemy_db.gd")


static func create_battle(battle_id: String) -> BattleData:
	match battle_id:
		"S2_OpeningBattle": return s2_opening_battle()
		_:
			push_error("Unknown Story 2 battle: %s" % battle_id)
			return s2_opening_battle()


static func s2_opening_battle() -> BattleData:
	var b := BattleData.new()
	b.battle_id = "S2_OpeningBattle"
	b.enemies = [
		EnemyDB.create_thug("Test Enemy"),
	]
	b.pre_battle_text = [
		"Story 2 placeholder. This content will be replaced.",
		"For now, defeat this enemy to test the multi-story framework.",
	]
	b.post_battle_text = [
		"Story 2 framework test complete.",
	]
	b.is_final_battle = true
	b.music_track = "res://assets/audio/music/battle/Fantasy Tension - Weeping Walls.ogg"
	b.cutscene_track = "res://assets/audio/music/cutscene/#2.wav"
	return b
