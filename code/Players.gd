extends Node2D

func _ready():
	pass

func _process(delta):
	
	replace_cam()

func replace_cam():
	var cuba_pos = $cuba.global_position
	var cubi_pos = $cubi.global_position

	# Horizontale
	if cubi_pos.x > cuba_pos.x:
		$cam.global_position.x = cuba_pos.x + abs(cuba_pos.x - cubi_pos.x)/2
	else:
		$cam.global_position.x = cubi_pos.x + abs(cuba_pos.x - cubi_pos.x)/2
	# Vertical
	if cubi_pos.y > cuba_pos.y:
		$cam.global_position.y = cuba_pos.y + abs(cuba_pos.y - cubi_pos.y)/2
	else:
		$cam.global_position.y = cubi_pos.y + abs(cuba_pos.y - cubi_pos.y)/2