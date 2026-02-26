extends Control

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var subtitle_label: Label = $VBoxContainer/SubtitleLabel
@onready var class_grid: GridContainer = $VBoxContainer/ClassGrid
@onready var dialogue_box: Control = $DialogueBox

const CLASS_DATA := {
	"squire": {
		"display_name": "Squire",
		"mentor": "Sir Aldric",
		"description": "A stalwart warrior who leads from the front. High physical attack and defense, with the discipline to protect allies.",
		"abilities": "Slash, Guard",
	},
	"mage": {
		"display_name": "Mage",
		"mentor": "Elara",
		"description": "A wielder of arcane forces who strikes from afar. High magic attack and mana reserves, but fragile up close.",
		"abilities": "Arcane Bolt",
	},
	"entertainer": {
		"display_name": "Entertainer",
		"mentor": "Lyris",
		"description": "A charismatic performer who weakens foes and bolsters allies. Fast and versatile with debuffing magic.",
		"abilities": "Sing, Demoralize",
	},
	"scholar": {
		"display_name": "Scholar",
		"mentor": "Professor Thane",
		"description": "A brilliant mind who exposes weaknesses and unleashes devastating energy. Strong magic with analytical debuffs.",
		"abilities": "Proof, Energy Blast",
	},
}

var _selected_class: String = ""


func _ready() -> void:
	MusicManager.play_context(MusicManager.MusicContext.MENU)
	dialogue_box.visible = false

	# Title + subtitle fade-in
	title_label.modulate.a = 0.0
	subtitle_label.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(title_label, "modulate:a", 1.0, 0.5)
	tween.tween_property(subtitle_label, "modulate:a", 1.0, 0.5)

	_build_class_buttons()


func _build_class_buttons() -> void:
	for class_id in CLASS_DATA:
		var data: Dictionary = CLASS_DATA[class_id]
		var panel := PanelContainer.new()
		panel.custom_minimum_size = Vector2(280, 200)

		var vbox := VBoxContainer.new()
		vbox.add_theme_constant_override("separation", 8)

		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 12)
		margin.add_theme_constant_override("margin_right", 12)
		margin.add_theme_constant_override("margin_top", 12)
		margin.add_theme_constant_override("margin_bottom", 12)

		var mentor_label := Label.new()
		mentor_label.text = data["mentor"]
		mentor_label.add_theme_font_size_override("font_size", 20)
		mentor_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(mentor_label)

		var class_label := Label.new()
		class_label.text = data["display_name"]
		class_label.add_theme_font_size_override("font_size", 14)
		class_label.add_theme_color_override("font_color", Color(0.7, 0.8, 1.0))
		class_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(class_label)

		var desc_label := Label.new()
		desc_label.text = data["description"]
		desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_label.add_theme_font_size_override("font_size", 12)
		desc_label.add_theme_color_override("font_color", Color(0.75, 0.75, 0.75))
		vbox.add_child(desc_label)

		var ability_label := Label.new()
		ability_label.text = "Abilities: " + data["abilities"]
		ability_label.add_theme_font_size_override("font_size", 12)
		ability_label.add_theme_color_override("font_color", Color(0.6, 0.85, 0.6))
		vbox.add_child(ability_label)

		# Sprite preview
		var class_data: FighterData = BattleConfig.load_class(class_id)
		if class_data and not class_data.sprite_id.is_empty():
			var frames := SpriteLoader.get_frames(class_data.sprite_id)
			if frames and frames.has_animation("idle_down"):
				var tex := frames.get_frame_texture("idle_down", 0)
				if tex:
					var preview := TextureRect.new()
					preview.texture = tex
					preview.custom_minimum_size = Vector2(64, 64)
					preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
					preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
					vbox.add_child(preview)

		var btn := Button.new()
		btn.text = "Train with " + data["mentor"]
		btn.size_flags_vertical = Control.SIZE_SHRINK_END
		var cid := class_id
		btn.pressed.connect(func(): _on_class_selected(cid))
		vbox.add_child(btn)

		margin.add_child(vbox)
		panel.add_child(margin)
		class_grid.add_child(panel)


func _on_class_selected(class_id: String) -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	_selected_class = class_id
	var data: Dictionary = CLASS_DATA[class_id]

	GameState.set_player_class(class_id)
	GameState.set_flag("class_chosen")

	var royal_title := "Prince" if GameState.player_gender == "prince" else "Princess"
	var lines: Array[Dictionary] = [
		{"speaker": data["mentor"], "text": "An excellent choice, %s %s." % [royal_title, GameState.player_name]},
		{"speaker": data["mentor"], "text": "I will teach you everything I know about the ways of the %s." % data["display_name"]},
		{"speaker": GameState.player_name, "text": "Thank you, %s. I won't let you down." % data["mentor"]},
		{"speaker": data["mentor"], "text": "The kingdom is counting on you. Let us proceed to the throne room."},
	]

	for child in class_grid.get_children():
		child.queue_free()
	title_label.text = "The %s chooses the path of the %s" % [royal_title, data["display_name"]]
	subtitle_label.visible = false

	dialogue_box.visible = true
	dialogue_box.show_dialogue(lines)
	await dialogue_box.dialogue_finished
	SceneManager.go_to_throne_room()
