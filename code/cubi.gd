extends "res://code/tuto/playersScript.gd"

var max_tunnel_height = -1
var max_tunnel_width = -1
var max_width = -1
var max_height = -1
var right_collision = false
var left_collision = false

func call_shadow():
	shadow.set_collision_layer_bit(11,false)
	shadow.get_node("sprite").texture = $Sprite.texture
	yield(get_tree().create_timer(0.01),"timeout")
	shadow.set_collision_layer_bit(10,true)
	shadow.scale = scale
	shadow.position = position

func _cuba_wanna_jump():
	if carried :
		vel.y = -JUMP_HEIGH

func _on_feetsDetection_body_entered(body):
	if body.name == "cuba":
		carried = true
		$carried.text = "carried"

func _on_feetsDetection_body_exited(body):
	if body.name == "cuba":
		carried = false
		$carried.text = ""

func _on_top_detection_body_entered(body):
	if (scale.y < 0.5):
		max_tunnel_height = 0.5
		max_tunnel_width = 2

func _on_top_detection_body_exited(body):
	max_tunnel_height = -1
	max_tunnel_width = -1

func _on_left_collision_body_entered(body):
	left_collision  = true
	if (self.scale.x <= 64 / ($collision.shape.extents.x*2)):
		max_width = 64 / ($collision.shape.extents.x*2)
		max_height = 1
	elif (self.scale.x <= 128 / ($collision.shape.extents.x*2)):
		max_width = 128 / ($collision.shape.extents.x*2)
		max_height = 0.5
		
func _on_left_collision_body_exited(body):
	left_collision = false
	max_width = -1

func _on_right_collision_body_entered(body):
	right_collision = true
	if (self.scale.x <= 64 / ($collision.shape.extents.x*2)):
		max_width = 64 / ($collision.shape.extents.x*2)
		max_height = 1
	elif (self.scale.x <= 128 / ($collision.shape.extents.x*2)):
		max_width = 128 / ($collision.shape.extents.x*2)
		max_height = 0.5

func _on_right_collision_body_exited(body):
	right_collision = false
	max_width = -1