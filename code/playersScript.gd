extends KinematicBody2D
export(String) var myName
export(String) var theOtherName

const UP = Vector2.UP
const GRAVITY = 1000
const MAX_SPEED = 300
const JUMP_HEIGH = 550
const RESET_TIMER_MAX = 2
# movement
enum {IDLE, TRANSLATE, JUMP}
var vel = Vector2()
var carried = false
signal wanna_jump
# Shadow
var shadow
export var can_use_shadow = false
#
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
#
func _ready():
	shadow = get_parent().get_node("cubx_shadow")
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
	# Shadow power
	if can_use_shadow and Input.is_action_just_pressed("shadow_"+myName):
		call_shadow()
	# Going through tiles (allowing it)
	travers()
	
	# Moves applications
	vel = move_and_slide_with_snap(vel, snap, UP)

func movements(delta):
	var left = Input.is_action_pressed("left_"+myName)
	var right = Input.is_action_pressed("right_"+myName)
	# direction
	if left and !right: vel.x = -MAX_SPEED 
	elif right and !left: vel.x = MAX_SPEED
	else: vel.x = 0
	var jump = Input.is_action_just_pressed("jump_"+myName)
	var support_on_floor = is_on_floor()
	if carried and !get_parent().get_node(theOtherName).is_on_floor():
		support_on_floor = false
	if jump and support_on_floor:
		emit_signal("wanna_jump")
		yield(get_tree().create_timer(0.02),"timeout")
		vel.y = -JUMP_HEIGH

func call_shadow():
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

func travers ():
	if Input.is_action_just_pressed("travers_"+myName):
		set_collision_mask_bit(5,false)
	if Input.is_action_just_released("travers_"+myName):
		set_collision_mask_bit(5,true)

func transform(delta):
	if Input.is_action_just_pressed("transform_down_"+myName) and is_on_floor() and (scale.y < 0.5) :
		vel.y = -200
	
	if Input.is_action_pressed("transform_down_"+myName):
		scale.x = lerp (scale.x, scale_down_x, scale_speed)
		scale.y = lerp (scale.y, scale_down_y, scale_speed)
	
	if Input.is_action_pressed("transform_up_"+myName):
		scale.x = lerp (scale.x, scale_up_x, scale_speed)
		scale.y = lerp (scale.y, scale_up_y, scale_speed)

func reset_pos():
	var new_pos
	vel = Vector2.ZERO
	if myName == "cubi":
		new_pos = LIFELINE.checkpoint_cubi.position
		global_position.x = new_pos.x-45
	else:
		new_pos = LIFELINE.checkpoint_cuba.position
		global_position.x = new_pos.x+45
	scale = Vector2(1,1)
	global_position.y = new_pos.y-45

func prepare_scale():
	pass
	
func setScale(body_can_scale):
	if (body_can_scale == false):
		self.scale = Vector2(1,1)
	can_scale = body_can_scale
	
func setShadow(body_can_shadow):
	can_use_shadow = body_can_shadow