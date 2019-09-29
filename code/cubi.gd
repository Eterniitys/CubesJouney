extends KinematicBody2D

const UP = Vector2.UP
const GRAVITY = 1000
const MAX_SPEED = 300
const JUMP_HEIGH = 550
# movementd
enum {IDLE, TRANSLATE, JUMP}
var vel = Vector2()
var carried = false
signal wanna_jump
# Shadow
var shadow
# TODO del
var old_scale = false
var state
var snap
# Scaling cube datas
var scale_speed = 0.15
var scale_min_x
var scale_min_y
var delta_scale_x
var delta_scale_y

func _ready():
	shadow = get_parent().get_node("cubx_shadow")
	get_parent().get_node("cuba").connect("wanna_jump", self, "_cuba_wanna_jump")
	change_state(IDLE)

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
	# Going through tiles (allowing it)
	travers()
	
	# Moves applications
	vel = move_and_slide_with_snap(vel, snap, UP)

func movements(delta):
	for i in get_slide_count():
		var col = get_slide_collision(i)
		var has_cubi = false
		if col.collider.name == "cuba" and col.normal == Vector2.UP:
			has_cubi = true
			carried = true
		if !has_cubi:
			carried = false
	
	var left = Input.is_action_pressed("left_cubi")
	var right = Input.is_action_pressed("right_cubi")
	# direction
	if left and !right: vel.x = -MAX_SPEED 
	elif right and !left: vel.x = MAX_SPEED
	else: vel.x = 0
	
	var jump = Input.is_action_just_pressed("jump_cubi")
	if jump and is_on_floor():
		emit_signal("wanna_jump")
		yield(get_tree().create_timer(0.02),"timeout")
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
			snap = Vector2.ZERO
			carried = false

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

func _cuba_wanna_jump():
	if carried :
		vel.y = -JUMP_HEIGH