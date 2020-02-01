extends Node2D

export var speed = 400
export var MAX_LIFE = 3  # seconds

var time_alive = 0

var control = false
var bullet_id

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_alive += delta
	if time_alive > MAX_LIFE:
		rpc("delete", bullet_id)
		delete(bullet_id)
	
	if control:  # shot by current player
		position.y -= speed * delta
		rpc_unreliable("move_projectile", bullet_id, position)
		
		# TODO: check for collision


remote func delete(id):
	if id == bullet_id:
		queue_free()


remote func move_projectile(id, pos):
	if id == bullet_id:
		position = pos
