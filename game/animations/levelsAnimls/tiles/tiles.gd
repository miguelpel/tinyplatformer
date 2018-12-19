extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var tick = 0
var tilesNbr = 13
var tiles = []
var tile = preload("res://game/animations/levelsAnimls/tiles/groundTile.tscn")
export var isRunning = true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#print(position.y)
	for tileNbr in range(tilesNbr):
		var tl = tile.instance()
		tl.position.y = 0
		tl.position.x = tileNbr * 32
		#print(tl.position)
		add_child(tl)
		#tiles.append(tl)
	pass

func _create_new_tile():
	#print("new one!")
	var tl = tile.instance()
	tl.position.y = 0
	tl.position.x = tilesNbr * 32
	tilesNbr += 1
	#print(tl.position)
	add_child(tl)
	_erase_tile()

func _erase_tile():
	var tl = get_child(0)
	remove_child(tl)
	
func _run():
	tick += 1
	if tick == 16:
		_create_new_tile()
		tick = 0
	move_local_x(-2)

func start_run():
	isRunning = true

func stop_run():
	isRunning = false

func _process(delta):
	if isRunning:
		_run()
	pass
