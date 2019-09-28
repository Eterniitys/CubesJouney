extends KinematicBody2D

const UP = Vector2.UP
const GRAVITY = 1000
const MAX_SPEED = 300
const JUMP_HEIGH = 550
# Velocity
var vel = Vector2()
# Shadow
var shadow_preload = preload("res://scene/objects/cubx_shadow.tscn")
var shadow
# TODO del
var old_scale = false
var etat = "normal"
# Scaling cube datas
var scale_speed = 0.15
var scale_min_x
var scale_min_y
var delta_scale_x
var delta_scale_y

func _ready():
	#shadow = shadow_preload.instance()
	shadow = get_parent().get_node("cubx_shadow")

func _physics_process(delta):
	vel.y += GRAVITY * delta
	# Moves
	movements(delta)
	# Transform
	if old_scale:
		transform_alt(delta)
	else:
		transform(delta)
	# Shadow
	if Input.is_action_just_pressed("shadow_cuba"):
		call_shadow()
	
	vel = move_and_slide(vel, UP)
    
	# Travers cube when press f/j
	travers()
		
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
		vel.y = -JUMP_HEIGH

func travers ():
	if Input.is_action_just_pressed("travers_cuba"):
		set_collision_mask_bit(5,false)
	if Input.is_action_just_released("travers_cuba"):
		set_collision_mask_bit(5,true)	

func call_shadow():
	shadow.set_collision_layer_bit(10,false)
	shadow.get_node("sprite").region_rect = $Sprite.region_rect
	shadow.set_collision_layer_bit(11,true)
	shadow.scale = scale
	shadow.position = position
	#get_parent().add_child(shadow)

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
		vel.y = -400
		if etat != "up":
			if etat == "down":
				etat = "normal"			
			else :
				etat = "up"
			scale.x -= delta_scale_x
			scale.y += delta_scale_y


func transform(delta):
	
	if Input.is_action_just_pressed("transform_up_cuba") and is_on_floor():
		vel.y = -337
		
	if Input.is_action_pressed("transform_down_cuba"):
		scale.x = lerp (scale.x, scale_min_x, scale_speed)
		scale.y = lerp (scale.y, scale_min_y, scale_speed)

	if Input.is_action_pressed("transform_up_cuba"):
		scale.x = lerp (scale.x, scale_min_x + delta_scale_x, scale_speed)
		scale.y = lerp (scale.y, scale_min_y + delta_scale_y, scale_speed)