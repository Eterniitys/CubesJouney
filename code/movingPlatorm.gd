extends KinematicBody2D

const SPEED = 100

var vel = Vector2()
var compteur = 0


func _ready():
	pass # Replace with function body.

func _process(delta):
	compteur +=1
	
	if compteur <= -10:
		vel.x = -SPEED
	elif compteur >= 10:
		vel.x = SPEED
	else:
		vel.x = 0
	
	if compteur == 100:
		compteur *= -1
		
	vel = move_and_slide(vel)
