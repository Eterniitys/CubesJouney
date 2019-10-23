extends Area2D

func _on_deadZone_body_entered(body):
	if body.has_method("reset_pos"):
		body.reset_pos()