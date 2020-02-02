extends KinematicBody2D

export var speed = 400
export var MAX_LIFE = 3  # seconds

var time_alive = 0

var control = false
var bullet_id

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_alive += delta
	
	if control:  # shot by current player
		position.y -= speed * delta
		rpc_unreliable("move_projectile", bullet_id, position)
		if time_alive > MAX_LIFE:
			rpc("deleteBullet", bullet_id)
			deleteBullet(bullet_id)
			
		if (test_move(transform, Vector2(0, 0.1))):
			rpc("deleteBullet", bullet_id)
			deleteBullet(bullet_id)


remote func deleteBullet(id):
	if id == bullet_id:
		print("deleting bullet " + str(bullet_id))
		queue_free()


remote func move_projectile(id, pos):
	if id == bullet_id:
		position = pos
