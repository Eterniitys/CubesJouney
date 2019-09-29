extends KinematicBody2D

const UP = Vector2.UP
const GRAVITY = 1000
const MAX_SPEED = 300
const JUMP_HEIGH = 550
# Velocity
var vel = Vector2()
# Shadow
#var shadow_preload = preload("res://scene/objects/cubx_shadow.tscn")
var shadow
# TODO del
var old_scale = false
enum {IDLE, TRANSLATE, JUMP}
var state = IDLE
var snap
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
	# Gravity
	if !is_on_floor():
		vel.y += GRAVITY * delta
	# Moves
	manage_state()
	movements(delta)
	# Transform
	if old_scale:
		transform_alt(delta)
	else:
		transform(delta)
	# Shadow power
	if Input.is_action_just_pressed("shadow_cubi"):
		call_shadow()
	
	# Moves applications
	vel = move_and_slide_with_snap(vel, snap, UP)
	# Travers cube when press f/j
	travers()


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
	
	var jump = Input.is_action_just_pressed("jump_cubi")
	if jump and is_on_floor():
		vel.y = -JUMP_HEIGH
		
func travers ():
	if Input.is_action_just_pressed("travers_cubi"):
		set_collision_mask_bit(5,false)
	if Input.is_action_just_released("travers_cubi"):
		set_collision_mask_bit(5,true)	
		
func call_shadow():
	shadow.set_collision_layer_bit(11,false)
	shadow.get_node("sprite").region_rect = $Sprite.region_rect
	shadow.set_collision_layer_bit(10,true)
	shadow.scale = scale
	shadow.position = position
	#get_parent().add_child(shadow)

func manage_state():
	if state == IDLE and vel.x != 0:
		change_state(TRANSLATE)
	elif state == TRANSLATE and vel.x == 0:
		change_state(IDLE)
	elif state in [IDLE,TRANSLATE] and vel.y != 0:
		change_state(JUMP)
	elif state == JUMP and vel.y == 0:
		change_state(IDLE)

func change_state(new_state):
	state = new_state
	#print("idle" if state == IDLE else ("translate" if state == TRANSLATE else "jump"))	
	match state:
		IDLE:
			snap = Vector2(0,32)
		TRANSLATE:
			pass
		JUMP:
			snap = Vector2(0,0)

func transform_alt(delta):
	if Input.is_action_just_pressed("transform_down_cubi"):
		vel.y = -200
		if state != "down":	
			if state == "up":
				state = "normal"			
			else :
				state = "down"
			scale.x += delta_scale_x
			scale.y -= delta_scale_y

	if Input.is_action_just_pressed("transform_up_cubi"):
		
		if state != "up":
			if state == "down":
				state = "normal"			
			else :
				state = "up"
			scale.x -= delta_scale_x
			scale.y += delta_scale_y

func transform(delta):
	
	if Input.is_action_just_pressed("transform_down_cubi") and is_on_floor() and (scale.y < 0.5) :
		vel.y = -200
		
	if Input.is_action_pressed("transform_down_cubi"):
		scale.x = lerp (scale.x, scale_min_x, scale_speed)
		scale.y = lerp (scale.y, scale_min_y, scale_speed)

	if Input.is_action_pressed("transform_up_cubi"):
		scale.x = lerp (scale.x, scale_min_x + delta_scale_x, scale_speed)
		scale.y = lerp (scale.y, scale_min_y + delta_scale_y, scale_speed)