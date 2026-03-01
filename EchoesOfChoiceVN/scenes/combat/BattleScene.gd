extends Control

const PortraitCardScene = preload("res://scenes/combat/PortraitCard.tscn")
const _BattleConfig = preload("res://scripts/data/battle_config.gd")
const _BattleUnit = preload("res://scripts/combat/battle_unit.gd")
const _AbilityExecutor = preload("res://scripts/combat/ability_executor.gd")
const _BattleAI = preload("res://scripts/combat/battle_ai.gd")
const _Combat = preload("res://scripts/combat/combat.gd")
const _ModifiedStat = preload("res://scripts/data/modified_stat.gd")

const TURN_THRESHOLD := 100.0

@onready var _enemy_row: HBoxContainer = %EnemyRow
@onready var _player_row: HBoxContainer = %PlayerRow
@onready var _action_menu: Control = %ActionMenu
@onready var _turn_label: Label = %TurnLabel
@onready var _battle_name_label: Label = %BattleName

var _player_units: Array = []
var _enemy_units: Array = []
var _all_units: Array = []
var _battle_active: bool = false
var _cards: Dictionary = {}  # BattleUnit -> PortraitCard node
var _config: Dictionary = {}

var _selected_target = null
signal _target_selected


func _ready() -> void:
	_config = _BattleConfig.load_config(GameState.current_battle_id)
	_battle_name_label.text = _config.get("name", "Battle")
	var music_ctx: int = _config.get("music", MusicManager.MusicContext.BATTLE)
	MusicManager.play_context(music_ctx)
	_spawn_player_units()
	_spawn_enemy_units()
	_all_units = _player_units.duplicate()
	_all_units.append_array(_enemy_units)
	_run_battle()


func _spawn_player_units() -> void:
	var player_data: FighterData = _BattleConfig.load_class(GameState.player_class_id)
	if not player_data:
		push_error("BattleScene: Could not load player class '%s'" % GameState.player_class_id)
		return
	var pu := _BattleUnit.from_fighter_data(
		player_data, GameState.player_name, GameState.player_level, Enums.Team.PLAYER)
	pu.xp = GameState.player_xp
	pu.jp = GameState.player_jp
	_player_units.append(pu)
	_create_card(pu, _player_row)

	for member in GameState.party_members:
		var data: FighterData = _BattleConfig.load_class(member.get("class_id", ""))
		if not data:
			continue
		var unit := _BattleUnit.from_fighter_data(
			data, member["name"], member.get("level", 1), Enums.Team.PLAYER)
		unit.xp = member.get("xp", 0)
		unit.jp = member.get("jp", 0)
		var tracked := GameState.get_tracked_hp_mp(member["name"])
		if tracked["hp"] >= 0:
			unit.health = mini(tracked["hp"], unit.max_health)
		if tracked["mp"] >= 0:
			unit.mana = mini(tracked["mp"], unit.max_mana)
		_player_units.append(unit)
		_create_card(unit, _player_row)


func _spawn_enemy_units() -> void:
	for enemy_def in _config.get("enemies", []):
		var data: FighterData = _BattleConfig.load_enemy(enemy_def["id"])
		if not data:
			push_error("BattleScene: Could not load enemy '%s'" % enemy_def["id"])
			continue
		var display_name := data.class_display_name
		var count := 0
		for existing in _enemy_units:
			if existing.class_id == data.class_id:
				count += 1
		if count > 0:
			display_name += " " + char(65 + count)
		var unit := _BattleUnit.from_fighter_data(
			data, display_name, enemy_def.get("level", 1), Enums.Team.ENEMY)
		_enemy_units.append(unit)
		_create_card(unit, _enemy_row)


func _create_card(unit, container: HBoxContainer) -> void:
	var card := PortraitCardScene.instantiate()
	container.add_child(card)
	card.setup(unit)
	card.clicked.connect(_on_card_clicked)
	_cards[unit] = card


# --- ATB Loop ---

func _run_battle() -> void:
	_battle_active = true
	await get_tree().create_timer(0.5).timeout
	while _battle_active:
		_advance_atb()
		var acting := _get_acting_units()
		for unit in acting:
			if not _battle_active or not unit.is_alive:
				continue
			unit.turn_counter -= TURN_THRESHOLD
			unit.start_turn()
			_update_all_cards()
			_highlight_card(unit, true)

			if unit.team == Enums.Team.PLAYER:
				await _player_turn(unit)
			else:
				await _ai_turn(unit)

			unit.end_turn()
			_highlight_card(unit, false)
			_update_all_cards()
			if _check_battle_end():
				return
		_update_all_cards()
		await get_tree().process_frame


func _advance_atb() -> void:
	for unit in _all_units:
		if unit.is_alive:
			unit.turn_counter += float(unit.speed)


func _get_acting_units() -> Array:
	var acting: Array = []
	for unit in _all_units:
		if unit.is_alive and unit.turn_counter >= TURN_THRESHOLD:
			acting.append(unit)
	acting.sort_custom(func(a, b) -> bool: return a.turn_counter > b.turn_counter)
	return acting


# --- Player Turn ---

func _player_turn(unit) -> void:
	_turn_label.text = "%s's turn" % unit.unit_name
	_action_menu.show_for(unit)
	var action: Dictionary = await _action_menu.action_chosen

	match action.get("type", ""):
		"attack", "ability":
			var ability: AbilityData = action["ability"]
			var targets := await _select_targets(ability, unit)
			if not targets.is_empty():
				unit.spend_mana(ability.mana_cost)
				var results := _AbilityExecutor.execute(ability, unit, targets)
				await _animate_results(results)
		"defend":
			_apply_defend(unit)

	_turn_label.text = ""


func _select_targets(ability: AbilityData, caster) -> Array:
	var valid := _get_valid_targets(ability, caster)
	if valid.is_empty():
		return []

	if ability.target_scope != Enums.TargetScope.SINGLE:
		return valid

	for u in valid:
		if _cards.has(u):
			_cards[u].set_targetable(true)

	_selected_target = null
	await _target_selected

	for u in valid:
		if _cards.has(u):
			_cards[u].set_targetable(false)

	if _selected_target and _selected_target in valid:
		return [_selected_target]
	return valid.slice(0, 1)


func _on_card_clicked(unit) -> void:
	_selected_target = unit
	_target_selected.emit()


func _get_valid_targets(ability: AbilityData, caster) -> Array:
	var allies := _player_units if caster.team == Enums.Team.PLAYER else _enemy_units
	var enemies := _enemy_units if caster.team == Enums.Team.PLAYER else _player_units

	match ability.ability_type:
		Enums.AbilityType.DAMAGE, Enums.AbilityType.DEBUFF:
			return _filter_alive(enemies)
		Enums.AbilityType.HEAL, Enums.AbilityType.BUFF:
			return _filter_alive(allies)
	return []


# --- AI Turn ---

func _ai_turn(unit) -> void:
	_turn_label.text = "%s's turn" % unit.unit_name
	await get_tree().create_timer(0.4).timeout

	var allies := _enemy_units if unit.team == Enums.Team.ENEMY else _player_units
	var enemies := _player_units if unit.team == Enums.Team.ENEMY else _enemy_units
	var decision := _BattleAI.decide_action(unit, allies, enemies)

	if decision.is_empty():
		_turn_label.text = ""
		return

	var ability: AbilityData = decision["ability"]
	var targets: Array = decision["targets"]
	unit.spend_mana(ability.mana_cost)
	var results := _AbilityExecutor.execute(ability, unit, targets)
	await _animate_results(results)
	_turn_label.text = ""


# --- Combat Animations ---

func _animate_results(results: Array[Dictionary]) -> void:
	for result in results:
		var target = result["target"]
		if not _cards.has(target):
			continue
		var card: Control = _cards[target]

		match result.get("type", ""):
			"damage":
				var text := str(result["amount"])
				if result.get("is_crit", false):
					text += "!"
				var color := Color.YELLOW if result.get("is_crit", false) else Color.WHITE
				_show_popup(card, text, color)
				_flash_card(card, Color(1.5, 0.5, 0.5))
			"heal":
				_show_popup(card, "+%d" % result["amount"], Color.GREEN)
				_flash_card(card, Color(0.5, 1.5, 0.5))
			"mana_heal":
				_show_popup(card, "+%d MP" % result["amount"], Color.CYAN)
			"dodge":
				_show_popup(card, "DODGE", Color.CYAN)
			"buff":
				_show_popup(card, result.get("stat_name", "BUFF") + " UP", Color(0.4, 0.6, 1.0))
			"debuff":
				_show_popup(card, result.get("stat_name", "DEBUFF") + " DOWN", Color(0.8, 0.3, 0.8))

		card.update_display()
		await get_tree().create_timer(0.3).timeout


func _show_popup(card: Control, text: String, color: Color) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", 22)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.global_position = card.global_position + Vector2(card.size.x * 0.2, -10)
	label.z_index = 100
	get_tree().root.add_child(label)
	var tween := label.create_tween()
	tween.tween_property(label, "position:y", label.position.y - 50, 0.9)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.9)
	tween.tween_callback(label.queue_free)


func _flash_card(card: Control, color: Color) -> void:
	card.modulate = color
	var tween := card.create_tween()
	tween.tween_property(card, "modulate", Color.WHITE, 0.3)


# --- Utilities ---

func _apply_defend(unit) -> void:
	var def_mod := _ModifiedStat.create(Enums.StatType.PHYSICAL_DEFENSE, 3, 1, false)
	var mdef_mod := _ModifiedStat.create(Enums.StatType.MAGIC_DEFENSE, 3, 1, false)
	unit.modified_stats.append(def_mod)
	unit.modified_stats.append(mdef_mod)
	unit.apply_stat_modifier(def_mod.stat, def_mod.modifier)
	unit.apply_stat_modifier(mdef_mod.stat, mdef_mod.modifier)


func _highlight_card(unit, active: bool) -> void:
	if _cards.has(unit):
		_cards[unit].set_active(active)


func _update_all_cards() -> void:
	for unit in _cards:
		_cards[unit].update_display()


func _filter_alive(units: Array) -> Array:
	var result: Array = []
	for u in units:
		if u.is_alive:
			result.append(u)
	return result


# --- Battle End ---

func _check_battle_end() -> bool:
	var alive_enemies := _filter_alive(_enemy_units)
	var alive_players := _filter_alive(_player_units)

	if alive_enemies.is_empty():
		_battle_active = false
		await get_tree().create_timer(0.8).timeout
		_on_victory()
		return true

	if alive_players.is_empty():
		_battle_active = false
		await get_tree().create_timer(0.8).timeout
		_on_defeat()
		return true

	return false


func _on_victory() -> void:
	_turn_label.text = "Victory!"
	var gold: int = _config.get("gold_reward", 0)
	GameState.add_gold(gold)
	GameState.update_party_after_battle(_build_party_snapshot())
	GameState.complete_battle(GameState.current_battle_id)
	GameState.auto_save()
	await get_tree().create_timer(1.5).timeout
	_show_summary(true, gold)


func _on_defeat() -> void:
	_turn_label.text = "Defeat..."
	await get_tree().create_timer(2.0).timeout
	SceneManager.go_to_game_over()


func _build_party_snapshot() -> Array:
	var snapshot: Array = []
	for unit in _player_units:
		snapshot.append({
			"team": Enums.Team.PLAYER,
			"unit_name": unit.unit_name,
			"is_alive": unit.is_alive,
			"level": unit.level,
			"xp": unit.xp,
			"jp": unit.jp,
			"health": unit.health,
			"mana": unit.mana,
		})
	return snapshot


func _show_summary(victory: bool, gold: int) -> void:
	var summary_panel := Panel.new()
	summary_panel.set_anchors_preset(Control.PRESET_CENTER)
	summary_panel.custom_minimum_size = Vector2(400, 300)
	summary_panel.offset_left = -200
	summary_panel.offset_top = -150
	summary_panel.offset_right = 200
	summary_panel.offset_bottom = 150
	add_child(summary_panel)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	summary_panel.add_child(margin)
	var inner_vbox := VBoxContainer.new()
	inner_vbox.add_theme_constant_override("separation", 8)
	margin.add_child(inner_vbox)

	var title := Label.new()
	title.text = "Victory!" if victory else "Defeat"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	inner_vbox.add_child(title)

	if gold > 0:
		var gold_label := Label.new()
		gold_label.text = "Gold earned: %d" % gold
		inner_vbox.add_child(gold_label)

	for unit in _player_units:
		var unit_label := Label.new()
		var status := "OK" if unit.is_alive else "Fallen"
		unit_label.text = "%s - Lv.%d (%s)" % [unit.unit_name, unit.level, status]
		inner_vbox.add_child(unit_label)

	var btn := Button.new()
	btn.text = "Continue"
	btn.custom_minimum_size = Vector2(0, 40)
	btn.pressed.connect(func(): StoryFlow.advance())
	inner_vbox.add_child(btn)
