class_name AbilityDB

## Static factory for all abilities. Each function returns a configured AbilityData.
## C# source: EchoesOfChoice/CharacterClasses/Abilities/

const AbilityData := preload("res://scripts/data/ability_data.gd")
const Enums := preload("res://scripts/data/enums.gd")


static func _make(p_name: String, flavor: String, stat: Enums.StatType, mod: int,
		turns: int, on_enemy: bool, cost: int, all: bool = false,
		dot: int = 0, steal: float = 0.0, cd: int = 0) -> AbilityData:
	var a := AbilityData.new()
	a.ability_name = p_name
	a.flavor_text = flavor
	a.modified_stat = stat
	a.modifier = mod
	a.impacted_turns = turns
	a.use_on_enemy = on_enemy
	a.mana_cost = cost
	a.target_all = all
	a.damage_per_turn = dot
	a.life_steal_percent = steal
	a.cooldown = cd
	return a


# --- Player abilities (T0 classes) ---

static func slash() -> AbilityData:
	return _make("Slash", "Swing your weapon to attack the enemy.",
		Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 2, false, 0, 0.0, 1)


static func guard() -> AbilityData:
	return _make("Guard", "Brace for impact. Increases defenses.",
		Enums.StatType.DEFENSE, 2, 2, false, 1)


static func arcane_bolt() -> AbilityData:
	return _make("Arcane Bolt", "A bolt of pure arcane energy.",
		Enums.StatType.MAGIC_ATTACK, 2, 0, true, 2, false, 0, 0.0, 1)


static func sing() -> AbilityData:
	return _make("Sing",
		"Vocally amaze your enemies and distract them. Lowers magic Defense.",
		Enums.StatType.MAGIC_DEFENSE, 3, 2, true, 1)


static func mockery() -> AbilityData:
	return _make("Mockery",
		"A cruel, humiliating taunt that cuts deeper than any blade.",
		Enums.StatType.MIXED_ATTACK, 2, 0, true, 1, false, 0, 0.0, 1)


static func demoralize() -> AbilityData:
	return _make("Demoralize",
		"A mocking performance that saps the enemy's fighting spirit. Reduces attacks.",
		Enums.StatType.ATTACK, 3, 2, true, 3, true, 0, 0.0, 2)


static func proof() -> AbilityData:
	return _make("Proof",
		"Pull out a blackboard and stump your enemy with your big brains. Lowers magical defenses",
		Enums.StatType.MAGIC_DEFENSE, 3, 2, true, 3, false, 0, 0.0, 2)


static func energy_blast() -> AbilityData:
	return _make("Energy Blast", "Use a scientific explosion to hit an enemy",
		Enums.StatType.MAGIC_ATTACK, 5, 0, true, 4, false, 0, 0.0, 2)


static func thorn_whip() -> AbilityData:
	return _make("Thorn Whip",
		"Lash out with a vine covered in razor-sharp thorns.",
		Enums.StatType.MAGIC_ATTACK, 3, 0, true, 2, false, 0, 0.0, 1)


static func bark_skin() -> AbilityData:
	return _make("Bark Skin", "Harden your skin with a layer of living bark.",
		Enums.StatType.DEFENSE, 2, 2, false, 1)


# --- Shared abilities (used by both player classes and enemies) ---

static func smash() -> AbilityData:
	return _make("Smash", "A powerful overhead blow.",
		Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 2, false, 0, 0.0, 1)

static func torrent() -> AbilityData:
	return _make("Torrent", "A surge of water magic crashes into the target.",
		Enums.StatType.MAGIC_ATTACK, 4, 0, true, 3, false, 0, 0.0, 2)

static func roar() -> AbilityData:
	return _make("Roar", "A fearsome roar that shakes the enemy's confidence.",
		Enums.StatType.ATTACK, 3, 2, true, 2, false, 0, 0.0, 2)

static func shadow_attack() -> AbilityData:
	return _make("Shadow Attack", "Strike from the shadows with dark energy.",
		Enums.StatType.MIXED_ATTACK, 7, 0, true, 5, false, 0, 0.0, 3)

static func frustrate() -> AbilityData:
	return _make("Frustrate", "Undermine the enemy's will to fight.",
		Enums.StatType.ATTACK, 5, 2, true, 3, false, 0, 0.0, 2)

static func ember() -> AbilityData:
	return _make("Ember", "A searing bolt of flame.",
		Enums.StatType.MAGIC_ATTACK, 7, 0, true, 4, false, 0, 0.0, 2)

static func corruption() -> AbilityData:
	return _make("Corruption", "Dark magic that corrodes the target.",
		Enums.StatType.MAGIC_ATTACK, 8, 0, true, 5, false, 0, 0.0, 2)

static func shield_slam() -> AbilityData:
	return _make("Shield Slam", "Bash the enemy with a heavy shield.",
		Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 2, false, 0, 0.0, 1)

static func rally() -> AbilityData:
	return _make("Rally", "Sound the charge! Allies move faster.",
		Enums.StatType.SPEED, 5, 2, false, 3, true, 0, 0.0, 2)


# --- Enemy abilities ---

static func haymaker() -> AbilityData:
	return _make("Haymaker", "A wild, heavy-fisted swing.",
		Enums.StatType.PHYSICAL_ATTACK, 4, 0, true, 2, false, 0, 0.0, 1)

static func intimidate() -> AbilityData:
	return _make("Intimidate",
		"A menacing glare that weakens the target's resolve. Reduces attack.",
		Enums.StatType.ATTACK, 3, 2, true, 2, false, 0, 0.0, 2)

static func quick_stab() -> AbilityData:
	return _make("Quick Stab", "A swift blade flashes in the dark.",
		Enums.StatType.PHYSICAL_ATTACK, 2, 0, true, 1, false, 0, 0.0, 1)

static func pilfer() -> AbilityData:
	return _make("Pilfer",
		"Nimble fingers lighten the target's pockets and slow their step.",
		Enums.StatType.SPEED, 3, 2, true, 2, false, 0, 0.0, 2)
