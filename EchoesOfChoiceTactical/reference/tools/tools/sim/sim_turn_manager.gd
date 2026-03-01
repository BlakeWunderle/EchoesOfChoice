## Synchronous ATB turn manager for headless simulation.
## No signals, no await — runs the full battle loop and returns the result.
class_name SimTurnManager extends RefCounted

const TURN_THRESHOLD := 100
const MAX_ROUNDS := 200

var all_units: Array = []
var player_units: Array = []
var enemy_units: Array = []
var round_number: int = 0


func setup(units: Array) -> void:
	all_units = units
	player_units = []
	enemy_units = []
	for unit in units:
		if unit.team == Enums.Team.PLAYER:
			player_units.append(unit)
		else:
			enemy_units.append(unit)
	# Randomize initial turn counters slightly to avoid deterministic ordering
	for unit in all_units:
		unit.turn_counter = randi_range(0, unit.speed)


## Run the full battle. Returns {"player_won": bool, "turns": int}.
func run_battle(ai) -> Dictionary:
	ai.set_units(all_units, player_units, enemy_units)
	var total_turns := 0

	while round_number < MAX_ROUNDS:
		_advance_time()
		var acting := _get_acting_units()
		for unit in acting:
			if not unit.is_alive:
				continue
			unit.start_turn()
			unit.turn_counter -= TURN_THRESHOLD
			ai.run_turn(unit)
			total_turns += 1

			var result := _check_battle_end()
			if result != 0:
				return {"player_won": result == 1, "turns": total_turns}

		round_number += 1
		# Reset reactions each round
		for unit in all_units:
			if unit.is_alive:
				unit.has_reaction = true

	# Exceeded max rounds — player loses (couldn't finish the fight)
	return {"player_won": false, "turns": total_turns}


func _advance_time() -> void:
	# Find the minimum ticks needed for any living unit to reach threshold
	var min_ticks := TURN_THRESHOLD
	for unit in all_units:
		if not unit.is_alive:
			continue
		var remaining: int = TURN_THRESHOLD - unit.turn_counter
		var ticks_needed := ceili(float(remaining) / float(unit.speed))
		if ticks_needed < min_ticks:
			min_ticks = ticks_needed
	min_ticks = maxi(min_ticks, 1)

	for unit in all_units:
		if unit.is_alive:
			unit.turn_counter += unit.speed * min_ticks


func _get_acting_units() -> Array:
	var acting: Array = []
	for unit in all_units:
		if unit.is_alive and unit.turn_counter >= TURN_THRESHOLD:
			acting.append(unit)
	# Sort by turn_counter descending (highest goes first), speed as tiebreaker
	acting.sort_custom(func(a, b):
		if a.turn_counter != b.turn_counter:
			return a.turn_counter > b.turn_counter
		return a.speed > b.speed
	)
	return acting


## Returns 0 (ongoing), 1 (player wins), -1 (player loses).
func _check_battle_end() -> int:
	var player_alive := false
	var enemy_alive := false
	for unit in player_units:
		if unit.is_alive:
			player_alive = true
			break
	for unit in enemy_units:
		if unit.is_alive:
			enemy_alive = true
			break

	if not enemy_alive:
		return 1
	if not player_alive:
		return -1
	return 0
