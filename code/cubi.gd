extends "res://code/tuto/playersScript.gd"

var max_tunnel_height = -1
var max_tunnel_width = -1
var max_width = -1
var max_height = -1
var right_collision = false
var left_collision = false

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
	if Input.is_action_just_pressed("shadow_cubi"):
		call_shadow()
	# Going through tiles (allowing it)
	travers()
	
	# Moves applications
	vel = move_and_slide_with_snap(vel, snap, UP)


func movements(delta):
	
	var left = Input.is_action_pressed("left_cubi")
	var right = Input.is_action_pressed("right_cubi")
	# direction
	if left and !right: vel.x = -MAX_SPEED 
	elif right and !left: vel.x = MAX_SPEED
	else: vel.x = 0
	
	var jump = Input.is_action_just_pressed("jump_cubi")
	var support_on_floor = is_on_floor()
	if carried and !get_parent().get_node("cuba").is_on_floor():
		support_on_floor = false
	if jump and support_on_floor:
		emit_signal("wanna_jump")
		yield(get_tree().create_timer(0.02),"timeout")
		vel.y = -JUMP_HEIGH

func call_shadow():
	shadow.set_collision_layer_bit(11,false)
	shadow.get_node("sprite").texture = $Sprite.texture
	yield(get_tree().create_timer(0.01),"timeout")
	shadow.set_collision_layer_bit(10,true)
	shadow.scale = scale
	shadow.position = position

func transform(delta):
	if Input.is_action_just_pressed("transform_down_cubi") and is_on_floor() and (scale.y < 0.5) :
		vel.y = -200
	
	if Input.is_action_pressed("transform_up_cubi"):
		if max_tunnel_height == -1:
			scale.x = lerp (scale.x, scale_min_x, scale_speed)
			scale.y = lerp (scale.y, scale_min_y, scale_speed)
		else : 
			scale.x = lerp (scale.x, max_tunnel_width, scale_speed)
			scale.y = lerp (scale.y, max_tunnel_height, scale_speed)
			
	if Input.is_action_pressed("transform_down_cubi"):
		if max_width == -1 or !right_collision or !left_collision:
			scale.x = lerp (scale.x, scale_min_x + delta_scale_x, scale_speed)
			scale.y = lerp (scale.y, scale_min_y + delta_scale_y, scale_speed)
		else :
			scale.x = lerp (scale.x, max_width, scale_speed)
			scale.y = lerp (scale.y, max_height, scale_speed)
			
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