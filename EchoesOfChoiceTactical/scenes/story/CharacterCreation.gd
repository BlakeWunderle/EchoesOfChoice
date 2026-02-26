extends Control

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var gender_container: HBoxContainer = $VBoxContainer/GenderContainer
@onready var prince_button: Button = $VBoxContainer/GenderContainer/PrinceButton
@onready var princess_button: Button = $VBoxContainer/GenderContainer/PrincessButton
@onready var name_container: VBoxContainer = $VBoxContainer/NameContainer
@onready var name_input: LineEdit = $VBoxContainer/NameContainer/NameInput
@onready var confirm_button: Button = $VBoxContainer/NameContainer/ConfirmButton
@onready var selection_label: Label = $VBoxContainer/SelectionLabel

var _selected_gender: String = ""
var _sprite_preview: TextureRect = null


func _ready() -> void:
	MusicManager.play_context(MusicManager.MusicContext.MENU)
	name_container.visible = false
	selection_label.visible = false
	prince_button.pressed.connect(_on_prince_selected)
	princess_button.pressed.connect(_on_princess_selected)
	confirm_button.pressed.connect(_on_confirm)
	name_input.text_submitted.connect(func(_t: String): _on_confirm())


func _on_prince_selected() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_selected_gender = "prince"
	selection_label.text = "You have chosen the path of the Prince."
	selection_label.visible = true
	name_container.visible = true
	name_input.placeholder_text = "Enter the Prince's name..."
	name_input.grab_focus()
	prince_button.disabled = false
	princess_button.disabled = false
	prince_button.add_theme_stylebox_override("normal", _highlight_style())
	princess_button.remove_theme_stylebox_override("normal")
	_show_sprite_preview("prince")


func _on_princess_selected() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_selected_gender = "princess"
	selection_label.text = "You have chosen the path of the Princess."
	selection_label.visible = true
	name_container.visible = true
	name_input.placeholder_text = "Enter the Princess's name..."
	name_input.grab_focus()
	prince_button.disabled = false
	princess_button.disabled = false
	princess_button.add_theme_stylebox_override("normal", _highlight_style())
	prince_button.remove_theme_stylebox_override("normal")
	_show_sprite_preview("princess")


func _on_confirm() -> void:
	var player_name := name_input.text.strip_edges()
	if player_name.is_empty():
		return
	if _selected_gender.is_empty():
		return

	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	GameState.set_player_info(player_name, _selected_gender)
	SceneManager.go_to_tutorial_battle()


func _show_sprite_preview(class_id: String) -> void:
	if _sprite_preview:
		_sprite_preview.queue_free()
		_sprite_preview = null
	var data: FighterData = BattleConfig.load_class(class_id)
	if not data:
		return
	var sprite_id := data.sprite_id
	if sprite_id.is_empty():
		return
	var frames := SpriteLoader.get_frames(sprite_id)
	if not frames or not frames.has_animation("idle_down"):
		return
	var tex := frames.get_frame_texture("idle_down", 0)
	if not tex:
		return
	_sprite_preview = TextureRect.new()
	_sprite_preview.texture = tex
	_sprite_preview.custom_minimum_size = Vector2(96, 96)
	_sprite_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_sprite_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	# Insert before name container
	var vbox: VBoxContainer = name_container.get_parent()
	vbox.add_child(_sprite_preview)
	vbox.move_child(_sprite_preview, selection_label.get_index() + 1)


func _highlight_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.3, 0.5, 0.8, 0.4)
	style.border_color = Color(0.4, 0.6, 1.0)
	style.set_border_width_all(2)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(8)
	return style
