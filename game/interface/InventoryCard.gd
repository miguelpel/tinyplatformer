extends TextureRect

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var FramePosition


func _ready():
	#FramePosition = position + Vector2(7, 7)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_area_entered(area):
	var icon = area.get_parent()
	print(icon)
	pass # replace with function body
