class_name EquipmentDB

## Equipment factory, upgrade logic, and choice definitions.
## Follows the ShopDB / ItemDB static-factory pattern.

const EquipmentData := preload("res://scripts/data/equipment_data.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")


# =============================================================================
# Initial choice lists (for party creation UI)
# =============================================================================

static func get_weapon_choices() -> Array[Dictionary]:
	return [
		{"id": "physical_weapon", "label": "Sharpened Blade",
			"description": "+3 Physical Attack"},
		{"id": "magic_weapon", "label": "Enchanted Staff",
			"description": "+3 Magic Attack"},
		{"id": "combo_weapon", "label": "Balanced Armament",
			"description": "+2 Physical Attack, +2 Magic Attack"},
	]


static func get_armor_choices() -> Array[Dictionary]:
	return [
		{"id": "physical_armor", "label": "Reinforced Plate",
			"description": "+3 Physical Defense"},
		{"id": "magic_armor", "label": "Warded Robe",
			"description": "+3 Magic Defense"},
		{"id": "combo_armor", "label": "Balanced Mail",
			"description": "+2 Physical Defense, +2 Magic Defense"},
	]


static func get_boots_choices() -> Array[Dictionary]:
	return [
		{"id": "speed_boots", "label": "Swift Boots",
			"description": "+3 Speed"},
		{"id": "crit_boots", "label": "Keen Boots",
			"description": "+5 Crit Chance"},
		{"id": "dodge_boots", "label": "Evasive Boots",
			"description": "+5 Dodge Chance"},
	]


# =============================================================================
# Factory
# =============================================================================

static func create_equipment(choice_id: String) -> EquipmentData:
	var e := EquipmentData.new()
	match choice_id:
		# Weapons
		"physical_weapon":
			e.slot = EquipmentData.Slot.WEAPON
			e.display_name = "Sharpened Blade"
			e.base_id = "physical_weapon"
			e.stat_bonuses = {"physical_attack": 3}
		"magic_weapon":
			e.slot = EquipmentData.Slot.WEAPON
			e.display_name = "Enchanted Staff"
			e.base_id = "magic_weapon"
			e.stat_bonuses = {"magic_attack": 3}
		"combo_weapon":
			e.slot = EquipmentData.Slot.WEAPON
			e.display_name = "Balanced Armament"
			e.base_id = "combo_weapon"
			e.stat_bonuses = {"physical_attack": 2, "magic_attack": 2}
		# Armor
		"physical_armor":
			e.slot = EquipmentData.Slot.ARMOR
			e.display_name = "Reinforced Plate"
			e.base_id = "physical_armor"
			e.stat_bonuses = {"physical_defense": 3}
		"magic_armor":
			e.slot = EquipmentData.Slot.ARMOR
			e.display_name = "Warded Robe"
			e.base_id = "magic_armor"
			e.stat_bonuses = {"magic_defense": 3}
		"combo_armor":
			e.slot = EquipmentData.Slot.ARMOR
			e.display_name = "Balanced Mail"
			e.base_id = "combo_armor"
			e.stat_bonuses = {"physical_defense": 2, "magic_defense": 2}
		# Boots
		"speed_boots":
			e.slot = EquipmentData.Slot.BOOTS
			e.display_name = "Swift Boots"
			e.base_id = "speed_boots"
			e.stat_bonuses = {"speed": 3}
		"crit_boots":
			e.slot = EquipmentData.Slot.BOOTS
			e.display_name = "Keen Boots"
			e.base_id = "crit_boots"
			e.stat_bonuses = {"crit_chance": 5}
		"dodge_boots":
			e.slot = EquipmentData.Slot.BOOTS
			e.display_name = "Evasive Boots"
			e.base_id = "dodge_boots"
			e.stat_bonuses = {"dodge_chance": 5}
	return e


# =============================================================================
# Stat application
# =============================================================================

## Apply an equipment piece's stat bonuses to a fighter's base stats.
static func apply_to_fighter(equip: EquipmentData, fighter: FighterData) -> void:
	for stat_name: String in equip.stat_bonuses:
		var amount: int = equip.stat_bonuses[stat_name]
		var current: int = fighter.get(stat_name)
		fighter.set(stat_name, current + amount)
		if stat_name == "max_health":
			fighter.health = fighter.max_health
		elif stat_name == "max_mana":
			fighter.mana = fighter.max_mana


# =============================================================================
# Upgrade options
# =============================================================================

static func get_upgrade_options(equip: EquipmentData) -> Array[Dictionary]:
	if equip.upgrade_level >= 1:
		return []
	match equip.slot:
		EquipmentData.Slot.WEAPON:
			return _weapon_upgrades(equip)
		EquipmentData.Slot.ARMOR:
			return _armor_upgrades(equip)
		EquipmentData.Slot.BOOTS:
			return _boots_upgrades(equip)
	return []


static func _weapon_upgrades(equip: EquipmentData) -> Array[Dictionary]:
	# Auto-double is always applied. Player picks the secondary bonus.
	var double_desc: String = _describe_double(equip)
	var options: Array[Dictionary] = [
		{"id": "mana", "label": "Mana Reservoir",
			"description": "%s, then +3 Max Mana" % double_desc},
		{"id": "crit_chance", "label": "Keen Edge",
			"description": "%s, then +5 Crit Chance" % double_desc},
		{"id": "crit_damage", "label": "Brutal Force",
			"description": "%s, then +3 Crit Damage" % double_desc},
	]
	# Trade-off option
	var trade_desc: String
	match equip.base_id:
		"physical_weapon":
			trade_desc = "%s, then +5 P.ATK but -3 P.DEF" % double_desc
		"magic_weapon":
			trade_desc = "%s, then +5 M.ATK but -3 M.DEF" % double_desc
		"combo_weapon":
			trade_desc = "%s, then +3 P.ATK/+3 M.ATK but -2 P.DEF/-2 M.DEF" % double_desc
		_:
			trade_desc = double_desc
	options.append({"id": "reckless", "label": "Reckless Edge",
		"description": trade_desc})
	return options


static func _armor_upgrades(equip: EquipmentData) -> Array[Dictionary]:
	var double_desc: String = _describe_double(equip)
	var options: Array[Dictionary] = [
		{"id": "health", "label": "Plated",
			"description": "%s, then +5 Max HP" % double_desc},
		{"id": "dodge", "label": "Agile Fit",
			"description": "%s, then +3 Dodge Chance" % double_desc},
		{"id": "mana", "label": "Channeling",
			"description": "%s, then +2 Max Mana" % double_desc},
	]
	var trade_desc: String
	match equip.base_id:
		"physical_armor":
			trade_desc = "%s, then +5 P.DEF but -2 SPD" % double_desc
		"magic_armor":
			trade_desc = "%s, then +5 M.DEF but -2 SPD" % double_desc
		"combo_armor":
			trade_desc = "%s, then +3 P.DEF/+3 M.DEF but -2 SPD" % double_desc
		_:
			trade_desc = double_desc
	options.append({"id": "ironclad", "label": "Ironclad",
		"description": trade_desc})
	return options


static func _boots_upgrades(equip: EquipmentData) -> Array[Dictionary]:
	var double_desc: String = _describe_double(equip)
	var options: Array[Dictionary] = [
		{"id": "speed", "label": "Speed",
			"description": "%s, then +2 Speed" % double_desc},
		{"id": "crit_chance", "label": "Crit Chance",
			"description": "%s, then +3 Crit Chance" % double_desc},
		{"id": "dodge", "label": "Dodge Chance",
			"description": "%s, then +3 Dodge Chance" % double_desc},
		{"id": "crit_damage", "label": "Crit Damage",
			"description": "%s, then +3 Crit Damage" % double_desc},
	]
	var trade_desc: String
	match equip.base_id:
		"speed_boots":
			trade_desc = "%s, then +5 SPD but -3 P.DEF" % double_desc
		"crit_boots":
			trade_desc = "%s, then +5 Crit but -3 M.DEF" % double_desc
		"dodge_boots":
			trade_desc = "%s, then +5 Dodge but -3 P.DEF" % double_desc
		_:
			trade_desc = double_desc
	options.append({"id": "nimble", "label": "Nimble Stride",
		"description": trade_desc})
	return options


static func _describe_double(equip: EquipmentData) -> String:
	var parts: Array[String] = []
	for key: String in equip.stat_bonuses:
		var val: int = equip.stat_bonuses[key]
		parts.append("%s doubles to +%d" % [EquipmentData._stat_short_name(key), val * 2])
	return ", ".join(parts)


# =============================================================================
# Apply upgrade
# =============================================================================

## Apply the chosen upgrade. Doubles existing stats and adds the secondary bonus.
static func apply_upgrade(equip: EquipmentData, fighter: FighterData,
		choice_id: String) -> void:
	if equip.upgrade_level >= 1:
		return

	# Step 1: Double existing stat bonuses (apply the delta to fighter)
	var original_bonuses: Dictionary = equip.stat_bonuses.duplicate()
	for key: String in original_bonuses:
		var delta: int = original_bonuses[key]
		equip.stat_bonuses[key] = delta * 2
		var current: int = fighter.get(key)
		fighter.set(key, current + delta)

	# Step 2: Apply secondary bonus
	var secondary: Dictionary = _get_secondary_bonuses(equip, choice_id)
	for key: String in secondary:
		var amount: int = secondary[key]
		equip.stat_bonuses[key] = equip.stat_bonuses.get(key, 0) + amount
		var current: int = fighter.get(key)
		fighter.set(key, current + amount)
		if key == "max_health":
			fighter.health = fighter.max_health
		elif key == "max_mana":
			fighter.mana = fighter.max_mana

	equip.upgrade_level = 1


static func _get_secondary_bonuses(equip: EquipmentData,
		choice_id: String) -> Dictionary:
	match equip.slot:
		EquipmentData.Slot.WEAPON:
			return _weapon_secondary(equip, choice_id)
		EquipmentData.Slot.ARMOR:
			return _armor_secondary(equip, choice_id)
		EquipmentData.Slot.BOOTS:
			return _boots_secondary(equip, choice_id)
	return {}


static func _weapon_secondary(equip: EquipmentData,
		choice_id: String) -> Dictionary:
	match choice_id:
		"mana": return {"max_mana": 3}
		"crit_chance": return {"crit_chance": 5}
		"crit_damage": return {"crit_damage": 3}
		"reckless":
			match equip.base_id:
				"physical_weapon":
					return {"physical_attack": 5, "physical_defense": -3}
				"magic_weapon":
					return {"magic_attack": 5, "magic_defense": -3}
				"combo_weapon":
					return {"physical_attack": 3, "magic_attack": 3,
						"physical_defense": -2, "magic_defense": -2}
	return {}


static func _armor_secondary(equip: EquipmentData,
		choice_id: String) -> Dictionary:
	match choice_id:
		"health": return {"max_health": 5}
		"dodge": return {"dodge_chance": 3}
		"mana": return {"max_mana": 2}
		"ironclad":
			match equip.base_id:
				"physical_armor":
					return {"physical_defense": 5, "speed": -2}
				"magic_armor":
					return {"magic_defense": 5, "speed": -2}
				"combo_armor":
					return {"physical_defense": 3, "magic_defense": 3, "speed": -2}
	return {}


static func _boots_secondary(_equip: EquipmentData,
		choice_id: String) -> Dictionary:
	match choice_id:
		"speed": return {"speed": 2}
		"crit_chance": return {"crit_chance": 3}
		"dodge": return {"dodge_chance": 3}
		"crit_damage": return {"crit_damage": 3}
		"nimble":
			match _equip.base_id:
				"speed_boots":
					return {"speed": 5, "physical_defense": -3}
				"crit_boots":
					return {"crit_chance": 5, "magic_defense": -3}
				"dodge_boots":
					return {"dodge_chance": 5, "physical_defense": -3}
	return {}


# =============================================================================
# Upgrade narration (story-specific)
# =============================================================================

static func get_upgrade_text(story_id: String) -> Array[String]:
	match story_id:
		"story_1":
			return ["A traveling blacksmith offers to improve your equipment."]
		"story_2":
			return ["You find tools and materials to reinforce your gear."]
		"story_3":
			return ["The innkeeper knows a craftsman. 'He owes me a favor.'"]
	return ["You find an opportunity to improve your equipment."]


# =============================================================================
# Simulation: random equipment
# =============================================================================

## Assign random equipment to a fighter for simulation purposes.
## If upgraded is true, each piece also gets a random upgrade applied.
static func apply_random_equipment(fighter: FighterData, upgraded: bool) -> void:
	var weapon_ids: Array[String] = ["physical_weapon", "magic_weapon", "combo_weapon"]
	var armor_ids: Array[String] = ["physical_armor", "magic_armor", "combo_armor"]
	var boots_ids: Array[String] = ["speed_boots", "crit_boots", "dodge_boots"]

	var weapon := create_equipment(weapon_ids[randi() % weapon_ids.size()])
	apply_to_fighter(weapon, fighter)
	fighter.equipment.append(weapon)

	var armor := create_equipment(armor_ids[randi() % armor_ids.size()])
	apply_to_fighter(armor, fighter)
	fighter.equipment.append(armor)

	var boots := create_equipment(boots_ids[randi() % boots_ids.size()])
	apply_to_fighter(boots, fighter)
	fighter.equipment.append(boots)

	if upgraded:
		var weapon_choices: Array[String] = ["mana", "crit_chance", "crit_damage", "reckless"]
		var armor_choices: Array[String] = ["health", "dodge", "mana", "ironclad"]
		var boots_choices: Array[String] = ["speed", "crit_chance", "dodge", "crit_damage", "nimble"]
		apply_upgrade(weapon, fighter, weapon_choices[randi() % weapon_choices.size()])
		apply_upgrade(armor, fighter, armor_choices[randi() % armor_choices.size()])
		apply_upgrade(boots, fighter, boots_choices[randi() % boots_choices.size()])


# =============================================================================
# Helpers
# =============================================================================

## Get the equipment piece in the given slot, or null.
static func get_by_slot(fighter: FighterData,
		slot: EquipmentData.Slot) -> EquipmentData:
	for equip: EquipmentData in fighter.equipment:
		if equip.slot == slot:
			return equip
	return null
