## Headless battle simulator for balance validation.
## Usage: godot --path EchoesOfChoiceTactical --headless --script res://tools/sim/battle_simulator.gd -- [options]
##   city_street              Run a specific battle
##   --all                    Run all battles
##   --progression N          Run battles for progression N
##   --sims N                 Simulations per party combo (default: 30)
##   --sample N               Max party combos to sample (default: 200)
##   --list                   List all battles
##   --verbose                Show per-combo results
extends SceneTree

const _SimUnit = preload("res://tools/sim/sim_unit.gd")
const _SimReactionSystem = preload("res://tools/sim/sim_reaction_system.gd")
const _SimExecutor = preload("res://tools/sim/sim_executor.gd")
const _SimAI = preload("res://tools/sim/sim_ai.gd")
const _SimTurnManager = preload("res://tools/sim/sim_turn_manager.gd")
const _PartyComposer = preload("res://tools/sim/party_composer.gd")
const _BattleStages = preload("res://tools/sim/battle_stages.gd")

var _sims_per_combo: int = 30
var _max_sample: int = 200
var _verbose: bool = false


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 0 or "--help" in args:
		_print_usage()
		quit()
		return

	if "--list" in args:
		_list_battles()
		quit()
		return

	_sims_per_combo = _parse_int_arg(args, "--sims", 30)
	_max_sample = _parse_int_arg(args, "--sample", 200)
	_verbose = "--verbose" in args

	var stages: Array[Dictionary] = []
	if "--all" in args:
		stages = _BattleStages.get_all_stages()
	elif "--progression" in args:
		var prog := _parse_int_arg(args, "--progression", 0)
		stages = _BattleStages.get_stages_for_progression(prog)
	else:
		var skip_next := false
		for arg in args:
			if skip_next:
				skip_next = false
				continue
			if arg in ["--sims", "--sample", "--progression"]:
				skip_next = true
				continue
			if arg.begins_with("--"):
				continue
			var stage := _BattleStages.get_stage(arg)
			if stage.size() > 0:
				stages.append(stage)
			else:
				print("Unknown battle: %s" % arg)

	if stages.size() == 0:
		print("No battles to simulate.")
		quit()
		return

	print("=== BATTLE SIMULATOR ===\n")
	var composer := _PartyComposer.new()
	var all_results: Array[Dictionary] = []
	var start_time := Time.get_ticks_msec()

	for stage in stages:
		var result := _run_stage(stage, composer)
		all_results.append(result)

	var elapsed := (Time.get_ticks_msec() - start_time) / 1000.0
	_print_summary(all_results, elapsed)
	quit()


func _run_stage(stage: Dictionary, composer) -> Dictionary:
	var battle_id: String = stage["battle_id"]
	var prog: int = stage["progression"]
	var target: float = stage["target"]
	var parties = composer.get_parties(prog, _max_sample)
	var party_level: int = _PartyComposer.get_party_level(prog)

	# Load enemy FighterData resources
	var enemy_datas: Array[Dictionary] = []
	for e_def in stage["enemies"]:
		var data: FighterData = load(e_def["path"])
		if data:
			enemy_datas.append({"data": data, "level": e_def["level"], "pos": e_def["pos"]})

	var total_wins := 0
	var total_sims := 0
	var class_wins: Dictionary = {}
	var class_counts: Dictionary = {}
	var class_jp_total: Dictionary = {}
	var class_jp_sims: Dictionary = {}
	var combo_results: Array[Dictionary] = []

	for party in parties:
		var wins := 0
		for _sim in range(_sims_per_combo):
			var sim_result := _simulate_battle(stage, party, party_level, enemy_datas)
			if sim_result["player_won"]:
				wins += 1
			var jp_map: Dictionary = sim_result["jp"]
			for cid in jp_map:
				class_jp_total[cid] = class_jp_total.get(cid, 0) + jp_map[cid]
				class_jp_sims[cid] = class_jp_sims.get(cid, 0) + 1
		total_wins += wins
		total_sims += _sims_per_combo
		var combo_rate := float(wins) / float(_sims_per_combo)
		combo_results.append({"party": party, "win_rate": combo_rate})

		for class_id in party:
			class_wins[class_id] = class_wins.get(class_id, 0) + wins
			class_counts[class_id] = class_counts.get(class_id, 0) + _sims_per_combo

	var overall_rate := float(total_wins) / float(total_sims) if total_sims > 0 else 0.0

	# Class breakdown
	var class_breakdown: Array[Dictionary] = []
	for class_id in class_wins:
		var rate := float(class_wins[class_id]) / float(class_counts[class_id])
		class_breakdown.append({"class_id": class_id, "win_rate": rate, "sims": class_counts[class_id]})
	class_breakdown.sort_custom(func(a, b): return a["win_rate"] > b["win_rate"])

	# Sort combos for extremes
	combo_results.sort_custom(func(a, b): return a["win_rate"] < b["win_rate"])

	# Per-class banding
	var warn_floor := target - _BattleStages.CLASS_WARN_DELTA
	var fail_floor := target - _BattleStages.CLASS_FAIL_DELTA
	var over_ceiling := target + _BattleStages.TOLERANCE + _BattleStages.CLASS_OVER_DELTA
	var class_bands: Array[Dictionary] = []
	for c in class_breakdown:
		var band := "OK"
		if c["win_rate"] < fail_floor:
			band = "FAIL"
		elif c["win_rate"] < warn_floor:
			band = "WARN"
		elif c["win_rate"] > over_ceiling:
			band = "OVER"
		class_bands.append({"class_id": c["class_id"], "win_rate": c["win_rate"], "band": band})

	# JP economy
	var jp_breakdown: Array[Dictionary] = []
	for cid in class_jp_total:
		var avg_jp := float(class_jp_total[cid]) / float(class_jp_sims[cid])
		var is_identity := XpConfig.CLASS_IDENTITY.has(cid)
		jp_breakdown.append({"class_id": cid, "avg_jp": avg_jp, "identity": is_identity})
	jp_breakdown.sort_custom(func(a, b): return a["avg_jp"] > b["avg_jp"])

	if _verbose:
		_print_stage_detail(battle_id, overall_rate, target, class_breakdown, class_bands, combo_results, jp_breakdown)

	return {
		"battle_id": battle_id, "progression": prog,
		"win_rate": overall_rate, "target": target,
		"total_sims": total_sims, "combos": parties.size(),
		"class_breakdown": class_breakdown, "class_bands": class_bands,
		"jp_breakdown": jp_breakdown,
		"weakest": combo_results.slice(0, 3),
		"strongest": combo_results.slice(maxi(0, combo_results.size() - 3), combo_results.size()),
	}


func _simulate_battle(stage: Dictionary, party: Array, party_level: int, enemy_datas: Array[Dictionary]) -> Dictionary:
	var grid := Grid.new(stage["grid_width"], stage["grid_height"])
	var reaction_sys := _SimReactionSystem.new(grid)
	var executor := _SimExecutor.new(grid, reaction_sys)
	var ai := _SimAI.new(grid, reaction_sys, executor)
	var turn_mgr := _SimTurnManager.new()

	var all_units: Array = []
	var player_units: Array = []
	var spawn_positions: Array = stage["player_spawn"]

	# Create player units
	for i in range(party.size()):
		var class_id: String = party[i]
		var data: FighterData = load("res://resources/classes/%s.tres" % class_id)
		if not data:
			continue
		var unit := _SimUnit.new()
		unit.initialize(data, class_id, Enums.Team.PLAYER, party_level)
		var pos: Vector2i = spawn_positions[i] if i < spawn_positions.size() else Vector2i(0, i)
		unit.grid_position = pos
		grid.set_occupant(pos, unit)
		all_units.append(unit)
		player_units.append(unit)

	# Create enemy units
	for e_def in enemy_datas:
		var unit := _SimUnit.new()
		unit.initialize(e_def["data"], e_def["data"].class_id, Enums.Team.ENEMY, e_def["level"])
		unit.grid_position = e_def["pos"]
		grid.set_occupant(e_def["pos"], unit)
		all_units.append(unit)

	turn_mgr.setup(all_units)
	var result := turn_mgr.run_battle(ai)

	# Collect JP per class
	var jp_per_class: Dictionary = {}
	for unit in player_units:
		jp_per_class[unit.unit_name] = unit.jp_gained

	return {"player_won": result["player_won"], "jp": jp_per_class}


func _print_summary(results: Array[Dictionary], elapsed: float) -> void:
	print("  SIMULATION SUMMARY")
	print("  %-24s %-10s %-10s %-14s %s" % ["Battle", "Win Rate", "Target", "Range", "Status"])
	print("  " + "-".repeat(74))

	var passed := 0
	for r in results:
		var low: float = float(r["target"]) - _BattleStages.TOLERANCE
		var high: float = float(r["target"]) + _BattleStages.TOLERANCE
		var status := "PASS"
		if r["win_rate"] < low:
			status = "TOO HARD"
		elif r["win_rate"] > high:
			status = "TOO EASY"
		else:
			passed += 1

		print("  %-24s %5.1f%%     %5.1f%%     %4.0f%% - %4.0f%%   %s" % [
			r["battle_id"],
			r["win_rate"] * 100.0, r["target"] * 100.0,
			low * 100.0, high * 100.0,
			status,
		])

	print("\n  Passed: %d/%d | Sims/combo: %d | Time: %.1fs" % [
		passed, results.size(), _sims_per_combo, elapsed])

	# Class outliers
	var outliers: Array[Dictionary] = []
	for r in results:
		for cb in r.get("class_bands", []):
			if cb["band"] != "OK":
				outliers.append({"battle": r["battle_id"], "class_id": cb["class_id"],
					"win_rate": cb["win_rate"], "band": cb["band"]})
	if outliers.size() > 0:
		print("\n  CLASS OUTLIERS")
		print("  %-24s %-20s %-10s %s" % ["Battle", "Class", "Win Rate", "Band"])
		print("  " + "-".repeat(64))
		for o in outliers:
			print("  %-24s %-20s %5.1f%%     %s" % [o["battle"], o["class_id"],
				o["win_rate"] * 100.0, o["band"]])


func _print_stage_detail(battle_id: String, rate: float, target: float,
		breakdown: Array[Dictionary], bands: Array[Dictionary],
		combos: Array[Dictionary], jp: Array[Dictionary] = []) -> void:
	print("\n  --- %s (%.1f%% vs %.1f%% target) ---" % [battle_id, rate * 100.0, target * 100.0])

	if combos.size() >= 3:
		print("  WEAKEST:")
		for i in range(mini(3, combos.size())):
			var c := combos[i]
			print("    %5.1f%%  %s" % [c["win_rate"] * 100.0, " / ".join(c["party"])])
		print("  STRONGEST:")
		for i in range(maxi(0, combos.size() - 3), combos.size()):
			var c := combos[i]
			print("    %5.1f%%  %s" % [c["win_rate"] * 100.0, " / ".join(c["party"])])

	var band_map := {}
	for b in bands:
		band_map[b["class_id"]] = b["band"]
	print("  CLASS BREAKDOWN:")
	for c in breakdown.slice(0, 10):
		var band: String = band_map.get(c["class_id"], "OK")
		var suffix := "  <-- %s" % band if band != "OK" else ""
		print("    %-20s %5.1f%%%s" % [c["class_id"], c["win_rate"] * 100.0, suffix])

	if jp.size() > 0:
		print("  JP ECONOMY (avg per battle):")
		for j in jp:
			var tag := "  (identity)" if j["identity"] else ""
			print("    %-20s %4.1f JP%s" % [j["class_id"], j["avg_jp"], tag])


func _list_battles() -> void:
	print("Available battles:")
	for stage in _BattleStages.get_all_stages():
		print("  %-24s Prog %d  Target %.0f%%  Grid %dx%d  Enemies %d" % [
			stage["battle_id"], stage["progression"],
			stage["target"] * 100.0,
			stage["grid_width"], stage["grid_height"],
			stage["enemies"].size(),
		])


func _print_usage() -> void:
	print("Battle Simulator — headless balance testing")
	print("Usage: ... --script res://tools/sim/battle_simulator.gd -- [options]")
	print("  <battle_id>        Simulate a specific battle")
	print("  --all              Simulate all battles")
	print("  --progression N    Simulate all battles in progression N")
	print("  --sims N           Simulations per combo (default: 30)")
	print("  --sample N         Max party combos (default: 200)")
	print("  --verbose          Show per-battle detail")
	print("  --list             List all battles")


func _parse_int_arg(args: Array, flag: String, default: int) -> int:
	var idx := args.find(flag)
	if idx >= 0 and idx + 1 < args.size():
		return int(args[idx + 1])
	return default
