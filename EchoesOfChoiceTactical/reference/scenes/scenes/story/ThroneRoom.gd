extends Control

@onready var background: ColorRect = $Background
@onready var scene_label: Label = $SceneLabel
@onready var dialogue_box: Control = $DialogueBox

const MENTOR_NAMES := {
	"squire": "Sir Aldric",
	"mage": "Elara",
	"entertainer": "Lyris",
	"tinker": "Professor Thane",
	"wildling": "Thorne",
}

const CLASS_NAMES := {
	"squire": "Squire",
	"mage": "Mage",
	"entertainer": "Entertainer",
	"tinker": "Tinker",
	"wildling": "Wildling",
}


func _ready() -> void:
	MusicManager.play_music("res://assets/audio/music/cutscene/#14.wav")
	var mentor: String = MENTOR_NAMES.get(GameState.player_class_id, "Mentor")
	var class_name_str: String = CLASS_NAMES.get(GameState.player_class_id, "warrior")
	var royal_title := "Prince" if GameState.player_gender == "prince" else "Princess"
	var player := GameState.player_name

	# Scene label fade-in
	scene_label.text = "The Throne Room"
	scene_label.modulate.a = 0.0
	var label_tween := create_tween()
	label_tween.tween_property(scene_label, "modulate:a", 1.0, 0.8)
	await label_tween.finished

	# Mentor dialogue
	var mentor_lines: Array[Dictionary] = [
		{"speaker": mentor, "text": "Welcome to the throne room, %s %s." % [royal_title, player]},
		{"speaker": mentor, "text": "You've shown great promise in your training. As a %s, you will serve the kingdom well." % class_name_str},
		{"speaker": player, "text": "I will do my best to honor the crown and protect our people."},
		{"speaker": mentor, "text": "I know you will. But there is something I must tell you—"},
		{"speaker": "???", "text": "Forgive the interruption."},
	]

	dialogue_box.show_dialogue(mentor_lines)
	await dialogue_box.dialogue_finished

	# Dramatic stranger entrance
	await get_tree().create_timer(0.6).timeout

	var darken_overlay := ColorRect.new()
	darken_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	darken_overlay.color = Color(0.0, 0.0, 0.0, 0.0)
	darken_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(darken_overlay)
	move_child(darken_overlay, dialogue_box.get_index())

	var darken_tween := create_tween()
	darken_tween.tween_property(darken_overlay, "color:a", 0.3, 0.5)
	await darken_tween.finished

	SFXManager.play(SFXManager.Category.VORTEX, 0.5)

	# Subtle screen shake
	var orig_pos := background.position
	var shake_tween := create_tween()
	for i in range(6):
		var offset := Vector2(randf_range(-3, 3), randf_range(-2, 2))
		shake_tween.tween_property(background, "position", orig_pos + offset, 0.04)
	shake_tween.tween_property(background, "position", orig_pos, 0.04)
	await shake_tween.finished

	# Stranger dialogue
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

	# Fade out the darken overlay
	var fade_tween := create_tween()
	fade_tween.tween_property(darken_overlay, "color:a", 0.0, 0.3)
	await fade_tween.finished
	darken_overlay.queue_free()

	GameState.set_flag("stranger_met")
	GameState.auto_save()
	SceneManager.go_to_barracks()
