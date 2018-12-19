# Shirt.gd
extends TextureRect

const CATEGORY = "shirt"
signal filled
var index
#fill data with the name and texture
var objectName
#var objectData = {}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func get_drag_data(pos):
	var data = {tex = TextureRect.new(),
	name = objectName}
	# Use another colorpicker as drag preview
	data.tex.texture = texture
	#cpb.color = color
	data.tex.rect_size = Vector2(48, 48)
	set_drag_preview(data.tex.texture)
	# Return color as drag data
	return data


func can_drop_data(pos, data):
	print(typeof(data))
	print(data.name)
	return true


func drop_data(pos, data):
	texture = data.tex.texture
	index = data.index
	objectName = data.name
	emit_signal("filled")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass