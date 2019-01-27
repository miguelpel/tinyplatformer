extends Area2D

#var active = true

signal position_clicked(parent)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _input_event(viewport, event, shape_idx):
	var mouseClick = event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and event.is_pressed()
	var touchClick = event is InputEventScreenTouch \
		and event.is_pressed()
	if (mouseClick or touchClick):
#		active = false
		on_click()
		
		pass

func on_click():
	emit_signal("position_clicked", get_parent().position)
	print(get_parent().name, " clicked")
#	active = true

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
