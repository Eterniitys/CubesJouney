extends Node2D

func _ready():
	get_node("Players").position = $initial.position
	LIFELINE.set_checkpoint_cuba($initial)
	LIFELINE.set_checkpoint_cubi($initial)
	
	if NETWORK.play_on_network :
		for peer_id in NETWORK.players:
			var player = get_node("Players").get_node(NETWORK.players[peer_id].name)
			player.set_network_master(NETWORK.players[peer_id].network_id)
			player.network_id = NETWORK.players[peer_id].network_id