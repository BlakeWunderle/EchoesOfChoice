class_name TurnManager extends Node

signal unit_turn_started(unit: Unit)
signal unit_turn_ended(unit: Unit)
signal round_ended
signal battle_ended(player_won: bool)

var all_units: Array[Unit] = []
var player_units: Array[Unit] = []
var enemy_units: Array[Unit] = []
var current_unit: Unit = null
var round_number: int = 0
var battle_active: bool = false
var paused: bool = false

const TURN_THRESHOLD := 100


func setup(units: Array[Unit]) -> void:
	all_units = units
	player_units.clear()
	enemy_units.clear()
	for unit in all_units:
		if unit.team == Enums.Team.PLAYER:
			player_units.append(unit)
		else:
			enemy_units.append(unit)
		unit.died.connect(_on_unit_died)
	round_number = 0
	battle_active = true


func run_battle() -> void:
	while battle_active:
		advance_time()
		var acting := _get_acting_units()
		if acting.size() == 0:
			continue

		for unit in acting:
			if not unit.is_alive:
				continue
			if not battle_active:
				break

			unit.turn_counter -= TURN_THRESHOLD
			current_unit = unit
			unit.start_turn()
			unit_turn_started.emit(unit)

			await unit.turn_completed

			unit_turn_ended.emit(unit)
			current_unit = null

			_check_battle_end()

		round_number += 1
		round_ended.emit()
		while paused:
			await get_tree().process_frame


func advance_time() -> void:
	for unit in all_units:
		if unit.is_alive:
			unit.turn_counter += unit.speed


func _get_acting_units() -> Array[Unit]:
	var acting: Array[Unit] = []
	for unit in all_units:
		if unit.is_alive and unit.turn_counter >= TURN_THRESHOLD:
			acting.append(unit)
	acting.sort_custom(func(a: Unit, b: Unit) -> bool:
		return a.turn_counter > b.turn_counter
	)
	return acting


func _on_unit_died(unit: Unit) -> void:
	if unit.team == Enums.Team.PLAYER:
		player_units.erase(unit)
	else:
		enemy_units.erase(unit)
	_check_battle_end()


func _check_battle_end() -> void:
	var alive_players := player_units.filter(func(u: Unit) -> bool: return u.is_alive)
	var alive_enemies := enemy_units.filter(func(u: Unit) -> bool: return u.is_alive)

	if alive_players.size() == 0:
		battle_active = false
		battle_ended.emit(false)
	elif alive_enemies.size() == 0:
		battle_active = false
		battle_ended.emit(true)


func get_turn_order_preview(count: int = 8) -> Array[Unit]:
	var preview: Array[Unit] = []
	var sim_counters := {}
	for unit in all_units:
		if unit.is_alive:
			sim_counters[unit] = unit.turn_counter

	for _i in range(count):
		while true:
			var ready_unit: Unit = null
			var best_counter := -1
			for unit in sim_counters:
				sim_counters[unit] += unit.speed
				if sim_counters[unit] >= TURN_THRESHOLD and sim_counters[unit] > best_counter:
					best_counter = sim_counters[unit]
					ready_unit = unit
			if ready_unit:
				preview.append(ready_unit)
				sim_counters[ready_unit] -= TURN_THRESHOLD
				break

	return preview
