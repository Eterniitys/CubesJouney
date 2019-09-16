extends KinematicBody2D

const UP = Vector2(0,-1)

var vel = Vector2()

func _ready():
	pass
	
func _physics_process(delta):
	
	vel = move_and_slide(vel, UP)
	
	pass
