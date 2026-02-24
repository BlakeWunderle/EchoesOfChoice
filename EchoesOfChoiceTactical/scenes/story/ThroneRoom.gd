extends Control

@onready var scene_label: Label = $SceneLabel
@onready var dialogue_box: Control = $DialogueBox

const MENTOR_NAMES := {
	"squire": "Sir Aldric",
	"mage": "Elara",
	"entertainer": "Lyris",
	"scholar": "Professor Thane",
}

const CLASS_NAMES := {
	"squire": "Squire",
	"mage": "Mage",
	"entertainer": "Entertainer",
	"scholar": "Scholar",
}


func _ready() -> void:
	MusicManager.play_context(MusicManager.MusicContext.CUTSCENE)
	var mentor: String = MENTOR_NAMES.get(GameState.player_class_id, "Mentor")
	var class_name_str: String = CLASS_NAMES.get(GameState.player_class_id, "warrior")
	var royal_title := "Prince" if GameState.player_gender == "prince" else "Princess"
	var player := GameState.player_name

	scene_label.text = "The Throne Room"

	var mentor_lines: Array[Dictionary] = [
		{"speaker": mentor, "text": "Welcome to the throne room, %s %s." % [royal_title, player]},
		{"speaker": mentor, "text": "You've shown great promise in your training. As a %s, you will serve the kingdom well." % class_name_str},
		{"speaker": player, "text": "I will do my best to honor the crown and protect our people."},
		{"speaker": mentor, "text": "I know you will. But there is something I must tell you—"},
		{"speaker": "???", "text": "Forgive the interruption."},
	]

	dialogue_box.show_dialogue(mentor_lines)
	await dialogue_box.dialogue_finished

	var stranger_lines: Array[Dictionary] = [
		{"speaker": "Cloaked Stranger", "text": "I have traveled far to bring a warning to the throne."},
		{"speaker": player, "text": "Who are you? How did you get past the guards?"},
		{"speaker": "Cloaked Stranger", "text": "My name is not important. What matters is what I've seen."},
		{"speaker": "Cloaked Stranger", "text": "A darkness gathers beyond the borders. Forces that haven't moved in centuries are stirring."},
		{"speaker": "Cloaked Stranger", "text": "The old wards are failing. Your kingdom will be the first to fall — unless you act."},
		{"speaker": mentor, "text": "These are serious claims. Do you have proof?"},
		{"speaker": "Cloaked Stranger", "text": "The proof will come whether you believe me or not. I only ask that you prepare."},
		{"speaker": "Cloaked Stranger", "text": "Assemble a guard. Travel beyond the walls. See the truth for yourself."},
		{"speaker": player, "text": "...I'll gather a team from the barracks. If what you say is true, we need to be ready."},
		{"speaker": mentor, "text": "Then go, %s %s. Choose your companions wisely." % [royal_title, player]},
	]

	dialogue_box.show_dialogue(stranger_lines)
	await dialogue_box.dialogue_finished

	GameState.set_flag("stranger_met")
	SceneManager.go_to_barracks()
