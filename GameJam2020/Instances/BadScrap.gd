extends Node2D

export var MIN_X_SPEED = -350
export var MAX_X_SPEED = 350
export var Y_SPEED = 100
var x_speed
var y_speed

var scrap_id

func init(x, y):
	position.x = x
	position.y = y
	x_speed = range(MIN_X_SPEED,MAX_X_SPEED)[randi()%range(MIN_X_SPEED,MAX_X_SPEED).size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += x_speed * delta
	if position.x > get_parent().MAX_X || position.x < get_parent().MIN_X:
		x_speed = -x_speed
	
	position.y += Y_SPEED * delta
	rpc_unreliable("move_scrap", scrap_id, position)

	# TODO: check for collision

remote func delete(id):
	if id == scrap_id:
		print("deleting " + str(scrap_id))
		queue_free()

remote func move_scrap(id, pos):
	if id == scrap_id:
		position = pos