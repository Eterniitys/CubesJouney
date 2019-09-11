extends KinematicBody2D

const GRAVITY = 1000
const UP = Vector2(0,-1)
const ACCEL = 5

var vel = Vector2()
var max_speed = 200

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	vel.y += GRAVITY * delta
	movement_loop()
	
	move_and_slide(vel, UP) # UP indique la direction du plafond
	
func movement_loop():
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var dirx = int(right) - int(left)
	match dirx: # switch
		1: # Droite
			vel.x = min(vel.x+ACCEL, max_speed)
		-1: # Gauche
			vel.x = max(vel.x-ACCEL, -max_speed)
		_: # Both
			vel.x = lerp(vel.x ,0, 0.2)
	
	 #vel.x = max_speed * dirx
	
	var jump = Input.is_action_just_pressed("ui_up")
	if jump == true and is_on_floor():
		vel.y = -300
		
	if !jump and is_on_floor():
		vel.y = 100