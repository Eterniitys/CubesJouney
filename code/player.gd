extends KinematicBody2D

const GRAVITY = 1000
const UP = Vector2(0,-1)
const ACCEL = 10

# Moves
var vel = Vector2()
export(int) var max_speed = 300

# Weapons
var bullet = preload("res://scene/bullet.tscn")
var dir_bullet = 1
var can_shoot = true

func _ready():
	pass

func _process(delta):
	pass

func _physics_process(delta):
	animation_loop()
	movement_loop()
	vel.y += GRAVITY * delta

	vel = move_and_slide(vel, UP) # UP indique la direction du plafond

func movement_loop():
	
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var shoot = Input.is_action_pressed("shoot")
	var dirx = int(right) - int(left)
	match dirx: # switch
		1: # Droite
			dir_bullet = 1
			vel.x = min(vel.x + ACCEL, max_speed)
			$Sprite.flip_h = false
			$muzzle.position.x = 20
		-1: # Gauche
			dir_bullet = -1
			vel.x = max(vel.x - ACCEL, -max_speed)
			$Sprite.flip_h = true
			$muzzle.position.x = -20
		_: # Both / Nothing
			vel.x = lerp(vel.x ,0, 0.2)

	var jump = Input.is_action_just_pressed("ui_up")
	if jump == true and is_on_floor():
		vel.y = -600

	if shoot and can_shoot:
		can_shoot = false
		get_node("shoot_delay").start()
		$anim.play("shoot")
		var b = bullet.instance()
		b.start($muzzle.global_position, dir_bullet)
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