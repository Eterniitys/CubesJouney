extends Control
#warning-ignore:return_value_discarded
func _ready():
	$Menu/CenterRow/Buttons/Play_button.grab_focus()
	for button in $Menu/CenterRow/Buttons.get_children():
		button.connect("pressed", self, "_on_button_pressed", [button.next_scene])

func _on_button_pressed(scene_to_load):
	$FadeIn.show()
	$FadeIn/AnimationPlayer.play("Fade");
	yield($FadeIn/AnimationPlayer, "animation_finished")
	get_tree().change_scene_to(scene_to_load)