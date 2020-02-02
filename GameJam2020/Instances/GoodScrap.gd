extends KinematicBody2D

export var speed = 128
export var grav = 0.09375

var velocity = Vector2(0, 0)

func _physics_process(delta):
	if (is_on_floor()):
		velocity.y = 0
	velocity.y += grav
	
	move_and_slide(velocity*speed, Vector2(0, -1), true)
