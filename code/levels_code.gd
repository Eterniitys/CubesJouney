extends Node2D

func _ready():
	get_node("Players").position = $initial.position
	LIFELINE.set_checkpoint_cuba($initial)
	LIFELINE.set_checkpoint_cubi($initial)