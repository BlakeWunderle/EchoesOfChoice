extends Control

@onready var title_label: Label = $CenterContainer/VBoxContainer/TitleLabel
@onready var subtitle_label: Label = $CenterContainer/VBoxContainer/SubtitleLabel
@onready var prompt_label: Label = $CenterContainer/VBoxContainer/PromptLabel

var _ready_to_proceed: bool = false


func _ready() -> void:
	title_label.modulate.a = 0.0
	subtitle_label.modulate.a = 0.0
	prompt_label.modulate.a = 0.0
	_play_reveal()


func _play_reveal() -> void:
	await get_tree().create_timer(0.5).timeout

	var tween := create_tween()
	tween.tween_property(title_label, "modulate:a", 1.0, 2.0)
	await tween.finished

	await get_tree().create_timer(0.5).timeout

	var tween2 := create_tween()
	tween2.tween_property(subtitle_label, "modulate:a", 1.0, 1.5)
	await tween2.finished

	await get_tree().create_timer(1.0).timeout

	var tween3 := create_tween()
	tween3.set_loops()
	tween3.tween_property(prompt_label, "modulate:a", 1.0, 0.8)
	tween3.tween_property(prompt_label, "modulate:a", 0.3, 0.8)

	_ready_to_proceed = true


func _input(event: InputEvent) -> void:
	if not _ready_to_proceed:
		return
	if (event is InputEventKey and event.pressed) or (event is InputEventMouseButton and event.pressed):
		_ready_to_proceed = false
		GameState.current_battle_id = ""
		SceneManager.change_scene("res://scenes/battle/BattleMap.tscn")
