extends SceneTree

## Parallel battle simulation coordinator.
## Processes one battle at a time; all workers split the party combos for that battle,
## finish quickly, then the coordinator merges and moves to the next battle.
##
## Usage: godot --path PartingShadows --headless \
##        --script res://tools/battle_sim_parallel.gd -- [options]
##
## Options:
##   --jobs <n>      Number of worker processes (default: CPU count, capped at 8 on Windows)
##   --stagger <ms>  Delay in ms between spawning workers (default: 2000)
##   --timeout <s>   Per-battle timeout in seconds (default: 300)
##   All other options are forwarded to battle_simulator.gd workers.

const SR := preload("res://scripts/tools/simulation_runner.gd")
const SC := preload("res://scripts/tools/sim_cache.gd")
const BSDB := preload("res://scripts/tools/battle_stage_db.gd")
const SRep := preload("res://scripts/tools/sim_report.gd")
const SD := preload("res://scripts/tools/sim_diagnostics.gd")
const SRepMD := preload("res://scripts/tools/sim_report_markdown.gd")

const DEFAULT_STAGGER_MS: int = 2000             ## fallback delay if sentinel not received
const DEFAULT_TIMEOUT_SECONDS: int = 300         ## baseline timeout
const PER_BATTLE_TIMEOUT_SEC: int = 300          ## per-battle timeout; workers only run 1/N of one battle
const WINDOWS_MAX_JOBS: int = 8                  ## cap on Windows (imports are now serialized via sentinel)
const PROGRESS_DOT_INTERVAL_MS: int = 5000
const IMPORT_SENTINEL_TIMEOUT_MS: int = 90000    ## max ms to wait for a worker import sentinel

var _json_path := ""
var _markdown_path := ""
var _from_json_path := ""
var _sim_mode := "quick"
var _progressive := false
var _from_prog := 0
var _compact := false
var _run_id: int = 0  ## unique per coordinator invocation — prevents file collisions when two sims run simultaneously


func _init() -> void:
	randomize()  ## ensure unique RNG seed per process (prevents collision when two coordinators start simultaneously)
	_run_id = (Time.get_ticks_msec() ^ randi()) & 0xFFFFFF  ## 24-bit unique ID for this run
	var args := OS.get_cmdline_user_args()
	var jobs: int = OS.get_processor_count()
	var stagger_ms: int = DEFAULT_STAGGER_MS
	var timeout_sec: int = -1  ## -1 = auto-calculate from job count
	var passthrough: Array[String] = []

	# Parse coordinator-specific args; collect the rest for workers.
	var i := 0
	while i < args.size():
		match args[i]:
			"--jobs":
				if i + 1 < args.size():
					jobs = int(args[i + 1])
					i += 1
			"--stagger":
				if i + 1 < args.size():
					stagger_ms = int(args[i + 1])
					i += 1
			"--timeout":
				if i + 1 < args.size():
					timeout_sec = int(args[i + 1])
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
			"--progressive":
				_progressive = true
			"--compact":
				_compact = true
				passthrough.append("--compact")
			"--from":
				if i + 1 < args.size():
					_from_prog = int(args[i + 1])
					i += 1
			_:
				passthrough.append(args[i])
				# Forward the value of flags that take an argument.
				if args[i] in ["--sims", "--sample", "--progression",
						"--story", "--tier", "--difficulty",
						"--player-item", "--party"] and i + 1 < args.size():
					i += 1
					passthrough.append(args[i])
		i += 1

	# Handle --clear-cache directly (utility command, no workers needed).
	if "--clear-cache" in args:
		SC.clear()
		print("Sim cache cleared.")
		quit()
		return

	if "--auto" in passthrough:
		_sim_mode = "full"

	jobs = clampi(jobs, 1, 32)

	## Cap default job count on Windows to reduce Godot startup cache contention.
	if OS.get_name() == "Windows" and not args.has("--jobs"):
		jobs = mini(jobs, WINDOWS_MAX_JOBS)

	## Per-battle timeout: workers only process 1/N of a single battle's combos.
	if timeout_sec < 0:
		timeout_sec = PER_BATTLE_TIMEOUT_SEC

	# Convert existing JSON to markdown without simulating.
	if _from_json_path != "":
		if _markdown_path == "":
			print("ERROR: --from-json requires --markdown <path>")
		else:
			_generate_from_json()
		quit()
		return

	if _progressive:
		_run_progressive(jobs, passthrough, stagger_ms, timeout_sec)
		return

	# Ensure a run mode flag is present so _get_effective_stages can filter correctly.
	if not passthrough.has("--all") and not passthrough.has("--progression") \
			and not passthrough.has("--battles"):
		passthrough.append("--all")

	var effective_stages := _get_effective_stages(passthrough)
	if effective_stages.is_empty():
		print("ERROR: No stages matched the given filters.")
		quit(1)
		return

	print("=== Parallel Battle Simulator ===")
	print("  Workers: %d/battle  Stagger: %dms  Timeout/battle: %ds  Stages: %d" % [
		jobs, stagger_ms, timeout_sec, effective_stages.size()])
	print("  Args: %s\n" % " ".join(passthrough))

	var sw := Time.get_ticks_msec()
	var all_stages := _run_all_per_battle(jobs, effective_stages, passthrough, stagger_ms, timeout_sec)
	var elapsed := (Time.get_ticks_msec() - sw) / 1000.0

	if all_stages.is_empty():
		print("ERROR: No results collected.")
		quit(1)
		return

	# Sort by story then progression stage.
	all_stages.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		if a.story != b.story:
			return a.story < b.story
		return a.progression_stage < b.progression_stage)

	print("  Workers finished in %.1fs\n" % elapsed)

	var pass_count := 0
	var fail_count := 0
	for s: Dictionary in all_stages:
		if s.status == "PASS":
			pass_count += 1
		else:
			fail_count += 1

	if _compact:
		# Compact: one line per stage, only FAIL stages get detail.
		for s: Dictionary in all_stages:
			var line := "  %s: %.1f%% (target %d%%) %s" % [
				s.stage_name, s.overall_win_rate * 100,
				int(s.target_win_rate * 100), s.status]
			print(line)
		print("\n  Results: %d PASS, %d FAIL" % [pass_count, fail_count])
	else:
		# Verbose summary table.
		print("=" .repeat(80))
		print("  PARALLEL SIMULATION SUMMARY (%d workers, %d stages)" % [
			jobs, all_stages.size()])
		print("=" .repeat(80))
		print("  %-25s %10s %10s %14s %12s" % [
			"Battle", "Win Rate", "Target", "Range", "Status"])
		print("  " + "-".repeat(71))

		var total_wr := 0.0
		var total_ms := 0
		for s: Dictionary in all_stages:
			var low: float = s.target_win_rate - 0.03
			var high: float = s.target_win_rate + 0.03
			var range_str := "%d%% - %d%%" % [int(low * 100), int(high * 100)]
			print("  %-25s %9.1f%% %9d%% %14s %12s" % [
				s.stage_name, s.overall_win_rate * 100,
				int(s.target_win_rate * 100), range_str, s.status])
			total_wr += s.overall_win_rate
			total_ms += int(s.get("elapsed_ms", 0))

		print("\n  Passed: %d/%d" % [pass_count, all_stages.size()])
		print("  Average win rate: %.1f%%" % [total_wr / all_stages.size() * 100])
		print("  Worker sim time: %.1fs (sum of all workers)" % [total_ms / 1000.0])
		print("  Wall clock time: %.1fs" % elapsed)
		print("  Speedup: %.1fx" % [total_ms / 1000.0 / maxf(elapsed, 0.001)])

		# Print per-stage class breakdown and equipment breakdown.
		for s: Dictionary in all_stages:
			print("\n--- %s ---" % s.stage_name)
			var breakdown: Dictionary = s.get("class_breakdown", {})
			if not breakdown.is_empty():
				var entries := []
				for cname: String in breakdown:
					entries.append({
						"class": cname,
						"win_rate": breakdown[cname].get("win_rate", 0.0),
						"count": breakdown[cname].get("combo_count", 0),
					})
				entries.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
					return a.win_rate > b.win_rate)
				var warn_thr: float = s.get("target_win_rate", 0.0) * 0.60
				print("\n  CLASS BREAKDOWN:")
				print("    %-22s %10s %8s  %s" % ["Class", "Win Rate", "Combos", "Note"])
				print("    " + "-".repeat(54))
				for e: Dictionary in entries:
					var note: String = "** WEAK **" if e.win_rate < warn_thr else ""
					print("    %-22s %9.1f%% %8d  %s" % [
						e["class"], e.win_rate * 100, e.count, note])
			SR.print_action_breakdown(s)
			SR.print_equipment_breakdown(s)
			SR.print_ultimate_breakdown(s)
			SR.print_charge_analysis(s)
			# Print detailed diagnostics when --diagnostics requested.
			if passthrough.has("--diagnostics"):
				SD.print_diagnostics(s.get("diagnostics", []), s.stage_name)

	_write_outputs(all_stages)
	quit()


## Process each battle sequentially, parallelizing party combos within each battle.
## N workers each run 1/N of the combos for the current battle, finish quickly (~1-3 min),
## then we merge and move on. Avoids the long-running worker timeout issue.
func _run_all_per_battle(jobs: int, stages: Array, passthrough: Array[String],
		stagger_ms: int, timeout_sec: int) -> Array:
	## Build base worker args: strip run-mode flags (--all, --battles, --progression).
	## We add --battles per iteration.
	var base_args: Array[String] = []
	var pi := 0
	while pi < passthrough.size():
		var arg: String = passthrough[pi]
		if arg == "--all":
			pass  ## standalone flag, skip
		elif arg in ["--progression", "--battles"] and pi + 1 < passthrough.size():
			pi += 1  ## skip value; pi++ below skips the flag
		else:
			base_args.append(arg)
		pi += 1

	var all_results: Array = []
	for si in stages.size():
		var stage: Dictionary = stages[si]
		var stage_args: Array[String] = base_args.duplicate()
		stage_args.append("--battles")
		stage_args.append(stage.name)

		printraw("  [%d/%d] %-28s" % [si + 1, stages.size(), stage.name])
		var stage_results := _spawn_and_collect(jobs, stage_args, stagger_ms, timeout_sec)
		if stage_results.is_empty():
			print("  FAIL (timeout or no workers)")
			continue
		var r: Dictionary = stage_results[0]
		print("  %.1f%%  target %d%%  %s" % [
			r.overall_win_rate * 100,
			int(r.get("target_win_rate", 0.0) * 100),
			r.get("status", "?")])
		all_results.append(r)

	return all_results


func _run_progressive(jobs: int, passthrough: Array[String],
		stagger_ms: int, timeout_sec: int) -> void:
	# Build stage list applying same filters workers would use.
	var stages := BSDB.get_all_stages()
	var story_filter := 0
	var tier_filter := ""
	for fi in passthrough.size():
		if passthrough[fi] == "--story" and fi + 1 < passthrough.size():
			story_filter = int(passthrough[fi + 1])
		if passthrough[fi] == "--tier" and fi + 1 < passthrough.size():
			tier_filter = passthrough[fi + 1]
	if story_filter > 0:
		stages = stages.filter(
			func(s: Dictionary) -> bool: return s.story == story_filter)
	if tier_filter != "":
		stages = stages.filter(
			func(s: Dictionary) -> bool: return s.tier == tier_filter)

	# Group by progression.
	var by_prog := {}
	for s: Dictionary in stages:
		var p: int = s.progression_stage
		if p < _from_prog:
			continue
		if not by_prog.has(p):
			by_prog[p] = []
		by_prog[p].append(s)
	var prog_keys: Array = by_prog.keys()
	prog_keys.sort()

	print("=== Parallel Progressive Simulator ===")
	print("  Workers: %d  Stagger: %dms  Timeout: %ds | Progressions: %s\n" % [
		jobs, stagger_ms, timeout_sec, prog_keys])

	var grand_sw := Time.get_ticks_msec()
	var all_stages: Array = []

	for prog: int in prog_keys:
		print("\n" + "=".repeat(60))
		print("  PROGRESSION %d  (%d battles)" % [prog, by_prog[prog].size()])
		print("=".repeat(60))

		# Build worker args for this progression only.
		var prog_args: Array[String] = []
		prog_args.append_array(passthrough)
		prog_args.append("--progression")
		prog_args.append(str(prog))

		var prog_stages := _spawn_and_collect(jobs, prog_args, stagger_ms, timeout_sec)
		if prog_stages.is_empty():
			print("  ERROR: No results for progression %d." % prog)
			print("  Workers likely timed out. Try --stagger 4000 or --jobs 1.")
			break

		all_stages.append_array(prog_stages)

		# Check for failures.
		var failed := []
		for s: Dictionary in prog_stages:
			print("  %s: %.1f%% (%s)" % [
				s.stage_name, s.overall_win_rate * 100, s.status])
			if s.status != "PASS":
				failed.append(s)

		if not failed.is_empty():
			print("\n  PROGRESSION %d FAILED (%d/%d):" % [
				prog, failed.size(), prog_stages.size()])
			for f: Dictionary in failed:
				print("    %s: %.1f%% (target %d%%)" % [
					f.stage_name, f.overall_win_rate * 100,
					int(f.target_win_rate * 100)])
			break
		else:
			print("  PROGRESSION %d: ALL PASS" % prog)

	var elapsed := (Time.get_ticks_msec() - grand_sw) / 1000.0
	_print_progressive_summary(all_stages, elapsed)
	_write_outputs(all_stages)
	quit()


func _spawn_and_collect(jobs: int, passthrough: Array[String],
		stagger_ms: int = DEFAULT_STAGGER_MS,
		timeout_sec: int = DEFAULT_TIMEOUT_SECONDS) -> Array:
	var sim_temp_dir := OS.get_user_data_dir().path_join("sim_temp")
	DirAccess.make_dir_recursive_absolute(sim_temp_dir)

	# Clean up ALL stale sentinels and worker JSON from previous crashed runs.
	var _da := DirAccess.open(sim_temp_dir)
	if _da:
		_da.list_dir_begin()
		var _fname := _da.get_next()
		while _fname != "":
			if (_fname.begins_with("sim_ready_") and _fname.ends_with(".sentinel")) \
					or (_fname.begins_with("sim_worker_") and _fname.ends_with(".json")):
				_da.remove(_fname)
			_fname = _da.get_next()
		_da.list_dir_end()

	var godot_exe := OS.get_executable_path()
	if not godot_exe.contains("_console") and FileAccess.file_exists(
			godot_exe.replace(".exe", "_console.exe")):
		godot_exe = godot_exe.replace(".exe", "_console.exe")

	## Auto-detect split mode: use combo-split when fewer stages than workers.
	var effective_stages := _get_effective_stages(passthrough)
	var use_combo_split: bool = effective_stages.size() > 0 and effective_stages.size() < jobs
	if use_combo_split:
		print("  Mode: combo-split (%d stage(s) across %d workers)" % [
			effective_stages.size(), jobs])
	else:
		print("  Mode: stage-split (%d stages, %d workers)" % [
			effective_stages.size(), jobs])

	var pids: Array[int] = []
	var sentinel_paths: Array[String] = []
	for wi in jobs:
		var worker_json := "user://sim_temp/sim_worker_%d_%d.json" % [_run_id, wi]
		if FileAccess.file_exists(worker_json):
			DirAccess.remove_absolute(
				ProjectSettings.globalize_path(worker_json))

		# Coordinator-controlled sentinel path: avoids PID mismatch between
		# OS.create_process() (wrapper PID) and OS.get_process_id() (engine PID)
		# that occurs because godot_console.exe is a two-process wrapper on Windows.
		var sentinel_path := sim_temp_dir.path_join(
			"sim_ready_w%d_%d.sentinel" % [_run_id, wi])
		DirAccess.remove_absolute(sentinel_path)
		sentinel_paths.append(sentinel_path)

		var worker_args: Array[String] = [
			"--path", ProjectSettings.globalize_path("res://"),
			"--headless",
			"--script", "res://tools/battle_simulator.gd",
			"--",
		]
		worker_args.append_array(passthrough)
		if use_combo_split:
			worker_args.append("--combo-worker")
			worker_args.append("%d/%d" % [wi, jobs])
		else:
			worker_args.append("--worker")
			worker_args.append("%d/%d" % [wi, jobs])
		worker_args.append("--json")
		worker_args.append(worker_json)
		worker_args.append("--sentinel-path")
		worker_args.append(sentinel_path)

		var pid := OS.create_process(godot_exe, worker_args)
		if pid > 0:
			pids.append(pid)
			# Wait for this worker to finish import before spawning the next.
			# Serializes .godot/ write locks so workers don't deadlock on Windows.
			if wi < jobs - 1:
				if not _wait_for_import_sentinel(sentinel_path, pid):
					print("  WARNING: Worker %d import sentinel not received — using stagger fallback" % wi)
					OS.delay_msec(stagger_ms)
		else:
			print("  ERROR: Failed to spawn worker %d" % wi)

	# Wait for all workers with timeout and progress dots.
	var deadline_msec: int = Time.get_ticks_msec() + timeout_sec * 1000
	var last_dot_msec: int = Time.get_ticks_msec()
	var dot_count := 0
	var timed_out := false

	printraw("  Waiting for workers")
	while true:
		var now := Time.get_ticks_msec()
		var still_running := false
		for pid: int in pids:
			if OS.is_process_running(pid):
				still_running = true
				break
		if not still_running:
			print("")
			break
		if now >= deadline_msec:
			print("\n  TIMEOUT: Workers did not finish within %ds." % timeout_sec)
			for pid: int in pids:
				if OS.is_process_running(pid):
					OS.kill(pid)
			timed_out = true
			break
		if now - last_dot_msec >= PROGRESS_DOT_INTERVAL_MS:
			dot_count += 1
			if dot_count % 10 == 0:
				var elapsed_s: int = (now - (deadline_msec - timeout_sec * 1000)) / 1000
				printraw(" %ds" % elapsed_s)
			else:
				printraw(".")
			last_dot_msec = now
		OS.delay_msec(500)

	if timed_out:
		return []

	# Collect results.
	var results: Array = []
	var partials_by_stage: Dictionary = {}
	for wi in jobs:
		var worker_json := "user://sim_temp/sim_worker_%d_%d.json" % [_run_id, wi]
		if not FileAccess.file_exists(worker_json):
			print("  WARNING: Worker %d did not produce output (file missing)" % wi)
			continue
		var file := FileAccess.open(worker_json, FileAccess.READ)
		if file == null:
			print("  WARNING: Worker %d output unreadable" % wi)
			continue
		var json := JSON.new()
		if json.parse(file.get_as_text()) == OK and json.data is Dictionary:
			var data: Dictionary = json.data
			if data.has("stages"):
				results.append_array(data.stages)
			elif data.has("partial_stages"):
				for partial: Dictionary in data.partial_stages:
					var sname: String = partial.get("stage_name", "")
					if sname == "":
						continue
					if not partials_by_stage.has(sname):
						partials_by_stage[sname] = []
					partials_by_stage[sname].append(partial)
			else:
				print("  WARNING: Worker %d JSON missing 'stages' or 'partial_stages' key" % wi)
		else:
			print("  WARNING: Worker %d JSON parse failed" % wi)
		file.close()
		DirAccess.remove_absolute(
			ProjectSettings.globalize_path(worker_json))

	# Merge partial results from combo-split workers.
	if use_combo_split and not partials_by_stage.is_empty():
		for sname: String in partials_by_stage:
			var parts: Array = partials_by_stage[sname]
			if parts.is_empty():
				continue
			var merged := _merge_partial_results(parts)
			var stage_cfg := {}
			for s: Dictionary in effective_stages:
				if s.name == sname:
					stage_cfg = s
					break
			if stage_cfg.is_empty():
				print("  WARNING: No stage config found for merged result '%s'" % sname)
				continue
			results.append(SRep.build_entry(merged, stage_cfg))

	if results.is_empty() and jobs > 0:
		print("  ERROR: All %d workers produced no results." % jobs)
		print("  Godot exe: %s" % godot_exe)

	results.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return a.get("stage_name", "") < b.get("stage_name", ""))
	return results


## Wait for a worker to write its import-done sentinel file.
## battle_simulator.gd writes a sentinel file via absolute path at the top of _init(),
## which only runs after Godot has finished all initialization and released .godot/ locks.
## Returns true when sentinel is found, false on timeout or if process exited early.
## sentinel_path is the absolute path constructed by the coordinator and passed to the
## worker via --sentinel-path, eliminating any PID mismatch.
func _wait_for_import_sentinel(sentinel_path: String, pid: int) -> bool:
	var deadline := Time.get_ticks_msec() + IMPORT_SENTINEL_TIMEOUT_MS
	# OS.is_process_running() races on Windows: a freshly-spawned process may not
	# be visible to OpenProcess() for a short window. Ignore is_process_running
	# results for the first 5s after spawn.
	var min_alive_until := Time.get_ticks_msec() + 5000
	while Time.get_ticks_msec() < deadline:
		if FileAccess.file_exists(sentinel_path):
			DirAccess.remove_absolute(sentinel_path)
			return true
		if Time.get_ticks_msec() > min_alive_until and not OS.is_process_running(pid):
			# Process confirmed exited without writing sentinel (fast finish or crash).
			DirAccess.remove_absolute(sentinel_path)
			return false
		OS.delay_msec(500)
	# Timeout — clean up if the sentinel appeared just after the deadline.
	if FileAccess.file_exists(sentinel_path):
		DirAccess.remove_absolute(sentinel_path)
	return false


func _get_effective_stages(passthrough: Array[String]) -> Array:
	var stages := BSDB.get_all_stages()
	var story_filter := 0
	var tier_filter := ""
	var progression_filter := -1
	var battle_names: Array[String] = []
	for fi in passthrough.size():
		if passthrough[fi] == "--story" and fi + 1 < passthrough.size():
			story_filter = int(passthrough[fi + 1])
		elif passthrough[fi] == "--tier" and fi + 1 < passthrough.size():
			tier_filter = passthrough[fi + 1]
		elif passthrough[fi] == "--progression" and fi + 1 < passthrough.size():
			progression_filter = int(passthrough[fi + 1])
		elif passthrough[fi] == "--battles" and fi + 1 < passthrough.size():
			for bname: String in passthrough[fi + 1].split(","):
				var trimmed := bname.strip_edges()
				if trimmed != "":
					battle_names.append(trimmed.to_lower())
	if story_filter > 0:
		stages = stages.filter(func(s: Dictionary) -> bool: return s.story == story_filter)
	if tier_filter != "":
		stages = stages.filter(func(s: Dictionary) -> bool: return s.tier == tier_filter)
	if progression_filter >= 0:
		stages = stages.filter(
			func(s: Dictionary) -> bool: return s.progression_stage == progression_filter)
	if not battle_names.is_empty():
		stages = stages.filter(
			func(s: Dictionary) -> bool: return s.name.to_lower() in battle_names)
	return stages


func _merge_partial_results(partials: Array) -> Dictionary:
	var merged: Dictionary = (partials[0] as Dictionary).duplicate(true)
	merged["combo_results"] = []
	merged["class_diag"] = {}
	merged["equip_stats"] = {}
	merged["ult_stats"] = {}
	merged["ult_class_map"] = {}
	merged["elapsed_ms"] = 0
	for partial: Dictionary in partials:
		merged.combo_results.append_array(partial.get("combo_results", []))
		merged.elapsed_ms += partial.get("elapsed_ms", 0)
		for cls: String in partial.get("class_diag", {}):
			if not merged.class_diag.has(cls):
				merged.class_diag[cls] = partial.class_diag[cls].duplicate()
			else:
				for key: String in ["dmg_dealt", "dmg_taken", "heals", "deaths", "battles",
					"actions", "dmg_mitigated", "buffs_applied", "debuffs_applied", "charge_gained"]:
					merged.class_diag[cls][key] += partial.class_diag[cls].get(key, 0)
		for eid: String in partial.get("equip_stats", {}):
			var ps: Dictionary = partial.equip_stats[eid]
			if not merged.equip_stats.has(eid):
				merged.equip_stats[eid] = {wins = 0, total = 0}
			merged.equip_stats[eid].wins += ps.get("wins", 0)
			merged.equip_stats[eid].total += ps.get("total", 0)
		for uid: String in partial.get("ult_stats", {}):
			var ps: Dictionary = partial.ult_stats[uid]
			if not merged.ult_stats.has(uid):
				merged.ult_stats[uid] = {wins = 0, total = 0, uses = 0}
			merged.ult_stats[uid].wins += ps.get("wins", 0)
			merged.ult_stats[uid].total += ps.get("total", 0)
			merged.ult_stats[uid].uses += ps.get("uses", 0)
		merged.ult_class_map.merge(partial.get("ult_class_map", {}))
	## Merge turn_stats from all partials.
	var ts_all_sum := 0
	var ts_player_sum := 0
	var ts_battle_count := 0
	var ts_stalemate_count := 0
	var ts_min := 999999
	var ts_max := 0
	var ts_party_size := 3
	var ts_all_sum_w := 0
	var ts_player_sum_w := 0
	var ts_count_w := 0
	var ts_min_w := 999999
	var ts_max_w := 0
	var ts_all_sum_l := 0
	var ts_player_sum_l := 0
	var ts_count_l := 0
	var ts_min_l := 999999
	var ts_max_l := 0
	for partial: Dictionary in partials:
		var ts: Dictionary = partial.get("turn_stats", {})
		ts_all_sum += int(ts.get("_total_all_actions", 0))
		ts_player_sum += int(ts.get("_total_player_actions", 0))
		ts_battle_count += int(ts.get("_total_battle_count", 0))
		ts_stalemate_count += int(ts.get("stalemate_count", 0))
		var pmin: int = int(ts.get("min_all_actions", 999999))
		var pmax: int = int(ts.get("max_all_actions", 0))
		if pmin < ts_min:
			ts_min = pmin
		if pmax > ts_max:
			ts_max = pmax
		ts_party_size = int(ts.get("_party_size", 3))
		var tw: Dictionary = ts.get("wins", {})
		ts_all_sum_w += int(tw.get("_total_all_actions", 0))
		ts_player_sum_w += int(tw.get("_total_player_actions", 0))
		ts_count_w += int(tw.get("_total_battle_count", 0))
		var wmin: int = int(tw.get("min_all_actions", 999999))
		var wmax: int = int(tw.get("max_all_actions", 0))
		if wmin < ts_min_w:
			ts_min_w = wmin
		if wmax > ts_max_w:
			ts_max_w = wmax
		var tl: Dictionary = ts.get("losses", {})
		ts_all_sum_l += int(tl.get("_total_all_actions", 0))
		ts_player_sum_l += int(tl.get("_total_player_actions", 0))
		ts_count_l += int(tl.get("_total_battle_count", 0))
		var lmin: int = int(tl.get("min_all_actions", 999999))
		var lmax: int = int(tl.get("max_all_actions", 0))
		if lmin < ts_min_l:
			ts_min_l = lmin
		if lmax > ts_max_l:
			ts_max_l = lmax
	merged["turn_stats"] = {
		"avg_player_per_char": float(ts_player_sum) / (ts_party_size * ts_battle_count) if ts_battle_count > 0 else 0.0,
		"avg_all_actions": float(ts_all_sum) / ts_battle_count if ts_battle_count > 0 else 0.0,
		"min_all_actions": ts_min if ts_battle_count > 0 else 0,
		"max_all_actions": ts_max if ts_battle_count > 0 else 0,
		"stalemate_rate": float(ts_stalemate_count) / ts_battle_count if ts_battle_count > 0 else 0.0,
		"stalemate_count": ts_stalemate_count,
		"_total_all_actions": ts_all_sum,
		"_total_player_actions": ts_player_sum,
		"_total_battle_count": ts_battle_count,
		"_party_size": ts_party_size,
		"wins": {
			"avg_player_per_char": float(ts_player_sum_w) / (ts_party_size * ts_count_w) if ts_count_w > 0 else 0.0,
			"avg_all_actions": float(ts_all_sum_w) / ts_count_w if ts_count_w > 0 else 0.0,
			"min_all_actions": ts_min_w if ts_count_w > 0 else 0,
			"max_all_actions": ts_max_w if ts_count_w > 0 else 0,
			"_total_all_actions": ts_all_sum_w,
			"_total_player_actions": ts_player_sum_w,
			"_total_battle_count": ts_count_w,
		},
		"losses": {
			"avg_player_per_char": float(ts_player_sum_l) / (ts_party_size * ts_count_l) if ts_count_l > 0 else 0.0,
			"avg_all_actions": float(ts_all_sum_l) / ts_count_l if ts_count_l > 0 else 0.0,
			"min_all_actions": ts_min_l if ts_count_l > 0 else 0,
			"max_all_actions": ts_max_l if ts_count_l > 0 else 0,
			"_total_all_actions": ts_all_sum_l,
			"_total_player_actions": ts_player_sum_l,
			"_total_battle_count": ts_count_l,
		},
	}

	## Merge player item usage stats if present.
	if partials[0].has("player_item"):
		merged["player_item"] = partials[0]["player_item"]
		var item_uses := 0
		var item_battles := 0
		for partial: Dictionary in partials:
			var iu: Dictionary = partial.get("item_usage", {})
			item_uses += int(iu.get("uses", 0))
			item_battles += int(iu.get("total_battles", 0))
		merged["item_usage"] = {
			"uses": item_uses,
			"total_battles": item_battles,
			"use_rate": float(item_uses) / item_battles if item_battles > 0 else 0.0,
		}

	## Merge action counts.
	var agg_ac := {"player": {}, "enemy": {}}
	for partial: Dictionary in partials:
		var pac: Dictionary = partial.get("action_counts", {})
		for side: String in ["player", "enemy"]:
			var src: Dictionary = pac.get(side, {})
			for act: String in src:
				agg_ac[side][act] = agg_ac[side].get(act, 0) + int(src[act])
	merged["action_counts"] = agg_ac

	## Recalculate overall_win_rate as average of combo win_rates (matches simulate_stage).
	var total_wr := 0.0
	for combo: Dictionary in merged.combo_results:
		total_wr += combo.win_rate
	merged["overall_win_rate"] = total_wr / merged.combo_results.size() \
		if not merged.combo_results.is_empty() else 0.0
	merged.erase("combo_worker_index")
	merged.erase("combo_worker_count")
	return merged


func _print_progressive_summary(all_stages: Array, elapsed: float) -> void:
	if all_stages.is_empty():
		return
	print("\n" + "=".repeat(60))
	print("  PROGRESSIVE SUMMARY (%d stages, %.1fs)" % [
		all_stages.size(), elapsed])
	print("=".repeat(60))
	print("  %-25s %10s %10s %12s" % ["Battle", "Win Rate", "Target", "Status"])
	print("  " + "-".repeat(57))
	var pass_count := 0
	for s: Dictionary in all_stages:
		print("  %-25s %9.1f%% %9d%% %12s" % [
			s.stage_name, s.overall_win_rate * 100,
			int(s.target_win_rate * 100), s.status])
		if s.status == "PASS":
			pass_count += 1
	print("\n  Passed: %d/%d" % [pass_count, all_stages.size()])


func _write_outputs(all_stages: Array) -> void:
	if all_stages.is_empty():
		return
	if _json_path != "":
		# Merge with existing JSON: keep old stages, replace matching stage_names
		var new_names := {}
		for s in all_stages:
			new_names[s.stage_name] = true
		var existing_file := FileAccess.open(_json_path, FileAccess.READ)
		if existing_file:
			var json := JSON.new()
			if json.parse(existing_file.get_as_text()) == OK \
					and json.data is Dictionary:
				var old_stages: Array = json.data.get("stages", [])
				for old_s in old_stages:
					if old_s is Dictionary \
							and not new_names.has(old_s.get("stage_name", "")):
						all_stages.append(old_s)
			existing_file.close()
		all_stages.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
			return a.get("stage_name", "") < b.get("stage_name", ""))
		var json_str := JSON.stringify({"stages": all_stages}, "\t")
		var out_file := FileAccess.open(_json_path, FileAccess.WRITE)
		if out_file:
			out_file.store_string(json_str)
			out_file.close()
			print("\n  JSON report written to: %s" % _json_path)
		else:
			print("\n  ERROR: Could not write JSON report to: %s" % _json_path)
	if _markdown_path != "":
		SRepMD.write_markdown(_markdown_path, all_stages, _sim_mode)


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
	SRepMD.write_markdown(_markdown_path, json.data.get("stages", []), "cached")
