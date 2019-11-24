extends Node2D

export (PackedScene) var next_scene
var cubiPresent = false
var cubaPresent = false

func _ready():
	pass

#warning-ignore:return_value_discarded
func _on_exit_right_body_entered(body):
	if (body.name == "cubi"):
		cubiPresent = true
	if (body.name == "cuba"):
		cubaPresent = true
	if (cubiPresent and cubaPresent):
		if "HubDoor" in self.name:
			get_tree().change_scene("res://scene/levels/HubRoom.tscn")
		else:
			get_tree().change_scene_to(next_scene)

func _on_exit_right_body_exited(body):
	if (body.name == "cubi"):
		cubiPresent = false
	if (body.name == "cuba"):
		cubaPresent = false
