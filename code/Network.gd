extends Node

const DEFAULT_IP = '127.0.0.1'
const DEFAULT_PORT = 33221
const MAX_PLAYERS = 2
var actual_scene = ""
#players on server
var players = {}
#new player info
var new_player_data = {name = '', position = Vector2.ZERO, scale = Vector2(1,1) }

func create_server(player_name):
	new_player_data.name = player_name
	players[1] = new_player_data
	#new player on server -> peer
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	#add peer to network
	get_tree().set_network_peer(peer)

func connect_to_server(player_name):
	new_player_data.name = player_name
	#new player wait signal response connect to server
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

func _connected_to_server():
	players[get_tree().get_network_unique_id()] = new_player_data
	#all others players on the server will send info the new player
	rpc("_send_player_info", get_tree().get_network_unique_id(),new_player_data)

remote func _send_player_info(id_new_player, info_new_player):
	var create_player = null
	if get_tree().is_network_server():
		for peer_id in players:
			rpc_id(id_new_player,"_send_player_info",peer_id, players[peer_id])

	#add new player with all others
	players[id_new_player] = info_new_player
	#create new players
	if is_network_master():
		# TODO verifier le contenu de actual_scene -> signal 
		create_player = get_node(actual_scene).get_node("Players").get_node("cubi")
	else :
		create_player = get_node(actual_scene).get_node("Players").get_node("cuba")
	create_player.network_id = id_new_player
	#this player is the master of himself
	create_player.set_network_master(id_new_player)
	
func update_position(id, position, scale):
	players[id].position = position
	players[id].scale = scale