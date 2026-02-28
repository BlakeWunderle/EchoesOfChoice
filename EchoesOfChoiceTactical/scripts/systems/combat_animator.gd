class_name CombatAnimator extends RefCounted

const _AbilityAnnouncement = preload("res://scenes/battle/AbilityAnnouncement.gd")

var _scene_root: Node
var _camera: Camera2D
var _hud: CanvasLayer

const POPUP_RISE := 40.0
const POPUP_DURATION := 0.7
const HIT_FLASH_DURATION := 0.12
const SHAKE_STEP := 0.03
const TINT_DURATION := 0.15
const HEALTH_TWEEN_DURATION := 0.3
const DEATH_FADE_DURATION := 0.4
const SETTLE_TIME := 0.2

const TINT_FIRE := Color(1.5, 0.6, 0.3)
const TINT_ICE := Color(0.5, 0.8, 1.5)
const TINT_LIGHTNING := Color(1.5, 1.4, 0.5)
const TINT_HEAL := Color(0.5, 1.5, 0.5)
const TINT_DARK := Color(0.8, 0.4, 1.2)
const TINT_DAMAGE := Color(1.3, 0.8, 0.8)
const TINT_BUFF := Color(0.8, 1.0, 1.5)
const TINT_DEBUFF := Color(1.2, 0.7, 1.2)

const COLOR_DAMAGE := Color(1.0, 0.3, 0.2)
const COLOR_CRIT := Color(1.0, 0.85, 0.0)
const COLOR_HEAL := Color(0.3, 1.0, 0.4)
const COLOR_MANA := Color(0.4, 0.6, 1.0)
const COLOR_MISS := Color(0.7, 0.7, 0.7)
const COLOR_BUFF := Color(0.4, 0.8, 1.0)
const COLOR_DEBUFF := Color(0.9, 0.4, 0.9)
const COLOR_BODYGUARD := Color(0.9, 0.7, 0.3)
const COLOR_MITIGATE := Color(0.5, 0.8, 0.9)


func _init(p_scene_root: Node, p_camera: Camera2D = null, p_hud: CanvasLayer = null) -> void:
	_scene_root = p_scene_root
	_camera = p_camera
	_hud = p_hud


## Animate all results from an ability execution.
func animate_ability_results(attacker: Unit, exec_result: Dictionary) -> void:
	var results: Array = exec_result.get("results", [])
	var ability: AbilityData = exec_result.get("ability", null)
	if results.is_empty():
		return

	# Show ability name announcement (skip basic Strike and items)
	if ability and ability.ability_name != "Strike" and _hud:
		_AbilityAnnouncement.announce(_hud, attacker, ability)

	# Attacker plays attack animation
	await _play_attack(attacker)

	# Ability tint flash on all targets
	var targets: Array[Unit] = []
	for r in results:
		var t: Unit = r.get("target")
		if t and t not in targets:
			targets.append(t)
	if ability:
		_flash_ability_tint(targets, ability)

	# Process each result with visual feedback
	var killed_units: Array[Unit] = []
	for r in results:
		var rtype: String = r.get("type", "")

		if rtype == "destructible":
			var tile_pos: Vector2i = r.get("pos", Vector2i.ZERO)
			var world_pos := Vector2(tile_pos.x * 64 + 32, tile_pos.y * 64 + 32)
			var amount: int = r.get("amount", 0)
			_spawn_popup_at_pos(world_pos, str(amount), COLOR_DAMAGE, 16)
			if r.get("destroyed", false):
				_shake_camera(3.0, 0.15)
			continue

		var target: Unit = r.get("target")
		if target == null:
			continue

		match rtype:
			"dodge":
				spawn_popup(target, "MISS", COLOR_MISS, 14)
			"damage":
				var amount: int = r.get("amount", 0)
				var is_crit: bool = r.get("is_crit", false)
				_animate_damage_hit(target, amount, is_crit, r)
				if is_crit:
					_shake_camera(5.0, 0.2)
				if r.get("killed", false) and target not in killed_units:
					killed_units.append(target)
			"heal":
				var amount: int = r.get("amount", 0)
				spawn_popup(target, "+%d" % amount, COLOR_HEAL, 16)
				_tween_health_bar(target, r)
			"mana_heal":
				var amount: int = r.get("amount", 0)
				spawn_popup(target, "+%d MP" % amount, COLOR_MANA, 14)
			"buff":
				var stat_name: String = r.get("stat_name", "STAT")
				spawn_popup(target, "%s UP" % stat_name, COLOR_BUFF, 14)
			"debuff":
				var stat_name: String = r.get("stat_name", "STAT")
				spawn_popup(target, "%s DOWN" % stat_name, COLOR_DEBUFF, 14)
			"terrain":
				pass  # Terrain placement has no per-unit visual

	# Animate defensive reaction popups (bodyguard, mitigation)
	var def_reactions: Array = exec_result.get("defensive_reactions", [])
	for dr in def_reactions:
		_animate_defensive_reaction(dr)

	# Animate offensive reactions (flanking strikes, reactive heals)
	var off_reactions: Array = exec_result.get("offensive_reactions", [])
	if off_reactions.size() > 0:
		var typed_reactions: Array[Dictionary] = []
		for r in off_reactions:
			typed_reactions.append(r)
		await animate_reaction_results(typed_reactions)

	# Wait for hit animations to settle
	await _scene_root.get_tree().create_timer(SETTLE_TIME).timeout

	# Death sequences
	for dead_unit in killed_units:
		await _play_death(dead_unit)


## Animate results from reactions during movement.
func animate_reaction_results(results: Array[Dictionary]) -> void:
	for r in results:
		var reactor: Unit = r.get("reactor")
		var target: Unit = r.get("target")
		if reactor == null or target == null:
			continue

		await _play_attack(reactor)

		if r.get("dodged", false):
			spawn_popup(target, "MISS", COLOR_MISS, 14)
		elif r.get("heal", 0) > 0:
			var heal_amount: int = r["heal"]
			spawn_popup(target, "+%d" % heal_amount, COLOR_HEAL, 16)
		else:
			var damage: int = r.get("damage", 0)
			_play_hit_flash(target)
			spawn_popup(target, str(damage), COLOR_DAMAGE, 16)

		await _scene_root.get_tree().create_timer(SETTLE_TIME).timeout

		if target is Unit and not target.is_alive:
			await _play_death(target)


# --- Private Helpers ---

func _play_attack(unit: Unit) -> void:
	unit.play_attack_animation()
	# If unit has no attack anim, play_attack_animation returns immediately.
	# Wait a minimum time so the attacker's intent is visible.
	await _scene_root.get_tree().create_timer(0.25).timeout


func _play_hit_flash(unit: Unit) -> void:
	unit.modulate = Color(3, 3, 3, 1)
	var tween := _scene_root.create_tween()
	tween.tween_property(unit, "modulate", Color(1, 1, 1, 1), HIT_FLASH_DURATION)


func _play_death(unit: Unit) -> void:
	await unit.play_death_animation()


func _animate_damage_hit(target: Unit, amount: int, is_crit: bool, result: Dictionary) -> void:
	_play_hit_flash(target)
	if is_crit:
		spawn_popup(target, str(amount), COLOR_CRIT, 22)
		_spawn_crit_sparkles(target)
	else:
		spawn_popup(target, str(amount), COLOR_DAMAGE, 16)
	_tween_health_bar(target, result)


func _animate_defensive_reaction(dr: Dictionary) -> void:
	var rtype = dr.get("type")
	var reactor: Unit = dr.get("reactor")
	var target: Unit = dr.get("target")
	if rtype == Enums.ReactionType.BODYGUARD and reactor:
		var absorbed: int = dr.get("damage_to_tank", 0)
		spawn_popup(reactor, "GUARD %d" % absorbed, COLOR_BODYGUARD, 14)
		_play_hit_flash(reactor)
	elif rtype == Enums.ReactionType.DAMAGE_MITIGATION and reactor:
		var reduced: int = dr.get("reduction", 0)
		spawn_popup(target if target else reactor, "-%d MIT" % reduced, COLOR_MITIGATE, 14)


func _tween_health_bar(target: Unit, result: Dictionary) -> void:
	var old_ratio: float = result.get("old_hp_ratio", 1.0)
	var new_ratio: float = result.get("new_hp_ratio", 1.0)
	if target.health_bar:
		target.health_bar.value = old_ratio * 100.0
		var tween := _scene_root.create_tween()
		tween.tween_property(target.health_bar, "value", new_ratio * 100.0, HEALTH_TWEEN_DURATION)


func spawn_popup(unit: Unit, text: String, color: Color, font_size: int = 16) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", font_size)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = unit.position + Vector2(-20, -45)
	label.z_index = 100
	_scene_root.add_child(label)

	var tween := _scene_root.create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - POPUP_RISE, POPUP_DURATION)
	tween.tween_property(label, "modulate:a", 0.0, POPUP_DURATION).set_delay(0.3)
	tween.set_parallel(false)
	tween.tween_callback(label.queue_free)


func _spawn_popup_at_pos(world_pos: Vector2, text: String, color: Color, font_size: int = 16) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", font_size)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = world_pos + Vector2(-20, -45)
	label.z_index = 100
	_scene_root.add_child(label)

	var tween := _scene_root.create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - POPUP_RISE, POPUP_DURATION)
	tween.tween_property(label, "modulate:a", 0.0, POPUP_DURATION).set_delay(0.3)
	tween.set_parallel(false)
	tween.tween_callback(label.queue_free)


func _spawn_crit_sparkles(unit: Unit) -> void:
	var sparkle_chars := ["*", "+", "*", "+", "*", "+"]
	for i in range(6):
		var spark := Label.new()
		spark.text = sparkle_chars[i]
		spark.add_theme_color_override("font_color", COLOR_CRIT if i % 2 == 0 else Color.WHITE)
		spark.add_theme_font_size_override("font_size", 10)
		spark.position = unit.position + Vector2(-4, -20)
		spark.z_index = 101
		_scene_root.add_child(spark)

		var angle := TAU * i / 6.0
		var end_pos := spark.position + Vector2(cos(angle), sin(angle)) * 28.0
		var tween := _scene_root.create_tween()
		tween.set_parallel(true)
		tween.tween_property(spark, "position", end_pos, 0.4).set_ease(Tween.EASE_OUT)
		tween.tween_property(spark, "modulate:a", 0.0, 0.4).set_delay(0.15)
		tween.set_parallel(false)
		tween.tween_callback(spark.queue_free)


func _shake_camera(intensity: float = 4.0, duration: float = 0.2) -> void:
	if _camera == null:
		return
	var original_offset := _camera.offset
	var tween := _scene_root.create_tween()
	var steps := int(duration / SHAKE_STEP)
	for i in steps:
		var offset := Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(_camera, "offset", original_offset + offset, SHAKE_STEP)
	tween.tween_property(_camera, "offset", original_offset, SHAKE_STEP)


func _flash_ability_tint(targets: Array[Unit], ability: AbilityData) -> void:
	var tint := _get_ability_tint(ability)
	for target in targets:
		target.modulate = tint
		var tween := _scene_root.create_tween()
		tween.tween_property(target, "modulate", Color(1, 1, 1, 1), TINT_DURATION)


func _get_ability_tint(ability: AbilityData) -> Color:
	if ability.is_heal():
		return TINT_HEAL
	if ability.ability_type == Enums.AbilityType.BUFF:
		return TINT_BUFF
	if ability.ability_type == Enums.AbilityType.DEBUFF:
		return TINT_DEBUFF
	var lower := ability.ability_name.to_lower()
	for keyword in ["fire", "flame", "burn", "ignite", "inferno", "blaze", "scorch"]:
		if lower.contains(keyword):
			return TINT_FIRE
	for keyword in ["ice", "frost", "cold", "blizzard", "cryo", "freeze"]:
		if lower.contains(keyword):
			return TINT_ICE
	for keyword in ["lightning", "thunder", "shock", "bolt", "storm", "jolt"]:
		if lower.contains(keyword):
			return TINT_LIGHTNING
	for keyword in ["dark", "shadow", "void", "necrotic", "drain", "siphon"]:
		if lower.contains(keyword):
			return TINT_DARK
	return TINT_DAMAGE
