extends Control
#
#signal slotFilled
var itemIndex

const clothe_scene = preload("res://game/interface/SilhouetteCloth.tscn")

signal dress(clothName)
signal undress(clothName)

const cat_rect = {
	hat = null,
	shirt = null,
	pants = null,
	undershirt = null,
	panties = null
}

const positions = {
	hat = null,
	shirt = null,
	pants = null,
	undershirt = null,
	panties = null
}

func _ready():
	positions["hat"] = Vector2(88, 30)
	positions["shirt"] = Vector2(88, 89)
	positions["pants"] = Vector2(88, 148)
	positions["undershirt"] = Vector2(25, 59)
	positions["panties"] = Vector2(25, 118)
#	cat_rect["hat"] = $Hat
#	cat_rect["shirt"] = $Shirt
#	cat_rect["pants"] = $Pants
#	cat_rect["undershirt"] = $Undershirt
#	cat_rect["panties"] = $Panties
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func can_drop_data(pos, data):
	var cat = get_parent().check_clothes_dictionnary(data.name)
	if data.parent.name == "ItemList" and cat_rect[cat] == null:
#		print("okay")
		return true
	return false
	pass

func drop_data(pos, data):
#	print("drop item to Silhouette")
	var cat = get_parent().check_clothes_dictionnary(data.name)
	cat_rect[cat] = clothe_scene.instance()
	cat_rect[cat].rect_position = positions[cat]
	cat_rect[cat].cloth_name = data.name
	cat_rect[cat].category = cat
#	cat_rect[cat] = data.name
	cat_rect[cat].get_node("TextureRect").texture = data.tex.texture
	add_child(cat_rect[cat])
	data.parent.remove_item(data.index)
	emit_signal("dress", data.name)
#	print('successful but can you see the dropped item?')

func remove_from_inventory(obj):
#	print("remove ", obj.name)
	var cat = obj.category
#	print(cat)
	emit_signal("undress", obj.cloth_name)
	remove_child(obj)
	obj.queue_free()
	cat_rect[cat] = null
#	print(cat_rect[cat])
	pass

func remove(category):
	var obj = cat_rect[category]
	remove_child(obj)
	obj.queue_free()
	cat_rect[category] = null
#func _on_Panties_filled():
#	print($Panties.index)
#	itemIndex = $Panties.index
#	emit_signal("slotFilled")
#	pass # replace with function body
#
#
#func _on_Undershirt_filled():
#	print($Undershirt.index)
#	itemIndex = $Undershirt.index
#	emit_signal("slotFilled")
#	pass # replace with function body
#
#
#func _on_Pants_filled():
#	print($Pants.index)
#	itemIndex = $Pants.index
#	emit_signal("slotFilled")
#	pass # replace with function body
#
#
#func _on_Shirt_filled():
#	print($Shirt.index)
#	itemIndex = $Shirt.index
#	emit_signal("slotFilled")
#	pass # replace with function body
#
#
#func _on_Hat_filled():
#	print($Hat.index)
#	itemIndex = $Hat.index
#	emit_signal("slotFilled")
#	pass # replace with function body
