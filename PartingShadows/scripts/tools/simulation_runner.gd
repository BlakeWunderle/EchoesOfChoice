class_name SimulationRunner

## Runs automated battles and reports win rates for balance testing.
## Port of C# PartingShadows/BattleSimulator/SimulationRunner.cs.

const BattleEngine := preload("res://scripts/battle/battle_engine.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")
const PC := preload("res://scripts/tools/party_composer.gd")
const BSDB := preload("res://scripts/tools/battle_stage_db.gd")
const EnemyItemDB := preload("res://scripts/data/enemy_item_db.gd")
const EquipmentData := preload("res://scripts/data/equipment_data.gd")

const MIN_TOTAL_BATTLES := 200_000
const MIN_SIMS_PER_COMBO := 40
const MAX_SIMS_PER_COMBO := 500
const TOLERANCE := 0.03
const MAX_TICKS := 500
const CLASS_BAND := {"base": 0.15, "tier1": 0.125, "tier2": 0.10}

## Stalemate detection: if enemy HP doesn't decrease by STALEMATE_HP_THRESHOLD
## of starting total per STALEMATE_CHECK_INTERVAL ticks for STALEMATE_MAX_PERIODS
## consecutive periods, the battle ends as a loss.
const STALEMATE_CHECK_INTERVAL := 40
const STALEMATE_HP_THRESHOLD := 0.03
const STALEMATE_MAX_PERIODS := 3

static var _sim_engine: BattleEngine = null
static var enable_enemy_items: bool = false  ## Set via --items flag


static func _get_sim_engine() -> BattleEngine:
	if _sim_engine == null:
		_sim_engine = BattleEngine.new()
		_sim_engine.sim_mode = true
	return _sim_engine


static func calculate_sims_for_party_count(party_count: int) -> int:
	if party_count <= 0:
		return MIN_SIMS_PER_COMBO
	var sims := ceili(float(MIN_TOTAL_BATTLES) / party_count)
	return clampi(sims, MIN_SIMS_PER_COMBO, MAX_SIMS_PER_COMBO)


# =============================================================================
# Core battle loop
# =============================================================================

static func run_single_battle(party: Array, enemies: Array,
		engine: BattleEngine = null) -> Dictionary:
	if engine == null:
		engine = BattleEngine.new()
	if engine.sim_mode:
		engine.start_battle_sim(party, enemies)
	else:
		engine.start_battle(party, enemies)
	var ticks := 0
	var player_actions := 0
	var all_actions := 0
	var unit_actions: Dictionary = {}  # FighterData -> int

	var enemy_start_hp := 0.0
	for e: FighterData in enemies:
		enemy_start_hp += e.max_health
	var stale_threshold := enemy_start_hp * STALEMATE_HP_THRESHOLD
	var stale_hp_snapshot := enemy_start_hp
	var stale_interval_ticks := 0
	var stale_count := 0

	while not engine.is_battle_over() and ticks < MAX_TICKS:
		ticks += 1
		engine.tick_atb_fast()
		for actor: FighterData in engine.get_acting_units():
			if engine.is_battle_over():
				break
			engine.reset_modified_stat(actor)
			var is_player := engine.units.has(actor)
			var targets: Array = engine.enemies if is_player else engine.units
			var allies: Array = engine.units if is_player else engine.enemies
			if targets.is_empty():
				break
			engine.execute_ai_turn(actor, targets, allies)
			all_actions += 1
			unit_actions[actor] = unit_actions.get(actor, 0) + 1
			if is_player:
				player_actions += 1
			engine.check_for_death()
		engine.reset_turns()

		stale_interval_ticks += 1
		if stale_interval_ticks >= STALEMATE_CHECK_INTERVAL:
			stale_interval_ticks = 0
			var current_enemy_hp := 0.0
			for e: FighterData in engine.enemies:
				current_enemy_hp += e.health
			if stale_hp_snapshot - current_enemy_hp < stale_threshold:
				stale_count += 1
				if stale_count >= STALEMATE_MAX_PERIODS:
					break
			else:
				stale_count = 0
			stale_hp_snapshot = current_enemy_hp

	var stalemate := not engine.is_battle_over()
	return {
		"won": engine.did_player_win(),
		"stalemate": stalemate,
		"player_actions": player_actions,
		"all_actions": all_actions,
		"unit_actions": unit_actions,
	}


# =============================================================================
# Stage simulation
# =============================================================================

static func _get_parties(stage: Dictionary) -> Array:
	match stage.tier:
		"base": return PC.get_base_parties()
		"tier1": return PC.get_tier1_parties()
		"tier2": return PC.get_tier2_parties()
		_: return PC.get_base_parties()


static func _clone_fighters(template: Array) -> Array:
	var result := []
	for f: FighterData in template:
		result.append(f.clone())
	return result


static func simulate_stage(stage: Dictionary, sims_per_combo: int,
		sample_size: int = 0,
		combo_worker_index: int = -1, combo_worker_count: int = 0,
		exclude_combos: Array[String] = []) -> Dictionary:
	var parties := _get_parties(stage)
	if sample_size > 0:
		parties = PC.sample_parties(parties, sample_size)
	if combo_worker_index >= 0 and combo_worker_count > 1:
		var my_parties := []
		for pi in parties.size():
			if pi % combo_worker_count == combo_worker_index:
				my_parties.append(parties[pi])
		parties = my_parties
	if not exclude_combos.is_empty():
		var exclude_set := {}
		for e: String in exclude_combos:
			exclude_set[e] = true
		parties = parties.filter(func(p: Dictionary) -> bool:
			return not exclude_set.has(PC.get_party_description(p)))

	var combo_results := []
	var class_diag := {}
	var equip_stats := {}  ## { "physical_weapon": {wins: int, total: int}, ... }
	var start_ms := Time.get_ticks_msec()
	var engine := _get_sim_engine()
	var turn_all_sum := 0
	var turn_player_sum := 0
	var turn_min := 999999
	var turn_max := 0
	var turn_battle_count := 0
	var stalemate_count := 0
	var party_size := 3

	for pi in parties.size():
		var party_def: Dictionary = parties[pi]
		var wins := 0
		# Create enemy template once per combo; clone per sim to avoid
		# the full factory dispatch on every iteration.
		var enemy_template: Array = BSDB.create_enemies(stage.name)
		for si in sims_per_combo:
			var party_fighters := PC.create_party(party_def, stage.level_ups, stage.get("equip_upgrades", 0))
			var all_party := party_fighters.duplicate()  # snapshot before battle mutates array
			party_size = party_fighters.size()
			var enemies: Array = _clone_fighters(enemy_template)
			if enable_enemy_items:
				engine.enemy_shared_items = EnemyItemDB.get_battle_items(stage.name)
			else:
				engine.enemy_shared_items.clear()
			var br: Dictionary = run_single_battle(party_fighters, enemies, engine)
			if br.won:
				wins += 1
			if br.get("stalemate", false):
				stalemate_count += 1
			turn_all_sum += br.all_actions
			turn_player_sum += br.player_actions
			turn_min = mini(turn_min, br.all_actions)
			turn_max = maxi(turn_max, br.all_actions)
			turn_battle_count += 1
			# Accumulate per-class combat diagnostics.
			for f: FighterData in all_party:
				var ct: String = f.character_type
				if not class_diag.has(ct):
					class_diag[ct] = {dmg_dealt = 0, dmg_taken = 0,
						heals = 0, deaths = 0, battles = 0, actions = 0, dmg_mitigated = 0,
					buffs_applied = 0, debuffs_applied = 0}
				var ss: Dictionary = engine.sim_stats.get(f, {})
				class_diag[ct].dmg_dealt += ss.get("dmg_dealt", 0)
				class_diag[ct].dmg_taken += ss.get("dmg_taken", 0)
				class_diag[ct].heals += ss.get("heals", 0)
				class_diag[ct].deaths += 1 if ss.get("died", false) else 0
				class_diag[ct].battles += 1
				class_diag[ct].actions += br.unit_actions.get(f, 0)
				class_diag[ct].dmg_mitigated += ss.get("dmg_mitigated", 0)
				class_diag[ct].buffs_applied += ss.get("buffs_applied", 0)
				class_diag[ct].debuffs_applied += ss.get("debuffs_applied", 0)
				# Accumulate per-equipment-piece win rates.
				for equip: EquipmentData in f.equipment:
					var eid: String = equip.base_id
					if not equip_stats.has(eid):
						equip_stats[eid] = {wins = 0, total = 0}
					equip_stats[eid].total += 1
					if br.won:
						equip_stats[eid].wins += 1

		combo_results.append({
			"description": PC.get_party_description(party_def),
			"wins": wins,
			"losses": sims_per_combo - wins,
			"total": sims_per_combo,
			"win_rate": float(wins) / sims_per_combo,
		})

		if (pi + 1) % 100 == 0:
			print("  ... %d / %d combos" % [pi + 1, parties.size()])

	combo_results.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return a.win_rate < b.win_rate)

	var total_wr := 0.0
	for c: Dictionary in combo_results:
		total_wr += c.win_rate
	var overall_wr: float = total_wr / combo_results.size() if not combo_results.is_empty() else 0.0

	var avg_player_per_char := (float(turn_player_sum) / (party_size * turn_battle_count)
		if turn_battle_count > 0 else 0.0)
	var avg_all := float(turn_all_sum) / turn_battle_count if turn_battle_count > 0 else 0.0

	return {
		"stage_name": stage.name,
		"target_win_rate": stage.target_win_rate,
		"progression_stage": stage.progression_stage,
		"tier": stage.get("tier", "base"),
		"combo_results": combo_results,
		"overall_win_rate": overall_wr,
		"elapsed_ms": Time.get_ticks_msec() - start_ms,
		"class_diag": class_diag,
		"equip_stats": equip_stats,
		"turn_stats": {
			"avg_player_per_char": avg_player_per_char,
			"avg_all_actions": avg_all,
			"min_all_actions": turn_min if turn_battle_count > 0 else 0,
			"max_all_actions": turn_max if turn_battle_count > 0 else 0,
			"stalemate_rate": float(stalemate_count) / turn_battle_count if turn_battle_count > 0 else 0.0,
			"stalemate_count": stalemate_count,
			"_total_all_actions": turn_all_sum,
			"_total_player_actions": turn_player_sum,
			"_total_battle_count": turn_battle_count,
			"_party_size": party_size,
		},
	}


# =============================================================================
# Output formatting
# =============================================================================

static func get_status(result: Dictionary) -> String:
	var low: float = result.target_win_rate - TOLERANCE
	var high: float = result.target_win_rate + TOLERANCE
	if result.overall_win_rate >= low and result.overall_win_rate <= high:
		return "PASS"
	if result.overall_win_rate < low:
		return "TOO HARD"
	return "TOO EASY"


static func print_stage_result(result: Dictionary) -> void:
	var combos: Array = result.combo_results
	print("  Combos tested: %d" % combos.size())
	print("  Time: %dms" % result.elapsed_ms)
	print("  Overall win rate: %.1f%%" % [result.overall_win_rate * 100])
	print("  Target: %d%% (+/- %d%%)" % [
		int(result.target_win_rate * 100), int(TOLERANCE * 100)])
	var ts: Dictionary = result.get("turn_stats", {})
	if not ts.is_empty():
		var stale_str := ""
		if ts.get("stalemate_rate", 0.0) > 0.0:
			stale_str = "  stalemates %.2f%% (%d)" % [ts.stalemate_rate * 100, ts.get("stalemate_count", 0)]
		print("  Battle length: %.1f turns/char  (%.1f total avg, min %d, max %d)%s" % [
			ts.avg_player_per_char, ts.avg_all_actions,
			ts.min_all_actions, ts.max_all_actions, stale_str])
	print_combo_extremes(result)
	print_class_breakdown(result)
	print_equipment_breakdown(result)
	print("\n  STATUS: %s" % get_status(result))


static func get_combo_extremes(result: Dictionary, count: int = 5) -> Dictionary:
	var sorted: Array = result.combo_results
	if sorted.is_empty():
		return {"worst": [], "best": []}
	var worst := sorted.slice(0, mini(count, sorted.size()))
	var best := sorted.slice(maxi(0, sorted.size() - count), sorted.size())
	return {"worst": worst, "best": best}


static func get_spread(result: Dictionary) -> Dictionary:
	var sorted: Array = result.combo_results
	if sorted.is_empty():
		return {"full_spread": 0.0, "core_spread": 0.0, "p10": 0.0, "p90": 0.0, "verdict": "N/A"}
	var worst_wr: float = sorted[0].win_rate
	var best_wr: float = sorted[-1].win_rate
	var full_spread: float = best_wr - worst_wr
	var p10_idx := mini(int(sorted.size() * 0.10), sorted.size() - 1)
	var p90_idx := mini(int(sorted.size() * 0.90), sorted.size() - 1)
	var p10: float = sorted[p10_idx].win_rate
	var p90: float = sorted[p90_idx].win_rate
	var core_spread: float = p90 - p10
	var verdict: String
	if core_spread < 0.15:
		verdict = "EXCELLENT"
	elif core_spread < 0.25:
		verdict = "ACCEPTABLE"
	elif core_spread < 0.40:
		verdict = "CONCERNING"
	else:
		verdict = "CRITICAL"
	return {"full_spread": full_spread, "core_spread": core_spread, "p10": p10, "p90": p90, "verdict": verdict}


static func get_class_breakdown(result: Dictionary) -> Dictionary:
	var class_stats := {}
	for combo: Dictionary in result.combo_results:
		for cname: String in combo.description.split(" / "):
			if not class_stats.has(cname):
				class_stats[cname] = {"wins": 0, "total": 0, "count": 0}
			class_stats[cname].wins += combo.wins
			class_stats[cname].total += combo.total
			class_stats[cname].count += 1
	var breakdown := {}
	for cname: String in class_stats:
		var s: Dictionary = class_stats[cname]
		breakdown[cname] = {
			"wins": s.wins,
			"total": s.total,
			"win_rate": float(s.wins) / s.total if s.total > 0 else 0.0,
			"combo_count": s.count,
		}
	return breakdown


static func print_combo_extremes(result: Dictionary, count: int = 5) -> void:
	var extremes := get_combo_extremes(result, count)
	if extremes.worst.is_empty():
		return
	var spread := get_spread(result)

	print("\n  WEAKEST COMBOS:")
	for c: Dictionary in extremes.worst:
		print("    %.1f%%  %s" % [c.win_rate * 100, c.description])

	print("\n  STRONGEST COMBOS:")
	for c: Dictionary in extremes.best:
		print("    %.1f%%  %s" % [c.win_rate * 100, c.description])

	print("\n  FULL SPREAD (min-max): %.1f%%" % [spread.full_spread * 100])
	print("  CORE SPREAD (p10-p90): %.1f%% (%s)  [p10=%.1f%%, p90=%.1f%%]" % [
		spread.core_spread * 100, spread.verdict, spread.p10 * 100, spread.p90 * 100])


static func print_class_breakdown(result: Dictionary) -> void:
	var breakdown := get_class_breakdown(result)
	var diag: Dictionary = result.get("class_diag", {})
	var entries := []
	for cname: String in breakdown:
		var d: Dictionary = diag.get(cname, {})
		var avg_acts: float = (float(d.get("actions", 0)) / float(d.get("battles", 1))
			if d.get("battles", 0) > 0 else 0.0)
		entries.append({
			"class": cname,
			"win_rate": breakdown[cname].win_rate,
			"count": breakdown[cname].combo_count,
			"avg_acts": avg_acts,
		})
	entries.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return a.win_rate > b.win_rate)

	print("\n  CLASS BREAKDOWN:")
	print("    %-22s %10s %8s %8s  %s" % ["Class", "Win Rate", "Combos", "AvgActs", "Note"])
	print("    " + "-".repeat(62))

	var warn_threshold: float = result.target_win_rate * 0.60
	for e: Dictionary in entries:
		var note: String = "** WEAK **" if e.win_rate < warn_threshold else ""
		print("    %-22s %9.1f%% %8d %8.1f  %s" % [
			e["class"], e.win_rate * 100, e.count, e.avg_acts, note])

	# Combat stats section (all classes).
	print("
  COMBAT STATS (avg per battle):")
	print("    %-22s %8s %8s %10s %8s" % ["Class", "Dealt", "Taken", "Mitigated", "Heals"])
	print("    " + "-".repeat(62))
	for e: Dictionary in entries:
		var d: Dictionary = diag.get(e["class"], {})
		var battles: int = d.get("battles", 0)
		if battles == 0:
			continue
		var avg_dealt: float = float(d.get("dmg_dealt", 0)) / battles
		var avg_taken: float = float(d.get("dmg_taken", 0)) / battles
		var avg_mitigated: float = float(d.get("dmg_mitigated", 0)) / battles
		var avg_heals: float = float(d.get("heals", 0)) / battles
		print("    %-22s %8.1f %8.1f %10.1f %8.1f" % [
			e["class"], avg_dealt, avg_taken, avg_mitigated, avg_heals])


static func get_equipment_breakdown(result: Dictionary) -> Dictionary:
	var es: Dictionary = result.get("equip_stats", {})
	if es.is_empty():
		return {}
	var slots := {"Weapon": [], "Armor": [], "Boots": []}
	for eid: String in es:
		var s: Dictionary = es[eid]
		var wr: float = float(s.wins) / s.total if s.total > 0 else 0.0
		var entry := {"id": eid, "win_rate": wr, "total": s.total}
		if eid.ends_with("_weapon"):
			slots["Weapon"].append(entry)
		elif eid.ends_with("_armor"):
			slots["Armor"].append(entry)
		elif eid.ends_with("_boots"):
			slots["Boots"].append(entry)
	for slot_entries: Array in slots.values():
		slot_entries.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
			return a.win_rate > b.win_rate)
	return slots


static func print_equipment_breakdown(result: Dictionary) -> void:
	var slots := get_equipment_breakdown(result)
	if slots.is_empty():
		return
	print("\n  EQUIPMENT BREAKDOWN:")
	print("    %-22s %10s %10s  %s" % ["Piece", "Win Rate", "Battles", "Note"])
	print("    " + "-".repeat(56))
	for slot_name: String in ["Weapon", "Armor", "Boots"]:
		var entries: Array = slots[slot_name]
		if entries.is_empty():
			continue
		var slot_avg := 0.0
		for e: Dictionary in entries:
			slot_avg += e.win_rate
		slot_avg /= entries.size()
		for e: Dictionary in entries:
			var diff: float = (e.win_rate - slot_avg) * 100
			var note := ""
			if absf(diff) > 5.0:
				note = "** %+.1fpp **" % diff
			elif absf(diff) > 3.0:
				note = "(%+.1fpp)" % diff
			print("    %-22s %9.1f%% %10d  %s" % [
				e.id, e.win_rate * 100, e.total, note])
		print("    %-22s %9.1f%% %10s" % [
			"  [%s avg]" % slot_name, slot_avg * 100, ""])


static func print_summary(results: Array) -> void:
	print("\n" + "=".repeat(80))
	print("  SIMULATION SUMMARY")
	print("=".repeat(80))
	print("  %-25s %10s %10s %14s %12s" % [
		"Battle", "Win Rate", "Target", "Range", "Status"])
	print("  " + "-".repeat(71))

	for r: Dictionary in results:
		var low: float = r.target_win_rate - TOLERANCE
		var high: float = r.target_win_rate + TOLERANCE
		var range_str := "%d%% - %d%%" % [int(low * 100), int(high * 100)]
		print("  %-25s %9.1f%% %9d%% %14s %12s" % [
			r.stage_name, r.overall_win_rate * 100,
			int(r.target_win_rate * 100), range_str, get_status(r)])

	var total_wr := 0.0
	var pass_count := 0
	for r: Dictionary in results:
		total_wr += r.overall_win_rate
		if get_status(r) == "PASS":
			pass_count += 1

	print("\n  Passed: %d/%d" % [pass_count, results.size()])
	print("  Average win rate: %.1f%%" % [total_wr / results.size() * 100])
	print("  Tolerance: +/- %d%%" % int(TOLERANCE * 100))


# =============================================================================
# Compact output (minimal context footprint)
# =============================================================================

## Print a single stage result in compact form: 1 line for PASS, 3-5 for FAIL.
static func print_stage_compact(result: Dictionary) -> void:
	var status := get_status(result)
	var line := "  %s: %.1f%% (target %d%%) %s" % [
		result.stage_name, result.overall_win_rate * 100,
		int(result.target_win_rate * 100), status]
	print(line)
	var ts_c: Dictionary = result.get("turn_stats", {})
	if ts_c.get("stalemate_rate", 0.0) > 0.0:
		print("    Stalemates: %.2f%% (%d battles)" % [
			ts_c.stalemate_rate * 100, ts_c.get("stalemate_count", 0)])
	if status == "PASS":
		return
	# Show weak classes below the tier-specific band floor.
	var breakdown := get_class_breakdown(result)
	var tier: String = result.get("tier", "base")
	var band_width: float = CLASS_BAND.get(tier, 0.15)
	var band_floor: float = result.target_win_rate - band_width
	var weak: PackedStringArray = []
	for cname: String in breakdown:
		if breakdown[cname].win_rate < band_floor:
			weak.append("%s %.1f%%" % [cname, breakdown[cname].win_rate * 100])
	if not weak.is_empty():
		print("    Weak: %s" % ", ".join(weak))
	var spread := get_spread(result)
	if spread.verdict != "EXCELLENT" and spread.verdict != "ACCEPTABLE":
		print("    Core spread: %.1f%% (%s)" % [
			spread.core_spread * 100, spread.verdict])


## Print a summary of all results in compact form.
static func print_summary_compact(results: Array) -> void:
	var pass_count := 0
	var fail_count := 0
	for r: Dictionary in results:
		if get_status(r) == "PASS":
			pass_count += 1
		else:
			fail_count += 1
	print("\n  Results: %d PASS, %d FAIL" % [pass_count, fail_count])


## Build verbose text lines for a single stage result (for file-based report).
static func format_stage_verbose(result: Dictionary) -> PackedStringArray:
	var lines := PackedStringArray()
	var combos: Array = result.combo_results
	lines.append("  Combos tested: %d" % combos.size())
	lines.append("  Time: %dms" % result.elapsed_ms)
	lines.append("  Overall win rate: %.1f%%" % [result.overall_win_rate * 100])
	lines.append("  Target: %d%% (+/- %d%%)" % [
		int(result.target_win_rate * 100), int(TOLERANCE * 100)])
	var ts: Dictionary = result.get("turn_stats", {})
	if not ts.is_empty():
		var stale_str := ""
		if ts.get("stalemate_rate", 0.0) > 0.0:
			stale_str = "  stalemates %.2f%% (%d)" % [ts.stalemate_rate * 100, ts.get("stalemate_count", 0)]
		lines.append("  Battle length: %.1f turns/char  (%.1f total avg, min %d, max %d)%s" % [
			ts.avg_player_per_char, ts.avg_all_actions,
			ts.min_all_actions, ts.max_all_actions, stale_str])

	# Combo extremes.
	var extremes := get_combo_extremes(result)
	if not extremes.worst.is_empty():
		var spread := get_spread(result)
		lines.append("")
		lines.append("  WEAKEST COMBOS:")
		for c: Dictionary in extremes.worst:
			lines.append("    %.1f%%  %s" % [c.win_rate * 100, c.description])
		lines.append("")
		lines.append("  STRONGEST COMBOS:")
		for c: Dictionary in extremes.best:
			lines.append("    %.1f%%  %s" % [c.win_rate * 100, c.description])
		lines.append("")
		lines.append("  FULL SPREAD (min-max): %.1f%%" % [spread.full_spread * 100])
		lines.append("  CORE SPREAD (p10-p90): %.1f%% (%s)  [p10=%.1f%%, p90=%.1f%%]" % [
			spread.core_spread * 100, spread.verdict,
			spread.p10 * 100, spread.p90 * 100])

	# Class breakdown.
	var breakdown := get_class_breakdown(result)
	var diag: Dictionary = result.get("class_diag", {})
	var entries := []
	for cname: String in breakdown:
		var d: Dictionary = diag.get(cname, {})
		var avg_acts: float = (float(d.get("actions", 0)) / float(d.get("battles", 1))
			if d.get("battles", 0) > 0 else 0.0)
		entries.append({
			"class": cname,
			"win_rate": breakdown[cname].win_rate,
			"count": breakdown[cname].combo_count,
			"avg_acts": avg_acts,
		})
	entries.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return a.win_rate > b.win_rate)
	lines.append("")
	lines.append("  CLASS BREAKDOWN:")
	lines.append("    %-22s %10s %8s %8s  %s" % ["Class", "Win Rate", "Combos", "AvgActs", "Note"])
	lines.append("    " + "-".repeat(62))
	var warn_threshold: float = result.target_win_rate * 0.60
	for e: Dictionary in entries:
		var note: String = "** WEAK **" if e.win_rate < warn_threshold else ""
		lines.append("    %-22s %9.1f%% %8d %8.1f  %s" % [
			e["class"], e.win_rate * 100, e.count, e.avg_acts, note])

	# Combat stats section (all classes).
	lines.append("")
	lines.append("  COMBAT STATS (avg per battle):")
	lines.append("    %-22s %8s %8s %10s %8s" % ["Class", "Dealt", "Taken", "Mitigated", "Heals"])
	lines.append("    " + "-".repeat(62))
	for e: Dictionary in entries:
		var dc: Dictionary = diag.get(e["class"], {})
		var battles_c: int = dc.get("battles", 0)
		if battles_c == 0:
			continue
		var avg_dealt: float = float(dc.get("dmg_dealt", 0)) / battles_c
		var avg_taken: float = float(dc.get("dmg_taken", 0)) / battles_c
		var avg_mitigated: float = float(dc.get("dmg_mitigated", 0)) / battles_c
		var avg_heals: float = float(dc.get("heals", 0)) / battles_c
		lines.append("    %-22s %8.1f %8.1f %10.1f %8.1f" % [
			e["class"], avg_dealt, avg_taken, avg_mitigated, avg_heals])

	# Equipment breakdown.
	var equip_slots := get_equipment_breakdown(result)
	if not equip_slots.is_empty():
		lines.append("")
		lines.append("  EQUIPMENT BREAKDOWN:")
		lines.append("    %-22s %10s %10s  %s" % ["Piece", "Win Rate", "Battles", "Note"])
		lines.append("    " + "-".repeat(56))
		for slot_name: String in ["Weapon", "Armor", "Boots"]:
			var slot_entries: Array = equip_slots.get(slot_name, [])
			if slot_entries.is_empty():
				continue
			var slot_avg := 0.0
			for eq: Dictionary in slot_entries:
				slot_avg += eq.win_rate
			slot_avg /= slot_entries.size()
			for eq: Dictionary in slot_entries:
				var diff: float = (eq.win_rate - slot_avg) * 100
				var note := ""
				if absf(diff) > 5.0:
					note = "** %+.1fpp **" % diff
				elif absf(diff) > 3.0:
					note = "(%+.1fpp)" % diff
				lines.append("    %-22s %9.1f%% %10d  %s" % [
					eq.id, eq.win_rate * 100, eq.total, note])
			lines.append("    %-22s %9.1f%% %10s" % [
				"  [%s avg]" % slot_name, slot_avg * 100, ""])

	lines.append("")
	lines.append("  STATUS: %s" % get_status(result))
	return lines
