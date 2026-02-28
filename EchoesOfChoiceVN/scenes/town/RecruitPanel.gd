extends Control

signal closed

@onready var _class_list: VBoxContainer = %ClassList
@onready var _detail_box: VBoxContainer = %RecruitDetail
@onready var _name_input: LineEdit = %NameInput
@onready var _gender_box: HBoxContainer = %GenderBox
@onready var _confirm_btn: Button = %ConfirmRecruit
@onready var _gold_label: Label = %RecruitGold
@onready var _status_label: Label = %RecruitStatus

var _selected_class_id: String = ""
var _selected_gender: String = "male"


func setup() -> void:
	_selected_class_id = ""
	_selected_gender = "male"
	_detail_box.visible = false
	_status_label.text = ""
	_gold_label.text = "Gold: %d" % GameState.gold
	_refresh_class_list()


func _refresh_class_list() -> void:
	for child in _class_list.get_children():
		child.queue_free()
	for class_id in GameState.unlocked_classes:
		var path := "res://resources/classes/%s.tres" % class_id
		if not ResourceLoader.exists(path):
			continue
		var data: FighterData = load(path) as FighterData
		if not data:
			continue
		var cost := GameState.get_recruit_cost(class_id)
		var btn := Button.new()
		btn.text = "%s (T%d) - %d gold" % [data.class_display_name, data.tier, cost]
		btn.custom_minimum_size = Vector2(0, 36)
		btn.disabled = not GameState.can_afford(cost) or \
			GameState.get_party_size() >= GameState.MAX_PARTY_SIZE - 1
		var cid := class_id
		btn.pressed.connect(func(): _select_class(cid))
		_class_list.add_child(btn)


func _select_class(class_id: String) -> void:
	_selected_class_id = class_id
	_detail_box.visible = true
	_name_input.text = ""
	_confirm_btn.disabled = true
	_status_label.text = ""

	# Show stats preview
	var path := "res://resources/classes/%s.tres" % class_id
	var data: FighterData = load(path) as FighterData
	if data:
		var level := GameState.get_lowest_party_level()
		var stats := data.get_stats_at_level(level)
		_status_label.text = "%s - Lv.%d\nHP:%d MP:%d ATK:%d DEF:%d MATK:%d MDEF:%d SPD:%d" % [
			data.class_display_name, level,
			stats["max_health"], stats["max_mana"],
			stats["physical_attack"], stats["physical_defense"],
			stats["magic_attack"], stats["magic_defense"],
			stats["speed"]]

	_name_input.grab_focus()


func _on_name_changed(new_text: String) -> void:
	_confirm_btn.disabled = new_text.strip_edges().length() < 2


func _on_gender_male() -> void:
	_selected_gender = "male"


func _on_gender_female() -> void:
	_selected_gender = "female"


func _on_confirm() -> void:
	var recruit_name := _name_input.text.strip_edges()
	if recruit_name.length() < 2 or _selected_class_id.is_empty():
		return
	var cost := GameState.get_recruit_cost(_selected_class_id)
	if not GameState.spend_gold(cost):
		return
	var level := GameState.get_lowest_party_level()
	GameState.add_party_member(recruit_name, _selected_gender, _selected_class_id, level)
	_status_label.text = "%s recruited!" % recruit_name
	_detail_box.visible = false
	_gold_label.text = "Gold: %d" % GameState.gold
	_refresh_class_list()


func _on_close() -> void:
	closed.emit()
