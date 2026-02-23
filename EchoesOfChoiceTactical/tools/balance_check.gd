extends SceneTree
## Headless balance checker — run with:
##   Godot_v4.6.1-stable_win64_console.exe --path EchoesOfChoiceTactical --headless --script res://tools/balance_check.gd
## Optional filter by battle ID:
##   ... -- deep_forest
##
## Parses .tres files as text to avoid GDScript class_name registration issues
## that occur in --script mode (Enums, FighterData, AbilityData not auto-registered).

# ─── Ability type / stat type int constants (from Enums.gd) ──────────────────
const ABILITY_TYPE_DAMAGE: int = 0   # Enums.AbilityType.DAMAGE
const STAT_PHYSICAL_ATTACK: int = 0  # Enums.StatType.PHYSICAL_ATTACK
const STAT_MAGIC_ATTACK: int = 2     # Enums.StatType.MAGIC_ATTACK
const STAT_MIXED_ATTACK: int = 6     # Enums.StatType.MIXED_ATTACK

# ─── Squire phys_atk at each progression ─────────────────────────────────────
# Squire: base_physical_attack=18, growth_physical_attack=2 → level L: 18+2*(L-1)
const SQUIRE_PHYS_ATK: Dictionary = {
	0: 18, 1: 20, 2: 22, 3: 24, 4: 24, 5: 26, 6: 28, 7: 28, 8: 30
}

# ─── Party defense profiles (P.Def equipment only, no M.Def equipment bonus) ─
# Equipment bonus to P.Def only:
#   Prog 0: +0    Prog 1-2: +3    Prog 3-6: +5    Prog 7-8: +8
# Base L1 stats:  Squire P15/M13  Mage P13/M18  Scholar P12/M18  Ent P13/M18
# Growth per level: all +2 P.Def / +2 M.Def, Entertainer M.Def +3/level
const PARTY: Dictionary = {
	0: {"level": 1, "squire": [15, 13], "mage": [13, 18], "scholar": [12, 18], "entertainer": [13, 18]},
	1: {"level": 2, "squire": [20, 15], "mage": [18, 20], "scholar": [17, 20], "entertainer": [18, 21]},
	2: {"level": 3, "squire": [22, 17], "mage": [20, 22], "scholar": [19, 22], "entertainer": [20, 24]},
	3: {"level": 4, "squire": [26, 19], "mage": [24, 24], "scholar": [23, 24], "entertainer": [24, 27]},
	4: {"level": 4, "squire": [26, 19], "mage": [24, 24], "scholar": [23, 24], "entertainer": [24, 27]},
	5: {"level": 5, "squire": [33, 21], "mage": [31, 26], "scholar": [30, 26], "entertainer": [31, 30]},
	6: {"level": 6, "squire": [35, 23], "mage": [33, 28], "scholar": [32, 28], "entertainer": [33, 33]},
	7: {"level": 6, "squire": [38, 23], "mage": [36, 28], "scholar": [35, 28], "entertainer": [36, 33]},
	8: {"level": 7, "squire": [41, 25], "mage": [39, 30], "scholar": [38, 30], "entertainer": [39, 36]},
}

const CLASS_ORDER: Array = ["squire", "mage", "scholar", "entertainer"]
const CLASS_LABELS: Array = ["vs Squire", "vs Mage", "vs Scholar", "vs Ent"]

# ─── Battle roster ────────────────────────────────────────────────────────────
const BATTLES: Dictionary = {
	"city_street": {
		"prog": 0,
		"enemies": [
			{"res": "res://resources/enemies/thug.tres", "name": "Thug", "count": 2, "level": 1},
			{"res": "res://resources/enemies/street_tough.tres", "name": "Street Tough", "count": 2, "level": 1},
			{"res": "res://resources/enemies/hex_peddler.tres", "name": "Hex Peddler", "count": 1, "level": 1},
		],
	},
	"forest": {
		"prog": 1,
		"enemies": [
			{"res": "res://resources/enemies/bear.tres", "name": "Bear", "count": 1, "level": 1},
			{"res": "res://resources/enemies/bear_cub.tres", "name": "Bear Cub", "count": 1, "level": 1},
			{"res": "res://resources/enemies/wolf.tres", "name": "Wolf", "count": 2, "level": 1},
			{"res": "res://resources/enemies/wild_boar.tres", "name": "Wild Boar", "count": 1, "level": 1},
		],
	},
	"village_raid": {
		"prog": 1,
		"enemies": [
			{"res": "res://resources/enemies/goblin.tres", "name": "Goblin", "count": 2, "level": 1},
			{"res": "res://resources/enemies/goblin_archer.tres", "name": "Goblin Archer", "count": 1, "level": 1},
			{"res": "res://resources/enemies/goblin_shaman.tres", "name": "Goblin Shaman", "count": 1, "level": 1},
			{"res": "res://resources/enemies/hobgoblin.tres", "name": "Hobgoblin", "count": 1, "level": 1},
		],
	},
	"smoke": {
		"prog": 2,
		"enemies": [
			{"res": "res://resources/enemies/imp.tres", "name": "Imp", "count": 2, "level": 2},
			{"res": "res://resources/enemies/fire_spirit.tres", "name": "Fire Spirit", "count": 3, "level": 2},
		],
	},
	"deep_forest": {
		"prog": 2,
		"enemies": [
			{"res": "res://resources/enemies/witch.tres", "name": "Witch", "count": 1, "level": 2},
			{"res": "res://resources/enemies/wisp.tres", "name": "Wisp", "count": 2, "level": 2},
			{"res": "res://resources/enemies/sprite.tres", "name": "Sprite", "count": 2, "level": 2},
		],
	},
	"clearing": {
		"prog": 2,
		"enemies": [
			{"res": "res://resources/enemies/satyr.tres", "name": "Satyr", "count": 1, "level": 2},
			{"res": "res://resources/enemies/nymph.tres", "name": "Nymph", "count": 2, "level": 2},
			{"res": "res://resources/enemies/pixie.tres", "name": "Pixie", "count": 2, "level": 2},
		],
	},
	"ruins": {
		"prog": 2,
		"enemies": [
			{"res": "res://resources/enemies/shade.tres", "name": "Shade", "count": 2, "level": 2},
			{"res": "res://resources/enemies/wraith.tres", "name": "Wraith", "count": 2, "level": 2},
			{"res": "res://resources/enemies/bone_sentry.tres", "name": "Bone Sentry", "count": 1, "level": 2},
		],
	},
	"cave": {
		"prog": 3,
		"enemies": [
			{"res": "res://resources/enemies/cave_bat.tres", "name": "Cave Bat", "count": 2, "level": 3},
			{"res": "res://resources/enemies/fire_wyrmling.tres", "name": "Fire Wyrmling", "count": 1, "level": 3},
			{"res": "res://resources/enemies/frost_wyrmling.tres", "name": "Frost Wyrmling", "count": 1, "level": 3},
		],
	},
	"portal": {
		"prog": 3,
		"enemies": [
			{"res": "res://resources/enemies/fiendling.tres", "name": "Fiendling", "count": 3, "level": 3},
			{"res": "res://resources/enemies/hellion.tres", "name": "Hellion", "count": 2, "level": 3},
		],
	},
	"inn_ambush": {
		"prog": 3,
		"enemies": [
			{"res": "res://resources/enemies/shadow_hound.tres", "name": "Shadow Hound", "count": 2, "level": 3},
			{"res": "res://resources/enemies/night_prowler.tres", "name": "Night Prowler", "count": 1, "level": 3},
			{"res": "res://resources/enemies/dusk_moth.tres", "name": "Dusk Moth", "count": 1, "level": 3},
			{"res": "res://resources/enemies/gloom_stalker.tres", "name": "Gloom Stalker", "count": 1, "level": 3},
		],
	},
}


# ─── .tres text parser ────────────────────────────────────────────────────────
## Reads a .tres file as text and returns {props: {key: int}, ext_res: {id: path}}.
## Only extracts integer props and ext_resource paths — sufficient for balance data.
func _parse_tres(res_path: String) -> Dictionary:
	var abs_path: String = ProjectSettings.globalize_path(res_path)
	var f: FileAccess = FileAccess.open(abs_path, FileAccess.READ)
	if f == null:
		return {}

	var ext_res: Dictionary = {}   # id (String) → res_path (String)
	var props: Dictionary = {}     # prop_name (String) → int_value
	var abilities_ids: Array = []  # ordered list of ext_res IDs for abilities array

	var in_resource_section: bool = false

	while not f.eof_reached():
		var raw: String = f.get_line()
		var line: String = raw.strip_edges()

		# Section headers
		if line.begins_with("[ext_resource"):
			# Extract path and id: [ext_resource type="Resource" path="res://..." id="2"]
			var path_start: int = line.find("path=\"")
			var id_start: int = line.find("id=\"")
			if path_start >= 0 and id_start >= 0:
				var path_val: String = line.substr(path_start + 6)
				path_val = path_val.substr(0, path_val.find("\""))
				var id_val: String = line.substr(id_start + 4)
				id_val = id_val.substr(0, id_val.find("\""))
				ext_res[id_val] = path_val
			continue

		if line == "[resource]":
			in_resource_section = true
			continue

		if not in_resource_section:
			continue

		# Skip blank lines and comments
		if line.is_empty() or line.begins_with(";") or line.begins_with("["):
			continue

		var eq: int = line.find(" = ")
		if eq < 0:
			continue
		var key: String = line.substr(0, eq).strip_edges()
		var val_str: String = line.substr(eq + 3).strip_edges()

		# abilities = [ExtResource("2"), ExtResource("3")]
		if key == "abilities":
			var bracket_open: int = val_str.find("[")
			var bracket_close: int = val_str.rfind("]")
			if bracket_open >= 0 and bracket_close > bracket_open:
				var inner: String = val_str.substr(bracket_open + 1, bracket_close - bracket_open - 1)
				# Extract all IDs from ExtResource("X") patterns
				var parts: PackedStringArray = inner.split(",")
				for part: String in parts:
					part = part.strip_edges()
					var id_start: int = part.find("\"")
					if id_start >= 0:
						var id_end: int = part.find("\"", id_start + 1)
						if id_end > id_start:
							abilities_ids.append(part.substr(id_start + 1, id_end - id_start - 1))
			continue

		# Integer properties
		if val_str.is_valid_int():
			props[key] = val_str.to_int()

	f.close()
	return {"props": props, "ext_res": ext_res, "abilities_ids": abilities_ids}


## Loads a FighterData .tres and returns a summary dict with stats and ability data.
func _load_enemy(res_path: String) -> Dictionary:
	var data: Dictionary = _parse_tres(res_path)
	if data.is_empty():
		return {}

	var props: Dictionary = data["props"]
	var ext_res: Dictionary = data["ext_res"]
	var abilities_ids: Array = data["abilities_ids"]

	# Collect ability data: list of {ability_type, modified_stat, modifier}
	var abilities: Array = []
	for ab_id: String in abilities_ids:
		if not ext_res.has(ab_id):
			continue
		var ab_path: String = ext_res[ab_id]
		var ab_data: Dictionary = _parse_tres(ab_path)
		if ab_data.is_empty():
			continue
		var ap: Dictionary = ab_data["props"]
		abilities.append({
			"ability_type": ap.get("ability_type", -1),
			"modified_stat": ap.get("modified_stat", -1),
			"modifier": ap.get("modifier", 0),
		})

	return {
		"base_physical_attack":  props.get("base_physical_attack", 0),
		"base_magic_attack":     props.get("base_magic_attack", 0),
		"base_physical_defense": props.get("base_physical_defense", 0),
		"base_max_health":       props.get("base_max_health", 0),
		"growth_physical_attack":  props.get("growth_physical_attack", 0),
		"growth_magic_attack":     props.get("growth_magic_attack", 0),
		"growth_physical_defense": props.get("growth_physical_defense", 0),
		"growth_health":           props.get("growth_health", 0),
		"abilities": abilities,
	}


# ─── Main ─────────────────────────────────────────────────────────────────────
func _initialize() -> void:
	var filter: String = ""
	var user_args: PackedStringArray = OS.get_cmdline_user_args()
	if user_args.size() > 0:
		filter = user_args[0]

	var found: bool = false
	for battle_id: String in BATTLES:
		if filter.is_empty() or battle_id == filter:
			_report_battle(battle_id, BATTLES[battle_id])
			found = true

	if not found:
		print("No battle found matching: %s" % filter)
		print("Available battles: %s" % ", ".join(BATTLES.keys()))

	quit()


func _report_battle(battle_id: String, bdata: Dictionary) -> void:
	var prog: int = bdata["prog"]
	var profile: Dictionary = PARTY[prog]
	var party_level: int = profile["level"]
	var sq_atk: int = SQUIRE_PHYS_ATK[prog]

	print("")
	print("═══ %-22s [Prog %d | Party Lv%d | Sq.Atk %d] ═══" % [
		battle_id, prog, party_level, sq_atk
	])
	print("%-22s %4s │ %-13s %-13s %-13s %-12s │ TTK" % [
		"Enemy", "HP",
		CLASS_LABELS[0], CLASS_LABELS[1], CLASS_LABELS[2], CLASS_LABELS[3]
	])
	print("─".repeat(94))

	var zero_names: Array = []
	var spike_names: Array = []
	var slow_names: Array = []

	for entry: Dictionary in bdata["enemies"]:
		var res_path: String = entry["res"]
		var display_name: String = entry["name"]
		var count: int = entry["count"]

		var fighter: Dictionary = _load_enemy(res_path)
		if fighter.is_empty():
			print("  [MISSING: %s]" % res_path)
			continue

		var e_lvl: int = entry["level"]
		var e_phys_atk: int = fighter["base_physical_attack"]  + fighter["growth_physical_attack"]  * (e_lvl - 1)
		var e_mag_atk: int  = fighter["base_magic_attack"]     + fighter["growth_magic_attack"]     * (e_lvl - 1)
		var e_phys_def: int = fighter["base_physical_defense"] + fighter["growth_physical_defense"] * (e_lvl - 1)
		var e_hp: int       = fighter["base_max_health"]       + fighter["growth_health"]           * (e_lvl - 1)

		# Best damage modifier per type; basic physical attack is always available (mod=0)
		var best_phys_mod: int   = 0
		var has_mag_ability: bool = false
		var best_mag_mod: int    = 0

		for ability: Dictionary in fighter["abilities"]:
			if int(ability["ability_type"]) != ABILITY_TYPE_DAMAGE:
				continue
			var stat: int = int(ability["modified_stat"])
			var mod: int  = ability["modifier"]
			if stat == STAT_PHYSICAL_ATTACK:
				best_phys_mod = maxi(best_phys_mod, mod)
			elif stat == STAT_MAGIC_ATTACK:
				if not has_mag_ability:
					has_mag_ability = true
					best_mag_mod = mod
				else:
					best_mag_mod = maxi(best_mag_mod, mod)
			elif stat == STAT_MIXED_ATTACK:
				best_phys_mod = maxi(best_phys_mod, mod)
				if not has_mag_ability:
					has_mag_ability = true
					best_mag_mod = mod
				else:
					best_mag_mod = maxi(best_mag_mod, mod)

		var label: String = display_name if count <= 1 else "%s (x%d)" % [display_name, count]

		var class_cells: Array = []
		var any_nonzero: bool   = false
		var min_hp_ratio: float = 999.0

		for cls: String in CLASS_ORDER:
			var def_pair: Array = profile[cls]
			var cls_phys_def: int = def_pair[0]
			var cls_mag_def: int  = def_pair[1]

			var phys_dmg: int = maxi(0, best_phys_mod + e_phys_atk - cls_phys_def)
			var mag_dmg: int  = 0
			if has_mag_ability:
				mag_dmg = maxi(0, best_mag_mod + e_mag_atk - cls_mag_def)

			if phys_dmg > 0 or mag_dmg > 0:
				any_nonzero = true

			var max_dmg: int = maxi(phys_dmg, mag_dmg)
			if max_dmg > 0:
				min_hp_ratio = minf(min_hp_ratio, float(e_hp) / float(max_dmg))

			class_cells.append("%dp/%dm" % [phys_dmg, mag_dmg])

		# TTK: Squire basic-attack hits to kill this enemy
		var sq_dmg_vs_enemy: int = maxi(1, sq_atk - e_phys_def)
		var ttk: int = int(ceil(float(e_hp) / float(sq_dmg_vs_enemy)))

		var flags: String = ""
		if not any_nonzero:
			flags += " ⚠ZERO"
			zero_names.append(label)
		elif min_hp_ratio < 3.0:
			flags += " ⚠SPIKE"
			spike_names.append(label)
		if ttk > 10:
			flags += " ⚠SLOW"
			slow_names.append(label)

		print("%-22s %4d │ %-13s %-13s %-13s %-12s │ %3d%s" % [
			label, e_hp,
			class_cells[0], class_cells[1], class_cells[2], class_cells[3],
			ttk, flags
		])

	print("")
	if zero_names.is_empty() and spike_names.is_empty() and slow_names.is_empty():
		print("  ✓ All clear — damage present, no spikes, TTK ≤ 10")
	if not zero_names.is_empty():
		print("  ⚠ ZERO  — deals 0 to all classes: " + ", ".join(zero_names))
	if not spike_names.is_empty():
		print("  ⚠ SPIKE — kills a class in <3 hits: " + ", ".join(spike_names))
	if not slow_names.is_empty():
		print("  ⚠ SLOW  — Squire needs >10 hits: " + ", ".join(slow_names))
