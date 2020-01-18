extends VBoxContainer

signal paused_action

func _ready():
	get_children()[1].grab_focus()
	for button in get_children():
		if button.next_scene != null :
			button.connect("pressed", get_parent().get_parent().get_parent(), "_on_button_pressed", [button.next_scene])
	

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		emit_signal("paused_action", 0) 