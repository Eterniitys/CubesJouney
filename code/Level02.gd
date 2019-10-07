extends Node2D

export (String, FILE, "*.tscn") var next_right
export (String, FILE, "*.tscn") var next_left
var cubiPresent = false
var cubaPresent = false

func _ready():
	get_node("Players").position = get_node("left_position").position