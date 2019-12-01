extends "res://code/playersScript.gd"
#warning-ignore-all:unused_argument


func get_left():
	if NETWORK.play_on_network:
		return "left"
	else:
		return "left_cuba"
func get_right():
	if NETWORK.play_on_network:
		return "right"
	else:
		return "right_cuba"
func get_jump():
	if NETWORK.play_on_network:
		return "jump"
	else:
		return "jump_cuba"
func get_travers():
	if NETWORK.play_on_network:
		return "travers"
	else:
		return "travers_cuba"
func get_shadow():
	if NETWORK.play_on_network:
		return "shadow"
	else:
		return "shadow_cuba"
func get_transform_up():
	if NETWORK.play_on_network:
		return "transform_up"
	else:
		return "transform_up_cuba"
func get_transform_down():
	if NETWORK.play_on_network:
		return "transform_down"
	else:
		return "transform_down_cuba"

func prepare_scale():
	scale_up_x = 1/float(3)
	scale_up_y = 3
	scale_down_x = 1
	scale_down_y = 1

remotesync func call_shadow():
	print(name)
	shadow.set_collision_layer_bit(10,false)
	shadow.get_node("sprite").texture = $Sprite.texture
	yield(get_tree().create_timer(0.01),"timeout")
	shadow.set_collision_layer_bit(11,true)
	shadow.scale = scale
	shadow.position = position

remote func _cubi_wanna_jump():
	if NETWORK.play_on_network && !is_network_master():
		rpc("_cubi_wanna_jump")
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