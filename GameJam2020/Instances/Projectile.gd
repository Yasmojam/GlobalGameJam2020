extends Node2D

export var speed = 400

var control = false
var bullet_id

func _ready():
	print('shot')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if control:
		position.y -= speed * delta
		rpc_unreliable("move_projectile", bullet_id, position)

remote func move_projectile(id, pos):
	if id == bullet_id:
		position = pos
