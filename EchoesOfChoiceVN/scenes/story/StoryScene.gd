extends Control

## Generic story scene that plays VN dialogue lines and advances the story flow.

const DialogueBoxScene = preload("res://scenes/ui/DialogueBox.tscn")

var _dialogue_box: Control
var _beat: Dictionary = {}


func _ready() -> void:
	MusicManager.play_context(MusicManager.MusicContext.CUTSCENE)


func start_beat(beat: Dictionary) -> void:
	_beat = beat
	var lines := beat.get("lines", [])
	if lines.is_empty():
		_finish()
		return

	_dialogue_box = DialogueBoxScene.instantiate()
	add_child(_dialogue_box)
	_dialogue_box.dialogue_finished.connect(_finish)

	var typed_lines: Array[Dictionary] = []
	for line in lines:
		typed_lines.append(line)
	_dialogue_box.show_dialogue(typed_lines)


func _finish() -> void:
	StoryFlow.advance()
