## Battle definitions for headless simulation.
## Maps battle_id -> enemy roster, grid size, spawn positions, target win rate.
class_name BattleStages extends RefCounted

## Target win rates per progression stage.
const TARGETS := {
	0: 0.90, 1: 0.86, 2: 0.81, 3: 0.77,
	4: 0.73, 5: 0.69, 6: 0.64, 7: 0.60,
}

## Tolerance range (±) for pass/fail.
const TOLERANCE := 0.03

## Per-class win rate thresholds relative to stage target.
const CLASS_WARN_DELTA := 0.15
const CLASS_FAIL_DELTA := 0.25
const CLASS_OVER_DELTA := 0.08


static func get_all_stages() -> Array[Dictionary]:
	var stages: Array[Dictionary] = []
	stages.append_array(_prog_0())
	stages.append_array(_prog_1())
	stages.append_array(_prog_2())
	stages.append_array(_prog_3())
	stages.append_array(_prog_4())
	stages.append_array(_prog_5())
	stages.append_array(_prog_6())
	stages.append_array(_prog_7())
	return stages


static func get_stages_for_progression(prog: int) -> Array[Dictionary]:
	match prog:
		0: return _prog_0()
		1: return _prog_1()
		2: return _prog_2()
		3: return _prog_3()
		4: return _prog_4()
		5: return _prog_5()
		6: return _prog_6()
		7: return _prog_7()
	return []


static func get_stage(battle_id: String) -> Dictionary:
	for stage in get_all_stages():
		if stage["battle_id"] == battle_id:
			return stage
	return {}


static func _stage(id: String, prog: int, w: int, h: int, enemies: Array[Dictionary]) -> Dictionary:
	return {
		"battle_id": id, "progression": prog,
		"grid_width": w, "grid_height": h,
		"target": TARGETS.get(prog, 0.75),
		"enemies": enemies,
		"player_spawn": [Vector2i(2, 3), Vector2i(3, 1), Vector2i(3, 2), Vector2i(3, 4), Vector2i(3, 5)],
	}


static func _e(path: String, lvl: int, pos: Vector2i) -> Dictionary:
	return {"path": "res://resources/enemies/%s.tres" % path, "level": lvl, "pos": pos}


# --- Progression 0 (tutorial area) ---
static func _prog_0() -> Array[Dictionary]:
	return [_stage("city_street", 0, 10, 8, [
		_e("thug", 1, Vector2i(8, 1)), _e("thug", 1, Vector2i(8, 5)),
		_e("street_tough", 1, Vector2i(8, 3)), _e("street_tough", 1, Vector2i(9, 3)),
		_e("hedge_mage", 1, Vector2i(9, 1)),
	])]


# --- Progression 1 ---
static func _prog_1() -> Array[Dictionary]:
	return [
		_stage("forest", 1, 10, 8, [
			_e("forest_guardian", 1, Vector2i(8, 3)), _e("grove_sprite", 1, Vector2i(9, 4)),
			_e("gnoll_raider", 1, Vector2i(8, 1)), _e("gnoll_raider", 1, Vector2i(8, 5)),
			_e("minotaur", 1, Vector2i(9, 2)),
		]),
		_stage("village_raid", 1, 10, 8, [
			_e("goblin", 1, Vector2i(8, 2)), _e("goblin", 1, Vector2i(8, 4)),
			_e("goblin_archer", 1, Vector2i(9, 1)), _e("orc_shaman", 1, Vector2i(9, 5)),
			_e("orc_warrior", 1, Vector2i(9, 3)),
		]),
	]


# --- Progression 2 ---
static func _prog_2() -> Array[Dictionary]:
	return [
		_stage("smoke", 2, 10, 8, [
			_e("goblin_firestarter", 2, Vector2i(8, 1)), _e("goblin_firestarter", 2, Vector2i(8, 5)),
			_e("blood_fiend", 2, Vector2i(8, 2)), _e("blood_fiend", 2, Vector2i(8, 4)),
			_e("ogre", 2, Vector2i(9, 3)),
		]),
		_stage("deep_forest", 2, 10, 8, [
			_e("witch", 2, Vector2i(9, 3)),
			_e("wisp", 2, Vector2i(8, 1)), _e("wisp", 2, Vector2i(8, 5)),
			_e("sprite", 2, Vector2i(8, 2)), _e("wild_huntsman", 2, Vector2i(8, 4)),
		]),
		_stage("clearing", 2, 14, 10, [
			_e("elf_ranger", 2, Vector2i(12, 2)), _e("elf_ranger", 2, Vector2i(12, 5)),
			_e("pixie", 2, Vector2i(12, 1)), _e("pixie", 2, Vector2i(12, 7)),
			_e("satyr", 2, Vector2i(13, 4)),
		]),
		_stage("ruins", 2, 12, 10, [
			_e("shade", 2, Vector2i(10, 2)), _e("shade", 2, Vector2i(10, 5)),
			_e("wraith", 2, Vector2i(11, 4)), _e("wraith", 2, Vector2i(10, 7)),
			_e("bone_sentry", 2, Vector2i(11, 2)),
		]),
	]


# --- Progression 3 ---
static func _prog_3() -> Array[Dictionary]:
	return [
		_stage("cave", 3, 8, 6, [
			_e("orc_scout", 3, Vector2i(6, 1)), _e("orc_scout", 3, Vector2i(6, 4)),
			_e("demon_archer", 3, Vector2i(7, 2)), _e("frost_demon", 3, Vector2i(7, 4)),
		]),
		_stage("portal", 3, 10, 8, [
			_e("blood_imp", 3, Vector2i(8, 1)), _e("blood_imp", 3, Vector2i(8, 4)),
			_e("blood_imp", 3, Vector2i(8, 7)),
			_e("hellion", 3, Vector2i(9, 3)), _e("hellion", 3, Vector2i(9, 5)),
		]),
		_stage("inn_ambush", 3, 10, 8, [
			_e("skeleton_hunter", 3, Vector2i(8, 1)), _e("skeleton_hunter", 3, Vector2i(8, 5)),
			_e("dark_elf_assassin", 3, Vector2i(8, 3)),
			_e("fallen_seraph", 3, Vector2i(9, 2)), _e("shadow_demon", 3, Vector2i(9, 4)),
		]),
	]


# --- Progression 4 ---
static func _prog_4() -> Array[Dictionary]:
	return [
		_stage("shore", 4, 10, 8, [
			_e("medusa", 4, Vector2i(8, 1)), _e("medusa", 4, Vector2i(8, 5)),
			_e("sea_elf", 4, Vector2i(8, 2)), _e("sea_elf", 4, Vector2i(8, 4)),
			_e("medusa", 4, Vector2i(9, 3)),
		]),
		_stage("beach", 4, 10, 8, [
			_e("pirate", 4, Vector2i(8, 1)), _e("pirate", 4, Vector2i(8, 4)),
			_e("pirate", 4, Vector2i(8, 5)),
			_e("captain", 4, Vector2i(9, 2)), _e("ogre", 4, Vector2i(9, 3)),
		]),
		_stage("cemetery_battle", 4, 10, 8, [
			_e("zombie", 4, Vector2i(8, 1)), _e("zombie", 4, Vector2i(8, 5)),
			_e("specter", 4, Vector2i(8, 2)), _e("specter", 4, Vector2i(8, 4)),
			_e("grave_wraith", 4, Vector2i(9, 3)),
		]),
		_stage("box_battle", 4, 10, 8, [
			_e("harlequin", 4, Vector2i(8, 1)), _e("elf_enchantress", 4, Vector2i(8, 2)),
			_e("elf_enchantress", 4, Vector2i(8, 4)), _e("harlequin", 4, Vector2i(8, 5)),
			_e("ringmaster", 4, Vector2i(9, 3)),
		]),
		_stage("army_battle", 4, 10, 8, [
			_e("shadow_fiend", 4, Vector2i(8, 1)), _e("orc_warchanter", 4, Vector2i(8, 2)),
			_e("shadow_fiend", 4, Vector2i(8, 5)), _e("orc_warchanter", 4, Vector2i(9, 2)),
			_e("commander", 4, Vector2i(9, 3)),
		]),
		_stage("lab_battle", 4, 10, 8, [
			_e("frost_sentinel", 4, Vector2i(8, 1)), _e("arc_golem", 4, Vector2i(8, 2)),
			_e("ironclad", 4, Vector2i(9, 3)),
			_e("frost_sentinel", 4, Vector2i(8, 5)), _e("skeleton_crusader", 4, Vector2i(8, 4)),
		]),
	]


# --- Progression 5 ---
static func _prog_5() -> Array[Dictionary]:
	return [
		_stage("mirror_battle", 5, 14, 10, [
			_e("gorgon", 5, Vector2i(13, 4)),
			_e("ghost_corsair", 5, Vector2i(12, 2)),
			_e("dark_elf_blade", 5, Vector2i(12, 1)), _e("dark_elf_blade", 5, Vector2i(12, 7)),
			_e("dark_seraph", 5, Vector2i(12, 5)),
		]),
		_stage("gate_ambush", 5, 10, 8, [
			_e("ghost_corsair", 5, Vector2i(9, 3)),
			_e("dark_elf_blade", 5, Vector2i(8, 1)), _e("dark_elf_blade", 5, Vector2i(8, 5)),
			_e("bone_sorcerer", 5, Vector2i(9, 2)), _e("dark_seraph", 5, Vector2i(8, 3)),
		]),
	]


# --- Progression 6 ---
static func _prog_6() -> Array[Dictionary]:
	return [
		_stage("city_gate_ambush", 6, 10, 8, [
			_e("gorgon_queen", 6, Vector2i(9, 3)),
			_e("dark_elf_warlord", 6, Vector2i(8, 1)), _e("city_militia", 6, Vector2i(8, 5)),
			_e("dire_shade", 6, Vector2i(9, 2)), _e("phantom_prowler", 6, Vector2i(8, 4)),
		]),
		_stage("return_city_1", 6, 10, 8, [
			_e("seraph", 6, Vector2i(9, 3)), _e("arch_hellion", 6, Vector2i(9, 5)),
			_e("phantom_prowler", 6, Vector2i(8, 1)), _e("phantom_prowler", 6, Vector2i(8, 5)),
			_e("dark_elf_warlord", 6, Vector2i(8, 3)),
		]),
		_stage("return_city_2", 6, 10, 8, [
			_e("necromancer", 6, Vector2i(9, 3)), _e("elder_witch", 6, Vector2i(9, 5)),
			_e("dire_shade", 6, Vector2i(8, 1)), _e("phantom_prowler", 6, Vector2i(8, 5)),
			_e("dread_wraith", 6, Vector2i(8, 3)),
		]),
		_stage("return_city_3", 6, 10, 8, [
			_e("psion", 6, Vector2i(9, 3)), _e("runewright", 6, Vector2i(9, 5)),
			_e("phantom_prowler", 6, Vector2i(8, 1)), _e("phantom_prowler", 6, Vector2i(8, 5)),
			_e("dark_elf_warlord", 6, Vector2i(8, 3)),
		]),
		_stage("return_city_4", 6, 10, 8, [
			_e("warlock", 6, Vector2i(9, 3)), _e("shaman", 6, Vector2i(9, 5)),
			_e("dire_shade", 6, Vector2i(8, 1)), _e("phantom_prowler", 6, Vector2i(8, 5)),
			_e("gorgon_queen", 6, Vector2i(8, 3)),
		]),
	]


# --- Progression 7 (elemental shrines + final boss) ---
static func _prog_7() -> Array[Dictionary]:
	var spawn_wide := [Vector2i(0, 4), Vector2i(1, 1), Vector2i(1, 3), Vector2i(1, 5), Vector2i(1, 7)]
	var stages: Array[Dictionary] = [
		_stage("elemental_1", 7, 12, 10, [
			_e("fire_elemental", 8, Vector2i(11, 5)),
			_e("fire_elemental", 7, Vector2i(10, 2)), _e("fire_elemental", 7, Vector2i(10, 5)),
			_e("fire_elemental", 7, Vector2i(10, 8)), _e("fire_elemental", 7, Vector2i(11, 3)),
		]),
		_stage("elemental_2", 7, 12, 10, [
			_e("water_elemental", 8, Vector2i(11, 5)),
			_e("water_elemental", 7, Vector2i(10, 2)), _e("water_elemental", 7, Vector2i(10, 5)),
			_e("water_elemental", 7, Vector2i(10, 8)), _e("water_elemental", 7, Vector2i(11, 3)),
		]),
		_stage("elemental_3", 7, 12, 10, [
			_e("air_elemental", 8, Vector2i(11, 5)),
			_e("air_elemental", 7, Vector2i(10, 2)), _e("air_elemental", 7, Vector2i(10, 5)),
			_e("air_elemental", 7, Vector2i(10, 8)), _e("air_elemental", 7, Vector2i(11, 3)),
		]),
		_stage("elemental_4", 7, 12, 10, [
			_e("earth_elemental", 8, Vector2i(11, 5)),
			_e("earth_elemental", 7, Vector2i(10, 2)), _e("earth_elemental", 7, Vector2i(10, 5)),
			_e("earth_elemental", 7, Vector2i(10, 8)), _e("earth_elemental", 7, Vector2i(11, 3)),
		]),
	]
	for s in stages:
		s["player_spawn"] = spawn_wide

	# Final castle — big map
	var final := _stage("final_castle", 7, 14, 12, [
		_e("the_stranger", 8, Vector2i(12, 5)),
		_e("elite_guard_mage", 8, Vector2i(12, 2)), _e("elite_guard_mage", 8, Vector2i(12, 8)),
		_e("elite_guard_squire", 8, Vector2i(11, 3)), _e("elite_guard_squire", 8, Vector2i(11, 7)),
	])
	final["player_spawn"] = [Vector2i(1, 5), Vector2i(2, 2), Vector2i(2, 4), Vector2i(2, 6), Vector2i(2, 8)]
	stages.append(final)
	return stages
