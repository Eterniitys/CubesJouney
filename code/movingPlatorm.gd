extends Node2D

export(int) var duration = 5
onready var aiming_pos = $pos_1.position

export var transition = 1
export var t_ease = 1

enum{ISUP,ISDOWN,UP,DOWN}
var etat = ISDOWN

func _ready():
	pass 

func move():
	$platform_t/Tween.interpolate_property(
	self.get_node("platform_t"),
	"position",
	get_node("platform_t").position,
	get_node("platform_t").position + aiming_pos,
	duration,
	transition,
	t_ease
	)
	$platform_t/Tween.start()

func _on_Tween_tween_completed(object, key):
		
	if (etat in [UP,DOWN]):
		aiming_pos *= -1
		match etat:
			UP : 
				etat = DOWN 
				move()
			DOWN : 
				etat = ISDOWN

func _on_button_body_entered(body):
	$button/Sprite.frame = 1
	if (etat == ISDOWN):
		etat = UP
		move()


func _on_button_body_exited(body):
	$button/Sprite.frame = 0
