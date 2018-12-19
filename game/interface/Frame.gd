extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func can_drop_data(pos, data):
	print("can drop data")
	print("from frame")
	print(data.name)
	return true
	#return typeof(data) == TYPE_TEXTURERECT


func drop_data(pos, data):
	print("from frame")
	print(data)
	#add_item(data.name, data.tex.texture)
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	pass
