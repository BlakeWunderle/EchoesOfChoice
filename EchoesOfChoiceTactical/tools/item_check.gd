extends SceneTree
## Equipment balance checker — run with:
##   "<godot_exe>" --path EchoesOfChoiceTactical --headless --script res://tools/item_check.gd
##
## Optional filters (after --):
##   -- squire       show only Squire rows
##   -- ranger       show only Ranger rows (any class in CLASS_PROFILES)
##   -- 0 / 1 / 2   show only that tier
##   -- squire 1     Squire at Tier 1 only
##
## First run: no filter → full discovery pass to see which class benefits most
## from each item group. Then use class filter for targeted re-checks.
##
## Output per item: Dmg | TTK | TTS | ΔKill | ΔSurv
##   Dmg   = damage equipped unit deals to bare opponent per basic attack
##   TTK   = hits for equipped unit to kill bare opponent  (∞ = cannot)
##   TTS   = hits for bare opponent to kill equipped unit  (∞ = cannot)
##   ΔKill = baseline_TTK − TTK  (positive = kills faster)
##   ΔSurv = TTS − baseline_TTS  (positive = survives longer)

# ─── Stat-type integer constants (mirrors Enums.StatType) ────────────────────
const STAT_PA: int      = 0   # PHYSICAL_ATTACK
const STAT_PD: int      = 1   # PHYSICAL_DEFENSE
const STAT_MA: int      = 2   # MAGIC_ATTACK
const STAT_MD: int      = 3   # MAGIC_DEFENSE
const STAT_SPD: int     = 7   # SPEED
const STAT_DODGE: int   = 8   # DODGE_CHANCE
const STAT_HP: int      = 10  # MAX_HEALTH
const STAT_MP: int      = 11  # MAX_MANA
const STAT_CRIT: int    = 12  # CRIT_CHANCE
const STAT_CRITD: int   = 13  # CRIT_DAMAGE
const STAT_MOV: int     = 14  # MOVEMENT
const STAT_JUMP: int    = 15  # JUMP

const STAT_NAMES: Dictionary = {
	0: "P.Atk", 1: "P.Def", 2: "M.Atk", 3: "M.Def",
	7: "Speed", 8: "Dodge%", 10: "HP", 11: "Mana",
	12: "Crit%", 13: "CritDmg", 14: "Move", 15: "Jump"
}

const INF_HITS: int = 9999  # sentinel for "cannot kill / cannot be killed"

# ─── Reference class profiles ─────────────────────────────────────────────────
# Base + growth*(level-1), no equipment.
# Tier checkpoints: T0 → Lv2, T1 → Lv4, T2 → Lv6
# T0 classes have Lv2/4/6, T1 classes have Lv4/6, T2 classes have Lv6 only.
const CLASS_PROFILES: Dictionary = {
	# ── T0 base classes ──────────────────────────────────────────────────────
	"squire": {
		# PA=21+2*(L-1), PD=15+2*(L-1), HP=55+8*(L-1), MA=9+2*(L-1), MD=11+2*(L-1)
		# Spd=13+3*(L-1), Crit=15, CritDmg=2, Dodge=5, Move=4, Jump=2
		2: {"pa": 23, "pd": 17, "ma": 11, "md": 13, "hp": 63, "mana": 11,
			"speed": 16, "crit": 15, "crit_dmg": 2, "dodge": 5, "move": 4, "jump": 2},
		4: {"pa": 27, "pd": 21, "ma": 15, "md": 17, "hp": 79, "mana": 15,
			"speed": 22, "crit": 15, "crit_dmg": 2, "dodge": 5, "move": 4, "jump": 2},
		6: {"pa": 31, "pd": 25, "ma": 19, "md": 21, "hp": 95, "mana": 19,
			"speed": 28, "crit": 15, "crit_dmg": 2, "dodge": 5, "move": 4, "jump": 2},
	},
	"mage": {
		# PA=11+2*(L-1), PD=11+2*(L-1), HP=49+6*(L-1), MA=23+2*(L-1), MD=18+2*(L-1)
		# Spd=15+3*(L-1), Crit=5, CritDmg=1, Dodge=5, Move=3, Jump=1
		2: {"pa": 13, "pd": 13, "ma": 25, "md": 20, "hp": 55, "mana": 22,
			"speed": 18, "crit": 5, "crit_dmg": 1, "dodge": 5, "move": 3, "jump": 1},
		4: {"pa": 17, "pd": 17, "ma": 29, "md": 24, "hp": 67, "mana": 28,
			"speed": 24, "crit": 5, "crit_dmg": 1, "dodge": 5, "move": 3, "jump": 1},
		6: {"pa": 21, "pd": 21, "ma": 33, "md": 28, "hp": 79, "mana": 31,
			"speed": 30, "crit": 5, "crit_dmg": 1, "dodge": 5, "move": 3, "jump": 1},
	},
	"scholar": {
		# PA=7+2*(L-1), PD=12+2*(L-1), HP=44+7*(L-1), MA=20+2*(L-1), MD=20+2*(L-1)
		# Spd=13+3*(L-1), Crit=5, CritDmg=1, Dodge=5, Move=3, Jump=1
		2: {"pa": 9, "pd": 14, "ma": 22, "md": 22, "hp": 51, "mana": 16,
			"speed": 16, "crit": 5, "crit_dmg": 1, "dodge": 5, "move": 3, "jump": 1},
		4: {"pa": 13, "pd": 18, "ma": 26, "md": 26, "hp": 65, "mana": 20,
			"speed": 22, "crit": 5, "crit_dmg": 1, "dodge": 5, "move": 3, "jump": 1},
		6: {"pa": 17, "pd": 22, "ma": 30, "md": 30, "hp": 79, "mana": 24,
			"speed": 28, "crit": 5, "crit_dmg": 1, "dodge": 5, "move": 3, "jump": 1},
	},
	# ── T1 representatives ───────────────────────────────────────────────────
	"ranger": {
		# PA=24+3*(L-1), PD=17+2*(L-1), HP=59+10*(L-1), MA=9+3*(L-1), MD=11+2*(L-1)
		# Spd=16+3*(L-1), Crit=20, CritDmg=3, Dodge=5, Move=5, Jump=3
		4: {"pa": 33, "pd": 23, "ma": 18, "md": 17, "hp": 89, "mana": 15,
			"speed": 25, "crit": 20, "crit_dmg": 3, "dodge": 5, "move": 5, "jump": 3},
		6: {"pa": 39, "pd": 27, "ma": 24, "md": 21, "hp": 109, "mana": 19,
			"speed": 31, "crit": 20, "crit_dmg": 3, "dodge": 5, "move": 5, "jump": 3},
	},
	"firebrand": {
		# PA=14+2*(L-1), PD=10+2*(L-1), HP=49+7*(L-1), MA=28+7*(L-1), MD=18+3*(L-1)
		# Spd=17+3*(L-1), Crit=10, CritDmg=2, Dodge=5, Move=3, Jump=1
		4: {"pa": 20, "pd": 16, "ma": 49, "md": 27, "hp": 70, "mana": 34,
			"speed": 26, "crit": 10, "crit_dmg": 2, "dodge": 5, "move": 3, "jump": 1},
		6: {"pa": 24, "pd": 20, "ma": 63, "md": 33, "hp": 84, "mana": 44,
			"speed": 32, "crit": 10, "crit_dmg": 2, "dodge": 5, "move": 3, "jump": 1},
	},
	"dervish": {
		# PA=14+4*(L-1), PD=12+2*(L-1), HP=49+6*(L-1), MA=21+4*(L-1), MD=18+2*(L-1)
		# Spd=20+4*(L-1), Crit=10, CritDmg=2, Dodge=15, Move=5, Jump=2
		4: {"pa": 26, "pd": 18, "ma": 33, "md": 24, "hp": 67, "mana": 23,
			"speed": 32, "crit": 10, "crit_dmg": 2, "dodge": 15, "move": 5, "jump": 2},
		6: {"pa": 34, "pd": 22, "ma": 41, "md": 28, "hp": 79, "mana": 29,
			"speed": 40, "crit": 10, "crit_dmg": 2, "dodge": 15, "move": 5, "jump": 2},
	},
	# ── T2 representatives ───────────────────────────────────────────────────
	"ninja": {
		# PA=27+5*(L-1), PD=14+2*(L-1), HP=59+10*(L-1), MA=9+2*(L-1), MD=10+2*(L-1)
		# Spd=19+5*(L-1), Crit=25, CritDmg=3, Dodge=15, Move=5, Jump=3
		6: {"pa": 52, "pd": 24, "ma": 19, "md": 20, "hp": 109, "mana": 22,
			"speed": 44, "crit": 25, "crit_dmg": 3, "dodge": 15, "move": 5, "jump": 3},
	},
	"illusionist": {
		# PA=14+3*(L-1), PD=10+2*(L-1), HP=55+9*(L-1), MA=26+6*(L-1), MD=17+3*(L-1)
		# Spd=18+5*(L-1), Crit=15, CritDmg=2, Dodge=20, Move=4, Jump=2
		6: {"pa": 29, "pd": 20, "ma": 56, "md": 32, "hp": 100, "mana": 31,
			"speed": 43, "crit": 15, "crit_dmg": 2, "dodge": 20, "move": 4, "jump": 2},
	},
	"mercenary": {
		# PA=26+5*(L-1), PD=14+2*(L-1), HP=59+10*(L-1), MA=9+2*(L-1), MD=10+2*(L-1)
		# Spd=18+5*(L-1), Crit=30, CritDmg=7, Dodge=5, Move=5, Jump=2
		6: {"pa": 51, "pd": 24, "ma": 19, "md": 20, "hp": 109, "mana": 19,
			"speed": 43, "crit": 30, "crit_dmg": 7, "dodge": 5, "move": 5, "jump": 2},
	},
}

const CLASS_DISPLAY_ORDER: Array = [
	"squire", "mage", "scholar",
	"ranger", "firebrand", "dervish",
	"ninja", "illusionist", "mercenary",
]

# Tier → (level checkpoint, equipment slot count)
const TIER_CHECKPOINTS: Dictionary = {
	0: {"level": 2, "slots": 1},
	1: {"level": 4, "slots": 2},
	2: {"level": 6, "slots": 3},
}

# ─── Preset combo loadouts ────────────────────────────────────────────────────
# Tested at Lv6. Each entry: {label, bonuses, slots}
# bonuses = stat_key → total bonus amount
# Equipment values: PA/PD/MA/MD 0:+3 1:+5 2:+8, HP 0:+5 1:+10 2:+15,
#   Spd 0:+2 1:+3 2:+5, Crit 1:+5 2:+10, Dodge 1:+5 2:+10
const COMBOS: Dictionary = {
	"squire": [
		{"label": "2x PA T1",         "bonuses": {0: 10},               "slots": 2},
		{"label": "PA1 + PD1",        "bonuses": {0: 5, 1: 5},          "slots": 2},
		{"label": "PA1 + HP1",        "bonuses": {0: 5, 10: 10},        "slots": 2},
		{"label": "3x PA T2",         "bonuses": {0: 24},               "slots": 3},
		{"label": "3x PD T2",         "bonuses": {1: 24},               "slots": 3},
		{"label": "PA(0+1+2)",        "bonuses": {0: 16},               "slots": 3},
		{"label": "PA2+Spd2+Crit2",   "bonuses": {0: 8, 7: 5, 12: 10}, "slots": 3},
		{"label": "PD2+HP2+MD2",      "bonuses": {1: 8, 10: 15, 3: 8}, "slots": 3},
		{"label": "PA2+PD2+HP2",      "bonuses": {0: 8, 1: 8, 10: 15}, "slots": 3},
	],
	"mage": [
		{"label": "2x MA T1",         "bonuses": {2: 10},               "slots": 2},
		{"label": "MA1 + MD1",        "bonuses": {2: 5, 3: 5},          "slots": 2},
		{"label": "MA1 + HP1",        "bonuses": {2: 5, 10: 10},        "slots": 2},
		{"label": "3x MA T2",         "bonuses": {2: 24},               "slots": 3},
		{"label": "3x MD T2",         "bonuses": {3: 24},               "slots": 3},
		{"label": "MA(0+1+2)",        "bonuses": {2: 16},               "slots": 3},
		{"label": "MA2+Spd2+Crit2",   "bonuses": {2: 8, 7: 5, 12: 10}, "slots": 3},
		{"label": "MD2+HP2+PD2",      "bonuses": {3: 8, 10: 15, 1: 8}, "slots": 3},
		{"label": "MA2+MD2+HP2",      "bonuses": {2: 8, 3: 8, 10: 15}, "slots": 3},
	],
	"scholar": [
		{"label": "2x MA T1",         "bonuses": {2: 10},               "slots": 2},
		{"label": "MA1 + MD1",        "bonuses": {2: 5, 3: 5},          "slots": 2},
		{"label": "MA1 + Dodge1",     "bonuses": {2: 5, 8: 5},          "slots": 2},
		{"label": "3x MA T2",         "bonuses": {2: 24},               "slots": 3},
		{"label": "3x MD T2",         "bonuses": {3: 24},               "slots": 3},
		{"label": "MA(0+1+2)",        "bonuses": {2: 16},               "slots": 3},
		{"label": "MA2+Dod2+HP2",     "bonuses": {2: 8, 8: 10, 10: 15},"slots": 3},
		{"label": "MD2+HP2+Spd2",     "bonuses": {3: 8, 10: 15, 7: 5}, "slots": 3},
		{"label": "MA2+MD2+HP2",      "bonuses": {2: 8, 3: 8, 10: 15}, "slots": 3},
	],
	"ranger": [
		{"label": "PA1 + Crit1",      "bonuses": {0: 5, 12: 5},         "slots": 2},
		{"label": "PA1 + HP1",        "bonuses": {0: 5, 10: 10},        "slots": 2},
		{"label": "PA2+Crit2+Spd2",   "bonuses": {0: 8, 12: 10, 7: 5}, "slots": 3},
		{"label": "3x PA",            "bonuses": {0: 24},               "slots": 3},
	],
	"firebrand": [
		{"label": "MA1 + HP1",        "bonuses": {2: 5, 10: 10},        "slots": 2},
		{"label": "MA1 + MD1",        "bonuses": {2: 5, 3: 5},          "slots": 2},
		{"label": "MA2+Crit2+Spd2",   "bonuses": {2: 8, 12: 10, 7: 5}, "slots": 3},
		{"label": "MA2+HP2+MD2",      "bonuses": {2: 8, 10: 15, 3: 8}, "slots": 3},
	],
	"dervish": [
		{"label": "MA1 + Dodge1",     "bonuses": {2: 5, 8: 5},          "slots": 2},
		{"label": "MA1 + Spd1",       "bonuses": {2: 5, 7: 3},          "slots": 2},
		{"label": "MA2+Dod2+Spd2",    "bonuses": {2: 8, 8: 10, 7: 5},  "slots": 3},
		{"label": "MA2+MA1+Dod1",     "bonuses": {2: 13, 8: 5},         "slots": 3},
	],
	"ninja": [
		{"label": "PA2+Crit2+Spd2",   "bonuses": {0: 8, 12: 10, 7: 5}, "slots": 3},
		{"label": "3x PA",            "bonuses": {0: 24},               "slots": 3},
		{"label": "PA2+Dod2+Spd2",    "bonuses": {0: 8, 8: 10, 7: 5},  "slots": 3},
	],
	"illusionist": [
		{"label": "MA2+Dod2+Spd2",    "bonuses": {2: 8, 8: 10, 7: 5},  "slots": 3},
		{"label": "3x MA",            "bonuses": {2: 24},               "slots": 3},
		{"label": "MA2+MA1+Dod1",     "bonuses": {2: 13, 8: 5},         "slots": 3},
	],
	"mercenary": [
		{"label": "PA2+Crit2+Spd2",   "bonuses": {0: 8, 12: 10, 7: 5}, "slots": 3},
		{"label": "3x PA",            "bonuses": {0: 24},               "slots": 3},
		{"label": "PA2+Crit2+HP2",    "bonuses": {0: 8, 12: 10, 10: 15},"slots": 3},
	],
}

# Best-fit class per primary stat for story item testing
const BEST_FIT: Dictionary = {
	0:  "ranger",      # P.Atk → physical attacker
	1:  "squire",      # P.Def → physical tank
	2:  "firebrand",   # M.Atk → magic glass cannon
	3:  "scholar",     # M.Def → magic defender
	7:  "dervish",     # Speed → dodge-based benefits most from speed
	8:  "illusionist", # Dodge% → highest dodge base
	10: "squire",      # HP → tank benefits most from bulk
	11: "firebrand",   # Mana → mana-hungry caster
	12: "mercenary",   # Crit% → crit specialist
	13: "mercenary",   # CritDmg → crit specialist
	14: "squire",      # Move → slowest class benefits most
	15: "squire",      # Jump → lowest jump benefits most
}


# ─── .tres item parser ────────────────────────────────────────────────────────
## Reads an equipment .tres file as text. Returns {} if not found or not equipment.
func _parse_tres_item(res_path: String) -> Dictionary:
	var abs_path: String = ProjectSettings.globalize_path(res_path)
	var f: FileAccess = FileAccess.open(abs_path, FileAccess.READ)
	if f == null:
		return {}

	var props: Dictionary = {}          # string and int properties
	var stat_bonuses: Dictionary = {}   # int stat_key → int bonus
	var unlock_classes: Array = []      # Array[String]
	var in_resource: bool = false
	var in_dict: bool = false           # inside a multi-line stat_bonuses { ... }

	while not f.eof_reached():
		var raw: String = f.get_line()
		var line: String = raw.strip_edges()

		if line == "[resource]":
			in_resource = true
			continue

		if not in_resource:
			continue

		if line.is_empty() or line.begins_with(";"):
			continue

		# Section change ends any open dict
		if line.begins_with("["):
			in_dict = false
			continue

		# ── Multi-line stat_bonuses collection ───────────────────────────────
		if in_dict:
			if line == "}" or line == "},":
				in_dict = false
				continue
			_parse_kv_into_dict(line, stat_bonuses)
			continue

		# ── Normal property lines ─────────────────────────────────────────────
		var eq: int = line.find(" = ")
		if eq < 0:
			continue
		var key: String = line.substr(0, eq).strip_edges()
		var val: String = line.substr(eq + 3).strip_edges()

		if key == "stat_bonuses":
			if val == "{}" or val == "{ }":
				continue  # empty dict
			elif val.begins_with("{"):
				if val.ends_with("}"):
					# Inline single-line dict: {0: 8} or {0: 8, 1: 3}
					var inner: String = val.substr(1, val.length() - 2)
					for pair: String in inner.split(","):
						_parse_kv_into_dict(pair.strip_edges(), stat_bonuses)
				else:
					# Opening brace; content on subsequent lines
					in_dict = true
					var after: String = val.substr(1).strip_edges()
					if not after.is_empty() and after != "{":
						_parse_kv_into_dict(after, stat_bonuses)
			continue

		if key == "unlock_class_ids":
			var s: int = val.find("(")
			var e: int = val.rfind(")")
			if s >= 0 and e > s:
				var inner: String = val.substr(s + 1, e - s - 1)
				# Handle both PackedStringArray("a","b") and PackedStringArray(["a","b"])
				inner = inner.strip_edges().trim_prefix("[").trim_suffix("]")
				for part: String in inner.split(","):
					part = part.strip_edges().trim_prefix("\"").trim_suffix("\"")
					if not part.is_empty():
						unlock_classes.append(part)
			continue

		# String property: "value"
		if val.begins_with("\"") and val.ends_with("\"") and val.length() >= 2:
			props[key] = val.substr(1, val.length() - 2)
			continue

		# Integer property
		if val.is_valid_int():
			props[key] = val.to_int()

	f.close()

	# Only process equipment items (item_type = 1)
	if props.get("item_type", -1) != 1:
		return {}

	return {
		"item_id":       props.get("item_id", ""),
		"display_name":  props.get("display_name", "?"),
		"buy_price":     props.get("buy_price", 0),
		"unlock_tier":   props.get("unlock_tier", 0),
		"stat_bonuses":  stat_bonuses,
		"unlock_classes": unlock_classes,
	}


## Parse a single "key: value" or "key: value," pair into a dictionary.
func _parse_kv_into_dict(text: String, out: Dictionary) -> void:
	text = text.strip_edges().trim_suffix(",")
	var c: int = text.find(":")
	if c < 0:
		return
	var k_str: String = text.substr(0, c).strip_edges()
	var v_str: String = text.substr(c + 1).strip_edges()
	if k_str.is_valid_int() and v_str.is_valid_int():
		out[k_str.to_int()] = v_str.to_int()


# ─── Stat helpers ─────────────────────────────────────────────────────────────

## Apply item stat bonuses to a class profile copy.
func _apply_bonuses(base: Dictionary, bonuses: Dictionary) -> Dictionary:
	var out: Dictionary = base.duplicate()
	for sk: Variant in bonuses:
		var b: int = int(bonuses[sk])
		match int(sk):
			0:  out["pa"] += b
			1:  out["pd"] += b
			2:  out["ma"] += b
			3:  out["md"] += b
			7:  out["speed"] += b
			8:  out["dodge"] += b
			10: out["hp"] += b
			11: out["mana"] += b
			12: out["crit"] += b
			13: out["crit_dmg"] += b
			14: out["move"] += b
			15: out["jump"] += b
	return out


## Run a mirror fight. a = equipped unit, b = bare unit.
## Returns {ttk, tts, dmg_a, dmg_b}.
func _mirror_fight(a: Dictionary, b: Dictionary) -> Dictionary:
	var phys_a: int = maxi(0, a["pa"] - b["pd"])
	var mag_a:  int = maxi(0, a["ma"] - b["md"])
	var phys_b: int = maxi(0, b["pa"] - a["pd"])
	var mag_b:  int = maxi(0, b["ma"] - a["md"])
	var dmg_a: int  = maxi(phys_a, mag_a)
	var dmg_b: int  = maxi(phys_b, mag_b)
	var ttk: int    = INF_HITS if dmg_a == 0 else int(ceil(float(b["hp"]) / float(dmg_a)))
	var tts: int    = INF_HITS if dmg_b == 0 else int(ceil(float(a["hp"]) / float(dmg_b)))
	return {"ttk": ttk, "tts": tts, "dmg_a": dmg_a, "dmg_b": dmg_b}


## Map a stat key to the profile dict field name.
func _stat_field(sk: int) -> String:
	match sk:
		0:  return "pa"
		1:  return "pd"
		2:  return "ma"
		3:  return "md"
		7:  return "speed"
		8:  return "dodge"
		10: return "hp"
		11: return "mana"
		12: return "crit"
		13: return "crit_dmg"
		14: return "move"
		15: return "jump"
	return ""


## Return the stat key with the largest bonus in a dict.
func _primary_stat(bonuses: Dictionary) -> int:
	var best_k: int = -1
	var best_v: int = 0
	for sk: Variant in bonuses:
		if int(bonuses[sk]) > best_v:
			best_v = int(bonuses[sk])
			best_k = int(sk)
	return best_k


## Build a compact bonus label, e.g. "+8 P.Atk" or "+6 M.Atk/+8 Mana".
func _bonus_str(bonuses: Dictionary) -> String:
	var parts: Array = []
	for sk: Variant in bonuses:
		var sname: String = STAT_NAMES.get(int(sk), "s%d" % int(sk))
		parts.append("+%d %s" % [int(bonuses[sk]), sname])
	return "/".join(parts) if not parts.is_empty() else "(none)"


## Pick best-fit class for a given primary stat (see BEST_FIT constant).
func _best_fit_class(pstat: int) -> String:
	return BEST_FIT.get(pstat, "squire")


# ─── Formatting ───────────────────────────────────────────────────────────────

func _fmt(n: int) -> String:
	return "∞" if n >= INF_HITS else str(n)


func _fmt_d(n: int) -> String:
	if n >= INF_HITS:  return "+∞"
	if n == 0:         return "0"
	if n > 0:          return "+%d" % n
	return str(n)


## Build utility note for items with no mirror-fight combat effect.
func _utility_note(bonuses: Dictionary, profile: Dictionary) -> String:
	var pstat: int = _primary_stat(bonuses)
	var delta: int = int(bonuses.get(pstat, 0))
	match pstat:
		STAT_SPD:
			var base: int = profile["speed"]
			var pct: int = int(round(float(delta) / float(maxi(1, base)) * 100.0))
			return "≈+%d%% Spd (%d→%d)" % [pct, base, base + delta]
		STAT_MOV:
			var base: int = profile["move"]
			return "+%d tiles move (%d→%d)" % [delta, base, base + delta]
		STAT_JUMP:
			var base: int = profile["jump"]
			return "+%d jump (%d→%d)" % [delta, base, base + delta]
		STAT_MP:
			return "⚠WEAK (spell fuel, no mirror effect)"
		STAT_CRIT:
			var base_c: int = profile["crit"]
			var new_c: int  = base_c + delta
			var cd: int     = profile["crit_dmg"]
			# Expected flat dmg increase per hit = (delta/100) * crit_damage
			var extra: float = float(delta) / 100.0 * float(cd)
			return "crit %d%%→%d%% (≈+%.1f avg dmg, cd=%d)" % [base_c, new_c, extra, cd]
		STAT_DODGE:
			var base_d: int = profile["dodge"]
			var new_d: int  = base_d + delta
			return "+%d%% dodge (%d%%→%d%%)" % [delta, base_d, new_d]
	return ""


# ─── Per-class/tier report ────────────────────────────────────────────────────

func _report_class_tier(
		cls: String, tier: int, level: int,
		items: Array, profile: Dictionary) -> void:

	var base: Dictionary = _mirror_fight(profile, profile)
	var base_ttk: int  = base["ttk"]
	var base_tts: int  = base["tts"]
	var base_dmg: int  = base["dmg_a"]

	var degenerate: bool = (base_dmg == 0 and base["dmg_b"] == 0)

	print("")
	print("═══ %s Lv%d [T%d | PA%d PD%d MA%d MD%d HP%d Spd%d] ═══" % [
		cls.capitalize(), level, tier,
		profile["pa"], profile["pd"], profile["ma"], profile["md"],
		profile["hp"], profile["speed"]
	])
	if degenerate:
		print("Baseline: 0 dmg both ways (class cannot penetrate its own defenses)")
		print("Items that break through are marked ✓BREAK.")
	else:
		print("Baseline mirror (bare vs bare): Dmg=%d  TTK=%s  TTS=%s" % [
			base_dmg, _fmt(base_ttk), _fmt(base_tts)
		])

	print("")
	print("%-22s  %-26s  %3s  %4s  %4s  %5s  %5s  %5s  Notes" % [
		"Item", "Bonus", "Dmg", "TTK", "TTS", "ΔKill", "ΔSurv", "Price"
	])
	print("─".repeat(100))
	if not degenerate:
		print("%-22s  %-26s  %3d  %4s  %4s  %5s  %5s  %5s" % [
			"[bare]", "",
			base_dmg, _fmt(base_ttk), _fmt(base_tts), "—", "—", "—"
		])

	var immune_names: Array = []
	var spike_names: Array  = []
	var weak_names: Array   = []
	var break_names: Array  = []

	for item: Dictionary in items:
		var bonuses: Dictionary = item["stat_bonuses"]
		var equipped: Dictionary = _apply_bonuses(profile, bonuses)
		var fight: Dictionary    = _mirror_fight(equipped, profile)
		var ttk: int  = fight["ttk"]
		var tts: int  = fight["tts"]
		var dmg: int  = fight["dmg_a"]
		var dmg_b: int = fight["dmg_b"]   # bare's attack against equipped unit

		# ΔKill: positive = equipped kills faster
		var dkill: int
		if base_ttk >= INF_HITS and ttk < INF_HITS:
			dkill = INF_HITS   # item breaks immunity → show +∞
		elif base_ttk >= INF_HITS:
			dkill = 0
		else:
			dkill = base_ttk - ttk

		# ΔSurv: positive = equipped survives longer
		var dsurv: int
		if tts >= INF_HITS and base_tts < INF_HITS:
			dsurv = INF_HITS   # item grants immunity → show +∞
		elif base_tts >= INF_HITS:
			dsurv = 0
		else:
			dsurv = tts - base_tts

		var price_str: String = "free" if item["buy_price"] == 0 else str(item["buy_price"])
		var bstr: String      = _bonus_str(bonuses)
		var pstat: int        = _primary_stat(bonuses)
		var notes: String     = ""

		# ── Flag evaluation ──────────────────────────────────────────────────

		# Item breaks a degenerate (0-damage) mirror
		if dkill >= INF_HITS:
			notes += " ✓BREAK"
			break_names.append(item["display_name"])
		# Equipped unit becomes immune to bare
		elif dmg_b == 0 and base["dmg_b"] > 0:
			notes += " ⚠IMMUNE"
			immune_names.append(item["display_name"])

		# Kills 2.5x faster than baseline
		if not degenerate and base_ttk < INF_HITS and ttk < INF_HITS and ttk > 0:
			if float(base_ttk) / float(ttk) >= 2.5:
				if not notes.contains("⚠SPIKE"):
					notes += " ⚠SPIKE"
					spike_names.append(item["display_name"])

		# No combat impact at all
		if dkill == 0 and dsurv == 0 and notes.is_empty():
			var unote: String = _utility_note(bonuses, profile)
			if not unote.is_empty():
				notes += "  " + unote
			elif pstat in [STAT_PA, STAT_MA, STAT_PD, STAT_MD, STAT_HP]:
				notes += "  ⚠WEAK"
				weak_names.append(item["display_name"])
			# else: some other stat type — skip flag

		# Class-restriction note
		if not item["unlock_classes"].is_empty():
			notes += "  [locked: %s]" % ", ".join(item["unlock_classes"])

		var dmg_str: String = _fmt(dmg) if dmg > 0 else ("0" if base_dmg > 0 else "—")
		print("%-22s  %-26s  %3s  %4s  %4s  %5s  %5s  %5s  %s" % [
			item["display_name"], bstr,
			dmg_str, _fmt(ttk), _fmt(tts),
			_fmt_d(dkill), _fmt_d(dsurv),
			price_str, notes
		])

	# ── Summary flags ────────────────────────────────────────────────────────
	print("")
	if immune_names.is_empty() and spike_names.is_empty() and weak_names.is_empty() and break_names.is_empty():
		print("  ✓ All clear")
	if not break_names.is_empty():
		print("  ✓ BREAK   — item breaks 0-dmg mirror: " + ", ".join(break_names))
	if not immune_names.is_empty():
		print("  ⚠ IMMUNE  — bare opponent deals 0 to equipped: " + ", ".join(immune_names))
	if not spike_names.is_empty():
		print("  ⚠ SPIKE   — kills 2.5× faster than baseline: " + ", ".join(spike_names))
	if not weak_names.is_empty():
		print("  ⚠ WEAK    — no combat effect in this mirror: " + ", ".join(weak_names))


# ─── Combo report ─────────────────────────────────────────────────────────────

func _report_combos(cls: String, profile: Dictionary) -> void:
	var base: Dictionary = _mirror_fight(profile, profile)
	var base_ttk: int    = base["ttk"]
	var base_tts: int    = base["tts"]
	var base_dmg: int    = base["dmg_a"]

	var combos: Array = COMBOS.get(cls, [])
	if combos.is_empty():
		return

	print("")
	print("─── Combos — %s Lv6 (T2 profile, slots per entry) ─────────────────────────────" % cls.capitalize())
	print("%-20s  %-26s  %3s  %4s  %4s  %5s  %5s  Flags" % [
		"Combo", "Total Bonus", "Dmg", "TTK", "TTS", "ΔKill", "ΔSurv"
	])
	print("─".repeat(100))
	print("%-20s  %-26s  %3d  %4s  %4s  %5s  %5s" % [
		"[bare]", "", base_dmg, _fmt(base_ttk), _fmt(base_tts), "—", "—"
	])

	for combo: Dictionary in combos:
		var bonuses: Dictionary   = combo["bonuses"]
		var slots: int            = combo["slots"]
		var equipped: Dictionary  = _apply_bonuses(profile, bonuses)
		var fight: Dictionary     = _mirror_fight(equipped, profile)
		var ttk: int              = fight["ttk"]
		var tts: int              = fight["tts"]
		var dmg: int              = fight["dmg_a"]
		var dmg_b: int            = fight["dmg_b"]

		var dkill: int
		if base_ttk >= INF_HITS and ttk < INF_HITS:
			dkill = INF_HITS
		elif base_ttk >= INF_HITS:
			dkill = 0
		else:
			dkill = base_ttk - ttk

		var dsurv: int
		if tts >= INF_HITS and base_tts < INF_HITS:
			dsurv = INF_HITS
		elif base_tts >= INF_HITS:
			dsurv = 0
		else:
			dsurv = tts - base_tts

		var flags: String = "[%d-slot]" % slots
		if dmg_b == 0 and base["dmg_b"] > 0:
			flags += " ⚠IMMUNE"
		if not (base_ttk >= INF_HITS) and ttk < INF_HITS and ttk > 0:
			if float(base_ttk) / float(ttk) >= 2.5:
				flags += " ⚠SPIKE"
		if dkill >= INF_HITS:
			flags += " ✓BREAK"
		if dkill == 0 and dsurv == 0:
			flags += " (no effect)"

		var bstr: String    = _bonus_str(bonuses)
		var dmg_str: String = _fmt(dmg) if dmg > 0 else ("0" if base_dmg > 0 else "—")

		print("%-20s  %-26s  %3s  %4s  %4s  %5s  %5s  %s" % [
			combo["label"], bstr,
			dmg_str, _fmt(ttk), _fmt(tts),
			_fmt_d(dkill), _fmt_d(dsurv),
			flags
		])


# ─── Main ─────────────────────────────────────────────────────────────────────

func _initialize() -> void:
	# ── Parse CLI args ────────────────────────────────────────────────────────
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var filter_class: String = ""
	var filter_tier: int = -1

	for arg: String in args:
		if arg in CLASS_PROFILES:
			filter_class = arg
		elif arg.is_valid_int():
			filter_tier = arg.to_int()

	# ── Load all equipment .tres files ────────────────────────────────────────
	var dir: DirAccess = DirAccess.open("res://resources/items/equipment/")
	if dir == null:
		print("ERROR: cannot open res://resources/items/equipment/")
		quit()
		return

	var all_items: Array = []
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		if not dir.current_is_dir() and fname.ends_with(".tres"):
			var path: String = "res://resources/items/equipment/" + fname
			var item: Dictionary = _parse_tres_item(path)
			if not item.is_empty():
				all_items.append(item)
		fname = dir.get_next()
	dir.list_dir_end()

	# Sort alphabetically within each group
	all_items.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return a["display_name"] < b["display_name"]
	)

	# Group by tier (story items = buy_price == 0, kept separate)
	var tier_groups: Dictionary = {0: [], 1: [], 2: [], "story": []}
	for item: Dictionary in all_items:
		if item["buy_price"] == 0:
			tier_groups["story"].append(item)
		else:
			var t: int = item["unlock_tier"]
			if tier_groups.has(t):
				tier_groups[t].append(item)

	# ── Per-class, per-tier reports ───────────────────────────────────────────
	var classes: Array = CLASS_DISPLAY_ORDER.duplicate()
	if not filter_class.is_empty():
		classes = [filter_class]

	var tiers: Array = [0, 1, 2]
	if filter_tier >= 0:
		tiers = [filter_tier]

	for cls: String in classes:
		if not CLASS_PROFILES.has(cls):
			continue
		var class_profs: Dictionary = CLASS_PROFILES[cls]

		for tier: int in tiers:
			var checkpoint: Dictionary = TIER_CHECKPOINTS[tier]
			var level: int = checkpoint["level"]
			if not class_profs.has(level):
				continue  # T1/T2 classes don't have lower-tier checkpoints
			var profile: Dictionary = class_profs[level]
			var items: Array = tier_groups[tier]
			_report_class_tier(cls, tier, level, items, profile)

		# Combos always shown at Lv6 (unless filtering to tier 0 or 1 only)
		if (filter_tier < 0 or filter_tier == 2) and class_profs.has(6):
			var t2_profile: Dictionary = class_profs[6]
			_report_combos(cls, t2_profile)

	# ── Story / Unique items ──────────────────────────────────────────────────
	if filter_tier < 0:
		var story_items: Array = tier_groups["story"]
		if not story_items.is_empty():
			print("")
			print("═══ Story / Unique Items (not purchasable) ═══")
			print("Mirror fight tested against best-fit class at Lv6 (T2 profile).")
			print("")
			print("%-22s  %-30s  %3s  %4s  %4s  %5s  %5s  Notes" % [
				"Item", "Bonuses", "Dmg", "TTK", "TTS", "ΔKill", "ΔSurv"
			])
			print("─".repeat(100))

			for item: Dictionary in story_items:
				var bonuses: Dictionary  = item["stat_bonuses"]
				var pstat: int           = _primary_stat(bonuses)
				var fit_cls: String      = _best_fit_class(pstat)
				if not filter_class.is_empty():
					fit_cls = filter_class

				var profs: Dictionary    = CLASS_PROFILES.get(fit_cls, CLASS_PROFILES["squire"])
				var profile: Dictionary  = profs[6]
				var equipped: Dictionary = _apply_bonuses(profile, bonuses)
				var base: Dictionary     = _mirror_fight(profile, profile)
				var fight: Dictionary    = _mirror_fight(equipped, profile)

				var ttk: int  = fight["ttk"]
				var tts: int  = fight["tts"]
				var dmg: int  = fight["dmg_a"]

				var dkill: int
				if base["ttk"] >= INF_HITS and ttk < INF_HITS:
					dkill = INF_HITS
				elif base["ttk"] >= INF_HITS:
					dkill = 0
				else:
					dkill = base["ttk"] - ttk

				var dsurv: int
				if tts >= INF_HITS and base["tts"] < INF_HITS:
					dsurv = INF_HITS
				elif base["tts"] >= INF_HITS:
					dsurv = 0
				else:
					dsurv = tts - base["tts"]

				var bstr: String     = _bonus_str(bonuses)
				var lock_str: String = ""
				if not item["unlock_classes"].is_empty():
					lock_str = "  [locked: %s]" % ", ".join(item["unlock_classes"])

				var dmg_str: String = _fmt(dmg) if dmg > 0 else ("0" if base["dmg_a"] > 0 else "—")

				print("%-22s  %-30s  %3s  %4s  %4s  %5s  %5s  (fit:%s)%s" % [
					item["display_name"], bstr,
					dmg_str, _fmt(ttk), _fmt(tts),
					_fmt_d(dkill), _fmt_d(dsurv),
					fit_cls, lock_str
				])

	print("")
	quit()
