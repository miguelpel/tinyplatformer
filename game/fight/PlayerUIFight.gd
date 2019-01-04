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

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Call_pressed():
	emit_signal("call")
	pass # replace with function body

func _on_Raise_pressed():
	emit_signal("raise")
	pass # replace with function body

func _on_Fold_pressed():
	emit_signal("fold")
	pass # replace with function body
