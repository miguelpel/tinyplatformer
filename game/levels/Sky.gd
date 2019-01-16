extends ColorRect

signal received_cloth(clothName)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func can_drop_data(pos, data):
#	print("can drop data")
#	print("from ItemList")
#	print(data.name)
	if data.parent.get_parent().name == "Silhouette" and get_parent().get_node("Fight").state == "waiting for opponent action" and get_parent().get_node("Fight").opponent == get_parent().get_node("Fight").player:
		return true
	else:
		return false

func drop_data(pos, data):
#	print("from ItemList drop_data")
#	print(data)
#	var tex = TextureRect.new()
#	tex.texture = data.tex.texture
	var objectName = data.name
#	emit_signal("filled")
	emit_signal("received_cloth", data.name)
	data.parent.remove_item()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
