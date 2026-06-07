extends Control

## Party creation scene. Story-aware: tavern intro (S1), cave amnesia (S2),
## or inn arrival (S3). 3 character creation loops with story-specific narrative.

const DialoguePanel := preload("res://scripts/ui/dialogue_panel.gd")
const NameInput := preload("res://scripts/ui/name_input.gd")
const ChoiceMenu := preload("res://scripts/ui/choice_menu.gd")
const TipOverlay := preload("res://scripts/ui/tip_overlay.gd")
const WaitingOverlay := preload("res://scripts/ui/waiting_overlay.gd")
const ReadyGate := preload("res://scripts/ui/ready_gate.gd")
const FighterData := preload("res://scripts/data/fighter_data.gd")
const FighterDB := preload("res://scripts/data/fighter_db.gd")
const ClassInfoPanel := preload("res://scripts/ui/class_info_panel.gd")
const PCText := preload("res://scenes/party_creation/party_creation_text.gd")
const EquipmentDB := preload("res://scripts/data/equipment_db.gd")
const EquipmentData := preload("res://scripts/data/equipment_data.gd")

enum State {
	DIFFICULTY, INTRO, NAME_1, CLASS_1, PORTRAIT_1,
	EQUIP_INTRO_1, EQUIP_WEAPON_1, EQUIP_ARMOR_1, EQUIP_BOOTS_1, CONFIRM_1,
	BRIDGE_1, NAME_2, CLASS_2, PORTRAIT_2,
	EQUIP_INTRO_2, EQUIP_WEAPON_2, EQUIP_ARMOR_2, EQUIP_BOOTS_2, CONFIRM_2,
	BRIDGE_2, NAME_3, CLASS_3, PORTRAIT_3,
	EQUIP_INTRO_3, EQUIP_WEAPON_3, EQUIP_ARMOR_3, EQUIP_BOOTS_3, CONFIRM_3,
	OUTRO, DONE,
}

const DIFFICULTY_OPTIONS: Array[Dictionary] = [
	{"label": "Easy", "description": "Enemy HP -10%, ATK -15%, SPD -10%"},
	{"label": "Normal", "description": "Standard enemy stats"},
	{"label": "Hard", "description": "Enemy HP +10%, ATK +15%, SPD +10%"},
]
const DIFFICULTY_VALUES: Array[int] = [0, 1, 2]

const BASE_CLASS_OPTIONS: Array[Dictionary] = [
	{"label": "Squire"},
	{"label": "Mage"},
	{"label": "Entertainer"},
	{"label": "Tinker"},
	{"label": "Wildling"},
]

const BASE_CLASS_IDS: Array[String] = ["Squire", "Mage", "Entertainer", "Tinker", "Wildling"]

var _state: State = State.INTRO
var _current_name: String = ""
var _current_class_id: String = ""
var _party: Array[FighterData] = []
var _class_options: Array[Dictionary] = []
var _class_ids: Array[String] = []
var _equip_choices: Array[Dictionary] = []  ## Current equipment choice list
var _equip_choice_ids: Array[String] = []   ## IDs matching _equip_choices

var _dialogue: DialoguePanel
var _name_input: NameInput
var _choice_menu: ChoiceMenu
var _tip_overlay: TipOverlay
var _waiting_overlay: WaitingOverlay
var _scene_image: TextureRect
var _vbox: VBoxContainer
var _portrait_container: HBoxContainer
var _portrait_preview_a: TextureRect
var _portrait_preview_b: TextureRect
var _portrait_btn_a: Button
var _portrait_btn_b: Button
var _portrait_back_btn: Button
var _player_indicator: Label
var _equip_label: Label
var _equip_back_btn: Button
var _class_info_panel: ClassInfoPanel
var _ready_gate: ReadyGate
var _pending_advance: Callable


func _is_s2() -> bool:
	return GameState.current_story_id == "story_2"


func _is_s3() -> bool:
	return GameState.current_story_id == "story_3"


func _ready() -> void:
	if _is_s2():
		MusicManager.play_music("res://assets/audio/music/cutscene/#12 Cave Horn.wav")
	else:
		MusicManager.play_music("res://assets/audio/music/town/Medieval Tavern 03.wav")
	_class_options = BASE_CLASS_OPTIONS.duplicate(true)
	_class_ids = BASE_CLASS_IDS.duplicate()
	if UnlockManager.is_unlocked("story_1_complete"):
		_class_options.append({"label": "Wanderer"})
		_class_ids.append("Wanderer")
	if _is_s2():
		for i: int in range(_class_options.size()):
			_class_options[i]["label"] = "???"
	_build_ui()
	# Pre-assign co-op slots so device gating works during creation
	if LocalCoop.is_active:
		LocalCoop.assign_slots(3)
	_set_state(State.DIFFICULTY)
	if NetManager.is_multiplayer_active:
		NetManager.player_left.connect(_on_player_left)
		NetManager.session_ended.connect(_on_session_ended)
		NetManager.peer_scene_ready.connect(_on_peer_scene_ready)
		_tip_overlay.show_tip_once("multiplayer_intro",
			"In multiplayer, each player controls their own party " +
			"members. Everyone must confirm Ready before the game " +
			"advances.\n\n" +
			"Branch choices are decided by vote!")
	if LocalCoop.is_active:
		_tip_overlay.show_tip_once("multiplayer_intro",
			"In co-op, each player controls their own party members. " +
			"Everyone must confirm Ready before the game advances.\n\n" +
			"Branch choices are decided by vote!")


func _build_ui() -> void:
	# Background image
	_scene_image = TextureRect.new()
	_scene_image.set_anchors_preset(Control.PRESET_FULL_RECT)
	_scene_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_scene_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_scene_image.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	if _is_s3():
		_scene_image.texture = load("res://assets/art/battles/weary_traveler_inn.png")
	elif _is_s2():
		_scene_image.texture = load("res://assets/art/battles/cave_awakening.png")
	else:
		_scene_image.texture = load("res://assets/art/battles/copper_mug.png")
	add_child(_scene_image)

	# Dark overlay for text readability
	var overlay := ColorRect.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0, 0, 0, 0.55)
	add_child(overlay)

	var outer_margin := MarginContainer.new()
	outer_margin.anchor_left = 0.0
	outer_margin.anchor_top = 0.0
	outer_margin.anchor_right = 1.0
	outer_margin.anchor_bottom = 0.5
	outer_margin.clip_contents = true
	outer_margin.add_theme_constant_override("margin_left", 80)
	outer_margin.add_theme_constant_override("margin_right", 80)
	outer_margin.add_theme_constant_override("margin_top", 40)
	outer_margin.add_theme_constant_override("margin_bottom", 20)
	add_child(outer_margin)

	_vbox = VBoxContainer.new()
	_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_vbox.add_theme_constant_override("separation", 8)
	outer_margin.add_child(_vbox)

	_dialogue = DialoguePanel.new()
	_dialogue.all_text_finished.connect(_on_text_finished)
	_dialogue.visible = false
	_vbox.add_child(_dialogue)

	_name_input = NameInput.new()
	_name_input.name_entered.connect(_on_name_entered)
	_name_input.text_changed.connect(_on_name_text_changed)
	_name_input.visible = false
	_vbox.add_child(_name_input)

	_equip_label = Label.new()
	_equip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_equip_label.add_theme_font_size_override("font_size", 28)
	_equip_label.visible = false
	_vbox.add_child(_equip_label)

	_choice_menu = ChoiceMenu.new()
	_choice_menu.choice_selected.connect(_on_class_selected)
	_choice_menu.option_focused.connect(_on_class_option_focused)
	_choice_menu.visible = false
	_vbox.add_child(_choice_menu)

	_equip_back_btn = Button.new()
	_equip_back_btn.text = "Back"
	_equip_back_btn.custom_minimum_size = Vector2(200, 48)
	_equip_back_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_equip_back_btn.focus_mode = Control.FOCUS_ALL
	_equip_back_btn.visible = false
	_equip_back_btn.pressed.connect(_on_equip_back)
	var _equip_back_focus_sb := StyleBoxFlat.new()
	_equip_back_focus_sb.bg_color = Color(0.1, 0.16, 0.22, 0.45)
	_equip_back_focus_sb.border_color = Color.WHITE
	_equip_back_focus_sb.set_border_width_all(3)
	_equip_back_focus_sb.set_corner_radius_all(6)
	_equip_back_btn.add_theme_stylebox_override("focus", _equip_back_focus_sb)
	_vbox.add_child(_equip_back_btn)

	_ready_gate = ReadyGate.new()
	_ready_gate.visible = false
	_ready_gate.all_ready.connect(_on_all_ready)
	_vbox.add_child(_ready_gate)

	# Portrait preview (shown during portrait selection)
	_portrait_container = HBoxContainer.new()
	_portrait_container.alignment = BoxContainer.ALIGNMENT_CENTER
	_portrait_container.add_theme_constant_override("separation", 32)
	_portrait_container.visible = false
	_vbox.add_child(_portrait_container)

	for i: int in 2:
		var col := VBoxContainer.new()
		col.add_theme_constant_override("separation", 4)
		col.alignment = BoxContainer.ALIGNMENT_CENTER
		_portrait_container.add_child(col)

		var frame := PanelContainer.new()
		frame.custom_minimum_size = Vector2(180, 240)
		col.add_child(frame)

		var tex_rect := TextureRect.new()
		tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tex_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tex_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tex_rect.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		frame.add_child(tex_rect)

		var btn := Button.new()
		btn.flat = true
		btn.set_anchors_preset(Control.PRESET_FULL_RECT)
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		btn.focus_mode = Control.FOCUS_ALL
		# Normal: fully transparent so the portrait shows through
		var clear_style := StyleBoxEmpty.new()
		btn.add_theme_stylebox_override("normal", clear_style)
		# Hover: semi-transparent teal border for mouse feedback
		var hover_style := StyleBoxFlat.new()
		hover_style.bg_color = Color(0, 0, 0, 0)
		hover_style.set_border_width_all(2)
		hover_style.border_color = Color(0.2, 0.9, 0.8, 0.5)
		hover_style.set_corner_radius_all(4)
		btn.add_theme_stylebox_override("hover", hover_style)
		# Pressed: brighter teal border
		var pressed_style := StyleBoxFlat.new()
		pressed_style.bg_color = Color(0, 0, 0, 0)
		pressed_style.set_border_width_all(3)
		pressed_style.border_color = Color(0.2, 0.9, 0.8, 0.8)
		pressed_style.set_corner_radius_all(4)
		btn.add_theme_stylebox_override("pressed", pressed_style)
		# Focus: white border for keyboard/gamepad (consistent with rest of UI)
		var focus_style := StyleBoxFlat.new()
		focus_style.bg_color = Color(0, 0, 0, 0)
		focus_style.set_border_width_all(3)
		focus_style.border_color = Color(1.0, 1.0, 1.0, 1.0)
		focus_style.set_corner_radius_all(4)
		btn.add_theme_stylebox_override("focus", focus_style)
		frame.add_child(btn)

		if i == 0:
			_portrait_preview_a = tex_rect
			_portrait_btn_a = btn
			btn.pressed.connect(_on_portrait_clicked.bind(0))
		else:
			_portrait_preview_b = tex_rect
			_portrait_btn_b = btn
			btn.pressed.connect(_on_portrait_clicked.bind(1))

	_portrait_back_btn = Button.new()
	_portrait_back_btn.text = "Back"
	_portrait_back_btn.custom_minimum_size = Vector2(200, 48)
	_portrait_back_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_portrait_back_btn.focus_mode = Control.FOCUS_ALL
	_portrait_back_btn.visible = false
	_portrait_back_btn.pressed.connect(_on_portrait_back)
	var _back_focus_sb := StyleBoxFlat.new()
	_back_focus_sb.bg_color = Color(0.1, 0.16, 0.22, 0.45)
	_back_focus_sb.border_color = Color.WHITE
	_back_focus_sb.set_border_width_all(3)
	_back_focus_sb.set_corner_radius_all(6)
	_portrait_back_btn.add_theme_stylebox_override("focus", _back_focus_sb)
	_vbox.add_child(_portrait_back_btn)

	_class_info_panel = ClassInfoPanel.new()
	_vbox.add_child(_class_info_panel)

	_tip_overlay = TipOverlay.new()
	add_child(_tip_overlay)

	_waiting_overlay = WaitingOverlay.new()
	add_child(_waiting_overlay)

	# Local co-op player indicator (top center)
	_player_indicator = Label.new()
	_player_indicator.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_player_indicator.add_theme_font_size_override("font_size", 22)
	_player_indicator.add_theme_color_override("font_color", Color(0.3, 0.9, 0.5))
	_player_indicator.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_player_indicator.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_player_indicator.offset_left = -200
	_player_indicator.offset_right = 200
	_player_indicator.offset_top = 16
	_player_indicator.visible = false
	add_child(_player_indicator)


## Returns the party index (0, 1, 2) for character creation states, or -1.
func _state_to_char_index(s: State) -> int:
	match s:
		State.NAME_1, State.CLASS_1, State.PORTRAIT_1, \
		State.EQUIP_INTRO_1, State.EQUIP_WEAPON_1, State.EQUIP_ARMOR_1, State.EQUIP_BOOTS_1:
			return 0
		State.NAME_2, State.CLASS_2, State.PORTRAIT_2, \
		State.EQUIP_INTRO_2, State.EQUIP_WEAPON_2, State.EQUIP_ARMOR_2, State.EQUIP_BOOTS_2:
			return 1
		State.NAME_3, State.CLASS_3, State.PORTRAIT_3, \
		State.EQUIP_INTRO_3, State.EQUIP_WEAPON_3, State.EQUIP_ARMOR_3, State.EQUIP_BOOTS_3:
			return 2
	return -1


## Returns true if the current state's character belongs to this local player.
func _is_my_character_state() -> bool:
	var idx: int = _state_to_char_index(_state)
	if idx < 0:
		return true  # Non-character states (dialogue, etc.) are always "mine"
	return NetManager.is_my_fighter(idx)


func _get_name_prompt() -> String:
	match _state:
		State.NAME_1:
			if _is_s2(): return "A leather bracelet on this one's wrist. Letters are stamped into it..."
			elif _is_s3(): return "The traveler nearest the fire raises a cup. 'Long road? I'm...'"
			else: return "'What is your name, young warrior?'"
		State.NAME_2:
			if _is_s2(): return "Scratched into the back of a belt buckle, barely legible..."
			elif _is_s3(): return "The second traveler leans forward. 'Name's...'"
			else: return "'And what is your name?'"
		State.NAME_3:
			if _is_s2(): return "Stitched into the collar of a torn cloak..."
			elif _is_s3(): return "The third traveler nods a greeting. 'Call me...'"
			else: return "'And you? What is your name?'"
	return ""


func _set_state(new_state: State) -> void:
	_state = new_state
	_dialogue.visible = false
	_name_input.visible = false
	_equip_label.visible = false
	_equip_back_btn.visible = false
	_choice_menu.visible = false
	_portrait_container.visible = false
	_portrait_back_btn.visible = false
	_class_info_panel.visible = false
	_waiting_overlay.hide_waiting()

	var char_idx: int = _state_to_char_index(_state)

	# Local co-op: gate input to the owning player for character states
	if LocalCoop.is_active:
		if char_idx >= 0:
			var owner: int = LocalCoop.get_player_for_slot(char_idx)
			LocalCoop.set_active_player(owner)
			_player_indicator.text = "Player %d" % (owner + 1)
			_player_indicator.visible = true
		else:
			LocalCoop.clear_active_player()
			_player_indicator.visible = false

	# In multiplayer, check if this is a remote player's character input state
	var is_remote_input: bool = (
		NetManager.is_multiplayer_active
		and char_idx >= 0
		and not NetManager.is_my_fighter(char_idx)
	)

	if is_remote_input:
		match _state:
			State.NAME_1, State.NAME_2, State.NAME_3:
				_name_input.show_mirror(_get_name_prompt())
			State.CLASS_1, State.CLASS_2, State.CLASS_3:
				if _is_s2():
					_show_dialogue(["Something stirs. A reflex. A memory buried in muscle and bone. What comes naturally?"])
				elif _is_s3():
					_show_dialogue(["'And what do you do for a living?' the innkeeper asks, refilling their cup."])
				else:
					_show_dialogue(["What is your calling?"])
			State.PORTRAIT_1, State.PORTRAIT_2, State.PORTRAIT_3:
				var owner_name: String = NetManager.get_fighter_owner_name(char_idx)
				_waiting_overlay.show_waiting(owner_name)
			State.EQUIP_INTRO_1, State.EQUIP_INTRO_2, State.EQUIP_INTRO_3:
				var ci: int = _state_to_char_index(_state)
				_show_dialogue(PCText.get_equip_text(GameState.current_story_id, ci))
		return

	match _state:
		State.DIFFICULTY:
			_show_difficulty_selection()
		State.INTRO:
			_show_dialogue(PCText.get_intro_text(GameState.current_story_id))
			if NetManager.is_multiplayer_active:
				_open_gate_early(_do_shared_advance)
		State.NAME_1, State.NAME_2, State.NAME_3:
			_name_input.show_prompt(_get_name_prompt())
		State.CLASS_1, State.CLASS_2, State.CLASS_3:
			if _is_s2():
				_show_dialogue(["Something stirs. A reflex. A memory buried in muscle and bone. What comes naturally?"])
			elif _is_s3():
				_show_dialogue(["'And what do you do for a living?' the innkeeper asks, refilling their cup."])
			else:
				_show_dialogue(["What is your calling?"])
		State.PORTRAIT_1, State.PORTRAIT_2, State.PORTRAIT_3:
			_show_portrait_selection()
		State.EQUIP_INTRO_1, State.EQUIP_INTRO_2, State.EQUIP_INTRO_3:
			var ci: int = _state_to_char_index(_state)
			_show_dialogue(PCText.get_equip_text(GameState.current_story_id, ci))
		State.EQUIP_WEAPON_1, State.EQUIP_WEAPON_2, State.EQUIP_WEAPON_3:
			_show_equip_choices("weapon")
		State.EQUIP_ARMOR_1, State.EQUIP_ARMOR_2, State.EQUIP_ARMOR_3:
			_show_equip_choices("armor")
		State.EQUIP_BOOTS_1, State.EQUIP_BOOTS_2, State.EQUIP_BOOTS_3:
			_show_equip_choices("boots")
		State.CONFIRM_1, State.CONFIRM_2, State.CONFIRM_3:
			var fighter: FighterData = _party.back()
			_show_dialogue(["%s the %s joins the party!" % [
				fighter.character_name, fighter.character_type]])
			if NetManager.is_multiplayer_active:
				_open_gate_early(_do_shared_advance)
		State.BRIDGE_1:
			_show_dialogue(PCText.get_bridge_1_text(GameState.current_story_id))
			if NetManager.is_multiplayer_active:
				_open_gate_early(_do_shared_advance)
		State.BRIDGE_2:
			_show_dialogue(PCText.get_bridge_2_text(GameState.current_story_id))
			if NetManager.is_multiplayer_active:
				_open_gate_early(_do_shared_advance)
		State.OUTRO:
			_show_dialogue(PCText.get_outro_text(GameState.current_story_id))
			if NetManager.is_multiplayer_active:
				_open_gate_early(_do_shared_advance)
		State.DONE:
			_finish()


func _show_dialogue(lines: Array) -> void:
	_dialogue.show_text(lines)


func _on_text_finished() -> void:
	if NetManager.is_multiplayer_active:
		# Shared dialogue: both players mark ready, gate callback advances
		if _state in [State.INTRO, State.CONFIRM_1, State.CONFIRM_2, State.CONFIRM_3,
				State.BRIDGE_1, State.BRIDGE_2, State.OUTRO]:
			_mark_self_ready()
			return

		# Per-character dialogue (CLASS/EQUIP_INTRO)
		if _state in [State.CLASS_1, State.CLASS_2, State.CLASS_3,
				State.EQUIP_INTRO_1, State.EQUIP_INTRO_2, State.EQUIP_INTRO_3]:
			if not _is_my_character_state():
				return  # Remote viewer: wait for mirror RPC from active player
			# Own character: fall through to show choices

	match _state:
		State.INTRO:
			_mp_set_state(State.NAME_1)
		State.CLASS_1, State.CLASS_2, State.CLASS_3:
			_dialogue.visible = false
			# If this is my character, show class choices and broadcast mirror
			if _is_my_character_state():
				_choice_menu.show_choices(_class_options)
				if NetManager.is_multiplayer_active:
					var char_idx: int = _state_to_char_index(_state)
					var owner_name: String = NetManager.get_fighter_owner_name(char_idx)
					_rpc_show_class_mirror.rpc(char_idx, owner_name)
				if _state == State.CLASS_1:
					_tip_overlay.show_tip_once("party_classes",
						"Each class has unique abilities and a different combat role. " +
						"Squires are sturdy fighters, Mages deal elemental damage, " +
						"Entertainers support allies, Tinkers use gadgets and knowledge, " +
						"and Wildlings channel nature.\n\n" +
						"Your party of three can be any combination. " +
						"Variety helps, but any team can win!")
		State.EQUIP_INTRO_1:
			_mp_set_state(State.EQUIP_WEAPON_1)
		State.EQUIP_INTRO_2:
			_mp_set_state(State.EQUIP_WEAPON_2)
		State.EQUIP_INTRO_3:
			_mp_set_state(State.EQUIP_WEAPON_3)
		State.CONFIRM_1:
			_mp_set_state(State.BRIDGE_1)
		State.CONFIRM_2:
			_mp_set_state(State.BRIDGE_2)
		State.CONFIRM_3:
			_mp_set_state(State.OUTRO)
		State.BRIDGE_1:
			_mp_set_state(State.NAME_2)
		State.BRIDGE_2:
			_mp_set_state(State.NAME_3)
		State.OUTRO:
			_mp_set_state(State.DONE)


func _on_name_entered(player_name: String) -> void:
	_current_name = player_name
	_name_input.visible = false

	var greeting: String = ""
	match _state:
		State.NAME_1:
			if _is_s2():
				greeting = "'%s.' The name feels right. But nothing else does." % player_name
			elif _is_s3():
				greeting = "'%s.' A firm handshake. The firelight catches old scars on their knuckles." % player_name
			else:
				greeting = "'Greetings, %s. You look like someone who can handle themselves.'" % player_name
			_show_dialogue([greeting])
			_state = State.CLASS_1
		State.NAME_2:
			if _is_s2():
				greeting = "'%s.' Another name reclaimed from the dark." % player_name
			elif _is_s3():
				greeting = "'%s.' They pull up a chair without being invited. Road dust on their boots." % player_name
			else:
				greeting = "'Greetings, %s. Good, we'll need the help.'" % player_name
			_show_dialogue([greeting])
			_state = State.CLASS_2
		State.NAME_3:
			if _is_s2():
				greeting = "'%s.' Three names. Three strangers. It's a start." % player_name
			elif _is_s3():
				greeting = "'%s.' Three travelers at one table. The innkeeper smiles as if she expected it." % player_name
			else:
				greeting = "'Greetings, %s. That makes three. That should be enough.'" % player_name
			_show_dialogue([greeting])
			_state = State.CLASS_3

	if NetManager.is_multiplayer_active and not greeting.is_empty():
		_rpc_name_greeting.rpc(greeting)


func _on_class_selected(index: int) -> void:
	# Route to difficulty handler
	if _state == State.DIFFICULTY:
		_on_difficulty_selected(index)
		return
	# Route to equipment handler if in an equipment state
	if _is_equip_state():
		_on_equip_selected(index)
		return

	_choice_menu.hide_menu()
	_class_info_panel.visible = false
	_current_class_id = _class_ids[index]

	match _state:
		State.CLASS_1: _set_state(State.PORTRAIT_1)
		State.CLASS_2: _set_state(State.PORTRAIT_2)
		State.CLASS_3: _set_state(State.PORTRAIT_3)


func _on_name_text_changed(text: String) -> void:
	if NetManager.is_multiplayer_active and _is_my_character_state():
		_rpc_name_text.rpc(text)


func _on_class_option_focused(index: int) -> void:
	if _is_equip_state():
		if _is_my_character_state() and NetManager.is_multiplayer_active:
			_rpc_equip_focus.rpc(index)
		return
	if _state not in [State.CLASS_1, State.CLASS_2, State.CLASS_3]:
		return
	if index < 0 or index >= _class_ids.size():
		_class_info_panel.visible = false
		return
	_class_info_panel.show_class(_class_ids[index], not _is_s2())
	# Sync focus to mirror viewers
	if _is_my_character_state() and NetManager.is_multiplayer_active:
		_rpc_class_focus.rpc(index)


func _show_portrait_selection() -> void:
	var slug: String = _current_class_id.to_lower().replace(" ", "_")
	var path_a: String = "res://assets/art/portraits/classes/%s_m.png" % slug
	var path_b: String = "res://assets/art/portraits/classes/%s_f.png" % slug

	_portrait_preview_a.texture = null
	_portrait_preview_b.texture = null
	if ResourceLoader.exists(path_a):
		_portrait_preview_a.texture = load(path_a) as Texture2D
	if ResourceLoader.exists(path_b):
		_portrait_preview_b.texture = load(path_b) as Texture2D

	_portrait_container.visible = true
	_portrait_back_btn.visible = true

	# Wire focus: left/right between portraits, down to back button
	_portrait_btn_a.focus_neighbor_right = _portrait_btn_b.get_path()
	_portrait_btn_a.focus_neighbor_bottom = _portrait_back_btn.get_path()
	_portrait_btn_b.focus_neighbor_left = _portrait_btn_a.get_path()
	_portrait_btn_b.focus_neighbor_bottom = _portrait_back_btn.get_path()
	_portrait_back_btn.focus_neighbor_top = _portrait_btn_a.get_path()

	_portrait_btn_a.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if _portrait_container.visible and event.is_action_pressed("ui_cancel"):
		_on_portrait_back()
		get_viewport().set_input_as_handled()
		return
	if _equip_back_btn.visible and event.is_action_pressed("ui_cancel"):
		_on_equip_back()
		get_viewport().set_input_as_handled()


func _on_portrait_back() -> void:
	_portrait_container.visible = false
	_portrait_back_btn.visible = false
	# Roll state back so _on_class_selected sees CLASS_X, not PORTRAIT_X
	match _state:
		State.PORTRAIT_1: _state = State.CLASS_1
		State.PORTRAIT_2: _state = State.CLASS_2
		State.PORTRAIT_3: _state = State.CLASS_3
	_choice_menu.show_choices(_class_options)


func _on_portrait_clicked(index: int) -> void:
	_portrait_container.visible = false
	_portrait_back_btn.visible = false

	var variant: String = "m" if index == 0 else "f"
	var char_idx: int = _state_to_char_index(_state)
	var fighter: FighterData = FighterDB.create_player(_current_class_id, _current_name, variant)

	# Set ownership
	if NetManager.is_multiplayer_active:
		fighter.owner_peer_id = NetManager.get_fighter_owner_peer(char_idx)
	elif LocalCoop.is_active:
		fighter.owner_peer_id = LocalCoop.get_player_for_slot(char_idx) + 1

	_party.append(fighter)
	CompendiumManager.record_class(fighter.class_id, fighter.character_type)

	# In multiplayer, broadcast the created character to all peers
	if NetManager.is_multiplayer_active:
		var char_data: Dictionary = {
			"name": _current_name,
			"class_id": _current_class_id,
			"variant": variant,
			"party_index": char_idx,
		}
		if NetManager.is_host:
			# Host created: broadcast to guests and advance
			_rpc_character_created.rpc(char_data)
			match _state:
				State.PORTRAIT_1: _mp_set_state(State.EQUIP_INTRO_1)
				State.PORTRAIT_2: _mp_set_state(State.EQUIP_INTRO_2)
				State.PORTRAIT_3: _mp_set_state(State.EQUIP_INTRO_3)
		else:
			# Guest created: send to host
			_rpc_submit_character.rpc_id(1, char_data)
		return

	# Singleplayer path
	match _state:
		State.PORTRAIT_1: _set_state(State.EQUIP_INTRO_1)
		State.PORTRAIT_2: _set_state(State.EQUIP_INTRO_2)
		State.PORTRAIT_3: _set_state(State.EQUIP_INTRO_3)


# =============================================================================
# Difficulty selection
# =============================================================================

func _show_difficulty_selection() -> void:
	if NetManager.is_multiplayer_active and not NetManager.is_host:
		_waiting_overlay.show_waiting("host")
		return
	_equip_label.text = "Select Difficulty:"
	_equip_label.visible = true
	_choice_menu.show_choices(DIFFICULTY_OPTIONS)
	_choice_menu.highlight_option(1)


func _on_difficulty_selected(index: int) -> void:
	if index < 0 or index >= DIFFICULTY_VALUES.size():
		return
	_choice_menu.hide_menu()
	_equip_label.visible = false
	GameState.difficulty = DIFFICULTY_VALUES[index]
	if NetManager.is_multiplayer_active:
		_rpc_difficulty_set.rpc(DIFFICULTY_VALUES[index])
	_mp_set_state(State.INTRO)


# =============================================================================
# Equipment selection
# =============================================================================

func _show_equip_choices(slot_type: String) -> void:
	var choices: Array[Dictionary]
	var header: String
	match slot_type:
		"weapon":
			choices = EquipmentDB.get_weapon_choices()
			header = "Select Weapon:"
		"armor":
			choices = EquipmentDB.get_armor_choices()
			header = "Select Armor:"
		"boots":
			choices = EquipmentDB.get_boots_choices()
			header = "Select Boots:"
		_:
			return

	_equip_choices.clear()
	_equip_choice_ids.clear()
	var options: Array[Dictionary] = []
	for c: Dictionary in choices:
		_equip_choice_ids.append(c.id)
		options.append({"label": c.label, "description": c.description})
	_equip_choices = options

	_equip_label.text = header
	_equip_label.visible = true
	_choice_menu.show_choices(options)

	var can_go_back: bool = _state not in [
		State.EQUIP_WEAPON_1, State.EQUIP_WEAPON_2, State.EQUIP_WEAPON_3]
	_equip_back_btn.visible = can_go_back
	if can_go_back:
		_wire_equip_back_focus()

	if _state in [State.EQUIP_WEAPON_1, State.EQUIP_WEAPON_2, State.EQUIP_WEAPON_3]:
		_tip_overlay.show_tip_once("first_equipment",
			"Equipment gives permanent stat bonuses to each character. " +
			"Choose a weapon, armor, and boots that complement your class.\n\n" +
			"You'll get a chance to upgrade each piece at town stops later.")

	# Multiplayer: broadcast mirror for equipment choices
	if _is_my_character_state() and NetManager.is_multiplayer_active:
		var char_idx: int = _state_to_char_index(_state)
		var owner_name: String = NetManager.get_fighter_owner_name(char_idx)
		_rpc_show_equip_mirror.rpc(char_idx, owner_name, slot_type)


func _on_equip_selected(index: int) -> void:
	if index < 0 or index >= _equip_choice_ids.size():
		return

	_choice_menu.hide_menu()
	_equip_label.visible = false

	var choice_id: String = _equip_choice_ids[index]
	var fighter: FighterData = _party.back()
	var equip: EquipmentData = EquipmentDB.create_equipment(choice_id)
	EquipmentDB.apply_to_fighter(equip, fighter)
	fighter.equipment.append(equip)

	# Broadcast in multiplayer
	if NetManager.is_multiplayer_active:
		var char_idx: int = _state_to_char_index(_state)
		if NetManager.is_host:
			_rpc_equip_applied.rpc(char_idx, choice_id)
		else:
			_rpc_submit_equip.rpc_id(1, char_idx, choice_id)

	_advance_equip_state()


func _advance_equip_state() -> void:
	match _state:
		State.EQUIP_INTRO_1, State.EQUIP_WEAPON_1: _mp_set_state(State.EQUIP_ARMOR_1)
		State.EQUIP_INTRO_2, State.EQUIP_WEAPON_2: _mp_set_state(State.EQUIP_ARMOR_2)
		State.EQUIP_INTRO_3, State.EQUIP_WEAPON_3: _mp_set_state(State.EQUIP_ARMOR_3)
		State.EQUIP_ARMOR_1: _mp_set_state(State.EQUIP_BOOTS_1)
		State.EQUIP_ARMOR_2: _mp_set_state(State.EQUIP_BOOTS_2)
		State.EQUIP_ARMOR_3: _mp_set_state(State.EQUIP_BOOTS_3)
		State.EQUIP_BOOTS_1: _mp_set_state(State.CONFIRM_1)
		State.EQUIP_BOOTS_2: _mp_set_state(State.CONFIRM_2)
		State.EQUIP_BOOTS_3: _mp_set_state(State.CONFIRM_3)


func _is_equip_state() -> bool:
	return _state in [
		State.EQUIP_WEAPON_1, State.EQUIP_ARMOR_1, State.EQUIP_BOOTS_1,
		State.EQUIP_WEAPON_2, State.EQUIP_ARMOR_2, State.EQUIP_BOOTS_2,
		State.EQUIP_WEAPON_3, State.EQUIP_ARMOR_3, State.EQUIP_BOOTS_3,
	]


func _on_equip_back() -> void:
	var fighter: FighterData = _party.back()
	if fighter.equipment.size() > 0:
		var last_equip: EquipmentData = fighter.equipment.pop_back()
		for stat_name: String in last_equip.stat_bonuses:
			var amount: int = last_equip.stat_bonuses[stat_name]
			fighter.set(stat_name, fighter.get(stat_name) - amount)
		if "max_health" in last_equip.stat_bonuses:
			fighter.health = fighter.max_health
		if "max_mana" in last_equip.stat_bonuses:
			fighter.mana = fighter.max_mana

	_choice_menu.hide_menu()
	_equip_label.visible = false
	_equip_back_btn.visible = false

	match _state:
		State.EQUIP_ARMOR_1: _set_state(State.EQUIP_WEAPON_1)
		State.EQUIP_ARMOR_2: _set_state(State.EQUIP_WEAPON_2)
		State.EQUIP_ARMOR_3: _set_state(State.EQUIP_WEAPON_3)
		State.EQUIP_BOOTS_1: _set_state(State.EQUIP_ARMOR_1)
		State.EQUIP_BOOTS_2: _set_state(State.EQUIP_ARMOR_2)
		State.EQUIP_BOOTS_3: _set_state(State.EQUIP_ARMOR_3)


func _wire_equip_back_focus() -> void:
	await get_tree().process_frame
	var last_btn: Button = null
	for i: int in range(_choice_menu._buttons.size() - 1, -1, -1):
		if not _choice_menu._buttons[i].disabled:
			last_btn = _choice_menu._buttons[i]
			break
	var first_btn: Button = null
	for btn: Button in _choice_menu._buttons:
		if not btn.disabled:
			first_btn = btn
			break
	if last_btn:
		last_btn.focus_neighbor_bottom = _equip_back_btn.get_path()
	if first_btn:
		first_btn.focus_neighbor_top = _equip_back_btn.get_path()
	_equip_back_btn.focus_neighbor_top = last_btn.get_path() if last_btn else NodePath()
	_equip_back_btn.focus_neighbor_bottom = first_btn.get_path() if first_btn else NodePath()


func _finish() -> void:
	# In multiplayer, host broadcasts the final party to all peers
	if NetManager.is_multiplayer_active and NetManager.is_host:
		var party_data: Array[Dictionary] = []
		for fighter: FighterData in _party:
			party_data.append(fighter.to_save_data())
		# Set up party + game state on all peers (call_local)
		_rpc_party_finalized.rpc(party_data)
		# Scene change routed through NetManager autoload for reliable delivery
		var scene_path: String
		match GameState.game_phase:
			GameState.GamePhase.TOWN_STOP:
				scene_path = "res://scenes/town_stop/town_stop.tscn"
			_:
				scene_path = "res://scenes/narrative/narrative.tscn"
		NetManager.change_scene_for_peers(scene_path)
		SceneManager.change_scene(scene_path)
		return

	_do_finish()


func _do_finish() -> void:
	GameState.set_party(_party)
	for fighter: RefCounted in _party:
		GameLog.info("Party: %s the %s" % [fighter.character_name, fighter.character_type])
	GameState.advance_to_battle(GameState.get_first_battle_id())
	match GameState.game_phase:
		GameState.GamePhase.TOWN_STOP:
			SceneManager.change_scene("res://scenes/town_stop/town_stop.tscn")
		_:
			SceneManager.change_scene("res://scenes/narrative/narrative.tscn")


# =============================================================================
# Multiplayer ready gate
# =============================================================================

func _open_gate_early(callback: Callable) -> void:
	if not NetManager.is_multiplayer_active:
		return
	_pending_advance = callback
	_ready_gate.start_online(NetManager.get_connected_peer_count())


func _mark_self_ready() -> void:
	var my_idx: int = NetManager.get_my_peer_index()
	_ready_gate.mark_ready(my_idx)
	NetManager.notify_scene_ready(my_idx)


func _on_peer_scene_ready(player_index: int) -> void:
	_ready_gate.mark_ready(player_index)


func _on_all_ready() -> void:
	if _pending_advance.is_valid():
		var cb := _pending_advance
		_pending_advance = Callable()
		cb.call_deferred()


func _do_shared_advance() -> void:
	if NetManager.is_multiplayer_active and not NetManager.is_host:
		return
	match _state:
		State.INTRO: _mp_set_state(State.NAME_1)
		State.CONFIRM_1: _mp_set_state(State.BRIDGE_1)
		State.CONFIRM_2: _mp_set_state(State.BRIDGE_2)
		State.CONFIRM_3: _mp_set_state(State.OUTRO)
		State.BRIDGE_1: _mp_set_state(State.NAME_2)
		State.BRIDGE_2: _mp_set_state(State.NAME_3)
		State.OUTRO: _mp_set_state(State.DONE)


# =============================================================================
# Multiplayer disconnect
# =============================================================================

func _on_player_left(_peer_id: int, player_name: String) -> void:
	if not NetManager.is_host:
		return
	GameLog.info("PartyCreation: %s disconnected, ending session" % player_name)
	# No autosave -- party is incomplete during creation
	NetManager.leave_session()
	SceneManager.change_scene("res://scenes/title/title.tscn")


func _on_session_ended(reason: String) -> void:
	GameLog.info("PartyCreation: Session ended (%s)" % reason)
	_name_input.visible = false
	_choice_menu.hide_menu()
	_portrait_container.visible = false
	_portrait_back_btn.visible = false
	_equip_back_btn.visible = false
	_waiting_overlay.hide_waiting()
	_dialogue.visible = true
	_dialogue.show_text([reason])
	await get_tree().create_timer(2.5).timeout
	SceneManager.change_scene("res://scenes/title/title.tscn")


# =============================================================================
# Multiplayer RPCs
# =============================================================================

## Sets state locally and broadcasts to all peers (host only).
func _mp_set_state(new_state: State) -> void:
	if NetManager.is_multiplayer_active and NetManager.is_host:
		_rpc_sync_state.rpc(new_state as int)
	_set_state(new_state)


## Host -> All: Sync the state machine to a new state.
@rpc("authority", "call_remote", "reliable")
func _rpc_sync_state(state_value: int) -> void:
	_set_state(state_value as State)


## Host -> All: Sync difficulty selection to peers.
@rpc("authority", "call_remote", "reliable")
func _rpc_difficulty_set(level: int) -> void:
	GameState.difficulty = level


## Any -> All: Broadcast name greeting text so both players see it.
@rpc("any_peer", "call_remote", "reliable")
func _rpc_name_greeting(greeting: String) -> void:
	_name_input.visible = false
	_waiting_overlay.hide_waiting()
	_show_dialogue([greeting])


## Guest -> Host: Submit a created character.
@rpc("any_peer", "call_remote", "reliable")
func _rpc_submit_character(char_data: Dictionary) -> void:
	if not NetManager.is_host:
		return
	# Host creates the fighter from the submitted data
	var fighter: FighterData = FighterDB.create_player(
		char_data["class_id"], char_data["name"], char_data["variant"])
	var char_idx: int = int(char_data["party_index"])
	fighter.owner_peer_id = NetManager.get_fighter_owner_peer(char_idx)
	_party.append(fighter)

	# Broadcast to all peers (including the submitter)
	_rpc_character_created.rpc(char_data)

	# Advance state: portrait -> equipment intro
	match char_idx:
		0: _mp_set_state(State.EQUIP_INTRO_1)
		1: _mp_set_state(State.EQUIP_INTRO_2)
		2: _mp_set_state(State.EQUIP_INTRO_3)


## Host -> All: A character has been created (broadcast to all peers).
@rpc("authority", "call_local", "reliable")
func _rpc_character_created(char_data: Dictionary) -> void:
	# If we're the host, we already added the fighter in submit or portrait_clicked
	if NetManager.is_host:
		return
	# Guest: create the fighter locally and add to party
	var fighter: FighterData = FighterDB.create_player(
		char_data["class_id"], char_data["name"], char_data["variant"])
	var char_idx: int = int(char_data["party_index"])
	fighter.owner_peer_id = NetManager.get_fighter_owner_peer(char_idx)
	_party.append(fighter)


## Host -> All: Full party finalized — set up party + game state (no scene change).
@rpc("authority", "call_local", "reliable")
func _rpc_party_finalized(party_data: Array) -> void:
	# Rebuild party from serialized data on all peers
	_party.clear()
	for data: Dictionary in party_data:
		var fighter := FighterData.new()
		fighter.apply_save_data(data)
		# Restore abilities from class DB since save_data doesn't include them
		var abilities: Array = FighterDB.get_abilities_for_class(fighter.class_id)
		fighter.abilities = abilities
		_party.append(fighter)
	# Set up game state (scene change is routed through NetManager separately)
	GameState.set_party(_party)
	for fighter: RefCounted in _party:
		GameLog.info("Party: %s the %s" % [fighter.character_name, fighter.character_type])
	GameState.advance_to_battle(GameState.get_first_battle_id())


## Active player -> All: Show class options as read-only mirror for non-owning peers.
@rpc("any_peer", "call_remote", "reliable")
func _rpc_show_class_mirror(char_idx: int, owner_name: String) -> void:
	if NetManager.is_my_fighter(char_idx):
		return  # I'm the one choosing, ignore mirror
	_name_input.visible = false
	_waiting_overlay.hide_waiting()
	_dialogue.visible = false
	var mirror_options: Array[Dictionary] = []
	for opt: Dictionary in _class_options:
		var copy: Dictionary = opt.duplicate()
		copy["disabled"] = true
		mirror_options.append(copy)
	_choice_menu.show_choices(mirror_options)
	# Show first option highlighted by default
	if not _class_ids.is_empty():
		_choice_menu.highlight_option(0)
		_class_info_panel.show_class(_class_ids[0], not _is_s2())


## Active player -> All: Sync which class option is focused (for mirror viewers).
@rpc("any_peer", "call_remote", "reliable")
func _rpc_class_focus(index: int) -> void:
	if index < 0 or index >= _class_ids.size():
		return
	_class_info_panel.show_class(_class_ids[index], not _is_s2())
	_choice_menu.highlight_option(index)


## Active player -> All: Show equipment options as read-only mirror.
@rpc("any_peer", "call_remote", "reliable")
func _rpc_show_equip_mirror(char_idx: int, owner_name: String,
		slot_type: String) -> void:
	if NetManager.is_my_fighter(char_idx):
		return
	_name_input.visible = false
	_class_info_panel.visible = false
	_waiting_overlay.hide_waiting()
	_dialogue.visible = false
	var choices: Array[Dictionary]
	match slot_type:
		"weapon": choices = EquipmentDB.get_weapon_choices()
		"armor": choices = EquipmentDB.get_armor_choices()
		"boots": choices = EquipmentDB.get_boots_choices()
		_: return
	var mirror_options: Array[Dictionary] = []
	for c: Dictionary in choices:
		mirror_options.append({"label": c.label, "description": c.description, "disabled": true})
	_choice_menu.show_choices(mirror_options)
	_choice_menu.highlight_option(0)


## Active player -> All: Mirror name text as it's typed.
@rpc("any_peer", "call_remote", "unreliable_ordered")
func _rpc_name_text(text: String) -> void:
	_name_input.set_mirror_text(text)


## Active player -> All: Sync which equipment option is focused.
@rpc("any_peer", "call_remote", "reliable")
func _rpc_equip_focus(index: int) -> void:
	_choice_menu.highlight_option(index)


## Host -> All: Equipment choice was applied.
@rpc("authority", "call_remote", "reliable")
func _rpc_equip_applied(char_idx: int, choice_id: String) -> void:
	if char_idx < 0 or char_idx >= _party.size():
		return
	var fighter: FighterData = _party[char_idx]
	var equip: EquipmentData = EquipmentDB.create_equipment(choice_id)
	EquipmentDB.apply_to_fighter(equip, fighter)
	fighter.equipment.append(equip)


## Guest -> Host: Submit an equipment choice.
@rpc("any_peer", "call_remote", "reliable")
func _rpc_submit_equip(char_idx: int, choice_id: String) -> void:
	if not NetManager.is_host:
		return
	if char_idx < 0 or char_idx >= _party.size():
		return
	var fighter: FighterData = _party[char_idx]
	var equip: EquipmentData = EquipmentDB.create_equipment(choice_id)
	EquipmentDB.apply_to_fighter(equip, fighter)
	fighter.equipment.append(equip)
	_rpc_equip_applied.rpc(char_idx, choice_id)
	_advance_equip_state()
