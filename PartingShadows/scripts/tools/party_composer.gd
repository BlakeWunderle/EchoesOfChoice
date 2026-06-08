class_name PartyComposer

## Generates all viable party combinations at T0/T1/T2 tiers.
## Port of C# PartingShadows/BattleSimulator/PartyComposer.cs.

const FighterDB := preload("res://scripts/data/fighter_db.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")
const FighterDBRoles := preload("res://scripts/data/fighter_db_roles.gd")
const EquipmentDB := preload("res://scripts/data/equipment_db.gd")
const UltimateDB := preload("res://scripts/data/ultimate_db.gd")

const LEVELS_AS_BASE := 3
const LEVELS_AS_TIER1 := 5

const BASE_TYPES: Array[String] = [
	"Squire", "Mage", "Entertainer", "Tinker", "Wildling", "Wanderer"]

const T1_UPGRADES := {
	"Squire": ["Sword", "Bow", "Headband"],
	"Mage": ["RedStone", "WhiteStone"],
	"Entertainer": ["Lyre", "Slippers", "Scroll"],
	"Tinker": ["Crystal", "Textbook", "Abacus"],
	"Wildling": ["Herbs", "Totem", "BeastClaw"],
	"Wanderer": ["Shield", "Compass"],
}

const T2_UPGRADES := {
	"Duelist": ["Horse", "Spear"],
	"Ranger": ["Gun", "Trap"],
	"MartialArtist": ["Sword", "Staff"],
	"Invoker": ["FireStone", "WaterStone", "LightningStone"],
	"Acolyte": ["Hammer", "HolyBook", "DarkOrb"],
	"Bard": ["Hat", "WarHorn"],
	"Dervish": ["Light", "Paint"],
	"Orator": ["Pen", "Medal"],
	"Artificer": ["Potion", "Hammer"],
	"Philosopher": ["TimeMachine", "Telescope"],
	"Arithmancer": ["ClockworkCore", "Computer"],
	"Herbalist": ["Venom", "Seedling"],
	"Shaman": ["Shrunkenhead", "SpiritOrb"],
	"Beastcaller": ["Feather", "Pelt"],
	"Sentinel": ["Fortress", "Mirror"],
	"Pathfinder": ["Torch", "Waterskin"],
}

static var _class_name_cache := {}
static var _class_id_cache := {}
static var _cached_t2_parties: Array = []


static func create_fighter(base_type: String, t1_item: String,
		t2_item: String, total_level_ups: int,
		equip_upgrades: int = 0, has_ultimate: bool = false) -> FighterData:
	var fighter := FighterDB.create_player(base_type, base_type)
	var remaining := total_level_ups

	var base_levels: int = mini(remaining, LEVELS_AS_BASE) if t1_item != "" else remaining
	for i in base_levels:
		FighterDB.level_up(fighter)
	remaining -= base_levels

	if t1_item != "":
		FighterDB.upgrade_class(fighter, t1_item)

		var t1_levels: int = mini(remaining, LEVELS_AS_TIER1) if t2_item != "" else remaining
		for i in t1_levels:
			FighterDB.level_up(fighter)
		remaining -= t1_levels

	if t2_item != "":
		FighterDB.upgrade_class(fighter, t2_item)
		for i in remaining:
			FighterDB.level_up(fighter)

	EquipmentDB.apply_random_equipment(fighter, equip_upgrades)

	if has_ultimate and t2_item != "":
		var ults: Array = UltimateDB.get_ultimates_for_class(fighter.class_id)
		if not ults.is_empty():
			fighter.ultimate = ults[randi() % ults.size()]

	return fighter


static func resolve_class_name(base_type: String, t1_item: String,
		t2_item: String) -> String:
	var key := base_type + ":" + t1_item + ":" + t2_item
	if _class_name_cache.has(key):
		return _class_name_cache[key]
	var fighter := create_fighter(base_type, t1_item, t2_item, 0)
	_class_name_cache[key] = fighter.character_type
	_class_id_cache[key] = fighter.class_id
	return fighter.character_type


static func resolve_class_id(base_type: String, t1_item: String,
		t2_item: String) -> String:
	var key := base_type + ":" + t1_item + ":" + t2_item
	if _class_id_cache.has(key):
		return _class_id_cache[key]
	resolve_class_name(base_type, t1_item, t2_item)
	return _class_id_cache.get(key, "")


static func get_party_description(party: Dictionary) -> String:
	var parts := PackedStringArray()
	for i in 3:
		parts.append(resolve_class_name(
			party.base_types[i], party.t1_items[i], party.t2_items[i]))
	return " / ".join(parts)


static func create_party(party: Dictionary, level_ups: int,
		equip_upgrades: int = 0, has_ultimate: bool = false) -> Array:
	var fighters := []
	for i in 3:
		var f := create_fighter(
			party.base_types[i], party.t1_items[i],
			party.t2_items[i], level_ups, equip_upgrades, has_ultimate)
		f.character_name = "Hero" + str(i + 1)
		fighters.append(f)
	return fighters


# =============================================================================
# Party generation
# =============================================================================

static func get_base_parties() -> Array:
	var parties := []
	var n: int = BASE_TYPES.size()
	for i in n:
		for j in range(i, n):
			for k in range(j, n):
				parties.append({
					"base_types": [BASE_TYPES[i], BASE_TYPES[j], BASE_TYPES[k]],
					"t1_items": ["", "", ""],
					"t2_items": ["", "", ""],
				})
	return parties


static func get_tier1_parties() -> Array:
	var classes := []  # Array of [base_type, t1_item]
	for bt in BASE_TYPES:
		for t1_item: String in T1_UPGRADES[bt]:
			classes.append([bt, t1_item])
	var parties := []
	var n: int = classes.size()
	for i in n:
		for j in range(i, n):
			for k in range(j, n):
				parties.append({
					"base_types": [classes[i][0], classes[j][0], classes[k][0]],
					"t1_items": [classes[i][1], classes[j][1], classes[k][1]],
					"t2_items": ["", "", ""],
				})
	# Filter parties with 3 low-offense classes (no damage dealer at all).
	return parties.filter(func(p: Dictionary) -> bool:
		var c := 0
		for i in 3:
			var cid := resolve_class_id(p.base_types[i], p.t1_items[i], "")
			if FighterDBRoles.is_low_offense_expected(cid):
				c += 1
		return c < 3)


static func get_tier2_parties() -> Array:
	if not _cached_t2_parties.is_empty():
		return _cached_t2_parties

	var classes := []  # Array of [base_type, t1_item, t2_item]
	for bt in BASE_TYPES:
		for t1_item: String in T1_UPGRADES[bt]:
			var t1_fighter := create_fighter(bt, t1_item, "", 0)
			var t1_cid: String = t1_fighter.class_id
			if T2_UPGRADES.has(t1_cid):
				for t2_item: String in T2_UPGRADES[t1_cid]:
					classes.append([bt, t1_item, t2_item])

	var parties := []
	var n: int = classes.size()
	for i in n:
		for j in range(i, n):
			for k in range(j, n):
				parties.append({
					"base_types": [classes[i][0], classes[j][0], classes[k][0]],
					"t1_items": [classes[i][1], classes[j][1], classes[k][1]],
					"t2_items": [classes[i][2], classes[j][2], classes[k][2]],
				})

	# Filter parties with 3 low-offense classes (no damage dealer at all).
	parties = parties.filter(func(p: Dictionary) -> bool:
		var c := 0
		for i in 3:
			var cid := resolve_class_id(
				p.base_types[i], p.t1_items[i], p.t2_items[i])
			if FighterDBRoles.is_low_offense_expected(cid):
				c += 1
		return c < 3)
	_cached_t2_parties = parties
	return parties


static func sample_parties(full_list: Array, sample_size: int,
		min_per_class: int = 5) -> Array:
	if sample_size >= full_list.size():
		return full_list

	seed(42)
	var selected := {}

	var class_buckets := {}
	for i in full_list.size():
		var desc := get_party_description(full_list[i])
		for cname in desc.split(" / "):
			if not class_buckets.has(cname):
				class_buckets[cname] = []
			class_buckets[cname].append(i)

	for bucket: Array in class_buckets.values():
		var needed := mini(min_per_class, bucket.size())
		_shuffle(bucket)
		for idx in needed:
			if selected.size() >= sample_size:
				break
			selected[bucket[idx]] = true

	while selected.size() < sample_size:
		selected[randi_range(0, full_list.size() - 1)] = true

	var result := []
	for idx: int in selected:
		result.append(full_list[idx])
	return result


static func _shuffle(arr: Array) -> void:
	for i in range(arr.size() - 1, 0, -1):
		var j := randi_range(0, i)
		var tmp = arr[i]
		arr[i] = arr[j]
		arr[j] = tmp
