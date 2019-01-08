extends CenterContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal call
signal raise
signal fold

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func disable():
	for button in $VBoxContainer.get_children():
		button.disabled = true
#		print(button.get_node("Label").custom_colors.font_color)
		button.get_node("Label").add_color_override("font_color", Color(0.7,0.7,0.7))
	pass

func able():
	for button in $VBoxContainer.get_children():
		button.disabled = false
		button.get_node("Label").add_color_override("font_color", Color(1,1,1))
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func _on_Call_pressed():
	emit_signal("call")
	pass # replace with function body

func _on_Raise_pressed():
	emit_signal("raise")
	pass # replace with function body

func _on_Fold_pressed():
	emit_signal("fold")
	pass # replace with function body
