extends Node2D

func _ready():
	get_node("Players").position = $initial.position
