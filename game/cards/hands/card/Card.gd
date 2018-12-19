extends Container

var hid # "not", "mid", "hidden"
var dealt = false
var goddessHand = preload("res://game/cards/GoddessHand/GoddessHand.tscn")

func _ready():
	$Card.hide()
	$Hid.hide()
	pass

func play_GoddessHand():
	var GoddessHand = goddessHand.instance()
	GoddessHand.connect("almost_done", self, "_almost_done")
	add_child(GoddessHand)
	GoddessHand.play()
	pass

func set_card(nbr, hid="open"):
	dealt = true
	var suit = nbr/13
	var rank = nbr%13
	$Card.region_rect = Rect2(Vector2((rank*32) + 32, suit*48), Vector2(32,48))
	if hid=="hidden":
		print("hidden")
		$Hid.region_rect = Rect2(Vector2(0,0), Vector2(32,48))
		pass
	elif hid=="mid":
		print("mid")
		$Hid.region_rect = Rect2(Vector2(0,96), Vector2(32,48))
		pass
	else:
		$Hid.region_rect = Rect2(Vector2(0,144), Vector2(32,48))
		pass
	play_GoddessHand()
	pass

func _make_appear():
	$Card.show()
	$Hid.show()
	pass

func reveal():
	$Card.hide()
	$Hid.hide()
	$Hid.region_rect = Rect2(Vector2(0,144), Vector2(32,48))
	play_GoddessHand()
	pass

func change_card_to(nbr):
	dealt = true
	$Card.hide()
	$Hid.hide()
	var suit = nbr/13
	var rank = nbr%13
	$Card.region_rect = Rect2(Vector2((rank*32) + 32, suit*48), Vector2(32,48))
	play_GoddessHand()
	pass

func _almost_done():
	if dealt:
		_make_appear()
	pass # replace with function body

func erase():
	dealt = false
	$Card.hide()
	$Hid.hide()
	play_GoddessHand()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass