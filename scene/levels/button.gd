extends Area2D


func _ready():
	pass


func _on_Area2D_body_entered(body):	

	if (get_parent().etat == get_parent().ISDOWN):
		get_parent().etat = get_parent().UP
		get_parent().move()
		