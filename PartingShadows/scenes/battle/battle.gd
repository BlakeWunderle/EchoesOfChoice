extends Control

## Battle scene. Connects BattleEngine to visual UI.
## Visual-first layout: scene image background, portrait cards for all fighters,
## minimal action text overlay instead of scrolling combat log.

const BattleEngine := preload("res://scripts/battle/battle_engine.gd")
const BattleDisplay_C := preload("res://scenes/battle/battle_display.gd")
const BattleUIBuilder_C := preload("res://scenes/battle/battle_ui_builder.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const PortraitCard := preload("res://scripts/ui/portrait_card.gd")
const StatsPanel := preload("res://scripts/ui/stats_panel.gd")
const TipOverlay := preload("res://scripts/ui/tip_overlay.gd")
const ReadyGate := preload("res://scripts/ui/ready_gate.gd")
const WaitingOverlay := preload("res://scripts/ui/waiting_overlay.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")
const AbilityData := preload("res://scripts/data/ability_data.gd")
const ItemData := preload("res://scripts/data/item_data.gd")
const BattleData := preload("res://scripts/data/battle_data.gd")
const BattleMultiplayer_C := preload("res://scenes/battle/battle_multiplayer.gd")
const LootRoller := preload("res://scripts/battle/loot_roller.gd")
const EnemyItemDB := preload("res://scripts/data/enemy_item_db.gd")

enum Phase {
	STARTING,
	TICKING_ATB,
	PLAYER_ACTION,
	PLAYER_ACTIONS_SUBMENU,
	PLAYER_TARGET_ATTACK,
	PLAYER_ABILITY_SELECT,
	PLAYER_ABILITY_TARGET_ENEMY,
	PLAYER_ABILITY_TARGET_ALLY,
	SHOWING_STATS,
	STATS_PICK,
	PLAYER_ITEM_SELECT,
	PLAYER_ITEM_TARGET,
	PLAYER_ULTIMATE_TARGET_ENEMY,
	PLAYER_ULTIMATE_TARGET_ALLY,
	AI_ACTING,
	MESSAGE_DELAY,
	BATTLE_END,
}

var COMBAT_PAUSE: float = 1.2  ## Seconds between combat messages

var _engine: BattleEngine
var _phase: Phase = Phase.STARTING
var _current_actor: FighterData
var _selected_ability: AbilityData
var _selected_item: ItemData
var _message_queue: Array[String] = []
var _processing_messages: bool = false
var _escape_hp_pct: float = 0.0  ## Boss escape threshold from BattleData
var _boss_escaped: bool = false
var _battle_stats: Dictionary = {}  ## FighterData -> {damage_dealt, damage_taken, healing_done, kills}
var _auto_battle: bool = false
var _auto_battle_unlocked: bool = false
var _summary_waiting: bool = false
var _loot_waiting: bool = false
var _summary_gate: ReadyGate = null
var _loot_gate: ReadyGate = null
var _pending_summary_ready: Array[int] = []
var _pending_loot_ready: Array[int] = []
var _summary_phase_done: bool = false
var _combat_event_queue: Array[Dictionary] = []
var _pending_loot_items: Array = []
var _pending_loot_gold: int = 0
var _auto_button: Button
var _display: BattleDisplay
var _mp: BattleMultiplayer

signal _player_turn_done
signal _remote_action_received(action: Dictionary)

# Multiplayer state
var _waiting_overlay: WaitingOverlay
var _pending_remote_action: Dictionary = {}

# UI elements -- portrait cards
var _party_cards: Array[PortraitCard] = []
var _enemy_cards: Array[PortraitCard] = []
var _active_card: PortraitCard
var _portrait_cache: Dictionary = {}

# UI elements -- layout
var _scene_image: TextureRect
var _gradient_overlay: TextureRect
var _action_text: RichTextLabel
var _action_menu: ChoiceMenu
var _stats_panel: StatsPanel
var _party_cards_box: HBoxContainer
var _enemy_cards_box: HBoxContainer
var _bottom_panel: VBoxContainer
var _turn_order_label: RichTextLabel
var _turn_queue: Array = []  ## Predicted turn order, depleted as actors act
var _tip_overlay: TipOverlay
var _player_indicator: Label

# Track all fighters (including dead) for card display
var _all_party: Array = []
var _all_enemies: Array = []


func _ready() -> void:
	COMBAT_PAUSE = SettingsManager.combat_pause
	SettingsManager.combat_pause_changed.connect(func(s: float) -> void: COMBAT_PAUSE = s)
	_display = BattleDisplay_C.new(self)
	_mp = BattleMultiplayer_C.new(self)
	_build_ui()
	if NetManager.is_multiplayer_active:
		NetManager.peer_scene_ready.connect(_on_peer_ready_received)
	_start_battle()


func _build_ui() -> void:
	var refs: Dictionary = BattleUIBuilder_C.build(self)
	_scene_image = refs.scene_image
	_gradient_overlay = refs.gradient_overlay
	_action_text = refs.action_text
	_action_menu = refs.action_menu
	_stats_panel = refs.stats_panel
	_party_cards_box = refs.party_cards_box
	_enemy_cards_box = refs.enemy_cards_box
	_bottom_panel = refs.bottom_panel
	_turn_order_label = refs.turn_order_label
	_tip_overlay = refs.tip_overlay
	_waiting_overlay = refs.waiting_overlay
	_player_indicator = refs.player_indicator
	_auto_button = refs.auto_button
	# Connect signals
	_action_menu.choice_selected.connect(_on_action_selected)
	_stats_panel.closed.connect(_on_stats_closed)
	_auto_button.pressed.connect(_on_auto_button_pressed)


func _is_mp_guest() -> bool:
	return NetManager.is_multiplayer_active and not NetManager.is_host


func _start_battle() -> void:
	_engine = BattleEngine.new()
	# Enemy AI scales with party tier: T0=easy, T1=normal, T2=hard
	var _FighterDB := preload("res://scripts/data/fighter_db.gd")
	var max_tier: int = 0
	for f: FighterData in GameState.party:
		max_tier = maxi(max_tier, _FighterDB.get_class_tier(f.class_id))
	_engine.difficulty_level = max_tier
	_engine.combat_message.connect(_on_combat_message)
	_engine.combat_event.connect(_on_combat_event)
	_engine.fighter_died.connect(_on_fighter_died)
	_engine.battle_won.connect(_on_battle_won)
	_engine.battle_lost.connect(_on_battle_lost)

	if NetManager.is_multiplayer_active and NetManager.is_host:
		NetManager.player_left.connect(_on_peer_left_mid_battle)

	var battle: BattleData = GameState.current_battle
	_escape_hp_pct = battle.escape_hp_pct
	_boss_escaped = false
	if not battle.scene_image.is_empty() and ResourceLoader.exists(battle.scene_image):
		_scene_image.texture = load(battle.scene_image)
	if not battle.music_track.is_empty():
		MusicManager.play_music(battle.music_track)
	else:
		MusicManager.play_context(MusicManager.MusicContext.BATTLE)
	_engine.enemy_shared_items = EnemyItemDB.get_battle_items(GameState.current_battle_id)
	_engine.start_battle(GameState.party, battle.enemies)
	for enemy: FighterData in battle.enemies:
		CompendiumManager.record_enemy(enemy, GameState.current_story_id)
	GameLog.info("Battle started: %s (%d enemies)" % [
		GameState.current_battle_id, battle.enemies.size()])

	_auto_battle = false
	var unlock_key: String = GameState.current_story_id + "_complete"
	_auto_battle_unlocked = UnlockManager.is_unlocked(unlock_key)
	_auto_button.visible = _auto_battle_unlocked and not _is_mp_guest()
	_update_auto_button_style()

	_build_portrait_cards()

	_battle_stats.clear()
	for f: FighterData in _all_party:
		_battle_stats[f] = {"damage_dealt": 0, "damage_taken": 0, "healing_done": 0, "kills": 0}
	_add_log("[color=gold]Battle begins![/color]")
	_compute_turn_order()
	_display_turn_order()

	_tip_overlay.show_tip_once("first_battle",
		"Combat uses an Active Time Battle system. " +
		"Faster characters act more often.\n\n" +
		"On your turn, choose Attack for basic damage, " +
		"use an Ability for special moves (costs MP), " +
		"or check Stats to review your party.\n\n" +
		"Some abilities target all enemies or all allies. " +
		"Buffs and debuffs last several turns.")

	_phase = Phase.TICKING_ATB
	if not _is_mp_guest():
		_tick_loop()
	# Guests wait for RPCs from host to drive the battle


func _build_portrait_cards() -> void:
	for card: PortraitCard in _party_cards:
		card.queue_free()
	_party_cards.clear()
	for card: PortraitCard in _enemy_cards:
		card.queue_free()
	_enemy_cards.clear()

	# Snapshot all fighters so we can track dead ones
	_all_party = _engine.units.duplicate()
	_all_enemies = _engine.enemies.duplicate()

	for f: FighterData in _all_party:
		var card := PortraitCard.new()
		_party_cards_box.add_child(card)
		var tex: Texture2D = _get_portrait_texture(f)
		card.setup(f, false, tex)
		_party_cards.append(card)

	for f: FighterData in _all_enemies:
		var card := PortraitCard.new()
		_enemy_cards_box.add_child(card)
		var tex: Texture2D = _get_portrait_texture(f)
		card.setup(f, true, tex)
		_enemy_cards.append(card)


func _refresh_cards() -> void:
	for card: PortraitCard in _party_cards:
		card.update_display(card.get_fighter())
	for card: PortraitCard in _enemy_cards:
		card.update_display(card.get_fighter())


func _add_log(text: String) -> void:
	if _action_text.get_total_character_count() > 0:
		_action_text.append_text("\n")
	_action_text.append_text(text)


func _add_log_separator() -> void:
	_action_text.append_text("\n[color=gray]───────────[/color]")


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
			_highlight_active_card(actor)
			# Pop this actor from the display queue
			if not _turn_queue.is_empty() and _turn_queue[0] == actor:
				_turn_queue.pop_front()
			_display_turn_order()

			_engine.reset_modified_stat(actor)
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
			_add_log_separator()
			var colored_turn: String = "[color=#b3b3b3]%s[/color]" % turn_text
			_add_log(colored_turn)
			# Send turn announcement to guests (bypasses _message_queue to avoid
			# double-display on host, since _add_log already showed it above)
			if NetManager.is_multiplayer_active and NetManager.is_host:
				_rpc_combat_log.rpc("\n[color=gray]───────────[/color]")
				_rpc_combat_log.rpc(colored_turn)

			if actor.is_user_controlled:
				_phase = Phase.PLAYER_ACTION
				var actor_party_idx: int = _all_party.find(actor)
				if _auto_battle and not _is_mp_guest():
					# Auto-battle: use AI logic for player fighter
					_execute_auto_turn()
					await _player_turn_done
					if NetManager.is_multiplayer_active:
						_broadcast_state_sync()
				elif LocalCoop.is_active:
					# Local co-op: gate input to the owning player
					var owner: int = LocalCoop.get_player_for_slot(actor_party_idx)
					LocalCoop.set_active_player(owner)
					_player_indicator.text = "%s's turn" % LocalCoop.get_player_name(owner)
					_player_indicator.visible = true
					_show_action_menu(actor)
					await _player_turn_done
					LocalCoop.clear_active_player()
					_player_indicator.visible = false
				elif NetManager.is_multiplayer_active and not NetManager.is_my_fighter(actor_party_idx):
					# Remote player's turn -- request their action via RPC
					var owner_peer: int = NetManager.get_fighter_owner_peer(actor_party_idx)
					var owner_name: String = NetManager.get_fighter_owner_name(actor_party_idx)
					_waiting_overlay.show_waiting(owner_name)
					_rpc_request_action.rpc_id(owner_peer, actor_party_idx)
					NetManager.start_turn_timeout()
					var action: Dictionary = await _remote_action_received
					NetManager.stop_turn_timeout()
					_waiting_overlay.hide_waiting()
					_execute_remote_action(actor, action)
					_broadcast_state_sync()
				else:
					_show_action_menu(actor)
					await _player_turn_done
					if NetManager.is_multiplayer_active:
						_broadcast_state_sync()
			else:
				# AI turn -- brief pause so player can read the turn announcement
				_phase = Phase.AI_ACTING
				await get_tree().create_timer(COMBAT_PAUSE * 0.5, false).timeout
				var is_party: bool = _engine.units.has(actor)
				var targets: Array = _engine.enemies if is_party else _engine.units
				var allies: Array = _engine.units if is_party else _engine.enemies
				_engine.execute_ai_turn(actor, targets, allies)
				if NetManager.is_multiplayer_active:
					_broadcast_state_sync()

			# Post-action (same for player and AI)
			_engine.check_for_death()
			_rebuild_cards_if_needed()
			await _drain_messages()
			_refresh_cards()

			# Check boss escape before death, escape triggers at HP threshold
			if _check_boss_escape():
				_end_battle()
				return

			await _drain_messages()

			if _engine.is_battle_over():
				_end_battle()
				return

			_phase = Phase.TICKING_ATB

		_engine.reset_turns()
		_compute_turn_order()
		_display_turn_order()


func _is_ability_available(fighter: FighterData, ability: AbilityData) -> bool:
	return ability.mana_cost <= fighter.mana


# =============================================================================
# Auto-battle
# =============================================================================

func _update_auto_button_style() -> void:
	if _auto_battle:
		_auto_button.add_theme_color_override("font_color", Color(0.9, 0.8, 0.5))
		_auto_button.modulate.a = 1.0
	else:
		_auto_button.add_theme_color_override("font_color", Color(0.6, 0.55, 0.35))
		_auto_button.modulate.a = 0.45


func _execute_auto_turn() -> void:
	# Reuse engine AI logic for player fighter
	var targets: Array = _engine.enemies
	var allies: Array = _engine.units
	_engine.execute_ai_turn(_current_actor, targets, allies)
	_player_turn_done.emit.call_deferred()


func _on_auto_button_pressed() -> void:
	if _phase == Phase.BATTLE_END or _is_mp_guest():
		return
	_auto_battle = not _auto_battle
	_update_auto_button_style()
	SFXManager.play(SFXManager.Category.UI_CONFIRM, 0.3)
	if _auto_battle:
		_tip_overlay.show_tip_once("auto_battle",
			"Auto-battle lets the AI choose actions for your party. " +
			"Press any button or click AUTO to take back control.\n\n" +
			"Auto-battle speeds up combat but may not always make " +
			"the best strategic choices.")
		if _phase == Phase.PLAYER_ACTION and _action_menu.visible:
			_action_menu.hide_menu()
			_execute_auto_turn()


func _input(event: InputEvent) -> void:
	if _summary_waiting:
		if event.is_action_pressed("confirm") or (event is InputEventMouseButton and event.pressed):
			_summary_waiting = false
			get_viewport().set_input_as_handled()
			return
	if _loot_waiting:
		if event.is_action_pressed("confirm") or (event is InputEventMouseButton and event.pressed):
			_loot_waiting = false
			get_viewport().set_input_as_handled()
			return
	if _auto_battle and (event.is_action_pressed("confirm") or event.is_action_pressed("cancel")):
		_auto_battle = false
		_update_auto_button_style()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("cancel"):
		_handle_cancel()


func _handle_cancel() -> void:
	match _phase:
		Phase.PLAYER_ACTIONS_SUBMENU:
			# Back to main action menu
			if _action_menu.choice_selected.is_connected(_on_actions_submenu_selected):
				_action_menu.choice_selected.disconnect(_on_actions_submenu_selected)
			if not _action_menu.choice_selected.is_connected(_on_action_selected):
				_action_menu.choice_selected.connect(_on_action_selected)
			_action_menu.hide_menu()
			_phase = Phase.PLAYER_ACTION
			_show_action_menu(_current_actor)
			get_viewport().set_input_as_handled()
		Phase.PLAYER_TARGET_ATTACK:
			# Back to actions submenu
			if _action_menu.choice_selected.is_connected(_on_target_selected):
				_action_menu.choice_selected.disconnect(_on_target_selected)
			if not _action_menu.choice_selected.is_connected(_on_action_selected):
				_action_menu.choice_selected.connect(_on_action_selected)
			_action_menu.hide_menu()
			_phase = Phase.PLAYER_ACTIONS_SUBMENU
			_show_actions_submenu()
			get_viewport().set_input_as_handled()
		Phase.PLAYER_ABILITY_SELECT:
			# Back to main action menu
			if _action_menu.choice_selected.is_connected(_on_ability_selected):
				_action_menu.choice_selected.disconnect(_on_ability_selected)
			if not _action_menu.choice_selected.is_connected(_on_action_selected):
				_action_menu.choice_selected.connect(_on_action_selected)
			_action_menu.hide_menu()
			_phase = Phase.PLAYER_ACTION
			_show_action_menu(_current_actor)
			get_viewport().set_input_as_handled()
		Phase.PLAYER_ABILITY_TARGET_ENEMY, Phase.PLAYER_ABILITY_TARGET_ALLY:
			# Back to ability list
			if _action_menu.choice_selected.is_connected(_on_target_selected):
				_action_menu.choice_selected.disconnect(_on_target_selected)
			if not _action_menu.choice_selected.is_connected(_on_action_selected):
				_action_menu.choice_selected.connect(_on_action_selected)
			_action_menu.hide_menu()
			_phase = Phase.PLAYER_ABILITY_SELECT
			_show_ability_menu()
			get_viewport().set_input_as_handled()
		Phase.STATS_PICK:
			# Back to main action menu
			if _action_menu.choice_selected.is_connected(_on_stats_pick_selected):
				_action_menu.choice_selected.disconnect(_on_stats_pick_selected)
			if not _action_menu.choice_selected.is_connected(_on_action_selected):
				_action_menu.choice_selected.connect(_on_action_selected)
			_action_menu.hide_menu()
			_phase = Phase.PLAYER_ACTION
			_show_action_menu(_current_actor)
			get_viewport().set_input_as_handled()
		Phase.PLAYER_ITEM_SELECT:
			if _action_menu.choice_selected.is_connected(_on_item_selected):
				_action_menu.choice_selected.disconnect(_on_item_selected)
			if not _action_menu.choice_selected.is_connected(_on_action_selected):
				_action_menu.choice_selected.connect(_on_action_selected)
			_action_menu.hide_menu()
			_phase = Phase.PLAYER_ACTION
			_show_action_menu(_current_actor)
			get_viewport().set_input_as_handled()
		Phase.PLAYER_ITEM_TARGET:
			if _action_menu.choice_selected.is_connected(_on_item_target_selected):
				_action_menu.choice_selected.disconnect(_on_item_target_selected)
			if not _action_menu.choice_selected.is_connected(_on_action_selected):
				_action_menu.choice_selected.connect(_on_action_selected)
			_action_menu.hide_menu()
			_phase = Phase.PLAYER_ITEM_SELECT
			_show_item_menu()
			get_viewport().set_input_as_handled()
		Phase.PLAYER_ULTIMATE_TARGET_ENEMY, Phase.PLAYER_ULTIMATE_TARGET_ALLY:
			# Back to main action menu
			if _action_menu.choice_selected.is_connected(_on_target_selected):
				_action_menu.choice_selected.disconnect(_on_target_selected)
			if not _action_menu.choice_selected.is_connected(_on_action_selected):
				_action_menu.choice_selected.connect(_on_action_selected)
			_action_menu.hide_menu()
			_phase = Phase.PLAYER_ACTION
			_show_action_menu(_current_actor)
			get_viewport().set_input_as_handled()
		Phase.SHOWING_STATS:
			_stats_panel.visible = false
			_phase = Phase.STATS_PICK
			_show_stats_pick()
			get_viewport().set_input_as_handled()


# =============================================================================
# Player action handling
# =============================================================================

func _show_action_menu(actor: FighterData) -> void:
	var has_available: bool = false
	for a: AbilityData in actor.abilities:
		if _is_ability_available(actor, a):
			has_available = true
			break

	var options: Array[Dictionary] = [{"label": "Actions"}]
	options.append({"label": "Ability", "disabled": not has_available})
	options.append({"label": "Item", "disabled": GameState.inventory.size() == 0})
	options.append({"label": "Stats"})
	# Slot 4: Ultimate (shows charge %)
	var has_ult: bool = actor.ultimate != null
	var ult_ready: bool = has_ult and actor.ultimate_charge >= actor.ultimate.charge_cost
	if has_ult:
		var pct: int = mini(int(float(actor.ultimate_charge) / float(actor.ultimate.charge_cost) * 100), 100)
		options.append({"label": "Ultimate (%d%%)" % pct, "disabled": not ult_ready})
		if ult_ready:
			_tip_overlay.show_tip_once("ultimate_ready",
				"Your ultimate ability is fully charged! Select Ultimate " +
				"to unleash a powerful finishing move.\n\n" +
				"Ultimates charge through basic actions: Attack, Block, " +
				"and Rest. Charge carries over partially between battles.")
	else:
		options.append({"label": "", "disabled": true})
	options.append({"label": "Auto", "disabled": not _auto_battle_unlocked})
	_action_menu.show_choices(options, true)
	_tip_overlay.show_tip_once("combat_actions",
		"Attack, Block, and Rest all restore MP based on your Magic Attack.\n\n" +
		"Attack deals damage. Block raises defenses for one turn. " +
		"Rest restores double MP and a little HP, but leaves you exposed.\n\n" +
		"Use basic actions to recharge between abilities.")


func _on_action_selected(index: int) -> void:
	_action_menu.hide_menu()

	# Fixed layout: Actions(0), Ability(1), Item(2), Stats(3), Ultimate(4), Auto(5)
	match index:
		0: # Actions
			_phase = Phase.PLAYER_ACTIONS_SUBMENU
			_show_actions_submenu()
		1: # Ability
			_phase = Phase.PLAYER_ABILITY_SELECT
			_show_ability_menu()
		2: # Item
			_phase = Phase.PLAYER_ITEM_SELECT
			_show_item_menu()
		3: # Stats
			_phase = Phase.STATS_PICK
			_show_stats_pick()
		4: # Ultimate
			_start_ultimate_targeting()
		5: # Auto
			_auto_battle = true
			_update_auto_button_style()
			_tip_overlay.show_tip_once("auto_battle",
				"Auto-battle lets the AI choose actions for your party. " +
				"Press any button or click AUTO to take back control.\n\n" +
				"Auto-battle speeds up combat but may not always make " +
				"the best strategic choices.")
			_execute_auto_turn()


func _start_ultimate_targeting() -> void:
	var ult: RefCounted = _current_actor.ultimate
	if ult == null:
		return
	var abil: AbilityData = ult.ability
	if abil.target_all:
		# AoE ultimate: execute immediately, no target selection
		if _is_mp_guest():
			_rpc_submit_action.rpc_id(1, {"type": "ultimate", "target_index": 0})
			_player_turn_done.emit()
			return
		_engine.use_ultimate(_current_actor, null)
		_player_turn_done.emit()
	elif abil.use_on_enemy:
		_phase = Phase.PLAYER_ULTIMATE_TARGET_ENEMY
		_show_target_menu(_engine.enemies)
	else:
		_phase = Phase.PLAYER_ULTIMATE_TARGET_ALLY
		_show_target_menu(_engine.units)


func _show_actions_submenu() -> void:
	var options: Array[Dictionary] = [
		{"label": "Attack"}, {"label": "Block"},
		{"label": "Rest"}, {"label": "Back"},
	]
	_action_menu.choice_selected.disconnect(_on_action_selected)
	_action_menu.choice_selected.connect(_on_actions_submenu_selected)
	_action_menu.show_choices(options, true)


func _on_actions_submenu_selected(index: int) -> void:
	_action_menu.hide_menu()
	_action_menu.choice_selected.disconnect(_on_actions_submenu_selected)
	_action_menu.choice_selected.connect(_on_action_selected)

	var labels: Array[String] = ["Attack", "Block", "Rest", "Back"]
	var action: String = labels[index] if index < labels.size() else "Back"

	match action:
		"Attack":
			_phase = Phase.PLAYER_TARGET_ATTACK
			_show_target_menu(_engine.enemies)
		"Block":
			if _is_mp_guest():
				_rpc_submit_action.rpc_id(1, {"type": "block"})
				_player_turn_done.emit()
				return
			_engine.perform_block(_current_actor)
			_player_turn_done.emit()
		"Rest":
			if _is_mp_guest():
				_rpc_submit_action.rpc_id(1, {"type": "rest"})
				_player_turn_done.emit()
				return
			_engine.perform_rest(_current_actor)
			_player_turn_done.emit()
		"Back":
			_phase = Phase.PLAYER_ACTION
			_show_action_menu(_current_actor)


func _show_target_menu(fighters: Array) -> void:
	var options: Array[Dictionary] = []
	for f: FighterData in fighters:
		options.append({
			"label": f.character_name,
			"description": "%s  |  HP: %d/%d" % [f.character_type, f.health, f.max_health],
		})
	options.append({"label": "Back"})
	_action_menu.show_choices(options, true)
	_action_menu.choice_selected.disconnect(_on_action_selected)
	_action_menu.choice_selected.connect(_on_target_selected)


func _on_target_selected(index: int) -> void:
	# Check for Back option
	var fighter_count: int
	match _phase:
		Phase.PLAYER_TARGET_ATTACK, Phase.PLAYER_ABILITY_TARGET_ENEMY, \
		Phase.PLAYER_ULTIMATE_TARGET_ENEMY:
			fighter_count = _engine.enemies.size()
		Phase.PLAYER_ABILITY_TARGET_ALLY, Phase.PLAYER_ULTIMATE_TARGET_ALLY:
			fighter_count = _engine.units.size()
		_:
			fighter_count = 0

	if index >= fighter_count:
		# Back: return to appropriate menu
		_action_menu.choice_selected.disconnect(_on_target_selected)
		_action_menu.choice_selected.connect(_on_action_selected)
		_action_menu.hide_menu()
		if _phase == Phase.PLAYER_TARGET_ATTACK:
			_phase = Phase.PLAYER_ACTIONS_SUBMENU
			_show_actions_submenu()
		elif _phase == Phase.PLAYER_ULTIMATE_TARGET_ENEMY or \
				_phase == Phase.PLAYER_ULTIMATE_TARGET_ALLY:
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

	if _is_mp_guest():
		# Guest: send action to host instead of executing locally
		var action: Dictionary = {}
		match _phase:
			Phase.PLAYER_TARGET_ATTACK:
				action = {"type": "attack", "target_index": index}
			Phase.PLAYER_ABILITY_TARGET_ENEMY:
				action = {"type": "ability_enemy", "ability_name": _selected_ability.ability_name, "target_index": index}
			Phase.PLAYER_ABILITY_TARGET_ALLY:
				action = {"type": "ability_ally", "ability_name": _selected_ability.ability_name, "target_index": index}
			Phase.PLAYER_ULTIMATE_TARGET_ENEMY, Phase.PLAYER_ULTIMATE_TARGET_ALLY:
				action = {"type": "ultimate", "target_index": index}
		_rpc_submit_action.rpc_id(1, action)
		_player_turn_done.emit()
		return

	match _phase:
		Phase.PLAYER_TARGET_ATTACK:
			var taunter: FighterData = _engine.get_taunt_target(_engine.enemies)
			var target: FighterData
			if taunter:
				target = taunter
				_add_log("%s has taunted your attention!" % taunter.character_name)
			else:
				target = _engine.enemies[index]
			_engine.physical_attack(_current_actor, target)
		Phase.PLAYER_ABILITY_TARGET_ENEMY:
			var taunter: FighterData = _engine.get_taunt_target(_engine.enemies)
			var target: FighterData
			if taunter:
				target = taunter
				_add_log("%s has taunted your attention!" % taunter.character_name)
			else:
				target = _engine.enemies[index]
			_current_actor.mana -= _selected_ability.mana_cost
			_engine.use_ability_on_enemy(_current_actor, target, _selected_ability)
		Phase.PLAYER_ABILITY_TARGET_ALLY:
			_current_actor.mana -= _selected_ability.mana_cost
			_engine.use_ability_on_teammate(
				_current_actor, _engine.units[index], _selected_ability)
		Phase.PLAYER_ULTIMATE_TARGET_ENEMY:
			var taunter: FighterData = _engine.get_taunt_target(_engine.enemies)
			var ult_target: FighterData
			if taunter:
				ult_target = taunter
				_add_log("%s has taunted your attention!" % taunter.character_name)
			else:
				ult_target = _engine.enemies[index]
			_engine.use_ultimate(_current_actor, ult_target)
		Phase.PLAYER_ULTIMATE_TARGET_ALLY:
			_engine.use_ultimate(_current_actor, _engine.units[index])

	_player_turn_done.emit()


func _show_ability_menu() -> void:
	var available: Array[AbilityData] = []
	for a: AbilityData in _current_actor.abilities:
		if _is_ability_available(_current_actor, a):
			available.append(a)

	var options: Array[Dictionary] = []
	for a: AbilityData in available:
		var label: String = "%s (%d MP)" % [a.ability_name, a.mana_cost]
		options.append({"label": label, "description": a.get_description()})
	options.append({"label": "Back"})

	_action_menu.show_choices(options, true)
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
		if _is_mp_guest():
			# Guest: send AoE action to host
			var action_type: String = "ability_enemy" if _selected_ability.use_on_enemy else "ability_ally"
			_rpc_submit_action.rpc_id(1, {
				"type": action_type,
				"ability_name": _selected_ability.ability_name,
				"target_index": 0,
			})
			_player_turn_done.emit()
			return

		# AoE, no target selection needed
		_current_actor.mana -= _selected_ability.mana_cost
		if _selected_ability.use_on_enemy:
			_add_log("%s targets all enemies!" % _current_actor.character_name)
			var _aoe_targets: int = _engine.enemies.size()
			for enemy: FighterData in _engine.enemies.duplicate():
				_engine.use_ability_on_enemy(_current_actor, enemy, _selected_ability, true, _aoe_targets)
		else:
			_add_log("%s targets all allies!" % _current_actor.character_name)
			for ally: FighterData in _engine.units.duplicate():
				_engine.use_ability_on_teammate(_current_actor, ally, _selected_ability, true)

		_player_turn_done.emit()
	elif _selected_ability.use_on_enemy:
		_phase = Phase.PLAYER_ABILITY_TARGET_ENEMY
		_show_target_menu(_engine.enemies)
	else:
		_phase = Phase.PLAYER_ABILITY_TARGET_ALLY
		_show_target_menu(_engine.units)


# =============================================================================
# Item usage
# =============================================================================

func _show_item_menu() -> void:
	var items: Array = GameState.inventory.get_items()
	var options: Array[Dictionary] = []
	for item: ItemData in items:
		options.append({"label": item.item_name, "description": item.get_use_description()})
	# Pad to 5 slots so the grid never resizes when items are consumed
	while options.size() < 5:
		options.append({"label": "", "disabled": true})
	options.append({"label": "Back"})

	_action_menu.show_choices(options, true)
	_action_menu.choice_selected.disconnect(_on_action_selected)
	_action_menu.choice_selected.connect(_on_item_selected)
	_tip_overlay.show_tip_once("first_item_use",
		"Items are consumable and don't cost MP. Using an item takes your turn.\n\n" +
		"You can find items as loot after battles or buy them at town shops.")


func _on_item_selected(index: int) -> void:
	var items: Array = GameState.inventory.get_items()
	if index >= items.size():
		# Back
		_action_menu.choice_selected.disconnect(_on_item_selected)
		_action_menu.choice_selected.connect(_on_action_selected)
		_action_menu.hide_menu()
		_phase = Phase.PLAYER_ACTION
		_show_action_menu(_current_actor)
		return

	_action_menu.choice_selected.disconnect(_on_item_selected)
	_action_menu.choice_selected.connect(_on_action_selected)
	_action_menu.hide_menu()

	_selected_item = items[index]

	if _selected_item.target_all:
		# AoE item, no target selection needed
		if _is_mp_guest():
			_rpc_submit_action.rpc_id(1, {"type": "item", "item_index": index, "target_index": 0})
			_player_turn_done.emit()
			return
		GameState.inventory.use_item(index)
		_engine.use_item(_current_actor, _current_actor, _selected_item)
		_engine.check_for_death()
		_player_turn_done.emit()
	elif _selected_item.target_ally:
		_phase = Phase.PLAYER_ITEM_TARGET
		_show_item_target_menu(_engine.units)
	else:
		_phase = Phase.PLAYER_ITEM_TARGET
		_show_item_target_menu(_engine.enemies)


func _show_item_target_menu(fighters: Array) -> void:
	var options: Array[Dictionary] = []
	for f: FighterData in fighters:
		options.append({
			"label": f.character_name,
			"description": "%s  |  HP: %d/%d" % [f.character_type, f.health, f.max_health],
		})
	options.append({"label": "Back"})
	_action_menu.show_choices(options, true)
	if not _action_menu.choice_selected.is_connected(_on_item_target_selected):
		_action_menu.choice_selected.connect(_on_item_target_selected)


func _on_item_target_selected(index: int) -> void:
	var fighters: Array = _engine.units if _selected_item.target_ally else _engine.enemies
	if index >= fighters.size():
		# Back to item list
		_action_menu.choice_selected.disconnect(_on_item_target_selected)
		_action_menu.choice_selected.connect(_on_action_selected)
		_action_menu.hide_menu()
		_phase = Phase.PLAYER_ITEM_SELECT
		_show_item_menu()
		return

	_action_menu.choice_selected.disconnect(_on_item_target_selected)
	_action_menu.choice_selected.connect(_on_action_selected)
	_action_menu.hide_menu()

	if _is_mp_guest():
		var item_idx: int = GameState.inventory.get_items().find(_selected_item)
		_rpc_submit_action.rpc_id(1, {"type": "item", "item_index": item_idx, "target_index": index})
		_player_turn_done.emit()
		return

	var item_idx: int = GameState.inventory.get_items().find(_selected_item)
	var target: FighterData = fighters[index]
	GameState.inventory.use_item(item_idx)
	_engine.use_item(_current_actor, target, _selected_item)
	_engine.check_for_death()
	_player_turn_done.emit()


# =============================================================================
# Stats viewing
# =============================================================================

func _show_stats_pick() -> void:
	var options: Array[Dictionary] = []
	for f: FighterData in _engine.units:
		options.append({
			"label": f.character_name,
			"description": f.character_type,
		})
	options.append({"label": "Back"})

	_action_menu.show_choices(options, true)
	if _action_menu.choice_selected.is_connected(_on_action_selected):
		_action_menu.choice_selected.disconnect(_on_action_selected)
	if not _action_menu.choice_selected.is_connected(_on_stats_pick_selected):
		_action_menu.choice_selected.connect(_on_stats_pick_selected)


func _on_stats_pick_selected(index: int) -> void:
	if index >= _engine.units.size():
		# Back
		_action_menu.choice_selected.disconnect(_on_stats_pick_selected)
		_action_menu.choice_selected.connect(_on_action_selected)
		_action_menu.hide_menu()
		_phase = Phase.PLAYER_ACTION
		_show_action_menu(_current_actor)
		return

	_action_menu.hide_menu()
	var fighter: FighterData = _engine.units[index]

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


func _on_combat_event(target: FighterData, amount: int, event_type: String) -> void:
	_display.on_combat_event(target, amount, event_type)
	if NetManager.is_multiplayer_active and NetManager.is_host:
		var idx: int = _all_enemies.find(target)
		var is_enemy: bool = idx >= 0
		if not is_enemy:
			idx = _all_party.find(target)
		if idx >= 0:
			_combat_event_queue.append({
				"idx": idx, "is_enemy": is_enemy,
				"amount": amount, "type": event_type
			})


func _find_card_for_fighter(fighter: FighterData) -> PortraitCard:
	return _display.find_card_for_fighter(fighter)


func _drain_messages() -> void:
	var pause: float = COMBAT_PAUSE * 0.3 if _auto_battle else COMBAT_PAUSE
	while not _message_queue.is_empty():
		var msg: String = _message_queue.pop_front()
		_add_log(msg)
		_refresh_cards()
		# Extra hit pause after crits for impact feel
		if _display.had_crit and not SettingsManager.reduced_motion:
			_display.had_crit = false
			await get_tree().create_timer(0.08, false).timeout
		await get_tree().create_timer(pause, false).timeout
	_refresh_cards()


# =============================================================================
# Battle end
# =============================================================================

func _check_boss_escape() -> bool:
	if _escape_hp_pct <= 0.0:
		return false
	for enemy: FighterData in _engine.enemies:
		if enemy.health > 0 and float(enemy.health) / float(enemy.max_health) <= _escape_hp_pct:
			_boss_escaped = true
			_add_log("[color=yellow]%s staggers back, then vanishes in a flash of dark energy![/color]" % enemy.character_name)
			return true
	return false


func _end_battle() -> void:
	_phase = Phase.BATTLE_END
	_highlight_active_card(null)
	await _drain_messages()

	_engine.finish_battle()

	var won: bool = _boss_escaped or _engine.did_player_win()

	# Roll loot drops (host / single-player only)
	var loot_items: Array = []
	var loot_gold: int = 0
	if won:
		var loot: Dictionary = LootRoller.roll_drops(_all_enemies, GameState.current_story_id)
		loot_items = loot.items
		loot_gold = loot.gold

	# Broadcast battle end to guests (include loot in same RPC to avoid race)
	if NetManager.is_multiplayer_active and NetManager.is_host:
		_broadcast_state_sync()
		var stats_data: Array = _serialize_battle_stats()
		var item_ids: Array = []
		for item: ItemData in loot_items:
			item_ids.append(item.item_id)
		_rpc_battle_ended.rpc(won, stats_data, item_ids, loot_gold)

	if won:
		GameLog.info("Battle won: %s" % GameState.current_battle_id)
		if _boss_escaped:
			_add_log("[color=gold]The enemy has fled! Victory is yours... for now.[/color]")
		else:
			_add_log("[color=gold]Victory! The enemies have been vanquished.[/color]")
		SFXManager.play(SFXManager.Category.UI_FANFARE)
		_display.show_victory_flash()
		await get_tree().create_timer(2.0, false).timeout
		await _show_battle_summary()
		if loot_items.size() > 0 or loot_gold > 0:
			if NetManager.is_multiplayer_active:
				_pre_open_loot_gate()
			GameState.inventory.add_gold(loot_gold)
			await _display.show_loot_drops(loot_items, loot_gold)
			if NetManager.is_multiplayer_active:
				await _wait_loot_ready()
		GameState.advance_to_post_battle()
		if NetManager.is_multiplayer_active and NetManager.is_host:
			NetManager.change_scene_for_peers("res://scenes/narrative/narrative.tscn")
		SceneManager.change_scene("res://scenes/narrative/narrative.tscn", 0.4, true)
	else:
		GameLog.info("Battle lost: %s" % GameState.current_battle_id)
		_add_log("[color=red]The party has been defeated...[/color]")
		_display.show_defeat_effect()
		await get_tree().create_timer(2.5, false).timeout
		GameState.go_to_ending(false)
		if NetManager.is_multiplayer_active and NetManager.is_host:
			NetManager.change_scene_for_peers("res://scenes/narrative/narrative.tscn")
		SceneManager.change_scene("res://scenes/narrative/narrative.tscn")


func _show_battle_summary() -> void:
	if NetManager.is_multiplayer_active:
		_pre_open_summary_gate()
	await _display.show_battle_summary()
	if NetManager.is_multiplayer_active:
		await _wait_summary_ready()
		_summary_phase_done = true


## Pre-open the summary ready gate so signals arriving while the summary
## is displayed are captured immediately (not buffered then drained).
func _pre_open_summary_gate() -> void:
	var gate := ReadyGate.new()
	gate.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	gate.offset_top = -40
	gate.offset_bottom = -10
	add_child(gate)
	_summary_gate = gate
	gate.start_online(NetManager.get_connected_peer_count())
	# Apply any ready signals that arrived before the gate existed
	for idx: int in _pending_summary_ready:
		gate.mark_ready(idx)
	_pending_summary_ready.clear()
	GameLog.info("Summary gate: pre-opened (peer_count=%d)" % NetManager.get_connected_peer_count())


## Mark self ready and (host only) wait for all peers.
## Guests return immediately — host sends change_scene_for_peers.
func _wait_summary_ready() -> void:
	# Gate was already pre-opened in _pre_open_summary_gate
	var my_idx: int = NetManager.get_my_peer_index()
	_summary_gate.mark_ready(my_idx)
	NetManager.notify_scene_ready(my_idx)
	GameLog.info("Summary gate: marked self ready (idx=%d, is_host=%s)" % [my_idx, NetManager.is_host])
	if not NetManager.is_host:
		var g: ReadyGate = _summary_gate
		_summary_gate = null
		g.queue_free()
		return
	# If all players were already ready, gate hid itself — skip await
	if not _summary_gate.visible:
		GameLog.info("Summary gate: all ready immediately (host)")
		var g: ReadyGate = _summary_gate
		_summary_gate = null
		g.queue_free()
		return
	GameLog.info("Summary gate: host waiting for peers")
	await _summary_gate.all_ready
	GameLog.info("Summary gate: all ready (host)")
	var g2: ReadyGate = _summary_gate
	_summary_gate = null
	g2.queue_free()


func _on_peer_ready_received(player_index: int) -> void:
	if _loot_gate:
		_loot_gate.mark_ready(player_index)
	elif _summary_gate:
		_summary_gate.mark_ready(player_index)
	elif _summary_phase_done:
		if player_index not in _pending_loot_ready:
			_pending_loot_ready.append(player_index)
	else:
		if player_index not in _pending_summary_ready:
			_pending_summary_ready.append(player_index)


func _pre_open_loot_gate() -> void:
	var gate := ReadyGate.new()
	gate.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	gate.offset_top = -40
	gate.offset_bottom = -10
	add_child(gate)
	_loot_gate = gate
	gate.start_online(NetManager.get_connected_peer_count())
	for idx: int in _pending_loot_ready:
		gate.mark_ready(idx)
	_pending_loot_ready.clear()


func _wait_loot_ready() -> void:
	var my_idx: int = NetManager.get_my_peer_index()
	_loot_gate.mark_ready(my_idx)
	NetManager.notify_scene_ready(my_idx)
	if not NetManager.is_host:
		var g: ReadyGate = _loot_gate
		_loot_gate = null
		g.queue_free()
		return
	if not _loot_gate.visible:
		var g: ReadyGate = _loot_gate
		_loot_gate = null
		g.queue_free()
		return
	await _loot_gate.all_ready
	var g2: ReadyGate = _loot_gate
	_loot_gate = null
	g2.queue_free()


func _on_fighter_died(fighter: FighterData) -> void:
	_display.on_fighter_died(fighter)


func _on_battle_won() -> void:
	pass  # Handled in _end_battle


func _on_battle_lost() -> void:
	pass  # Handled in _end_battle


func _rebuild_cards_if_needed() -> void:
	_display.rebuild_cards_if_needed()


func _compute_turn_order() -> void:
	_display.compute_turn_order()


func _display_turn_order() -> void:
	_display.display_turn_order()


# =============================================================================
# Portrait cards
# =============================================================================

func _get_portrait_texture(fighter: FighterData) -> Texture2D:
	return _display.get_portrait_texture(fighter)


func _highlight_active_card(fighter: FighterData) -> void:
	_display.highlight_active_card(fighter)


func _build_turn_order_text() -> String:
	var parts: Array[String] = []
	if _current_actor != null:
		parts.append("[color=lime]%s[/color]" % _current_actor.character_name)
	for f: FighterData in _turn_queue:
		if _engine.units.has(f):
			parts.append("[color=cyan]%s[/color]" % f.character_name)
		else:
			parts.append("[color=salmon]%s[/color]" % f.character_name)
	return "[color=gray]Turn Order:[/color]  " + "  >  ".join(parts)


# =============================================================================
# Multiplayer RPCs (logic delegated to battle_multiplayer.gd)
# =============================================================================

func _execute_remote_action(actor: FighterData, action: Dictionary) -> void:
	_mp.execute_remote_action(actor, action)

func _find_ability(actor: FighterData, ability_name: String) -> AbilityData:
	return _mp.find_ability(actor, ability_name)

func _broadcast_state_sync() -> void:
	_mp.broadcast_state_sync()

@rpc("authority", "call_remote", "reliable")
func _rpc_state_sync(party_state: Array, enemy_state: Array, alive_party: Array,
		alive_enemies: Array, log_lines: Array, combat_events: Array = [],
		active_idx: int = -1, active_is_enemy: bool = false, turn_text: String = "") -> void:
	_mp.handle_state_sync(party_state, enemy_state, alive_party, alive_enemies,
		log_lines, combat_events, active_idx, active_is_enemy, turn_text)

@rpc("authority", "call_remote", "reliable")
func _rpc_request_action(actor_party_idx: int) -> void:
	_mp.handle_request_action(actor_party_idx)

@rpc("any_peer", "call_remote", "reliable")
func _rpc_submit_action(action: Dictionary) -> void:
	_mp.handle_submit_action(action)

@rpc("authority", "call_remote", "reliable")
func _rpc_battle_ended(won: bool, stats_data: Array = [], item_ids: Array = [], loot_gold: int = 0) -> void:
	_mp.handle_loot_dropped(item_ids, loot_gold)
	_mp.handle_battle_ended(won, stats_data)


func _serialize_battle_stats() -> Array:
	var result: Array = []
	for i: int in _all_party.size():
		var f: FighterData = _all_party[i]
		var s: Dictionary = _battle_stats.get(f, {})
		result.append({
			"index": i,
			"damage_dealt": s.get("damage_dealt", 0),
			"damage_taken": s.get("damage_taken", 0),
			"healing_done": s.get("healing_done", 0),
			"kills": s.get("kills", 0),
		})
	return result

@rpc("authority", "call_remote", "reliable")
func _rpc_combat_log(text: String) -> void:
	_mp.handle_combat_log(text)

func _on_peer_left_mid_battle(peer_id: int, player_name: String) -> void:
	_mp.on_peer_left_mid_battle(peer_id, player_name)
