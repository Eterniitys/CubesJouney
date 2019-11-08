extends Area2D

func init(name,pos):
	position = pos + Vector2(16,16)

func _on_deadZone_body_entered(body):
	if body.has_method("reset_pos"):
		body.reset_pos()