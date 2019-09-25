extends Node2D

func start(pos):
	position = pos
	$Particles2D.emitting = true

func _process(delta):
	if !$Particles2D.emitting:
		queue_free()
