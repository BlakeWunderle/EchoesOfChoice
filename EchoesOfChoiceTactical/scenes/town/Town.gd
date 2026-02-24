extends Control

@onready var town_name_label: Label = $Panel/MarginContainer/VBox/TownName
@onready var town_desc_label: Label = $Panel/MarginContainer/VBox/Description
@onready var party_list: VBoxContainer = $Panel/MarginContainer/VBox/ScrollContainer/PartyList
@onready var gold_label: Label = $Panel/MarginContainer/VBox/GoldLabel
@onready var optional_battle_button: Button = $Panel/MarginContainer/VBox/Buttons/OptionalBattleButton
@onready var shop_button: Button = $Panel/MarginContainer/VBox/Buttons/ShopButton
@onready var recruit_button: Button = $Panel/MarginContainer/VBox/Buttons/RecruitButton
@onready var continue_button: Button = $Panel/MarginContainer/VBox/Buttons/ContinueButton

var _town_id: String = ""
var _dialogue_box_scene: PackedScene = preload("res://scenes/ui/DialogueBox.tscn")

const TOWN_BATTLES: Dictionary = {
	"forest_village": {
		"battle_id": "village_raid",
		"label": "Defend Village from Goblins",
		"flag": "village_defended",
	},
	"crossroads_inn": {
		"battle_id": "inn_ambush",
		"label": "Fight Off Night Ambush",
		"flag": "inn_defended",
	},
	"gate_town": {
		"battle_id": "gate_ambush",
		"label": "Defend the Gate",
		"flag": "gate_defended",
	},
}

const TOWN_SHOPS: Dictionary = {
	"forest_village": [
		# Consumables — Tier 0
		"health_potion", "mana_potion",
		"strength_tonic", "magic_tonic", "guard_tonic",
		# Equipment — Tier 0
		"equipment/health_0", "equipment/mana_0",
		"equipment/phys_atk_0", "equipment/phys_def_0",
		"equipment/mag_atk_0", "equipment/mag_def_0",
	],
	"crossroads_inn": [
		# Consumables — Tier 0+1
		"health_potion", "mana_potion",
		"strength_tonic", "magic_tonic", "guard_tonic",
		"greater_health_potion", "greater_mana_potion",
		"greater_strength_tonic", "greater_magic_tonic", "greater_guard_tonic",
		# Equipment — Tier 0+1 + first 2-tier items
		"equipment/health_0", "equipment/mana_0",
		"equipment/phys_atk_0", "equipment/phys_def_0",
		"equipment/mag_atk_0", "equipment/mag_def_0",
		"equipment/health_1", "equipment/mana_1",
		"equipment/phys_atk_1", "equipment/phys_def_1",
		"equipment/mag_atk_1", "equipment/mag_def_1", "equipment/speed_1",
		"equipment/crit_0", "equipment/dodge_0",
		"equipment/movement_1", "equipment/jump_1",
	],
	"gate_town": [
		# Consumables — all tiers
		"health_potion", "mana_potion",
		"strength_tonic", "magic_tonic", "guard_tonic",
		"greater_health_potion", "greater_mana_potion",
		"greater_strength_tonic", "greater_magic_tonic", "greater_guard_tonic",
		"superior_health_potion", "superior_mana_potion",
		"superior_strength_tonic", "superior_magic_tonic", "superior_guard_tonic",
		# Equipment — all tiers (T2 class-locked items hidden until right class in party)
		"equipment/health_0", "equipment/mana_0",
		"equipment/phys_atk_0", "equipment/phys_def_0",
		"equipment/mag_atk_0", "equipment/mag_def_0",
		"equipment/health_1", "equipment/mana_1",
		"equipment/phys_atk_1", "equipment/phys_def_1",
		"equipment/mag_atk_1", "equipment/mag_def_1", "equipment/speed_1",
		"equipment/crit_0", "equipment/dodge_0",
		"equipment/movement_1", "equipment/jump_1",
		"equipment/health_2", "equipment/mana_2",
		"equipment/phys_atk_2", "equipment/phys_def_2",
		"equipment/mag_atk_2", "equipment/mag_def_2", "equipment/speed_2",
		"equipment/crit_1", "equipment/dodge_1",
		"equipment/movement_2", "equipment/jump_2",
	],
}


func _ready() -> void:
	_town_id = GameState.current_town_id
	var node_data: Dictionary = MapData.get_node(_town_id)

	town_name_label.text = node_data.get("display_name", "Town")
	town_desc_label.text = node_data.get("description", "")
	gold_label.text = "Gold: %d" % GameState.gold

	_populate_party_list()

	var battle_info: Dictionary = TOWN_BATTLES.get(_town_id, {})
	if not battle_info.is_empty() and not GameState.story_flags.get(battle_info["flag"], false):
		optional_battle_button.text = battle_info["label"]
		optional_battle_button.visible = true
		optional_battle_button.pressed.connect(_on_optional_battle)
	else:
		optional_battle_button.visible = false

	if TOWN_SHOPS.has(_town_id):
		shop_button.visible = true
		shop_button.pressed.connect(_on_shop_pressed)
	else:
		shop_button.visible = false

	recruit_button.pressed.connect(_on_recruit_pressed)

	_populate_npcs(node_data)

	continue_button.pressed.connect(_on_continue)


func _populate_party_list() -> void:
	for child in party_list.get_children():
		child.queue_free()

	var roster_total := GameState.party_members.size() + 1
	var header := Label.new()
	header.text = "— Roster (%d members) —" % roster_total
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 18)
	party_list.add_child(header)

	var player_row := _make_member_row(
		GameState.player_name, GameState.player_class_id, GameState.player_level
	)
	party_list.add_child(player_row)

	for member in GameState.party_members:
		var row := _make_member_row(
			member.get("name", "???"),
			member.get("class_id", ""),
			member.get("level", 1)
		)
		party_list.add_child(row)


func _make_member_row(unit_name: String, class_id: String, level: int) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)

	var name_label := Label.new()
	name_label.text = unit_name
	name_label.custom_minimum_size.x = 140
	row.add_child(name_label)

	var class_label := Label.new()
	class_label.text = class_id.capitalize()
	class_label.custom_minimum_size.x = 100
	class_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	row.add_child(class_label)

	var level_label := Label.new()
	level_label.text = "Lv. " + str(level)
	row.add_child(level_label)

	return row


func _on_optional_battle() -> void:
	var battle_info: Dictionary = TOWN_BATTLES.get(_town_id, {})
	if battle_info.is_empty():
		return
	GameState.current_battle_id = battle_info["battle_id"]
	GameState.story_flags[battle_info["flag"]] = true
	SceneManager.go_to_party_select()


func _on_shop_pressed() -> void:
	var shop_scene := preload("res://scenes/ui/ShopUI.tscn")
	var shop: Control = shop_scene.instantiate()
	var item_ids: Array = TOWN_SHOPS.get(_town_id, [])
	var items: Array = []
	for raw_id in item_ids:
		var path := "res://resources/items/%s.tres" % raw_id
		if not ResourceLoader.exists(path):
			continue
		var item: Resource = load(path) as Resource
		if not item:
			continue
		if item.get("item_type") == 1:  # Enums.ItemType.EQUIPMENT
			if not GameState.is_item_unlocked(item):
				continue
		items.append(item)
	shop.setup(items)
	shop.shop_closed.connect(func():
		shop.queue_free()
		gold_label.text = "Gold: %d" % GameState.gold
	)
	add_child(shop)


func _on_recruit_pressed() -> void:
	var recruit_scene := preload("res://scenes/town/RecruitUI.tscn")
	var recruit: Control = recruit_scene.instantiate()
	recruit.recruit_closed.connect(func():
		recruit.queue_free()
		gold_label.text = "Gold: %d" % GameState.gold
		_populate_party_list()
	)
	add_child(recruit)


func _populate_npcs(node_data: Dictionary) -> void:
	var npcs: Array = node_data.get("npcs", [])
	if npcs.is_empty():
		return

	var buttons_container: Node = optional_battle_button.get_parent()
	var vbox: Node = buttons_container.get_parent()

	var separator := HSeparator.new()
	vbox.add_child(separator)
	vbox.move_child(separator, buttons_container.get_index())

	var npc_header := Label.new()
	npc_header.text = "— Townsfolk —"
	npc_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	npc_header.add_theme_font_size_override("font_size", 16)
	vbox.add_child(npc_header)
	vbox.move_child(npc_header, separator.get_index() + 1)

	var npc_container := VBoxContainer.new()
	npc_container.add_theme_constant_override("separation", 6)
	vbox.add_child(npc_container)
	vbox.move_child(npc_container, npc_header.get_index() + 1)

	for npc in npcs:
		var requires_flag: String = npc.get("requires_flag", "")
		if not requires_flag.is_empty() and not GameState.story_flags.get(requires_flag, false):
			continue

		var btn := Button.new()
		btn.text = "%s (%s)" % [npc.get("name", "???"), npc.get("role", "")]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		var npc_copy: Dictionary = npc
		btn.pressed.connect(func(): _on_npc_pressed(npc_copy))
		npc_container.add_child(btn)


func _on_npc_pressed(npc: Dictionary) -> void:
	var lines_raw: Array = npc.get("lines", [])
	var lines: Array[Dictionary] = []
	for text in lines_raw:
		lines.append({"speaker": npc.get("name", ""), "text": text})

	var dialogue_box: Control = _dialogue_box_scene.instantiate()
	add_child(dialogue_box)
	dialogue_box.show_dialogue(lines)
	await dialogue_box.dialogue_finished
	dialogue_box.queue_free()


func _on_continue() -> void:
	SceneManager.go_to_overworld()
