extends TextureRect

signal slotFilled
var itemIndex

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Panties_filled():
	print($Panties.index)
	itemIndex = $Panties.index
	emit_signal("slotFilled")
	pass # replace with function body


func _on_Undershirt_filled():
	print($Undershirt.index)
	itemIndex = $Undershirt.index
	emit_signal("slotFilled")
	pass # replace with function body


func _on_Pants_filled():
	print($Pants.index)
	itemIndex = $Pants.index
	emit_signal("slotFilled")
	pass # replace with function body


func _on_Shirt_filled():
	print($Shirt.index)
	itemIndex = $Shirt.index
	emit_signal("slotFilled")
	pass # replace with function body


func _on_Hat_filled():
	print($Hat.index)
	itemIndex = $Hat.index
	emit_signal("slotFilled")
	pass # replace with function body
