extends KinematicBody2D

const GRAVITY = 1000
const UP = Vector2(0,-1)
const ACCEL = 10

# Moves
var vel = Vector2()
export(int) var max_speed = 300

# Weapons
var bullet = preload("res://scene/objects/bullet.tscn")
var dir_bullet = 1
var can_shoot = true

var mouse_pos = Vector2()

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	animation_loop()
	movement_loop()
	vel.y += GRAVITY * delta

	vel = move_and_slide(vel, UP) # UP indique la direction du plafond
	
	$sprite_bras.look_at(mouse_pos)

func movement_loop():
	mouse_pos = get_global_mouse_position() # Vector2
	var ligne_bullet = mouse_pos - $sprite_bras/muzzle.global_position
	var rot = ligne_bullet.angle()
	
	var right = Input.is_action_pressed("right_cubi")
	var left = Input.is_action_pressed("left_cubi")
	var shoot = Input.is_action_pressed("shoot")
	var dirx = int(right) - int(left)
	match dirx: # switch
		1: # Droite
			dir_bullet = 1
			vel.x = min(vel.x + ACCEL, max_speed)
			$Sprite.flip_h = false
			$sprite_bras.flip_v = false
			$sprite_bras.position.x = -5
			$sprite_bras.flip_v = false
		-1: # Gauche
			dir_bullet = -1
			vel.x = max(vel.x - ACCEL, -max_speed)
			$Sprite.flip_h = true
			$sprite_bras.flip_v = true
			$sprite_bras.position.x = 5
		_: # Both / Nothing
			vel.x = lerp(vel.x ,0, 0.2)

	var jump = Input.is_action_just_pressed("jump_cubi")
	if jump == true and is_on_floor():
		vel.y = -600

	if shoot and can_shoot:
		can_shoot = false
		get_node("shoot_delay").start()
		$anim.play("shoot")
		var b = bullet.instance()
		b.start($sprite_bras/muzzle.global_position, rot)
		get_parent().add_child(b)

func animation_loop():
	if $anim.current_animation != "shoot":
		if abs(vel.x) > 1:
			$anim.play("walk")
		else:
			$anim.play("idle")		
		if vel.y > 0:
			$anim.play("jump_down")
		if vel.y < 0:
			$anim.play("jump_up")