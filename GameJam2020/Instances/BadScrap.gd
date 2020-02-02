extends Node2D

export var MIN_X_SPEED = -350
export var MAX_X_SPEED = 350
export var Y_SPEED = 100
var x_speed
var y_speed
var manager

var control = false

var scrap_id

signal scrapHitGround

func init(x, y, ground):
	position.x = x
	position.y = y
	x_speed = range(MIN_X_SPEED,MAX_X_SPEED)[randi()%range(MIN_X_SPEED,MAX_X_SPEED).size()]
	if (!is_connected("scrapHitGround", ground, "_on_scrapHitGround")):
		connect("scrapHitGround", ground, "_on_scrapHitGround")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if control:
		position.x += x_speed * delta
		if position.x > get_parent().MAX_X || position.x < get_parent().MIN_X:
			x_speed = -x_speed
		
		position.y += Y_SPEED * delta
		manager.send_updated_scrap_position(scrap_id, position)

remote func deleteBadScrap(id):
	if id == scrap_id:
		print("deleting " + str(scrap_id))
		queue_free()

func _on_Area2D_body_entered(body):
	if (body.name == "Projectile"):
		var good_scrap_scene = load("res://Instances/GoodScrap.tscn")
		var good_scrap = good_scrap_scene.instance()
		good_scrap.position = Vector2(position.x, position.y)
		get_parent().add_child(good_scrap)
		queue_free()
	if (body.name == "GroundTileMap"):
		emit_signal("scrapHitGround", position)
	deleteBadScrap(scrap_id)
	rpc("deleteBadScrap", scrap_id)
