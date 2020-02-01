extends KinematicBody2D

export var speed = 128
export var jumpInitSpeed = 3
export var grav = 0.09375

export var SHOOT_COOLDOWN = 1
var shoot_available = true
var last_shoot_time = 0
var current_time = 0

var velocity = Vector2()

# Networking
var control = false
var player_id = 0
var bullet_ids = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if control == true:
		_handle_movement(delta)

func _process(delta):
	if control:
		current_time += delta
		_handle_actions(delta)

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
	if (position.y > 576):
		delete(player_id)
		rpc("delete", player_id)

remote func delete(id):
	if id == player_id:
		print("Player " + str(player_id) + " died")
		queue_free()


func _handle_actions(delta):
	if current_time - SHOOT_COOLDOWN > last_shoot_time:
		shoot_available = true
	
	if shoot_available && Input.is_action_just_pressed("ui_select"):
		shoot_available = false
		last_shoot_time = current_time
		var id = _next_bullet_id()
		var pos = position + Vector2(16, 0)
		shoot(pos, id,  true)
		rpc("player_shoot", pos, id)


func _next_bullet_id():
	var id = str(player_id) + "_" + str(bullet_ids)
	bullet_ids += 1
	return id


func shoot(pos, bullet_id, control):
	print(bullet_id)
	var projectile_scene = load("res://Instances/Projectile.tscn")
	var projectile = projectile_scene.instance()
	projectile.bullet_id = bullet_id
	projectile.position = pos
	projectile.control = control
	get_parent().add_child(projectile)


remote func player_shoot(pos, bullet_id):
	shoot(pos, bullet_id, false)

	
remote func move_player(pos, player_id):
	var root = get_parent()
	var player = root.get_node(str(player_id))
	player.position = pos
	
