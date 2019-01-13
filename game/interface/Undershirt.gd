#Hat
extends Control

const CATEGORY = "undershirt"
var cloth_name = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#print(name)
	pass

func get_drag_data(pos):
	print("get drag data")
	var preview = TextureRect.new()
	preview.set_anchor(-24,24)
	var name = cloth_name
	if $TextureRect.texture != null:
		print("texture non-null")
		preview.texture = $TextureRect.texture
		set_drag_preview(preview)
	else:
		preview.texture = null
		print("no preview")
	var data = {
		parent = self,
		tex = preview.texture,
		name = name
	}
	return data
	pass

#func can_drop_data(pos, data):
##	print(data)
#	var cat = get_parent().get_parent().check_clothes_dictionnary(data.name)
#	if data.parent.name == "ItemList" and $TextureRect.texture == null and cat == CATEGORY:
#		print("okay")
#		return true
#	return false
#	pass
#
#func drop_data(pos, data):
#	print("drop item ", data)
#	$TextureRect.texture = data.tex.texture
#	cloth_name = data.name
#	data.parent.remove_item(data.index)
##	get_parent().get_parent().get_node("Inventory").remove_item(data.index)
##	data.parent.get_node("TextureRect").texture = null
#	print('successful but can you see the dropped item?')

func remove_item():
	print(name, " remove item")
	$TextureRect.texture = null
	cloth_name = null
	pass

#func handle_drop_data(data):
##	var view = TextureRect.new()
##	view.texture = data.texture
#	$TextureRect.texture = data.texture
#	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

## ThisControl.gd
#extends Control
#func _ready():
#    set_drag_forwarding(target_control)
#
## TargetControl.gd
#extends Control
#func can_drop_data_fw(position, data, from_control):
#    return true
#
#func drop_data_fw(position, data, from_control):
#    my_handle_data(data)
#
#func get_drag_data_fw(position, from_control):
#    set_drag_preview(my_preview)
#    return my_data()