extends Node2D
#warning-ignore-all:unused_class_variable
# Cubi&Cuba
onready var cubi = $cubi
onready var cuba = $cuba
# Cam
export(float) var ZOOM_MIN = 1
export(float) var ZOOM_MAX = 1.5
var cam_lst = []

func _ready():
	
	# set cam limit
	var ref_tilemap = get_parent().get_node("TileMaps/x64_gd_tiles")
	var used_zone = ref_tilemap.get_used_rect()
	var cell_size = ref_tilemap.cell_size
	$cam.limit_left = used_zone.position.x * cell_size.x
	$cam.limit_top = used_zone.position.y * cell_size.y
	$cam.limit_right = (used_zone.position.x + used_zone.size.x) * cell_size.x
	$cam.limit_bottom = (used_zone.position.y + used_zone.size.y)  * cell_size.y

#warning-ignore:unused_argument
func _process(delta):
	default_cam()

func default_cam():
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
	
	$cam.zoom.x = max(ZOOM_MIN,min(ZOOM_MAX,(cuba_pos.distance_to(cubi_pos)/64)/10))
	$cam.zoom.y = $cam.zoom.x
	
func grabbing_cam(new_cam):
	new_cam.make_current()
	cam_lst.append(new_cam)

func try_free_cam(cam_to_free):
	cam_lst.erase(cam_to_free)
	if cam_lst.empty():
		$cam.make_current()
	else:
		cam_lst.front().make_current()