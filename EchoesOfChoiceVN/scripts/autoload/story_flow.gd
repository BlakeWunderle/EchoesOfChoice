extends Node

## Linear story progression — routes between battles, story beats, and towns.
## Each entry is a "beat" with a type (battle/town/story/class_upgrade) and data.

const STORY_BEATS: Array[Dictionary] = [
	# Prog 0: Opening
	{"type": "story", "id": "pre_city_street", "next_battle": "city_street",
	 "lines": [
		{"speaker": "", "text": "Your party leaves the tavern and heads into the city streets."},
		{"speaker": "", "text": "The night air is thick with tension. Shadows move in the alleyways."},
		{"speaker": "Stranger", "text": "Be on your guard. The streets ahead are not safe."},
	]},
	{"type": "battle", "id": "city_street", "progression": 0},
	{"type": "story", "id": "post_city_street",
	 "lines": [
		{"speaker": "", "text": "The street toughs scatter into the darkness."},
		{"speaker": "", "text": "A forest path lies ahead, winding into ancient woods."},
	]},

	# Prog 1: Forest + Village
	{"type": "battle", "id": "forest", "progression": 1},
	{"type": "story", "id": "post_forest",
	 "lines": [
		{"speaker": "", "text": "The forest guardians fall. Something deeper drove them to attack."},
		{"speaker": "", "text": "Through the trees, smoke rises from a small village."},
	]},
	{"type": "town", "id": "village"},
	{"type": "class_upgrade", "id": "tier1_choice"},

	# Prog 2: Branch battles
	{"type": "story", "id": "pre_smoke",
	 "lines": [
		{"speaker": "", "text": "Following the village elder's directions, you head toward the smoke."},
		{"speaker": "", "text": "The air grows acrid. A dark ritual was performed here."},
	]},
	{"type": "battle", "id": "smoke", "progression": 2},
	{"type": "story", "id": "pre_portal",
	 "lines": [
		{"speaker": "", "text": "A rift crackles with dark energy. Something holds it open."},
	]},
	{"type": "battle", "id": "portal", "progression": 2},

	# Prog 3: Crossroads
	{"type": "story", "id": "post_portal",
	 "lines": [
		{"speaker": "", "text": "The portal collapses behind you. A crossroads inn appears ahead."},
		{"speaker": "", "text": "A warm fire and the smell of bread greet you."},
	]},
	{"type": "town", "id": "port_town"},

	# Prog 4: Mid-game path
	{"type": "story", "id": "pre_cemetery",
	 "lines": [
		{"speaker": "", "text": "Leaving the crossroads, you follow the southern road."},
		{"speaker": "", "text": "Gravestones line both sides of the path. The dead stir."},
	]},
	{"type": "battle", "id": "cemetery", "progression": 4},
	{"type": "story", "id": "pre_carnival",
	 "lines": [
		{"speaker": "", "text": "Beyond the cemetery, carnival lights flicker in the mist."},
		{"speaker": "", "text": "A ringmaster awaits with an unsettling smile."},
	]},
	{"type": "battle", "id": "carnival", "progression": 4},

	# Prog 5: Mirror + Gate Town
	{"type": "story", "id": "pre_mirror",
	 "lines": [
		{"speaker": "", "text": "All roads converge at the Mirror — a vast reflecting pool."},
		{"speaker": "", "text": "Elite shadow warriors stand guard. This is the final barrier."},
	]},
	{"type": "battle", "id": "mirror", "progression": 5},
	{"type": "story", "id": "post_mirror",
	 "lines": [
		{"speaker": "", "text": "The shadow forces break. Gate Town lies just ahead."},
		{"speaker": "", "text": "Last chance to prepare before storming the city."},
	]},
	{"type": "town", "id": "capital"},
	{"type": "class_upgrade", "id": "tier2_choice"},

	# Prog 6: City gate
	{"type": "story", "id": "pre_city_gate",
	 "lines": [
		{"speaker": "", "text": "The city gates loom before you. Shadow agents have infiltrated."},
		{"speaker": "", "text": "A gorgon queen has crowned herself ruler of the occupied city."},
	]},
	{"type": "battle", "id": "city_gate", "progression": 6},
	{"type": "story", "id": "pre_return_city",
	 "lines": [
		{"speaker": "", "text": "The gates fall. The four districts await liberation."},
	]},
	{"type": "battle", "id": "return_city_1", "progression": 6},

	# Prog 7: Elemental shrines
	{"type": "story", "id": "pre_shrines",
	 "lines": [
		{"speaker": "", "text": "Four elemental shrines pulse with power across the city."},
		{"speaker": "", "text": "A hooded figure watches from a rooftop, then vanishes."},
	]},
	{"type": "battle", "id": "shrine_fire", "progression": 7, "music": "boss"},
	{"type": "battle", "id": "shrine_water", "progression": 7, "music": "boss"},
	{"type": "battle", "id": "shrine_wind", "progression": 7, "music": "boss"},
	{"type": "battle", "id": "shrine_earth", "progression": 7, "music": "boss"},

	# Prog 8: Finale
	{"type": "story", "id": "pre_finale",
	 "lines": [
		{"speaker": "", "text": "The shrines are sealed. The path to the castle opens."},
		{"speaker": "Stranger", "text": "You made it. All of you. I watched every step."},
		{"speaker": "Stranger", "text": "The city needed defenders, not mourners. I built the trials."},
		{"speaker": "Stranger", "text": "You passed them."},
	]},
	{"type": "battle", "id": "final_castle", "progression": 8, "music": "boss"},
	{"type": "story", "id": "ending",
	 "lines": [
		{"speaker": "Stranger", "text": "The city is safe. You have proven that."},
		{"speaker": "Stranger", "text": "Whatever comes next — you are ready for it."},
		{"speaker": "", "text": "Every choice left an echo. Yours will ring through the ages."},
		{"speaker": "", "text": "THE END"},
	]},
	{"type": "credits"},
]

var current_beat_index: int = 0


func _ready() -> void:
	pass


func get_current_beat() -> Dictionary:
	if current_beat_index >= STORY_BEATS.size():
		return {"type": "credits"}
	return STORY_BEATS[current_beat_index]


func advance() -> void:
	current_beat_index += 1
	_process_beat()


func go_to_beat(beat_id: String) -> void:
	for i in range(STORY_BEATS.size()):
		if STORY_BEATS[i].get("id", "") == beat_id:
			current_beat_index = i
			_process_beat()
			return
	push_error("StoryFlow: Beat '%s' not found" % beat_id)


func _process_beat() -> void:
	var beat := get_current_beat()
	match beat.get("type", ""):
		"battle":
			GameState.current_battle_id = beat["id"]
			if beat.has("progression"):
				GameState.advance_progression(beat["progression"])
			SceneManager.go_to_battle()
		"town":
			GameState.current_town_id = beat["id"]
			SceneManager.go_to_town(beat["id"])
		"story":
			_start_story_scene(beat)
		"class_upgrade":
			# Skip for now if no one can promote
			if GameState.has_any_promotable_member():
				_start_story_scene({
					"id": beat["id"],
					"lines": [
						{"speaker": "", "text": "Your party has grown stronger. Time to specialize."},
					],
				})
			else:
				advance()
		"credits":
			SceneManager.go_to_title_screen()


func _start_story_scene(beat: Dictionary) -> void:
	SceneManager.change_scene("res://scenes/story/StoryScene.tscn")
	await SceneManager.transition_finished
	var scene := get_tree().current_scene
	if scene and scene.has_method("start_beat"):
		scene.start_beat(beat)


func save_progress() -> Dictionary:
	return {"beat_index": current_beat_index}


func load_progress(data: Dictionary) -> void:
	current_beat_index = data.get("beat_index", 0)
