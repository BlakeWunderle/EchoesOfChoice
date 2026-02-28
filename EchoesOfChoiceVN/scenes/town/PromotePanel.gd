extends Control

signal closed

@onready var _member_list: VBoxContainer = %MemberList
@onready var _options_box: VBoxContainer = %PromoteOptions
@onready var _status_label: Label = %PromoteStatus


func setup() -> void:
	_options_box.visible = false
	_status_label.text = ""
	_refresh_members()


func _refresh_members() -> void:
	for child in _member_list.get_children():
		child.queue_free()
	# Player
	if GameState.can_promote(GameState.player_name):
		_add_member_btn(GameState.player_name, GameState.player_class_id,
			GameState.player_jp, GameState.player_level)
	# Party
	for member in GameState.party_members:
		var name: String = member.get("name", "")
		if GameState.can_promote(name):
			_add_member_btn(name, member.get("class_id", ""),
				member.get("jp", 0), member.get("level", 1))

	if _member_list.get_child_count() == 0:
		var label := Label.new()
		label.text = "No one is ready for promotion."
		label.add_theme_font_size_override("font_size", 14)
		_member_list.add_child(label)


func _add_member_btn(unit_name: String, class_id: String, jp: int, level: int) -> void:
	var btn := Button.new()
	btn.text = "%s - %s Lv.%d (JP: %d)" % [unit_name, class_id.capitalize(), level, jp]
	btn.custom_minimum_size = Vector2(0, 36)
	var uname := unit_name
	var cid := class_id
	var lvl := level
	btn.pressed.connect(func(): _show_options(uname, cid, lvl))
	_member_list.add_child(btn)


func _show_options(unit_name: String, class_id: String, level: int) -> void:
	_options_box.visible = true
	for child in _options_box.get_children():
		child.queue_free()

	var title := Label.new()
	title.text = "Promote %s:" % unit_name
	title.add_theme_font_size_override("font_size", 16)
	_options_box.add_child(title)

	var path := "res://resources/classes/%s.tres" % class_id
	if not ResourceLoader.exists(path):
		return
	var data: FighterData = load(path) as FighterData
	if not data:
		return

	for option in data.upgrade_options:
		var opt_stats := option.get_stats_at_level(level)
		var cur_stats := data.get_stats_at_level(level)

		var info := Label.new()
		var hp_diff := opt_stats["max_health"] - cur_stats["max_health"]
		var atk_diff := opt_stats["physical_attack"] - cur_stats["physical_attack"]
		var matk_diff := opt_stats["magic_attack"] - cur_stats["magic_attack"]
		info.text = "%s (T%d) HP:%+d ATK:%+d MATK:%+d" % [
			option.class_display_name, option.tier, hp_diff, atk_diff, matk_diff]
		info.add_theme_font_size_override("font_size", 13)
		_options_box.add_child(info)

		var btn := Button.new()
		btn.text = "Promote to %s" % option.class_display_name
		btn.custom_minimum_size = Vector2(0, 36)
		var uname := unit_name
		var new_cid := option.class_id
		btn.pressed.connect(func(): _do_promote(uname, new_cid))
		_options_box.add_child(btn)

	var back := Button.new()
	back.text = "Back"
	back.custom_minimum_size = Vector2(0, 36)
	back.pressed.connect(func(): _options_box.visible = false)
	_options_box.add_child(back)


func _do_promote(unit_name: String, new_class_id: String) -> void:
	if GameState.promote_member(unit_name, new_class_id):
		_status_label.text = "%s promoted to %s!" % [unit_name, new_class_id.capitalize()]
		_options_box.visible = false
		_refresh_members()
	else:
		_status_label.text = "Promotion failed."


func _on_close() -> void:
	closed.emit()
