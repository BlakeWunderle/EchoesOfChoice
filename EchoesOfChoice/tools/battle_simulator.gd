extends SceneTree

## CLI tool for running battle simulations.
## Usage: godot --path EchoesOfChoiceGame --headless --script res://tools/battle_simulator.gd -- [args]

const SR := preload("res://scripts/tools/simulation_runner.gd")
const BSDB := preload("res://scripts/tools/battle_stage_db.gd")
const PC := preload("res://scripts/tools/party_composer.gd")


func _init() -> void:
	var stages := BSDB.get_all_stages()
	var args := OS.get_cmdline_user_args()

	var sims_per_combo := 1000
	var auto_sims := false
	var sims_explicit := false
	var run_all := false
	var progression_filter := -1
	var sample_size := 0
	var stage_name := ""

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
			"--progression":
				if i + 1 < args.size():
					progression_filter = int(args[i + 1])
					i += 1
			"--sample":
				if i + 1 < args.size():
					sample_size = int(args[i + 1])
					i += 1
			"--list":
				_print_stage_list(stages)
				quit()
				return
			"--help":
				_print_help()
				quit()
				return
			_:
				if not args[i].begins_with("--"):
					stage_name = args[i]
		i += 1

	if auto_sims and sims_explicit:
		print("Warning: --auto overrides --sims. Using auto-calculated sim counts.\n")

	print("=== Echoes of Choice Battle Simulator ===\n")

	if run_all:
		_run_stages(stages, sims_per_combo, auto_sims, sample_size)
	elif progression_filter >= 0:
		var prog_stages := stages.filter(
			func(s: Dictionary) -> bool: return s.progression_stage == progression_filter)
		if prog_stages.is_empty():
			print("No battles found for progression stage %d.\n" % progression_filter)
			_print_stage_list(stages)
		else:
			_run_stages(prog_stages, sims_per_combo, auto_sims, sample_size)
	elif stage_name != "":
		var stage: Dictionary = {}
		for s: Dictionary in stages:
			if s.name.to_lower() == stage_name.to_lower():
				stage = s
				break
		if stage.is_empty():
			print("Stage '%s' not found.\n" % stage_name)
			_print_stage_list(stages)
		else:
			_run_single(stage, sims_per_combo, auto_sims, sample_size)
	else:
		_print_help()

	quit()


func _run_single(stage: Dictionary, sims_per_combo: int,
		auto_sims: bool, sample_size: int) -> void:
	if auto_sims:
		var parties := SR._get_parties(stage)
		var count: int = mini(sample_size, parties.size()) if sample_size > 0 else parties.size()
		sims_per_combo = SR.calculate_sims_for_party_count(count)
		print("  Auto: %d party combos -> %d sims/combo (%d total battles)" % [
			count, sims_per_combo, count * sims_per_combo])

	print("\nRunning %d sims/combo for %s..." % [sims_per_combo, stage.name])
	var sw := Time.get_ticks_msec()
	var result := SR.simulate_stage(stage, sims_per_combo, sample_size)
	var elapsed := (Time.get_ticks_msec() - sw) / 1000.0

	SR.print_summary([result])
	SR.print_combo_extremes(result)
	SR.print_class_breakdown(result)
	print("\n  Time: %.1fs" % elapsed)


func _run_stages(stages: Array, sims_per_combo: int,
		auto_sims: bool, sample_size: int) -> void:
	for stage: Dictionary in stages:
		var parties := SR._get_parties(stage)
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

		var result := SR.simulate_stage(stage, sims, sample_size)
		results.append(result)
		SR.print_stage_result(result)

	var elapsed := (Time.get_ticks_msec() - sw) / 1000.0
	SR.print_summary(results)

	for r: Dictionary in results:
		print("\n  --- %s ---" % r.stage_name)
		SR.print_combo_extremes(r)
		SR.print_class_breakdown(r)

	print("\n  Total time: %.1fs" % elapsed)


func _print_stage_list(stages: Array) -> void:
	print("  %-25s %6s %8s" % ["Battle", "Stage", "Target"])
	print("  " + "-".repeat(41))
	for s: Dictionary in stages:
		print("  %-25s %6d %7d%%" % [
			s.name, s.progression_stage, int(s.target_win_rate * 100)])


func _print_help() -> void:
	print("Usage: godot --path EchoesOfChoiceGame --headless \\")
	print("       --script res://tools/battle_simulator.gd -- [options] [stage-name]\n")
	print("Options:")
	print("  --sims <n>           Simulations per combo (default: 1000)")
	print("  --auto               Auto-calculate sims to hit 200k+ total battles")
	print("  --sample <n>         Use stratified sample of n party combos")
	print("  --progression <n>    Run all battles in a progression stage")
	print("  --all                Run all battles")
	print("  --list               List available battle stages")
	print("  --help               Show this help\n")
	print("Auto mode sims by tier:")
	print("  Base (35 combos)      -> 5,715 sims/combo = 200k battles")
	print("  Tier 1 (~560 combos)  ->   358 sims/combo = 200k battles")
	print("  Tier 2 (~4960 combos) ->    41 sims/combo = 203k battles\n")
	print("Examples:")
	print("  ... -- CityStreetBattle")
	print("  ... -- --sims 500 WolfForestBattle")
	print("  ... -- --auto --progression 0")
	print("  ... -- --auto --all")
	print("  ... -- --sample 500 --sims 50 --progression 4")
