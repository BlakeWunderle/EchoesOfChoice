class_name UltimateData extends RefCounted

## A powerful class-specific ability that charges through basic combat actions.
## Wraps an AbilityData for execution via the existing battle engine pipeline.

const AbilityData := preload("res://scripts/data/ability_data.gd")
const _Self := preload("res://scripts/data/ultimate_data.gd")

var ability: AbilityData        ## The underlying ability (damage, heal, buff, etc.)
var charge_cost: int = 100      ## Charge required to fire (80 = fast, 100 = standard, 120 = slow)
var ultimate_name: String       ## Display name shown in menus
var ultimate_id: String         ## Unique key for save/load lookup
var description: String         ## Player-facing description for selection UI


static func create(id: String, ult_name: String, desc: String,
		abil: AbilityData, cost: int) -> RefCounted:
	var u := _Self.new()
	u.ultimate_id = id
	u.ultimate_name = ult_name
	u.description = desc
	u.ability = abil
	u.charge_cost = cost
	return u
