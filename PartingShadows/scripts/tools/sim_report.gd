class_name SimReport

## Builds structured JSON report entries from simulation results.
## Extracted from battle_simulator.gd to keep the CLI entry point lean.

const SR := preload("res://scripts/tools/simulation_runner.gd")
const SD := preload("res://scripts/tools/sim_diagnostics.gd")
const BSDB := preload("res://scripts/tools/battle_stage_db.gd")
const EnemyRoles := preload("res://scripts/data/enemy_roles.gd")


## Build a JSON-ready report entry for one stage result.
static func build_entry(result: Dictionary, stage: Dictionary) -> Dictionary:
	var breakdown := SR.get_class_breakdown(result)
	var spread := SR.get_spread(result)
	var extremes := SR.get_combo_extremes(result)
	var worst_entries := []
	for c: Dictionary in extremes.worst:
		worst_entries.append({"description": c.description, "win_rate": c.win_rate})
	var best_entries := []
	for c: Dictionary in extremes.best:
		best_entries.append({"description": c.description, "win_rate": c.win_rate})
	# Build per-class combat stat averages for JSON persistence.
	var diag_raw: Dictionary = result.get("class_diag", {})
	var combat_stats := {}
	for cname: String in diag_raw:
		var cd: Dictionary = diag_raw[cname]
		var b: int = cd.get("battles", 0)
		if b == 0:
			continue
		combat_stats[cname] = {
			"avg_dealt": float(cd.get("dmg_dealt", 0)) / b,
			"avg_taken": float(cd.get("dmg_taken", 0)) / b,
			"avg_mitigated": float(cd.get("dmg_mitigated", 0)) / b,
			"avg_heals": float(cd.get("heals", 0)) / b,
			"death_rate": float(cd.get("deaths", 0)) / b,
			"avg_buffs": float(cd.get("buffs_applied", 0)) / b,
			"avg_debuffs": float(cd.get("debuffs_applied", 0)) / b,
		}
	# Compute enemy role profile for the stage.
	var enemies: Array = BSDB.create_enemies(stage.name)
	var enemy_ids: Array[String] = []
	var has_boss := false
	for e in enemies:
		enemy_ids.append(e.class_id)
		if EnemyRoles.is_boss(e.class_id):
			has_boss = true
	var enemy_profile := EnemyRoles.get_battle_profile(enemy_ids)

	var entry := {
		"stage_name": result.stage_name,
		"story": stage.get("story", 1),
		"progression_stage": result.progression_stage,
		"tier": stage.get("tier", "base"),
		"target_win_rate": result.target_win_rate,
		"overall_win_rate": result.overall_win_rate,
		"combo_count": result.combo_results.size(),
		"elapsed_ms": result.elapsed_ms,
		"status": SR.get_status(result),
		"has_boss": has_boss,
		"enemy_roles": enemy_profile,
		"class_breakdown": breakdown,
		"combat_stats": combat_stats,
		"class_diag": diag_raw,
		"spread": spread,
		"best_combos": best_entries,
		"worst_combos": worst_entries,
		"turn_stats": result.get("turn_stats", {}),
		"diagnostics": SD.to_json(SD.analyze(result, stage)),
		"equip_stats": _build_equip_json(result),
		"ult_stats": _build_ult_json(result),
		"ult_breakdown": SR.get_ultimate_breakdown(result),
	}
	if result.has("action_counts"):
		entry["action_counts"] = result["action_counts"]
	if result.has("player_item"):
		entry["player_item"] = result["player_item"]
		entry["item_usage"] = result.get("item_usage", {})
	return entry


static func _build_equip_json(result: Dictionary) -> Dictionary:
	var es: Dictionary = result.get("equip_stats", {})
	var out := {}
	for eid: String in es:
		var s: Dictionary = es[eid]
		out[eid] = {
			"wins": s.wins,
			"total": s.total,
			"win_rate": float(s.wins) / s.total if s.total > 0 else 0.0,
		}
	return out


static func _build_ult_json(result: Dictionary) -> Dictionary:
	var us: Dictionary = result.get("ult_stats", {})
	var cm: Dictionary = result.get("ult_class_map", {})
	var out := {}
	for uid: String in us:
		var s: Dictionary = us[uid]
		out[uid] = {
			"wins": s.wins,
			"total": s.total,
			"uses": s.get("uses", 0),
			"win_rate": float(s.wins) / s.total if s.total > 0 else 0.0,
			"class": cm.get(uid, "Unknown"),
		}
	return out


## Write an array of report entries to a JSON file.
static func write_json(path: String, entries: Array) -> void:
	# Merge with existing JSON: keep old stages, replace matching stage_names
	var new_names := {}
	for e in entries:
		new_names[e.get("stage_name", "")] = true
	var existing := FileAccess.open(path, FileAccess.READ)
	if existing:
		var parser := JSON.new()
		if parser.parse(existing.get_as_text()) == OK and parser.data is Dictionary:
			var old: Array = parser.data.get("stages", [])
			for o in old:
				if o is Dictionary and not new_names.has(o.get("stage_name", "")):
					entries.append(o)
		existing.close()
	entries.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return a.get("stage_name", "") < b.get("stage_name", ""))
	var json_str := JSON.stringify({"stages": entries}, "\t")
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(json_str)
		file.close()
		print("\n  JSON report written to: %s" % path)
	else:
		print("\n  ERROR: Could not write JSON report to: %s" % path)


## Write a human-readable text report with full verbose output for all stages.
## Used by --compact mode to store details in a file instead of stdout.
static func write_text_report(path: String, results: Array,
		stages: Array) -> void:
	var lines := PackedStringArray()
	lines.append("=== Detailed Simulation Report ===")
	lines.append("Generated: %s" % Time.get_datetime_string_from_system())
	lines.append("")

	for idx in results.size():
		var r: Dictionary = results[idx]
		lines.append("=" .repeat(60))
		lines.append("  %s" % r.stage_name)
		lines.append("=" .repeat(60))
		lines.append_array(SR.format_stage_verbose(r))

		# Add diagnostics for non-PASS stages.
		if SR.get_status(r) != "PASS" and idx < stages.size():
			var diags := SD.analyze(r, stages[idx])
			if not diags.is_empty():
				lines.append("")
				lines.append("  WEAK CLASS DIAGNOSTICS:")
				for d: Dictionary in diags:
					lines.append("")
					lines.append("    %s (win_rate: %.1f%%, category: %s)" % [
						d["class"], d.win_rate * 100, d.category])
					lines.append("      Offense: avg damage %.0f (stage avg %.0f, %.2fx)" % [
						d.avg_dmg_dealt, d.stage_avg_dealt, d.offense_ratio])
					lines.append("      Defense: avg taken %.0f (stage avg %.0f, %.2fx)" % [
						d.avg_dmg_taken, d.stage_avg_taken, d.defense_ratio])
					lines.append("      Heals: avg %.0f | Death rate: %.0f%%" % [
						d.avg_heals, d.death_rate * 100])
					if not d.enemy_profile.is_empty():
						var ep: Dictionary = d.enemy_profile
						lines.append("      Enemies: %d units, avg p_def=%d m_def=%d p_atk=%d m_atk=%d" % [
							ep.count, ep.avg_phys_def, ep.avg_mag_def,
							ep.avg_phys_atk, ep.avg_mag_atk])
		lines.append("")

	# Summary table.
	lines.append("=" .repeat(60))
	lines.append("  SUMMARY")
	lines.append("=" .repeat(60))
	lines.append("  %-25s %10s %10s %12s" % [
		"Battle", "Win Rate", "Target", "Status"])
	lines.append("  " + "-".repeat(57))
	var pass_count := 0
	for r: Dictionary in results:
		lines.append("  %-25s %9.1f%% %9d%% %12s" % [
			r.stage_name, r.overall_win_rate * 100,
			int(r.target_win_rate * 100), SR.get_status(r)])
		if SR.get_status(r) == "PASS":
			pass_count += 1
	lines.append("")
	lines.append("  Passed: %d/%d" % [pass_count, results.size()])

	var file := FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string("\n".join(lines))
		file.close()
		var abs_path := ProjectSettings.globalize_path(path)
		print("  Full report: %s" % abs_path)
	else:
		print("  ERROR: Could not write report to: %s" % path)
