extends Control

func _ready():
	var btn_return = $Menu/Content/Buttons/ReturnMenuButton
	btn_return.connect("pressed", self, "_on_ButtonReturn_pressed", [btn_return.next_scene])

func _load_game():
	get_tree().change_scene("res://scene/levels/waitLevel.tscn")

func _on_ConnectToServer_pressed():
	var desired_ip = $Menu/Content/Buttons/IP/adresse_ip.text
	NETWORK.connect_to_server("cuba", desired_ip)
	NETWORK.connect("data_ready", self, "_connected_to_server")

func _on_CreateServer_pressed():
	NETWORK.create_server("cubi")
	_load_game()

func _on_ButtonReturn_pressed(scene_to_load):
	$FadeIn.show()
	$FadeIn/AnimationPlayer.play("Fade");
	yield($FadeIn/AnimationPlayer, "animation_finished")
	get_tree().change_scene(scene_to_load)

func _connected_to_server():
	_load_game()