extends Node

const DEFAULT_IP = '127.0.0.1'
const DEFAULT_PORT = 33221
const MAX_PLAYERS = 2

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
	if get_tree().is_network_server():
		for peer_id in players:
			rpc_id(id_new_player,"_send_player_info",peer_id, players[peer_id])

	#add new player with all others
	players[id_new_player] = info_new_player
	#create new players
	var create_player = load("res://player.tscn").instance()
	create_player.name = str(id_new_player)
	#this player is the master of himself
	create_player.set_network_master(id_new_player)
	get_tree().get_root().add_child(create_player)
	create_player.init(info_new_player.name, info_new_player.position, info_new_player.scale)

func update_position(id, position):
	players[id].position = position