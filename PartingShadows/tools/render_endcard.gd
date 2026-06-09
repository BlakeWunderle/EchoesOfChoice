extends SceneTree

## Renders a trailer end card using the exact same font/style as the title screen.
## Must run with display server (NOT --headless) since SubViewport needs GPU.
##
## Usage: godot --script res://tools/render_endcard.gd

const WIDTH: int = 1280
const HEIGHT: int = 720
const BG_PATH: String = "res://assets/art/ui/title_background.png"
const OUTPUT_PATH: String = "res://tools/endcard.png"

var _vp: SubViewport
var _frames: int = 0


func _init() -> void:
	_vp = SubViewport.new()
	_vp.size = Vector2i(WIDTH, HEIGHT)
	_vp.transparent_bg = false
	_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(_vp)

	# Background image
	var bg := TextureRect.new()
	bg.texture = load(BG_PATH)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.custom_minimum_size = Vector2(WIDTH, HEIGHT)
	_vp.add_child(bg)

	# Center container — offset up like title screen
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.offset_bottom = -80
	_vp.add_child(center)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(vbox)

	# Title — exact copy from title.gd
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

	# Subtitle — exact copy from title.gd
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

	# CTA — same style as title
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


func _process(_delta: float) -> bool:
	_frames += 1
	if _frames < 5:
		return false
	var img: Image = _vp.get_texture().get_image()
	img.save_png(OUTPUT_PATH)
	print("Saved end card to: %s (%dx%d)" % [OUTPUT_PATH, img.get_width(), img.get_height()])
	quit()
	return true
