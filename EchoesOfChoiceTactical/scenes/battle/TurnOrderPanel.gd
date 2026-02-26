class_name TurnOrderPanel extends PanelContainer

const MAX_SLOTS := 8
const SLOT_WIDTH := 56
const ICON_SIZE := 32

var _hbox: HBoxContainer
var _slots: Array[VBoxContainer] = []
var _current_unit: Unit = null


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	custom_minimum_size = Vector2(MAX_SLOTS * (SLOT_WIDTH + 4) + 16, 64)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 4)
	add_child(margin)

	_hbox = HBoxContainer.new()
	_hbox.add_theme_constant_override("separation", 4)
	margin.add_child(_hbox)

	for i in range(MAX_SLOTS):
		var slot := _create_slot()
		_hbox.add_child(slot)
		_slots.append(slot)


func _create_slot() -> VBoxContainer:
	var slot := VBoxContainer.new()
	slot.custom_minimum_size = Vector2(SLOT_WIDTH, 0)
	slot.alignment = BoxContainer.ALIGNMENT_CENTER

	# Icon placeholder
	var icon := TextureRect.new()
	icon.name = "Icon"
	icon.custom_minimum_size = Vector2(ICON_SIZE, ICON_SIZE)
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	slot.add_child(icon)

	# Team color bar
	var bar := ColorRect.new()
	bar.name = "TeamBar"
	bar.custom_minimum_size = Vector2(SLOT_WIDTH, 3)
	slot.add_child(bar)

	# Name label
	var lbl := Label.new()
	lbl.name = "NameLabel"
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.add_theme_font_size_override("font_size", 9)
	lbl.clip_text = true
	lbl.custom_minimum_size = Vector2(SLOT_WIDTH, 0)
	slot.add_child(lbl)

	return slot


func refresh(turn_manager: TurnManager) -> void:
	_current_unit = turn_manager.current_unit
	var preview: Array[Unit] = turn_manager.get_turn_order_preview(MAX_SLOTS)

	for i in range(MAX_SLOTS):
		var slot := _slots[i]
		if i < preview.size():
			_fill_slot(slot, preview[i])
			slot.visible = true
		else:
			slot.visible = false


func _fill_slot(slot: VBoxContainer, unit: Unit) -> void:
	var icon: TextureRect = slot.get_node("Icon")
	var bar: ColorRect = slot.get_node("TeamBar")
	var lbl: Label = slot.get_node("NameLabel")

	# Set sprite icon
	var tex := _get_unit_icon(unit)
	if tex:
		icon.texture = tex
	else:
		icon.texture = null

	# Team color
	var is_player := unit.team == Enums.Team.PLAYER
	bar.color = Color(0.3, 0.5, 0.9) if is_player else Color(0.9, 0.3, 0.3)

	# Name
	lbl.text = unit.unit_name
	lbl.add_theme_color_override("font_color", Color(1, 1, 1))

	# Highlight current unit
	if unit == _current_unit:
		bar.color = Color(0.9, 0.8, 0.3)
		lbl.add_theme_color_override("font_color", Color(0.9, 0.8, 0.3))


func _get_unit_icon(unit: Unit) -> Texture2D:
	if unit.sprite and unit.sprite.sprite_frames:
		if unit.sprite.sprite_frames.has_animation("idle_down"):
			return unit.sprite.sprite_frames.get_frame_texture("idle_down", 0)
		var anims := unit.sprite.sprite_frames.get_animation_names()
		if anims.size() > 0:
			return unit.sprite.sprite_frames.get_frame_texture(anims[0], 0)
	return null
