extends Node

const _enums = preload("res://scripts/data/enums.gd")

var player_name: String = ""
var player_gender: String = ""
var player_class_id: String = ""
var player_voice_pack: String = ""

var party_members: Array[Dictionary] = []

var progression_stage: int = 0
var current_battle_id: String = ""
var current_town_id: String = ""
var story_flags: Dictionary = {}

var completed_battles: Array[String] = []

var gold: int = 0
var inventory: Dictionary = {}
var equipment: Dictionary = {}

var unlocked_classes: Array[String] = []
var player_level: int = 1
var player_xp: int = 0
var player_jp: int = 0

var settings: Dictionary = {
	"master_volume": 1.0,
	"music_volume": 0.8,
	"sfx_volume": 1.0,
	"text_speed": 1.0,
	"fullscreen": true,
}

const MAX_PARTY_SIZE := 4
const MAX_SAVE_SLOTS := 3
const AUTOSAVE_SLOT := 3
const REST_HEAL_FRACTION := 0.30

var current_slot: int = -1
var _save_manager = preload("res://scripts/autoload/save_load_manager.gd").new()
var _equipment  # EquipmentManager


func _ready() -> void:
	_equipment = preload("res://scripts/autoload/equipment_manager.gd").new(self)
	_load_settings()


func set_player_info(p_name: String, p_gender: String) -> void:
	player_name = p_name
	player_gender = p_gender
	player_voice_pack = _assign_voice_pack(p_gender)
	unlock_class(p_gender)


func set_player_class(class_id: String) -> void:
	player_class_id = class_id
	unlock_class(class_id)


func add_party_member(p_name: String, p_gender: String, class_id: String, level: int = 1) -> void:
	party_members.append({
		"name": p_name,
		"gender": p_gender,
		"class_id": class_id,
		"level": level,
		"xp": 0,
		"jp": 0,
		"current_hp": -1,
		"current_mp": -1,
		"voice_pack": _assign_voice_pack(p_gender),
		"row": "front",
	})
	unlock_class(class_id)


func remove_party_member(member_name: String) -> void:
	for i in range(party_members.size() - 1, -1, -1):
		if party_members[i]["name"] == member_name:
			party_members.remove_at(i)
			break


func get_party_size() -> int:
	return party_members.size()


func get_voice_pack(unit_name: String) -> String:
	if unit_name == player_name:
		return player_voice_pack
	for member in party_members:
		if member.get("name", "") == unit_name:
			return member.get("voice_pack", "")
	return ""


const _MALE_VOICE_PACKS: Array[String] = ["male_01", "male_02", "male_03", "male_04"]
const _FEMALE_VOICE_PACKS: Array[String] = ["female_01", "female_02", "female_03", "female_04"]


func _assign_voice_pack(gender: String) -> String:
	if gender in ["prince", "male"]:
		return _MALE_VOICE_PACKS[randi() % _MALE_VOICE_PACKS.size()]
	return _FEMALE_VOICE_PACKS[randi() % _FEMALE_VOICE_PACKS.size()]


# --- Class Unlock ---

func unlock_class(class_id: String) -> void:
	if class_id not in unlocked_classes:
		unlocked_classes.append(class_id)


func is_class_unlocked(class_id: String) -> bool:
	return class_id in unlocked_classes


func get_lowest_party_level() -> int:
	var lowest := player_level
	for member in party_members:
		var lvl: int = member.get("level", 1)
		if lvl < lowest:
			lowest = lvl
	return lowest


const RECRUIT_COST_BY_TIER := [100, 300, 600]

func get_recruit_cost(class_id: String) -> int:
	var path := "res://resources/classes/%s.tres" % class_id
	if ResourceLoader.exists(path):
		var data: Resource = load(path) as Resource
		if data and "tier" in data:
			var tier_idx: int = clampi(data.tier, 0, RECRUIT_COST_BY_TIER.size() - 1)
			return RECRUIT_COST_BY_TIER[tier_idx]
	return RECRUIT_COST_BY_TIER[0]


func set_flag(flag: String, value: bool = true) -> void:
	story_flags[flag] = value


func has_flag(flag: String) -> bool:
	return story_flags.get(flag, false)


func complete_battle(battle_id: String) -> void:
	if battle_id not in completed_battles:
		completed_battles.append(battle_id)


func is_battle_completed(battle_id: String) -> bool:
	return battle_id in completed_battles


func update_party_after_battle(player_units: Array) -> Array[String]:
	var fallen: Array[String] = []
	for unit in player_units:
		if not ("team" in unit and "unit_name" in unit and "is_alive" in unit):
			continue
		if unit.team != _enums.Team.PLAYER:
			continue
		if not unit.is_alive:
			if unit.unit_name == player_name:
				fallen.insert(0, unit.unit_name)
			else:
				fallen.append(unit.unit_name)
				remove_party_member(unit.unit_name)
			continue
		if unit.unit_name == player_name:
			player_level = unit.level
			player_xp = unit.xp
			player_jp = unit.jp
			continue
		for i in range(party_members.size()):
			if party_members[i]["name"] == unit.unit_name:
				party_members[i]["level"] = unit.level
				party_members[i]["xp"] = unit.xp
				party_members[i]["jp"] = unit.jp
				party_members[i]["current_hp"] = unit.health
				party_members[i]["current_mp"] = unit.mana
				break
	return fallen


func advance_progression(battle_progression: int) -> void:
	if battle_progression > progression_stage:
		progression_stage = battle_progression


# --- HP/MP Tracking ---

func get_member_max_hp(member: Dictionary) -> int:
	var path := "res://resources/classes/%s.tres" % member.get("class_id", "")
	if ResourceLoader.exists(path):
		var data: Resource = load(path) as Resource
		if data and data.has_method("get_stats_at_level"):
			var stats: Dictionary = data.get_stats_at_level(member.get("level", 1))
			return int(stats.get("max_health", 0))
	return 0


func get_member_max_mp(member: Dictionary) -> int:
	var path := "res://resources/classes/%s.tres" % member.get("class_id", "")
	if ResourceLoader.exists(path):
		var data: Resource = load(path) as Resource
		if data and data.has_method("get_stats_at_level"):
			var stats: Dictionary = data.get_stats_at_level(member.get("level", 1))
			return int(stats.get("max_mana", 0))
	return 0


func get_tracked_hp_mp(unit_name: String) -> Dictionary:
	for member in party_members:
		if member.get("name", "") == unit_name:
			return {
				"hp": member.get("current_hp", -1),
				"mp": member.get("current_mp", -1),
			}
	return {"hp": -1, "mp": -1}


func heal_unit(unit_name: String, amount: int) -> int:
	for member in party_members:
		if member.get("name", "") == unit_name:
			var max_hp: int = get_member_max_hp(member)
			var cur: int = member.get("current_hp", -1)
			if cur < 0:
				cur = max_hp
			var new_hp: int = mini(cur + amount, max_hp)
			member["current_hp"] = new_hp
			return new_hp - cur
	return 0


func restore_mana(unit_name: String, amount: int) -> int:
	for member in party_members:
		if member.get("name", "") == unit_name:
			var max_mp: int = get_member_max_mp(member)
			var cur: int = member.get("current_mp", -1)
			if cur < 0:
				cur = max_mp
			var new_mp: int = mini(cur + amount, max_mp)
			member["current_mp"] = new_mp
			return new_mp - cur
	return 0


func full_rest_party() -> void:
	heal_party_partial(1.0, 1.0)


func heal_party_partial(hp_frac: float, mp_frac: float) -> void:
	for member in party_members:
		var max_hp: int = get_member_max_hp(member)
		var max_mp: int = get_member_max_mp(member)
		var cur_hp: int = member.get("current_hp", -1)
		var cur_mp: int = member.get("current_mp", -1)
		if cur_hp < 0:
			cur_hp = max_hp
		if cur_mp < 0:
			cur_mp = max_mp
		if max_hp > 0:
			member["current_hp"] = mini(cur_hp + int(max_hp * hp_frac), max_hp)
		if max_mp > 0:
			member["current_mp"] = mini(cur_mp + int(max_mp * mp_frac), max_mp)


# --- Gold ---

func add_gold(amount: int) -> void:
	gold += amount


func spend_gold(amount: int) -> bool:
	if gold < amount:
		return false
	gold -= amount
	return true


func can_afford(amount: int) -> bool:
	return gold >= amount


# --- Inventory ---

func add_item(item_id: String, quantity: int = 1) -> void:
	inventory[item_id] = inventory.get(item_id, 0) + quantity


func remove_item(item_id: String, quantity: int = 1) -> bool:
	var owned: int = inventory.get(item_id, 0)
	if owned < quantity:
		return false
	owned -= quantity
	if owned <= 0:
		inventory.erase(item_id)
	else:
		inventory[item_id] = owned
	return true


func get_item_count(item_id: String) -> int:
	return inventory.get(item_id, 0)


func get_consumables_in_inventory() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for item_id in inventory:
		var qty: int = inventory[item_id]
		if qty <= 0:
			continue
		var item: Resource = _load_item(item_id) as Resource
		if item and item.get("is_consumable") and item.is_consumable():
			result.append({"item": item, "quantity": qty})
	return result


# --- Equipment (delegated to EquipmentManager) ---

func get_unit_tier(unit_name: String) -> int:
	return _equipment.get_unit_tier(unit_name)


func get_max_slots(unit_name: String) -> int:
	return _equipment.get_max_slots(unit_name)


func equip_item(unit_name: String, item_id: String) -> bool:
	return _equipment.equip_item(unit_name, item_id)


func unequip_item(unit_name: String, slot_index: int) -> void:
	_equipment.unequip_item(unit_name, slot_index)


func get_equipped_item_at(unit_name: String, slot_index: int) -> Resource:
	return _equipment.get_equipped_item_at(unit_name, slot_index)


func get_all_equipped(unit_name: String) -> Array:
	return _equipment.get_all_equipped(unit_name)


func is_item_unlocked(item: Resource) -> bool:
	return _equipment.is_item_unlocked(item)


func get_item_resource(item_id: String) -> Resource:
	return _load_item(item_id)


func _load_item(item_id: String) -> Resource:
	var path := "res://resources/items/%s.tres" % item_id
	if ResourceLoader.exists(path):
		return load(path) as Resource
	path = "res://resources/items/equipment/%s.tres" % item_id
	if ResourceLoader.exists(path):
		return load(path) as Resource
	return null


# --- Class Promotion ---

const _TIER_1_JP_THRESHOLD := 50
const _TIER_2_JP_THRESHOLD := 100


func get_jp_threshold(current_tier: int) -> int:
	match current_tier:
		0: return _TIER_1_JP_THRESHOLD
		1: return _TIER_2_JP_THRESHOLD
		_: return -1


func can_promote(unit_name: String) -> bool:
	var class_id: String = ""
	var jp: int = 0
	if unit_name == player_name:
		class_id = player_class_id
		jp = player_jp
	else:
		for member in party_members:
			if member.get("name", "") == unit_name:
				class_id = member.get("class_id", "")
				jp = member.get("jp", 0)
				break
	if class_id.is_empty():
		return false
	var path := "res://resources/classes/%s.tres" % class_id
	if not ResourceLoader.exists(path):
		return false
	var data: Resource = load(path) as Resource
	if not data or not ("upgrade_options" in data):
		return false
	if data.upgrade_options.size() == 0:
		return false
	var threshold := get_jp_threshold(data.tier)
	if threshold < 0:
		return false
	return jp >= threshold


func promote_member(unit_name: String, new_class_id: String) -> bool:
	var class_id: String = ""
	var level: int = 1
	if unit_name == player_name:
		class_id = player_class_id
		level = player_level
	else:
		for member in party_members:
			if member.get("name", "") == unit_name:
				class_id = member.get("class_id", "")
				level = member.get("level", 1)
				break
	if class_id.is_empty():
		return false

	var path := "res://resources/classes/%s.tres" % class_id
	if not ResourceLoader.exists(path):
		return false
	var old_data: Resource = load(path) as Resource
	if not old_data or not ("upgrade_options" in old_data):
		return false

	var valid := false
	for opt in old_data.upgrade_options:
		if opt.class_id == new_class_id:
			valid = true
			break
	if not valid:
		return false

	unlock_class(new_class_id)

	if unit_name == player_name:
		player_class_id = new_class_id
		player_jp = 0
	else:
		for member in party_members:
			if member.get("name", "") == unit_name:
				member["class_id"] = new_class_id
				member["jp"] = 0
				var new_path := "res://resources/classes/%s.tres" % new_class_id
				var new_data: Resource = load(new_path) as Resource
				if new_data and new_data.has_method("get_stats_at_level"):
					var stats: Dictionary = new_data.get_stats_at_level(level)
					member["current_hp"] = stats["max_health"]
					member["current_mp"] = stats["max_mana"]
				break

	return true


func has_any_promotable_member() -> bool:
	if can_promote(player_name):
		return true
	for member in party_members:
		if can_promote(member.get("name", "")):
			return true
	return false


func reset_for_new_game() -> void:
	player_name = ""
	player_gender = ""
	player_class_id = ""
	player_voice_pack = ""
	player_level = 1
	player_xp = 0
	player_jp = 0
	party_members.clear()
	progression_stage = 0
	current_battle_id = ""
	current_town_id = ""
	story_flags.clear()
	completed_battles.clear()
	gold = 0
	inventory.clear()
	equipment.clear()
	unlocked_classes.clear()


func save_game() -> void:
	if current_slot < 0 or current_slot >= _save_manager.MAX_SAVE_SLOTS:
		push_error("GameState.save_game: no valid slot selected (current_slot=%d)" % current_slot)
		return
	_save_manager.save_to_slot(current_slot, _build_save_data())


func auto_save() -> void:
	_save_manager.save_to_slot(_save_manager.AUTOSAVE_SLOT, _build_save_data())


func _build_save_data() -> Dictionary:
	return {
		"player_name": player_name,
		"player_gender": player_gender,
		"player_class_id": player_class_id,
		"player_voice_pack": player_voice_pack,
		"player_level": player_level,
		"player_xp": player_xp,
		"player_jp": player_jp,
		"party_members": party_members,
		"progression_stage": progression_stage,
		"current_battle": current_battle_id,
		"story_flags": story_flags,
		"completed_battles": completed_battles,
		"gold": gold,
		"inventory": inventory,
		"equipment": equipment,
		"unlocked_classes": unlocked_classes,
	}


func load_game(slot: int) -> bool:
	var data: Dictionary = _save_manager.load_from_slot(slot)
	if data.is_empty():
		return false
	player_name = data.get("player_name", "")
	player_gender = data.get("player_gender", "")
	player_class_id = data.get("player_class_id", "")
	player_voice_pack = data.get("player_voice_pack", "")
	party_members.assign(data.get("party_members", []))
	progression_stage = data.get("progression_stage", 0)
	current_battle_id = data.get("current_battle", "")
	story_flags = data.get("story_flags", {})
	var cb: Array = data.get("completed_battles", [])
	completed_battles.clear()
	for b in cb:
		completed_battles.append(str(b))
	gold = int(data.get("gold", 0))
	inventory = data.get("inventory", {})
	equipment = data.get("equipment", {})
	player_level = int(data.get("player_level", 1))
	player_xp = int(data.get("player_xp", 0))
	player_jp = int(data.get("player_jp", 0))
	var uc: Array = data.get("unlocked_classes", [])
	unlocked_classes.clear()
	for c in uc:
		unlocked_classes.append(str(c))
	current_slot = slot
	_save_manager.mark_last_used(slot)
	return true


func delete_save(slot: int) -> void:
	_save_manager.delete_save(slot)


func has_save(slot: int) -> bool:
	return _save_manager.has_save(slot)


func has_any_save() -> bool:
	return _save_manager.has_any_save()


func has_autosave() -> bool:
	return _save_manager.has_autosave()


func get_last_used_slot() -> int:
	return _save_manager.get_last_used_slot()


func get_save_summary(slot: int) -> Dictionary:
	return _save_manager.get_save_summary(slot)


# --- Settings ---

func apply_settings() -> void:
	var master_idx := AudioServer.get_bus_index("Master")
	if master_idx >= 0:
		AudioServer.set_bus_volume_db(master_idx, linear_to_db(maxf(0.0001, settings.get("master_volume", 1.0))))
	MusicManager.set_music_volume(settings.get("music_volume", 0.8))
	SFXManager.set_sfx_volume(settings.get("sfx_volume", 1.0))
	var fs: bool = settings.get("fullscreen", true)
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if fs
		else DisplayServer.WINDOW_MODE_WINDOWED
	)


func save_settings() -> void:
	_save_manager.save_settings(settings)


func _load_settings() -> void:
	var data: Dictionary = _save_manager.load_settings()
	if not data.is_empty():
		for key: String in data:
			settings[key] = data[key]
	call_deferred("apply_settings")
