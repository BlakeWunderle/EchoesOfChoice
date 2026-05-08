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
var enemy_shared_items: Array = []  ## Shared enemy item pool (like player inventory)
var player_shared_items: Array = []  ## Shared player item pool for sim testing
var player_items_used: int = 0  ## Counter for sim tracking

var sim_mode: bool = false  ## Skip signal emissions for headless simulation
var difficulty_level: int = 1  ## 0=easy, 1=normal, 2=hard. Set by caller.
var _eff_diff: int = 1  ## Effective difficulty for current turn (player always 2)
var sim_stats: Dictionary = {}  ## Per-fighter combat stats (sim mode only)
var trace_log: Array[String] = []  ## Per-action trace when trace_mode is on
var trace_mode: bool = false
var action_counts: Dictionary = {}  ## Action type tallies per side (sim mode)
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
	action_counts = {"player": {}, "enemy": {}}
	for f: FighterData in units:
		sim_stats[f] = {dmg_dealt = 0, dmg_taken = 0, heals = 0, died = false, dmg_mitigated = 0, buffs_applied = 0, debuffs_applied = 0, ultimates_used = 0, charge_gained = 0}
	for f: FighterData in enemies:
		sim_stats[f] = {dmg_dealt = 0, dmg_taken = 0, heals = 0, died = false, dmg_mitigated = 0, buffs_applied = 0, debuffs_applied = 0, ultimates_used = 0, charge_gained = 0}


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

	# Ultimate charge: Attack grants 15
	_add_ultimate_charge(attacker, 15)


func use_ability_on_enemy(attacker: FighterData, defender: FighterData,
		ability: AbilityData, skip_flavor: bool = false,
		aoe_targets: int = 1) -> void:
	if _check_for_ability_dodge(defender):
		if not sim_mode:
			combat_message.emit("[color=#b3b3b3]%s dodged %s's ability![/color]" % [
				defender.character_name, attacker.character_name])
			combat_event.emit(defender, 0, "miss")
		return

	if ability.impacted_turns == 0:
		# Instant damage
		var damage: int = _calc_ability_damage(attacker, defender, ability)
		if aoe_targets > 1:
			damage = ceili(float(damage) / aoe_targets)
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

	# Ultimate charge: Offensive ability grants 5
	_add_ultimate_charge(attacker, 5)


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
		if ability.damage_per_turn > 0:
			# Regen (heal over time)
			var hot_flat: int = maxi(1, floori(
				float(target.max_health) * float(ability.damage_per_turn) / 100.0))
			target.modified_stats.append({
				"stat": ability.modified_stat,
				"modifier": 0,
				"turns": ability.impacted_turns,
				"is_negative": false,
				"damage_per_turn": hot_flat,
			})
			if sim_mode:
				sim_stats[caster].buffs_applied += 1
			else:
				if not skip_flavor:
					combat_message.emit(ability.flavor_text)
				combat_message.emit("[color=#4dff66]%s will recover %d health per turn for %d turns.[/color]" % [
					target.character_name, hot_flat, ability.impacted_turns])
				combat_event.emit(target, hot_flat, "buff")
		else:
			# Stat buff
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

	# Ultimate charge: Supportive ability grants 5
	_add_ultimate_charge(caster, 5)


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

	# Ultimate charge: Block grants 10
	_add_ultimate_charge(blocker, 10)


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

	# Ultimate charge: Rest grants 20
	_add_ultimate_charge(unit, 20)


func use_item(user: FighterData, target: FighterData, item: ItemData) -> void:
	match item.effect_type:
		Enums.ItemEffect.HEAL_HP:
			var heal_amount: int = int(target.max_health * item.magnitude / 100.0)
			var healed: int = mini(heal_amount, target.max_health - target.health)
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
			var max_remove: int = item.magnitude if item.magnitude > 0 else 999
			var to_remove: Array[int] = []
			for i: int in target.modified_stats.size():
				if target.modified_stats[i]["is_negative"]:
					to_remove.append(i)
					if to_remove.size() >= max_remove:
						break
			for i: int in range(to_remove.size() - 1, -1, -1):
				target._revert_mod(target.modified_stats[to_remove[i]])
				target.modified_stats.remove_at(to_remove[i])
				removed += 1
			if not sim_mode:
				combat_message.emit("[color=#4dff66]%s used %s on %s, clearing %d debuff(s).[/color]" % [
					user.character_name, item.item_name, target.character_name, removed])
				combat_event.emit(target, removed, "cure")
		Enums.ItemEffect.BUFF:
			var is_debuff := not item.target_ally
			var targets: Array = [target]
			if item.target_all:
				if is_debuff:
					var user_opponents: Array = enemies if user in units else units
					targets = user_opponents.duplicate()
				else:
					var user_allies: Array = units if user in units else enemies
					targets = user_allies.duplicate()
			for t: FighterData in targets:
				var delta: int = _compute_buff_delta(t, item.stat_type, item.magnitude)
				t.modified_stats.append({
					"stat": item.stat_type,
					"modifier": delta,
					"turns": item.duration,
					"is_negative": is_debuff,
					"damage_per_turn": 0,
				})
				_modify_stats(t, item.stat_type, delta, is_debuff)
			if not sim_mode:
				if is_debuff:
					combat_message.emit("[color=#cc4dcc]%s used %s![/color]" % [
						user.character_name, item.item_name])
					combat_event.emit(target, abs(item.magnitude), "debuff")
				else:
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


## Add ultimate charge to a fighter (player-controlled only).
func _add_ultimate_charge(fighter: FighterData, amount: int) -> void:
	if fighter.ultimate == null:
		return
	if not fighter.is_user_controlled and not sim_mode:
		return
	var old_charge: int = fighter.ultimate_charge
	fighter.ultimate_charge = mini(fighter.ultimate_charge + amount, fighter.ultimate.charge_cost)
	if sim_mode:
		sim_stats[fighter].charge_gained += fighter.ultimate_charge - old_charge
	elif fighter.ultimate_charge > old_charge:
		combat_event.emit(fighter, fighter.ultimate_charge - old_charge, "charge_gain")


## Execute a fighter's ultimate ability. Resets charge to 0.
func use_ultimate(user: FighterData, target: FighterData) -> void:
	var ult: RefCounted = user.ultimate
	if ult == null:
		return
	user.ultimate_charge = 0
	if sim_mode:
		sim_stats[user].ultimates_used += 1
	else:
		combat_message.emit("[color=#ffc822]%s unleashes %s![/color]" % [
			user.character_name, ult.ultimate_name])

	var abil: AbilityData = ult.ability
	if abil.use_on_enemy:
		if abil.target_all:
			var targets: Array = enemies if user in units else units
			var alive_count: int = targets.size()
			for t: FighterData in targets.duplicate():
				if t.health > 0:
					use_ability_on_enemy(user, t, abil, true, alive_count)
		else:
			use_ability_on_enemy(user, target, abil, true)
	else:
		if abil.target_all:
			var allies: Array = units if user in units else enemies
			for ally: FighterData in allies.duplicate():
				if ally.health > 0:
					use_ability_on_teammate(user, ally, abil, true)
		else:
			use_ability_on_teammate(user, target, abil, true)


func _pick_ultimate_target(user: FighterData, targets: Array,
		allies: Array) -> FighterData:
	## Choose a target for AI ultimate usage. For offensive ultimates, pick the
	## lowest-HP enemy. For supportive ultimates, pick the most wounded ally.
	## AoE ultimates ignore the target in use_ultimate, so any valid pick works.
	var abil: AbilityData = user.ultimate.ability
	if abil.use_on_enemy:
		var best: FighterData = targets[0]
		for t: FighterData in targets:
			if t.health < best.health:
				best = t
		return best
	else:
		var best: FighterData = user
		for ally: FighterData in allies:
			if ally.health > 0 and ally.health < best.health:
				best = ally
		return best


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
	if stat == Enums.StatType.DODGE_CHANCE or stat == Enums.StatType.TAUNT \
			or stat == Enums.StatType.CRIT_CHANCE or stat == Enums.StatType.CRIT:
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
			if mod["is_negative"]:
				fighter.health -= mod["damage_per_turn"]
				if sim_mode:
					sim_stats[fighter].dmg_taken += mod["damage_per_turn"]
				else:
					combat_message.emit("[color=#cc4dcc]%s takes %d damage from a lingering effect.[/color]" % [
						fighter.character_name, mod["damage_per_turn"]])
					combat_event.emit(fighter, mod["damage_per_turn"], "damage")
			else:
				var heal: int = mini(mod["damage_per_turn"],
					fighter.max_health - fighter.health)
				fighter.health += heal
				if sim_mode:
					sim_stats[fighter].heals += heal
				else:
					combat_message.emit("[color=#4dff66]%s recovers %d health from a lingering effect.[/color]" % [
						fighter.character_name, heal])
					combat_event.emit(fighter, heal, "heal")

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
	## Try using a shared enemy item. Returns true if an item was consumed.
	## Only the lowest-offense enemy uses items (support role).
	if enemy_shared_items.is_empty():
		return false
	var unit_offense := unit.physical_attack + unit.magic_attack
	for ally: FighterData in allies:
		if ally.health > 0 and (ally.physical_attack + ally.magic_attack) < unit_offense:
			return false

	# Priority 1: Cure debuffs if 2+ debuffs (25% chance)
	if randf() < 0.25:
		var debuff_count: int = 0
		for mod: Dictionary in unit.modified_stats:
			if mod["is_negative"]:
				debuff_count += 1
		if debuff_count >= 2:
			var idx: int = _find_shared_item(Enums.ItemEffect.CURE_DEBUFF)
			if idx >= 0:
				return _consume_shared_item(unit, unit, idx)

	# Priority 2: Buff best ally if unbuffed (25% chance)
	if randf() < 0.25:
		for i: int in enemy_shared_items.size():
			var item: ItemData = enemy_shared_items[i]
			if item.effect_type == Enums.ItemEffect.BUFF and item.target_ally \
					and item.magnitude > 0:
				if item.target_all:
					var any_unbuffed: bool = false
					for ally: FighterData in allies:
						if ally.health > 0 and not _has_modifier(ally, item.stat_type, false):
							any_unbuffed = true
							break
					if any_unbuffed:
						return _consume_shared_item(unit, unit, i)
				else:
					var best: FighterData = _best_item_buff_target(allies, item)
					if best != null:
						return _consume_shared_item(unit, best, i)

	# Priority 3: Debuff strongest enemy (25% chance)
	if randf() < 0.25:
		for i: int in enemy_shared_items.size():
			var item: ItemData = enemy_shared_items[i]
			if item.effect_type == Enums.ItemEffect.BUFF and not item.target_ally:
				var target_list: Array = units if unit in enemies else enemies
				if not target_list.is_empty():
					if item.target_all:
						return _consume_shared_item(unit, target_list[0], i)
					var best: FighterData = _best_debuff_item_target(target_list, item)
					if best != null and not _has_modifier(best, item.stat_type, true):
						return _consume_shared_item(unit, best, i)

	# Priority 4: Use damage item on enemy (25% chance)
	if randf() < 0.25:
		for i: int in enemy_shared_items.size():
			var item: ItemData = enemy_shared_items[i]
			if item.effect_type == Enums.ItemEffect.DAMAGE and not item.target_ally:
				var target_list: Array = units if unit in enemies else enemies
				if not target_list.is_empty():
					var target: FighterData = target_list[randi() % target_list.size()]
					return _consume_shared_item(unit, target, i)

	return false


func _best_item_buff_target(allies: Array, item: ItemData) -> FighterData:
	var best: FighterData = null
	var best_score := -1.0
	for ally: FighterData in allies:
		if ally.health <= 0 or _has_modifier(ally, item.stat_type, false):
			continue
		var score := _stat_relevance(ally, item.stat_type, true)
		if score > best_score:
			best_score = score
			best = ally
	return best


func _best_debuff_item_target(targets: Array, item: ItemData) -> FighterData:
	var best: FighterData = null
	var best_score := -1.0
	for t: FighterData in targets:
		if t.health <= 0:
			continue
		var score := _stat_relevance(t, item.stat_type, false)
		if score > best_score:
			best_score = score
			best = t
	return best


func _find_shared_item(effect: Enums.ItemEffect) -> int:
	for i: int in enemy_shared_items.size():
		var item: ItemData = enemy_shared_items[i]
		if item.target_ally and item.effect_type == effect:
			return i
	return -1


func _consume_shared_item(unit: FighterData, target: FighterData, index: int) -> bool:
	var item: ItemData = enemy_shared_items[index]
	enemy_shared_items.remove_at(index)
	use_item(unit, target, item)
	return true


# =============================================================================
# Player Item AI (deterministic, for sim power-level testing)
# =============================================================================

func _try_player_item(unit: FighterData, targets: Array,
		allies: Array) -> bool:
	if player_shared_items.is_empty():
		return false
	var unit_offense := unit.physical_attack + unit.magic_attack
	for ally: FighterData in allies:
		if ally.health > 0 and (ally.physical_attack + ally.magic_attack) < unit_offense:
			return false

	# Priority 1: Cure debuffs if 2+
	var debuff_count: int = 0
	for mod: Dictionary in unit.modified_stats:
		if mod["is_negative"]:
			debuff_count += 1
	if debuff_count >= 2:
		var idx: int = _find_player_item(Enums.ItemEffect.CURE_DEBUFF)
		if idx >= 0:
			return _consume_player_item(unit, unit, idx)

	# Priority 2: Buff best ally if unbuffed
	for i: int in player_shared_items.size():
		var item: ItemData = player_shared_items[i]
		if item.effect_type == Enums.ItemEffect.BUFF and item.target_ally \
				and item.magnitude > 0:
			if item.target_all:
				var any_unbuffed: bool = false
				for ally: FighterData in allies:
					if ally.health > 0 and not _has_modifier(ally, item.stat_type, false):
						any_unbuffed = true
						break
				if any_unbuffed:
					return _consume_player_item(unit, unit, i)
			else:
				var best: FighterData = _best_item_buff_target(allies, item)
				if best != null:
					return _consume_player_item(unit, best, i)

	# Priority 3: Debuff strongest enemy
	for i: int in player_shared_items.size():
		var item: ItemData = player_shared_items[i]
		if item.effect_type == Enums.ItemEffect.BUFF and not item.target_ally:
			if not targets.is_empty():
				if item.target_all:
					return _consume_player_item(unit, targets[0], i)
				var best: FighterData = _best_debuff_item_target(targets, item)
				if best != null and not _has_modifier(best, item.stat_type, true):
					return _consume_player_item(unit, best, i)

	# Priority 4: Use damage item on enemy
	for i: int in player_shared_items.size():
		var item: ItemData = player_shared_items[i]
		if item.effect_type == Enums.ItemEffect.DAMAGE and not item.target_ally:
			if not targets.is_empty():
				var target: FighterData = targets[randi() % targets.size()]
				return _consume_player_item(unit, target, i)

	return false


func _find_player_item(effect: Enums.ItemEffect) -> int:
	for i: int in player_shared_items.size():
		var item: ItemData = player_shared_items[i]
		if item.target_ally and item.effect_type == effect:
			return i
	return -1


func _consume_player_item(unit: FighterData, target: FighterData, index: int) -> bool:
	var item: ItemData = player_shared_items[index]
	player_shared_items.remove_at(index)
	use_item(unit, target, item)
	player_items_used += 1
	return true


# =============================================================================
# AI: port of C# ExecuteAITurn
# =============================================================================

func _trace(msg: String) -> void:
	if trace_mode:
		trace_log.append(msg)


func _count_action(unit: FighterData, action_type: String) -> void:
	if not sim_mode:
		return
	var side: String = "player" if unit in units else "enemy"
	var bucket: Dictionary = action_counts.get(side, {})
	bucket[action_type] = bucket.get(action_type, 0) + 1
	action_counts[side] = bucket


func execute_ai_turn(unit: FighterData, targets: Array,
		allies: Array) -> void:
	if targets.is_empty():
		return
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

	# Priority 2.75: Battle items (alongside block/rest)
	if _try_enemy_item(unit, targets, allies):
		return

	# Priority 2.8: Prefer life steal when wounded
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
				use_ability_on_enemy(unit, target, ability, true, targets.size())
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


func _has_affordable_aoe(offensive_abilities: Array[AbilityData],
		target_count: int) -> bool:
	if target_count < 2:
		return false
	for a: AbilityData in offensive_abilities:
		if a.target_all:
			return true
	return false


func _choose_offensive_ability(unit: FighterData,
		offensive_abilities: Array[AbilityData], magic_ratio: float,
		target_count: int = 1) -> AbilityData:
	var preferred: Enums.StatType = Enums.StatType.MAGIC_ATTACK \
		if magic_ratio > 0.5 else Enums.StatType.PHYSICAL_ATTACK
	var preferred_list: Array[AbilityData] = []

	for a: AbilityData in offensive_abilities:
		if a.modified_stat == preferred or a.modified_stat == Enums.StatType.MIXED_ATTACK:
			preferred_list.append(a)

	var pool: Array[AbilityData] = preferred_list if not preferred_list.is_empty() \
		else offensive_abilities
	if target_count >= 2:
		var aoe_pool: Array[AbilityData] = []
		for a: AbilityData in pool:
			if a.target_all:
				aoe_pool.append(a)
		if not aoe_pool.is_empty() and randf() < 0.8:
			return _weighted_pick(aoe_pool)
	return _weighted_pick(pool)


# =============================================================================
# Smart AI (Normal + Hard difficulty)
# =============================================================================

func _execute_smart_ai_turn(unit: FighterData, targets: Array,
		allies: Array) -> void:
	var _tu: String = unit.character_name if trace_mode else ""
	var _tc: String = unit.character_type if trace_mode else ""
	# Priority 0: Use ultimate if charged
	if unit.ultimate and unit.ultimate_charge >= unit.ultimate.charge_cost:
		var best: FighterData = _pick_ultimate_target(unit, targets, allies)
		_trace("%s (%s): ULTIMATE -> %s" % [_tu, _tc, best.character_name])
		use_ultimate(unit, best)
		return

	# Score-based AI for all smart units (T1/T2 enemies + player auto-battle)
	_execute_score_ai_turn(unit, targets, allies)


func _execute_old_priority_ai(unit: FighterData, targets: Array,
		allies: Array) -> void:
	# Legacy priority system preserved below but no longer called.
	var _tu: String = unit.character_name if trace_mode else ""
	var _tc: String = unit.character_type if trace_mode else ""
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
				var _ht: String = "ALL" if heal.target_all else wounded.character_name
				_trace("%s (%s): HEAL %s -> %s (HP %d/%d)" % [
					_tu, _tc, heal.ability_name, _ht, wounded.health, wounded.max_health])
				if heal.target_all:
					if not sim_mode:
						combat_message.emit(heal.flavor_text)
					for ally2: FighterData in allies:
						if ally2.health > 0:
							use_ability_on_teammate(unit, ally2, heal, true)
				else:
					use_ability_on_teammate(unit, wounded, heal)
				return

	# -- Priority 1.5: Taunt if defensive unit --
	if taunt_ability != null and not _has_modifier(unit, Enums.StatType.TAUNT, false):
		var def_total: float = unit.physical_defense + unit.magic_defense
		var off_total: float = unit.physical_attack + unit.magic_attack
		var tank_ratio: float = def_total / (def_total + off_total)
		var taunt_chance: float = tank_ratio * (targets.size() / 3.0)
		if randf() < taunt_chance:
			unit.mana -= taunt_ability.mana_cost
			_trace("%s (%s): TAUNT" % [_tu, _tc])
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
		var debuff_chance := 0.1 if _has_affordable_aoe(offensive_abilities, targets.size()) else 0.4
		if best_debuff != null and randf() < debuff_chance:
			unit.mana -= best_debuff.mana_cost
			var _dt: String = "ALL" if best_debuff.target_all else best_debuff_target.character_name
			_trace("%s (%s): DEBUFF %s -> %s" % [_tu, _tc, best_debuff.ability_name, _dt])
			if best_debuff.target_all:
				if not sim_mode:
					combat_message.emit(best_debuff.flavor_text)
				for t: FighterData in targets:
					use_ability_on_enemy(unit, t, best_debuff, true, targets.size())
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
						_trace("%s (%s): BUFF %s -> ALL" % [_tu, _tc, buff.ability_name])
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
						_trace("%s (%s): BUFF %s -> %s" % [_tu, _tc, buff.ability_name, buff_target.character_name])
						use_ability_on_teammate(unit, buff_target, buff)
						return

	# -- Priority 4: Block or Rest --
	var hp_pct: float = float(unit.health) / float(unit.max_health)
	var mp_pct: float = float(unit.mana) / float(unit.max_mana) if unit.max_mana > 0 else 1.0

	if hp_pct < 0.35 and not _has_defense_buff(unit):
		if randf() < 0.25:
			_trace("%s (%s): BLOCK (HP %.0f%%)" % [_tu, _tc, hp_pct * 100])
			perform_block(unit)
			return

	if mp_pct < 0.3 and hp_pct >= 0.35:
		if randf() < 0.25:
			_trace("%s (%s): REST (MP %.0f%%)" % [_tu, _tc, mp_pct * 100])
			perform_rest(unit)
			return

	# -- Priority 4.5: Battle items --
	if unit in units:
		if _try_player_item(unit, targets, allies):
			return
	else:
		if _try_enemy_item(unit, targets, allies):
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
			_trace("%s (%s): LIFESTEAL %s -> %s" % [_tu, _tc, ability.ability_name, target.character_name])
			use_ability_on_enemy(unit, target, ability)
			return

	# -- Priority 6: Offense --
	var ability_chance: float = magic_ratio
	if _has_affordable_aoe(offensive_abilities, targets.size()):
		ability_chance = maxf(ability_chance, 0.85)
	elif magic_ratio < 0.4 and not offensive_abilities.is_empty():
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
			unit, all_offensive, magic_ratio, targets.size())
		unit.mana -= ability.mana_cost
		if ability.target_all:
			_trace("%s (%s): AOE %s -> ALL (%d targets)" % [_tu, _tc, ability.ability_name, targets.size()])
			if not sim_mode:
				combat_message.emit(ability.flavor_text)
			for target: FighterData in targets:
				use_ability_on_enemy(unit, target, ability, true, targets.size())
		else:
			var target: FighterData
			if ability.impacted_turns > 0:
				target = _best_debuff_target(targets, ability)
				_trace("%s (%s): DEBUFF-ATK %s -> %s" % [_tu, _tc, ability.ability_name, target.character_name])
			else:
				target = _smart_choose_target(unit, targets, magic_ratio)
				_trace("%s (%s): ABILITY %s -> %s (HP %d/%d)" % [_tu, _tc, ability.ability_name, target.character_name, target.health, target.max_health])
			use_ability_on_enemy(unit, target, ability)
	else:
		var target: FighterData = _smart_choose_target(unit, targets, magic_ratio)
		_trace("%s (%s): PHYS_ATK -> %s (HP %d/%d)" % [_tu, _tc, target.character_name, target.health, target.max_health])
		physical_attack(unit, target)


func _execute_score_ai_turn(unit: FighterData, targets: Array,
		allies: Array) -> void:
	var _tu: String = unit.character_name if trace_mode else ""
	var _tc: String = unit.character_type if trace_mode else ""

	# -- Classify abilities --
	var heal_abilities: Array[AbilityData] = []
	var buff_abilities: Array[AbilityData] = []
	var offensive_abilities: Array[AbilityData] = []
	var debuff_abilities: Array[AbilityData] = []
	var taunt_ability: AbilityData = null
	var cheapest_cost: int = 999

	for a: AbilityData in unit.abilities:
		if a.mana_cost < cheapest_cost:
			cheapest_cost = a.mana_cost
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

	var best_score: float = -1.0
	var best_type: String = ""
	var best_ability: AbilityData = null
	var best_target: FighterData = null
	var best_item_idx: int = -1

	# -- Score heals --
	for heal: AbilityData in heal_abilities:
		for ally: FighterData in allies:
			if ally.health <= 0:
				continue
			var hp_frac: float = float(ally.health) / float(ally.max_health)
			if hp_frac >= heal.heal_threshold:
				continue
			var heal_amount: int
			if heal.modified_stat == Enums.StatType.MIXED_ATTACK:
				heal_amount = heal.modifier + (unit.physical_attack + unit.magic_attack) / 4
			else:
				heal_amount = heal.modifier + unit.magic_attack / 2
			heal_amount = maxi(0, heal_amount)
			var score: float = float(heal_amount)
			if hp_frac < 0.25:
				score *= 2.0
			if heal.target_all:
				var total: float = 0.0
				for a2: FighterData in allies:
					if a2.health > 0 and a2.health < a2.max_health:
						var f2: float = float(a2.health) / float(a2.max_health)
						var s2: float = float(heal_amount)
						if f2 < 0.25:
							s2 *= 2.0
						total += s2
				score = total
			if score > best_score:
				best_score = score
				best_type = "HEAL"
				best_ability = heal
				best_target = ally

	# -- Score buffs --
	var offense_stats: Array = [
		Enums.StatType.ATTACK, Enums.StatType.PHYSICAL_ATTACK,
		Enums.StatType.MAGIC_ATTACK, Enums.StatType.MIXED_ATTACK,
		Enums.StatType.CRIT, Enums.StatType.CRIT_CHANCE,
	]
	var defense_stats: Array = [
		Enums.StatType.DEFENSE, Enums.StatType.PHYSICAL_DEFENSE,
		Enums.StatType.MAGIC_DEFENSE,
	]
	for buff: AbilityData in buff_abilities:
		if buff.damage_per_turn > 0:
			# Regen buff: score as heal over time
			for ally: FighterData in allies:
				if ally.health <= 0:
					continue
				var hp_frac: float = float(ally.health) / float(ally.max_health)
				var hot_flat: int = maxi(1, floori(
					float(ally.max_health) * float(buff.damage_per_turn) / 100.0))
				var score: float = float(hot_flat * buff.impacted_turns)
				if hp_frac < 0.25:
					score *= 2.0
				if buff.target_all:
					var total: float = 0.0
					for a2: FighterData in allies:
						if a2.health > 0:
							var f2: float = float(a2.health) / float(a2.max_health)
							var s2: float = float(hot_flat * buff.impacted_turns)
							if f2 < 0.25:
								s2 *= 2.0
							total += s2
					score = total
				if score > best_score:
					best_score = score
					best_type = "BUFF"
					best_ability = buff
					best_target = ally
			continue

		var is_offense: bool = buff.modified_stat in offense_stats
		var is_defense: bool = buff.modified_stat in defense_stats
		var is_speed: bool = buff.modified_stat == Enums.StatType.SPEED

		if buff.target_all:
			var total: float = 0.0
			for ally: FighterData in allies:
				if ally.health <= 0:
					continue
				var delta: int = _compute_buff_delta(ally, buff.modified_stat, buff.modifier)
				var s: float = float(delta) * float(buff.impacted_turns)
				if is_defense:
					s *= float(targets.size()) / maxf(1.0, float(allies.size()))
				elif is_speed:
					s *= 0.5
				total += s
			if total > best_score:
				best_score = total
				best_type = "BUFF"
				best_ability = buff
				best_target = allies[0]
		else:
			for ally: FighterData in allies:
				if ally.health <= 0:
					continue
				var delta: int = _compute_buff_delta(ally, buff.modified_stat, buff.modifier)
				var score: float = float(delta) * float(buff.impacted_turns)
				if is_defense:
					score *= float(targets.size()) / maxf(1.0, float(allies.size()))
				elif is_speed:
					score *= 0.5
				if score > best_score:
					best_score = score
					best_type = "BUFF"
					best_ability = buff
					best_target = ally

	# -- Score debuffs --
	for debuff: AbilityData in debuff_abilities:
		if debuff.damage_per_turn > 0:
			# DoT debuff: score as total damage over time
			if debuff.target_all:
				var total: float = 0.0
				for t: FighterData in targets:
					var dot_flat: int = maxi(1, floori(
						float(t.max_health) * float(debuff.damage_per_turn) / 100.0))
					total += float(dot_flat * debuff.impacted_turns)
				if total > best_score:
					best_score = total
					best_type = "DEBUFF"
					best_ability = debuff
					best_target = targets[0]
			else:
				for t: FighterData in targets:
					var dot_flat: int = maxi(1, floori(
						float(t.max_health) * float(debuff.damage_per_turn) / 100.0))
					var score: float = float(dot_flat * debuff.impacted_turns)
					if score > best_score:
						best_score = score
						best_type = "DEBUFF"
						best_ability = debuff
						best_target = t
			continue

		if debuff.target_all:
			var total: float = 0.0
			for t: FighterData in targets:
				var delta: int = _compute_buff_delta(t, debuff.modified_stat, debuff.modifier)
				var s: float = float(delta) * float(debuff.impacted_turns)
				total += s
			if total > best_score:
				best_score = total
				best_type = "DEBUFF"
				best_ability = debuff
				best_target = targets[0]
		else:
			for t: FighterData in targets:
				var delta: int = _compute_buff_delta(t, debuff.modified_stat, debuff.modifier)
				var score: float = float(delta) * float(debuff.impacted_turns)
				if score > best_score:
					best_score = score
					best_type = "DEBUFF"
					best_ability = debuff
					best_target = t

	# -- Score offensive abilities --
	for ability: AbilityData in offensive_abilities:
		if ability.target_all:
			var total: float = 0.0
			for t: FighterData in targets:
				var dmg: float = float(maxi(0, _calc_ability_damage(unit, t, ability)))
				dmg = dmg / float(maxi(1, targets.size()))
				var hit: float = (100.0 - float(t.dodge_chance) / 2.0) / 100.0
				var t_score: float = dmg * hit
				if ability.life_steal_percent > 0:
					t_score += floorf(dmg * ability.life_steal_percent) * hit
					var hp_frac: float = float(unit.health) / float(unit.max_health)
					if hp_frac < 0.5:
						t_score *= 1.3
				if dmg >= float(t.health):
					t_score *= 3.0
				total += t_score
			if total > best_score:
				best_score = total
				best_type = "AOE"
				best_ability = ability
				best_target = targets[0]
		else:
			for t: FighterData in targets:
				var dmg: float = float(maxi(0, _calc_ability_damage(unit, t, ability)))
				var hit: float = (100.0 - float(t.dodge_chance) / 2.0) / 100.0
				var score: float = dmg * hit
				if ability.life_steal_percent > 0:
					score += floorf(dmg * ability.life_steal_percent) * hit
					var hp_frac: float = float(unit.health) / float(unit.max_health)
					if hp_frac < 0.5:
						score *= 1.3
				if dmg >= float(t.health):
					score *= 3.0
				elif float(t.health) / float(t.max_health) < 0.25:
					score *= 1.2
				if score > best_score:
					best_score = score
					best_type = "ABILITY"
					best_ability = ability
					best_target = t

	# -- Score taunt --
	if taunt_ability != null and not _has_modifier(unit, Enums.StatType.TAUNT, false):
		var def_total: float = float(unit.physical_defense + unit.magic_defense)
		var off_total: float = float(unit.physical_attack + unit.magic_attack)
		var tank_ratio: float = def_total / (def_total + off_total)
		var score: float = tank_ratio * 30.0
		if score > best_score:
			best_score = score
			best_type = "TAUNT"
			best_ability = taunt_ability
			best_target = unit

	# -- Score items --
	var item_pool: Array = player_shared_items if unit in units else enemy_shared_items
	for idx: int in item_pool.size():
		var item: ItemData = item_pool[idx]
		match item.effect_type:
			Enums.ItemEffect.HEAL_HP:
				if not item.target_ally:
					continue
				for ally: FighterData in allies:
					if ally.health <= 0 or ally.health >= ally.max_health:
						continue
					var heal_amount: int = int(ally.max_health * item.magnitude / 100.0)
					var actual: int = mini(heal_amount, ally.max_health - ally.health)
					var score: float = float(actual)
					var hp_frac: float = float(ally.health) / float(ally.max_health)
					if hp_frac < 0.25:
						score *= 2.0
					if item.target_all:
						var total: float = 0.0
						for a2: FighterData in allies:
							if a2.health > 0 and a2.health < a2.max_health:
								var a_heal: int = mini(
									int(a2.max_health * item.magnitude / 100.0),
									a2.max_health - a2.health)
								var s2: float = float(a_heal)
								if float(a2.health) / float(a2.max_health) < 0.25:
									s2 *= 2.0
								total += s2
						score = total
					if score > best_score:
						best_score = score
						best_type = "ITEM"
						best_item_idx = idx
						best_target = ally
			Enums.ItemEffect.HEAL_MP:
				if not item.target_ally:
					continue
				for ally: FighterData in allies:
					if ally.health <= 0 or ally.mana >= ally.max_mana:
						continue
					var restored: int = mini(item.magnitude, ally.max_mana - ally.mana)
					var score: float = 0.0
					var ally_cheapest: int = 999
					for a: AbilityData in ally.abilities:
						if a.mana_cost < ally_cheapest:
							ally_cheapest = a.mana_cost
					if ally.mana < ally_cheapest and ally.mana + restored >= ally_cheapest:
						var best_ev: float = 0.0
						for a: AbilityData in ally.abilities:
							if a.mana_cost == ally_cheapest and a.use_on_enemy and a.impacted_turns == 0:
								for t: FighterData in targets:
									best_ev = maxf(best_ev, float(maxi(0, _calc_ability_damage(ally, t, a))))
						score = best_ev * 0.5
					if score > best_score:
						best_score = score
						best_type = "ITEM"
						best_item_idx = idx
						best_target = ally
			Enums.ItemEffect.CURE_DEBUFF:
				if not item.target_ally:
					continue
				for ally: FighterData in allies:
					if ally.health <= 0:
						continue
					var debuff_count: int = 0
					for mod: Dictionary in ally.modified_stats:
						if mod["is_negative"]:
							debuff_count += 1
					if debuff_count == 0:
						continue
					var score: float = float(debuff_count) * 15.0
					if score > best_score:
						best_score = score
						best_type = "ITEM"
						best_item_idx = idx
						best_target = ally
			Enums.ItemEffect.BUFF:
				if item.target_ally:
					var delta: int = _compute_buff_delta(unit, item.stat_type, item.magnitude)
					if item.target_all:
						var total: float = 0.0
						for ally: FighterData in allies:
							if ally.health <= 0:
								continue
							var d: int = _compute_buff_delta(ally, item.stat_type, item.magnitude)
							total += float(d) * float(item.duration)
						if total > best_score:
							best_score = total
							best_type = "ITEM"
							best_item_idx = idx
							best_target = allies[0] if not allies.is_empty() else unit
					else:
						for ally: FighterData in allies:
							if ally.health <= 0:
								continue
							var d: int = _compute_buff_delta(ally, item.stat_type, item.magnitude)
							var score: float = float(d) * float(item.duration)
							if score > best_score:
								best_score = score
								best_type = "ITEM"
								best_item_idx = idx
								best_target = ally
				else:
					if item.target_all:
						var total: float = 0.0
						for t: FighterData in targets:
							var d: int = _compute_buff_delta(t, item.stat_type, item.magnitude)
							var s: float = float(d) * float(item.duration)
							if item.stat_type in defense_stats:
								s *= float(allies.size())
							total += s
						if total > best_score:
							best_score = total
							best_type = "ITEM"
							best_item_idx = idx
							best_target = targets[0] if not targets.is_empty() else null
					else:
						for t: FighterData in targets:
							var d: int = _compute_buff_delta(t, item.stat_type, item.magnitude)
							var score: float = float(d) * float(item.duration)
							if item.stat_type in defense_stats:
								score *= float(allies.size())
							if score > best_score:
								best_score = score
								best_type = "ITEM"
								best_item_idx = idx
								best_target = t
			Enums.ItemEffect.DAMAGE:
				if item.target_ally:
					continue
				if item.target_all:
					var total: float = 0.0
					for t: FighterData in targets:
						var score: float = float(item.magnitude)
						if item.magnitude >= t.health:
							score *= 3.0
						total += score
					if total > best_score:
						best_score = total
						best_type = "ITEM"
						best_item_idx = idx
						best_target = targets[0] if not targets.is_empty() else null
				else:
					for t: FighterData in targets:
						var score: float = float(item.magnitude)
						if item.magnitude >= t.health:
							score *= 3.0
						elif float(t.health) / float(t.max_health) < 0.25:
							score *= 1.2
						if score > best_score:
							best_score = score
							best_type = "ITEM"
							best_item_idx = idx
							best_target = t

	# -- Score block --
	if unit.mana < cheapest_cost:
		var mp_from_block: int = maxi(1, floori(unit.magic_attack / 7))
		var best_atk_ev: float = 0.0
		for t: FighterData in targets:
			var phys_dmg: float = float(maxi(
				maxi(unit.physical_attack - t.physical_defense, 0),
				maxi((unit.magic_attack - t.magic_defense) / 2, 0)))
			var hit: float = (100.0 - float(t.dodge_chance)) / 100.0
			var ev: float = phys_dmg * hit + float(mp_from_block) * hit
			best_atk_ev = maxf(best_atk_ev, ev)
		var phys_boost: float = floorf(unit.physical_defense * 0.5)
		var mag_boost: float = floorf(unit.magic_defense * 0.5)
		var avg_boost: float = (phys_boost + mag_boost) / 2.0
		var attacks_on_me: float = float(targets.size()) / maxf(1.0, float(allies.size()))
		var block_value: float = avg_boost * attacks_on_me + float(mp_from_block)
		if block_value > best_atk_ev and block_value > best_score:
			best_score = block_value
			best_type = "BLOCK"
			best_ability = null
			best_target = null

	# -- Score rest --
	var hp_pct: float = float(unit.health) / float(unit.max_health)
	var hp_restored: float = float(maxi(1, floori(unit.max_health * 0.1)))
	var mp_restored: int = maxi(2, floori(unit.magic_attack / 7) * 2)
	var hp_value: float = hp_restored if hp_pct < 0.5 else hp_restored * 0.3
	var mp_value: float = 0.0
	if unit.mana < cheapest_cost and unit.mana + mp_restored >= cheapest_cost:
		var cheapest_ev: float = 0.0
		for a: AbilityData in unit.abilities:
			if a.mana_cost == cheapest_cost and a.use_on_enemy and a.impacted_turns == 0:
				for t: FighterData in targets:
					var dmg: float = float(maxi(0, _calc_ability_damage(unit, t, a)))
					cheapest_ev = maxf(cheapest_ev, dmg)
		mp_value = cheapest_ev * 0.5
	var rest_score: float = hp_value + mp_value
	if hp_pct < 0.3:
		rest_score *= 1.5
	if rest_score > best_score:
		best_score = rest_score
		best_type = "REST"
		best_ability = null
		best_target = null

	# -- Score physical attack on each target (fallback) --
	var mp_from_hit: int = maxi(1, floori(unit.magic_attack / 7))
	var phys_mp_value: float = 0.0
	if unit.mana < cheapest_cost and unit.mana + mp_from_hit >= cheapest_cost:
		var cheapest_ev: float = 0.0
		for a: AbilityData in unit.abilities:
			if a.mana_cost == cheapest_cost and a.use_on_enemy and a.impacted_turns == 0:
				for t: FighterData in targets:
					var dmg: float = float(maxi(0, _calc_ability_damage(unit, t, a)))
					cheapest_ev = maxf(cheapest_ev, dmg)
		phys_mp_value = cheapest_ev * 0.5
	for t: FighterData in targets:
		var phys_dmg: float = float(maxi(
			maxi(unit.physical_attack - t.physical_defense, 0),
			maxi((unit.magic_attack - t.magic_defense) / 2, 0)))
		var hit: float = (100.0 - float(t.dodge_chance)) / 100.0
		var score: float = (phys_dmg + phys_mp_value) * hit
		if phys_dmg >= float(t.health):
			score *= 3.0
		elif float(t.health) / float(t.max_health) < 0.25:
			score *= 1.2
		if score > best_score:
			best_score = score
			best_type = "PHYS_ATK"
			best_ability = null
			best_target = t

	# -- Execute best action --
	_count_action(unit, best_type if best_type != "" else "PHYS_ATK")
	match best_type:
		"HEAL":
			unit.mana -= best_ability.mana_cost
			if best_ability.target_all:
				_trace("%s (%s): HEAL %s -> ALL [score: %.1f]" % [
					_tu, _tc, best_ability.ability_name, best_score])
				if not sim_mode:
					combat_message.emit(best_ability.flavor_text)
				for ally: FighterData in allies:
					if ally.health > 0:
						use_ability_on_teammate(unit, ally, best_ability, true)
			else:
				_trace("%s (%s): HEAL %s -> %s [score: %.1f]" % [
					_tu, _tc, best_ability.ability_name, best_target.character_name, best_score])
				use_ability_on_teammate(unit, best_target, best_ability)
		"BUFF":
			unit.mana -= best_ability.mana_cost
			if best_ability.target_all:
				_trace("%s (%s): BUFF %s -> ALL [score: %.1f]" % [
					_tu, _tc, best_ability.ability_name, best_score])
				if not sim_mode:
					combat_message.emit(best_ability.flavor_text)
				for ally: FighterData in allies:
					if ally.health > 0:
						use_ability_on_teammate(unit, ally, best_ability, true)
			else:
				_trace("%s (%s): BUFF %s -> %s [score: %.1f]" % [
					_tu, _tc, best_ability.ability_name, best_target.character_name, best_score])
				use_ability_on_teammate(unit, best_target, best_ability)
		"DEBUFF":
			unit.mana -= best_ability.mana_cost
			if best_ability.target_all:
				_trace("%s (%s): DEBUFF %s -> ALL [score: %.1f]" % [
					_tu, _tc, best_ability.ability_name, best_score])
				if not sim_mode:
					combat_message.emit(best_ability.flavor_text)
				for t: FighterData in targets:
					use_ability_on_enemy(unit, t, best_ability, true, targets.size())
			else:
				_trace("%s (%s): DEBUFF %s -> %s [score: %.1f]" % [
					_tu, _tc, best_ability.ability_name, best_target.character_name, best_score])
				use_ability_on_enemy(unit, best_target, best_ability)
		"AOE":
			unit.mana -= best_ability.mana_cost
			_trace("%s (%s): AOE %s -> ALL (%d targets) [score: %.1f]" % [
				_tu, _tc, best_ability.ability_name, targets.size(), best_score])
			if not sim_mode:
				combat_message.emit(best_ability.flavor_text)
			for t: FighterData in targets:
				use_ability_on_enemy(unit, t, best_ability, true, targets.size())
		"ABILITY":
			unit.mana -= best_ability.mana_cost
			_trace("%s (%s): ABILITY %s -> %s [score: %.1f]" % [
				_tu, _tc, best_ability.ability_name, best_target.character_name, best_score])
			use_ability_on_enemy(unit, best_target, best_ability)
		"TAUNT":
			unit.mana -= best_ability.mana_cost
			_trace("%s (%s): TAUNT [score: %.1f]" % [_tu, _tc, best_score])
			use_ability_on_teammate(unit, unit, best_ability)
		"BLOCK":
			_trace("%s (%s): BLOCK [score: %.1f]" % [_tu, _tc, best_score])
			perform_block(unit)
		"REST":
			_trace("%s (%s): REST [score: %.1f]" % [_tu, _tc, best_score])
			perform_rest(unit)
		"ITEM":
			var item: ItemData = item_pool[best_item_idx]
			var tgt_name: String = best_target.character_name if best_target else "ALL"
			_trace("%s (%s): ITEM %s -> %s [score: %.1f]" % [
				_tu, _tc, item.item_name, tgt_name, best_score])
			if unit in units:
				_consume_player_item(unit, best_target, best_item_idx)
			else:
				_consume_shared_item(unit, best_target, best_item_idx)
		"PHYS_ATK":
			_trace("%s (%s): PHYS_ATK -> %s [score: %.1f]" % [
				_tu, _tc, best_target.character_name, best_score])
			physical_attack(unit, best_target)
		_:
			var target: FighterData = targets[0]
			_trace("%s (%s): PHYS_ATK (fallback) -> %s" % [_tu, _tc, target.character_name])
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
