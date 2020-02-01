extends KinematicBody2D

export var speed = 128
export var jumpInitSpeed = 3
export var grav = 0.09375

var velocity = Vector2()

# Networking
var control = false
var player_id = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if control == true:
		_handle_movement(delta)

func _handle_movement(delta):
	velocity.x = 0
	if (is_on_ceiling()):
		velocity.y = 0
	if (is_on_floor()):
		velocity.y = 0
	velocity.y += grav
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		$AnimatedSprite.flip_h = false
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		$AnimatedSprite.flip_h = true
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -1 * jumpInitSpeed
	if velocity.x != 0:
		$AnimatedSprite.animation = "Walking"
	else:
		$AnimatedSprite.animation = "Standing"
	$AnimatedSprite.play()
	move_and_slide(velocity*speed, Vector2(0, -1), true)
	rpc_unreliable("move_player", position, player_id)
	
remote func move_player(pos, player_id):
	var root = get_parent()
	var player = root.get_node(str(player_id))
	player.position = pos
	
