extends "res://code/tuto/playersScript.gd"


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
		$carried.text="carried" 

func _on_feetsDetection_body_exited(body):
	if body.name == "cubi":
		carried = false
		$carried.text=""