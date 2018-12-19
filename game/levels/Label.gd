extends Label

var topMargin

func _ready():
	# set position above top
	topMargin = margin_top
	pass

func _process(delta):
	# if position.y > top:
		#position.y -=1
	# else:
		#fire signal to make appear the buttons
	pass


func _on_PlayButton_button_down():
	margin_top = margin_top + 1
	#position.y +=1
	pass # replace with function body


func _on_PlayButton_button_up():
	margin_top = topMargin
	pass # replace with function body
