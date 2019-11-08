extends Node2D

onready var itm = preload("res://scene/prefab/losePower.tscn")

onready var items = {
	"checkpoint" : preload("res://scene/prefab/checkpoint.tscn"),
	"death_zone": preload("res://scene/prefab/deadZone.tscn"),
	"lose": preload("res://scene/prefab/losePower.tscn"),
	"get": preload("res://scene/prefab/losePower.tscn")
}

func _ready():
	get_node("Players").position = $initial.position
	LIFELINE.set_checkpoint_cuba($initial)
	LIFELINE.set_checkpoint_cubi($initial)
	spawn_items()
	
	
func spawn_items():
	var tm = $TileMaps/tiles_item
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
		