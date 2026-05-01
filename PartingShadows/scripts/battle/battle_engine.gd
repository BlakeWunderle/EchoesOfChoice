class_name BattleEngine extends RefCounted

## Port of C# Battle.cs. Pure combat logic, no UI.
## Emits signals for the battle scene to visualize.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityData := preload("res://scripts/data/ability_data.gd")
const ItemData := preload("res://scripts/data/item_data.gd")
const Enums := preload("res://scripts/data/enums.gd")

signal combat_message(text: String)
signal combat_event(target: FighterData, amount: int, event_type: String)
signal fighter_died(fighter: FighterData)
signal battle_won
signal battle_lost

var units: Array = []      ## Player party (alive)
var enemies: Array = []    ## Enemy team (alive)
var dead_units: Array = [] ## Dead party members (revived at end)

var sim_mode: bool = false  ## Skip signal emissions for headless simulation
var difficulty_level: int = 1  ## 0=easy, 1=normal, 2=hard. Set by caller.
var _eff_diff: int = 1  ## Effective difficulty for current turn (player always 2)
var sim_stats: Dictionary = {}  ## Per-fighter combat stats (sim mode only)
var _acting_units: Array = []


func start_battle(party: Array, enemy_list: Array) -> void:
	units = party.duplicate()
	enemies = enemy_list.duplicate()
	dead_units.clear()
	for f: FighterData in units:
		f.reset_for_battle()
	for f: FighterData in enemies:
		f.reset_for_battle()


## Start battle without array duplication. Sim mode only: callers must
## pass freshly-created or cloned arrays that will not be reused.
func start_battle_sim(party: Array, enemy_list: Array) -> void:
	units = party
	enemies = enemy_list
	dead_units.clear()
	for f: FighterData in units:
		f.reset_for_battle()
	for f: FighterData in enemies:
		f.reset_for_battle()
	sim_stats.clear()
	for f: FighterData in units:
		sim_stats[f] = {dmg_dealt = 0, dmg_taken = 0, heals = 0, died = false, dmg_mitigated = 0, buffs_applied = 0, debuffs_applied = 0}
	for f: FighterData in enemies:
		sim_stats[f] = {dmg_dealt = 0, dmg_taken = 0, heals = 0, died = false, dmg_mitigated = 0, buffs_applied = 0, debuffs_applied = 0}


## Advance ATB timers by one tick. Returns true if any units can act.
func tick_atb() -> bool:
	for f: FighterData in units:
		f.turn_calculation += f.speed
	for f: FighterData in enemies:
		f.turn_calculation += f.speed
	return _has_acting_units()


## Fast-forward ATB to the exact point where the next actor(s) reach 100.
## Always produces at least one ready actor. Used by the simulation runner
## to skip the many no-op ticks where nobody is ready.
func tick_atb_fast() -> void:
	var min_ticks := 999999
	for f: FighterData in units:
		var remaining := 100 - f.turn_calculation
		if remaining <= 0:
			min_ticks = 0
			break
		var needed := ceili(float(remaining) / float(f.speed))
		if needed < min_ticks:
			min_ticks = needed
	if min_ticks > 0:
		for f: FighterData in enemies:
			var remaining := 100 - f.turn_calculation
			if remaining <= 0:
				min_ticks = 0
				break
			var needed := ceili(float(remaining) / float(f.speed))
			if needed < min_ticks:
				min_ticks = needed
	if min_ticks > 0:
		for f: FighterData in units:
			f.turn_calculation += f.speed * min_ticks
		for f: FighterData in enemies:
			f.turn_calculation += f.speed * min_ticks


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
	var phys_damage: int = maxi(attacker.physical_attack - defender.physical_defense, 0)
	var mag_damage: int = maxi((attacker.magic_attack - defender.magic_defense) / 2, 0)
	var damage: int = maxi(phys_damage, mag_damage)

	var is_crit: bool = _check_for_critical(attacker)
	if is_crit:
		damage += attacker.crit_damage

	if _check_for_dodge(defender):
		if not sim_mode:
			combat_message.emit("[color=#b3b3b3]The attack from %s missed[/color]" % attacker.character_name)
			combat_event.emit(defender, 0, "miss")
		return

	defender.health -= damage
	if sim_mode:
		sim_stats[attacker].dmg_dealt += damage
		sim_stats[defender].dmg_taken += damage
		var raw_phys: int = maxi(attacker.physical_attack, 0)
		var raw_mag: int = maxi(attacker.magic_attack / 2, 0)
		var raw_base: int = maxi(raw_phys, raw_mag)
		var base_after_def: int = damage - (attacker.crit_damage if is_crit else 0)
		sim_stats[defender].dmg_mitigated += maxi(raw_base - base_after_def, 0)
	else:
		var crit_tag: String = " [color=#ffd933](Critical!)[/color]" if is_crit else ""
		combat_message.emit("[color=#ff4d4d]%s did %d points of damage to %s.[/color]%s" % [
			attacker.character_name, damage, defender.character_name, crit_tag])
		combat_event.emit(defender, damage, "crit" if is_crit else "damage")

	# Restore MP based on magic attack
	var mp_restore: int = maxi(1, floori(attacker.magic_attack / 7))
	attacker.mana = mini(attacker.mana + mp_restore, attacker.max_mana)
	if not sim_mode:
		combat_event.emit(attacker, mp_restore, "mp_restore")


func use_ability_on_enemy(attacker: FighterData, defender: FighterData,
		ability: AbilityData, skip_flavor: bool = false) -> void:
	if _check_for_ability_dodge(defender):
		if not sim_mode:
			combat_message.emit("[color=#b3b3b3]%s dodged %s's ability![/color]" % [
				defender.character_name, attacker.character_name])
			combat_event.emit(defender, 0, "miss")
		return

	if ability.impacted_turns == 0:
		# Instant damage
		var damage: int = _calc_ability_damage(attacker, defender, ability)
		if damage < 0:
			damage = 0
		var is_crit: bool = _check_for_critical(attacker)
		if is_crit:
			damage += attacker.crit_damage

		defender.health -= damage
		if sim_mode:
			sim_stats[attacker].dmg_dealt += damage
			sim_stats[defender].dmg_taken += damage
			var raw_ability: int = maxi(_calc_ability_damage_raw(attacker, ability), 0)
			var base_after_def: int = damage - (attacker.crit_damage if is_crit else 0)
			sim_stats[defender].dmg_mitigated += maxi(raw_ability - base_after_def, 0)
		else:
			if not skip_flavor:
				combat_message.emit(ability.flavor_text)
			var crit_tag: String = " [color=#ffd933](Critical!)[/color]" if is_crit else ""
			combat_message.emit("[color=#9966ff]%s did %d points of damage to %s.[/color]%s" % [
				attacker.character_name, damage, defender.character_name, crit_tag])
			combat_event.emit(defender, damage, "spell_crit" if is_crit else "spell_damage")

		if ability.life_steal_percent > 0.0 and damage > 0:
			var heal_amount: int = int(damage * ability.life_steal_percent)
			attacker.health = mini(attacker.health + heal_amount, attacker.max_health)
			if sim_mode:
				sim_stats[attacker].heals += heal_amount
			else:
				combat_message.emit("[color=#4dff66]%s absorbed %d health.[/color]" % [
					attacker.character_name, heal_amount])
				combat_event.emit(attacker, heal_amount, "heal")
	else:
		# Over-time effect
		if ability.damage_per_turn > 0:
			var dot_flat: int = maxi(1, floori(
				float(defender.max_health) * float(ability.damage_per_turn) / 100.0))
			defender.modified_stats.append({
				"stat": ability.modified_stat,
				"modifier": 0,
				"turns": ability.impacted_turns,
				"is_negative": true,
				"damage_per_turn": dot_flat,
			})
			if sim_mode:
				sim_stats[attacker].debuffs_applied += 1
			if not sim_mode:
				if not skip_flavor:
					combat_message.emit(ability.flavor_text)
				combat_message.emit("[color=#cc4dcc]%s will take %d damage per turn for %d turns.[/color]" % [
					defender.character_name, dot_flat, ability.impacted_turns])
				combat_event.emit(defender, dot_flat, "debuff")

		if ability.modifier > 0 and (ability.damage_per_turn == 0 \
				or ability.modified_stat != Enums.StatType.HEALTH):
			var delta: int = _compute_buff_delta(
				defender, ability.modified_stat, ability.modifier)
			defender.modified_stats.append({
				"stat": ability.modified_stat,
				"modifier": delta,
				"turns": ability.impacted_turns,
				"is_negative": true,
				"damage_per_turn": 0,
			})
			_modify_stats(defender, ability.modified_stat, delta, true)
			if sim_mode:
				sim_stats[attacker].debuffs_applied += 1
			if not sim_mode and ability.damage_per_turn == 0:
				if not skip_flavor:
					combat_message.emit(ability.flavor_text)
				combat_message.emit("[color=#cc4dcc]%s was hit with this ability.[/color]" % defender.character_name)
				combat_event.emit(defender, delta, "debuff")


func use_ability_on_teammate(caster: FighterData, target: FighterData,
		ability: AbilityData, skip_flavor: bool = false) -> void:
	if ability.impacted_turns == 0:
		# Instant heal
		var heal_amount: int
		if ability.modified_stat == Enums.StatType.MIXED_ATTACK:
			heal_amount = ability.modifier + (caster.physical_attack + caster.magic_attack) / 4
		else:
			heal_amount = ability.modifier + caster.magic_attack / 2
		heal_amount = maxi(0, heal_amount)

		target.health += heal_amount
		if target.health > target.max_health:
			target.health = target.max_health

		if sim_mode:
			sim_stats[caster].heals += heal_amount
		else:
			if not skip_flavor:
				combat_message.emit(ability.flavor_text)
			combat_message.emit("[color=#4dff66]%s healed %d points of damage.[/color]" % [
				target.character_name, heal_amount])
			combat_event.emit(target, heal_amount, "heal")
	else:
		# Buff
		var delta: int = _compute_buff_delta(
			target, ability.modified_stat, ability.modifier)
		target.modified_stats.append({
			"stat": ability.modified_stat,
			"modifier": delta,
			"turns": ability.impacted_turns,
			"is_negative": false,
			"damage_per_turn": 0,
		})
		_modify_stats(target, ability.modified_stat, delta, false)
		if sim_mode:
			sim_stats[caster].buffs_applied += 1
		if not sim_mode:
			if not skip_flavor:
				combat_message.emit(ability.flavor_text)
			combat_message.emit("[color=#66ccff]%s was impacted by the ability.[/color]" % target.character_name)
			combat_event.emit(target, delta, "buff")


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


func _calc_ability_damage_raw(attacker: FighterData, ability: AbilityData) -> int:
	match ability.modified_stat:
		Enums.StatType.MAGIC_ATTACK:
			return ability.modifier + attacker.magic_attack
		Enums.StatType.PHYSICAL_ATTACK:
			return ability.modifier + attacker.physical_attack
		Enums.StatType.MIXED_ATTACK:
			return ability.modifier \
				+ (attacker.physical_attack + attacker.magic_attack) / 2
		_:
			return ability.modifier


func perform_block(blocker: FighterData) -> void:
	var phys_bonus: int = maxi(1, floori(blocker.physical_defense * 0.5))
	var mag_bonus: int = maxi(1, floori(blocker.magic_defense * 0.5))
	blocker._apply_stat_change(Enums.StatType.PHYSICAL_DEFENSE, phys_bonus, false)
	blocker.modified_stats.append({
		"stat": Enums.StatType.PHYSICAL_DEFENSE,
		"modifier": phys_bonus,
		"turns": 1,
		"is_negative": false,
		"damage_per_turn": 0,
	})
	blocker._apply_stat_change(Enums.StatType.MAGIC_DEFENSE, mag_bonus, false)
	blocker.modified_stats.append({
		"stat": Enums.StatType.MAGIC_DEFENSE,
		"modifier": mag_bonus,
		"turns": 1,
		"is_negative": false,
		"damage_per_turn": 0,
	})
	var mp_restore: int = maxi(1, floori(blocker.magic_attack / 7))
	blocker.mana = mini(blocker.mana + mp_restore, blocker.max_mana)
	if not sim_mode:
		combat_message.emit("[color=#66b3ff]%s braces for impact.[/color]" % blocker.character_name)
		combat_event.emit(blocker, mp_restore, "block")


func perform_rest(unit: FighterData) -> void:
	var mp_restore: int = maxi(2, floori(unit.magic_attack / 7) * 2)
	unit.mana = mini(unit.mana + mp_restore, unit.max_mana)
	var hp_restore: int = maxi(1, floori(unit.max_health * 0.1))
	unit.health = mini(unit.health + hp_restore, unit.max_health)
	if sim_mode:
		sim_stats[unit].heals += hp_restore
	else:
		combat_message.emit("[color=#80cc66]%s takes a moment to rest.[/color]" % unit.character_name)
		combat_event.emit(unit, mp_restore, "rest")


func use_item(user: FighterData, target: FighterData, item: ItemData) -> void:
	match item.effect_type:
		Enums.ItemEffect.HEAL_HP:
			var healed: int = mini(item.magnitude, target.max_health - target.health)
			target.health += healed
			if sim_mode:
				sim_stats[user].heals += healed
			else:
				combat_message.emit("[color=#4dff66]%s used %s on %s, restoring %d HP.[/color]" % [
					user.character_name, item.item_name, target.character_name, healed])
				combat_event.emit(target, healed, "heal")
		Enums.ItemEffect.HEAL_MP:
			var restored: int = mini(item.magnitude, target.max_mana - target.mana)
			target.mana += restored
			if not sim_mode:
				combat_message.emit("[color=#66b3ff]%s used %s on %s, restoring %d MP.[/color]" % [
					user.character_name, item.item_name, target.character_name, restored])
				combat_event.emit(target, restored, "rest")
		Enums.ItemEffect.CURE_DEBUFF:
			var removed: int = 0
			var to_remove: Array[int] = []
			for i: int in target.modified_stats.size():
				if target.modified_stats[i]["is_negative"]:
					to_remove.append(i)
			for i: int in range(to_remove.size() - 1, -1, -1):
				target._revert_mod(target.modified_stats[to_remove[i]])
				target.modified_stats.remove_at(to_remove[i])
				removed += 1
			if not sim_mode:
				combat_message.emit("[color=#4dff66]%s used %s on %s, clearing %d debuff(s).[/color]" % [
					user.character_name, item.item_name, target.character_name, removed])
				combat_event.emit(target, removed, "cure")
		Enums.ItemEffect.BUFF:
			var targets: Array = [target]
			if item.target_all:
				var user_allies: Array = units if user in units else enemies
				targets = user_allies.duplicate()
			for t: FighterData in targets:
				var delta: int = _compute_buff_delta(t, item.stat_type, item.magnitude)
				t.modified_stats.append({
					"stat": item.stat_type,
					"modifier": delta,
					"turns": item.duration,
					"is_negative": item.magnitude < 0,
					"damage_per_turn": 0,
				})
				_modify_stats(t, item.stat_type, delta, item.magnitude < 0)
			if not sim_mode:
				combat_message.emit("[color=#66ccff]%s used %s![/color]" % [
					user.character_name, item.item_name])
				combat_event.emit(target, abs(item.magnitude), "buff")
		Enums.ItemEffect.DAMAGE:
			var targets: Array = [target]
			if item.target_all:
				var user_opponents: Array = enemies if user in units else units
				targets = user_opponents.duplicate()
			for t: FighterData in targets:
				t.health = maxi(0, t.health - item.magnitude)
				if sim_mode:
					sim_stats[user].dmg_dealt += item.magnitude
				else:
					combat_event.emit(t, item.magnitude, "spell_damage")
			if not sim_mode:
				combat_message.emit("[color=#ff6666]%s used %s![/color]" % [
					user.character_name, item.item_name])


func _has_defense_buff(fighter: FighterData) -> bool:
	for mod: Dictionary in fighter.modified_stats:
		if mod["stat"] == Enums.StatType.PHYSICAL_DEFENSE and not mod["is_negative"]:
			return true
	return false


# =============================================================================
# Stat modification & reset
# =============================================================================

## Convert a percentage modifier into a flat delta for the given fighter and stat.
## DODGE_CHANCE and TAUNT stay flat -- their modifiers are already absolute values.
func _compute_buff_delta(fighter: FighterData, stat: Enums.StatType,
		percent: int) -> int:
	if stat == Enums.StatType.DODGE_CHANCE or stat == Enums.StatType.TAUNT:
		return percent
	var base_stat: int
	match stat:
		Enums.StatType.ATTACK, Enums.StatType.MIXED_ATTACK:
			base_stat = (fighter.physical_attack + fighter.magic_attack) / 2
		Enums.StatType.DEFENSE:
			base_stat = (fighter.physical_defense + fighter.magic_defense) / 2
		Enums.StatType.PHYSICAL_ATTACK:
			base_stat = fighter.physical_attack
		Enums.StatType.PHYSICAL_DEFENSE:
			base_stat = fighter.physical_defense
		Enums.StatType.MAGIC_ATTACK:
			base_stat = fighter.magic_attack
		Enums.StatType.MAGIC_DEFENSE:
			base_stat = fighter.magic_defense
		Enums.StatType.SPEED:
			base_stat = fighter.speed
		_:
			return percent
	return maxi(1, floori(float(base_stat) * float(percent) / 100.0))


func _modify_stats(fighter: FighterData, stat: Enums.StatType,
		modifier: int, negative: bool) -> void:
	fighter._apply_stat_change(stat, modifier, negative)


func reset_modified_stat(fighter: FighterData) -> void:
	var to_remove: Array[int] = []

	for i: int in fighter.modified_stats.size():
		var mod: Dictionary = fighter.modified_stats[i]

		if mod.get("damage_per_turn", 0) > 0:
			fighter.health -= mod["damage_per_turn"]
			if sim_mode:
				sim_stats[fighter].dmg_taken += mod["damage_per_turn"]
			else:
				combat_message.emit("[color=#cc4dcc]%s takes %d damage from a lingering effect.[/color]" % [
					fighter.character_name, mod["damage_per_turn"]])
				combat_event.emit(fighter, mod["damage_per_turn"], "damage")

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
			if sim_mode:
				sim_stats[units[i]].died = true
			else:
				combat_message.emit("[color=#ffcc00]%s the %s has been knocked out.[/color]" % [
					units[i].character_name, units[i].character_type])
				fighter_died.emit(units[i])
			unit_deaths.append(i)

	for i: int in enemies.size():
		if enemies[i].health <= 0:
			if not sim_mode:
				combat_message.emit("[color=#ffcc00]%s the %s has been knocked out.[/color]" % [
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
		if not sim_mode:
			battle_won.emit()
	else:
		if not sim_mode:
			battle_lost.emit()


# =============================================================================
# Crit & dodge
# =============================================================================

func _check_for_critical(fighter: FighterData) -> bool:
	return randi_range(1, 100) <= fighter.crit_chance


func _check_for_dodge(fighter: FighterData) -> bool:
	return randi_range(1, 100) <= fighter.dodge_chance


func _check_for_ability_dodge(fighter: FighterData) -> bool:
	return randi_range(1, 100) <= fighter.dodge_chance / 2


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
# AI: Enemy Item Usage
# =============================================================================

func _try_enemy_item(unit: FighterData, targets: Array,
		allies: Array) -> bool:
	## Try using a battle item. Returns true if an item was consumed.
	if unit.battle_items.is_empty():
		return false

	var hp_pct: float = float(unit.health) / float(unit.max_health)
	var mp_pct: float = float(unit.mana) / float(unit.max_mana) \
		if unit.max_mana > 0 else 1.0

	# Priority 1: Heal self when wounded
	if hp_pct < 0.4:
		var idx: int = _find_ally_item(unit, Enums.ItemEffect.HEAL_HP)
		if idx >= 0:
			return _consume_item(unit, unit, idx)

	# Priority 2: Heal a critically wounded ally
	for ally: FighterData in allies:
		if ally == unit or ally.health <= 0:
			continue
		if float(ally.health) / float(ally.max_health) < 0.3:
			var idx: int = _find_ally_item(unit, Enums.ItemEffect.HEAL_HP)
			if idx >= 0:
				return _consume_item(unit, ally, idx)
			break

	# Priority 3: Cure debuffs if debuffed
	for mod: Dictionary in unit.modified_stats:
		if mod["is_negative"]:
			var idx: int = _find_ally_item(unit, Enums.ItemEffect.CURE_DEBUFF)
			if idx >= 0:
				return _consume_item(unit, unit, idx)
			break

	# Priority 4: Restore mana when low
	if mp_pct < 0.25:
		var idx: int = _find_ally_item(unit, Enums.ItemEffect.HEAL_MP)
		if idx >= 0:
			return _consume_item(unit, unit, idx)

	# Priority 5: Buff self if unbuffed (35% chance per check)
	if randf() < 0.35:
		for i: int in unit.battle_items.size():
			var item: ItemData = unit.battle_items[i]
			if item.effect_type == Enums.ItemEffect.BUFF and item.target_ally \
					and item.magnitude > 0 \
					and not _has_modifier(unit, item.stat_type, false):
				return _consume_item(unit, unit, i)

	return false


func _find_ally_item(unit: FighterData, effect: Enums.ItemEffect) -> int:
	for i: int in unit.battle_items.size():
		var item: ItemData = unit.battle_items[i]
		if item.effect_type == effect and item.target_ally:
			return i
	return -1


func _consume_item(unit: FighterData, target: FighterData, index: int) -> bool:
	var item: ItemData = unit.battle_items[index]
	unit.battle_items.remove_at(index)
	use_item(unit, target, item)
	return true


# =============================================================================
# AI: port of C# ExecuteAITurn
# =============================================================================

func execute_ai_turn(unit: FighterData, targets: Array,
		allies: Array) -> void:
	if targets.is_empty():
		return
	# Player auto-battle always uses full smart AI; enemies use difficulty setting
	_eff_diff = 2 if unit.is_user_controlled else difficulty_level
	if _eff_diff > 0:
		_execute_smart_ai_turn(unit, targets, allies)
		return
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
			var hp_frac: float = float(wounded.health) / float(wounded.max_health)
			var eligible: Array[AbilityData] = heal_abilities.filter(
				func(h: AbilityData) -> bool: return hp_frac < h.heal_threshold)
			if eligible.is_empty():
				wounded = null
		if wounded != null:
			var heal: AbilityData = _weighted_pick(
				heal_abilities.filter(func(h: AbilityData) -> bool:
					return float(wounded.health) / float(wounded.max_health) < h.heal_threshold))
			unit.mana -= heal.mana_cost
			if heal.target_all:
				if not sim_mode:
					combat_message.emit(heal.flavor_text)
				for ally: FighterData in allies:
					if ally.health > 0:
						use_ability_on_teammate(unit, ally, heal, true)
			else:
				use_ability_on_teammate(unit, wounded, heal)
			return

	# Priority 1.25: Battle items (heal > cure > mana > buff)
	if _try_enemy_item(unit, targets, allies):
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
			var buff: AbilityData = _weighted_pick(buff_abilities)
			if buff.target_all:
				var any_unbuffed: bool = false
				for ally: FighterData in allies:
					if ally.health > 0 and not _has_modifier(ally, buff.modified_stat, false):
						any_unbuffed = true
						break
				if any_unbuffed:
					unit.mana -= buff.mana_cost
					if not sim_mode:
						combat_message.emit(buff.flavor_text)
					for ally: FighterData in allies:
						if ally.health > 0:
							use_ability_on_teammate(unit, ally, buff, true)
					return
			else:
				var buff_target := _best_buff_target(allies, buff)
				if buff_target != null:
					unit.mana -= buff.mana_cost
					use_ability_on_teammate(unit, buff_target, buff)
					return

	# Priority 2.5: Block or Rest (basic actions)
	var hp_pct: float = float(unit.health) / float(unit.max_health)
	var mp_pct: float = float(unit.mana) / float(unit.max_mana) if unit.max_mana > 0 else 1.0

	if hp_pct < 0.35 and not _has_defense_buff(unit):
		if unit.is_user_controlled:
			# Player auto-battle: always block when low HP
			perform_block(unit)
			return
		else:
			# Enemy: 25% chance to block, never consecutively
			if randf() < 0.25:
				perform_block(unit)
				return

	if mp_pct < 0.3 and hp_pct >= 0.35:
		if unit.is_user_controlled:
			perform_rest(unit)
			return
		else:
			if randf() < 0.25:
				perform_rest(unit)
				return

	# Priority 2.75: Prefer life steal when wounded
	if hp_pct < 0.7 and not offensive_abilities.is_empty():
		var steal_abilities: Array[AbilityData] = []
		for a: AbilityData in offensive_abilities:
			if a.life_steal_percent > 0:
				steal_abilities.append(a)
		if not steal_abilities.is_empty() and randf() < 0.6:
			var ability: AbilityData = _weighted_pick(steal_abilities)
			unit.mana -= ability.mana_cost
			var target: FighterData = _choose_target(unit, targets, magic_ratio)
			use_ability_on_enemy(unit, target, ability)
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
			if not sim_mode:
				combat_message.emit(ability.flavor_text)
			for target: FighterData in targets:
				use_ability_on_enemy(unit, target, ability, true)
		else:
			var target: FighterData
			if ability.impacted_turns > 0:
				target = _best_debuff_target(targets, ability)
			else:
				target = _choose_target(unit, targets, magic_ratio)
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


func _best_buff_target(allies: Array, buff: AbilityData) -> FighterData:
	var best: FighterData = null
	var best_score := -1.0
	for ally: FighterData in allies:
		if ally.health <= 0 or _has_modifier(ally, buff.modified_stat, false):
			continue
		var score := _stat_relevance(ally, buff.modified_stat, true)
		if score > best_score:
			best_score = score
			best = ally
	return best


func _best_debuff_target(targets: Array, ability: AbilityData) -> FighterData:
	if ability.damage_per_turn > 0:
		return _find_max_health(targets)
	var best: FighterData = null
	var best_score := -1.0
	for t: FighterData in targets:
		var score := _stat_relevance(t, ability.modified_stat, false)
		if score > best_score:
			best_score = score
			best = t
	return best if best != null else targets[0]


func _stat_relevance(fighter: FighterData, stat: Enums.StatType,
		is_buff: bool) -> float:
	match stat:
		Enums.StatType.PHYSICAL_ATTACK:
			return float(fighter.physical_attack)
		Enums.StatType.MAGIC_ATTACK:
			return float(fighter.magic_attack)
		Enums.StatType.MIXED_ATTACK:
			return float(fighter.physical_attack + fighter.magic_attack)
		Enums.StatType.PHYSICAL_DEFENSE:
			if is_buff:
				return 1.0 / float(maxi(fighter.physical_defense, 1))
			return float(fighter.physical_defense)
		Enums.StatType.MAGIC_DEFENSE:
			if is_buff:
				return 1.0 / float(maxi(fighter.magic_defense, 1))
			return float(fighter.magic_defense)
		Enums.StatType.DEFENSE:
			if is_buff:
				return 1.0 / float(maxi(fighter.physical_defense + fighter.magic_defense, 1))
			return float(fighter.physical_defense + fighter.magic_defense)
		Enums.StatType.ATTACK:
			return float(fighter.physical_attack + fighter.magic_attack)
		Enums.StatType.SPEED:
			if is_buff:
				return 100.0 / float(maxi(fighter.speed, 1))
			return float(fighter.speed)
		Enums.StatType.DODGE_CHANCE:
			if is_buff:
				return 1.0 / float(maxi(fighter.dodge_chance, 1))
			return float(fighter.dodge_chance)
		_:
			return float(fighter.physical_attack + fighter.magic_attack)


func _find_min_health(targets: Array) -> FighterData:
	if targets.is_empty():
		return null
	var best: FighterData = targets[0]
	for i: int in range(1, targets.size()):
		if targets[i].health < best.health:
			best = targets[i]
	return best


func _find_max_health(targets: Array) -> FighterData:
	if targets.is_empty():
		return null
	var best: FighterData = targets[0]
	for i: int in range(1, targets.size()):
		if targets[i].health > best.health:
			best = targets[i]
	return best


func _weighted_pick(abilities: Array[AbilityData]) -> AbilityData:
	## Pick an ability weighted by mana cost (higher cost = stronger = preferred).
	var total: float = 0.0
	for a: AbilityData in abilities:
		total += 1.0 + a.mana_cost
	var roll: float = randf() * total
	for a: AbilityData in abilities:
		roll -= 1.0 + a.mana_cost
		if roll <= 0.0:
			return a
	return abilities[abilities.size() - 1]


func _choose_offensive_ability(unit: FighterData,
		offensive_abilities: Array[AbilityData], magic_ratio: float) -> AbilityData:
	var preferred: Enums.StatType = Enums.StatType.MAGIC_ATTACK \
		if magic_ratio > 0.5 else Enums.StatType.PHYSICAL_ATTACK
	var preferred_list: Array[AbilityData] = []

	for a: AbilityData in offensive_abilities:
		if a.modified_stat == preferred or a.modified_stat == Enums.StatType.MIXED_ATTACK:
			preferred_list.append(a)

	if not preferred_list.is_empty():
		return _weighted_pick(preferred_list)
	return _weighted_pick(offensive_abilities)


# =============================================================================
# Smart AI (Normal + Hard difficulty)
# =============================================================================

func _execute_smart_ai_turn(unit: FighterData, targets: Array,
		allies: Array) -> void:
	# -- Classify abilities --
	var heal_abilities: Array[AbilityData] = []
	var buff_abilities: Array[AbilityData] = []
	var offensive_abilities: Array[AbilityData] = []
	var debuff_abilities: Array[AbilityData] = []
	var taunt_ability: AbilityData = null
	var has_aoe_buff: bool = false

	for a: AbilityData in unit.abilities:
		if a.mana_cost > unit.mana:
			continue
		if a.use_on_enemy:
			if a.impacted_turns > 0:
				debuff_abilities.append(a)
			else:
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

	# -- Adaptive aggression (Hard only) --
	var battle_state: float = 0.5
	if _eff_diff >= 2:
		battle_state = _calc_battle_state(allies, targets)

	# -- Priority 1: Heal wounded ally --
	if not heal_abilities.is_empty():
		var heal_threshold_mult: float = 1.0
		if _eff_diff >= 2:
			if battle_state > 0.6:
				heal_threshold_mult = 0.6
			elif battle_state < 0.4:
				heal_threshold_mult = 1.4
		var wounded: FighterData = null
		for ally: FighterData in allies:
			if ally.health > 0 and ally.health < ally.max_health * 0.5 * heal_threshold_mult:
				if wounded == null or ally.health < wounded.health:
					wounded = ally
		if wounded != null:
			var hp_frac: float = float(wounded.health) / float(wounded.max_health)
			var eligible: Array[AbilityData] = heal_abilities.filter(
				func(h: AbilityData) -> bool: return hp_frac < h.heal_threshold)
			if not eligible.is_empty():
				var heal: AbilityData = _weighted_pick(eligible)
				unit.mana -= heal.mana_cost
				if heal.target_all:
					if not sim_mode:
						combat_message.emit(heal.flavor_text)
					for ally2: FighterData in allies:
						if ally2.health > 0:
							use_ability_on_teammate(unit, ally2, heal, true)
				else:
					use_ability_on_teammate(unit, wounded, heal)
				return

	# -- Priority 1.25: Battle items (heal > cure > mana > buff) --
	if _try_enemy_item(unit, targets, allies):
		return

	# -- Priority 1.5: Taunt if defensive unit --
	if taunt_ability != null and not _has_modifier(unit, Enums.StatType.TAUNT, false):
		var def_total: float = unit.physical_defense + unit.magic_defense
		var off_total: float = unit.physical_attack + unit.magic_attack
		var tank_ratio: float = def_total / (def_total + off_total)
		var taunt_chance: float = tank_ratio * (targets.size() / 3.0)
		if randf() < taunt_chance:
			unit.mana -= taunt_ability.mana_cost
			use_ability_on_teammate(unit, unit, taunt_ability)
			return

	# -- Priority 2: Coordinated debuff (Normal + Hard) --
	if not debuff_abilities.is_empty() and not (_eff_diff >= 2 and battle_state > 0.7):
		var best_debuff: AbilityData = null
		var best_debuff_target: FighterData = null
		var best_debuff_score: float = -1.0
		for d: AbilityData in debuff_abilities:
			if d.target_all:
				var unbuffed_count: int = 0
				for t: FighterData in targets:
					if not _has_modifier(t, d.modified_stat, true):
						unbuffed_count += 1
				if unbuffed_count >= ceili(targets.size() / 2.0):
					var score: float = float(d.mana_cost + 1) * float(unbuffed_count)
					if score > best_debuff_score:
						best_debuff_score = score
						best_debuff = d
						best_debuff_target = null
			else:
				for t: FighterData in targets:
					if _has_modifier(t, d.modified_stat, true):
						continue
					if d.damage_per_turn > 0 and _has_dot(t):
						continue
					var score: float = (float(d.mana_cost + 1)
						* _stat_relevance(t, d.modified_stat, false))
					if score > best_debuff_score:
						best_debuff_score = score
						best_debuff = d
						best_debuff_target = t
		if best_debuff != null and randf() < 0.4:
			unit.mana -= best_debuff.mana_cost
			if best_debuff.target_all:
				if not sim_mode:
					combat_message.emit(best_debuff.flavor_text)
				for t: FighterData in targets:
					use_ability_on_enemy(unit, t, best_debuff, true)
			else:
				use_ability_on_enemy(unit, best_debuff_target, best_debuff)
			return

	# -- Priority 3: Buff allies --
	if not buff_abilities.is_empty():
		var skip_buff: bool = _eff_diff >= 2 and battle_state > 0.65
		if not skip_buff:
			var buff_roll: int = randi_range(0, 4)
			var try_buff: bool = buff_roll == 0 or (buff_roll <= 1 and has_aoe_buff)
			if try_buff:
				var buff: AbilityData = _weighted_pick(buff_abilities)
				if buff.target_all:
					var any_unbuffed: bool = false
					for ally: FighterData in allies:
						if ally.health > 0 and not _has_modifier(ally, buff.modified_stat, false):
							any_unbuffed = true
							break
					if any_unbuffed:
						unit.mana -= buff.mana_cost
						if not sim_mode:
							combat_message.emit(buff.flavor_text)
						for ally: FighterData in allies:
							if ally.health > 0:
								use_ability_on_teammate(unit, ally, buff, true)
						return
				else:
					var buff_target := _best_buff_target(allies, buff)
					if buff_target != null:
						unit.mana -= buff.mana_cost
						use_ability_on_teammate(unit, buff_target, buff)
						return

	# -- Priority 4: Block or Rest --
	var hp_pct: float = float(unit.health) / float(unit.max_health)
	var mp_pct: float = float(unit.mana) / float(unit.max_mana) if unit.max_mana > 0 else 1.0

	if hp_pct < 0.35 and not _has_defense_buff(unit):
		if randf() < 0.25:
			perform_block(unit)
			return

	if mp_pct < 0.3 and hp_pct >= 0.35:
		if randf() < 0.25:
			perform_rest(unit)
			return

	# -- Priority 5: Life steal when wounded --
	if hp_pct < 0.7 and not offensive_abilities.is_empty():
		var steal_abilities: Array[AbilityData] = []
		for a: AbilityData in offensive_abilities:
			if a.life_steal_percent > 0:
				steal_abilities.append(a)
		if not steal_abilities.is_empty() and randf() < 0.6:
			var ability: AbilityData = _weighted_pick(steal_abilities)
			unit.mana -= ability.mana_cost
			var target: FighterData = _smart_choose_target(unit, targets, magic_ratio)
			use_ability_on_enemy(unit, target, ability)
			return

	# -- Priority 6: Offense --
	var ability_chance: float = magic_ratio
	if magic_ratio < 0.4 and not offensive_abilities.is_empty():
		for a: AbilityData in offensive_abilities:
			if a.modified_stat == Enums.StatType.PHYSICAL_ATTACK \
					or a.modified_stat == Enums.StatType.MIXED_ATTACK:
				ability_chance = 0.4
				break

	# Include debuff abilities in the offensive pool if they weren't used earlier
	var all_offensive: Array[AbilityData] = offensive_abilities.duplicate()
	all_offensive.append_array(debuff_abilities)

	var use_ability: bool = not all_offensive.is_empty() and randf() < ability_chance

	if use_ability:
		var ability: AbilityData = _choose_offensive_ability(
			unit, all_offensive, magic_ratio)
		unit.mana -= ability.mana_cost
		if ability.target_all:
			if not sim_mode:
				combat_message.emit(ability.flavor_text)
			for target: FighterData in targets:
				use_ability_on_enemy(unit, target, ability, true)
		else:
			var target: FighterData
			if ability.impacted_turns > 0:
				target = _best_debuff_target(targets, ability)
			else:
				target = _smart_choose_target(unit, targets, magic_ratio)
			use_ability_on_enemy(unit, target, ability)
	else:
		var target: FighterData = _smart_choose_target(unit, targets, magic_ratio)
		physical_attack(unit, target)


func _smart_choose_target(unit: FighterData, targets: Array,
		magic_ratio: float) -> FighterData:
	## Smart targeting: taunt > focus fire > threat (Hard) > HP-based.
	var taunter: FighterData = get_taunt_target(targets)
	if taunter != null:
		return taunter

	var focus: FighterData = _find_focus_target(targets)
	if focus != null:
		return focus

	if _eff_diff >= 2:
		return _weighted_threat_target(targets)

	var pick_lowest: bool = magic_ratio > 0.6 \
		or (magic_ratio >= 0.4 and randf() < 0.6)
	return _find_min_health(targets) if pick_lowest else _find_max_health(targets)


func _find_focus_target(targets: Array) -> FighterData:
	## Focus fire: pick the most wounded target below 25% HP. 70% chance to commit.
	var best: FighterData = null
	var best_pct: float = 1.0
	for t: FighterData in targets:
		var pct: float = float(t.health) / float(t.max_health)
		if pct < 0.25 and pct < best_pct:
			best_pct = pct
			best = t
	if best != null and randf() < 0.7:
		return best
	return null


func _weighted_threat_target(targets: Array) -> FighterData:
	## Threat targeting: weighted random using offense + heal score as probability.
	var scores: Array[float] = []
	var total: float = 0.0
	for t: FighterData in targets:
		var offense: float = float(t.physical_attack + t.magic_attack)
		var heal_power: float = 0.0
		for a: AbilityData in t.abilities:
			if not a.use_on_enemy and a.impacted_turns == 0:
				heal_power += float(a.modifier + t.magic_attack / 2)
		var score: float = offense + heal_power * 1.5
		scores.append(score)
		total += score
	if total <= 0.0:
		return targets[0]
	var roll: float = randf() * total
	var cumulative: float = 0.0
	for i: int in range(targets.size()):
		cumulative += scores[i]
		if roll <= cumulative:
			return targets[i]
	return targets[targets.size() - 1]


func _calc_battle_state(allies: Array, targets: Array) -> float:
	## Returns 0.0 (losing) to 1.0 (winning). Blends HP ratio and unit count.
	var ally_hp: float = 0.0
	var ally_count: int = 0
	for a: FighterData in allies:
		if a.health > 0:
			ally_hp += float(a.health) / float(a.max_health)
			ally_count += 1
	var target_hp: float = 0.0
	var target_count: int = 0
	for t: FighterData in targets:
		if t.health > 0:
			target_hp += float(t.health) / float(t.max_health)
			target_count += 1
	if ally_count == 0:
		return 0.0
	if target_count == 0:
		return 1.0
	var ally_avg: float = ally_hp / ally_count
	var target_avg: float = target_hp / target_count
	var hp_ratio: float = ally_avg / (ally_avg + target_avg) \
		if (ally_avg + target_avg) > 0.0 else 0.5
	var count_ratio: float = float(ally_count) / float(ally_count + target_count)
	return hp_ratio * 0.6 + count_ratio * 0.4


func _has_dot(fighter: FighterData) -> bool:
	## Check if a fighter already has a damage-over-time effect.
	for mod: Dictionary in fighter.modified_stats:
		if mod.get("damage_per_turn", 0) > 0:
			return true
	return false
