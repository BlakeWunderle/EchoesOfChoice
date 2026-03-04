extends Control

## Battle scene. Connects BattleEngine to visual UI.

const BattleEngine := preload("res://scripts/battle/battle_engine.gd")
const CombatLog := preload("res://scripts/ui/combat_log.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const FighterBar := preload("res://scripts/ui/fighter_bar.gd")
const StatsPanel := preload("res://scripts/ui/stats_panel.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityData := preload("res://scripts/data/ability_data.gd")
const BattleData := preload("res://scripts/data/battle_data.gd")

enum Phase {
	STARTING,
	TICKING_ATB,
	PLAYER_ACTION,
	PLAYER_TARGET_ATTACK,
	PLAYER_ABILITY_SELECT,
	PLAYER_ABILITY_TARGET_ENEMY,
	PLAYER_ABILITY_TARGET_ALLY,
	SHOWING_STATS,
	STATS_PICK,
	AI_ACTING,
	MESSAGE_DELAY,
	BATTLE_END,
}

const COMBAT_PAUSE: float = 1.2  ## Seconds between combat messages (C# Thread.Sleep(1200))

var _engine: BattleEngine
var _phase: Phase = Phase.STARTING
var _current_actor: FighterData
var _selected_ability: AbilityData
var _message_queue: Array[String] = []
var _processing_messages: bool = false
var _escape_hp_pct: float = 0.0  ## Boss escape threshold from BattleData
var _boss_escaped: bool = false

signal _player_turn_done

# UI elements
var _party_bars: Array[FighterBar] = []
var _enemy_bars: Array[FighterBar] = []
var _combat_log: CombatLog
var _action_menu: ChoiceMenu
var _turn_label: Label
var _stats_panel: StatsPanel
var _scene_image: TextureRect
var _scene_image_panel: PanelContainer

# Layout containers
var _top_panel: HBoxContainer
var _party_vbox: VBoxContainer
var _enemy_vbox: VBoxContainer
var _bottom_panel: VBoxContainer
var _turn_order_label: RichTextLabel
var _turn_queue: Array = []  ## Predicted turn order, depleted as actors act


func _ready() -> void:
	_build_ui()
	_start_battle()


func _build_ui() -> void:
	var root := VBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", 4)
	add_child(root)

	# Top: party + enemy status bars
	_top_panel = HBoxContainer.new()
	_top_panel.add_theme_constant_override("separation", 24)
	_top_panel.custom_minimum_size = Vector2(0, 120)
	root.add_child(_top_panel)

	_party_vbox = VBoxContainer.new()
	_party_vbox.add_theme_constant_override("separation", 4)
	_party_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_top_panel.add_child(_party_vbox)

	var party_header := Label.new()
	party_header.text = "  Party"
	party_header.add_theme_font_size_override("font_size", 16)
	_party_vbox.add_child(party_header)

	_enemy_vbox = VBoxContainer.new()
	_enemy_vbox.add_theme_constant_override("separation", 4)
	_enemy_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_top_panel.add_child(_enemy_vbox)

	var enemy_header := Label.new()
	enemy_header.text = "  Enemies"
	enemy_header.add_theme_font_size_override("font_size", 16)
	_enemy_vbox.add_child(enemy_header)

	# Turn order bar
	_turn_order_label = RichTextLabel.new()
	_turn_order_label.bbcode_enabled = true
	_turn_order_label.fit_content = true
	_turn_order_label.scroll_active = false
	_turn_order_label.add_theme_font_size_override("normal_font_size", 13)
	_turn_order_label.custom_minimum_size = Vector2(0, 20)
	root.add_child(_turn_order_label)

	# Middle: combat log (left) + scene image (right)
	var middle_panel := HBoxContainer.new()
	middle_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	middle_panel.custom_minimum_size = Vector2(0, 200)
	middle_panel.add_theme_constant_override("separation", 8)
	root.add_child(middle_panel)

	_combat_log = CombatLog.new()
	_combat_log.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_combat_log.size_flags_vertical = Control.SIZE_EXPAND_FILL
	middle_panel.add_child(_combat_log)

	_scene_image_panel = PanelContainer.new()
	_scene_image_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scene_image_panel.custom_minimum_size = Vector2(360, 0)
	middle_panel.add_child(_scene_image_panel)

	_scene_image = TextureRect.new()
	_scene_image.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	_scene_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_scene_image.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scene_image.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scene_image.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	_scene_image_panel.add_child(_scene_image)



	# Turn indicator
	_turn_label = Label.new()
	_turn_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_turn_label.add_theme_font_size_override("font_size", 18)
	_turn_label.visible = false
	root.add_child(_turn_label)

	# Bottom: action menu
	_bottom_panel = VBoxContainer.new()
	_bottom_panel.custom_minimum_size = Vector2(0, 160)
	_bottom_panel.alignment = BoxContainer.ALIGNMENT_CENTER
	root.add_child(_bottom_panel)

	_action_menu = ChoiceMenu.new()
	_action_menu.choice_selected.connect(_on_action_selected)
	_action_menu.visible = false
	_bottom_panel.add_child(_action_menu)

	# Stats panel (overlay)
	_stats_panel = StatsPanel.new()
	_stats_panel.closed.connect(_on_stats_closed)
	_stats_panel.visible = false
	_stats_panel.set_anchors_preset(Control.PRESET_CENTER)
	_stats_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_stats_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	_stats_panel.custom_minimum_size = Vector2(350, 0)
	add_child(_stats_panel)



func _start_battle() -> void:
	_engine = BattleEngine.new()
	_engine.combat_message.connect(_on_combat_message)
	_engine.fighter_died.connect(_on_fighter_died)
	_engine.battle_won.connect(_on_battle_won)
	_engine.battle_lost.connect(_on_battle_lost)

	var battle: BattleData = GameState.current_battle
	_escape_hp_pct = battle.escape_hp_pct
	_boss_escaped = false
	if not battle.scene_image.is_empty() and ResourceLoader.exists(battle.scene_image):
		_scene_image.texture = load(battle.scene_image)
	if not battle.music_track.is_empty():
		MusicManager.play_music(battle.music_track)
	else:
		MusicManager.play_context(MusicManager.MusicContext.BATTLE)
	_engine.start_battle(GameState.party, battle.enemies)
	GameLog.info("Battle started: %s (%d enemies)" % [
		GameState.current_battle_id, battle.enemies.size()])

	_build_status_bars()
	_combat_log.add_message("[color=gold]Battle begins![/color]")
	_compute_turn_order()
	_display_turn_order()
	_phase = Phase.TICKING_ATB
	_tick_loop()


func _build_status_bars() -> void:
	for bar: FighterBar in _party_bars:
		bar.queue_free()
	_party_bars.clear()
	for bar: FighterBar in _enemy_bars:
		bar.queue_free()
	_enemy_bars.clear()

	for f: FighterData in _engine.units:
		var bar := FighterBar.new()
		_party_vbox.add_child(bar)
		bar.setup(f, false)
		_party_bars.append(bar)

	for f: FighterData in _engine.enemies:
		var bar := FighterBar.new()
		_enemy_vbox.add_child(bar)
		bar.setup(f, true)
		_enemy_bars.append(bar)


func _refresh_bars() -> void:
	for i: int in _party_bars.size():
		if i < _engine.units.size():
			_party_bars[i].update_display(_engine.units[i])
			_party_bars[i].visible = true
		else:
			_party_bars[i].visible = false
	for i: int in _enemy_bars.size():
		if i < _engine.enemies.size():
			_enemy_bars[i].update_display(_engine.enemies[i])
			_enemy_bars[i].visible = true
		else:
			_enemy_bars[i].visible = false


# =============================================================================
# Main ATB loop
# =============================================================================

func _tick_loop() -> void:
	_phase = Phase.TICKING_ATB
	while true:
		if not _engine.tick_atb():
			continue

		var actors: Array = _engine.get_acting_units()
		for actor: FighterData in actors:
			if actor.health <= 0:
				continue

			_current_actor = actor
			# Pop this actor from the display queue
			if not _turn_queue.is_empty() and _turn_queue[0] == actor:
				_turn_queue.pop_front()
			_display_turn_order()

			_engine.reset_modified_stat(actor)
			_engine.tick_cooldowns(actor)
			await _drain_messages()

			if _engine.is_battle_over():
				_end_battle()
				return

			# Turn announcement
			var turn_text: String
			if actor.character_name.ends_with("s"):
				turn_text = "It is %s' turn." % actor.character_name
			else:
				turn_text = "It is %s's turn." % actor.character_name
			_combat_log.add_separator()
			_combat_log.add_message("[color=yellow]%s[/color]" % turn_text)

			if actor.is_user_controlled:
				_phase = Phase.PLAYER_ACTION
				_show_action_menu(actor)
				await _player_turn_done
			else:
				# AI turn
				_phase = Phase.AI_ACTING
				var is_party: bool = _engine.units.has(actor)
				var targets: Array = _engine.enemies if is_party else _engine.units
				var allies: Array = _engine.units if is_party else _engine.enemies
				_engine.execute_ai_turn(actor, targets, allies)

			# Post-action (same for player and AI)
			await _drain_messages()
			_refresh_bars()

			# Check boss escape before death, escape triggers at HP threshold
			if _check_boss_escape():
				_end_battle()
				return

			_engine.check_for_death()
			_rebuild_bars_if_needed()
			await _drain_messages()

			if _engine.is_battle_over():
				_end_battle()
				return

			_phase = Phase.TICKING_ATB

		_engine.reset_turns()
		_compute_turn_order()
		_display_turn_order()


# =============================================================================
# Cooldown management
# =============================================================================

func _set_cooldown(fighter: FighterData, ability: AbilityData) -> void:
	if ability.cooldown > 0:
		fighter.ability_cooldowns[ability.ability_name] = ability.cooldown


func _is_ability_available(fighter: FighterData, ability: AbilityData) -> bool:
	return ability.mana_cost <= fighter.mana \
		and fighter.ability_cooldowns.get(ability.ability_name, 0) <= 0


# =============================================================================
# Player action handling
# =============================================================================

func _show_action_menu(actor: FighterData) -> void:
	_turn_label.text = "[%s the %s]" % [actor.character_name, actor.character_type]
	_turn_label.visible = true

	var has_available: bool = false
	for a: AbilityData in actor.abilities:
		if _is_ability_available(actor, a):
			has_available = true
			break

	var options: Array[Dictionary] = [{"label": "Attack"}]
	if has_available:
		options.append({"label": "Ability"})
	options.append({"label": "Stats"})
	_action_menu.show_choices(options)


func _on_action_selected(index: int) -> void:
	_action_menu.hide_menu()
	_turn_label.visible = false

	# Map index accounting for possibly missing Ability option
	var has_available: bool = false
	for a: AbilityData in _current_actor.abilities:
		if _is_ability_available(_current_actor, a):
			has_available = true
			break

	var action: String
	if index == 0:
		action = "attack"
	elif has_available and index == 1:
		action = "ability"
	else:
		action = "stats"

	match action:
		"attack":
			_phase = Phase.PLAYER_TARGET_ATTACK
			_show_target_menu(_engine.enemies)
		"ability":
			_phase = Phase.PLAYER_ABILITY_SELECT
			_show_ability_menu()
		"stats":
			_phase = Phase.STATS_PICK
			_show_stats_pick()


func _show_target_menu(fighters: Array) -> void:
	var options: Array[Dictionary] = []
	for f: FighterData in fighters:
		options.append({"label": "%s the %s (HP: %d/%d)" % [
			f.character_name, f.character_type, f.health, f.max_health]})
	options.append({"label": "Back"})
	_action_menu.show_choices(options)
	_action_menu.choice_selected.disconnect(_on_action_selected)
	_action_menu.choice_selected.connect(_on_target_selected)


func _on_target_selected(index: int) -> void:
	# Check for Back option
	var fighter_count: int
	match _phase:
		Phase.PLAYER_TARGET_ATTACK, Phase.PLAYER_ABILITY_TARGET_ENEMY:
			fighter_count = _engine.enemies.size()
		Phase.PLAYER_ABILITY_TARGET_ALLY:
			fighter_count = _engine.units.size()
		_:
			fighter_count = 0

	if index >= fighter_count:
		# Back: return to appropriate menu
		_action_menu.choice_selected.disconnect(_on_target_selected)
		_action_menu.choice_selected.connect(_on_action_selected)
		_action_menu.hide_menu()
		if _phase == Phase.PLAYER_TARGET_ATTACK:
			_phase = Phase.PLAYER_ACTION
			_show_action_menu(_current_actor)
		else:
			# Ability target, go back to ability list
			_phase = Phase.PLAYER_ABILITY_SELECT
			_show_ability_menu()
		return

	_action_menu.choice_selected.disconnect(_on_target_selected)
	_action_menu.choice_selected.connect(_on_action_selected)
	_action_menu.hide_menu()
	_turn_label.visible = false

	match _phase:
		Phase.PLAYER_TARGET_ATTACK:
			var taunter: FighterData = _engine.get_taunt_target(_engine.enemies)
			var target: FighterData
			if taunter:
				target = taunter
				_combat_log.add_message("%s has taunted your attention!" % taunter.character_name)
			else:
				target = _engine.enemies[index]
			_engine.physical_attack(_current_actor, target)
		Phase.PLAYER_ABILITY_TARGET_ENEMY:
			var taunter: FighterData = _engine.get_taunt_target(_engine.enemies)
			var target: FighterData
			if taunter:
				target = taunter
				_combat_log.add_message("%s has taunted your attention!" % taunter.character_name)
			else:
				target = _engine.enemies[index]
			_current_actor.mana -= _selected_ability.mana_cost
			_set_cooldown(_current_actor, _selected_ability)
			_engine.use_ability_on_enemy(_current_actor, target, _selected_ability)
		Phase.PLAYER_ABILITY_TARGET_ALLY:
			_current_actor.mana -= _selected_ability.mana_cost
			_set_cooldown(_current_actor, _selected_ability)
			_engine.use_ability_on_teammate(
				_current_actor, _engine.units[index], _selected_ability)

	_player_turn_done.emit()


func _show_ability_menu() -> void:
	var available: Array[AbilityData] = []
	for a: AbilityData in _current_actor.abilities:
		if _is_ability_available(_current_actor, a):
			available.append(a)

	var options: Array[Dictionary] = []
	for a: AbilityData in available:
		var label: String = "%s (%d MP)" % [a.ability_name, a.mana_cost]
		if a.cooldown > 0:
			label += " [CD %d]" % a.cooldown
		options.append({"label": label, "description": a.get_description()})
	options.append({"label": "Back"})

	_action_menu.show_choices(options)
	_action_menu.choice_selected.disconnect(_on_action_selected)
	_action_menu.choice_selected.connect(_on_ability_selected)


func _on_ability_selected(index: int) -> void:
	var available: Array[AbilityData] = []
	for a: AbilityData in _current_actor.abilities:
		if _is_ability_available(_current_actor, a):
			available.append(a)

	# Back option
	if index >= available.size():
		_action_menu.choice_selected.disconnect(_on_ability_selected)
		_action_menu.choice_selected.connect(_on_action_selected)
		_action_menu.hide_menu()
		_phase = Phase.PLAYER_ACTION
		_show_action_menu(_current_actor)
		return

	_action_menu.choice_selected.disconnect(_on_ability_selected)
	_action_menu.choice_selected.connect(_on_action_selected)
	_action_menu.hide_menu()

	_selected_ability = available[index]

	if _selected_ability.target_all:
		# AoE, no target selection needed
		_current_actor.mana -= _selected_ability.mana_cost
		_set_cooldown(_current_actor, _selected_ability)
		if _selected_ability.use_on_enemy:
			_combat_log.add_message("%s targets all enemies!" % _current_actor.character_name)
			for enemy: FighterData in _engine.enemies.duplicate():
				_engine.use_ability_on_enemy(_current_actor, enemy, _selected_ability)
		else:
			_combat_log.add_message("%s targets all allies!" % _current_actor.character_name)
			for ally: FighterData in _engine.units.duplicate():
				_engine.use_ability_on_teammate(_current_actor, ally, _selected_ability)

		_player_turn_done.emit()
	elif _selected_ability.use_on_enemy:
		_phase = Phase.PLAYER_ABILITY_TARGET_ENEMY
		_show_target_menu(_engine.enemies)
	else:
		_phase = Phase.PLAYER_ABILITY_TARGET_ALLY
		_show_target_menu(_engine.units)


# =============================================================================
# Stats viewing
# =============================================================================

func _show_stats_pick() -> void:
	var options: Array[Dictionary] = []
	for f: FighterData in _engine.units:
		options.append({"label": "%s the %s" % [f.character_name, f.character_type]})
	for f: FighterData in _engine.enemies:
		options.append({"label": "%s the %s" % [f.character_name, f.character_type]})
	options.append({"label": "Back"})

	_action_menu.show_choices(options)
	if _action_menu.choice_selected.is_connected(_on_action_selected):
		_action_menu.choice_selected.disconnect(_on_action_selected)
	if not _action_menu.choice_selected.is_connected(_on_stats_pick_selected):
		_action_menu.choice_selected.connect(_on_stats_pick_selected)


func _on_stats_pick_selected(index: int) -> void:
	var total: int = _engine.units.size() + _engine.enemies.size()
	if index >= total:
		# Back
		_action_menu.choice_selected.disconnect(_on_stats_pick_selected)
		_action_menu.choice_selected.connect(_on_action_selected)
		_action_menu.hide_menu()
		_phase = Phase.PLAYER_ACTION
		_show_action_menu(_current_actor)
		return

	_action_menu.hide_menu()
	var fighter: FighterData
	if index < _engine.units.size():
		fighter = _engine.units[index]
	else:
		fighter = _engine.enemies[index - _engine.units.size()]

	_phase = Phase.SHOWING_STATS
	_stats_panel.show_fighter(fighter)


func _on_stats_closed() -> void:
	_stats_panel.visible = false
	_phase = Phase.STATS_PICK
	_show_stats_pick()


# =============================================================================
# Message queue & delays
# =============================================================================

func _on_combat_message(text: String) -> void:
	_message_queue.append(text)


func _drain_messages() -> void:
	while not _message_queue.is_empty():
		var msg: String = _message_queue.pop_front()
		_combat_log.add_message(msg)
		await get_tree().create_timer(COMBAT_PAUSE).timeout
	_refresh_bars()


# =============================================================================
# Battle end
# =============================================================================

func _check_boss_escape() -> bool:
	if _escape_hp_pct <= 0.0:
		return false
	for enemy: FighterData in _engine.enemies:
		if enemy.health > 0 and float(enemy.health) / float(enemy.max_health) <= _escape_hp_pct:
			_boss_escaped = true
			_combat_log.add_message("")
			_combat_log.add_message("[color=yellow]%s staggers back, then vanishes in a flash of dark energy![/color]" % enemy.character_name)
			return true
	return false


func _end_battle() -> void:
	_phase = Phase.BATTLE_END
	await _drain_messages()

	_engine.finish_battle()

	if _boss_escaped or _engine.did_player_win():
		GameLog.info("Battle won: %s" % GameState.current_battle_id)
		_combat_log.add_message("")
		if _boss_escaped:
			_combat_log.add_message("[color=gold]The enemy has fled! Victory is yours... for now.[/color]")
		else:
			_combat_log.add_message("[color=gold]Victory! The enemies have been vanquished.[/color]")
		await get_tree().create_timer(2.0).timeout
		GameState.advance_to_post_battle()
		SceneManager.change_scene("res://scenes/narrative/narrative.tscn")
	else:
		GameLog.info("Battle lost: %s" % GameState.current_battle_id)
		_combat_log.add_message("")
		_combat_log.add_message("[color=red]The party has been defeated...[/color]")
		await get_tree().create_timer(2.0).timeout
		GameState.go_to_ending(false)
		SceneManager.change_scene("res://scenes/narrative/narrative.tscn")


func _on_fighter_died(_fighter: FighterData) -> void:
	pass  # Death messages handled by engine signals


func _on_battle_won() -> void:
	pass  # Handled in _end_battle


func _on_battle_lost() -> void:
	pass  # Handled in _end_battle


func _rebuild_bars_if_needed() -> void:
	# Hide bars for dead fighters
	for i: int in _party_bars.size():
		_party_bars[i].visible = i < _engine.units.size()
		if i < _engine.units.size():
			_party_bars[i].update_display(_engine.units[i])
	for i: int in _enemy_bars.size():
		_enemy_bars[i].visible = i < _engine.enemies.size()
		if i < _engine.enemies.size():
			_enemy_bars[i].update_display(_engine.enemies[i])


func _compute_turn_order() -> void:
	## Predict the next several turns by simulating ATB ticks forward.
	_turn_queue.clear()

	var all_fighters: Array = []
	for f: FighterData in _engine.units:
		all_fighters.append(f)
	for f: FighterData in _engine.enemies:
		all_fighters.append(f)

	if all_fighters.is_empty():
		return

	# Snapshot current ATB values
	var atb: Dictionary = {}
	for f: FighterData in all_fighters:
		atb[f] = f.turn_calculation

	var show_count: int = mini(8, all_fighters.size() * 2)

	while _turn_queue.size() < show_count:
		# Tick until someone reaches 100
		var ready: Array = []
		for _i: int in 200:  # safety limit
			for f: FighterData in all_fighters:
				atb[f] += f.speed
			ready.clear()
			for f: FighterData in all_fighters:
				if atb[f] >= 100:
					ready.append(f)
			if not ready.is_empty():
				break

		if ready.is_empty():
			break

		# Sort by highest ATB (same as get_acting_units)
		ready.sort_custom(func(a: FighterData, b: FighterData) -> bool:
			return atb[a] > atb[b])

		for f: FighterData in ready:
			atb[f] -= 100
			_turn_queue.append(f)


func _display_turn_order() -> void:
	## Render the turn queue. Current actor in green, allies cyan, enemies salmon.
	var parts: Array[String] = []

	# Current actor first (green)
	if _current_actor != null:
		parts.append("[color=lime]%s[/color]" % _current_actor.character_name)

	# Remaining queue
	for f: FighterData in _turn_queue:
		if _engine.units.has(f):
			parts.append("[color=cyan]%s[/color]" % f.character_name)
		else:
			parts.append("[color=salmon]%s[/color]" % f.character_name)

	_turn_order_label.clear()
	_turn_order_label.append_text(
		"[color=gray]Turn Order:[/color]  " + "  >  ".join(parts))
