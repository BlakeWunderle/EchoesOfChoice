extends Node

## Global game state that persists across scene transitions.

const _BattleDB := preload("res://scripts/data/battle_db.gd")
const _FighterDB := preload("res://scripts/data/fighter_db.gd")
const _StoryDB := preload("res://scripts/data/story_db.gd")
const _Inventory := preload("res://scripts/data/inventory.gd")
const _ItemDB := preload("res://scripts/data/item_db.gd")

enum NarrativeMode { PRE_BATTLE, POST_BATTLE }
enum GamePhase { TITLE, PARTY_CREATION, NARRATIVE, BATTLE, TOWN_STOP, ENDING }

var party: Array = []
var current_battle_id: String = ""
var current_battle: RefCounted  ## BattleData
var previous_battle_id: String = ""
var narrative_mode: NarrativeMode = NarrativeMode.PRE_BATTLE
var game_phase: GamePhase = GamePhase.TITLE
var game_won: bool = false
var battles_won: int = 0
var play_seconds: float = 0.0
var current_story_id: String = "story_1"
var inventory: RefCounted = _Inventory.new()  ## Party-shared items + gold


func start_new_game(story_id: String = "story_1") -> void:
	GameLog.info("New game started (story: %s)" % story_id)
	party.clear()
	current_story_id = story_id
	current_battle_id = ""
	current_battle = null
	previous_battle_id = ""
	narrative_mode = NarrativeMode.PRE_BATTLE
	game_phase = GamePhase.PARTY_CREATION
	game_won = false
	battles_won = 0
	play_seconds = 0.0
	inventory = _Inventory.new()
	inventory.add_item(_ItemDB.minor_salve())
	_update_presence()


func _process(delta: float) -> void:
	if game_phase != GamePhase.TITLE and game_phase != GamePhase.ENDING \
			and not get_tree().paused:
		play_seconds += delta


func get_playtime_display() -> String:
	var total: int = int(play_seconds)
	var h: int = total / 3600
	var m: int = (total % 3600) / 60
	return "%dh %dm" % [h, m]


func get_first_battle_id() -> String:
	var story: Dictionary = _StoryDB.get_story(current_story_id)
	return story.get("first_battle_id", "CityStreetBattle")


func set_party(fighters: Array) -> void:
	party = fighters


func advance_to_battle(battle_id: String) -> void:
	GameLog.info("Battle: %s" % battle_id)
	previous_battle_id = current_battle_id
	current_battle_id = battle_id
	current_battle = _BattleDB.create_battle(battle_id)
	narrative_mode = NarrativeMode.PRE_BATTLE
	if current_battle.is_town_stop:
		game_phase = GamePhase.TOWN_STOP
	else:
		game_phase = GamePhase.NARRATIVE
	_update_presence()


func advance_to_post_battle() -> void:
	battles_won += 1
	# Track battle completion in compendium before achievement check
	if current_battle:
		CompendiumManager.mark_battle_complete(current_battle.battle_id)
	# Check milestone achievements using persistent compendium count
	var total: int = CompendiumManager.get_battles_completed().size()
	if total == 1:
		SteamManager.set_achievement("FIRST_VICTORY")
	if total >= 10:
		SteamManager.set_achievement("TEN_VICTORIES")
	if total >= 50:
		SteamManager.set_achievement("FIFTY_VICTORIES")
	if total >= 100:
		SteamManager.set_achievement("HUNDRED_VICTORIES")
	narrative_mode = NarrativeMode.POST_BATTLE
	game_phase = GamePhase.NARRATIVE
	_update_presence()


func level_up_party() -> void:
	for fighter: RefCounted in party:
		_FighterDB.level_up(fighter)


func upgrade_party_member(fighter: RefCounted, item: String) -> bool:
	return _FighterDB.upgrade_class(fighter, item)


func advance_to_next_battle() -> void:
	if current_battle.next_battle_id.is_empty() or current_battle.is_final_battle:
		game_phase = GamePhase.ENDING
		return
	advance_to_battle(current_battle.next_battle_id)


func advance_with_choice(battle_id: String) -> void:
	advance_to_battle(battle_id)


func go_to_ending(won: bool) -> void:
	GameLog.info("Ending: %s" % ("victory" if won else "defeat"))
	game_won = won
	game_phase = GamePhase.ENDING
	_update_presence()


# =============================================================================
# Steam rich presence
# =============================================================================

const _STORY_NAMES: Dictionary = {
	"story_1": "The Stranger's Shadow",
	"story_2": "Echoes in the Dark",
	"story_3": "The Woven Night",
}

func _update_presence() -> void:
	var story: String = _STORY_NAMES.get(current_story_id, current_story_id)
	match game_phase:
		GamePhase.TITLE:
			SteamManager.set_presence("status", "Main Menu")
		GamePhase.PARTY_CREATION:
			SteamManager.set_presence("status", "Creating party - %s" % story)
		GamePhase.BATTLE:
			SteamManager.set_presence("status", "In battle - %s" % story)
		GamePhase.NARRATIVE:
			SteamManager.set_presence("status", "Exploring - %s" % story)
		GamePhase.TOWN_STOP:
			SteamManager.set_presence("status", "Town stop - %s" % story)
		GamePhase.ENDING:
			SteamManager.set_presence("status", "Story complete - %s" % story)
