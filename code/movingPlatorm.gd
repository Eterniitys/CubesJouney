extends Node2D

export(int) var duration = 10
onready var aiming_pos = $pos_1.position

export var transition = 1
export var t_ease = 1

func _ready():
	move()

func move():
	$platform_t/Tween.interpolate_property(
	self,
	"position",
	position,
	position + aiming_pos,
	duration,
	transition,
	t_ease
	)
	$platform_t/Tween.start()

func _on_Tween_tween_completed(object, key):
	aiming_pos *= -1
	move()
