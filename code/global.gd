extends Node

enum {LEFT, RIGHT, UP, DOwN}

var sens = RIGHT setget set_sens

func set_sens(values):
	sens = values