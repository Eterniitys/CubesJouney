extends Node

const DEFAULT_IP = '127.0.0.1'
const DEFAULT_PORT = 33221
const MAX_PLAYERS = 2
var actual_scene = ""
#players on server
var players = {}
#new player info
var self_data = {name = '', network_id = 1}
var play_on_network = false
signal data_ready

func create_server(player_name):
	self_data.name = player_name
	self_data.network_id = 1
	players[1] = self_data
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)

func connect_to_server(player_name, desired_ip):
	var used_ip = desired_ip
	if used_ip == "localhost" :
		used_ip = DEFAULT_IP
	self_data.name = player_name
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("connection_failed", self, "_connection_failed", [desired_ip])
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(used_ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

func _connected_to_server():
	self_data.network_id = get_tree().get_network_unique_id()
	players[self_data.network_id] = self_data
	emit_signal("data_ready")
	rpc("_send_player_info", self_data.network_id, self_data)

remote func _send_player_info(id_new_player, new_player_data):
	var new_player = null
	if get_tree().is_network_server():
		for peer_id in players:
			rpc_id(id_new_player,"_send_player_info",peer_id, players[peer_id])
	
	players[id_new_player] = new_player_data
	# give control on players
	new_player = get_node(actual_scene).get_node("Players").get_node(players[id_new_player].name)
	new_player.set_network_master(id_new_player)

func _connection_failed(desired_ip):
	print("connection_failed : " + desired_ip)

func _server_disconnected():
	print("server_disconnected")
	get_tree().change_scene("res://scene/Menu_screen/TitleScreen.tscn")
	get_tree().set_network_peer(null)
	
	