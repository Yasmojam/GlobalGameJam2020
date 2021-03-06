extends Node

export var MIN_X = 0
export var MAX_X = 1000
export var Y = 0

var time = 0

var manager_id
var scrap_ids = 0

var bad_scrap_scene = load("res://Instances/BadScrap.tscn")
var good_scrap_scene = load("res://Instances/GoodScrap.tscn")
onready var ground = get_node("/root/World/GroundTileMap")


func _ready():
	manager_id = get_tree().get_network_unique_id()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time > 2:
		time = 0
		var x = range(MIN_X,MAX_X)[randi()%range(MIN_X,MAX_X).size()]
		var id = _next_scrap_id()
		new_scrap(x, Y, id, true)
		
	time += delta


func new_scrap(x, y, id, control):
	var bad_scrap = bad_scrap_scene.instance()
	bad_scrap.init(x, y, ground)
	bad_scrap.scrap_id = id
	bad_scrap.set_name(id)
	bad_scrap.control = control
	bad_scrap.manager = self
	add_child(bad_scrap)
	print('new scrap ' + id)

func _next_scrap_id():
	var scrap_id = str(manager_id) + "_" + str(scrap_ids)
	scrap_ids += 1
	return scrap_id

	
func send_updated_scrap_position(id, pos):
	rpc_unreliable("move_scrap", id, pos)

remote func move_scrap(id, pos):
	var child = get_node_or_null(id)
	if child:
		child.position = pos
	else:
		new_scrap(pos.x, pos.y, id, false)


# GOOD SCRAP ----------------------------


func new_good_scrap(pos, id, control):
	if not "GoodScrap" in id:
		id = "GoodScrap " + id
	
	var good_scrap = good_scrap_scene.instance()
	good_scrap.control = control
	good_scrap.scrap_id = id
	good_scrap.position = Vector2(pos.x, pos.y)
	good_scrap.manager = self
	good_scrap.set_name(id)
	add_child(good_scrap)


func send_updated_good_scrap_position(id, pos):
	rpc_unreliable("move_good_scrap", id, pos)


remote func move_good_scrap(id, pos):
	var child = get_node_or_null(id)
	if child:
		child.position = pos
	else:
		new_good_scrap(pos, id, false)
