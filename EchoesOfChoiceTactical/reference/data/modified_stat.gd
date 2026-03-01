class_name ModifiedStat extends RefCounted

var stat: Enums.StatType
var modifier: int
var turns_remaining: int
var is_negative: bool


static func create(p_stat: Enums.StatType, p_modifier: int, p_turns: int, p_negative: bool) -> ModifiedStat:
	var ms := ModifiedStat.new()
	ms.stat = p_stat
	ms.modifier = p_modifier
	ms.turns_remaining = p_turns
	ms.is_negative = p_negative
	return ms
