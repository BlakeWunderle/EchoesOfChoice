class_name StatsPanel extends PanelContainer

## Shows detailed stats for a fighter. Used in battle stats view.

const FighterData := preload("res://scripts/data/fighter_data.gd")

signal closed

var _vbox: VBoxContainer
var _close_btn: Button


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	add_child(margin)

	_vbox = VBoxContainer.new()
	_vbox.add_theme_constant_override("separation", 4)
	margin.add_child(_vbox)

	_close_btn = Button.new()
	_close_btn.text = "Back"
	_close_btn.custom_minimum_size = Vector2(120, 36)
	_close_btn.pressed.connect(func() -> void: closed.emit())


func show_fighter(fighter: FighterData) -> void:
	# Remove close button before clearing (preserve it for reuse)
	if _close_btn.get_parent() == _vbox:
		_vbox.remove_child(_close_btn)
	for child: Node in _vbox.get_children():
		child.queue_free()

	_add_line("Character: %s" % fighter.character_name)
	_add_line("Class: %s" % fighter.character_type)
	_add_line("Level: %d" % fighter.level)
	_add_line("")
	_add_line("Health: %d / %d" % [fighter.health, fighter.max_health])
	_add_line("Mana: %d / %d" % [fighter.mana, fighter.max_mana])
	_add_line("Physical Attack: %d" % fighter.physical_attack)
	_add_line("Physical Defense: %d" % fighter.physical_defense)
	_add_line("Magic Attack: %d" % fighter.magic_attack)
	_add_line("Magic Defense: %d" % fighter.magic_defense)
	_add_line("Speed: %d" % fighter.speed)
	_add_line("Crit Chance: %d%%" % fighter.crit_chance)
	_add_line("Crit Damage: %d" % fighter.crit_damage)
	_add_line("Dodge Chance: %d%%" % fighter.dodge_chance)

	_vbox.add_child(_close_btn)
	visible = true
	_close_btn.grab_focus()


func _add_line(text: String) -> void:
	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", 15)
	_vbox.add_child(lbl)
