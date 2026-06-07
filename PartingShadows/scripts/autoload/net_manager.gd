extends Node

## Multiplayer session manager. Handles lobby creation, peer tracking,
## character slot assignment, and transport abstraction.
##
## All game code uses Godot's MultiplayerPeer API and @rpc annotations.
## The transport layer is swapped per platform at connection time:
##   - Steam (PC): SteamMultiplayerPeer GDExtension
##   - Switch / fallback: ENetMultiplayerPeer (built-in)

const FighterData := preload("res://scripts/data/fighter_data.gd")
const FighterDB := preload("res://scripts/data/fighter_db.gd")

signal player_joined(peer_id: int, player_name: String)
signal player_left(peer_id: int, player_name: String)
signal lobby_ready  ## Enough players have joined to start
signal session_ended(reason: String)
signal steam_hosting_started(lobby_id: int)
signal steam_hosting_failed
signal peer_scene_ready(player_index: int)  ## Relayed ready signal for any scene

## Whether a multiplayer session is active (host or guest)
var is_multiplayer_active: bool = false
## Whether this peer is the host (authority)
var is_host: bool = false
## Steam lobby ID (0 when not using Steam lobbies)
var lobby_id: int = 0
## True when session uses Steam relay instead of direct ENet
var _use_steam: bool = false
## Set by SteamManager when a join_requested overlay invite arrives
var pending_join_lobby_id: int = 0
## Number of players in this session (1 = singleplayer, 2 or 3)
var player_count: int = 1
## Mapping of peer_id -> Array[int] of party slot indices
var peer_slots: Dictionary = {}
## Which party indices this local player controls
var my_slots: Array[int] = []
## Mapping of peer_id -> display name
var peer_names: Dictionary = {}
## Target player count for lobby (set by host before starting)
var target_player_count: int = 2

const DEFAULT_PORT: int = 7777
const MAX_PLAYERS: int = 3

var _turn_timeout_timer: Timer


func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

	_turn_timeout_timer = Timer.new()
	_turn_timeout_timer.one_shot = true
	_turn_timeout_timer.wait_time = 60.0
	add_child(_turn_timeout_timer)

	# Dev-only: --host auto-hosts, --connect <ip> auto-joins (ENet, no Steam)
	if OS.is_debug_build():
		var args := OS.get_cmdline_user_args()
		if "--host" in args:
			call_deferred("_dev_auto_host")
		elif "--connect" in args:
			var idx := args.find("--connect")
			var addr := args[idx + 1] if idx + 1 < args.size() else "127.0.0.1"
			call_deferred("_dev_auto_connect", addr)


func _dev_auto_host() -> void:
	GameLog.info("NetManager: [DEV] Auto-hosting on port %d" % DEFAULT_PORT)
	host_game()


func _dev_auto_connect(address: String) -> void:
	GameLog.info("NetManager: [DEV] Auto-connecting to %s:%d" % [address, DEFAULT_PORT])
	join_game(address)


# =============================================================================
# Transport setup
# =============================================================================

func host_game(port: int = DEFAULT_PORT) -> Error:
	var peer := ENetMultiplayerPeer.new()
	var err := peer.create_server(port, MAX_PLAYERS - 1)
	if err != OK:
		GameLog.info("NetManager: Failed to create server on port %d (error %d)" % [port, err])
		return err
	multiplayer.multiplayer_peer = peer
	is_host = true
	is_multiplayer_active = true
	player_count = 1

	# Host is always peer 1
	var host_name: String = _get_local_player_name()
	peer_names[1] = host_name
	_assign_host_slots()

	GameLog.info("NetManager: Hosting on port %d as '%s'" % [port, host_name])
	return OK


func join_game(address: String, port: int = DEFAULT_PORT) -> Error:
	var peer := ENetMultiplayerPeer.new()
	var err := peer.create_client(address, port)
	if err != OK:
		GameLog.info("NetManager: Failed to connect to %s:%d (error %d)" % [address, port, err])
		return err
	multiplayer.multiplayer_peer = peer
	is_host = false
	is_multiplayer_active = true

	GameLog.info("NetManager: Connecting to %s:%d" % [address, port])
	return OK


## Create a Steam lobby and host via SteamMultiplayerPeer relay.
## Async: emits steam_hosting_started(lobby_id) on success or steam_hosting_failed on error.
func host_game_steam() -> void:
	_use_steam = true
	Steam.lobby_created.connect(_on_steam_lobby_created, CONNECT_ONE_SHOT)
	Steam.createLobby(Steam.LOBBY_TYPE_FRIENDS_ONLY, MAX_PLAYERS)


func _on_steam_lobby_created(connect: int, new_lobby_id: int) -> void:
	if connect != 1:  # 1 = k_EResultOK
		GameLog.info("NetManager: Steam lobby creation failed (result %d)" % connect)
		_use_steam = false
		steam_hosting_failed.emit()
		return
	var peer := SteamMultiplayerPeer.new()
	var err: int = peer.host_with_lobby(new_lobby_id)
	if err != OK:
		GameLog.info("NetManager: host_with_lobby failed (%d)" % err)
		_use_steam = false
		Steam.leaveLobby(new_lobby_id)
		steam_hosting_failed.emit()
		return
	multiplayer.multiplayer_peer = peer
	lobby_id = new_lobby_id
	is_host = true
	is_multiplayer_active = true
	player_count = 1
	var host_name: String = _get_local_player_name()
	peer_names[1] = host_name
	_assign_host_slots()
	GameLog.info("NetManager: Steam lobby %d created as '%s'" % [new_lobby_id, host_name])
	steam_hosting_started.emit(new_lobby_id)


## Join a Steam lobby and connect via SteamMultiplayerPeer relay.
## Async: connection result arrives via multiplayer.connected_to_server / connection_failed.
func join_game_steam(steam_lobby_id: int) -> void:
	_use_steam = true
	Steam.lobby_joined.connect(_on_steam_lobby_joined, CONNECT_ONE_SHOT)
	Steam.joinLobby(steam_lobby_id)


func _on_steam_lobby_joined(joined_lobby: int, _permissions: int, _locked: bool, response: int) -> void:
	if response != 1:  # 1 = k_EChatRoomEnterResponseSuccess
		GameLog.info("NetManager: Failed to join Steam lobby (response %d)" % response)
		_use_steam = false
		session_ended.emit("Failed to join lobby")
		return
	var peer := SteamMultiplayerPeer.new()
	var err: int = peer.connect_to_lobby(joined_lobby)
	if err != OK:
		GameLog.info("NetManager: connect_to_lobby failed (%d)" % err)
		_use_steam = false
		Steam.leaveLobby(joined_lobby)
		session_ended.emit("Failed to connect to lobby")
		return
	multiplayer.multiplayer_peer = peer
	lobby_id = joined_lobby
	is_host = false
	is_multiplayer_active = true
	GameLog.info("NetManager: Joined Steam lobby %d" % joined_lobby)


func leave_session() -> void:
	if not is_multiplayer_active:
		return
	GameLog.info("NetManager: Leaving session")
	if _use_steam and lobby_id != 0:
		Steam.leaveLobby(lobby_id)
	multiplayer.multiplayer_peer = null
	_reset_state()


func _reset_state() -> void:
	is_multiplayer_active = false
	is_host = false
	lobby_id = 0
	_use_steam = false
	player_count = 1
	peer_slots.clear()
	my_slots.clear()
	peer_names.clear()


# =============================================================================
# Slot assignment
# =============================================================================

func _assign_host_slots() -> void:
	if target_player_count == 2:
		# Host gets slots 0 and 2
		peer_slots[1] = [0, 2]
		my_slots = [0, 2]
	else:
		# 3-player: host gets slot 0 only
		peer_slots[1] = [0]
		my_slots = [0]


func _assign_guest_slot(peer_id: int) -> void:
	if target_player_count == 2:
		# Guest gets slot 1
		peer_slots[peer_id] = [1]
	elif target_player_count == 3:
		# First guest gets slot 1, second guest gets slot 2
		if not _slot_taken(1):
			peer_slots[peer_id] = [1]
		elif not _slot_taken(2):
			peer_slots[peer_id] = [2]


func _slot_taken(slot: int) -> bool:
	for peer_id: int in peer_slots:
		var slots: Array = peer_slots[peer_id]
		if slot in slots:
			return true
	return false


# =============================================================================
# Ownership queries
# =============================================================================

func is_my_fighter(party_index: int) -> bool:
	if not is_multiplayer_active:
		return true
	return party_index in my_slots


func get_fighter_owner_peer(party_index: int) -> int:
	for peer_id: int in peer_slots:
		var slots: Array = peer_slots[peer_id]
		if party_index in slots:
			return peer_id
	return 1  # Fallback to host


func get_fighter_owner_name(party_index: int) -> String:
	var peer_id: int = get_fighter_owner_peer(party_index)
	return peer_names.get(peer_id, "Player")


func get_connected_peer_count() -> int:
	if not is_multiplayer_active:
		return 1
	return peer_names.size()


func is_lobby_full() -> bool:
	return get_connected_peer_count() >= target_player_count


# =============================================================================
# Connection callbacks
# =============================================================================

func _on_peer_connected(peer_id: int) -> void:
	GameLog.info("NetManager: Peer %d connected" % peer_id)
	if is_host:
		player_count += 1
		_assign_guest_slot(peer_id)
		# Send host info to new peer
		_rpc_receive_player_name.rpc_id(peer_id, 1, peer_names[1])
		# Send existing peers' names to new peer
		for existing_id: int in peer_names:
			if existing_id != 1 and existing_id != peer_id:
				_rpc_receive_player_name.rpc_id(peer_id, existing_id, peer_names[existing_id])
		# Request the new peer's name
		_rpc_request_name.rpc_id(peer_id)


func _on_peer_disconnected(peer_id: int) -> void:
	var name: String = peer_names.get(peer_id, "Unknown")
	GameLog.info("NetManager: Peer %d ('%s') disconnected" % [peer_id, name])
	if is_host:
		player_count -= 1
		# Reassign disconnected peer's slots to host (AI takeover)
		var lost_slots: Array = peer_slots.get(peer_id, [])
		if not lost_slots.is_empty():
			peer_slots.erase(peer_id)
			var host_slots: Array = peer_slots.get(1, [])
			for s: int in lost_slots:
				if s not in host_slots:
					host_slots.append(s)
			peer_slots[1] = host_slots
			my_slots = host_slots
			GameLog.info("NetManager: Reassigned slots %s to host" % str(lost_slots))
		peer_names.erase(peer_id)
		player_left.emit(peer_id, name)


func _on_connected_to_server() -> void:
	GameLog.info("NetManager: Connected to server as peer %d" % multiplayer.get_unique_id())
	# Send our name to host
	var local_name: String = _get_local_player_name()
	_rpc_submit_name.rpc_id(1, local_name)


func _on_connection_failed() -> void:
	GameLog.info("NetManager: Connection to server failed")
	session_ended.emit("Connection failed")
	_reset_state()


func _on_server_disconnected() -> void:
	GameLog.info("NetManager: Server disconnected")
	session_ended.emit("Host disconnected")
	_reset_state()


# =============================================================================
# Name exchange RPCs
# =============================================================================

@rpc("authority", "call_remote", "reliable")
func _rpc_request_name() -> void:
	# Host asked us for our name
	var local_name: String = _get_local_player_name()
	_rpc_submit_name.rpc_id(1, local_name)


@rpc("any_peer", "call_remote", "reliable")
func _rpc_submit_name(player_name: String) -> void:
	if not is_host:
		return
	var sender: int = multiplayer.get_remote_sender_id()
	peer_names[sender] = player_name
	GameLog.info("NetManager: Peer %d is '%s'" % [sender, player_name])

	# Broadcast name to all peers
	_rpc_receive_player_name.rpc(sender, player_name)

	player_joined.emit(sender, player_name)
	if is_lobby_full():
		lobby_ready.emit()


@rpc("authority", "call_local", "reliable")
func _rpc_receive_player_name(peer_id: int, player_name: String) -> void:
	peer_names[peer_id] = player_name


# =============================================================================
# Slot assignment broadcast
# =============================================================================

func broadcast_slot_assignments() -> void:
	if not is_host:
		return
	var data: Dictionary = {}
	for peer_id: int in peer_slots:
		data[peer_id] = peer_slots[peer_id]
	# Apply locally first — don't rely on call_local which can silently fail
	apply_slot_data(data, target_player_count)
	# Send to remote peers
	_rpc_receive_slots.rpc(data, target_player_count)


@rpc("authority", "call_remote", "reliable")
func _rpc_receive_slots(slot_data: Dictionary, p_count: int) -> void:
	apply_slot_data(slot_data, p_count)


## Apply slot assignments directly. Safe to call from any RPC or locally.
func apply_slot_data(slot_data: Dictionary, p_count: int) -> void:
	peer_slots = slot_data
	target_player_count = p_count
	player_count = p_count
	var my_id: int = multiplayer.get_unique_id()
	# Rebuild my_slots with explicit typed construction to avoid Array/Array[int] mismatch
	my_slots.clear()
	if my_id in slot_data:
		var raw: Array = slot_data[my_id]
		for s: int in raw:
			my_slots.append(s)
	GameLog.info("NetManager: Applied slots -- my_id=%d my_slots=%s peer_slots=%s" % [
		my_id, str(my_slots), str(peer_slots)])


# =============================================================================
# Utility
# =============================================================================

func _get_local_player_name() -> String:
	if SteamManager.is_steam_running:
		return Steam.getPersonaName()
	return "Player"


## Start the turn timeout timer. Call when waiting for a remote player's action.
func start_turn_timeout() -> void:
	_turn_timeout_timer.start()


## Stop the turn timeout timer. Call when the player submits their action.
func stop_turn_timeout() -> void:
	_turn_timeout_timer.stop()


## Returns true if the turn timeout has elapsed.
func is_turn_timed_out() -> bool:
	return _turn_timeout_timer.is_stopped() and _turn_timeout_timer.time_left <= 0.0


# =============================================================================
# Game state broadcast (for Open to Multiplayer)
# =============================================================================

## Serialize and send the full game state to all remote peers.
func broadcast_game_state() -> void:
	if not is_host:
		return
	var party_data: Array[Dictionary] = []
	for fighter: FighterData in GameState.party:
		party_data.append(fighter.to_save_data())
	var inv_data: Dictionary = GameState.inventory.to_save_data()
	_rpc_sync_game_state.rpc(party_data, GameState.current_battle_id,
		GameState.current_story_id, inv_data, GameState.difficulty)


@rpc("authority", "call_remote", "reliable")
func _rpc_sync_game_state(party_data: Array, battle_id: String, story_id: String,
		inv_data: Dictionary = {}, difficulty: int = 1) -> void:
	GameState.party.clear()
	for data: Dictionary in party_data:
		var fighter := FighterData.new()
		fighter.apply_save_data(data)
		fighter.abilities = FighterDB.get_abilities_for_class(fighter.class_id)
		GameState.party.append(fighter)
	if not inv_data.is_empty():
		GameState.inventory.apply_save_data(inv_data)
	GameState.difficulty = difficulty
	GameState.current_story_id = story_id
	GameState.advance_to_battle(battle_id)


## Tell all remote peers to change to a specific scene.
func change_scene_for_peers(scene_path: String) -> void:
	if not is_host:
		return
	GameLog.info("NetManager: change_scene_for_peers('%s')" % scene_path)
	_rpc_change_scene_all.rpc(scene_path)


## Reload the current scene on all peers (host + guests).
func reload_current_scene_all_peers() -> void:
	if not is_host:
		return
	var scene_path: String = _current_scene_path()
	_rpc_change_scene_all.rpc(scene_path)
	SceneManager.change_scene(scene_path)


func _current_scene_path() -> String:
	match GameState.game_phase:
		GameState.GamePhase.TOWN_STOP:
			return "res://scenes/town_stop/town_stop.tscn"
		GameState.GamePhase.NARRATIVE:
			return "res://scenes/narrative/narrative.tscn"
		GameState.GamePhase.BATTLE:
			return "res://scenes/battle/battle.tscn"
		_:
			return "res://scenes/narrative/narrative.tscn"


@rpc("authority", "call_remote", "reliable")
func _rpc_change_scene_all(scene_path: String) -> void:
	SceneManager.change_scene(scene_path)


# =============================================================================
# Scene-ready relay (routed through autoload for reliable RPC paths)
# =============================================================================

## Get the local player's index in the sorted peer list.
func get_my_peer_index() -> int:
	if is_host:
		return 0
	var peers: Array[int] = []
	for pid: int in peer_names:
		peers.append(pid)
	peers.sort()
	return peers.find(multiplayer.get_unique_id())


## Notify all peers that the local player is ready to advance.
func notify_scene_ready(player_index: int) -> void:
	GameLog.info("NetManager: notify_scene_ready(%d) from peer %d" % [player_index, multiplayer.get_unique_id()])
	if is_host:
		_rpc_scene_ready.rpc(player_index)
	else:
		_rpc_scene_ready.rpc_id(1, player_index)


@rpc("any_peer", "call_remote", "reliable")
func _rpc_scene_ready(player_index: int) -> void:
	GameLog.info("NetManager: _rpc_scene_ready(%d) received from peer %d" % [player_index, multiplayer.get_remote_sender_id()])
	peer_scene_ready.emit(player_index)
	if is_host:
		_rpc_scene_ready_broadcast.rpc(player_index)


@rpc("authority", "call_remote", "reliable")
func _rpc_scene_ready_broadcast(player_index: int) -> void:
	GameLog.info("NetManager: _rpc_scene_ready_broadcast(%d)" % player_index)
	peer_scene_ready.emit(player_index)
