class_name PauseSaveSlots
extends RefCounted

## Save-slot sub-menu logic extracted from PauseOverlay.
## Manages showing save slots, handling selection / overwrite / delete,
## performing the save, and navigating back to the main pause menu.

const StoryDB := preload("res://scripts/data/story_db.gd")
const PaginationControls := preload("res://scripts/ui/compendium/pagination_controls.gd")
const _SLOTS_PER_PAGE: int = 3
const _TOTAL_PAGES: int = ceili(float(SaveManager.MAX_SAVE_SLOTS) / _SLOTS_PER_PAGE)

var _overlay: CanvasLayer  # The PauseOverlay instance
var _delete_mode: bool = false
var _page: int = 0
var _pagination: PaginationControls


func _init(overlay: CanvasLayer) -> void:
	_overlay = overlay
	_pagination = PaginationControls.new()
	_pagination.visible = false
	_pagination.page_changed.connect(_on_page_changed)


# =============================================================================
# Show save slots
# =============================================================================

func show_save_slots() -> void:
	_delete_mode = false
	_page = 0
	_build_slot_menu()


func _build_slot_menu() -> void:
	_overlay._mode = _overlay.Mode.SAVE_SLOTS
	_overlay._main_vbox.visible = false

	# Remove pagination before clearing so it isn't freed
	if _pagination.get_parent() == _overlay._save_vbox:
		_overlay._save_vbox.remove_child(_pagination)

	# Clear old slot buttons
	for child: Node in _overlay._save_vbox.get_children():
		child.queue_free()

	var has_any_save: bool = false
	_page = clampi(_page, 0, _TOTAL_PAGES - 1)
	var page_start: int = _page * _SLOTS_PER_PAGE
	var page_end: int = mini(page_start + _SLOTS_PER_PAGE, SaveManager.MAX_SAVE_SLOTS)

	_overlay._pause_title.text = "Save"

	# Check if any saves exist
	for i: int in SaveManager.MAX_SAVE_SLOTS:
		if SaveManager.get_save_summary(i).get("exists", false):
			has_any_save = true
			break

	# Build slot buttons for current page
	for i: int in range(page_start, page_end):
		var summary: Dictionary = SaveManager.get_save_summary(i)
		var btn: Button
		if summary.get("exists", false):
			var story_title: String = StoryDB.get_story(
				summary.get("story_id", "story_1")).get("title", "")
			var lines: Array[String] = [
				"Slot %d" % [i + 1],
				"%s the %s  |  Lvl %d" % [
					summary.get("lead_name", "???"),
					summary.get("lead_class", "???"),
					summary.get("level", 1)],
				story_title,
			]
			btn = _make_slot_button(lines)
		else:
			btn = _overlay._make_button("Slot %d: Empty" % [i + 1])
			btn.custom_minimum_size.y = 64
		var slot: int = i
		if _delete_mode:
			if summary.get("exists", false):
				btn.pressed.connect(on_delete_slot_selected.bind(slot))
			else:
				btn.disabled = true
		else:
			btn.pressed.connect(on_save_slot_selected.bind(slot))
		_overlay._save_vbox.add_child(btn)

	# Mode toggle — Save / Delete
	if has_any_save:
		if _delete_mode:
			var save_btn: Button = _overlay._make_button("Save Mode")
			save_btn.pressed.connect(_on_switch_to_save)
			_overlay._save_vbox.add_child(save_btn)
		else:
			var del_btn: Button = _overlay._make_button("Delete Mode")
			del_btn.pressed.connect(_on_switch_to_delete)
			_overlay._save_vbox.add_child(del_btn)

	var back_btn: Button = _overlay._make_button("Back")
	back_btn.pressed.connect(_overlay._back_to_main)
	_overlay._save_vbox.add_child(back_btn)

	# Pagination controls
	_pagination.total_pages = _TOTAL_PAGES
	_pagination.current_page = _page + 1
	_pagination.visible = _TOTAL_PAGES > 1
	_overlay._save_vbox.add_child(_pagination)

	_overlay._save_vbox.visible = true

	# Focus first slot after frame so buttons are ready
	await _overlay.get_tree().process_frame
	if _overlay._save_vbox.get_child_count() > 0:
		var first: Button = _overlay._save_vbox.get_child(0) as Button
		if first:
			first.grab_focus()


func _make_slot_button(lines: Array[String]) -> Button:
	var btn: Button = _overlay._make_button("")
	btn.custom_minimum_size.y = 96
	btn.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 2)
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for i: int in lines.size():
		var lbl := Label.new()
		lbl.text = lines[i]
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.clip_text = true
		lbl.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if i == 0:
			lbl.add_theme_font_size_override("font_size", SettingsManager.font_size)
		else:
			lbl.add_theme_font_size_override("font_size", maxi(SettingsManager.font_size - 4, 12))
			lbl.add_theme_color_override("font_color", Color(0.7, 0.75, 0.8))
		vbox.add_child(lbl)
	margin.add_child(vbox)
	btn.add_child(margin)
	return btn


func _on_page_changed(new_page: int) -> void:
	_page = new_page - 1
	_build_slot_menu()


func _on_switch_to_save() -> void:
	_delete_mode = false
	_build_slot_menu()


func _on_switch_to_delete() -> void:
	_delete_mode = true
	_build_slot_menu()


# =============================================================================
# Slot selection / overwrite
# =============================================================================

func on_save_slot_selected(slot: int) -> void:
	if SaveManager.has_save(slot):
		_overlay._pending_save_slot = slot
		_overlay._confirm_dialog.confirmed.connect(on_overwrite_confirmed, CONNECT_ONE_SHOT)
		_overlay._confirm_dialog.show_confirm("Overwrite this save?")
	else:
		do_save(slot)


func on_overwrite_confirmed(accepted: bool) -> void:
	if accepted and _overlay._pending_save_slot >= 0:
		do_save(_overlay._pending_save_slot)
	_overlay._pending_save_slot = -1


# =============================================================================
# Perform save
# =============================================================================

func do_save(slot: int) -> void:
	SaveManager.save_to_slot(slot)
	# Find the button for this slot on the current page and update its label
	var page_start: int = _page * _SLOTS_PER_PAGE
	var btn_index: int = slot - page_start
	if btn_index >= 0 and btn_index < _overlay._save_vbox.get_child_count():
		var btn: Button = _overlay._save_vbox.get_child(btn_index) as Button
		if btn:
			for child: Node in btn.get_children():
				child.queue_free()
			btn.text = "Slot %d: Saved!" % [slot + 1]
	await _overlay.get_tree().create_timer(0.6).timeout
	if _overlay._mode == _overlay.Mode.SAVE_SLOTS:
		_overlay._back_to_main()


# =============================================================================
# Delete slot
# =============================================================================

func on_delete_slot_selected(slot: int) -> void:
	_overlay._pending_save_slot = slot
	_overlay._confirm_dialog.confirmed.connect(on_delete_confirmed, CONNECT_ONE_SHOT)
	_overlay._confirm_dialog.show_confirm("Delete this save? This cannot be undone.")


func on_delete_confirmed(accepted: bool) -> void:
	if accepted and _overlay._pending_save_slot >= 0:
		SaveManager.delete_save(_overlay._pending_save_slot)
	_overlay._pending_save_slot = -1
	_build_slot_menu()  # Refresh in current mode
