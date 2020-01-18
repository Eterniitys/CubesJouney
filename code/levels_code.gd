extends Node2D

var paused = false
		
onready var items = {
	"checkpoint" : preload("res://scene/prefab/checkpoint.tscn"),
	"death_zone": preload("res://scene/prefab/deadZone.tscn"),
	"loseShadowCubi": preload("res://scene/prefab/losePower.tscn"),
	"loseShadowCuba": preload("res://scene/prefab/losePower.tscn"),
	"loseScaleHeigth": preload("res://scene/prefab/losePower.tscn"),
	"loseScaleWidth": preload("res://scene/prefab/losePower.tscn"),
	"getShadowCubi": preload("res://scene/prefab/losePower.tscn"),
	"getShadowCuba": preload("res://scene/prefab/losePower.tscn"),
	"getScaleHeigth": preload("res://scene/prefab/losePower.tscn"),
	"getScaleWidth": preload("res://scene/prefab/losePower.tscn")
}

func _ready():
	#add_child(menu)
	#menu.get_node("PauseScreen").visible = false
	NETWORK.actual_scene = get_path()
	get_node("Players").position = $initial.position
	LIFELINE.set_checkpoint_cuba($initial)
	LIFELINE.set_checkpoint_cubi($initial)
	spawn_items()
	if NETWORK.play_on_network:
		for peer_id in NETWORK.players:
			var player = get_node("Players").get_node(NETWORK.players[peer_id].name)
			player.set_network_master(NETWORK.players[peer_id].network_id)
			player.network_id = NETWORK.players[peer_id].network_id

func spawn_items():
	var tm = $TileMaps/item_tiles
	for cell in tm.get_used_cells():
		var id = tm.get_cellv(cell)
		var name = tm.tile_set.tile_get_name(id)
		if name in items.keys():
			var pos = tm.map_to_world(cell)
			pos = pos + tm.position
			var i = items[name].instance()
			i.init(name, pos)
			add_child(i)
	tm.visible = false
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		var menu = load("res://scene/Menu_screen/PauseSceen.tscn").instance()
		add_child(menu)
	
	
	