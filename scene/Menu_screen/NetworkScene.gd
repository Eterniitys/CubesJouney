extends Control

func _load_game():
	get_tree().change_scene("res://scene/levels/waitLevel.tscn")

func _on_ConnectToServer_pressed():
	_load_game()
	NETWORK.connect_to_server("cuba")

func _on_CreateServer_pressed():
	_load_game()
	NETWORK.create_server("cubi")
