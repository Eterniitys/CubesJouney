extends "res://code/playersScript.gd"

func prepare_scale():
	scale_up_x = 1/float(3)
	scale_up_y = 3
	scale_down_x = 1
	scale_down_y = 1

func call_shadow():
	shadow.set_collision_layer_bit(10,false)
	shadow.get_node("sprite").texture = $Sprite.texture
	yield(get_tree().create_timer(0.01),"timeout")
	shadow.set_collision_layer_bit(11,true)
	shadow.scale = scale
	shadow.position = position

func _cubi_wanna_jump():
	if carried :
		vel.y = -JUMP_HEIGH

func _on_feetsDetection_body_entered(body):
	if body.name == "cubi":
		carried = true
		$carried.text = "carried"

func _on_feetsDetection_body_exited(body):
	if body.name == "cubi":
		carried = false
		$carried.text = ""
		
func _on_top_detection_body_entered(body):
	var actual_dim_y = 2 * $collision.shape.extents.y * scale.y
	if actual_dim_y > 160:
		scale_up_y = 3
	elif actual_dim_y > 128:
		scale_up_y = 159/(2 * $collision.shape.extents.y)
	elif actual_dim_y > 96:
		scale_up_y = 127/(2 * $collision.shape.extents.y)
	elif actual_dim_y > 64:
		scale_up_y = 95/(2 * $collision.shape.extents.y)
	else:
		scale_up_y = 63/(2 * $collision.shape.extents.y)
	scale_up_x = scale.x

func _on_top_detection_body_exited(body):
	scale_up_y = 3
	scale_up_x = 1/float(3)

func side_collision_synthetize():
	var actual_dim_x = 2 * $collision.shape.extents.x * scale.x
	if !(0 in side_collide) and actual_dim_x < 32:
		scale_down_x = 31/(2 * $collision.shape.extents.y)
		scale_down_y = scale.y
	else:
		scale_down_x = 1
		scale_down_y = 1

func _on_left_collision_body_entered(body):
	side_collide[0] += 1
	side_collision_synthetize()

func _on_right_collision_body_entered(body):
	side_collide[1] += 1
	side_collision_synthetize()

func _on_left_collision_body_exited(body):
	side_collide[0] -= 1
	side_collision_synthetize()

func _on_right_collision_body_exited(body):
	side_collide[1] -= 1
	side_collision_synthetize()