extends Node

export var MIN_X = 0
export var MAX_X = 1000
export var Y = 0

var time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time > 1.5:
		time = 0
		var x = range(MIN_X,MAX_X)[randi()%range(MIN_X,MAX_X).size()]
		var bad_scrap = load("res://Instances//BadScrap.tscn").instance()
		bad_scrap.init(x, Y)
		add_child(bad_scrap)
		
	time += delta	
