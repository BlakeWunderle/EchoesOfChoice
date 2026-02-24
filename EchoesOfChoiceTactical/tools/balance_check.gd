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
# Squire: base_physical_attack=21, growth_physical_attack=2 → level L: 21+2*(L-1)
const SQUIRE_PHYS_ATK: Dictionary = {
	0: 21, 1: 23, 2: 25, 3: 27, 4: 27, 5: 29, 6: 31, 7: 31, 8: 33
}

# ─── Party defense profiles (P.Def equipment only, no M.Def equipment bonus) ─
# Base L1 stats:  Squire P15/M11  Mage P11/M18  Scholar P12/M20  Ent P12/M18
# Growth per level: all +2 P.Def / +2 M.Def, Entertainer M.Def +3/level
const PARTY: Dictionary = {
	0: {"level": 1, "squire": [15, 11], "mage": [11, 18], "scholar": [12, 20], "entertainer": [12, 18]},
	1: {"level": 2, "squire": [20, 13], "mage": [16, 20], "scholar": [17, 22], "entertainer": [17, 21]},
	2: {"level": 3, "squire": [22, 15], "mage": [18, 22], "scholar": [19, 24], "entertainer": [19, 24]},
	3: {"level": 4, "squire": [26, 17], "mage": [22, 24], "scholar": [23, 26], "entertainer": [23, 27]},
	4: {"level": 4, "squire": [26, 17], "mage": [22, 24], "scholar": [23, 26], "entertainer": [23, 27]},
	5: {"level": 5, "squire": [33, 19], "mage": [29, 26], "scholar": [30, 28], "entertainer": [30, 30]},
	6: {"level": 6, "squire": [35, 21], "mage": [31, 28], "scholar": [32, 30], "entertainer": [32, 33]},
	7: {"level": 6, "squire": [38, 21], "mage": [34, 28], "scholar": [35, 30], "entertainer": [35, 33]},
	8: {"level": 7, "squire": [41, 23], "mage": [37, 30], "scholar": [38, 32], "entertainer": [38, 36]},
}

const CLASS_ORDER: Array = ["squire", "mage", "scholar", "entertainer"]
const CLASS_LABELS: Array = ["vs Squire", "vs Mage", "vs Scholar", "vs Ent"]

# ─── Tier 1 representative defenders (available from Prog 1) ─────────────────
# No equipment bonus assumed. Format: [P.Def, M.Def] = base + growth*(level-1).
# Warden (phys tank): PD=23 g4, MD=13 g2 | Acolyte (mag tank): PD=13 g2, MD=23 g3
# Ranger (phys mid):  PD=17 g2, MD=11 g2 | Firebrand (mag glass): PD=10 g2, MD=18 g3
# Dervish (dodge):    PD=12 g2, MD=18 g2 | Martial Artist (phys glass): PD=14 g3, MD=10 g2
const T1_ORDER: Array = ["warden", "acolyte", "ranger", "firebrand", "dervish", "martial_artist"]
const PARTY_T1: Dictionary = {
	1: {"warden": [27, 15], "acolyte": [15, 26], "ranger": [19, 13], "firebrand": [12, 21], "dervish": [14, 20], "martial_artist": [17, 12]},
	2: {"warden": [31, 17], "acolyte": [17, 29], "ranger": [21, 15], "firebrand": [14, 24], "dervish": [16, 22], "martial_artist": [20, 14]},
	3: {"warden": [35, 19], "acolyte": [19, 32], "ranger": [23, 17], "firebrand": [16, 27], "dervish": [18, 24], "martial_artist": [23, 16]},
	4: {"warden": [35, 19], "acolyte": [19, 32], "ranger": [23, 17], "firebrand": [16, 27], "dervish": [18, 24], "martial_artist": [23, 16]},
	5: {"warden": [39, 21], "acolyte": [21, 35], "ranger": [25, 19], "firebrand": [18, 30], "dervish": [20, 26], "martial_artist": [26, 18]},
	6: {"warden": [43, 23], "acolyte": [23, 38], "ranger": [27, 21], "firebrand": [20, 33], "dervish": [22, 28], "martial_artist": [29, 20]},
	7: {"warden": [43, 23], "acolyte": [23, 38], "ranger": [27, 21], "firebrand": [20, 33], "dervish": [22, 28], "martial_artist": [29, 20]},
	8: {"warden": [47, 25], "acolyte": [25, 41], "ranger": [29, 23], "firebrand": [22, 36], "dervish": [24, 30], "martial_artist": [32, 22]},
}

# ─── Tier 2 representative defenders (available from Prog 3) ─────────────────
# Bastion (phys extreme): PD=28 g7, MD=15 g3 | Paladin (balanced): PD=22 g5, MD=18 g4
# Ninja (phys glass):     PD=14 g2, MD=10 g2 | Cavalry (phys atk): PD=14 g3, MD=10 g2
# Pyromancer (mag glass): PD=10 g2, MD=17 g3 | Priest (mag extreme): PD=13 g2, MD=21 g4
# Mercenary (crit):       PD=14 g2, MD=10 g2 | Illusionist (dodge): PD=10 g2, MD=17 g3
const T2_ORDER: Array = ["bastion", "paladin", "ninja", "cavalry", "pyromancer", "priest", "mercenary", "illusionist"]

# Short column labels for tier tables
const T_LABELS: Dictionary = {
	"warden": "Ward", "acolyte": "Aco", "ranger": "Rang",
	"firebrand": "Fire", "dervish": "Derv", "martial_artist": "MArt",
	"bastion": "Bast", "paladin": "Pala", "ninja": "Ninj", "cavalry": "Cav",
	"pyromancer": "Pyro", "priest": "Prie", "mercenary": "Merc", "illusionist": "Illu",
}
const PARTY_T2: Dictionary = {
	3: {"bastion": [49, 24], "paladin": [37, 30], "ninja": [20, 16], "cavalry": [23, 16], "pyromancer": [16, 26], "priest": [19, 33], "mercenary": [20, 16], "illusionist": [16, 26]},
	4: {"bastion": [49, 24], "paladin": [37, 30], "ninja": [20, 16], "cavalry": [23, 16], "pyromancer": [16, 26], "priest": [19, 33], "mercenary": [20, 16], "illusionist": [16, 26]},
	5: {"bastion": [56, 27], "paladin": [42, 34], "ninja": [22, 18], "cavalry": [26, 18], "pyromancer": [18, 29], "priest": [21, 37], "mercenary": [22, 18], "illusionist": [18, 29]},
	6: {"bastion": [63, 30], "paladin": [47, 38], "ninja": [24, 20], "cavalry": [29, 20], "pyromancer": [20, 32], "priest": [23, 41], "mercenary": [24, 20], "illusionist": [20, 32]},
	7: {"bastion": [63, 30], "paladin": [47, 38], "ninja": [24, 20], "cavalry": [29, 20], "pyromancer": [20, 32], "priest": [23, 41], "mercenary": [24, 20], "illusionist": [20, 32]},
	8: {"bastion": [70, 33], "paladin": [52, 42], "ninja": [26, 22], "cavalry": [32, 22], "pyromancer": [22, 35], "priest": [25, 45], "mercenary": [26, 22], "illusionist": [22, 35]},
}

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
	# ── Prog 4 ──────────────────────────────────────────────────────────────────
	"shore": {
		"prog": 4,
		"enemies": [
			{"res": "res://resources/enemies/siren.tres", "name": "Siren", "count": 3, "level": 4},
			{"res": "res://resources/enemies/nymph.tres", "name": "Nymph", "count": 2, "level": 4},
		],
	},
	"beach": {
		"prog": 4,
		"enemies": [
			{"res": "res://resources/enemies/pirate.tres",  "name": "Pirate",  "count": 3, "level": 4},
			{"res": "res://resources/enemies/captain.tres", "name": "Captain", "count": 1, "level": 4},
			{"res": "res://resources/enemies/kraken.tres",  "name": "Kraken",  "count": 1, "level": 4},
		],
	},
	"cemetery_battle": {
		"prog": 4,
		"enemies": [
			{"res": "res://resources/enemies/zombie.tres",  "name": "Zombie",  "count": 2, "level": 4},
			{"res": "res://resources/enemies/specter.tres", "name": "Specter", "count": 2, "level": 4},
			{"res": "res://resources/enemies/wraith.tres",  "name": "Wraith",  "count": 1, "level": 4},
		],
	},
	"box_battle": {
		"prog": 4,
		"enemies": [
			{"res": "res://resources/enemies/harlequin.tres",        "name": "Harlequin",  "count": 2, "level": 4},
			{"res": "res://resources/enemies/chanteuse.tres",        "name": "Chanteuse",  "count": 2, "level": 4},
			{"res": "res://resources/enemies/ringmaster.tres",       "name": "Ringmaster", "count": 1, "level": 4},
		],
	},
	"army_battle": {
		"prog": 4,
		"enemies": [
			{"res": "res://resources/enemies/draconian.tres", "name": "Draconian", "count": 2, "level": 4},
			{"res": "res://resources/enemies/chaplain.tres",  "name": "Chaplain",  "count": 2, "level": 4},
			{"res": "res://resources/enemies/commander.tres", "name": "Commander", "count": 1, "level": 4},
		],
	},
	"lab_battle": {
		"prog": 4,
		"enemies": [
			{"res": "res://resources/enemies/android.tres",   "name": "Android",   "count": 2, "level": 4},
			{"res": "res://resources/enemies/machinist.tres", "name": "Machinist", "count": 2, "level": 4},
			{"res": "res://resources/enemies/ironclad.tres",  "name": "Ironclad",  "count": 1, "level": 4},
		],
	},
	# ── Prog 5 ──────────────────────────────────────────────────────────────────
	"mirror_battle": {
		"prog": 5,
		"enemies": [
			{"res": "res://resources/enemies/void_stalker.tres",  "name": "Void Stalker",  "count": 1, "level": 5},
			{"res": "res://resources/enemies/gloom_stalker.tres", "name": "Gloom Stalker", "count": 1, "level": 5},
			{"res": "res://resources/enemies/night_prowler.tres", "name": "Night Prowler", "count": 2, "level": 5},
			{"res": "res://resources/enemies/dusk_moth.tres",     "name": "Dusk Moth",     "count": 1, "level": 5},
		],
	},
	"gate_ambush": {
		"prog": 5,
		"enemies": [
			{"res": "res://resources/enemies/gloom_stalker.tres", "name": "Gloom Stalker", "count": 1, "level": 5},
			{"res": "res://resources/enemies/night_prowler.tres", "name": "Night Prowler", "count": 2, "level": 5},
			{"res": "res://resources/enemies/cursed_peddler.tres", "name": "Cursed Peddler", "count": 1, "level": 5},
			{"res": "res://resources/enemies/dusk_moth.tres",     "name": "Dusk Moth",     "count": 1, "level": 5},
		],
	},
	# ── Prog 6 ──────────────────────────────────────────────────────────────────
	"city_gate_ambush": {
		"prog": 6,
		"enemies": [
			{"res": "res://resources/enemies/void_stalker.tres",  "name": "Void Stalker",  "count": 1, "level": 6},
			{"res": "res://resources/enemies/gloom_stalker.tres", "name": "Gloom Stalker", "count": 2, "level": 6},
			{"res": "res://resources/enemies/void_shade.tres",    "name": "Void Shade",    "count": 1, "level": 6},
			{"res": "res://resources/enemies/void_prowler.tres",  "name": "Void Prowler",  "count": 1, "level": 6},
		],
	},
	"return_city_1": {
		"prog": 6,
		"enemies": [
			{"res": "res://resources/enemies/seraph.tres",        "name": "Seraph",        "count": 1, "level": 6},
			{"res": "res://resources/enemies/arch_hellion.tres",  "name": "Arch Hellion",  "count": 1, "level": 6},
			{"res": "res://resources/enemies/void_prowler.tres",  "name": "Void Prowler",  "count": 2, "level": 6},
			{"res": "res://resources/enemies/gloom_stalker.tres", "name": "Gloom Stalker", "count": 1, "level": 6},
		],
	},
	"return_city_2": {
		"prog": 6,
		"enemies": [
			{"res": "res://resources/enemies/necromancer.tres",  "name": "Necromancer", "count": 1, "level": 6},
			{"res": "res://resources/enemies/elder_witch.tres",  "name": "Elder Witch", "count": 1, "level": 6},
			{"res": "res://resources/enemies/void_shade.tres",   "name": "Void Shade",  "count": 2, "level": 6},
			{"res": "res://resources/enemies/dread_wraith.tres", "name": "Dread Wraith","count": 1, "level": 6},
		],
	},
	"return_city_3": {
		"prog": 6,
		"enemies": [
			{"res": "res://resources/enemies/psion.tres",         "name": "Psion",         "count": 1, "level": 6},
			{"res": "res://resources/enemies/guard_scholar.tres", "name": "Guard Scholar", "count": 1, "level": 6},
			{"res": "res://resources/enemies/void_prowler.tres",  "name": "Void Prowler",  "count": 2, "level": 6},
			{"res": "res://resources/enemies/gloom_stalker.tres", "name": "Gloom Stalker", "count": 1, "level": 6},
		],
	},
	"return_city_4": {
		"prog": 6,
		"enemies": [
			{"res": "res://resources/enemies/warlock.tres",      "name": "Warlock",    "count": 1, "level": 6},
			{"res": "res://resources/enemies/shaman.tres",       "name": "Shaman",     "count": 1, "level": 6},
			{"res": "res://resources/enemies/void_shade.tres",   "name": "Void Shade", "count": 2, "level": 6},
			{"res": "res://resources/enemies/void_stalker.tres", "name": "Void Stalker","count": 1, "level": 6},
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


# ─── Tier damage helpers ─────────────────────────────────────────────────────

## Returns best physical/magic modifiers and scaled attack stats for an enemy.
func _best_mods(cf: Dictionary, e_lvl: int) -> Dictionary:
	var e_pa: int = cf["base_physical_attack"] + cf["growth_physical_attack"] * (e_lvl - 1)
	var e_ma: int = cf["base_magic_attack"] + cf["growth_magic_attack"] * (e_lvl - 1)
	var bp: int = 0
	var hm: bool = false
	var bm: int = 0
	for ab: Dictionary in cf["abilities"]:
		if int(ab["ability_type"]) != ABILITY_TYPE_DAMAGE:
			continue
		var st: int = int(ab["modified_stat"])
		var mo: int = ab["modifier"]
		if st == STAT_PHYSICAL_ATTACK:
			bp = maxi(bp, mo)
		elif st == STAT_MAGIC_ATTACK:
			if not hm:
				hm = true
				bm = mo
			else:
				bm = maxi(bm, mo)
		elif st == STAT_MIXED_ATTACK:
			bp = maxi(bp, mo)
			if not hm:
				hm = true
				bm = mo
			else:
				bm = maxi(bm, mo)
	return {"e_pa": e_pa, "e_ma": e_ma, "bp": bp, "hm": hm, "bm": bm}


## Reports a damage table for a tier of representative defender classes.
func _report_tier(tier_label: String, flag_prefix: String, order: Array,
		profiles: Dictionary, prog: int, fighters_cache: Array) -> void:
	if not profiles.has(prog):
		return
	var t: Dictionary = profiles[prog]

	print("")
	print("  %s:" % tier_label)

	# Column header
	var hdr: String = "    %-20s" % ""
	for cls: String in order:
		hdr += T_LABELS.get(cls, cls).rpad(9)
	print(hdr)

	# Defense reference row
	var drow: String = "    %-20s" % "Def (P/M):"
	for cls: String in order:
		drow += ("%d/%d" % [t[cls][0], t[cls][1]]).rpad(9)
	print(drow)

	# Per-enemy damage rows
	var class_any: Dictionary = {}
	for cls: String in order:
		class_any[cls] = false

	for cached: Dictionary in fighters_cache:
		var ce: Dictionary = cached["entry"]
		var cf: Dictionary = cached["fighter"]
		var mods: Dictionary = _best_mods(cf, ce["level"])
		var cnt: int = ce["count"]
		var lbl: String = ce["name"] if cnt <= 1 else "%s (x%d)" % [ce["name"], cnt]
		var line: String = "    %-20s" % lbl

		for cls: String in order:
			var pdmg: int = maxi(0, mods["bp"] + mods["e_pa"] - t[cls][0])
			var mdmg: int = 0
			if mods["hm"]:
				mdmg = maxi(0, mods["bm"] + mods["e_ma"] - t[cls][1])
			if pdmg > 0 or mdmg > 0:
				class_any[cls] = true
			var cell: String = "%d/%d" % [pdmg, mdmg] if (pdmg > 0 or mdmg > 0) else "--"
			line += cell.rpad(9)
		print(line)

	# Summary flags
	var immune: Array = []
	for cls: String in order:
		if not class_any[cls]:
			immune.append(T_LABELS.get(cls, cls))
	if immune.is_empty():
		print("  ✓ %s — all classes threatened" % tier_label)
	else:
		print("  ⚠ %sZERO — no enemy threatens: %s" % [flag_prefix, ", ".join(immune)])


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
	var easy_names: Array = []
	var fighters_cache: Array = []  # {entry, fighter} — reused for Tier 1 check

	for entry: Dictionary in bdata["enemies"]:
		var res_path: String = entry["res"]
		var display_name: String = entry["name"]
		var count: int = entry["count"]

		var fighter: Dictionary = _load_enemy(res_path)
		if fighter.is_empty():
			print("  [MISSING: %s]" % res_path)
			continue
		fighters_cache.append({"entry": entry, "fighter": fighter})

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
		if ttk <= 1:
			flags += " ⚠EASY"
			easy_names.append(label)

		print("%-22s %4d │ %-13s %-13s %-13s %-12s │ %3d%s" % [
			label, e_hp,
			class_cells[0], class_cells[1], class_cells[2], class_cells[3],
			ttk, flags
		])

	print("")
	if zero_names.is_empty() and spike_names.is_empty() and slow_names.is_empty() and easy_names.is_empty():
		print("  ✓ All clear — damage present, no spikes, TTK 2–10")
	if not zero_names.is_empty():
		print("  ⚠ ZERO  — deals 0 to all classes: " + ", ".join(zero_names))
	if not spike_names.is_empty():
		print("  ⚠ SPIKE — kills a class in <3 hits: " + ", ".join(spike_names))
	if not slow_names.is_empty():
		print("  ⚠ SLOW  — Squire needs >10 hits: " + ", ".join(slow_names))
	if not easy_names.is_empty():
		print("  ⚠ EASY  — Squire one-shots (TTK=1), needs more HP: " + ", ".join(easy_names))

	# Tier 1 representative class check (6 classes, available from Prog 1)
	if prog >= 1:
		_report_tier("Tier 1 defenders", "T1", T1_ORDER, PARTY_T1, prog, fighters_cache)

	# Tier 2 representative class check (8 classes, available from Prog 3)
	if prog >= 3:
		_report_tier("Tier 2 defenders", "T2", T2_ORDER, PARTY_T2, prog, fighters_cache)
