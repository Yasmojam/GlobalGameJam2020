extends TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	##if (!is_connected("scrapHitGround", self, "on_scrapHitGround")):
	##	connect("scrapHitGround", self, "on_scrapHitGround")
	pass
	
func _on_scrapHitGround(scrapPos):
	var tilePos = (scrapPos + Vector2(0,16)) / 32
	set_cellv(tilePos, -1)
