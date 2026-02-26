extends Control

@onready var scene_label: Label = $SceneLabel
@onready var dialogue_box: Control = $DialogueBox
@onready var selection_panel: PanelContainer = $SelectionPanel
@onready var selection_content: VBoxContainer = $SelectionPanel/MarginContainer/Content
@onready var npc_display: Control = $NPCDisplay
@onready var name_panel: PanelContainer = $NamePanel
@onready var name_input: LineEdit = $NamePanel/MarginContainer/VBox/NameInput
@onready var name_confirm: Button = $NamePanel/MarginContainer/VBox/ConfirmButton

const CLASS_INFO := {
	"squire": {
		"display_name": "Squire",
		"description": "A melee fighter with strong physical attack and defense. Uses Slash and Guard.",
		"color": Color(0.6, 0.4, 0.2),
	},
	"mage": {
		"display_name": "Mage",
		"description": "A ranged magic user with high magic attack and mana. Casts Arcane Bolt.",
		"color": Color(0.3, 0.3, 0.8),
	},
	"entertainer": {
		"display_name": "Entertainer",
		"description": "A fast support unit that debuffs enemies with Sing and Demoralize.",
		"color": Color(0.7, 0.3, 0.6),
	},
	"scholar": {
		"display_name": "Scholar",
		"description": "A magic specialist with Proof to weaken defenses and Energy Blast for damage.",
		"color": Color(0.2, 0.6, 0.5),
	},
}

var _guards_recruited: int = 0
var _current_class: String = ""
var _current_gender: String = ""
var _name_submitted: bool = false
var _entered_name: String = ""


func _ready() -> void:
	MusicManager.play_context(MusicManager.MusicContext.MENU)
	selection_panel.visible = false
	name_panel.visible = false
	dialogue_box.visible = false
	name_confirm.pressed.connect(_on_name_confirmed)
	name_input.text_submitted.connect(func(_t: String): _on_name_confirmed())

	# Scene label fade-in
	scene_label.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(scene_label, "modulate:a", 1.0, 0.6)

	_populate_npc_display()
	_start_recruitment()


func _populate_npc_display() -> void:
	var npc_configs := [
		{"x": 80, "y": 140, "class_id": "squire", "gender": "male", "label": "Squire"},
		{"x": 200, "y": 180, "class_id": "mage", "gender": "male", "label": "Mage"},
		{"x": 350, "y": 120, "class_id": "entertainer", "gender": "female", "label": "Ent."},
		{"x": 500, "y": 170, "class_id": "scholar", "gender": "male", "label": "Scholar"},
		{"x": 650, "y": 130, "class_id": "squire", "gender": "female", "label": "Squire"},
		{"x": 800, "y": 160, "class_id": "mage", "gender": "female", "label": "Mage"},
	]

	for cfg in npc_configs:
		var sprite_tex := _get_class_sprite(cfg["class_id"], cfg["gender"])
		if sprite_tex:
			var tex_rect := TextureRect.new()
			tex_rect.texture = sprite_tex
			tex_rect.custom_minimum_size = Vector2(48, 48)
			tex_rect.position = Vector2(cfg["x"], cfg["y"])
			tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			npc_display.add_child(tex_rect)
		else:
			var rect := ColorRect.new()
			rect.size = Vector2(32, 48)
			rect.position = Vector2(cfg["x"], cfg["y"])
			rect.color = CLASS_INFO[cfg["class_id"]]["color"]
			npc_display.add_child(rect)

		var lbl := Label.new()
		lbl.text = cfg["label"]
		lbl.position = Vector2(cfg["x"] - 8, cfg["y"] + 50)
		lbl.add_theme_font_size_override("font_size", 10)
		lbl.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		npc_display.add_child(lbl)

	for i in range(4):
		var bed := ColorRect.new()
		bed.size = Vector2(80, 24)
		bed.position = Vector2(100 + i * 200, 230)
		bed.color = Color(0.25, 0.18, 0.12)
		npc_display.add_child(bed)


func _start_recruitment() -> void:
	var royal_title := "Prince" if GameState.player_gender == "prince" else "Princess"
	var intro_lines: Array[Dictionary] = [
		{"speaker": GameState.player_name, "text": "Soldiers of the Royal Guard, I need volunteers for a critical mission beyond the walls."},
		{"speaker": GameState.player_name, "text": "I will personally select four of you to join me. Step forward if you are ready to serve."},
	]

	dialogue_box.visible = true
	dialogue_box.show_dialogue(intro_lines)
	await dialogue_box.dialogue_finished
	dialogue_box.visible = false

	_recruit_next_guard()


func _recruit_next_guard() -> void:
	if _guards_recruited >= 4:
		_finish_recruitment()
		return

	var ordinal := ["first", "second", "third", "fourth"][_guards_recruited]
	scene_label.text = "Barracks — Choose your %s guard" % ordinal

	_show_class_selection()


func _show_class_selection() -> void:
	_clear_selection_content()
	selection_panel.visible = true

	var header := Label.new()
	header.text = "Choose a class for this guard:"
	header.add_theme_font_size_override("font_size", 18)
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	selection_content.add_child(header)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)

	for class_id in CLASS_INFO:
		var info: Dictionary = CLASS_INFO[class_id]
		var panel := PanelContainer.new()
		panel.custom_minimum_size = Vector2(300, 100)

		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 10)
		margin.add_theme_constant_override("margin_right", 10)
		margin.add_theme_constant_override("margin_top", 8)
		margin.add_theme_constant_override("margin_bottom", 8)

		var vbox := VBoxContainer.new()

		var name_lbl := Label.new()
		name_lbl.text = info["display_name"]
		name_lbl.add_theme_font_size_override("font_size", 16)
		name_lbl.add_theme_color_override("font_color", info["color"].lightened(0.3))
		vbox.add_child(name_lbl)

		var desc_lbl := Label.new()
		desc_lbl.text = info["description"]
		desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_lbl.add_theme_font_size_override("font_size", 11)
		desc_lbl.add_theme_color_override("font_color", Color(0.75, 0.75, 0.75))
		vbox.add_child(desc_lbl)

		var btn := Button.new()
		btn.text = "Select " + info["display_name"]
		var cid := class_id
		btn.pressed.connect(func(): _on_guard_class_selected(cid))
		vbox.add_child(btn)

		margin.add_child(vbox)
		panel.add_child(margin)
		grid.add_child(panel)

	selection_content.add_child(grid)


func _on_guard_class_selected(class_id: String) -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_current_class = class_id
	_show_gender_selection()


func _show_gender_selection() -> void:
	_clear_selection_content()

	var info: Dictionary = CLASS_INFO[_current_class]

	var header := Label.new()
	header.text = "Choose a %s:" % info["display_name"]
	header.add_theme_font_size_override("font_size", 18)
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	selection_content.add_child(header)

	var btn_container := HBoxContainer.new()
	btn_container.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_container.add_theme_constant_override("separation", 40)

	var male_panel := _create_gender_option("Male", info["display_name"], info["color"], "male")
	btn_container.add_child(male_panel)

	var female_panel := _create_gender_option("Female", info["display_name"], info["color"].lightened(0.15), "female")
	btn_container.add_child(female_panel)

	selection_content.add_child(btn_container)

	var back_btn := Button.new()
	back_btn.text = "Back"
	back_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	back_btn.pressed.connect(func():
		SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
		_show_class_selection()
	)
	selection_content.add_child(back_btn)


func _create_gender_option(gender_label: String, class_name_str: String, color: Color, gender_id: String) -> VBoxContainer:
	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER

	var sprite_tex := _get_class_sprite(_current_class, gender_id)
	if sprite_tex:
		var preview := TextureRect.new()
		preview.texture = sprite_tex
		preview.custom_minimum_size = Vector2(64, 96)
		preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		vbox.add_child(preview)
	else:
		var portrait := ColorRect.new()
		portrait.custom_minimum_size = Vector2(64, 96)
		portrait.color = color
		portrait.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		vbox.add_child(portrait)

	var lbl := Label.new()
	lbl.text = gender_label + " " + class_name_str
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.add_theme_font_size_override("font_size", 14)
	vbox.add_child(lbl)

	var btn := Button.new()
	btn.text = "Select"
	btn.custom_minimum_size = Vector2(120, 36)
	btn.pressed.connect(func(): _on_gender_selected(gender_id))
	vbox.add_child(btn)

	return vbox


func _on_gender_selected(gender: String) -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_current_gender = gender
	selection_panel.visible = false
	_ask_for_name()


func _ask_for_name() -> void:
	var royal_title := "Prince" if GameState.player_gender == "prince" else "Princess"
	var info: Dictionary = CLASS_INFO[_current_class]
	var gender_str := "man" if _current_gender == "male" else "woman"

	var lines: Array[Dictionary] = [
		{"speaker": GameState.player_name, "text": "You there — the %s %s. Step forward." % [info["display_name"].to_lower(), gender_str]},
		{"speaker": GameState.player_name, "text": "I would have you join my company. What is your name, soldier?"},
	]

	dialogue_box.visible = true
	dialogue_box.show_dialogue(lines)
	await dialogue_box.dialogue_finished
	dialogue_box.visible = false

	name_panel.visible = true
	name_input.text = ""
	name_input.placeholder_text = "Enter the guard's name..."
	name_input.grab_focus()
	_name_submitted = false

	await _wait_for_name()

	name_panel.visible = false

	var guard_name := _entered_name

	var welcome_lines: Array[Dictionary] = [
		{"speaker": guard_name, "text": "It would be my honor, %s %s." % [royal_title, GameState.player_name]},
		{"speaker": GameState.player_name, "text": "Welcome to the company, %s." % guard_name},
	]

	dialogue_box.visible = true
	dialogue_box.show_dialogue(welcome_lines)
	await dialogue_box.dialogue_finished
	dialogue_box.visible = false

	GameState.add_party_member(guard_name, _current_gender, _current_class)
	_guards_recruited += 1
	_current_class = ""
	_current_gender = ""

	_recruit_next_guard()


func _on_name_confirmed() -> void:
	var n := name_input.text.strip_edges()
	if n.is_empty():
		return
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	_entered_name = n
	_name_submitted = true


func _wait_for_name() -> void:
	while not _name_submitted:
		await get_tree().process_frame


func _finish_recruitment() -> void:
	var royal_title := "Prince" if GameState.player_gender == "prince" else "Princess"
	var names: PackedStringArray = []
	for member in GameState.party_members:
		names.append(member["name"])

	var closing_lines: Array[Dictionary] = [
		{"speaker": GameState.player_name, "text": "This is my company: %s." % ", ".join(names)},
		{"speaker": GameState.player_name, "text": "Together, we ride beyond the walls. For the kingdom."},
	]

	dialogue_box.visible = true
	dialogue_box.show_dialogue(closing_lines)
	await dialogue_box.dialogue_finished

	GameState.set_flag("party_formed")
	GameState.auto_save()
	SceneManager.go_to_overworld()


func _get_class_sprite(class_id: String, gender: String) -> Texture2D:
	var data: FighterData = BattleConfig.load_class(class_id)
	if not data:
		return null
	var sid := data.sprite_id
	if gender in ["female", "princess"] and not data.sprite_id_female.is_empty():
		sid = data.sprite_id_female
	if sid.is_empty():
		return null
	var frames := SpriteLoader.get_frames(sid)
	if not frames or not frames.has_animation("idle_down"):
		return null
	return frames.get_frame_texture("idle_down", 0)


func _clear_selection_content() -> void:
	for child in selection_content.get_children():
		child.queue_free()
