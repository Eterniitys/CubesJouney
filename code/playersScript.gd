extends KinematicBody2D
#warning-ignore-all:unused_variable
#warning-ignore-all:unused_argument
export(String) var theOtherName

const UP = Vector2.UP
const GRAVITY = 1000
const MAX_SPEED = 300
const JUMP_HEIGH = 550
const RESET_TIMER_MAX = 2
# movement
enum {IDLE, TRANSLATE, JUMP}
var vel = Vector2.ZERO
var carried = false
var move_with = false
signal wanna_jump

# Shadow
var shadow
export var can_use_shadow = false
#warning-ignore:unused_class_variable
var side_collide = [0,0]
var reset_timer
var state
var snap
# Scaling cube settings
var scale_speed = 0.15
var scale_up_x = 1
var scale_up_y = 1
var scale_down_x = 1
var scale_down_y = 1
export var can_scale = false
# Networking
var network_id = 2
puppet var puppet_position = Vector2.ZERO
puppet var puppet_scale = Vector2(1,1)
#puppet var puppet_velocity = Vector2.ZERO

#
func _ready():
	puppet_position = position
	puppet_scale = scale
	
	shadow = get_parent().get_node("cubx_shadow")
	#warning-ignore:return_value_discarded
	get_parent().get_node(theOtherName).connect("wanna_jump", self, "_"+theOtherName+"_wanna_jump")
	change_state(IDLE)
	prepare_scale()

func _physics_process(delta):
	# Gravity
	if !is_on_floor():
		vel.y += GRAVITY * delta
	# Moves
	manage_state()
	if Input.is_action_pressed("resetPos"):
		reset_timer+=delta
		vel.x = 0
		if reset_timer >= RESET_TIMER_MAX:
			reset_pos()
			reset_timer=0
	else:
		reset_timer=0
		movements(delta)
	# Transform
	if can_scale:
		transform(delta)
		
	if NETWORK.play_on_network:
		# Shadow power
		if is_network_master() and can_use_shadow and Input.is_action_just_pressed(get_parent().get_node(name).get_shadow()):
			rpc("call_shadow")
	elif can_use_shadow and Input.is_action_just_pressed(get_parent().get_node(name).get_shadow()):
		call_shadow()
		
	# Going through tiles (allowing it)
	travers()
	
	# Moves applications
	vel = move_and_slide_with_snap(vel, snap, UP)
	
	# stop moving with the other cube
	if !carried and is_on_floor():
		move_with = false
	
	# start moving with the other cube
	if carried :
		move_with = true
	
	# Network
	if NETWORK.play_on_network:
		$name.text = str(network_id)
		if is_network_master():
			rset_unreliable("puppet_position", position)
			rset_unreliable("puppet_scale", scale)
		else:
			position = puppet_position
			scale = puppet_scale

#warning-ignore:unused_argument
master func movements(delta):
	var left = Input.is_action_pressed(get_parent().get_node(name).get_left())
	var right = Input.is_action_pressed(get_parent().get_node(name).get_right())
	var support_on_floor = is_on_floor()
	
	# direction
	if left and !right:
		vel.x = -MAX_SPEED
		move_with = false
	elif right and !left:
		vel.x = MAX_SPEED
		move_with = false
	elif move_with and !support_on_floor:
		vel.x = get_parent().get_node(theOtherName).vel.x
	else :
		vel.x = 0
		
	var jump = Input.is_action_pressed(get_parent().get_node(name).get_jump())
	
	if carried and !get_parent().get_node(theOtherName).is_on_floor():
		support_on_floor = false
		
	if jump and support_on_floor:
		emit_signal("wanna_jump")
		yield(get_tree().create_timer(0.1),"timeout")
		vel.y = -JUMP_HEIGH

remotesync func call_shadow():
	print_debug("call_shadow not defined")

func manage_state():
	if state == IDLE and vel.x != 0:
		change_state(TRANSLATE)
	elif state == TRANSLATE and vel.x == 0:
		change_state(IDLE)
	elif state in [IDLE,TRANSLATE] and vel.y:
		change_state(JUMP)
	elif state == JUMP and vel.y == 0:
		change_state(IDLE)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$lbl_state.text="idle"
			snap = Vector2.DOWN * 32
			if can_scale:
				$Sprite.frame = 2
			else:
				$Sprite.frame = 0
		TRANSLATE:
			$lbl_state.text="translate"
		JUMP:
			$lbl_state.text="jump"
			snap = Vector2.ZERO
			if can_scale:
				$Sprite.frame = 3
			else:
				$Sprite.frame = 1

master func travers():
	if   Input.is_action_pressed(get_parent().get_node(name).get_travers()):
		set_collision_mask_bit(5,false)
	if  Input.is_action_just_released(get_parent().get_node(name).get_travers()):
		set_collision_mask_bit(5,true)

#warning-ignore:unused_argument
master func transform(delta):
	if Input.is_action_just_pressed(get_parent().get_node(name).get_transform_down()) and is_on_floor() and (scale.y < 0.5) :
		vel.y = -200
	
	if Input.is_action_pressed(get_parent().get_node(name).get_transform_down()):
		scale.x = lerp (scale.x, scale_down_x, scale_speed)
		scale.y = lerp (scale.y, scale_down_y, scale_speed)
	
	if Input.is_action_pressed(get_parent().get_node(name).get_transform_up()):
		scale.x = lerp (scale.x, scale_up_x, scale_speed)
		scale.y = lerp (scale.y, scale_up_y, scale_speed)

func reset_pos():
	var new_pos
	vel = Vector2.ZERO
	if name == "cubi":
		new_pos = LIFELINE.checkpoint_cubi.position
		global_position.x = new_pos.x-45
	else:
		new_pos = LIFELINE.checkpoint_cuba.position
		global_position.x = new_pos.x+45
	scale = Vector2(1,1)
	global_position.y = new_pos.y-45

func setScale(body_can_scale):
	if (body_can_scale == false):
		self.scale = Vector2(1,1)
	can_scale = body_can_scale
	
func setShadow(body_can_shadow):
	can_use_shadow = body_can_shadow

func prepare_scale():
	print_debug("have to be redefinned")