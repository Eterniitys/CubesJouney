extends Area2D

var textures = {
	'loseShadow' : "res://img/Tuto/Coins/HP.png",
	'loseScale' : "res://img/Tuto/Coins/X10.png",
	"getShadow" : "res://img/Tuto/Coins/MP.png",
	"getScale" : "res://img/Tuto/Coins/X1.png"
}

var _type

func init(type, pos):
	_type = type
	$Sprite.texture = load(textures[_type])
	position = pos


func _on_losePower_body_entered(body):
	if (_type == "getShadow"):
		body.can_use_shadow = true
	if (_type == "getScale"): 
		body.can_scale = true
	if (_type == "loseShadow"): 
		body.can_use_shadow = false
	if (_type == "loseScale"): 
		body.can_scale = false
		
	body.change_state(body.IDLE)
	
	$CollisionShape2D.disabled = true
	$Tween.interpolate_property(
		self,
		"position",
		position,
		Vector2(position.x, position.y - 200),
		1,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT)
		
	$Tween.interpolate_property(
		self,
		"scale",
		Vector2(1,1),
		Vector2(1.5,1.5),
		1,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT)
		
	$Tween.interpolate_property(
		self,
		"modulate",
		Color(1,1,1,1),
		Color(1,1,1,0),
		0.5,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT,
		0.5)
		
		
	$Tween.start()
	yield($Tween,'tween_completed')
	queue_free()
