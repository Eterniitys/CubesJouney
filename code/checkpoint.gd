extends Position2D

enum {NONE,CUBI,CUBA,BOTH}
var state = NONE
var sprite_dim = Vector2(64,96)

func init(type, pos):
	position = pos + Vector2(sprite_dim.x/2,sprite_dim.y)

func _on_checkpointArea_body_entered(body):
	if body.name == "cubi":
		LIFELINE.set_checkpoint_cubi(self)
	elif body.name == "cuba":
		LIFELINE.set_checkpoint_cuba(self)

func _process(delta):
	#State control
	var cubi = false
	var cuba = false
	if self == LIFELINE.checkpoint_cuba:
		cuba = true
	if self == LIFELINE.checkpoint_cubi:
		cubi = true
	if cubi and cuba:
		state = BOTH
	else: 
		state = NONE
		if cubi: state = CUBI
		if cuba: state = CUBA
	#State machine
	match state:
		NONE:$Sprite.region_rect.position = Vector2(0 * sprite_dim.x, 0 * sprite_dim.y)
		CUBI:$Sprite.region_rect.position= Vector2(1 * sprite_dim.x, 0 * sprite_dim.y)
		CUBA:$Sprite.region_rect.position= Vector2(0 * sprite_dim.x, 1 * sprite_dim.y)
		BOTH:$Sprite.region_rect.position = Vector2(1 * sprite_dim.x, 1 * sprite_dim.y)