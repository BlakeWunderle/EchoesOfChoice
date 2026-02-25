@tool
extends SceneTree

## Generates the game_theme.tres file with styled controls.


func _init() -> void:
	var theme := Theme.new()
	var font: Font = null
	var font_path := "res://assets/art/ui/Oswald-Bold.ttf"
	if ResourceLoader.exists(font_path):
		font = load(font_path) as Font

	# --- Colors ---
	var panel_bg := Color(0.13, 0.11, 0.16, 0.92)
	var panel_border := Color(0.55, 0.45, 0.3, 0.6)
	var btn_normal_bg := Color(0.22, 0.28, 0.18)
	var btn_hover_bg := Color(0.28, 0.36, 0.22)
	var btn_pressed_bg := Color(0.16, 0.22, 0.14)
	var btn_disabled_bg := Color(0.2, 0.2, 0.2)
	var btn_border := Color(0.45, 0.55, 0.35, 0.7)
	var btn_hover_border := Color(0.55, 0.65, 0.4, 0.8)
	var text_light := Color(0.92, 0.88, 0.80)
	var text_dark := Color(0.25, 0.18, 0.10)
	var text_dim := Color(0.55, 0.52, 0.48)
	var input_bg := Color(0.08, 0.07, 0.1, 0.9)
	var input_border := Color(0.4, 0.35, 0.28, 0.5)
	var focus_border := Color(0.6, 0.5, 0.3, 0.8)
	var separator_color := Color(0.4, 0.35, 0.28, 0.4)
	var scrollbar_bg := Color(0.1, 0.1, 0.12, 0.3)
	var scrollbar_grab := Color(0.4, 0.45, 0.35, 0.6)
	var scrollbar_grab_hi := Color(0.5, 0.55, 0.4, 0.8)
	var progress_bg_color := Color(0.12, 0.1, 0.08)
	var progress_fill_color := Color(0.3, 0.75, 0.25)

	# --- Default font ---
	theme.default_font = font
	theme.default_font_size = 16

	# --- Panel ---
	var panel_style := _make_flat(panel_bg, panel_border, 2, 6)
	theme.set_stylebox("panel", "Panel", panel_style)
	theme.set_stylebox("panel", "PanelContainer", panel_style)

	# --- Button ---
	theme.set_stylebox("normal", "Button", _make_flat(btn_normal_bg, btn_border, 2, 5))
	theme.set_stylebox("hover", "Button", _make_flat(btn_hover_bg, btn_hover_border, 2, 5))
	theme.set_stylebox("pressed", "Button", _make_flat(btn_pressed_bg, btn_border, 2, 5))
	theme.set_stylebox("disabled", "Button", _make_flat(btn_disabled_bg, Color(0.3, 0.3, 0.3, 0.3), 1, 5))
	theme.set_stylebox("focus", "Button", _make_flat(btn_hover_bg, focus_border, 2, 5))
	theme.set_font("font", "Button", font)
	theme.set_font_size("font_size", "Button", 16)
	theme.set_color("font_color", "Button", text_light)
	theme.set_color("font_hover_color", "Button", Color(1.0, 0.95, 0.85))
	theme.set_color("font_pressed_color", "Button", Color(0.75, 0.7, 0.6))
	theme.set_color("font_disabled_color", "Button", text_dim)
	theme.set_color("font_focus_color", "Button", Color(1.0, 0.95, 0.85))
	theme.set_constant("h_separation", "Button", 8)

	# --- Label ---
	theme.set_font("font", "Label", font)
	theme.set_font_size("font_size", "Label", 16)
	theme.set_color("font_color", "Label", text_light)

	# --- RichTextLabel ---
	theme.set_font("normal_font", "RichTextLabel", font)
	theme.set_font_size("normal_font_size", "RichTextLabel", 16)
	theme.set_color("default_color", "RichTextLabel", text_light)

	# --- LineEdit ---
	theme.set_stylebox("normal", "LineEdit", _make_flat(input_bg, input_border, 1, 4))
	theme.set_stylebox("focus", "LineEdit", _make_flat(input_bg, focus_border, 2, 4))
	theme.set_stylebox("read_only", "LineEdit", _make_flat(Color(0.12, 0.11, 0.14, 0.7), input_border, 1, 4))
	theme.set_font("font", "LineEdit", font)
	theme.set_font_size("font_size", "LineEdit", 16)
	theme.set_color("font_color", "LineEdit", text_light)
	theme.set_color("caret_color", "LineEdit", Color(0.7, 0.65, 0.5))
	theme.set_color("font_placeholder_color", "LineEdit", text_dim)

	# --- HSeparator ---
	var sep_style := StyleBoxFlat.new()
	sep_style.bg_color = separator_color
	sep_style.content_margin_top = 4
	sep_style.content_margin_bottom = 4
	theme.set_stylebox("separator", "HSeparator", sep_style)
	theme.set_constant("separation", "HSeparator", 8)

	# --- VScrollBar ---
	var scroll_bg_style := StyleBoxFlat.new()
	scroll_bg_style.bg_color = scrollbar_bg
	scroll_bg_style.corner_radius_top_left = 3
	scroll_bg_style.corner_radius_top_right = 3
	scroll_bg_style.corner_radius_bottom_left = 3
	scroll_bg_style.corner_radius_bottom_right = 3
	theme.set_stylebox("scroll", "VScrollBar", scroll_bg_style)

	var grab_style := StyleBoxFlat.new()
	grab_style.bg_color = scrollbar_grab
	grab_style.corner_radius_top_left = 3
	grab_style.corner_radius_top_right = 3
	grab_style.corner_radius_bottom_left = 3
	grab_style.corner_radius_bottom_right = 3
	theme.set_stylebox("grabber", "VScrollBar", grab_style)

	var grab_hi := StyleBoxFlat.new()
	grab_hi.bg_color = scrollbar_grab_hi
	grab_hi.corner_radius_top_left = 3
	grab_hi.corner_radius_top_right = 3
	grab_hi.corner_radius_bottom_left = 3
	grab_hi.corner_radius_bottom_right = 3
	theme.set_stylebox("grabber_highlight", "VScrollBar", grab_hi)

	# --- ProgressBar ---
	var progress_bg := _make_flat(progress_bg_color, Color(0.25, 0.2, 0.15, 0.5), 1, 3)
	theme.set_stylebox("background", "ProgressBar", progress_bg)
	var progress_fill := _make_flat(progress_fill_color, Color(0.2, 0.5, 0.15, 0.5), 1, 3)
	theme.set_stylebox("fill", "ProgressBar", progress_fill)

	# --- OptionButton ---
	theme.set_stylebox("normal", "OptionButton", _make_flat(btn_normal_bg, btn_border, 2, 5))
	theme.set_stylebox("hover", "OptionButton", _make_flat(btn_hover_bg, btn_hover_border, 2, 5))
	theme.set_stylebox("pressed", "OptionButton", _make_flat(btn_pressed_bg, btn_border, 2, 5))
	theme.set_font("font", "OptionButton", font)
	theme.set_font_size("font_size", "OptionButton", 16)
	theme.set_color("font_color", "OptionButton", text_light)

	# --- PopupMenu ---
	theme.set_stylebox("panel", "PopupMenu", _make_flat(panel_bg, panel_border, 2, 4))
	theme.set_stylebox("hover", "PopupMenu", _make_flat(btn_hover_bg, Color.TRANSPARENT, 0, 2))
	theme.set_font("font", "PopupMenu", font)
	theme.set_font_size("font_size", "PopupMenu", 15)
	theme.set_color("font_color", "PopupMenu", text_light)
	theme.set_color("font_hover_color", "PopupMenu", Color(1.0, 0.95, 0.85))

	# --- ScrollContainer ---
	theme.set_stylebox("panel", "ScrollContainer", StyleBoxEmpty.new())

	# --- TabContainer ---
	theme.set_font("font", "TabContainer", font)
	theme.set_font_size("font_size", "TabContainer", 15)

	# Save
	ResourceSaver.save(theme, "res://resources/gui/game_theme.tres")
	print("Theme saved to res://resources/gui/game_theme.tres")
	quit()


func _make_flat(bg: Color, border: Color, border_width: int, corner_radius: int) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.border_color = border
	sb.border_width_left = border_width
	sb.border_width_right = border_width
	sb.border_width_top = border_width
	sb.border_width_bottom = border_width
	sb.corner_radius_top_left = corner_radius
	sb.corner_radius_top_right = corner_radius
	sb.corner_radius_bottom_left = corner_radius
	sb.corner_radius_bottom_right = corner_radius
	sb.content_margin_left = 8
	sb.content_margin_right = 8
	sb.content_margin_top = 4
	sb.content_margin_bottom = 4
	return sb
