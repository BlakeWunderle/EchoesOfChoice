extends Control

## Story selection screen. Shows available stories with lock state.
## Unlocked stories can be selected to start a new game.

const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const StoryDB := preload("res://scripts/data/story_db.gd")
const Title := preload("res://scenes/title/title.gd")

var _menu: ChoiceMenu
var _stories: Array[Dictionary] = []


func _ready() -> void:
	MusicManager.play_music("res://assets/audio/music/menu/Land of Heroes Alt LOOP.wav")
	_build_ui()
	_show_stories()


func _build_ui() -> void:
	# Background image (reuse title background)
	var bg := TextureRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var bg_path := Title._cached_bg if not Title._cached_bg.is_empty() else "res://assets/art/ui/title_background.png"
	if ResourceLoader.exists(bg_path):
		bg.texture = load(bg_path)
	add_child(bg)

	# Center container
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	var vp_w: float = get_viewport().get_visible_rect().size.x
	vbox.custom_minimum_size.x = clampf(vp_w * 0.55, 500, 900)
	center.add_child(vbox)

	# Header
	var header := Label.new()
	header.text = "SELECT A STORY"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 36)
	header.add_theme_constant_override("outline_size", 2)
	header.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	vbox.add_child(header)

	# Spacer
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 16)
	vbox.add_child(spacer)

	# Menu
	_menu = ChoiceMenu.new()
	_menu.button_min_size = Vector2(480, 64)
	_menu.choice_selected.connect(_on_story_selected)
	vbox.add_child(_menu)


func _show_stories() -> void:
	_stories = StoryDB.get_all_stories()
	var options: Array[Dictionary] = []
	for story: Dictionary in _stories:
		var unlocked: bool = UnlockManager.is_unlocked(story.get("unlock_requirement", ""))
		if unlocked:
			options.append({
				"label": story.get("title", "Unknown"),
				"description": story.get("description", ""),
			})
		else:
			options.append({
				"label": story.get("title", "Unknown") + " (Locked)",
				"description": "Complete a previous story to unlock.",
				"disabled": true,
			})
	options.append({"label": "Back"})
	_menu.show_choices(options)


func _on_story_selected(index: int) -> void:
	if index >= _stories.size():
		# Back
		SceneManager.change_scene("res://scenes/title/title.tscn")
		return
	var story: Dictionary = _stories[index]
	GameState.start_new_game(story.get("story_id", "story_1"))
	SceneManager.change_scene("res://scenes/party_creation/party_creation.tscn")
