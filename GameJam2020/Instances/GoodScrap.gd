extends KinematicBody2D

export var speed = 128
export var grav = 0.09375

var scrap_id
var control = false
var manager

var velocity = Vector2(0, 0)


func _ready():
	print('spawned ' + str(scrap_id))

func _physics_process(delta):
	if control:
		if (is_on_floor()):
			velocity.y = 0
		velocity.y += grav
		
		move_and_slide(velocity*speed, Vector2(0, -1), true)

func _process(delta):
	if control:
		manager.send_updated_good_scrap_position(scrap_id, position)
