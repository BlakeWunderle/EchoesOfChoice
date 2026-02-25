extends Control

const _GOLD := Color(0.85, 0.75, 0.45)
const _DIM := Color(0.6, 0.6, 0.65)
const _SECTION_SIZE := 22
const _BODY_SIZE := 15

var _container: MarginContainer
var _back_btn: Button


func _ready() -> void:
	MusicManager.play_context(MusicManager.MusicContext.MENU)
	_build_ui()
	_play_reveal()


func _build_ui() -> void:
	_container = MarginContainer.new()
	_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	_container.add_theme_constant_override("margin_left", 200)
	_container.add_theme_constant_override("margin_top", 40)
	_container.add_theme_constant_override("margin_right", 200)
	_container.add_theme_constant_override("margin_bottom", 40)
	_container.modulate.a = 0.0
	add_child(_container)

	var outer_vbox := VBoxContainer.new()
	outer_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_container.add_child(outer_vbox)

	# Title
	var title := Label.new()
	title.text = "CREDITS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 36)
	title.add_theme_color_override("font_color", _GOLD)
	outer_vbox.add_child(title)

	_add_spacer(outer_vbox, 16)

	# Scrollable credits body
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	outer_vbox.add_child(scroll)

	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 6)
	scroll.add_child(content)

	_build_credits_content(content)

	_add_spacer(outer_vbox, 12)

	# Back button
	_back_btn = Button.new()
	_back_btn.text = "Back"
	_back_btn.custom_minimum_size = Vector2(220, 48)
	_back_btn.focus_mode = Control.FOCUS_ALL
	_back_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_back_btn.pressed.connect(_on_back_pressed)
	outer_vbox.add_child(_back_btn)


func _build_credits_content(parent: VBoxContainer) -> void:
	_add_section(parent, "ECHOES OF CHOICE: TACTICAL")
	_add_body(parent, "A tactical RPG with grid-based combat, elevation, and role-based reactions.")
	_add_spacer(parent, 20)

	_add_section(parent, "ENGINE")
	_add_body(parent, "Godot Engine 4.6")
	_add_body(parent, "Copyright (c) 2014-present Godot Engine contributors")
	_add_body(parent, "License: MIT License")
	_add_body(parent, "https://godotengine.org")
	_add_spacer(parent, 20)

	_add_section(parent, "ART ASSETS")
	_add_body(parent, "Character sprites, tilesets, enemies, NPCs, and UI elements")
	_add_body(parent, "Asset packs by CraftPix.net")
	_add_body(parent, "CraftPix Standard License")
	_add_body(parent, "https://craftpix.net/file-licenses/")
	_add_spacer(parent, 20)

	_add_section(parent, "FONTS")
	_add_body(parent, "Oswald Bold by Vernon Adams, Kalapi, Cyreal")
	_add_body(parent, "License: SIL Open Font License 1.1")
	_add_body(parent, "https://opensource.org/licenses/OFL-1.1")
	_add_spacer(parent, 10)
	_add_body(parent, "TinyFontCraftpixPixel by CraftPix.net")
	_add_body(parent, "Included in the CraftPix Roguelike Kit pack")


func _add_section(parent: VBoxContainer, text: String) -> void:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", _SECTION_SIZE)
	label.add_theme_color_override("font_color", _GOLD)
	parent.add_child(label)


func _add_body(parent: VBoxContainer, text: String) -> void:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", _BODY_SIZE)
	label.add_theme_color_override("font_color", _DIM)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	parent.add_child(label)


func _add_spacer(parent: VBoxContainer, height: float) -> void:
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, height)
	parent.add_child(spacer)


func _play_reveal() -> void:
	var tween := create_tween()
	tween.tween_property(_container, "modulate:a", 1.0, 0.6)
	await tween.finished
	_back_btn.grab_focus()


func _on_back_pressed() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	SceneManager.go_to_title_screen()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		SFXManager.play(SFXManager.Category.UI_CANCEL, 0.5)
		SceneManager.go_to_title_screen()
