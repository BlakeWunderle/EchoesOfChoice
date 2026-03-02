class_name BattleData extends RefCounted

## Configuration for a single battle encounter.

var battle_id: String
var enemies: Array[FighterData] = []
var pre_battle_text: Array[String] = []
var post_battle_text: Array[String] = []
var is_final_battle: bool = false
var is_town_stop: bool = false
var next_battle_id: String = ""  ## Empty if branching or final
var music_track: String = ""  ## Explicit music path for this battle
