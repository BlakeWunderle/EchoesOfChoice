class_name ReactionIndicator extends Node2D

const ICON_SIZE := 10.0
const GAP := 2.0

const COLORS: Dictionary = {
	Enums.ReactionType.OPPORTUNITY_ATTACK: Color(0.9, 0.4, 0.2),
	Enums.ReactionType.FLANKING_STRIKE: Color(0.9, 0.8, 0.2),
	Enums.ReactionType.SNAP_SHOT: Color(0.3, 0.8, 0.9),
	Enums.ReactionType.REACTIVE_HEAL: Color(0.3, 0.9, 0.4),
	Enums.ReactionType.DAMAGE_MITIGATION: Color(0.5, 0.6, 0.8),
	Enums.ReactionType.BODYGUARD: Color(0.8, 0.65, 0.3),
}

const LABELS: Dictionary = {
	Enums.ReactionType.OPPORTUNITY_ATTACK: "O",
	Enums.ReactionType.FLANKING_STRIKE: "F",
	Enums.ReactionType.SNAP_SHOT: "S",
	Enums.ReactionType.REACTIVE_HEAL: "H",
	Enums.ReactionType.DAMAGE_MITIGATION: "M",
	Enums.ReactionType.BODYGUARD: "B",
}

var _reaction_types: Array[Enums.ReactionType] = []
var _available: bool = true


func setup(types: Array[Enums.ReactionType]) -> void:
	_reaction_types = types
	queue_redraw()


func set_available(available: bool) -> void:
	if _available == available:
		return
	_available = available
	queue_redraw()


func _draw() -> void:
	if _reaction_types.is_empty():
		return
	var total_w := _reaction_types.size() * ICON_SIZE + (_reaction_types.size() - 1) * GAP
	var x_start := -total_w / 2.0
	var font := ThemeDB.fallback_font

	for i in range(_reaction_types.size()):
		var rt: Enums.ReactionType = _reaction_types[i]
		var color: Color = COLORS.get(rt, Color.GRAY)
		if not _available:
			color = color.darkened(0.6)
		var x := x_start + i * (ICON_SIZE + GAP)
		draw_rect(Rect2(x, 0, ICON_SIZE, ICON_SIZE), color)
		draw_rect(Rect2(x, 0, ICON_SIZE, ICON_SIZE), color.lightened(0.3), false, 1.0)
		var letter: String = LABELS.get(rt, "?")
		draw_string(font, Vector2(x + 1.5, ICON_SIZE - 1.5), letter, HORIZONTAL_ALIGNMENT_LEFT, -1, 8, Color.WHITE)
