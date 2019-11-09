extends Area2D

var textures = {
	'loseShadowCubi' : "res://img/loseShadowCubi.png",
	'loseShadowCuba' :"res://img/loseShadowCuba.png",
	"getShadowCubi" : "res://img/getShadowCubi.png",
	"getShadowCuba" : "res://img/getShadowCuba.png",
	"getScale" : "res://img/getScaleHeight.png",
	"getScaleWidth" : "res://img/getScaleWidth.png",
	"loseScaleHeigth" :"res://img/loseScaleheight.png",
	"loseScaleWidth" : "res://img/loseScaleWidth.png"
}

var _type

func init(type, pos):
	_type = type
	$Sprite.texture = load(textures[_type])
	position = pos


func _on_losePower_body_entered(body):
	var cubi = null
	var cuba = null
	if (body.name == "cuba"):
		cubi = body.get_parent().get_node("cubi")
		cuba = body
	if (body.name == "cubi"):
		cuba = body.get_parent().get_node("cuba")
		cubi = body
		
	if (_type == "getShadowCubi"):
		cubi.setShadow(true)
	if (_type == "getShadowCuba"):
		cuba.setShadow(true)
	if (_type == "loseShadowCubi"):
		cubi.setShadow(false)
	if (_type == "loseShadowCuba"):
		cuba.setShadow(false)
	if (_type == "getScale"):
		cuba.setScale(true)
	if (_type == "getScaleWidth"):
		cubi.setScale(true)
	if (_type == "loseShadow"): 
		body.setShadow(false)
	if (_type == "loseScaleHeigth"): 
		cuba.setScale(false)
	if (_type == "loseScaleWidth"): 
		cubi.setScale(false)
			
	cubi.change_state(body.IDLE)
	cuba.change_state(body.IDLE)
	
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
		Vector2(0.5,0.5),
		Vector2(0.7,0.7),
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
