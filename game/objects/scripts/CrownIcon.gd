extends Sprite

const DESCRIPTION = "It's the crown of your Kingdom. Don't lose it!"

var mouseIn = false
var nextPosition
var placeFound = false
var offSt = Vector2(24, 24)

func _ready():
	nextPosition = position

func _process(delta):
	if mouseIn:
		if Input.is_action_just_pressed("click") :
			nextPosition = position
		if Input.is_action_pressed("click") :
			set_position(get_viewport().get_mouse_position() - offSt)
		if Input.is_action_just_released("click") :
			set_position(nextPosition)
	else:
		set_position(nextPosition)
	pass

func _on_Area2D_mouse_entered():
	print("Mouse Entered")
	mouseIn = true
	pass # replace with function body


func _on_Area2D_mouse_exited():
	print("Mouse Exited")
	mouseIn = false
	pass # replace with function body
