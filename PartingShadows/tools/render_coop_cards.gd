extends SceneTree

## Renders two cards for the co-op trailer:
##   1. Title card: "PARTING SHADOWS" + "Local & Online Co-op" (no CTA)
##   2. End card:   "PARTING SHADOWS" + subtitle + "Available Now on Steam"
##
## Must run with display server (NOT --headless) since SubViewport needs GPU.
##
## Usage: godot --script res://tools/render_coop_cards.gd

const WIDTH: int = 1280
const HEIGHT: int = 720
const BG_PATH: String = "res://assets/art/ui/title_background.png"
const TITLE_OUTPUT: String = "res://tools/coop_title_card.png"
const END_OUTPUT: String = "res://tools/coop_end_card.png"

var _vp: SubViewport
var _frames: int = 0
var _rendered_title: bool = false


func _init() -> void:
	_vp = SubViewport.new()
	_vp.size = Vector2i(WIDTH, HEIGHT)
	_vp.transparent_bg = false
	_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(_vp)
	_build_title_card()


func _build_title_card() -> void:
	_clear_vp()

	# Background
	var bg := TextureRect.new()
	bg.texture = load(BG_PATH)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.custom_minimum_size = Vector2(WIDTH, HEIGHT)
	_vp.add_child(bg)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.offset_bottom = -40
	_vp.add_child(center)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 24)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(vbox)

	# Title
	var title := Label.new()
	title.text = "PARTING SHADOWS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 56)
	title.add_theme_constant_override("outline_size", 2)
	title.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	title.add_theme_constant_override("shadow_offset_x", 4)
	title.add_theme_constant_override("shadow_offset_y", 4)
	title.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
	vbox.add_child(title)

	# "Local & Online Co-op"
	var coop_label := Label.new()
	coop_label.text = "Local & Online Co-op"
	coop_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	coop_label.add_theme_font_size_override("font_size", 32)
	coop_label.add_theme_constant_override("outline_size", 2)
	coop_label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	coop_label.add_theme_constant_override("shadow_offset_x", 3)
	coop_label.add_theme_constant_override("shadow_offset_y", 3)
	coop_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
	vbox.add_child(coop_label)


func _build_end_card() -> void:
	_clear_vp()

	# Background
	var bg := TextureRect.new()
	bg.texture = load(BG_PATH)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.custom_minimum_size = Vector2(WIDTH, HEIGHT)
	_vp.add_child(bg)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.offset_bottom = -80
	_vp.add_child(center)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(vbox)

	# Title
	var title := Label.new()
	title.text = "PARTING SHADOWS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 56)
	title.add_theme_constant_override("outline_size", 2)
	title.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	title.add_theme_constant_override("shadow_offset_x", 4)
	title.add_theme_constant_override("shadow_offset_y", 4)
	title.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
	vbox.add_child(title)

	# Subtitle
	var subtitle := Label.new()
	subtitle.text = "Some paths can't be retraced."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 20)
	subtitle.add_theme_constant_override("outline_size", 2)
	subtitle.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	vbox.add_child(subtitle)

	# Spacer
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 80)
	vbox.add_child(spacer)

	# CTA
	var cta := Label.new()
	cta.text = "Available Now on Steam"
	cta.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cta.add_theme_font_size_override("font_size", 40)
	cta.add_theme_constant_override("outline_size", 2)
	cta.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	cta.add_theme_constant_override("shadow_offset_x", 4)
	cta.add_theme_constant_override("shadow_offset_y", 4)
	cta.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
	vbox.add_child(cta)


func _clear_vp() -> void:
	for child in _vp.get_children():
		child.queue_free()


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames < 5:
		return false

	if not _rendered_title:
		var img: Image = _vp.get_texture().get_image()
		img.save_png(TITLE_OUTPUT)
		print("Saved title card to: %s (%dx%d)" % [TITLE_OUTPUT, img.get_width(), img.get_height()])
		_rendered_title = true
		_frames = 0
		_build_end_card()
		return false

	var img: Image = _vp.get_texture().get_image()
	img.save_png(END_OUTPUT)
	print("Saved end card to: %s (%dx%d)" % [END_OUTPUT, img.get_width(), img.get_height()])
	quit()
	return true
