extends KinematicBody2D

const GRAVITY = 1000
const UP = Vector2(0,-1)
const ACCEL = 10

var vel = Vector2()
export(int) var max_speed = 300

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
			vel.x = min(vel.x + ACCEL, max_speed)
			$Sprite.flip_h = false
			$anim.play("walk")
		-1: # Gauche
			vel.x = max(vel.x - ACCEL, -max_speed)
			$Sprite.flip_h = true
			$anim.play("walk")
		_: # Both
			vel.x = lerp(vel.x ,0, 0.2)
			$anim.play("idle")

	var jump = Input.is_action_just_pressed("ui_up")
	if jump == true and is_on_floor():
		vel.y = -600

	if !jump and is_on_floor():
		vel.y = 100
	
	if vel.y < 0:
		$anim.play("jump_up")
	elif vel.y > 0 and vel.y != 100:
		$anim.play("jump_down")