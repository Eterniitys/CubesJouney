extends KinematicBody2D
export(String) var myName
export(String) var theOtherName

const UP = Vector2.UP
const GRAVITY = 1000
const MAX_SPEED = 300
const JUMP_HEIGH = 550
# movement
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
	get_parent().get_node(theOtherName).connect("wanna_jump", self, "_"+theOtherName+"_wanna_jump")
	change_state(IDLE)

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
			$Sprite.frame = 2
		TRANSLATE:
			$lbl_state.text="translate"
		JUMP:
			$lbl_state.text="jump"
			snap = Vector2.ZERO
			$Sprite.frame = 3
	#print("idle" if state == IDLE else ("translate" if state == TRANSLATE else "jump")," -> ",snap, " velocity ->",vel)

func travers ():
	if Input.is_action_just_pressed("travers_cuba"):
		set_collision_mask_bit(5,false)
	if Input.is_action_just_released("travers_cuba"):
		set_collision_mask_bit(5,true)

func transform(delta):
	if Input.is_action_just_pressed("transform_down_cuba") and is_on_floor() and (scale.y < 0.5) :
		vel.y = -200
	
	if Input.is_action_pressed("transform_down_cuba"):
		scale.x = lerp (scale.x, scale_min_x, scale_speed)
		scale.y = lerp (scale.y, scale_min_y, scale_speed)
	
	if Input.is_action_pressed("transform_up_cuba"):
		scale.x = lerp (scale.x, scale_min_x + delta_scale_x, scale_speed)
		scale.y = lerp (scale.y, scale_min_y + delta_scale_y, scale_speed)
