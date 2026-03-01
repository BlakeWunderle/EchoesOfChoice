## Generates realistic party compositions per progression stage.
## Filters out degenerate comps (all-same-archetype) while allowing diverse parties.
class_name PartyComposer extends RefCounted

## Archetype trees: base class -> T1 -> T2
const ARCHETYPE_TREE := {
	"fighter": {
		"t0": ["squire"],
		"t1": ["duelist", "ranger", "martial_artist"],
		"t2": ["cavalry", "dragoon", "mercenary", "hunter",
			"ninja", "monk"],
	},
	"mage": {
		"t0": ["mage"],
		"t1": ["invoker", "acolyte"],
		"t2": ["infernalist", "tidecaller", "tempest",
			"paladin", "priest", "warlock"],
	},
	"entertainer": {
		"t0": ["entertainer"],
		"t1": ["bard", "dervish", "orator"],
		"t2": ["warcrier", "minstrel", "illusionist", "mime",
			"laureate", "elegist"],
	},
	"scholar": {
		"t0": ["scholar"],
		"t1": ["artificer", "tinker", "cosmologist", "arithmancer"],
		"t2": ["alchemist", "thaumaturge", "bombardier", "siegemaster",
			"astronomer", "chronomancer", "automaton", "technomancer"],
	},
}

## Maps class_id -> archetype name for filtering
var _class_to_archetype: Dictionary = {}


func _init() -> void:
	for archetype in ARCHETYPE_TREE:
		var tree: Dictionary = ARCHETYPE_TREE[archetype]
		for tier_key in tree:
			for class_id in tree[tier_key]:
				_class_to_archetype[class_id] = archetype


## Returns the class pool for a given progression stage.
func get_class_pool(progression: int) -> Array[String]:
	var pool: Array[String] = []
	if progression <= 1:
		for arch in ARCHETYPE_TREE:
			pool.append_array(ARCHETYPE_TREE[arch]["t0"])
	elif progression <= 3:
		for arch in ARCHETYPE_TREE:
			pool.append_array(ARCHETYPE_TREE[arch]["t1"])
	else:
		for arch in ARCHETYPE_TREE:
			pool.append_array(ARCHETYPE_TREE[arch]["t2"])
	return pool


## Returns the party level for a given progression stage.
static func get_party_level(progression: int) -> int:
	# Matches typical XP curve: start at 1, gain ~1 level per 1-2 progressions
	var levels := [1, 2, 3, 4, 4, 5, 6, 7]
	if progression < levels.size():
		return levels[progression]
	return 7


## Generate party compositions for a progression stage.
## Returns Array of Array[String] (each inner array is 5 class_ids).
func get_parties(progression: int, max_sample: int = 300) -> Array:
	var pool := get_class_pool(progression)
	var all_combos := _generate_multisets(pool, 5)

	# Filter: require at least 2 distinct archetypes
	var valid: Array = []
	for combo in all_combos:
		if _is_realistic(combo):
			valid.append(combo)

	if valid.size() <= max_sample:
		return valid
	return _sample(valid, max_sample)


## Check that a party has at least 2 distinct archetypes.
func _is_realistic(combo: Array) -> bool:
	var archetypes := {}
	for class_id in combo:
		var arch: String = _class_to_archetype.get(class_id, "unknown")
		archetypes[arch] = true
	return archetypes.size() >= 2


## Generate all multisets of size k from pool (combinations with replacement).
func _generate_multisets(pool: Array, k: int) -> Array:
	var results: Array = []
	_multiset_recurse(pool, k, 0, [], results)
	return results


func _multiset_recurse(pool: Array, k: int, start: int, current: Array, results: Array) -> void:
	if current.size() == k:
		results.append(current.duplicate())
		return
	# Cap generation to avoid memory issues with large pools
	if results.size() >= 50000:
		return
	for i in range(start, pool.size()):
		current.append(pool[i])
		_multiset_recurse(pool, k, i, current, results)
		current.pop_back()


## Random sample without replacement.
func _sample(source: Array, count: int) -> Array:
	var shuffled := source.duplicate()
	shuffled.shuffle()
	return shuffled.slice(0, count)
