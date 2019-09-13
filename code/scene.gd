extends Node2D

func _ready():
	camera_set_limit()

func camera_set_limit():
	var zone = $TileMap.get_used_rect()
	var cell_size = $TileMap.cell_size
	print(zone, " ", cell_size)
	
	$player/cam.limit_top = zone.position.y * cell_size.y
	$player/cam.limit_left = zone.position.x * cell_size.x
	$player/cam.limit_bottom =  (zone.position.y + zone.size.y) * cell_size.y
	$player/cam.limit_right = (zone.position.x + zone.size.x) * cell_size.x
	