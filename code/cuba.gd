extends "res://code/tuto/playersScript.gd"

func _physics_process(delta):
	# Gravity
	if !is_on_floor():
		vel.y += GRAVITY * delta
	# Moves
	manage_state()
	movements(delta)
	# Transform
	transform(delta)
	# Shadow power
	if Input.is_action_just_pressed("shadow_cuba"):
		call_shadow()
	# Going through tiles (allowing it)
	travers()
	# Moves applications
	vel = move_and_slide_with_snap(vel, snap, UP)

func movements(delta):
	
	var left = Input.is_action_pressed("left_cuba")
	var right = Input.is_action_pressed("right_cuba")
	# direction
	if left and !right: vel.x = -MAX_SPEED 
	elif right and !left: vel.x = MAX_SPEED
	else: vel.x = 0
	
	var jump = Input.is_action_just_pressed("jump_cuba")
	var support_on_floor = is_on_floor()
	if carried and !get_parent().get_node("cubi").is_on_floor():
		support_on_floor = false
	if jump and support_on_floor:
		emit_signal("wanna_jump")
		yield(get_tree().create_timer(0.02),"timeout")
		vel.y = -JUMP_HEIGH

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