extends Control

@onready var background: ColorRect = $Background
@onready var town_visual: Control = $HBoxSplit/TownVisual
@onready var visual_bg: ColorRect = $HBoxSplit/TownVisual/VisualBG
@onready var town_label: Label = $HBoxSplit/TownVisual/TownLabel
@onready var npc_area: Control = $HBoxSplit/TownVisual/NPCArea
@onready var town_name_label: Label = $HBoxSplit/MenuPanel/MarginContainer/VBox/TownName
@onready var town_desc_label: Label = $HBoxSplit/MenuPanel/MarginContainer/VBox/Description
@onready var party_list: VBoxContainer = $HBoxSplit/MenuPanel/MarginContainer/VBox/ScrollContainer/PartyList
@onready var gold_label: Label = $HBoxSplit/MenuPanel/MarginContainer/VBox/GoldLabel
@onready var optional_battle_button: Button = $HBoxSplit/MenuPanel/MarginContainer/VBox/Buttons/OptionalBattleButton
@onready var shop_button: Button = $HBoxSplit/MenuPanel/MarginContainer/VBox/Buttons/ShopButton
@onready var recruit_button: Button = $HBoxSplit/MenuPanel/MarginContainer/VBox/Buttons/RecruitButton
@onready var items_button: Button = $HBoxSplit/MenuPanel/MarginContainer/VBox/Buttons/ItemsButton
@onready var continue_button: Button = $HBoxSplit/MenuPanel/MarginContainer/VBox/Buttons/ContinueButton

var _town_id: String = ""
var _dialogue_box_scene: PackedScene = preload("res://scenes/ui/DialogueBox.tscn")
var _promote_button: Button

const REST_COST := 50

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
		"health_potion", "mana_potion",
		"strength_tonic", "magic_tonic", "guard_tonic",
		"equipment/health_0", "equipment/mana_0",
		"equipment/phys_atk_0", "equipment/phys_def_0",
		"equipment/mag_atk_0", "equipment/mag_def_0",
	],
	"crossroads_inn": [
		"tent",
		"health_potion", "mana_potion",
		"strength_tonic", "magic_tonic", "guard_tonic",
		"greater_health_potion", "greater_mana_potion",
		"greater_strength_tonic", "greater_magic_tonic", "greater_guard_tonic",
		"equipment/health_0", "equipment/mana_0",
		"equipment/phys_atk_0", "equipment/phys_def_0",
		"equipment/mag_atk_0", "equipment/mag_def_0",
		"equipment/health_1", "equipment/mana_1",
		"equipment/phys_atk_1", "equipment/phys_def_1",
		"equipment/mag_atk_1", "equipment/mag_def_1", "equipment/speed_1",
		"equipment/crit_1", "equipment/dodge_1",
		"equipment/movement_1", "equipment/jump_1",
	],
	"gate_town": [
		"tent",
		"health_potion", "mana_potion",
		"strength_tonic", "magic_tonic", "guard_tonic",
		"greater_health_potion", "greater_mana_potion",
		"greater_strength_tonic", "greater_magic_tonic", "greater_guard_tonic",
		"superior_health_potion", "superior_mana_potion",
		"superior_strength_tonic", "superior_magic_tonic", "superior_guard_tonic",
		"equipment/health_0", "equipment/mana_0",
		"equipment/phys_atk_0", "equipment/phys_def_0",
		"equipment/mag_atk_0", "equipment/mag_def_0",
		"equipment/health_1", "equipment/mana_1",
		"equipment/phys_atk_1", "equipment/phys_def_1",
		"equipment/mag_atk_1", "equipment/mag_def_1", "equipment/speed_1",
		"equipment/crit_1", "equipment/dodge_1",
		"equipment/movement_1", "equipment/jump_1",
		"equipment/health_2", "equipment/mana_2",
		"equipment/phys_atk_2", "equipment/phys_def_2",
		"equipment/mag_atk_2", "equipment/mag_def_2", "equipment/speed_2",
		"equipment/crit_2", "equipment/dodge_2",
		"equipment/movement_2", "equipment/jump_2",
	],
}

# Terrain-tinted visual backgrounds
const TERRAIN_VISUALS: Dictionary = {
	MapData.Terrain.VILLAGE: {
		"bg": Color(0.08, 0.14, 0.06),
		"ground": Color(0.12, 0.18, 0.08),
		"accent": Color(0.25, 0.35, 0.15),
	},
	MapData.Terrain.INN: {
		"bg": Color(0.14, 0.10, 0.06),
		"ground": Color(0.18, 0.13, 0.08),
		"accent": Color(0.4, 0.28, 0.12),
	},
	MapData.Terrain.CITY: {
		"bg": Color(0.10, 0.10, 0.14),
		"ground": Color(0.14, 0.14, 0.18),
		"accent": Color(0.25, 0.25, 0.35),
	},
	MapData.Terrain.CITY_GATE: {
		"bg": Color(0.10, 0.10, 0.14),
		"ground": Color(0.14, 0.14, 0.18),
		"accent": Color(0.25, 0.25, 0.35),
	},
	MapData.Terrain.CASTLE: {
		"bg": Color(0.10, 0.08, 0.12),
		"ground": Color(0.14, 0.12, 0.16),
		"accent": Color(0.3, 0.2, 0.35),
	},
}

# NPC visual config: sprite + fractional position in the visual area
const NPC_VISUAL_CONFIG: Dictionary = {
	"forest_village": [
		{"name": "Maren", "sprite_id": "chibi_women_citizen_women_1", "pos_frac": Vector2(0.25, 0.55)},
		{"name": "Corvin", "sprite_id": "chibi_citizen_1", "pos_frac": Vector2(0.65, 0.45)},
		{"name": "Sela", "sprite_id": "chibi_women_citizen_women_3", "pos_frac": Vector2(0.45, 0.60), "requires_flag": "village_defended"},
	],
	"crossroads_inn": [
		{"name": "Bram", "sprite_id": "chibi_citizen_2", "pos_frac": Vector2(0.30, 0.50)},
		{"name": "Lyra", "sprite_id": "chibi_women_citizen_women_2", "pos_frac": Vector2(0.60, 0.55)},
	],
	"gate_town": [
		{"name": "Donal", "sprite_id": "chibi_villager_1", "pos_frac": Vector2(0.40, 0.50)},
		{"name": "Petra", "sprite_id": "chibi_women_citizen_women_2_tinker", "pos_frac": Vector2(0.65, 0.55)},
	],
}


const TOWN_TRACKS: Dictionary = {
	"castle": "res://assets/audio/music/town/Medieval Celtic 01(L).wav",
	"forest_village": "res://assets/audio/music/town/Town Village 05(L).wav",
	"crossroads_inn": "res://assets/audio/music/town/Medieval Tavern 03.wav",
	"gate_town": "res://assets/audio/music/town/Medieval Celtic 07(L).wav",
}


func _ready() -> void:
	_town_id = GameState.current_town_id
	var town_track: String = TOWN_TRACKS.get(_town_id, "")
	if not town_track.is_empty():
		MusicManager.play_music(town_track)
	else:
		MusicManager.play_context(MusicManager.MusicContext.TOWN)
	var node_data: Dictionary = MapData.get_node(_town_id)

	var terrain: int = node_data.get("terrain", -1)
	_setup_visual_area(terrain, node_data)

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
	items_button.pressed.connect(_on_items_pressed)

	var buttons_node: Node = continue_button.get_parent()

	_promote_button = Button.new()
	_promote_button.text = "Promote"
	_promote_button.pressed.connect(_on_promote_pressed)
	_promote_button.visible = GameState.has_any_promotable_member()
	buttons_node.add_child(_promote_button)
	buttons_node.move_child(_promote_button, recruit_button.get_index() + 1)

	var status_button := Button.new()
	status_button.text = "Status"
	status_button.pressed.connect(_on_status_pressed)
	buttons_node.add_child(status_button)
	buttons_node.move_child(status_button, items_button.get_index() + 1)

	var rest_button := Button.new()
	rest_button.text = "Rest Party (%dg)" % REST_COST
	rest_button.pressed.connect(_on_rest_pressed)
	buttons_node.add_child(rest_button)
	buttons_node.move_child(rest_button, continue_button.get_index())

	_populate_npcs(node_data)
	continue_button.pressed.connect(_on_continue)

	if GameState.has_any_promotable_member():
		_on_promote_pressed()

	# Entrance animation
	town_visual.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(town_visual, "modulate:a", 1.0, 0.4)


func _setup_visual_area(terrain: int, node_data: Dictionary) -> void:
	var visuals: Dictionary = TERRAIN_VISUALS.get(terrain, {})
	if visuals.is_empty():
		visuals = {"bg": Color(0.1, 0.12, 0.14), "ground": Color(0.14, 0.16, 0.18), "accent": Color(0.2, 0.22, 0.25)}
	background.color = visuals["bg"]
	visual_bg.color = visuals["bg"]
	town_label.text = node_data.get("display_name", "Town")

	# Ground strip at bottom of visual area
	var ground := ColorRect.new()
	ground.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	ground.anchor_top = 0.7
	ground.color = visuals["ground"]
	town_visual.add_child(ground)
	town_visual.move_child(ground, visual_bg.get_index() + 1)

	_add_decorations(terrain, visuals)
	_place_npc_sprites()


func _add_decorations(terrain: int, visuals: Dictionary) -> void:
	match terrain:
		MapData.Terrain.VILLAGE:
			_add_tree(0.15, 0.30, visuals["accent"])
			_add_tree(0.75, 0.25, visuals["accent"].darkened(0.2))
			_add_building(0.40, 0.35, visuals["accent"].lightened(0.1), "Inn")
		MapData.Terrain.INN:
			_add_building(0.30, 0.30, visuals["accent"], "Bar")
			_add_building(0.60, 0.35, visuals["accent"].lightened(0.1), "Room")
			_add_lantern(0.20, 0.40)
			_add_lantern(0.75, 0.38)
		MapData.Terrain.CITY, MapData.Terrain.CITY_GATE:
			_add_building(0.15, 0.25, visuals["accent"], "")
			_add_building(0.45, 0.20, visuals["accent"].lightened(0.1), "Gate")
			_add_building(0.70, 0.28, visuals["accent"].darkened(0.1), "")
			_add_pillar(0.05, 0.35)
			_add_pillar(0.85, 0.35)
		MapData.Terrain.CASTLE:
			_add_building(0.30, 0.20, visuals["accent"], "Hall")
			_add_pillar(0.15, 0.30)
			_add_pillar(0.55, 0.30)
			_add_pillar(0.75, 0.30)


func _add_tree(x_frac: float, y_frac: float, color: Color) -> void:
	var trunk := ColorRect.new()
	trunk.size = Vector2(8, 30)
	trunk.color = Color(0.3, 0.2, 0.1)
	npc_area.add_child(trunk)
	trunk.set_meta("frac", Vector2(x_frac, y_frac))

	var canopy := ColorRect.new()
	canopy.size = Vector2(32, 24)
	canopy.color = color
	npc_area.add_child(canopy)
	canopy.set_meta("frac", Vector2(x_frac - 0.02, y_frac - 0.06))


func _add_building(x_frac: float, y_frac: float, color: Color, label_text: String) -> void:
	var bldg := ColorRect.new()
	bldg.size = Vector2(60, 50)
	bldg.color = color
	npc_area.add_child(bldg)
	bldg.set_meta("frac", Vector2(x_frac, y_frac))

	var roof := ColorRect.new()
	roof.size = Vector2(68, 10)
	roof.color = color.darkened(0.3)
	npc_area.add_child(roof)
	roof.set_meta("frac", Vector2(x_frac - 0.01, y_frac - 0.025))

	if not label_text.is_empty():
		var lbl := Label.new()
		lbl.text = label_text
		lbl.add_theme_font_size_override("font_size", 9)
		lbl.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, 0.7))
		npc_area.add_child(lbl)
		lbl.set_meta("frac", Vector2(x_frac + 0.01, y_frac + 0.01))


func _add_lantern(x_frac: float, y_frac: float) -> void:
	var glow := ColorRect.new()
	glow.size = Vector2(16, 16)
	glow.color = Color(1.0, 0.85, 0.4, 0.35)
	npc_area.add_child(glow)
	glow.set_meta("frac", Vector2(x_frac, y_frac))

	var post := ColorRect.new()
	post.size = Vector2(4, 24)
	post.color = Color(0.3, 0.25, 0.15)
	npc_area.add_child(post)
	post.set_meta("frac", Vector2(x_frac + 0.01, y_frac + 0.04))


func _add_pillar(x_frac: float, y_frac: float) -> void:
	var pillar := ColorRect.new()
	pillar.size = Vector2(12, 60)
	pillar.color = Color(0.35, 0.3, 0.4)
	npc_area.add_child(pillar)
	pillar.set_meta("frac", Vector2(x_frac, y_frac))

	var cap := ColorRect.new()
	cap.size = Vector2(18, 6)
	cap.color = Color(0.4, 0.35, 0.45)
	npc_area.add_child(cap)
	cap.set_meta("frac", Vector2(x_frac - 0.005, y_frac - 0.015))


func _place_npc_sprites() -> void:
	var npc_configs: Array = NPC_VISUAL_CONFIG.get(_town_id, [])
	for cfg in npc_configs:
		var requires_flag: String = cfg.get("requires_flag", "")
		if not requires_flag.is_empty() and not GameState.story_flags.get(requires_flag, false):
			continue

		var sprite_id: String = cfg.get("sprite_id", "")
		if sprite_id.is_empty():
			continue
		var frames := SpriteLoader.get_frames(sprite_id)
		if not frames or not frames.has_animation("idle_down"):
			continue
		var tex := frames.get_frame_texture("idle_down", 0)
		if not tex:
			continue

		var npc_node := TextureRect.new()
		npc_node.texture = tex
		npc_node.custom_minimum_size = Vector2(64, 64)
		npc_node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		npc_node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		npc_node.mouse_filter = Control.MOUSE_FILTER_STOP
		npc_node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		npc_node.set_meta("frac", cfg["pos_frac"])
		npc_node.set_meta("npc_name", cfg["name"])

		var npc_name_copy: String = cfg["name"]
		npc_node.gui_input.connect(func(event: InputEvent) -> void:
			if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				_on_visual_npc_clicked(npc_name_copy)
		)
		npc_area.add_child(npc_node)

		var name_lbl := Label.new()
		name_lbl.text = cfg["name"]
		name_lbl.add_theme_font_size_override("font_size", 11)
		name_lbl.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_lbl.set_meta("frac", cfg["pos_frac"] + Vector2(-0.02, 0.15))
		npc_area.add_child(name_lbl)

	# Position all children based on fractional positions after layout settles
	await get_tree().process_frame
	_layout_npc_area()


func _layout_npc_area() -> void:
	var area_size := npc_area.size
	for child in npc_area.get_children():
		if child.has_meta("frac"):
			var frac: Vector2 = child.get_meta("frac")
			child.position = Vector2(frac.x * area_size.x, frac.y * area_size.y)


func _on_visual_npc_clicked(npc_name: String) -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	var node_data: Dictionary = MapData.get_node(_town_id)
	var npcs: Array = node_data.get("npcs", [])
	for npc in npcs:
		if npc.get("name", "") == npc_name:
			_show_npc_dialogue(npc)
			return


func _show_npc_dialogue(npc: Dictionary) -> void:
	var lines_raw: Array = npc.get("lines", [])
	var lines: Array[Dictionary] = []
	for text in lines_raw:
		lines.append({"speaker": npc.get("name", ""), "text": text})

	var dialogue_box: Control = _dialogue_box_scene.instantiate()
	add_child(dialogue_box)
	dialogue_box.show_dialogue(lines)
	await dialogue_box.dialogue_finished
	dialogue_box.queue_free()


func _populate_party_list() -> void:
	for child in party_list.get_children():
		child.queue_free()

	var roster_total := GameState.party_members.size() + 1
	var header := Label.new()
	header.text = "— Roster (%d) —" % roster_total
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 16)
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
	row.add_theme_constant_override("separation", 12)

	var name_label := Label.new()
	name_label.text = unit_name
	name_label.custom_minimum_size.x = 100
	name_label.add_theme_font_size_override("font_size", 13)
	row.add_child(name_label)

	var class_label := Label.new()
	class_label.text = class_id.capitalize()
	class_label.custom_minimum_size.x = 80
	class_label.add_theme_font_size_override("font_size", 13)
	class_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	row.add_child(class_label)

	var level_label := Label.new()
	level_label.text = "Lv.%d" % level
	level_label.add_theme_font_size_override("font_size", 13)
	row.add_child(level_label)

	return row


func _on_optional_battle() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	var battle_info: Dictionary = TOWN_BATTLES.get(_town_id, {})
	if battle_info.is_empty():
		return
	GameState.current_battle_id = battle_info["battle_id"]
	GameState.story_flags[battle_info["flag"]] = true
	SceneManager.go_to_party_select()


func _on_shop_pressed() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
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


func _on_promote_pressed() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	var promote_scene := preload("res://scenes/town/PromoteUI.tscn")
	var promote_ui: Control = promote_scene.instantiate()
	promote_ui.promote_closed.connect(func():
		promote_ui.queue_free()
		_populate_party_list()
		_promote_button.visible = GameState.has_any_promotable_member()
	)
	add_child(promote_ui)


func _on_recruit_pressed() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	var recruit_scene := preload("res://scenes/town/RecruitUI.tscn")
	var recruit: Control = recruit_scene.instantiate()
	recruit.recruit_closed.connect(func():
		recruit.queue_free()
		gold_label.text = "Gold: %d" % GameState.gold
		_populate_party_list()
	)
	add_child(recruit)


func _on_items_pressed() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	var items_scene := preload("res://scenes/ui/ItemsUI.tscn")
	var items_ui: Control = items_scene.instantiate()
	items_ui.items_closed.connect(func(): items_ui.queue_free())
	add_child(items_ui)


func _on_status_pressed() -> void:
	SFXManager.play(SFXManager.Category.UI_SELECT, 0.5)
	var status_scene := preload("res://scenes/ui/StatusScreen.tscn")
	var status_ui: Control = status_scene.instantiate()
	status_ui.status_closed.connect(func(): status_ui.queue_free())
	add_child(status_ui)


func _populate_npcs(node_data: Dictionary) -> void:
	var npcs: Array = node_data.get("npcs", [])
	if npcs.is_empty():
		return

	var buttons_container: Node = optional_battle_button.get_parent()

	var separator := HSeparator.new()
	buttons_container.add_child(separator)

	var npc_header := Label.new()
	npc_header.text = "— Townsfolk —"
	npc_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	npc_header.add_theme_font_size_override("font_size", 14)
	buttons_container.add_child(npc_header)

	for npc in npcs:
		var requires_flag: String = npc.get("requires_flag", "")
		if not requires_flag.is_empty() and not GameState.story_flags.get(requires_flag, false):
			continue

		var btn := Button.new()
		btn.text = "%s (%s)" % [npc.get("name", "???"), npc.get("role", "")]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		var npc_copy: Dictionary = npc
		btn.pressed.connect(func(): _show_npc_dialogue(npc_copy))
		buttons_container.add_child(btn)


func _on_rest_pressed() -> void:
	if not GameState.can_afford(REST_COST):
		return
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	GameState.spend_gold(REST_COST)
	GameState.full_rest_party()
	gold_label.text = "Gold: %d" % GameState.gold


func _on_continue() -> void:
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.5)
	GameState.auto_save()
	SceneManager.go_to_overworld()
