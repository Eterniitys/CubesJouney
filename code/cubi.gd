extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 1000
const MAX_SPEED = 300

var vel = Vector2()
var etat = "normal"
export(float) var delta_scale = 0.5

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	# basique move and gravity
	vel.y += GRAVITY * delta
	
	# moves
	movements(delta)
	
	#transform
	transform(delta)
	
	vel = move_and_slide(vel, UP)

func movements(delta):
	var left = Input.is_action_pressed("left_cubi")
	var right = Input.is_action_pressed("right_cubi")
	var dirx = int(right) - int(left)
	
	if dirx == 1:
		vel.x = MAX_SPEED 
	elif dirx == -1:
		vel.x = -MAX_SPEED
	else:
		vel.x = 0
	
	var jump = Input.is_action_pressed("jump_cubi")
	if jump and is_on_floor():
		vel.y = -600
	
	
func transform(delta):
	
	if Input.is_action_just_pressed("transform_down_cubi"):
		if etat != "down":	
			if etat == "up":
				etat = "normal"			
			else :
				etat = "down"
			scale.x += delta_scale
			scale.y -= delta_scale

	if Input.is_action_just_pressed("transform_up_cubi"):
		if etat != "up":
			if etat == "down":
				etat = "normal"			
			else :
				etat = "up"
			scale.x -= delta_scale
			scale.y += delta_scale
	