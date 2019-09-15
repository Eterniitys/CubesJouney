extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 1000
const MAX_SPEED = 300

var vel = Vector2()
var etat = "normal"

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	# basique move and gravity
	vel = move_and_slide(vel, UP)
	vel.y += GRAVITY * delta
	# moves
	movements(delta)
	
	#transform
	transform(delta)

func movements(delta):
	var left = Input.is_action_pressed("left_cuba")
	var right = Input.is_action_pressed("right_cuba")
	var dirx = int(right) - int(left)
	
	if dirx == 1:
		vel.x = MAX_SPEED 
	elif dirx == -1:
		vel.x = -MAX_SPEED
	else:
		vel.x = 0
	
	var jump = Input.is_action_pressed("jump_cuba")
	if jump and is_on_floor():
		vel.y = -600
	
	
func transform(delta):
	
	if Input.is_action_just_pressed("transform_down_cuba"):
		if etat != "down":	
			if etat == "up":
				etat = "normal"			
			else :
				etat = "down"
			scale.x += 0.5
			scale.y -= 0.5

	if Input.is_action_just_pressed("transform_up_cuba"):
		if etat != "up":
			if etat == "down":
				etat = "normal"			
			else :
				etat = "up"
			scale.x -= 0.5
			scale.y += 0.5
	