class_name PartyComposer

## Generates all viable party combinations at T0/T1/T2 tiers.
## Port of C# EchoesOfChoice/BattleSimulator/PartyComposer.cs.

const FighterDB := preload("res://scripts/data/fighter_db.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")

const LEVELS_AS_BASE := 3
const LEVELS_AS_TIER1 := 5

const BASE_TYPES: Array[String] = ["Squire", "Mage", "Entertainer", "Tinker", "Wildling"]

const T1_UPGRADES := {
	"Squire": ["Sword", "Bow", "Headband"],
	"Mage": ["RedStone", "WhiteStone"],
	"Entertainer": ["Lyre", "Slippers", "Scroll"],
	"Tinker": ["Crystal", "Textbook", "Abacus"],
	"Wildling": ["Herbs", "Totem", "BeastClaw"],
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
	"Cosmologist": ["TimeMachine", "Telescope"],
	"Arithmancer": ["ClockworkCore", "Computer"],
	"Herbalist": ["Venom", "Seedling"],
	"Shaman": ["Shrunkenhead", "SpiritOrb"],
	"Beastcaller": ["Feather", "Pelt"],
}

static var _class_name_cache := {}
static var _cached_t2_parties: Array = []


static func create_fighter(base_type: String, t1_item: String,
		t2_item: String, total_level_ups: int) -> FighterData:
	var fighter := FighterDB.create_player(base_type, base_type)
	fighter.is_user_controlled = false
	var remaining := total_level_ups

	var base_levels: int = mini(remaining, LEVELS_AS_BASE) if t1_item != "" else remaining
	for i in base_levels:
		FighterDB.level_up(fighter)
	remaining -= base_levels

	if t1_item != "":
		FighterDB.upgrade_class(fighter, t1_item)
		fighter.is_user_controlled = false

		var t1_levels: int = mini(remaining, LEVELS_AS_TIER1) if t2_item != "" else remaining
		for i in t1_levels:
			FighterDB.level_up(fighter)
		remaining -= t1_levels

	if t2_item != "":
		FighterDB.upgrade_class(fighter, t2_item)
		fighter.is_user_controlled = false
		for i in remaining:
			FighterDB.level_up(fighter)

	return fighter


static func resolve_class_name(base_type: String, t1_item: String,
		t2_item: String) -> String:
	var key := base_type + ":" + t1_item + ":" + t2_item
	if _class_name_cache.has(key):
		return _class_name_cache[key]
	var fighter := create_fighter(base_type, t1_item, t2_item, 0)
	var cname: String = fighter.character_type
	_class_name_cache[key] = cname
	return cname


static func get_party_description(party: Dictionary) -> String:
	var parts := PackedStringArray()
	for i in 3:
		parts.append(resolve_class_name(
			party.base_types[i], party.t1_items[i], party.t2_items[i]))
	return " / ".join(parts)


static func create_party(party: Dictionary, level_ups: int) -> Array:
	var fighters := []
	for i in 3:
		var f := create_fighter(
			party.base_types[i], party.t1_items[i],
			party.t2_items[i], level_ups)
		f.character_name = "Hero" + str(i + 1)
		fighters.append(f)
	return fighters


# =============================================================================
# Party generation
# =============================================================================

static func get_base_parties() -> Array:
	var parties := []
	for i in 5:
		for j in range(i, 5):
			for k in range(j, 5):
				parties.append({
					"base_types": [BASE_TYPES[i], BASE_TYPES[j], BASE_TYPES[k]],
					"t1_items": ["", "", ""],
					"t2_items": ["", "", ""],
				})
	return parties


static func get_tier1_parties() -> Array:
	var parties := []
	for i in 5:
		for j in range(i, 5):
			for k in range(j, 5):
				var arch := [BASE_TYPES[i], BASE_TYPES[j], BASE_TYPES[k]]
				var u_a: Array = T1_UPGRADES[arch[0]]
				var u_b: Array = T1_UPGRADES[arch[1]]
				var u_c: Array = T1_UPGRADES[arch[2]]
				for ai in u_a.size():
					for bi in u_b.size():
						for ci in u_c.size():
							if i == j and ai >= bi:
								continue
							if j == k and bi >= ci:
								continue
							parties.append({
								"base_types": arch,
								"t1_items": [u_a[ai], u_b[bi], u_c[ci]],
								"t2_items": ["", "", ""],
							})
	return parties


static func get_tier2_parties() -> Array:
	if not _cached_t2_parties.is_empty():
		return _cached_t2_parties

	var chains := {}
	for bt in BASE_TYPES:
		chains[bt] = []
		for t1_item: String in T1_UPGRADES[bt]:
			var t1_fighter := create_fighter(bt, t1_item, "", 0)
			var t1_cid: String = t1_fighter.class_id
			if T2_UPGRADES.has(t1_cid):
				for t2_item: String in T2_UPGRADES[t1_cid]:
					chains[bt].append([t1_item, t2_item])

	var parties := []
	for i in 5:
		for j in range(i, 5):
			for k in range(j, 5):
				var arch := [BASE_TYPES[i], BASE_TYPES[j], BASE_TYPES[k]]
				var c_a: Array = chains[arch[0]]
				var c_b: Array = chains[arch[1]]
				var c_c: Array = chains[arch[2]]
				for ai in c_a.size():
					for bi in c_b.size():
						for ci in c_c.size():
							if i == j and ai >= bi:
								continue
							if j == k and bi >= ci:
								continue
							parties.append({
								"base_types": arch,
								"t1_items": [c_a[ai][0], c_b[bi][0], c_c[ci][0]],
								"t2_items": [c_a[ai][1], c_b[bi][1], c_c[ci][1]],
							})

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
