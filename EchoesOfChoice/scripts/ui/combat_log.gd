class_name CombatLog extends PanelContainer

## Scrollable text area for battle messages.
## Replaces Console.WriteLine during combat in C#.

var _label: RichTextLabel
var _margin: MarginContainer


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	_margin = MarginContainer.new()
	_margin.add_theme_constant_override("margin_left", 12)
	_margin.add_theme_constant_override("margin_right", 12)
	_margin.add_theme_constant_override("margin_top", 8)
	_margin.add_theme_constant_override("margin_bottom", 8)
	add_child(_margin)

	_label = RichTextLabel.new()
	_label.bbcode_enabled = true
	_label.scroll_active = true
	_label.scroll_following = true
	_label.fit_content = false
	_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_label.add_theme_font_size_override("normal_font_size", 16)
	_margin.add_child(_label)


func add_message(text: String) -> void:
	if _label.get_total_character_count() > 0:
		_label.append_text("\n")
	_label.append_text(text)


func add_separator() -> void:
	_label.append_text("\n[color=gray]───────────────────[/color]")


func clear_log() -> void:
	_label.clear()
