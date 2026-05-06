extends Node

## Quick-launch a town stop for testing upgrades, equipment, and shop UI.
## Run via: Godot --path PartingShadows --scene res://tools/debug_town_stop.tscn

const FighterDB := preload("res://scripts/data/fighter_db.gd")
const EquipmentDB := preload("res://scripts/data/equipment_db.gd")

const BATTLE_ID := "CopperMugStop"


func _ready() -> void:
	_launch_town_stop.call_deferred()


func _launch_town_stop() -> void:
	var fighter1 := FighterDB.create_player("Squire", "Aldric", "m")
	var fighter2 := FighterDB.create_player("Mage", "Sera", "f")
	var fighter3 := FighterDB.create_player("Wildling", "Fenn", "m")

	# Level to 4, T0 -> T1
	for _i: int in 3:
		FighterDB.level_up(fighter1)
		FighterDB.level_up(fighter2)
		FighterDB.level_up(fighter3)
	FighterDB.upgrade_class(fighter1, "Sword")      # Squire -> Duelist
	FighterDB.upgrade_class(fighter2, "RedStone")   # Mage -> Invoker
	FighterDB.upgrade_class(fighter3, "BeastClaw")  # Wildling -> Beastcaller

	# Level to ~9 (T2 upgrade point)
	for _i: int in 5:
		FighterDB.level_up(fighter1)
		FighterDB.level_up(fighter2)
		FighterDB.level_up(fighter3)

	# Base equipment (upgrade_level=0) so equipment phase triggers
	_equip_fighter(fighter1, "physical_weapon", "physical_armor", "speed_boots")
	_equip_fighter(fighter2, "magic_weapon", "magic_armor", "crit_boots")
	_equip_fighter(fighter3, "combo_weapon", "combo_armor", "dodge_boots")

	# Gold for shop
	GameState.inventory.gold = 500

	GameState.current_story_id = "story_1"
	GameState.set_party([fighter1, fighter2, fighter3])
	GameState.advance_to_battle(BATTLE_ID)
	SceneManager.change_scene("res://scenes/town_stop/town_stop.tscn", 0.3, false)


func _equip_fighter(fighter: RefCounted, weapon_id: String, armor_id: String,
		boots_id: String) -> void:
	var weapon := EquipmentDB.create_equipment(weapon_id)
	var armor := EquipmentDB.create_equipment(armor_id)
	var boots := EquipmentDB.create_equipment(boots_id)
	EquipmentDB.apply_to_fighter(weapon, fighter)
	EquipmentDB.apply_to_fighter(armor, fighter)
	EquipmentDB.apply_to_fighter(boots, fighter)
	fighter.equipment = [weapon, armor, boots]
