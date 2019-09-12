extends KinematicBody2D
var speed = 400
var vel

func start(pos, dir):
	position = pos
	vel = Vector2(speed*dir,0)
	if dir == 1:
		$Sprite.flip_h = false
		$CollisionShape2D.rotation_degrees = 90
	else:
		$Sprite.flip_h = true
		$CollisionShape2D.rotation_degrees = 270


func _process(delta):
	var collision = move_and_collide(vel * delta)
	if collision:
		if collision.collider.has_method("hit"):
			collision.collider.hit(25)
		queue_free()
