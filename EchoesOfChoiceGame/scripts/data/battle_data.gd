class_name BattleData extends RefCounted

## Configuration for a single battle encounter.

var battle_id: String
var enemies: Array = []  ## Array of FighterData
var pre_battle_text: Array[String] = []
var post_battle_text: Array[String] = []
var is_final_battle: bool = false
var is_town_stop: bool = false
var next_battle_id: String = ""
var choices: Array[Dictionary] = []  ## [{label: String, battle_id: String}] for branching
var escape_hp_pct: float = 0.0  ## >0 means boss escapes at this HP%, counts as victory
var music_track: String = ""  ## Explicit music path for this battle
