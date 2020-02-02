extends Node

export var MIN_X = 0
export var MAX_X = 1000
export var Y = 0

var time = 0

var manager_id = randi()
var scrap_ids = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time > 1.5:
		time = 0
		var x = range(MIN_X,MAX_X)[randi()%range(MIN_X,MAX_X).size()]
		var id = _next_scrap_id()
		new_scrap(x, id, true)
		rpc("scrap_spawned", x, id)
		
	time += delta


func new_scrap(x, id, control):
	var bad_scrap = load("res://Instances//BadScrap.tscn").instance()
	bad_scrap.init(x, Y)
	bad_scrap.scrap_id = id
	bad_scrap.control = control
	add_child(bad_scrap)

func _next_scrap_id():
	var scrap_id = str(manager_id) + "_" + str(scrap_ids)
	scrap_ids += 1
	return scrap_id

remote func scrap_spawned(x, id):
	new_scrap(x, id, false)	
