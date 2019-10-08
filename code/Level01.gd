extends Node2D

export (String, FILE, "*.tscn") var next_right

var cubiPresent = false
var cubaPresent = false

func _ready():
	pass

func _on_exit_right_body_entered(body):
	if (body.name == "cubi"):
		cubiPresent = true
	if (body.name == "cuba"):
		cubaPresent = true
	if (cubiPresent and cubaPresent):
		get_tree().change_scene(next_right)


func _on_exit_right_body_exited(body):
	if (body.name == "cubi"):
		cubiPresent = false
	if (body.name == "cuba"):
		cubaPresent = false
