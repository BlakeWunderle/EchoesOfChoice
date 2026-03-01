extends SceneTree
## Headless JP accumulation simulation — run with:
##   Godot_v4.6.1-stable_win64_console.exe --path EchoesOfChoiceTactical --headless --script res://tools/jp_check.gd
## Optional filter by class:
##   ... -- squire
##
## Models ability usage per battle to estimate JP earned at each town milestone.
## Parses .tres files as text to avoid class_name issues in --script mode.

# ─── Enum constants (from Enums.gd) ──────────────────────────────────────────
const AT_DAMAGE := 0
const AT_HEAL := 1
const AT_BUFF := 2
const AT_DEBUFF := 3

const ST_PHYS_ATK := 0
const ST_MAG_ATK := 2

# ─── JP constants (from XpConfig) ────────────────────────────────────────────
const BASE_JP := 1
const IDENTITY_JP := 5
const TIER_1_THRESHOLD := 50
const TIER_2_THRESHOLD := 100

# ─── Class identity rules (from XpConfig.CLASS_IDENTITY) ─────────────────────
const CLASS_IDENTITY: Dictionary = {
	"squire": {"ability_types": [AT_BUFF], "stat_types": [ST_PHYS_ATK]},
	"mage": {"ability_types": [], "stat_types": [ST_MAG_ATK]},
	"entertainer": {"ability_types": [AT_DEBUFF, AT_BUFF], "stat_types": []},
	"tinker": {"ability_types": [AT_DEBUFF], "stat_types": [ST_MAG_ATK]},
}

const BASE_CLASSES: Dictionary = {
	"squire": "res://resources/classes/squire.tres",
	"mage": "res://resources/classes/mage.tres",
	"entertainer": "res://resources/classes/entertainer.tres",
	"tinker": "res://resources/classes/tinker.tres",
}

const CLASS_ORDER: Array = ["squire", "mage", "entertainer", "tinker"]

# ─── Progression: conservative unit level at each battle index ────────────────
# Battle 0 = city_street (prog 0, L1), Battle 1 = forest (prog 1, still L1),
# Battle 2 = branch (prog 2, L2), etc.  Units level after battles, not before.
const BATTLE_LEVELS: Array = [1, 1, 2, 3, 4, 4, 5]

const TOWN_MILESTONES: Array = [
	["Forest Village", 2],
	["Crossroads Inn", 4],
	["Gate Town", 7],
]

# ─── Simulation defaults ─────────────────────────────────────────────────────
const BASE_USES := 6               # ability uses for the slowest class
const UTILITY_CAP_PER_ABILITY := 2  # buff/debuff tactical reuse limit

var _all_classes: Dictionary = {}  # populated after loading; used for speed baseline


# ─── .tres text parser (same pattern as balance_check.gd) ────────────────────
func _parse_tres(res_path: String) -> Dictionary:
	var abs_path: String = ProjectSettings.globalize_path(res_path)
	var f: FileAccess = FileAccess.open(abs_path, FileAccess.READ)
	if f == null:
		return {}

	var ext_res: Dictionary = {}
	var props: Dictionary = {}
	var abilities_ids: Array = []
	var in_resource: bool = false

	while not f.eof_reached():
		var line: String = f.get_line().strip_edges()

		if line.begins_with("[ext_resource"):
			var ps: int = line.find("path=\"")
			var is_: int = line.find("id=\"")
			if ps >= 0 and is_ >= 0:
				var pv: String = line.substr(ps + 6)
				pv = pv.substr(0, pv.find("\""))
				var iv: String = line.substr(is_ + 4)
				iv = iv.substr(0, iv.find("\""))
				ext_res[iv] = pv
			continue

		if line == "[resource]":
			in_resource = true
			continue
		if not in_resource:
			continue
		if line.is_empty() or line.begins_with(";") or line.begins_with("["):
			continue

		var eq: int = line.find(" = ")
		if eq < 0:
			continue
		var key: String = line.substr(0, eq).strip_edges()
		var val: String = line.substr(eq + 3).strip_edges()

		if key == "abilities":
			var bo: int = val.find("[")
			var bc: int = val.rfind("]")
			if bo >= 0 and bc > bo:
				for part: String in val.substr(bo + 1, bc - bo - 1).split(","):
					part = part.strip_edges()
					var qs: int = part.find("\"")
					if qs >= 0:
						var qe: int = part.find("\"", qs + 1)
						if qe > qs:
							abilities_ids.append(part.substr(qs + 1, qe - qs - 1))
			continue

		if val.begins_with("\"") and val.ends_with("\""):
			props[key] = val.substr(1, val.length() - 2)
			continue

		if val.is_valid_int():
			props[key] = val.to_int()

	f.close()
	return {"props": props, "ext_res": ext_res, "abilities_ids": abilities_ids}


func _is_identity(class_id: String, ability_type: int, modified_stat: int) -> bool:
	var identity: Dictionary = CLASS_IDENTITY.get(class_id, {})
	if identity.is_empty():
		return false
	if ability_type in identity.get("ability_types", []):
		return true
	if modified_stat in identity.get("stat_types", []):
		return true
	return false


func _load_class(class_id: String) -> Dictionary:
	var data: Dictionary = _parse_tres(BASE_CLASSES[class_id])
	if data.is_empty():
		return {}

	var props: Dictionary = data["props"]
	var ext_res: Dictionary = data["ext_res"]

	var abilities: Array = []
	for ab_id: String in data["abilities_ids"]:
		if not ext_res.has(ab_id):
			continue
		var ab: Dictionary = _parse_tres(ext_res[ab_id])
		if ab.is_empty():
			continue
		var ap: Dictionary = ab["props"]
		var a_type: int = ap.get("ability_type", 0)
		var a_stat: int = ap.get("modified_stat", 0)
		abilities.append({
			"name": ap.get("ability_name", "???"),
			"type": a_type,
			"stat": a_stat,
			"cost": ap.get("mana_cost", 0),
			"is_identity": _is_identity(class_id, a_type, a_stat),
		})

	return {
		"class_id": class_id,
		"mana": props.get("base_max_mana", 0),
		"mana_growth": props.get("growth_mana", 0),
		"speed": props.get("base_speed", 13),
		"speed_growth": props.get("growth_speed", 0),
		"abilities": abilities,
		"basic_identity": _is_identity(class_id, AT_DAMAGE, ST_PHYS_ATK),
	}


# ─── Battle simulation ───────────────────────────────────────────────────────
## Models one battle: utility first (capped per ability), damage until OOM, basic attack rest.
func _battle_detail(cd: Dictionary, level: int, uses: int) -> Dictionary:
	var mana: int = cd["mana"] + cd["mana_growth"] * (level - 1)
	var mana_left: int = mana
	var id_n: int = 0
	var plain_n: int = 0
	var used: int = 0

	# Phase 1: buff/debuff abilities, each capped
	for ab: Dictionary in cd["abilities"]:
		if ab["type"] != AT_BUFF and ab["type"] != AT_DEBUFF:
			continue
		for _i in range(mini(UTILITY_CAP_PER_ABILITY, uses - used)):
			if used >= uses or (ab["cost"] > 0 and mana_left < ab["cost"]):
				break
			mana_left -= ab["cost"]
			if ab["is_identity"]:
				id_n += 1
			else:
				plain_n += 1
			used += 1

	# Phase 2: damage/heal abilities until OOM
	for ab: Dictionary in cd["abilities"]:
		if ab["type"] != AT_DAMAGE and ab["type"] != AT_HEAL:
			continue
		if ab["cost"] <= 0:
			continue
		while used < uses and mana_left >= ab["cost"]:
			mana_left -= ab["cost"]
			if ab["is_identity"]:
				id_n += 1
			else:
				plain_n += 1
			used += 1

	# Phase 3: basic attack
	while used < uses:
		if cd["basic_identity"]:
			id_n += 1
		else:
			plain_n += 1
		used += 1

	return {
		"jp": id_n * IDENTITY_JP + plain_n * BASE_JP,
		"identity": id_n,
		"plain": plain_n,
		"mana_used": mana - mana_left,
		"mana_pool": mana,
	}


## Speed-adjusted ability uses for a class at a given level.
## Uses the minimum speed across all loaded classes at that level as the baseline.
func _speed_uses(cd: Dictionary, level: int) -> int:
	var min_spd: int = 999
	for cid: String in _all_classes:
		var s: int = _all_classes[cid]["speed"] + _all_classes[cid]["speed_growth"] * (level - 1)
		if s < min_spd:
			min_spd = s
	var spd: int = cd["speed"] + cd["speed_growth"] * (level - 1)
	return maxi(BASE_USES, roundi(float(BASE_USES) * float(spd) / float(min_spd)))


## Accumulate JP over N battles using speed-adjusted uses per battle.
func _accumulate(cd: Dictionary, battle_count: int) -> int:
	var total: int = 0
	for i in range(battle_count):
		var lvl: int = BATTLE_LEVELS[mini(i, BATTLE_LEVELS.size() - 1)]
		total += _battle_detail(cd, lvl, _speed_uses(cd, lvl))["jp"]
	return total


## Accumulate JP with a fixed (manual) uses count — for sensitivity table.
func _accumulate_fixed(cd: Dictionary, battle_count: int, uses: int) -> int:
	var total: int = 0
	for i in range(battle_count):
		var lvl: int = BATTLE_LEVELS[mini(i, BATTLE_LEVELS.size() - 1)]
		total += _battle_detail(cd, lvl, uses)["jp"]
	return total


# ─── Report sections ─────────────────────────────────────────────────────────
func _print_identity(classes: Dictionary) -> void:
	print("── Ability Identity Breakdown ──")
	print("")
	for cid: String in CLASS_ORDER:
		if not classes.has(cid):
			continue
		var cd: Dictionary = classes[cid]
		print("  %s:" % cid.capitalize())
		var ba_jp: int = IDENTITY_JP if cd["basic_identity"] else BASE_JP
		var ba_tag: String = "identity" if cd["basic_identity"] else "not identity"
		print("    Basic Attack (free)          → %d JP (%s)" % [ba_jp, ba_tag])
		for ab: Dictionary in cd["abilities"]:
			var jp: int = IDENTITY_JP if ab["is_identity"] else BASE_JP
			var tag: String = "identity" if ab["is_identity"] else "not identity"
			print("    %-28s → %d JP (%s, %d mana)" % [ab["name"], jp, tag, ab["cost"]])
		print("    Mana pool: %d (+%d/level)  |  Speed: %d (+%d/level)" % [
			cd["mana"], cd["mana_growth"], cd["speed"], cd["speed_growth"]
		])
		print("")


func _print_per_battle(classes: Dictionary) -> void:
	var min_spd: int = 999
	for cid2: String in _all_classes:
		if _all_classes[cid2]["speed"] < min_spd:
			min_spd = _all_classes[cid2]["speed"]
	print("── JP per Battle (speed-weighted, base %d uses @ spd %d) ──" % [BASE_USES, min_spd])
	print("")
	print("  %-14s │ Spd  Uses  JP   Identity  Basic  Mana" % "Class")
	print("  " + "─".repeat(62))
	for cid: String in CLASS_ORDER:
		if not classes.has(cid):
			continue
		var cd: Dictionary = classes[cid]
		var uses: int = _speed_uses(cd, 1)
		var d: Dictionary = _battle_detail(cd, 1, uses)
		print("  %-14s │ %-4d %-5d %-4d %d×5      %d×1    %d/%d" % [
			cid.capitalize(), cd["speed"], uses, d["jp"], d["identity"], d["plain"],
			d["mana_used"], d["mana_pool"]
		])
	print("")


func _print_milestones(classes: Dictionary) -> void:
	print("── JP at Town Milestones (speed-weighted) ──")
	print("")
	print("  %-14s │ Forest Village (2b) │ Crossroads Inn (4b) │ Gate Town (7b)" % "")
	print("  %-14s │ JP    T1?           │ JP    T1?           │ JP    T1? T2?" % "Class")
	print("  " + "─".repeat(78))

	var warnings: Array = []
	for cid: String in CLASS_ORDER:
		if not classes.has(cid):
			continue
		var cd: Dictionary = classes[cid]
		var fv: int = _accumulate(cd, 2)
		var cr: int = _accumulate(cd, 4)
		var gt: int = _accumulate(cd, 7)

		print("  %-14s │ %-5d %s              │ %-5d %s              │ %-5d %s   %s" % [
			cid.capitalize(),
			fv, "✓" if fv >= TIER_1_THRESHOLD else "✗",
			cr, "✓" if cr >= TIER_1_THRESHOLD else "✗",
			gt, "✓" if gt >= TIER_1_THRESHOLD else "✗",
			"✓" if gt >= TIER_2_THRESHOLD else "✗",
		])

		if fv < TIER_1_THRESHOLD:
			warnings.append("  ⚠ %s: %d JP at Forest Village (needs %d, short by %d)" % [
				cid.capitalize(), fv, TIER_1_THRESHOLD, TIER_1_THRESHOLD - fv
			])
		if cr < TIER_1_THRESHOLD:
			warnings.append("  ⚠ %s: %d JP at Crossroads (needs %d, short by %d)" % [
				cid.capitalize(), cr, TIER_1_THRESHOLD, TIER_1_THRESHOLD - cr
			])

	print("")
	if warnings.is_empty():
		print("  ✓ All classes reach T1 by Forest Village")
	else:
		for w: String in warnings:
			print(w)

	# Optional battle bonus
	print("")
	print("  Optional battle bonus (+1 battle at L1):")
	for cid: String in CLASS_ORDER:
		if not classes.has(cid):
			continue
		var cd: Dictionary = classes[cid]
		var uses: int = _speed_uses(cd, 1)
		var bonus: int = _battle_detail(cd, 1, uses)["jp"]
		print("    %s: +%d JP (%d uses)" % [cid.capitalize(), bonus, uses])
	print("")


func _print_sensitivity(classes: Dictionary) -> void:
	print("── Sensitivity: Fixed Uses/Battle → JP at Crossroads (4 battles) ──")
	print("")
	print("  %-14s │ 4 uses    5 uses    6 uses    7 uses    8 uses" % "Class")
	print("  " + "─".repeat(68))
	for cid: String in CLASS_ORDER:
		if not classes.has(cid):
			continue
		var cd: Dictionary = classes[cid]
		var cells: Array = []
		for u: int in [4, 5, 6, 7, 8]:
			var jp: int = _accumulate_fixed(cd, 4, u)
			cells.append("%d %s" % [jp, "✓" if jp >= TIER_1_THRESHOLD else "✗"])
		print("  %-14s │ %-9s %-9s %-9s %-9s %-9s" % [
			cid.capitalize(), cells[0], cells[1], cells[2], cells[3], cells[4]
		])

	print("")
	print("  %-14s │ 4 uses    5 uses    6 uses    7 uses    8 uses" % "@ Gate Town (7b)")
	print("  " + "─".repeat(68))
	for cid: String in CLASS_ORDER:
		if not classes.has(cid):
			continue
		var cd: Dictionary = classes[cid]
		var cells: Array = []
		for u: int in [4, 5, 6, 7, 8]:
			var jp: int = _accumulate_fixed(cd, 7, u)
			var t2: String = " T2" if jp >= TIER_2_THRESHOLD else ""
			cells.append("%d %s%s" % [jp, "✓" if jp >= TIER_1_THRESHOLD else "✗", t2])
		print("  %-14s │ %-9s %-9s %-9s %-9s %-9s" % [
			cid.capitalize(), cells[0], cells[1], cells[2], cells[3], cells[4]
		])
	print("")


func _print_thresholds(classes: Dictionary) -> void:
	print("── Threshold Analysis ──")
	print("")
	print("  Current thresholds: T1 = %d JP, T2 = %d JP" % [
		TIER_1_THRESHOLD, TIER_2_THRESHOLD
	])
	print("")

	for milestone: Array in TOWN_MILESTONES:
		var town: String = milestone[0]
		var battles: int = milestone[1]
		var min_jp: int = 9999
		var min_cid: String = ""
		var max_jp: int = 0
		var max_cid: String = ""
		for cid: String in CLASS_ORDER:
			if not classes.has(cid):
				continue
			var jp: int = _accumulate(classes[cid], battles)
			if jp < min_jp:
				min_jp = jp
				min_cid = cid
			if jp > max_jp:
				max_jp = jp
				max_cid = cid

		print("  %s (%d battles):" % [town, battles])
		print("    Slowest: %s @ %d JP  |  Fastest: %s @ %d JP" % [
			min_cid.capitalize(), min_jp, max_cid.capitalize(), max_jp
		])
		if min_jp >= TIER_1_THRESHOLD:
			print("    ✓ All classes reach T1 (%d)" % TIER_1_THRESHOLD)
		else:
			print("    → For all T1 by %s: threshold ≤ %d (currently %d, gap %d)" % [
				town, min_jp, TIER_1_THRESHOLD, TIER_1_THRESHOLD - min_jp
			])
		if battles >= 6:
			if min_jp >= TIER_2_THRESHOLD:
				print("    ✓ All classes reach T2 (%d)" % TIER_2_THRESHOLD)
			else:
				print("    → For all T2 by %s: threshold ≤ %d (currently %d, gap %d)" % [
					town, min_jp, TIER_2_THRESHOLD, TIER_2_THRESHOLD - min_jp
				])
		print("")


# ─── Main ─────────────────────────────────────────────────────────────────────
func _initialize() -> void:
	var filter: String = ""
	var user_args: PackedStringArray = OS.get_cmdline_user_args()
	if user_args.size() > 0:
		filter = user_args[0].to_lower()

	print("")
	print("═══ JP Accumulation Simulation ═══")

	var classes: Dictionary = {}
	for cid: String in CLASS_ORDER:
		if not filter.is_empty() and cid != filter:
			continue
		var cd: Dictionary = _load_class(cid)
		if cd.is_empty():
			print("[MISSING: %s]" % cid)
			continue
		classes[cid] = cd

	if classes.is_empty():
		print("No classes loaded. Available: %s" % ", ".join(CLASS_ORDER))
		quit()
		return

	_all_classes = classes

	# Find min base speed for display
	var min_spd: int = 999
	for cid: String in classes:
		if classes[cid]["speed"] < min_spd:
			min_spd = classes[cid]["speed"]

	print("Config: base %d uses @ slowest spd %d, utility cap %d/ability, JP: base=%d identity=%d" % [
		BASE_USES, min_spd, UTILITY_CAP_PER_ABILITY, BASE_JP, IDENTITY_JP
	])
	print("")

	_print_identity(classes)
	_print_per_battle(classes)
	_print_milestones(classes)
	_print_sensitivity(classes)
	_print_thresholds(classes)

	quit()
