class_name StatusIconBar extends Node2D

const ICON_SIZE := 12.0
const GAP := 2.0
const BUFF_COLOR := Color(0.2, 0.7, 0.3, 0.85)
const DEBUFF_COLOR := Color(0.8, 0.2, 0.3, 0.85)

const STAT_LETTERS: Dictionary = {
	Enums.StatType.PHYSICAL_ATTACK: "P",
	Enums.StatType.PHYSICAL_DEFENSE: "D",
	Enums.StatType.MAGIC_ATTACK: "M",
	Enums.StatType.MAGIC_DEFENSE: "R",
	Enums.StatType.ATTACK: "A",
	Enums.StatType.DEFENSE: "D",
	Enums.StatType.MIXED_ATTACK: "X",
	Enums.StatType.SPEED: "S",
	Enums.StatType.DODGE_CHANCE: "E",
}

var _stats: Array[ModifiedStat] = []


func refresh(stats: Array[ModifiedStat]) -> void:
	_stats = stats
	queue_redraw()


func _draw() -> void:
	if _stats.is_empty():
		return
	var total_w := _stats.size() * ICON_SIZE + (_stats.size() - 1) * GAP
	var x_start := -total_w / 2.0
	var font := ThemeDB.fallback_font

	for i in range(_stats.size()):
		var ms: ModifiedStat = _stats[i]
		var bg_color := DEBUFF_COLOR if ms.is_negative else BUFF_COLOR
		var x := x_start + i * (ICON_SIZE + GAP)
		draw_rect(Rect2(x, 0, ICON_SIZE, ICON_SIZE), bg_color)

		# Stat letter
		var letter: String = STAT_LETTERS.get(ms.stat, "?")
		draw_string(font, Vector2(x + 1, ICON_SIZE - 2), letter, HORIZONTAL_ALIGNMENT_LEFT, -1, 8, Color.WHITE)

		# Turn count in corner
		if ms.turns_remaining >= 0:
			var turn_str := str(ms.turns_remaining)
			draw_string(font, Vector2(x + ICON_SIZE - 5, 7), turn_str, HORIZONTAL_ALIGNMENT_LEFT, -1, 7, Color(1, 1, 1, 0.8))
