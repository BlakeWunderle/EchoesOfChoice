class_name Unit extends Node2D

signal turn_completed
signal died(unit: Unit)
signal took_damage(unit: Unit, amount: int)

@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $HealthBar

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


func initialize_xp(p_xp: int, p_jp: int) -> void:
	xp = p_xp
	jp = p_jp


func place_on_grid(pos: Vector2i) -> void:
	grid_position = pos
	position = Vector2(pos.x * TILE_SIZE + TILE_SIZE / 2, pos.y * TILE_SIZE + TILE_SIZE / 2)


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
		died.emit(self)


func heal(amount: int) -> void:
	health = mini(health + amount, max_health)
	_update_health_bar()


func spend_mana(amount: int) -> void:
	mana = maxi(mana - amount, 0)


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


func get_facing_direction() -> Vector2i:
	match facing:
		Enums.Facing.NORTH: return Vector2i(0, -1)
		Enums.Facing.SOUTH: return Vector2i(0, 1)
		Enums.Facing.EAST: return Vector2i(1, 0)
		Enums.Facing.WEST: return Vector2i(-1, 0)
	return Vector2i(0, 1)


func is_facing_toward(from_pos: Vector2i) -> bool:
	var approach_dir := grid_position - from_pos
	if approach_dir == Vector2i.ZERO:
		return false
	var face_dir := get_facing_direction()
	return approach_dir.x == face_dir.x and approach_dir.y == face_dir.y


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
	for cell in path:
		grid_position = cell
		var target_pos := Vector2(cell.x * TILE_SIZE + TILE_SIZE / 2, cell.y * TILE_SIZE + TILE_SIZE / 2)
		var tween := create_tween()
		tween.tween_property(self, "position", target_pos, 0.15)
		await tween.finished

	if path.size() > 1:
		set_facing_toward(path[-1])


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
