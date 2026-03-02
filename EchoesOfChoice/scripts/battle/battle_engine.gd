class_name BattleEngine extends RefCounted

## Port of C# Battle.cs — pure combat logic, no UI.
## Emits signals for the battle scene to visualize.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityData := preload("res://scripts/data/ability_data.gd")
const Enums := preload("res://scripts/data/enums.gd")

signal combat_message(text: String)
signal turn_started(fighter: FighterData)
signal action_needed(fighter: FighterData)
signal fighter_died(fighter: FighterData)
signal battle_won
signal battle_lost

var units: Array = []      ## Player party (alive)
var enemies: Array = []    ## Enemy team (alive)
var dead_units: Array = [] ## Dead party members (revived at end)

var _acting_units: Array = []


func start_battle(party: Array, enemy_list: Array) -> void:
	units = party.duplicate()
	enemies = enemy_list.duplicate()
	dead_units.clear()
	for f: FighterData in units:
		f.reset_for_battle()
	for f: FighterData in enemies:
		f.reset_for_battle()


## Advance ATB timers by one tick. Returns true if any units can act.
func tick_atb() -> bool:
	for f: FighterData in units:
		f.turn_calculation += f.speed
	for f: FighterData in enemies:
		f.turn_calculation += f.speed
	return _has_acting_units()


## Get all units ready to act, sorted by highest ATB first.
func get_acting_units() -> Array:
	_acting_units.clear()
	for f: FighterData in units:
		if f.turn_calculation >= 100:
			_acting_units.append(f)
	for f: FighterData in enemies:
		if f.turn_calculation >= 100:
			_acting_units.append(f)
	_acting_units.sort_custom(func(a: FighterData, b: FighterData) -> bool:
		return a.turn_calculation > b.turn_calculation)
	return _acting_units


func _has_acting_units() -> bool:
	for f: FighterData in units:
		if f.turn_calculation >= 100:
			return true
	for f: FighterData in enemies:
		if f.turn_calculation >= 100:
			return true
	return false


func reset_turns() -> void:
	for f: FighterData in units:
		if f.turn_calculation >= 100:
			f.turn_calculation -= 100
	for f: FighterData in enemies:
		if f.turn_calculation >= 100:
			f.turn_calculation -= 100


# =============================================================================
# Combat actions
# =============================================================================

func physical_attack(attacker: FighterData, defender: FighterData) -> void:
	var damage: int = attacker.physical_attack - defender.physical_defense
	if damage < 0:
		damage = 0

	if _check_for_critical(attacker):
		damage += attacker.crit_damage

	if _check_for_dodge(defender):
		combat_message.emit("The attack from %s missed" % attacker.character_name)
		return

	defender.health -= damage
	combat_message.emit("%s did %d points of damage to %s." % [
		attacker.character_name, damage, defender.character_name])


func use_ability_on_enemy(attacker: FighterData, defender: FighterData,
		ability: AbilityData) -> void:
	if ability.impacted_turns == 0:
		# Instant damage
		var damage: int = _calc_ability_damage(attacker, defender, ability)
		if damage < 0:
			damage = 0
		if _check_for_critical(attacker):
			damage += attacker.crit_damage

		defender.health -= damage
		combat_message.emit(ability.flavor_text)
		combat_message.emit("%s did %d points of damage to %s." % [
			attacker.character_name, damage, defender.character_name])

		if ability.life_steal_percent > 0.0 and damage > 0:
			var heal_amount: int = int(damage * ability.life_steal_percent)
			attacker.health = mini(attacker.health + heal_amount, attacker.max_health)
			combat_message.emit("%s absorbed %d health." % [
				attacker.character_name, heal_amount])
	else:
		# Over-time effect
		if ability.damage_per_turn > 0:
			defender.modified_stats.append({
				"stat": ability.modified_stat,
				"modifier": 0,
				"turns": ability.impacted_turns,
				"is_negative": true,
				"damage_per_turn": ability.damage_per_turn,
			})
			combat_message.emit(ability.flavor_text)
			combat_message.emit("%s will take %d damage per turn for %d turns." % [
				defender.character_name, ability.damage_per_turn, ability.impacted_turns])

		if ability.modifier > 0 and (ability.damage_per_turn == 0 \
				or ability.modified_stat != Enums.StatType.HEALTH):
			defender.modified_stats.append({
				"stat": ability.modified_stat,
				"modifier": ability.modifier,
				"turns": ability.impacted_turns,
				"is_negative": true,
				"damage_per_turn": 0,
			})
			_modify_stats(defender, ability.modified_stat, ability.modifier, true)
			if ability.damage_per_turn == 0:
				combat_message.emit(ability.flavor_text)
				combat_message.emit("%s was hit with this ability." % defender.character_name)


func use_ability_on_teammate(caster: FighterData, target: FighterData,
		ability: AbilityData) -> void:
	if ability.impacted_turns == 0:
		# Instant heal
		var heal_amount: int
		if ability.modified_stat == Enums.StatType.MIXED_ATTACK:
			heal_amount = ability.modifier + (caster.physical_attack + caster.magic_attack) / 2
		else:
			heal_amount = ability.modifier + caster.magic_attack

		target.health += heal_amount
		if target.health > target.max_health:
			target.health = target.max_health

		combat_message.emit(ability.flavor_text)
		combat_message.emit("%s healed %d points of damage." % [
			target.character_name, heal_amount])
	else:
		# Buff
		target.modified_stats.append({
			"stat": ability.modified_stat,
			"modifier": ability.modifier,
			"turns": ability.impacted_turns,
			"is_negative": false,
			"damage_per_turn": 0,
		})
		_modify_stats(target, ability.modified_stat, ability.modifier, false)
		combat_message.emit(ability.flavor_text)
		combat_message.emit("%s was impacted by the ability." % target.character_name)


func _calc_ability_damage(attacker: FighterData, defender: FighterData,
		ability: AbilityData) -> int:
	match ability.modified_stat:
		Enums.StatType.MAGIC_ATTACK:
			return ability.modifier + attacker.magic_attack - defender.magic_defense
		Enums.StatType.PHYSICAL_ATTACK:
			return ability.modifier + attacker.physical_attack - defender.physical_defense
		Enums.StatType.MIXED_ATTACK:
			return ability.modifier \
				+ (attacker.physical_attack + attacker.magic_attack) / 2 \
				- (defender.physical_defense + defender.magic_defense) / 2
		_:
			return ability.modifier


# =============================================================================
# Stat modification & reset
# =============================================================================

func _modify_stats(fighter: FighterData, stat: Enums.StatType,
		modifier: int, negative: bool) -> void:
	fighter._apply_stat_change(stat, modifier, negative)


func reset_modified_stat(fighter: FighterData) -> void:
	var to_remove: Array[int] = []

	for i: int in fighter.modified_stats.size():
		var mod: Dictionary = fighter.modified_stats[i]

		if mod.get("damage_per_turn", 0) > 0:
			fighter.health -= mod["damage_per_turn"]
			combat_message.emit("%s takes %d damage from a lingering effect." % [
				fighter.character_name, mod["damage_per_turn"]])

		if mod["turns"] == 0:
			if mod.get("damage_per_turn", 0) == 0:
				_modify_stats(fighter, mod["stat"], mod["modifier"], not mod["is_negative"])
			to_remove.append(i)
		else:
			mod["turns"] -= 1

	for offset: int in to_remove.size():
		fighter.modified_stats.remove_at(to_remove[offset] - offset)


# =============================================================================
# Death checking
# =============================================================================

func check_for_death() -> void:
	var unit_deaths: Array[int] = []
	var enemy_deaths: Array[int] = []

	for i: int in units.size():
		if units[i].health <= 0:
			combat_message.emit("%s the %s has been knocked out." % [
				units[i].character_name, units[i].character_type])
			fighter_died.emit(units[i])
			unit_deaths.append(i)

	for i: int in enemies.size():
		if enemies[i].health <= 0:
			combat_message.emit("%s the %s has been knocked out." % [
				enemies[i].character_name, enemies[i].character_type])
			fighter_died.emit(enemies[i])
			enemy_deaths.append(i)

	for offset: int in unit_deaths.size():
		var idx: int = unit_deaths[offset] - offset
		dead_units.append(units[idx])
		units.remove_at(idx)

	for offset: int in enemy_deaths.size():
		var idx: int = enemy_deaths[offset] - offset
		enemies.remove_at(idx)


func is_battle_over() -> bool:
	return units.is_empty() or enemies.is_empty()


func did_player_win() -> bool:
	return enemies.is_empty()


func finish_battle() -> void:
	if did_player_win():
		units.append_array(dead_units)
		dead_units.clear()
		battle_won.emit()
	else:
		battle_lost.emit()


# =============================================================================
# Crit & dodge
# =============================================================================

func _check_for_critical(fighter: FighterData) -> bool:
	return randi_range(1, 100) <= fighter.crit_chance


func _check_for_dodge(fighter: FighterData) -> bool:
	return randi_range(1, 100) <= fighter.dodge_chance


# =============================================================================
# Taunt
# =============================================================================

func get_taunt_target(targets: Array) -> FighterData:
	for t: FighterData in targets:
		if t.health > 0 and _has_modifier(t, Enums.StatType.TAUNT, false):
			return t
	return null


func _has_modifier(fighter: FighterData, stat: Enums.StatType,
		is_negative: bool) -> bool:
	for mod: Dictionary in fighter.modified_stats:
		if mod["stat"] == stat and mod["is_negative"] == is_negative:
			return true
	return false


# =============================================================================
# AI — port of C# ExecuteAITurn
# =============================================================================

func execute_ai_turn(unit: FighterData, targets: Array,
		allies: Array) -> void:
	var affordable: Array[AbilityData] = []
	var heal_abilities: Array[AbilityData] = []
	var buff_abilities: Array[AbilityData] = []
	var offensive_abilities: Array[AbilityData] = []
	var taunt_ability: AbilityData = null
	var has_aoe_buff: bool = false

	for a: AbilityData in unit.abilities:
		if a.mana_cost > unit.mana:
			continue
		affordable.append(a)

		if a.use_on_enemy:
			offensive_abilities.append(a)
		elif a.impacted_turns == 0:
			heal_abilities.append(a)
		elif a.modified_stat == Enums.StatType.TAUNT:
			taunt_ability = a
		else:
			buff_abilities.append(a)
			if a.target_all:
				has_aoe_buff = true

	var total_attack: float = unit.magic_attack + unit.physical_attack
	var magic_ratio: float = unit.magic_attack / total_attack if total_attack > 0 else 0.5

	# Priority 1: Heal a wounded ally
	if not heal_abilities.is_empty():
		var wounded: FighterData = null
		for ally: FighterData in allies:
			if ally.health > 0 and ally.health < ally.max_health * 0.5:
				if wounded == null or ally.health < wounded.health:
					wounded = ally
		if wounded != null:
			var heal: AbilityData = heal_abilities[randi_range(0, heal_abilities.size() - 1)]
			unit.mana -= heal.mana_cost
			if heal.target_all:
				for ally: FighterData in allies:
					if ally.health > 0:
						use_ability_on_teammate(unit, ally, heal)
			else:
				use_ability_on_teammate(unit, wounded, heal)
			return

	# Priority 1.5: Taunt if defensive unit
	if taunt_ability != null and not _has_modifier(unit, Enums.StatType.TAUNT, false):
		var def_total: float = unit.physical_defense + unit.magic_defense
		var off_total: float = unit.physical_attack + unit.magic_attack
		var tank_ratio: float = def_total / (def_total + off_total)
		var taunt_chance: float = tank_ratio * (targets.size() / 3.0)
		if randf() < taunt_chance:
			unit.mana -= taunt_ability.mana_cost
			use_ability_on_teammate(unit, unit, taunt_ability)
			return

	# Priority 2: Small chance to buff allies
	if not buff_abilities.is_empty():
		var buff_roll: int = randi_range(0, 4)
		var try_buff: bool = buff_roll == 0 or (buff_roll <= 1 and has_aoe_buff)
		if try_buff:
			var buff: AbilityData = buff_abilities[randi_range(0, buff_abilities.size() - 1)]
			if buff.target_all:
				var any_unbuffed: bool = false
				for ally: FighterData in allies:
					if ally.health > 0 and not _has_modifier(ally, buff.modified_stat, false):
						any_unbuffed = true
						break
				if any_unbuffed:
					unit.mana -= buff.mana_cost
					for ally: FighterData in allies:
						if ally.health > 0:
							use_ability_on_teammate(unit, ally, buff)
					return
			else:
				var buff_target: FighterData = null
				var best_total: int = -1
				for ally: FighterData in allies:
					if ally.health > 0:
						var t: int = ally.physical_attack + ally.magic_attack
						if t > best_total:
							best_total = t
							buff_target = ally
				if buff_target != null and not _has_modifier(buff_target, buff.modified_stat, false):
					unit.mana -= buff.mana_cost
					use_ability_on_teammate(unit, buff_target, buff)
					return

	# Priority 3: Offensive ability vs physical attack
	var ability_chance: float = magic_ratio
	if magic_ratio < 0.4 and not offensive_abilities.is_empty():
		for a: AbilityData in offensive_abilities:
			if a.modified_stat == Enums.StatType.PHYSICAL_ATTACK \
					or a.modified_stat == Enums.StatType.MIXED_ATTACK:
				ability_chance = 0.4
				break

	var use_ability: bool = not offensive_abilities.is_empty() and randf() < ability_chance

	if use_ability:
		var ability: AbilityData = _choose_offensive_ability(
			unit, offensive_abilities, magic_ratio)
		unit.mana -= ability.mana_cost
		if ability.target_all:
			for target: FighterData in targets.duplicate():
				use_ability_on_enemy(unit, target, ability)
		else:
			var target: FighterData = _choose_target(unit, targets, magic_ratio)
			use_ability_on_enemy(unit, target, ability)
	else:
		var target: FighterData = _choose_target(unit, targets, magic_ratio)
		physical_attack(unit, target)


func _choose_target(unit: FighterData, targets: Array,
		magic_ratio: float) -> FighterData:
	var taunter: FighterData = get_taunt_target(targets)
	if taunter != null:
		return taunter

	var pick_lowest: bool = magic_ratio > 0.6 \
		or (magic_ratio >= 0.4 and randf() < 0.6)
	return _find_min_health(targets) if pick_lowest else _find_max_health(targets)


func _find_min_health(targets: Array) -> FighterData:
	var best: FighterData = targets[0]
	for i: int in range(1, targets.size()):
		if targets[i].health < best.health:
			best = targets[i]
	return best


func _find_max_health(targets: Array) -> FighterData:
	var best: FighterData = targets[0]
	for i: int in range(1, targets.size()):
		if targets[i].health > best.health:
			best = targets[i]
	return best


func _choose_offensive_ability(unit: FighterData,
		offensive_abilities: Array[AbilityData], magic_ratio: float) -> AbilityData:
	var preferred: Enums.StatType = Enums.StatType.MAGIC_ATTACK \
		if magic_ratio > 0.5 else Enums.StatType.PHYSICAL_ATTACK
	var preferred_list: Array[AbilityData] = []

	for a: AbilityData in offensive_abilities:
		if a.modified_stat == preferred or a.modified_stat == Enums.StatType.MIXED_ATTACK:
			preferred_list.append(a)

	if not preferred_list.is_empty():
		return preferred_list[randi_range(0, preferred_list.size() - 1)]
	return offensive_abilities[randi_range(0, offensive_abilities.size() - 1)]
