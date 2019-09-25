extends Area2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	position = get_global_mouse_position()


func _on_crosshair_body_entered(body):
	$Sprite.frame = 1
	$Sprite.modulate = Color(255,0,0)


func _on_crosshair_body_exited(body):
	$Sprite.frame = 0
	$Sprite.modulate = Color(255,255,255)
