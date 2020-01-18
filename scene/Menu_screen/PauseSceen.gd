extends CanvasLayer

func _ready():
	get_tree().paused = true

#func _process(delta):
#	if Input.is_action_just_pressed("pause") and get_tree().paused:
#		print("pausedscreen")
#		get_node("PauseScreen").visible = false
#		get_tree().paused = false
		
#	$Menu/Content/Buttons.get_children()[1].grab_focus()
#	for button in $Menu/Content/Buttons.get_children():
#		if button.next_scene != null :
#			button.connect("pressed", self, "_on_button_pressed", [button.next_scene])

func _on_Menu_paused_action(val):
	match val:
		0: 
			get_tree().paused = false
	queue_free()

func _on_button_pressed(scene):
	get_tree().paused = false
	if typeof(scene) == TYPE_STRING :
		get_tree().change_scene(scene)
	else :
		get_tree().change_scene_to(scene)
		
func _on_QuitButton_pressed():
	get_tree().quit()
