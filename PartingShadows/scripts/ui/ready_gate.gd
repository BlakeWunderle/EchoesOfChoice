class_name ReadyGate extends HBoxContainer

## Blocks progression until all players press confirm.
## Works for both local co-op (device-based) and online MP (RPC-based).

signal all_ready

var _player_count: int = 0
var _ready_states: Array[bool] = []
var _labels: Array[Label] = []
var _is_online: bool = false
var _pending_ready: Array[int] = []  ## Buffered ready signals that arrived before gate started


func _init() -> void:
	alignment = BoxContainer.ALIGNMENT_CENTER
	add_theme_constant_override("separation", 24)


## Start local co-op ready gate.
func start_local(count: int) -> void:
	_is_online = false
	_player_count = count
	_ready_states.clear()
	for i: int in count:
		_ready_states.append(false)
	_build_labels()
	visible = true
	# Allow any device to interact (no gating)
	LocalCoop.clear_active_player()


## Start online multiplayer ready gate.
func start_online(peer_count: int) -> void:
	_is_online = true
	_player_count = peer_count
	_ready_states.clear()
	_pending_ready.clear()
	for i: int in peer_count:
		_ready_states.append(false)
	_build_labels()
	visible = true


func _build_labels() -> void:
	for child: Node in get_children():
		child.queue_free()
	_labels.clear()
	for i: int in _player_count:
		var label := Label.new()
		label.add_theme_font_size_override("font_size", 18)
		_update_label(label, i)
		add_child(label)
		_labels.append(label)


func _update_label(label: Label, index: int) -> void:
	var name: String
	if _is_online:
		var peers: Array[int] = []
		for pid: int in NetManager.peer_names:
			peers.append(pid)
		peers.sort()
		if index < peers.size():
			name = NetManager.peer_names.get(peers[index], "Player %d" % (index + 1))
		else:
			name = "Player %d" % (index + 1)
	else:
		name = LocalCoop.get_player_name(index)

	if _ready_states[index]:
		label.text = "%s: Ready" % name
		label.add_theme_color_override("font_color", Color(0.3, 0.9, 0.5))
	else:
		label.text = "%s: ..." % name
		label.add_theme_color_override("font_color", Color(0.6, 0.65, 0.7))


func _refresh_labels() -> void:
	for i: int in _labels.size():
		_update_label(_labels[i], i)


func _check_all_ready() -> void:
	for r: bool in _ready_states:
		if not r:
			return
	visible = false
	_ready_states.clear()
	all_ready.emit()


## Local co-op: check input device to determine which player pressed.
func _input(event: InputEvent) -> void:
	if not visible or _is_online:
		return
	if not event.is_action_pressed("confirm"):
		return
	get_viewport().set_input_as_handled()

	var player: int = -1
	if event is InputEventKey or event is InputEventMouseButton:
		player = LocalCoop.get_player_for_device(-1)
		# If keyboard isn't registered, accept from any player that isn't ready
		if player < 0:
			for i: int in _ready_states.size():
				if not _ready_states[i]:
					player = i
					break
	elif event is InputEventJoypadButton:
		player = LocalCoop.get_player_for_device(event.device)

	if player >= 0 and player < _ready_states.size() and not _ready_states[player]:
		_ready_states[player] = true
		_refresh_labels()
		_check_all_ready()


## Online MP: mark a specific player index as ready (called by scene RPCs).
func mark_ready(player_index: int) -> void:
	if _ready_states.is_empty():
		# Gate not started yet — buffer for when it opens
		if player_index not in _pending_ready:
			_pending_ready.append(player_index)
		return
	if player_index >= 0 and player_index < _ready_states.size():
		_ready_states[player_index] = true
		_refresh_labels()
		_check_all_ready()
