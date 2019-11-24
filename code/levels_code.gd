extends Node2D

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
	NETWORK.actual_scene = get_path()
	get_node("Players").position = $initial.position
	LIFELINE.set_checkpoint_cuba($initial)
	LIFELINE.set_checkpoint_cubi($initial)
	spawn_items()
	
	var new_player = null
	if is_network_master():
		new_player = get_node("Players").get_node("cubi")
	else : 
		new_player = get_node("Players").get_node("cuba")

	new_player.network_id = get_tree().get_network_unique_id()
	new_player.set_network_master(get_tree().get_network_unique_id())
	
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