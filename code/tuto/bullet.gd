extends KinematicBody2D
var speed = 400
var damage = 2
var vel
var impact = preload("res://scene/impact.tscn")

func start(pos, dir):
	rotation = dir
	position = pos
	vel = Vector2(speed,0).rotated(rotation)


func _process(delta):
	var collision = move_and_collide(vel * delta)
	if collision:
		var i = impact.instance()
		get_parent().add_child(i)
		i.start(collision.position)
		if collision.collider.has_method("hit"):
			collision.collider.hit(damage)
		queue_free()
