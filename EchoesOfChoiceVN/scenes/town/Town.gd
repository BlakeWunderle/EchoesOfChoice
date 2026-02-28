extends Control

const REST_COST := 50

@onready var _town_name: Label = %TownName
@onready var _gold_label: Label = %GoldLabel
@onready var _party_list: VBoxContainer = %PartyList
@onready var _menu_box: VBoxContainer = %MenuBox
@onready var _shop_panel: Control = %ShopPanel
@onready var _recruit_panel: Control = %RecruitPanel
@onready var _promote_panel: Control = %PromotePanel

var _town_id: String = ""

const TOWN_NAMES: Dictionary = {
	"village": "Willowbrook Village",
	"port_town": "Port Serenade",
	"capital": "The Royal Capital",
}

const TOWN_SHOPS: Dictionary = {
	"village": ["health_potion", "mana_potion", "basic_sword", "basic_staff"],
	"port_town": ["health_potion", "greater_health_potion", "mana_potion",
		"iron_shield", "travel_cloak", "silver_ring"],
	"capital": ["greater_health_potion", "greater_mana_potion",
		"knight_armor", "mage_robe", "royal_blade"],
}


func _ready() -> void:
	_town_id = GameState.current_town_id
	_town_name.text = TOWN_NAMES.get(_town_id, "Town")
	MusicManager.play_context(MusicManager.MusicContext.TOWN)
	_shop_panel.visible = false
	_recruit_panel.visible = false
	_promote_panel.visible = false
	_refresh()


func _refresh() -> void:
	_gold_label.text = "Gold: %d" % GameState.gold
	_refresh_party_list()
	_refresh_menu_buttons()


func _refresh_party_list() -> void:
	for child in _party_list.get_children():
		child.queue_free()
	_add_party_label(GameState.player_name, GameState.player_class_id, GameState.player_level)
	for member in GameState.party_members:
		_add_party_label(member["name"], member["class_id"], member.get("level", 1))


func _add_party_label(unit_name: String, class_id: String, level: int) -> void:
	var label := Label.new()
	label.text = "%s - %s Lv.%d" % [unit_name, class_id.capitalize(), level]
	label.add_theme_font_size_override("font_size", 13)
	_party_list.add_child(label)


func _refresh_menu_buttons() -> void:
	for child in _menu_box.get_children():
		if child is Button:
			match child.name:
				"RestBtn":
					child.disabled = not GameState.can_afford(REST_COST)
					child.text = "Rest (-%d gold)" % REST_COST
				"PromoteBtn":
					child.disabled = not GameState.has_any_promotable_member()
				"RecruitBtn":
					child.disabled = GameState.get_party_size() >= GameState.MAX_PARTY_SIZE - 1


func _on_shop() -> void:
	_menu_box.visible = false
	_shop_panel.visible = true
	_shop_panel.setup(TOWN_SHOPS.get(_town_id, []))


func _on_recruit() -> void:
	_menu_box.visible = false
	_recruit_panel.visible = true
	_recruit_panel.setup()


func _on_promote() -> void:
	_menu_box.visible = false
	_promote_panel.visible = true
	_promote_panel.setup()


func _on_rest() -> void:
	if GameState.spend_gold(REST_COST):
		GameState.full_rest_party()
		_refresh()


func _on_leave() -> void:
	GameState.auto_save()
	StoryFlow.advance()


func _on_sub_panel_closed() -> void:
	_menu_box.visible = true
	_shop_panel.visible = false
	_recruit_panel.visible = false
	_promote_panel.visible = false
	_refresh()
