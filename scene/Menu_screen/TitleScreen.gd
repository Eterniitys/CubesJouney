extends Control
#warning-ignore:return_value_discarded
func _ready():
	$Menu/Content/Buttons.get_children()[1].grab_focus()
	for button in $Menu/Content/Buttons.get_children():
		if button.next_scene != null :
			button.connect("pressed", self, "_on_button_pressed", [button.next_scene])

func _on_button_pressed(scene_to_load):
	$FadeIn.show()
	$FadeIn/AnimationPlayer.play("Fade");
	yield($FadeIn/AnimationPlayer, "animation_finished")
	get_tree().change_scene_to(scene_to_load)

func _on_QuitButton_pressed():
	get_tree().quit()
