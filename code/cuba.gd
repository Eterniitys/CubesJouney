extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 1000
const MAX_SPEED = 300

var vel = Vector2()

var old_scale = false
var etat = "normal"

var scale_speed = 0.15
var scale_min_x
var scale_min_y
var delta_scale_x
var delta_scale_y

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	# basique move and gravity
	vel.y += GRAVITY * delta
	
	# moves
	movements(delta)
	
	#transform
	if old_scale:
		transform_alt(delta)
	else:
		transform(delta)
	
	vel = move_and_slide(vel, UP)

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

func transform_alt(delta):
	if Input.is_action_just_pressed("transform_down_cuba"):
		if etat != "down":	
			if etat == "up":
				etat = "normal"			
			else :
				etat = "down"
			scale.x += delta_scale_x
			scale.y -= delta_scale_y

	if Input.is_action_just_pressed("transform_up_cuba"):
		if etat != "up":
			if etat == "down":
				etat = "normal"			
			else :
				etat = "up"
			scale.x -= delta_scale_x
			scale.y += delta_scale_y

	
func transform(delta):
	if Input.is_action_pressed("transform_down_cuba"):
		scale.x = lerp (scale.x, scale_min_x, scale_speed)
		scale.y = lerp (scale.y, scale_min_y, scale_speed)

	if Input.is_action_pressed("transform_up_cuba"):
		scale.x = lerp (scale.x, scale_min_x + delta_scale_x, scale_speed)
		scale.y = lerp (scale.y, scale_min_y + delta_scale_y, scale_speed)