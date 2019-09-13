extends Timer

#func _ready():
#	get_parent().can_shoot = true

func _on_shoot_delay_timeout():
	get_parent().can_shoot = true