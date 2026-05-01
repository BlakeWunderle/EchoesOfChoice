class_name BattleMultiplayer
extends RefCounted

## Multiplayer RPC logic helper for the battle scene.
## @rpc annotations must stay on battle.gd (Node in tree); this class
## holds the actual implementation that those thin wrappers delegate to.

const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityData := preload("res://scripts/data/ability_data.gd")
const ItemData := preload("res://scripts/data/item_data.gd")

var _battle: Control


func _init(battle: Control) -> void:
	_battle = battle


# =============================================================================
# Non-RPC helpers
# =============================================================================

## Host executes a remote player's action on the engine.
func execute_remote_action(actor: FighterData, action: Dictionary) -> void:
	var action_type: String = action.get("type", "attack")
	var target_index: int = action.get("target_index", 0)

	match action_type:
		"attack":
			var taunter: FighterData = _battle._engine.get_taunt_target(_battle._engine.enemies)
			var target: FighterData
			if taunter:
				target = taunter
			elif target_index < _battle._engine.enemies.size():
				target = _battle._engine.enemies[target_index]
			else:
				target = _battle._engine.enemies[0]
			_battle._engine.physical_attack(actor, target)

		"ability_enemy":
			var ability: AbilityData = find_ability(actor, action.get("ability_name", ""))
			if ability == null:
				_battle._engine.physical_attack(actor, _battle._engine.enemies[0])
				return
			actor.mana -= ability.mana_cost
			if ability.target_all:
				for enemy: FighterData in _battle._engine.enemies.duplicate():
					_battle._engine.use_ability_on_enemy(actor, enemy, ability, true)
			else:
				var taunter: FighterData = _battle._engine.get_taunt_target(_battle._engine.enemies)
				var target: FighterData
				if taunter:
					target = taunter
				elif target_index < _battle._engine.enemies.size():
					target = _battle._engine.enemies[target_index]
				else:
					target = _battle._engine.enemies[0]
				_battle._engine.use_ability_on_enemy(actor, target, ability)

		"ability_ally":
			var ability: AbilityData = find_ability(actor, action.get("ability_name", ""))
			if ability == null:
				return
			actor.mana -= ability.mana_cost
			if ability.target_all:
				for ally: FighterData in _battle._engine.units.duplicate():
					_battle._engine.use_ability_on_teammate(actor, ally, ability, true)
			else:
				if target_index < _battle._engine.units.size():
					_battle._engine.use_ability_on_teammate(actor, _battle._engine.units[target_index], ability)

		"block":
			_battle._engine.perform_block(actor)

		"rest":
			_battle._engine.perform_rest(actor)

		"item":
			var item_idx: int = action.get("item_index", 0)
			var item: ItemData = GameState.inventory.use_item(item_idx)
			if item == null:
				return
			var target: FighterData
			if item.target_all or item.target_ally:
				if target_index < _battle._engine.units.size():
					target = _battle._engine.units[target_index]
				else:
					target = actor
			else:
				if target_index < _battle._engine.enemies.size():
					target = _battle._engine.enemies[target_index]
				else:
					target = _battle._engine.enemies[0]
			_battle._engine.use_item(actor, target, item)


func find_ability(actor: FighterData, ability_name: String) -> AbilityData:
	for a: AbilityData in actor.abilities:
		if a.ability_name == ability_name:
			return a
	return null


## Host broadcasts full fighter state to all peers after each action.
func broadcast_state_sync() -> void:
	if not NetManager.is_host:
		return

	# Serialize all fighters
	var party_state: Array[Dictionary] = []
	for f: FighterData in _battle._all_party:
		party_state.append(serialize_fighter_combat(f))
	var enemy_state: Array[Dictionary] = []
	for f: FighterData in _battle._all_enemies:
		enemy_state.append(serialize_fighter_combat(f))

	# Alive indices
	var alive_party: Array[int] = []
	for f: FighterData in _battle._engine.units:
		var idx: int = _battle._all_party.find(f)
		if idx >= 0:
			alive_party.append(idx)
	var alive_enemies: Array[int] = []
	for f: FighterData in _battle._engine.enemies:
		var idx: int = _battle._all_enemies.find(f)
		if idx >= 0:
			alive_enemies.append(idx)

	# Combat log messages accumulated since last sync
	var log_lines: Array[String] = _battle._message_queue.duplicate()

	_battle._rpc_state_sync.rpc(party_state, enemy_state, alive_party, alive_enemies, log_lines)


func serialize_fighter_combat(f: FighterData) -> Dictionary:
	return {
		"hp": f.health,
		"max_hp": f.max_health,
		"mp": f.mana,
		"max_mp": f.max_mana,
		"atb": f.turn_calculation,
		"phys_atk": f.physical_attack,
		"phys_def": f.physical_defense,
		"mag_atk": f.magic_attack,
		"mag_def": f.magic_defense,
		"speed": f.speed,
		"crit": f.crit_chance,
		"dodge": f.dodge_chance,
	}


func apply_fighter_combat(f: FighterData, data: Dictionary) -> void:
	f.health = data.get("hp", f.health)
	f.max_health = data.get("max_hp", f.max_health)
	f.mana = data.get("mp", f.mana)
	f.max_mana = data.get("max_mp", f.max_mana)
	f.turn_calculation = data.get("atb", f.turn_calculation)
	f.physical_attack = data.get("phys_atk", f.physical_attack)
	f.physical_defense = data.get("phys_def", f.physical_defense)
	f.magic_attack = data.get("mag_atk", f.magic_attack)
	f.magic_defense = data.get("mag_def", f.magic_defense)
	f.speed = data.get("speed", f.speed)
	f.crit_chance = data.get("crit", f.crit_chance)
	f.dodge_chance = data.get("dodge", f.dodge_chance)


# =============================================================================
# RPC handler logic (called by thin @rpc wrappers in battle.gd)
# =============================================================================

## Host -> All: Full state sync after each action.
func handle_state_sync(
	party_state: Array,
	enemy_state: Array,
	alive_party: Array,
	alive_enemies: Array,
	log_lines: Array,
) -> void:
	# Apply combat state to local fighter instances
	for i: int in mini(party_state.size(), _battle._all_party.size()):
		apply_fighter_combat(_battle._all_party[i], party_state[i])
	for i: int in mini(enemy_state.size(), _battle._all_enemies.size()):
		apply_fighter_combat(_battle._all_enemies[i], enemy_state[i])

	# Update alive/dead status on engine arrays
	_battle._engine.units.clear()
	for idx: int in alive_party:
		if idx < _battle._all_party.size():
			_battle._engine.units.append(_battle._all_party[idx])
	_battle._engine.enemies.clear()
	for idx: int in alive_enemies:
		if idx < _battle._all_enemies.size():
			_battle._engine.enemies.append(_battle._all_enemies[idx])

	# Display combat log messages
	for line: String in log_lines:
		_battle._add_log(line)

	# Refresh cards
	_battle._rebuild_cards_if_needed()
	_battle._refresh_cards()


## Host -> Specific Peer: Request player action for their character.
func handle_request_action(actor_party_idx: int) -> void:
	# Guest receives: show action menu for this character
	if actor_party_idx < 0 or actor_party_idx >= _battle._all_party.size():
		return
	var actor: FighterData = _battle._all_party[actor_party_idx]
	_battle._current_actor = actor
	_battle._highlight_active_card(actor)

	# Turn announcement already sent by host via _rpc_combat_log

	_battle._phase = _battle.Phase.PLAYER_ACTION
	_battle._show_action_menu(actor)
	await _battle._player_turn_done
	# Action completed -- send it to host
	# (action dict was built by the modified _on_target_selected / _on_ability_selected)


## Guest -> Host: Submit chosen action.
func handle_submit_action(action: Dictionary) -> void:
	if not NetManager.is_host:
		return
	_battle._remote_action_received.emit(action)


## Host -> All: Battle ended.
func handle_battle_ended(won: bool, stats_data: Array = []) -> void:
	_battle._phase = _battle.Phase.BATTLE_END
	_battle._highlight_active_card(null)
	if won:
		_battle._add_log("[color=gold]Victory! The enemies have been vanquished.[/color]")
	else:
		_battle._add_log("[color=red]The party has been defeated...[/color]")

	# Restore battle stats from host data
	_apply_battle_stats(stats_data)

	if won:
		SFXManager.play(SFXManager.Category.UI_FANFARE)
		await _battle.get_tree().create_timer(1.0).timeout
		await _battle._show_battle_summary()
		GameState.advance_to_post_battle()
		# Guest doesn't change scene — host sends change_scene_for_peers after
		# its own summary gate resolves. Guest's ready signal was already sent
		# inside _show_battle_summary() → _wait_summary_ready().
	else:
		await _battle.get_tree().create_timer(2.0).timeout
		GameState.go_to_ending(false)
		# Guest waits for host's change_scene_for_peers


func _apply_battle_stats(stats_data: Array) -> void:
	for entry: Dictionary in stats_data:
		var idx: int = entry.get("index", -1)
		if idx >= 0 and idx < _battle._all_party.size():
			var f: FighterData = _battle._all_party[idx]
			_battle._battle_stats[f] = {
				"damage_dealt": entry.get("damage_dealt", 0),
				"damage_taken": entry.get("damage_taken", 0),
				"healing_done": entry.get("healing_done", 0),
				"kills": entry.get("kills", 0),
			}


## Host -> All: Combat log line (for real-time log display).
func handle_combat_log(text: String) -> void:
	_battle._add_log(text)


## Handle peer disconnect during battle.
func on_peer_left_mid_battle(_peer_id: int, player_name: String) -> void:
	_battle._add_log("[color=yellow]%s disconnected. AI will take over.[/color]" % player_name)
	# If we're waiting for a remote action, unblock the tick loop
	if _battle._phase == _battle.Phase.PLAYER_ACTION and _battle._waiting_overlay.visible:
		_battle._remote_action_received.emit({"type": "attack", "target_index": 0})
