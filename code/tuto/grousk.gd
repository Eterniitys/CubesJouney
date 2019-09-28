extends KinematicBody2D

const GRAVITY = 1000
const UP = Vector2(0,-1)
const ACCEL = 5

var vel = Vector2()
export(int) var max_speed = 500
var dirx = 0
var life = 100

func _ready():
	randomize()

func _on_time_timeout():
	var m = int(rand_range(0,8))
	if m < 2:
		dirx = -1
	elif m > 5:
		dirx = 1
	else:
		dirx = 0  
	
func _physics_process(delta):
	vel.y += GRAVITY * delta
	if $anim.current_animation != "hit":
		movement_loop()

# warning-ignore:return_value_discarded
	move_and_slide(vel, UP) # UP indique la direction du plafond

func movement_loop():

	match dirx: # switch
		1: # Droite
			vel.x = min(vel.x + ACCEL, max_speed)
			$Sprite.flip_h = false
			$anim.play("walk")
		-1: # Gauche
			vel.x = max(vel.x - ACCEL, -max_speed)
			$Sprite.flip_h = true
			$anim.play("walk")
		_: # Both / Nothing
			vel.x = lerp(vel.x ,0, 0.2)
			$anim.play("idle")


	if is_on_wall():
		dirx *= -1
		vel.x = 0

func hit(damage):
	$anim.play("hit")
	life -= damage
	if life <= 0:
		queue_free()
