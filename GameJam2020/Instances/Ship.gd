extends Area2D

var health = 0

var spaceship1 = preload("res://Textures/world/spaceship/Spaceship1.png")
var spaceship2 = preload("res://Textures/world/spaceship/Spaceship2.png")
var spaceship3 = preload("res://Textures/world/spaceship/Spaceship3.png")
var spaceship4 = preload("res://Textures/world/spaceship/Spaceship4.png")

export var SCRAP_NEEDED_TO_UPGRADE = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update_ship_health():
	if (health == SCRAP_NEEDED_TO_UPGRADE):
		get_child(0).set_texture(spaceship4)
	if (health == SCRAP_NEEDED_TO_UPGRADE * 2):
		get_child(0).set_texture(spaceship3)
	if (health == SCRAP_NEEDED_TO_UPGRADE * 3):
		get_child(0).set_texture(spaceship2)
	if (health == SCRAP_NEEDED_TO_UPGRADE * 4):
		get_child(0).set_texture(spaceship1)



func _on_Ship_body_entered(body):
	if ("Player" in body.get_filename()):
		if (body.get_inventory_size() > 0):
			body.drop_inventory()
			health += 1
			rpc("increment_health", 1)
		update_ship_health()


remote func increment_health(amount):
	health += amount
	update_ship_health()



