extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var alpha = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func create(txt):
#	print("card created ", txt)
#	print(position)
	z_index = 2
	$Label.text = txt
#	var offset = Vector2($Label.rect_size.x / 2, 0)
#	set_position(position)
	pass

func _process(delta):
	position.y -= 1
	alpha -= 0.02
	$Label.add_color_override("font_color", Color(1,1,1, alpha))
	if alpha <= 0:
		queue_free()
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
