class_name Unit extends Node2D

signal turn_completed
signal died(unit: Unit)
signal took_damage(unit: Unit, amount: int)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: ProgressBar = $HealthBar

const PLAYER_COLOR := Color(0.3, 0.5, 0.9)
const ENEMY_COLOR := Color(0.9, 0.3, 0.3)
const PLACEHOLDER_SIZE := 24.0

var unit_name: String
var unit_class: String
var team: Enums.Team = Enums.Team.PLAYER
var level: int = 1
var fighter_data: FighterData

var max_health: int
var health: int
var max_mana: int
var mana: int
var physical_attack: int
var physical_defense: int
var magic_attack: int
var magic_defense: int
var speed: int
var crit_chance: int
var crit_damage: int
var dodge_chance: int
var movement: int
var jump: int

var voice_pack: String = ""
var grid_position: Vector2i
var facing: Enums.Facing = Enums.Facing.SOUTH
var abilities: Array[AbilityData] = []
var reaction_types: Array[Enums.ReactionType] = []
var modified_stats: Array[ModifiedStat] = []

var xp: int = 0
var jp: int = 0
var xp_gained_this_battle: int = 0
var jp_gained_this_battle: int = 0
var levels_gained_this_battle: int = 0

var turn_counter: int = 0
var has_reaction: bool = true
var has_acted: bool = false
var has_moved: bool = false
var is_alive: bool = true

const TILE_SIZE := 64


func _draw() -> void:
	if sprite.sprite_frames and sprite.sprite_frames.get_animation_names().size() > 0:
		return
	var color := PLAYER_COLOR if team == Enums.Team.PLAYER else ENEMY_COLOR
	var half := PLACEHOLDER_SIZE / 2.0
	draw_rect(Rect2(-half, -half, PLACEHOLDER_SIZE, PLACEHOLDER_SIZE), color)
	draw_rect(Rect2(-half, -half, PLACEHOLDER_SIZE, PLACEHOLDER_SIZE), color.lightened(0.3), false, 2.0)


func initialize(data: FighterData, p_name: String, p_team: Enums.Team, p_level: int = 1) -> void:
	fighter_data = data
	unit_name = p_name
	unit_class = data.class_display_name
	team = p_team
	level = p_level

	var stats := data.get_stats_at_level(level)
	max_health = stats["max_health"]
	health = max_health
	max_mana = stats["max_mana"]
	mana = max_mana
	physical_attack = stats["physical_attack"]
	physical_defense = stats["physical_defense"]
	magic_attack = stats["magic_attack"]
	magic_defense = stats["magic_defense"]
	speed = stats["speed"]
	crit_chance = stats["crit_chance"]
	crit_damage = stats["crit_damage"]
	dodge_chance = stats["dodge_chance"]
	movement = stats["movement"]
	jump = stats["jump"]

	abilities = data.abilities.duplicate()
	reaction_types = data.reaction_types.duplicate()

	_load_sprite(data.sprite_id)

	if p_team == Enums.Team.PLAYER:
		_apply_equipment()
		# Restore persisted HP/MP if available (carries damage from previous battles)
		var tracked := GameState.get_tracked_hp_mp(p_name)
		if tracked["hp"] >= 0:
			health = mini(tracked["hp"], max_health)
		if tracked["mp"] >= 0:
			mana = mini(tracked["mp"], max_mana)


func initialize_xp(p_xp: int, p_jp: int) -> void:
	xp = p_xp
	jp = p_jp


func _apply_equipment() -> void:
	var equipped: Array = GameState.get_all_equipped(unit_name)
	for i in range(equipped.size()):
		var item: ItemData = GameState.get_equipped_item_at(unit_name, i)
		if not item:
			continue
		for stat_key in item.stat_bonuses:
			var bonus: int = int(item.stat_bonuses[stat_key])
			var stat_val: int
			if stat_key is String:
				stat_val = Enums.StatType.get(stat_key.to_upper(), -1)
			else:
				stat_val = int(stat_key)
			match stat_val:
				Enums.StatType.PHYSICAL_ATTACK:
					physical_attack += bonus
				Enums.StatType.PHYSICAL_DEFENSE:
					physical_defense += bonus
				Enums.StatType.MAGIC_ATTACK:
					magic_attack += bonus
				Enums.StatType.MAGIC_DEFENSE:
					magic_defense += bonus
				Enums.StatType.SPEED:
					speed += bonus
				Enums.StatType.DODGE_CHANCE:
					dodge_chance += bonus
				Enums.StatType.ATTACK:
					physical_attack += bonus
					magic_attack += bonus
				Enums.StatType.DEFENSE:
					physical_defense += bonus
					magic_defense += bonus
				Enums.StatType.MAX_HEALTH:
					max_health += bonus
					health = mini(health + bonus, max_health)
				Enums.StatType.MAX_MANA:
					max_mana += bonus
					mana = mini(mana + bonus, max_mana)
				Enums.StatType.CRIT_CHANCE:
					crit_chance += bonus
				Enums.StatType.CRIT_DAMAGE:
					crit_damage += bonus
				Enums.StatType.MOVEMENT:
					movement += bonus
				Enums.StatType.JUMP:
					jump += bonus


func place_on_grid(pos: Vector2i) -> void:
	grid_position = pos
	position = Vector2(pos.x * TILE_SIZE + TILE_SIZE / 2, pos.y * TILE_SIZE + TILE_SIZE / 2)
	_update_facing_animation()


func get_stats_dict() -> Dictionary:
	return {
		"physical_attack": physical_attack,
		"physical_defense": physical_defense,
		"magic_attack": magic_attack,
		"magic_defense": magic_defense,
		"speed": speed,
		"crit_chance": crit_chance,
		"crit_damage": crit_damage,
		"dodge_chance": dodge_chance,
	}


func take_damage(amount: int) -> void:
	health = maxi(health - amount, 0)
	took_damage.emit(self, amount)
	_update_health_bar()
	if health <= 0:
		is_alive = false
		if not voice_pack.is_empty():
			SFXManager.play_voice(voice_pack, "battle_cry")
		died.emit(self)
	elif not voice_pack.is_empty():
		SFXManager.play_voice(voice_pack, "vocal", 0.7)


func heal(amount: int) -> void:
	health = mini(health + amount, max_health)
	_update_health_bar()


func spend_mana(amount: int) -> void:
	mana = maxi(mana - amount, 0)


func restore_mana(amount: int) -> void:
	mana = mini(mana + amount, max_mana)


func can_afford_ability(ability: AbilityData) -> bool:
	return mana >= ability.mana_cost


func has_any_affordable_ability() -> bool:
	for ability in abilities:
		if can_afford_ability(ability):
			return true
	return false


func get_affordable_abilities() -> Array[AbilityData]:
	var affordable: Array[AbilityData] = []
	for ability in abilities:
		if can_afford_ability(ability):
			affordable.append(ability)
	return affordable


func start_turn() -> void:
	has_reaction = true
	has_acted = false
	has_moved = false
	_tick_modified_stats()


func end_turn() -> void:
	turn_completed.emit()


func use_reaction() -> void:
	has_reaction = false


func has_reaction_type(rt: Enums.ReactionType) -> bool:
	return rt in reaction_types


func set_facing_toward(target_pos: Vector2i) -> void:
	var diff := target_pos - grid_position
	if absi(diff.x) >= absi(diff.y):
		facing = Enums.Facing.EAST if diff.x > 0 else Enums.Facing.WEST
	else:
		facing = Enums.Facing.SOUTH if diff.y > 0 else Enums.Facing.NORTH
	_update_facing_animation()


func get_facing_direction() -> Vector2i:
	match facing:
		Enums.Facing.NORTH: return Vector2i(0, -1)
		Enums.Facing.SOUTH: return Vector2i(0, 1)
		Enums.Facing.EAST: return Vector2i(1, 0)
		Enums.Facing.WEST: return Vector2i(-1, 0)
	return Vector2i(0, 1)


func is_facing_toward(from_pos: Vector2i) -> bool:
	var dir_to_pos := from_pos - grid_position
	if dir_to_pos == Vector2i.ZERO:
		return false
	var face_dir := get_facing_direction()
	return sign(dir_to_pos.x) == face_dir.x and sign(dir_to_pos.y) == face_dir.y


func apply_stat_modifier(stat: Enums.StatType, modifier: int, is_negative: bool) -> void:
	_modify_stat(stat, modifier, is_negative)


func _tick_modified_stats() -> void:
	var to_remove: Array[int] = []
	for i in range(modified_stats.size()):
		var ms := modified_stats[i]
		if ms.turns_remaining <= 0:
			_modify_stat(ms.stat, ms.modifier, not ms.is_negative)
			to_remove.push_front(i)
		else:
			ms.turns_remaining -= 1

	for idx in to_remove:
		modified_stats.remove_at(idx)


func _modify_stat(stat: Enums.StatType, modifier: int, is_negative: bool) -> void:
	var sign_val := -1 if is_negative else 1
	match stat:
		Enums.StatType.ATTACK:
			physical_attack += modifier * sign_val
			magic_attack += modifier * sign_val
		Enums.StatType.DEFENSE:
			physical_defense += modifier * sign_val
			magic_defense += modifier * sign_val
		Enums.StatType.PHYSICAL_ATTACK:
			physical_attack += modifier * sign_val
		Enums.StatType.PHYSICAL_DEFENSE:
			physical_defense += modifier * sign_val
		Enums.StatType.MAGIC_ATTACK:
			magic_attack += modifier * sign_val
		Enums.StatType.MAGIC_DEFENSE:
			magic_defense += modifier * sign_val
		Enums.StatType.SPEED:
			speed += modifier * sign_val
		Enums.StatType.MIXED_ATTACK:
			physical_attack += modifier * sign_val
			magic_attack += modifier * sign_val
		Enums.StatType.DODGE_CHANCE:
			dodge_chance += modifier * sign_val

	physical_attack = maxi(0, physical_attack)
	physical_defense = maxi(0, physical_defense)
	magic_attack = maxi(0, magic_attack)
	magic_defense = maxi(0, magic_defense)
	speed = maxi(1, speed)
	dodge_chance = maxi(0, dodge_chance)


func _update_health_bar() -> void:
	if health_bar:
		health_bar.value = float(health) / float(max_health) * 100.0


func animate_move_along_path(path: Array[Vector2i]) -> void:
	for i in range(path.size()):
		var cell := path[i]
		# Update facing toward the next cell for walk animation
		if cell != grid_position:
			var diff := cell - grid_position
			if absi(diff.x) >= absi(diff.y):
				facing = Enums.Facing.EAST if diff.x > 0 else Enums.Facing.WEST
			else:
				facing = Enums.Facing.SOUTH if diff.y > 0 else Enums.Facing.NORTH
			_play_anim("walk")
		grid_position = cell
		var target_pos := Vector2(cell.x * TILE_SIZE + TILE_SIZE / 2, cell.y * TILE_SIZE + TILE_SIZE / 2)
		var tween := create_tween()
		tween.tween_property(self, "position", target_pos, 0.15)
		await tween.finished
		SFXManager.play(SFXManager.Category.FOOTSTEP, 0.4)

	_update_facing_animation()


# --- Sprite Loading ---

func _load_sprite(p_sprite_id: String) -> void:
	var frames := SpriteLoader.get_frames(p_sprite_id)
	if frames:
		sprite.sprite_frames = frames
	queue_redraw()


# --- Animation ---

func _facing_suffix() -> String:
	match facing:
		Enums.Facing.NORTH: return "up"
		Enums.Facing.SOUTH: return "down"
		Enums.Facing.EAST: return "right"
		Enums.Facing.WEST: return "left"
	return "down"


func _has_anim(anim_name: String) -> bool:
	return sprite.sprite_frames != null and sprite.sprite_frames.has_animation(anim_name)


func _play_anim(action: String) -> void:
	var anim_name := "%s_%s" % [action, _facing_suffix()]
	if _has_anim(anim_name):
		sprite.play(anim_name)
	elif _has_anim(action):
		sprite.play(action)


func _update_facing_animation() -> void:
	_play_anim("idle")


func play_attack_animation() -> void:
	var anim_name := "attack_%s" % _facing_suffix()
	if _has_anim(anim_name):
		sprite.play(anim_name)
		await sprite.animation_finished
		_update_facing_animation()
	elif _has_anim("attack"):
		sprite.play("attack")
		await sprite.animation_finished
		_update_facing_animation()


func play_hurt_animation() -> void:
	if _has_anim("hurt"):
		sprite.play("hurt")
		await sprite.animation_finished
		_update_facing_animation()
	else:
		# Flash bright white as fallback
		modulate = Color(3, 3, 3, 1)
		var tween := create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.15)
		await tween.finished


func play_death_animation() -> void:
	if _has_anim("death"):
		sprite.play("death")
		await sprite.animation_finished
	else:
		var tween := create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.4)
		await tween.finished


# --- XP / JP ---

func award_xp(raw_amount: int) -> void:
	if team != Enums.Team.PLAYER:
		return
	var multiplier := XpConfig.get_catchup_multiplier(level, GameState.progression_stage)
	var scaled := int(raw_amount * multiplier)
	scaled = maxi(scaled, 1)
	xp += scaled
	xp_gained_this_battle += scaled
	_check_level_up()


func award_jp(amount: int) -> void:
	if team != Enums.Team.PLAYER:
		return
	jp += amount
	jp_gained_this_battle += amount


func award_ability_xp_jp(ability: AbilityData, got_crit: bool, got_kill: bool) -> void:
	var xp_amount := XpConfig.BASE_ABILITY_XP
	if XpConfig.is_basic_attack(ability):
		xp_amount += XpConfig.BASIC_ATTACK_BONUS_XP
	if got_kill:
		xp_amount += XpConfig.KILL_BONUS_XP
	if got_crit:
		xp_amount += XpConfig.CRIT_BONUS_XP
	award_xp(xp_amount)

	var jp_amount := XpConfig.calculate_jp(fighter_data.class_id, ability)
	award_jp(jp_amount)


func _check_level_up() -> void:
	var threshold := XpConfig.xp_to_next_level(level)
	while xp >= threshold:
		xp -= threshold
		_level_up()
		threshold = XpConfig.xp_to_next_level(level)


func _level_up() -> void:
	level += 1
	levels_gained_this_battle += 1

	var stats := fighter_data.get_stats_at_level(level)
	max_health = stats["max_health"]
	health = max_health
	max_mana = stats["max_mana"]
	mana = max_mana
	physical_attack = stats["physical_attack"]
	physical_defense = stats["physical_defense"]
	magic_attack = stats["magic_attack"]
	magic_defense = stats["magic_defense"]
	speed = stats["speed"]
	crit_chance = stats["crit_chance"]
	crit_damage = stats["crit_damage"]
	dodge_chance = stats["dodge_chance"]
	movement = stats["movement"]
	jump = stats["jump"]
	_update_health_bar()
