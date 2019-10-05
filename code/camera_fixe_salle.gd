extends Area2D

var cubiInside = false
var cubaInside = false

func _ready():
	pass	
	
func _on_CameraSalleTest_body_entered(body):
	if body.name == "cubi":
		cubiInside = true
		
	if body.name == "cuba":
		cubaInside = true
		
	if cubaInside and cubiInside:
		body.get_parent().grabbing_cam(get_node("Camera_salle"))


func _on_CameraSalleTest_body_exited(body):
	if body.name == "cubi":
		cubiInside = false
		
	if body.name == "cuba":
		cubaInside = false
		
	if !cubaInside or !cubiInside:
		body.get_parent().try_free_cam($Camera_salle)