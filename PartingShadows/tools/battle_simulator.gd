extends SceneTree

## CLI tool for running battle simulations.
## Usage: godot --path PartingShadowsGame --headless --script res://tools/battle_simulator.gd -- [args]

const SR := preload("res://scripts/tools/simulation_runner.gd")
const BSDB := preload("res://scripts/tools/battle_stage_db.gd")
const PC := preload("res://scripts/tools/party_composer.gd")
const SRep := preload("res://scripts/tools/sim_report.gd")
const SC := preload("res://scripts/tools/sim_cache.gd")
const SP := preload("res://scripts/tools/sim_progressive.gd")
const SD := preload("res://scripts/tools/sim_diagnostics.gd")
const SRepMD := preload("res://scripts/tools/sim_report_markdown.gd")
var _json_path := ""
var _markdown_path := ""
var _from_json_path := ""
var _use_cache := true
var _diagnostics := false
var _compact := false
var _combo_worker_index := -1
var _combo_worker_count := 0
var _combo_worker_mode := false
var _all_results: Array = []
var _all_stages: Array = []
var _exclude_combos: Array[String] = []
var _difficulty_level: int = -1  ## -1 = auto (derive from stage tier)


func _init() -> void:
	# Ensure sim_temp directory exists for cache, reports, and worker files.
	DirAccess.make_dir_recursive_absolute(
		ProjectSettings.globalize_path("user://sim_temp"))

	# Signal to coordinator that Godot initialization (import, class cache) is complete.
	# The coordinator passes --sentinel-path so the file name is coordinator-controlled,
	# avoiding the PID mismatch that occurs because godot_console.exe is a two-process
	# wrapper: OS.create_process() returns the wrapper PID, but OS.get_process_id()
	# inside the actual Godot engine returns a different PID.
	var _args_pre := OS.get_cmdline_user_args()
	for _i in _args_pre.size():
		if _args_pre[_i] == "--sentinel-path" and _i + 1 < _args_pre.size():
			var _rsf := FileAccess.open(_args_pre[_i + 1], FileAccess.WRITE)
			if _rsf:
				_rsf.close()
			break

	var stages := BSDB.get_all_stages()
	var args := OS.get_cmdline_user_args()

	var sims_per_combo := 1000
	var auto_sims := false
	var sims_explicit := false
	var run_all := false
	var run_progressive := false
	var show_list := false
	var show_help := false
	var progression_filter := -1
	var from_progression := 0
	var sample_size := 0
	var stage_name := ""
	var battle_names: Array[String] = []
	var story_filter := 0
	var tier_filter := ""
	var worker_index := -1
	var worker_count := 0

	var i := 0
	while i < args.size():
		match args[i]:
			"--sims":
				if i + 1 < args.size():
					sims_per_combo = int(args[i + 1])
					sims_explicit = true
					i += 1
			"--auto":
				auto_sims = true
			"--all":
				run_all = true
			"--progressive":
				run_progressive = true
			"--from":
				if i + 1 < args.size():
					from_progression = int(args[i + 1])
					i += 1
			"--progression":
				if i + 1 < args.size():
					progression_filter = int(args[i + 1])
					i += 1
			"--sample":
				if i + 1 < args.size():
					sample_size = int(args[i + 1])
					i += 1
			"--story":
				if i + 1 < args.size():
					story_filter = int(args[i + 1])
					i += 1
			"--tier":
				if i + 1 < args.size():
					tier_filter = args[i + 1]
					i += 1
			"--json":
				if i + 1 < args.size():
					_json_path = args[i + 1]
					i += 1
			"--markdown":
				if i + 1 < args.size():
					_markdown_path = args[i + 1]
					i += 1
			"--from-json":
				if i + 1 < args.size():
					_from_json_path = args[i + 1]
					i += 1
			"--worker":
				if i + 1 < args.size():
					var parts := args[i + 1].split("/")
					if parts.size() == 2:
						worker_index = int(parts[0])
						worker_count = int(parts[1])
					i += 1
			"--combo-worker":
				if i + 1 < args.size():
					var parts := args[i + 1].split("/")
					if parts.size() == 2:
						_combo_worker_index = int(parts[0])
						_combo_worker_count = int(parts[1])
					i += 1
			"--battles":
				if i + 1 < args.size():
					for bname: String in args[i + 1].split(","):
						var trimmed := bname.strip_edges()
						if trimmed != "":
							battle_names.append(trimmed)
					i += 1
			"--exclude-combos":
				if i + 1 < args.size():
					for combo: String in args[i + 1].split("|"):
						var trimmed := combo.strip_edges()
						if trimmed != "":
							_exclude_combos.append(trimmed)
					i += 1
			"--sentinel-path":
				i += 1  # already handled above; skip value argument
			"--difficulty":
				if i + 1 < args.size():
					match args[i + 1].to_lower():
						"easy": _difficulty_level = 0
						"hard": _difficulty_level = 2
						_: _difficulty_level = 1
					i += 1
			"--items":
				SR.enable_enemy_items = true
			"--diagnostics":
				_diagnostics = true
			"--compact":
				_compact = true
			"--no-cache":
				_use_cache = false
			"--clear-cache":
				SC.clear()
				print("Sim cache cleared.")
				quit()
				return
			"--list":
				show_list = true
			"--help":
				show_help = true
			_:
				if not args[i].begins_with("--"):
					stage_name = args[i]
		i += 1

	# Convert existing JSON to markdown without simulating.
	if _from_json_path != "":
		if _markdown_path == "":
			print("ERROR: --from-json requires --markdown <path>")
		else:
			_generate_from_json()
		quit()
		return

	if story_filter > 0:
		stages = stages.filter(
			func(s: Dictionary) -> bool: return s.story == story_filter)

	if tier_filter != "":
		stages = stages.filter(
			func(s: Dictionary) -> bool: return s.tier == tier_filter)

	# Worker mode: take only this worker's slice of stages (round-robin).
	var _worker_mode: bool = worker_index >= 0 and worker_count > 0
	if _worker_mode:
		print("  Worker %d/%d starting (pid %d)" % [
			worker_index, worker_count, OS.get_process_id()])
		var my_stages := []
		for si in stages.size():
			if si % worker_count == worker_index:
				my_stages.append(stages[si])
		stages = my_stages

	# Combo-worker mode: process all stages but only 1/N of party combos per stage.
	_combo_worker_mode = _combo_worker_index >= 0 and _combo_worker_count > 1
	if _combo_worker_mode:
		_use_cache = false  ## partial results must not be cached
		print("  Combo-worker %d/%d starting (pid %d)" % [
			_combo_worker_index, _combo_worker_count, OS.get_process_id()])

	if show_list:
		_print_stage_list(stages)
		quit()
		return

	if show_help:
		_print_help()
		quit()
		return

	if auto_sims and sims_explicit and not _worker_mode:
		print("Warning: --auto overrides --sims. Using auto-calculated sim counts.\n")

	if not _worker_mode:
		print("=== Parting Shadows Battle Simulator ===\n")

	if _difficulty_level >= 0:
		SR._get_sim_engine().difficulty_level = _difficulty_level
		if not _worker_mode:
			var diff_names: Array[String] = ["Easy", "Normal", "Hard"]
			print("  Difficulty: %s (override)" % diff_names[_difficulty_level])
	elif not _worker_mode:
		print("  Difficulty: auto (T0=easy, T1=normal, T2=hard)")
	if SR.enable_enemy_items and not _worker_mode:
		print("  Enemy items: ENABLED")
	if not _worker_mode:
		print()

	if run_progressive:
		SP.run(stages, sims_per_combo, auto_sims, sample_size,
			from_progression, _use_cache, _worker_mode, _all_results, _all_stages)
	elif run_all:
		_run_stages(stages, sims_per_combo, auto_sims, sample_size, _worker_mode)
	elif not battle_names.is_empty():
		var matched: Array[Dictionary] = []
		var missing: Array[String] = []
		for bname: String in battle_names:
			var found := false
			for s: Dictionary in stages:
				if s.name.to_lower() == bname.to_lower():
					matched.append(s)
					found = true
					break
			if not found:
				missing.append(bname)
		if not missing.is_empty() and not _worker_mode:
			print("  WARNING: Stages not found: %s" % ", ".join(missing))
		if not matched.is_empty():
			_run_stages(matched, sims_per_combo, auto_sims, sample_size, _worker_mode)
	elif progression_filter >= 0:
		var prog_stages := stages.filter(
			func(s: Dictionary) -> bool: return s.progression_stage == progression_filter)
		if prog_stages.is_empty():
			if not _worker_mode:
				print("No battles found for progression stage %d.\n" % progression_filter)
				_print_stage_list(stages)
		else:
			_run_stages(prog_stages, sims_per_combo, auto_sims, sample_size, _worker_mode)
	elif stage_name != "":
		var stage: Dictionary = {}
		for s: Dictionary in stages:
			if s.name.to_lower() == stage_name.to_lower():
				stage = s
				break
		if stage.is_empty():
			if not _worker_mode:
				print("Stage '%s' not found.\n" % stage_name)
				_print_stage_list(stages)
		else:
			_run_single(stage, sims_per_combo, auto_sims, sample_size, _worker_mode)
	else:
		if not _worker_mode:
			_print_help()

	if not _all_results.is_empty():
		_write_reports(auto_sims)

	SC.save()
	quit()


func _run_single(stage: Dictionary, sims_per_combo: int,
		auto_sims: bool, sample_size: int, quiet: bool = false) -> void:
	if auto_sims:
		var parties := SR._get_parties(stage)
		var count: int = mini(sample_size, parties.size()) if sample_size > 0 else parties.size()
		sims_per_combo = SR.calculate_sims_for_party_count(count)
		if not quiet:
			print("  Auto: %d party combos -> %d sims/combo (%d total battles)" % [
				count, sims_per_combo, count * sims_per_combo])

	var cached := SC.get_cached(stage.name, stage.get("story", 1),
		sims_per_combo, sample_size) if _use_cache else {}

	if not cached.is_empty():
		if not quiet:
			print("\n  %s: cached (%.1f%%, %s)" % [stage.name,
				cached.overall_win_rate * 100, SR.get_status(cached)])
		_all_results.append(cached)
		_all_stages.append(stage)
		return

	# Auto-detect difficulty from stage tier when not overridden
	if _difficulty_level < 0:
		SR._get_sim_engine().difficulty_level = _tier_to_difficulty(stage.get("tier", "base"))

	if not quiet:
		print("\nRunning %d sims/combo for %s..." % [sims_per_combo, stage.name])
	var sw := Time.get_ticks_msec()
	var result := SR.simulate_stage(stage, sims_per_combo, sample_size,
		_combo_worker_index, _combo_worker_count, _exclude_combos)
	var elapsed := (Time.get_ticks_msec() - sw) / 1000.0

	_all_results.append(result)
	_all_stages.append(stage)
	if _use_cache:
		SC.store(stage.name, stage.get("story", 1),
			sims_per_combo, sample_size, result, stage)

	if not quiet:
		if _compact:
			SR.print_stage_compact(result)
			SR.print_summary_compact([result])
			SRep.write_text_report("user://sim_temp/sim_report.txt",
				[result], [stage])
		else:
			SR.print_summary([result])
			SR.print_combo_extremes(result)
			SR.print_class_breakdown(result)
			if _diagnostics:
				var diags := SD.analyze(result, stage)
				SD.print_diagnostics(diags, stage.name)
			print("\n  Time: %.1fs" % elapsed)


func _run_stages(stages: Array, sims_per_combo: int,
		auto_sims: bool, sample_size: int, quiet: bool = false) -> void:
	if not quiet and not _compact:
		for stage: Dictionary in stages:
			var parties := SR._get_parties(stage)
			if not _exclude_combos.is_empty():
				var excl := {}
				for e: String in _exclude_combos:
					excl[e] = true
				parties = parties.filter(func(p: Dictionary) -> bool:
					return not excl.has(PC.get_party_description(p)))
			var count: int = mini(sample_size, parties.size()) if sample_size > 0 else parties.size()
			var sims: int = SR.calculate_sims_for_party_count(count) if auto_sims else sims_per_combo
			var sample_note: String = " (sampled from %d)" % parties.size() \
				if sample_size > 0 and count < parties.size() else ""
			print("  %s: %d combos%s x %d sims = %d battles" % [
				stage.name, count, sample_note, sims, count * sims])
		print()

	var results := []
	var sw := Time.get_ticks_msec()

	for stage: Dictionary in stages:
		if not quiet and not _compact:
			print("\n" + "=".repeat(60))
			print("  SIMULATING: %s" % stage.name)
			print("=".repeat(60))

		var sims: int
		if auto_sims:
			var parties := SR._get_parties(stage)
			var count: int = mini(sample_size, parties.size()) if sample_size > 0 else parties.size()
			sims = SR.calculate_sims_for_party_count(count)
		else:
			sims = sims_per_combo

		# Auto-detect difficulty from stage tier when not overridden
		if _difficulty_level < 0:
			SR._get_sim_engine().difficulty_level = _tier_to_difficulty(stage.get("tier", "base"))

		var cached := SC.get_cached(stage.name, stage.get("story", 1),
			sims, sample_size) if _use_cache else {}
		var result: Dictionary
		if not cached.is_empty():
			result = cached
			if not quiet and not _compact:
				print("  (cached: %.1f%%, %s)" % [
					result.overall_win_rate * 100, SR.get_status(result)])
		else:
			result = SR.simulate_stage(stage, sims, sample_size,
				_combo_worker_index, _combo_worker_count, _exclude_combos)
			if _use_cache:
				SC.store(stage.name, stage.get("story", 1),
					sims, sample_size, result, stage)
			if not quiet and not _compact:
				SR.print_stage_result(result)
		if not quiet and _compact:
			SR.print_stage_compact(result)
		results.append(result)
		_all_results.append(result)
		_all_stages.append(stage)

	var elapsed := (Time.get_ticks_msec() - sw) / 1000.0
	if not quiet:
		if _compact:
			SR.print_summary_compact(results)
			SRep.write_text_report("user://sim_temp/sim_report.txt",
				results, stages)
		else:
			SR.print_summary(results)
			for idx in results.size():
				var r: Dictionary = results[idx]
				print("\n  --- %s ---" % r.stage_name)
				SR.print_combo_extremes(r)
				SR.print_class_breakdown(r)
				if _diagnostics:
					var diags := SD.analyze(r, stages[idx])
					SD.print_diagnostics(diags, r.stage_name)
			print("\n  Total time: %.1fs" % elapsed)


func _write_reports(auto: bool) -> void:
	if _combo_worker_mode:
		## Write raw simulate_stage() results tagged with worker identity.
		## The coordinator merges these partial_stages and calls build_entry() itself.
		if _json_path != "":
			var raw := []
			for idx in _all_results.size():
				var entry: Dictionary = _all_results[idx].duplicate()
				entry["combo_worker_index"] = _combo_worker_index
				entry["combo_worker_count"] = _combo_worker_count
				raw.append(entry)
			var json_str := JSON.stringify({"partial_stages": raw}, "\t")
			var file := FileAccess.open(_json_path, FileAccess.WRITE)
			if file:
				file.store_string(json_str)
				file.close()
		return
	var entries := []
	for idx in _all_results.size():
		entries.append(SRep.build_entry(_all_results[idx], _all_stages[idx]))
	if _json_path != "":
		SRep.write_json(_json_path, entries)
	if _markdown_path != "":
		SRepMD.write_markdown(_markdown_path, entries,
			"full" if auto else "quick")


func _generate_from_json() -> void:
	var file := FileAccess.open(_from_json_path, FileAccess.READ)
	if file == null:
		print("ERROR: Could not read: %s" % _from_json_path)
		return
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK or not json.data is Dictionary:
		print("ERROR: Invalid JSON in: %s" % _from_json_path)
		return
	file.close()
	SRepMD.write_markdown(
		_markdown_path, json.data.get("stages", []), "cached")


func _print_stage_list(stages: Array) -> void:
	print("  %-25s %6s %6s %8s" % ["Battle", "Story", "Stage", "Target"])
	print("  " + "-".repeat(49))
	for s: Dictionary in stages:
		print("  %-25s %6d %6d %7d%%" % [
			s.name, s.get("story", 1), s.progression_stage,
			int(s.target_win_rate * 100)])


func _print_help() -> void:
	print("Usage: godot --path PartingShadowsGame --headless \\")
	print("       --script res://tools/battle_simulator.gd -- [options] [stage-name]\n")
	print("Options:")
	print("  --sims <n>           Simulations per combo (default: 1000)")
	print("  --auto               Auto-calculate sims to hit 200k+ total battles")
	print("  --sample <n>         Use stratified sample of n party combos")
	print("  --progression <n>    Run all battles in a progression stage")
	print("  --story <n>          Filter to story 1, 2, or 3")
	print("  --tier <t>           Filter to tier (base, tier1, tier2)")
	print("  --progressive        Run all battles progression-by-progression, stop on failure")
	print("  --from <n>           Start progressive run from progression n (default: 0)")
	print("  --all                Run all battles")
	print("  --battles <a,b,...>   Run specific battles (comma-separated names)")
	print("  --json <path>        Write structured JSON report to file")
	print("  --markdown <path>    Write markdown class balance report to file")
	print("  --from-json <path>   Read existing JSON, convert to markdown (requires --markdown)")
	print("  --worker <N/M>       Worker mode: run stage slice N of M (used by parallel coordinator)")
	print("  --combo-worker <N/M> Combo-worker mode: run 1/M of party combos per stage (used by parallel coordinator)")
	print("  --compact            Minimal output (1 line/PASS, details to file)")
	print("  --difficulty <mode>   AI difficulty: easy, normal, hard (default: auto by tier)")
	print("  --items              Enable enemy battle items (compare baseline vs items)")
	print("  --diagnostics        Show detailed analysis of WEAK classes")
	print("  --no-cache           Skip cache lookups, force re-simulation")
	print("  --clear-cache        Delete cached results and exit")
	print("  --list               List available battle stages")
	print("  --help               Show this help\n")
	print("Auto mode sims by tier (capped at 500/combo):")
	print("  Base (56 combos)      ->   500 sims/combo =  28k battles")
	print("  Tier 1 (~816 combos)  ->   246 sims/combo = 200k battles")
	print("  Tier 2 (~8436 combos) ->    40 sims/combo = 337k battles\n")
	print("Examples:")
	print("  ... -- CityStreetBattle")
	print("  ... -- --sims 500 WolfForestBattle")
	print("  ... -- --auto --progression 0")
	print("  ... -- --auto --all")
	print("  ... -- --story 1 --auto --all")
	print("  ... -- --story 2 --sims 50 --progression 0")
	print("  ... -- --sample 500 --sims 50 --progression 4")
	print("  ... -- --progressive --story 1 --auto --sample 100")
	print("  ... -- --progressive --from 3 --story 2 --sims 50")
	print("  ... -- --auto --battles S3_DreamShadowChase,S3_DreamLabyrinth,S3_DreamNightmare")


static func _tier_to_difficulty(tier: String) -> int:
	## Maps stage tier to enemy AI difficulty: base=0 (easy), tier1=1 (normal), tier2=2 (hard).
	match tier:
		"tier1": return 1
		"tier2": return 2
	return 0
