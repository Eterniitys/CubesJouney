extends Control

func _ready():
	var btn_return = $Menu/Content/Buttons/ReturnMenuButton
	btn_return.connect("pressed", self, "_on_ButtonReturn_pressed", [btn_return.next_scene])

func _load_game():
	get_tree().change_scene("res://scene/levels/waitLevel.tscn")

func _on_ConnectToServer_pressed():
	_load_game()
	NETWORK.connect_to_server("cuba")

func _on_CreateServer_pressed():
	_load_game()
	NETWORK.create_server("cubi")

func _on_ButtonReturn_pressed(scene_to_load):
	$FadeIn.show()
	$FadeIn/AnimationPlayer.play("Fade");
	yield($FadeIn/AnimationPlayer, "animation_finished")
	get_tree().change_scene(scene_to_load)
