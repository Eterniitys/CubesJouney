extends Node2D

export (String, FILE, "*.tscn") var next_right
export (String, FILE, "*.tscn") var next_left
var cubiPresent = false
var cubaPresent = false

func _ready():
	
	match GLOBAL.sens:
		GLOBAL.LEFT:
			get_node("Players").position = get_node("right_position").position
		GLOBAL.RIGHT:
			get_node("Players").position = get_node("left_position").position

func _on_exit_right_body_entered(body):
	if (body.name == "cubi"):
		cubiPresent = true
	if (body.name == "cuba"):
		cubaPresent = true
	if (cubiPresent and cubaPresent):
		GLOBAL.set_sens(GLOBAL.RIGHT)
		get_tree().change_scene(next_right) 
