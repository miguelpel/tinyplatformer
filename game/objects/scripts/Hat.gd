# Hat.gd
extends TextureRect

const CATEGORY = "hat"
signal filled
var index
#fill data with the name and texture
var objectName
#var objectData = {}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func can_drop_data(pos, data):
    return true

func get_drag_data(pos):
	print("get drag data")
	var preview = TextureRect.new()
	preview.set_anchor(-24,24)
	var name = name
	if texture != null:
		print("texture non-null")
		preview.texture = texture
		set_drag_preview(preview)
	else:
		preview.texture = null
		print("no preview")
	var data = {
		parent = self,
		texture = preview.texture,
		name = name
	}
	return data
	pass

#func can_drop_data(pos, data):
#	#print(typeof(data))
#	print(data.name)
#	return true


func drop_data(pos, data):
	texture = data.tex.texture
	index = data.index
	objectName = data.name
	emit_signal("filled")
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
#	if has_
	pass