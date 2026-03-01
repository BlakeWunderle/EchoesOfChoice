class_name AbilityExecutor extends RefCounted

var _grid: Grid
var _reaction_system: ReactionSystem
var _results: Array[Dictionary] = []
var _defensive_reactions: Array[Dictionary] = []
var _offensive_reactions: Array[Dictionary] = []


func _init(p_grid: Grid, p_reaction: ReactionSystem) -> void:
	_grid = p_grid
	_reaction_system = p_reaction


## Dispatches ability execution by type. Returns a Dictionary with:
##   "terrain_changed": bool, "results": Array[Dictionary],
##   "ability": AbilityData, "defensive_reactions": Array[Dictionary]
func execute(unit: Unit, ability: AbilityData, aoe_tiles: Array[Vector2i]) -> Dictionary:
	_results = []
	_defensive_reactions = []
	_offensive_reactions = []
	var terrain_changed := false

	if ability.is_terrain_ability():
		_execute_terrain(unit, ability, aoe_tiles)
		terrain_changed = true
	elif ability.is_heal():
		_execute_heal(unit, ability, aoe_tiles)
	elif ability.is_buff_or_debuff():
		_execute_buff(unit, ability, aoe_tiles)
	else:
		_execute_damage(unit, ability, aoe_tiles)
		for r in _results:
			if r.get("type") == "destructible" and r.get("destroyed", false):
				terrain_changed = true
				break

	return {
		"terrain_changed": terrain_changed,
		"results": _results,
		"ability": ability,
		"defensive_reactions": _defensive_reactions,
		"offensive_reactions": _offensive_reactions,
	}


func _execute_damage(attacker: Unit, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	var got_crit := false
	var got_kill := false

	for tile in tiles:
		var target = _grid.get_occupant(tile)
		if not target is Unit or not target.is_alive:
			continue
		if target.team == attacker.team:
			continue

		var damage := Combat.calculate_ability_damage(ability, attacker.get_stats_dict(), target.get_stats_dict())

		if Combat.roll_dodge(target.dodge_chance):
			SFXManager.play(SFXManager.Category.WHOOSH, 0.7)
			_results.append({"target": target, "type": "dodge"})
			continue

		var this_crit := Combat.roll_crit(attacker.crit_chance)
		if this_crit:
			damage += attacker.crit_damage
			got_crit = true

		var def_result := _reaction_system.process_defensive_reactions(target, damage)
		damage = def_result["final_damage"]
		_defensive_reactions.append_array(def_result["reactions"])

		var old_hp_ratio := float(target.health) / float(target.max_health) if target.max_health > 0 else 0.0
		target.take_damage(damage)
		var new_hp_ratio := float(target.health) / float(target.max_health) if target.max_health > 0 else 0.0
		SFXManager.play_ability_sfx(ability)
		if this_crit:
			SFXManager.play(SFXManager.Category.IMPACT, 0.8)

		var killed: bool = not target.is_alive
		if killed:
			got_kill = true

		_results.append({
			"target": target, "type": "damage", "amount": damage,
			"is_crit": this_crit, "killed": killed,
			"old_hp_ratio": old_hp_ratio, "new_hp_ratio": new_hp_ratio,
		})

		var flanking_results := _reaction_system.check_flanking_strikes(attacker, target)
		_offensive_reactions.append_array(flanking_results)

		if target.is_alive:
			var heal_results := _reaction_system.check_reactive_heal(target, damage)
			_offensive_reactions.append_array(heal_results)

	# Damage destructible tiles in AoE
	for tile in tiles:
		if not _grid.is_destructible(tile):
			continue
		var destr_stats := {"phys_def": 0, "mag_def": 0, "dodge_chance": 0}
		var dmg := maxi(Combat.calculate_ability_damage(ability, attacker.get_stats_dict(), destr_stats), 1)
		var result := _grid.damage_destructible(tile, dmg)
		_results.append({
			"type": "destructible", "pos": tile,
			"amount": result["damage_dealt"], "destroyed": result["destroyed"],
		})

	attacker.award_ability_xp_jp(ability, got_crit, got_kill)


func _execute_heal(caster: Unit, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	for tile in tiles:
		var target = _grid.get_occupant(tile)
		if not target is Unit or not target.is_alive:
			continue
		if target.team != caster.team:
			continue
		var amount := Combat.calculate_heal(ability, caster.magic_attack, caster.physical_attack)
		var old_hp_ratio := float(target.health) / float(target.max_health) if target.max_health > 0 else 0.0
		if ability.modified_stat == Enums.StatType.MAX_MANA:
			target.restore_mana(amount)
			_results.append({"target": target, "type": "mana_heal", "amount": amount})
		else:
			target.heal(amount)
			var new_hp_ratio := float(target.health) / float(target.max_health) if target.max_health > 0 else 0.0
			_results.append({
				"target": target, "type": "heal", "amount": amount,
				"old_hp_ratio": old_hp_ratio, "new_hp_ratio": new_hp_ratio,
			})
		SFXManager.play(SFXManager.Category.SHIMMER)

	caster.award_ability_xp_jp(ability, false, false)


func _execute_buff(caster: Unit, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	for tile in tiles:
		var target = _grid.get_occupant(tile)
		if not target is Unit or not target.is_alive:
			continue

		var is_debuff := ability.ability_type == Enums.AbilityType.DEBUFF
		if is_debuff and target.team == caster.team:
			continue
		if not is_debuff and target.team != caster.team:
			continue

		var ms := ModifiedStat.create(ability.modified_stat, ability.modifier, ability.impacted_turns, is_debuff)
		target.modified_stats.append(ms)
		target.apply_stat_modifier(ability.modified_stat, ability.modifier, is_debuff)
		SFXManager.play(SFXManager.Category.SHIMMER, 0.8)

		var stat_name: String = Enums.StatType.keys()[ability.modified_stat] if ability.modified_stat < Enums.StatType.size() else "STAT"
		_results.append({
			"target": target, "type": "debuff" if is_debuff else "buff",
			"stat_name": stat_name,
		})

	caster.award_ability_xp_jp(ability, false, false)


func _execute_terrain(caster: Unit, ability: AbilityData, tiles: Array[Vector2i]) -> void:
	var blocks_movement := ability.terrain_tile == Enums.TileType.WALL \
		or ability.terrain_tile == Enums.TileType.ICE_WALL
	SFXManager.play_ability_sfx(ability)
	for tile in tiles:
		if blocks_movement and _grid.is_occupied(tile):
			continue
		_grid.place_terrain(tile, ability.terrain_tile, ability.terrain_duration)
		if ability.terrain_tile == Enums.TileType.FIRE_TILE:
			var occupant = _grid.get_occupant(tile)
			if occupant is Unit and occupant.is_alive:
				apply_fire_damage(occupant)
	_results.append({"type": "terrain"})
	caster.award_ability_xp_jp(ability, false, false)


func apply_fire_damage(unit: Unit) -> void:
	var dmg: int = max(1, 10 - unit.magic_defense)
	var old_hp_ratio := float(unit.health) / float(unit.max_health) if unit.max_health > 0 else 0.0
	unit.take_damage(dmg)
	var new_hp_ratio := float(unit.health) / float(unit.max_health) if unit.max_health > 0 else 0.0
	SFXManager.play(SFXManager.Category.FIRE, 0.7)
	_results.append({
		"target": unit, "type": "damage", "amount": dmg,
		"is_crit": false, "killed": not unit.is_alive,
		"old_hp_ratio": old_hp_ratio, "new_hp_ratio": new_hp_ratio,
	})
