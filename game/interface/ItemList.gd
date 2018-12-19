extends ItemList

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var itemSelected

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func get_drag_data(pos):
	var data = {tex = TextureRect.new(),
	name = get_item_text(itemSelected),
	index = itemSelected}
	# Use another colorpicker as drag preview
	data.tex.texture = get_item_icon(itemSelected)
	#cpb.color = color
	data.tex.rect_size = Vector2(48, 48)
	set_drag_preview(data.tex)
	# Return color as drag data
	return data

func can_drop_data(pos, data):
	print("can drop data")
	print("from ItemList")
	print(data.name)
	return true
	#return typeof(data) == TYPE_TEXTURERECT


func drop_data(pos, data):
	print("from ItemList drop_data")
	print(data)
	var tex = TextureRect.new()
	tex.texture = data.tex.texture
	var objectName = data.name
#	emit_signal("filled")
	add_item(objectName, data.tex.texture)
	pass

func _process(delta):
	pass


func _on_ItemList_item_selected(index):
	itemSelected = index
	pass # replace with function body
