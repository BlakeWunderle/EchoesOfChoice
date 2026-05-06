extends Control

## Title screen with animated reveal and menu.
## Shows Continue and Load Game options when saves exist.

const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const StoryDB := preload("res://scripts/data/story_db.gd")
const SettingsPanel := preload("res://scripts/ui/settings_panel.gd")
const ConfirmDialog := preload("res://scripts/ui/confirm_dialog.gd")
const CompendiumPanelNew := preload("res://scripts/ui/compendium/compendium_panel.gd")
const InputRemapPanel := preload("res://scripts/ui/input_remap_panel.gd")

enum Mode { MAIN_MENU, PLAY_MODE, LOAD_SLOTS, SETTINGS, COMPENDIUM, KEY_BINDINGS }

var _title_label: Label
var _subtitle_label: Label
var _menu: ChoiceMenu
var _vbox: VBoxContainer
var _mode: Mode = Mode.MAIN_MENU
var _has_saves: bool = false
var _error_label: Label
var _settings_panel: SettingsPanel
var _remap_panel: InputRemapPanel
var _compendium_panel: CompendiumPanelNew
var _confirm_dialog: ConfirmDialog
var _pending_delete_slot: int = -1
var _accepting_input: bool = false
var _center: CenterContainer
var _settings_margin: MarginContainer
var _remap_margin: MarginContainer

# Load screen controls (created in _build_ui, shown only during LOAD_SLOTS)
const PaginationControls := preload("res://scripts/ui/compendium/pagination_controls.gd")
var _load_pagination: PaginationControls
var _load_mode_box: HBoxContainer
var _load_btn: Button
var _delete_btn: Button
var _load_back_btn: Button


func _ready() -> void:
	MusicManager.play_music("res://assets/audio/music/menu/Land of Heroes Alt LOOP.wav")
	_build_ui()
	_play_reveal()


func _build_ui() -> void:
	# Background image
	var bg := TextureRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	var bg_path := _pick_title_background()
	if ResourceLoader.exists(bg_path):
		bg.texture = load(bg_path)
	add_child(bg)

	# Center container — offset bottom so content sits in upper portion of screen
	_center = CenterContainer.new()
	_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	_center.offset_bottom = -180
	add_child(_center)

	_vbox = VBoxContainer.new()
	_vbox.add_theme_constant_override("separation", 16)
	_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	_center.add_child(_vbox)

	# Title
	_title_label = Label.new()
	_title_label.text = "PARTING SHADOWS"
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.add_theme_font_size_override("font_size", 56)
	_title_label.add_theme_constant_override("outline_size", 2)
	_title_label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	_title_label.add_theme_constant_override("shadow_offset_x", 4)
	_title_label.add_theme_constant_override("shadow_offset_y", 4)
	_title_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
	_title_label.modulate.a = 0.0
	_vbox.add_child(_title_label)

	# Subtitle
	_subtitle_label = Label.new()
	_subtitle_label.text = "Some paths can't be retraced."
	_subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_subtitle_label.add_theme_font_size_override("font_size", 20)
	_subtitle_label.add_theme_constant_override("outline_size", 2)
	_subtitle_label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	_subtitle_label.modulate.a = 0.0
	_vbox.add_child(_subtitle_label)

	# Spacer
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 24)
	_vbox.add_child(spacer)

	# Menu
	_menu = ChoiceMenu.new()
	_menu.modulate.a = 0.0
	_menu.visible = false
	_menu.choice_selected.connect(_on_menu_choice)
	_vbox.add_child(_menu)

	# Load screen controls (hidden by default, shown during LOAD_SLOTS)
	_load_pagination = PaginationControls.new()
	_load_pagination.visible = false
	_load_pagination.page_changed.connect(_on_load_page_changed)
	_vbox.add_child(_load_pagination)

	_load_mode_box = HBoxContainer.new()
	_load_mode_box.alignment = BoxContainer.ALIGNMENT_CENTER
	_load_mode_box.add_theme_constant_override("separation", 12)
	_load_mode_box.visible = false
	_vbox.add_child(_load_mode_box)

	_load_btn = Button.new()
	_load_btn.text = "Load"
	_load_btn.custom_minimum_size = Vector2(120, 40)
	_load_btn.add_theme_font_size_override("font_size", SettingsManager.font_size)
	_load_btn.add_theme_constant_override("outline_size", 2)
	_load_btn.add_theme_color_override("font_outline_color", Color.BLACK)
	_load_btn.pressed.connect(_on_load_mode_pressed)
	ChoiceMenu._apply_focus_style(_load_btn)
	_load_mode_box.add_child(_load_btn)

	_delete_btn = Button.new()
	_delete_btn.text = "Delete"
	_delete_btn.custom_minimum_size = Vector2(120, 40)
	_delete_btn.add_theme_font_size_override("font_size", SettingsManager.font_size)
	_delete_btn.add_theme_constant_override("outline_size", 2)
	_delete_btn.add_theme_color_override("font_outline_color", Color.BLACK)
	_delete_btn.pressed.connect(_on_delete_mode_pressed)
	ChoiceMenu._apply_focus_style(_delete_btn)
	_load_mode_box.add_child(_delete_btn)

	# Wire Load/Delete focus neighbors
	_load_btn.focus_neighbor_right = _delete_btn.get_path()
	_delete_btn.focus_neighbor_left = _load_btn.get_path()

	_load_back_btn = Button.new()
	_load_back_btn.text = "Back"
	_load_back_btn.custom_minimum_size = Vector2(140, 40)
	_load_back_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_load_back_btn.add_theme_font_size_override("font_size", SettingsManager.font_size)
	_load_back_btn.add_theme_constant_override("outline_size", 2)
	_load_back_btn.add_theme_color_override("font_outline_color", Color.BLACK)
	_load_back_btn.pressed.connect(_show_main_menu)
	_load_back_btn.visible = false
	ChoiceMenu._apply_focus_style(_load_back_btn)
	_vbox.add_child(_load_back_btn)

	# Error label (hidden by default)
	_error_label = Label.new()
	_error_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_error_label.add_theme_font_size_override("font_size", 16)
	_error_label.add_theme_color_override("font_color", Color(1.0, 0.4, 0.4))
	_error_label.visible = false
	_vbox.add_child(_error_label)

	# Settings panel (hidden by default) — outside CenterContainer so it uses full screen
	_settings_margin = MarginContainer.new()
	_settings_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	_settings_margin.add_theme_constant_override("margin_left", 200)
	_settings_margin.add_theme_constant_override("margin_right", 200)
	_settings_margin.add_theme_constant_override("margin_top", 40)
	_settings_margin.add_theme_constant_override("margin_bottom", 40)
	_settings_margin.visible = false
	add_child(_settings_margin)
	_settings_panel = SettingsPanel.new()
	_settings_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_settings_panel.back_pressed.connect(_show_main_menu)
	_settings_panel.key_bindings_pressed.connect(_show_key_bindings)
	_settings_margin.add_child(_settings_panel)

	# Key bindings panel (hidden by default) — outside CenterContainer
	_remap_margin = MarginContainer.new()
	_remap_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	_remap_margin.add_theme_constant_override("margin_left", 200)
	_remap_margin.add_theme_constant_override("margin_right", 200)
	_remap_margin.add_theme_constant_override("margin_top", 40)
	_remap_margin.add_theme_constant_override("margin_bottom", 40)
	_remap_margin.visible = false
	add_child(_remap_margin)
	_remap_panel = InputRemapPanel.new()
	_remap_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_remap_panel.back_pressed.connect(_show_settings)
	_remap_margin.add_child(_remap_panel)

	# Compendium panel (hidden by default, global context)
	_compendium_panel = CompendiumPanelNew.new()
	_compendium_panel.visible = false
	_compendium_panel.set_context(CompendiumPanelNew.Context.GLOBAL, -1)
	_compendium_panel.close_requested.connect(_show_main_menu)
	_vbox.add_child(_compendium_panel)

	# Version label (bottom-right corner)
	var version_label := Label.new()
	var version_str: String = ProjectSettings.get_setting("application/config/version", "")
	if not version_str.is_empty():
		version_label.text = "v" + version_str
	version_label.add_theme_font_size_override("font_size", 13)
	version_label.add_theme_color_override("font_color", Color(0.5, 0.55, 0.6, 0.7))
	version_label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	version_label.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	version_label.grow_vertical = Control.GROW_DIRECTION_BEGIN
	version_label.offset_left = -80
	version_label.offset_top = -30
	add_child(version_label)

	# Confirm dialog (overlays entire screen)
	_confirm_dialog = ConfirmDialog.new()
	add_child(_confirm_dialog)


static var _cached_bg: String = ""

func _pick_title_background() -> String:
	if not _cached_bg.is_empty():
		return _cached_bg
	var options: Array[String] = ["res://assets/art/ui/title_background.png"]
	if UnlockManager.is_unlocked("story_1_complete"):
		options.append("res://assets/art/ui/title_background_s2.png")
	if UnlockManager.is_unlocked("story_2_complete"):
		options.append("res://assets/art/ui/title_background_s3.png")
	_cached_bg = options[randi() % options.size()]
	return _cached_bg


func _play_reveal() -> void:
	var tween := create_tween()
	tween.tween_interval(0.3)
	tween.tween_property(_title_label, "modulate:a", 1.0, 1.5)
	tween.tween_interval(0.3)
	tween.tween_property(_subtitle_label, "modulate:a", 1.0, 1.0)
	tween.tween_interval(0.5)
	await tween.finished
	_show_main_menu()
	# Release focus immediately so queued key events can't activate buttons
	get_viewport().gui_release_focus()
	await get_tree().create_timer(0.2).timeout
	_menu.focus_first()
	_accepting_input = true


# =============================================================================
# Main menu
# =============================================================================

func _show_load_error() -> void:
	_error_label.text = "Save data could not be loaded."
	_error_label.visible = true
	await get_tree().create_timer(2.0).timeout
	_error_label.visible = false


func _show_main_menu() -> void:
	_mode = Mode.MAIN_MENU
	_has_saves = SaveManager.has_any_save()
	_settings_margin.visible = false
	_settings_panel.visible = false
	_remap_margin.visible = false
	_remap_panel.visible = false
	_compendium_panel.visible = false
	_load_pagination.visible = false
	_load_mode_box.visible = false
	_load_back_btn.visible = false
	_title_label.visible = true
	_subtitle_label.visible = true
	_center.visible = true
	_menu.visible = true

	var options: Array[Dictionary] = []
	if _has_saves:
		options.append({"label": "Continue"})
	options.append({"label": "New Game"})
	if _has_saves:
		options.append({"label": "Load Game"})
	options.append({"label": "Settings"})
	options.append({"label": "Compendium"})
	options.append({"label": "Credits"})
	options.append({"label": "Quit"})

	_menu.show_choices(options)
	var t := create_tween()
	t.tween_property(_menu, "modulate:a", 1.0, 0.4)


func _on_menu_choice(index: int) -> void:
	if not _accepting_input:
		return
	match _mode:
		Mode.MAIN_MENU:
			_handle_main_choice(index)
		Mode.PLAY_MODE:
			_handle_play_mode_choice(index)
		Mode.LOAD_SLOTS:
			_handle_load_choice(index)


func _handle_main_choice(index: int) -> void:
	# Map index to label based on menu structure
	var labels: Array[String] = []
	if _has_saves:
		labels.append("Continue")
	labels.append("New Game")
	if _has_saves:
		labels.append("Load Game")
	labels.append("Settings")
	labels.append("Compendium")
	labels.append("Credits")
	labels.append("Quit")

	if index < 0 or index >= labels.size():
		return

	match labels[index]:
		"Continue":
			var slot: int = _find_best_continue_slot()
			if slot >= 0 and SaveManager.load_from_slot(slot):
				SceneManager.change_scene(_scene_for_phase())
			else:
				_show_load_error()
		"New Game":
			_show_play_mode()
		"Load Game":
			_show_load_slots()
		"Settings":
			_show_settings()
		"Compendium":
			_show_compendium()
		"Credits":
			SceneManager.change_scene("res://scenes/credits/credits.tscn")
		"Quit":
			_confirm_dialog.confirmed.connect(_on_quit_confirmed, CONNECT_ONE_SHOT)
			_confirm_dialog.show_confirm("Are you sure you want to quit?")


func _find_best_continue_slot() -> int:
	var manual_slot: int = SaveManager.get_last_used_slot()
	var has_auto: bool = SaveManager.has_autosave()
	if manual_slot >= 0 and has_auto:
		var manual_ts: String = SaveManager.get_save_summary(manual_slot).get("timestamp", "")
		var auto_ts: String = SaveManager.get_save_summary(SaveManager.AUTOSAVE_SLOT).get("timestamp", "")
		if auto_ts > manual_ts:
			return SaveManager.AUTOSAVE_SLOT
		return manual_slot
	if manual_slot >= 0:
		return manual_slot
	if has_auto:
		return SaveManager.AUTOSAVE_SLOT
	for i: int in SaveManager.MAX_SAVE_SLOTS:
		if SaveManager.has_save(i):
			return i
	return -1


# =============================================================================
# Play mode submenu (New Game -> Single / Co-op / Online)
# =============================================================================

func _show_play_mode() -> void:
	_mode = Mode.PLAY_MODE
	var options: Array[Dictionary] = [
		{"label": "Single Player"},
		{"label": "Local Co-op (2 Players)"},
		{"label": "Local Co-op (3 Players)"},
	]
	if SteamManager.is_steam_running:
		options.append({"label": "Online Multiplayer"})
	options.append({"label": "Back"})
	_menu.show_choices(options)


func _handle_play_mode_choice(index: int) -> void:
	# Check for Back option first
	var back_index: int = 4 if SteamManager.is_steam_running else 3
	if index == back_index:
		_show_main_menu()
		return
	match index:
		0:  # Single Player
			if UnlockManager.is_unlocked("story_1_complete"):
				SceneManager.change_scene("res://scenes/story_select/story_select.tscn")
			else:
				GameState.start_new_game("story_1")
				SceneManager.change_scene("res://scenes/party_creation/party_creation.tscn")
		1:  # Local Co-op (2 Players)
			LocalCoop.start(2)
			SceneManager.change_scene("res://scenes/controller_assign/controller_assign.tscn")
		2:  # Local Co-op (3 Players)
			LocalCoop.start(3)
			SceneManager.change_scene("res://scenes/controller_assign/controller_assign.tscn")
		3:  # Online Multiplayer (Steam)
			if SteamManager.is_steam_running:
				SceneManager.change_scene("res://scenes/lobby/lobby.tscn")


# =============================================================================
# Settings
# =============================================================================

func _show_settings() -> void:
	_mode = Mode.SETTINGS
	_menu.hide_menu()
	_center.visible = false
	_remap_margin.visible = false
	_remap_panel.visible = false
	_settings_panel.visible = true
	_fade_in(_settings_margin)
	_settings_panel.focus_first()


func _show_key_bindings() -> void:
	_mode = Mode.KEY_BINDINGS
	_center.visible = false
	_settings_margin.visible = false
	_settings_panel.visible = false
	_remap_panel.visible = true
	_fade_in(_remap_margin)
	_remap_panel.focus_first()


func _show_compendium() -> void:
	_mode = Mode.COMPENDIUM
	_menu.hide_menu()
	_title_label.visible = false
	_subtitle_label.visible = false
	_fade_in(_compendium_panel)
	_compendium_panel.refresh_data()


func _fade_in(node: Control) -> void:
	node.modulate.a = 0.0
	node.visible = true
	var tw := create_tween()
	tw.tween_property(node, "modulate:a", 1.0, 0.2)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		match _mode:
			Mode.PLAY_MODE:
				get_viewport().set_input_as_handled()
				_show_main_menu()
			Mode.LOAD_SLOTS:
				get_viewport().set_input_as_handled()
				_show_main_menu()


func _on_quit_confirmed(accepted: bool) -> void:
	if accepted:
		get_tree().quit()


func _scene_for_phase() -> String:
	if GameState.game_phase == GameState.GamePhase.TOWN_STOP:
		return "res://scenes/town_stop/town_stop.tscn"
	return "res://scenes/narrative/narrative.tscn"


# =============================================================================
# Load slot picker
# =============================================================================

var _load_slot_actions: Array[Dictionary] = []
var _load_delete_mode: bool = false
var _load_page: int = 0
const _SLOTS_PER_PAGE: int = 5


func _show_load_slots() -> void:
	_load_delete_mode = false
	_load_page = 0
	_build_load_menu()


func _build_load_menu() -> void:
	_mode = Mode.LOAD_SLOTS
	_load_slot_actions.clear()
	_title_label.visible = false
	_subtitle_label.visible = false

	var options: Array[Dictionary] = []
	var has_any_save: bool = false
	var action: String = "delete" if _load_delete_mode else "load"

	# Check if any saves exist (for mode toggle visibility)
	for i: int in SaveManager.MAX_SAVE_SLOTS:
		if SaveManager.get_save_summary(i).get("exists", false):
			has_any_save = true
			break
	if not has_any_save and SaveManager.get_save_summary(SaveManager.AUTOSAVE_SLOT).get("exists", false):
		has_any_save = true

	# Calculate page range (manual slots only; autosave is on last page)
	var total_pages: int = ceili(float(SaveManager.MAX_SAVE_SLOTS) / _SLOTS_PER_PAGE)
	_load_page = clampi(_load_page, 0, total_pages - 1)
	var page_start: int = _load_page * _SLOTS_PER_PAGE
	var page_end: int = mini(page_start + _SLOTS_PER_PAGE, SaveManager.MAX_SAVE_SLOTS)

	# Slots for current page
	for i: int in range(page_start, page_end):
		var summary: Dictionary = SaveManager.get_save_summary(i)
		if summary.get("exists", false):
			var story_title: String = StoryDB.get_story(
				summary.get("story_id", "story_1")).get("title", "")
			var mp_tag: String = ""
			if summary.get("is_local_coop", false):
				mp_tag = " [Co-op]"
			elif summary.get("is_multiplayer", false):
				mp_tag = " [Online]"
			var secs: float = summary.get("play_seconds", 0.0)
			var h: int = int(secs) / 3600
			var m: int = (int(secs) % 3600) / 60
			options.append({"label": "Slot %d: %s the %s - Lv %d (%s)%s [%dh %dm]" % [
				i + 1,
				summary.get("lead_name", "???"),
				summary.get("lead_class", "???"),
				summary.get("level", 1),
				story_title,
				mp_tag,
				h, m,
			]})
			_load_slot_actions.append({"action": action, "slot": i})
		else:
			options.append({"label": "Slot %d: Empty" % [i + 1], "disabled": true})
			_load_slot_actions.append({"action": "none", "slot": i})

	# Autosave on the last page
	if _load_page == total_pages - 1:
		var auto_summary: Dictionary = SaveManager.get_save_summary(SaveManager.AUTOSAVE_SLOT)
		if auto_summary.get("exists", false):
			var auto_story: String = StoryDB.get_story(
				auto_summary.get("story_id", "story_1")).get("title", "")
			var auto_mp_tag: String = ""
			if auto_summary.get("is_local_coop", false):
				auto_mp_tag = " [Co-op]"
			elif auto_summary.get("is_multiplayer", false):
				auto_mp_tag = " [Online]"
			var auto_secs: float = auto_summary.get("play_seconds", 0.0)
			var auto_h: int = int(auto_secs) / 3600
			var auto_m: int = (int(auto_secs) % 3600) / 60
			options.append({"label": "Autosave: %s the %s - Lv %d (%s)%s [%dh %dm]" % [
				auto_summary.get("lead_name", "???"),
				auto_summary.get("lead_class", "???"),
				auto_summary.get("level", 1),
				auto_story,
				auto_mp_tag,
				auto_h, auto_m,
			]})
			_load_slot_actions.append({"action": action, "slot": SaveManager.AUTOSAVE_SLOT})
		else:
			options.append({"label": "Autosave: Empty", "disabled": true})
			_load_slot_actions.append({"action": "none", "slot": SaveManager.AUTOSAVE_SLOT})

	# Show slots in the ChoiceMenu (slots only — no nav or mode buttons)
	_menu.show_choices(options)

	# Show external controls
	var total_p: int = ceili(float(SaveManager.MAX_SAVE_SLOTS) / _SLOTS_PER_PAGE)
	_load_pagination.total_pages = total_p
	_load_pagination.current_page = _load_page + 1  # PaginationControls is 1-based
	_load_pagination.visible = total_p > 1

	# Mode toggle — highlight active mode (compendium tab pattern)
	if has_any_save:
		_load_mode_box.visible = true
		_load_btn.modulate = Color.WHITE if not _load_delete_mode else Color(0.6, 0.6, 0.6)
		_delete_btn.modulate = Color.WHITE if _load_delete_mode else Color(0.6, 0.6, 0.6)
	else:
		_load_mode_box.visible = false

	_load_back_btn.visible = true

	# Focus wiring: ChoiceMenu bottom → pagination (or mode box) → back
	await get_tree().process_frame
	_wire_load_focus()
	_menu.focus_first()


func _wire_load_focus() -> void:
	var last_slot_btn: Button = null
	for i: int in range(_menu._buttons.size() - 1, -1, -1):
		if not _menu._buttons[i].disabled:
			last_slot_btn = _menu._buttons[i]
			break
	var first_slot_btn: Button = null
	for btn: Button in _menu._buttons:
		if not btn.disabled:
			first_slot_btn = btn
			break

	# Build focus chain below the slot list: pagination → mode box → back
	var below_chain: Array[Control] = []
	if _load_pagination.visible:
		below_chain.append(_load_pagination)
	if _load_mode_box.visible:
		below_chain.append(_load_mode_box)
	below_chain.append(_load_back_btn)

	# Wire last slot button → first item below
	if last_slot_btn and below_chain.size() > 0:
		var target: Control = below_chain[0]
		var focus_btn: Button = _focus_entry(target)
		last_slot_btn.focus_neighbor_bottom = focus_btn.get_path()

	# Wire first slot button top → wrap to back
	if first_slot_btn:
		first_slot_btn.focus_neighbor_top = _load_back_btn.get_path()

	# Wire consecutive items in below_chain
	for idx: int in below_chain.size():
		var cur: Control = below_chain[idx]
		# Top neighbor: previous item, or last slot button
		var above_btn: Button = last_slot_btn if idx == 0 else _focus_exit(below_chain[idx - 1])
		# Bottom neighbor: next item, or first slot button (wrap)
		var below_btn: Button = first_slot_btn if idx == below_chain.size() - 1 else _focus_entry(below_chain[idx + 1])

		if cur == _load_pagination:
			if above_btn:
				_load_pagination.set_top_neighbor(above_btn)
			if below_btn:
				_load_pagination.set_bottom_neighbor(below_btn)
		elif cur == _load_mode_box:
			if above_btn:
				_load_btn.focus_neighbor_top = above_btn.get_path()
				_delete_btn.focus_neighbor_top = above_btn.get_path()
			if below_btn:
				_load_btn.focus_neighbor_bottom = below_btn.get_path()
				_delete_btn.focus_neighbor_bottom = below_btn.get_path()
		elif cur == _load_back_btn:
			if above_btn:
				_load_back_btn.focus_neighbor_top = above_btn.get_path()
			if below_btn:
				_load_back_btn.focus_neighbor_bottom = below_btn.get_path()


## First focusable button when entering a control group from above.
func _focus_entry(ctrl: Control) -> Button:
	if ctrl == _load_pagination:
		return _load_pagination.get_focus_target()
	if ctrl == _load_mode_box:
		return _load_btn
	if ctrl is Button:
		return ctrl as Button
	return null


## Last focusable button when entering a control group from below.
func _focus_exit(ctrl: Control) -> Button:
	if ctrl == _load_pagination:
		if not _load_pagination._next_btn.disabled:
			return _load_pagination._next_btn
		return _load_pagination._prev_btn
	if ctrl == _load_mode_box:
		return _delete_btn
	if ctrl is Button:
		return ctrl as Button
	return null


func _on_load_page_changed(new_page: int) -> void:
	_load_page = new_page - 1  # PaginationControls is 1-based, our _load_page is 0-based
	_build_load_menu()


func _on_load_mode_pressed() -> void:
	_load_delete_mode = false
	_build_load_menu()


func _on_delete_mode_pressed() -> void:
	_load_delete_mode = true
	_build_load_menu()


func _handle_load_choice(index: int) -> void:
	if index < 0 or index >= _load_slot_actions.size():
		return

	var entry: Dictionary = _load_slot_actions[index]
	match entry["action"]:
		"none":
			return
		"delete":
			_pending_delete_slot = int(entry["slot"])
			_confirm_dialog.confirmed.connect(_on_delete_save_confirmed, CONNECT_ONE_SHOT)
			_confirm_dialog.show_confirm("Delete this save? This cannot be undone.")
		"load":
			var slot: int = int(entry["slot"])
			if SaveManager.load_from_slot(slot):
				SceneManager.change_scene(_scene_for_phase())
			else:
				_show_load_error()


func _on_delete_save_confirmed(accepted: bool) -> void:
	if accepted and _pending_delete_slot >= 0:
		SaveManager.delete_save(_pending_delete_slot)
	_pending_delete_slot = -1
	_build_load_menu()  # Refresh in current mode
