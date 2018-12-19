extends Control

var icons = [preload("res://CrownIcon.tscn"),
preload("res://PantiesIcon.gd"),
preload("res://UndershirtIcon.tscn"),
preload("res://RoyalPantsIcon.tscn"),
preload("res://RoyalShirtIcon.tscn")]

#const
var card = preload("res://InventoryCard.tscn")

#const max_height

var appearing = false
var disappearing = false
var disappeared = true
var appeared = false

#is it better to handle the thing without the ScrollContainer?

func _ready():
	#rect_min_size = Vector2(180, 0)
	# get viewport
	# check the appeare / disappeare vars, and act accordingly.
	pass

func add_item(icon):
	#create the card
	#add the card.(animation?)
	pass

func remove_item(item):
	pass

func make_disappear():
	#out from right
	pass

func make_appear():
	#in from right
	pass

func can_drop_data(pos, data):
	print("can drop data")
	print("from Inventory")
	print(data.name)
	return true
	#return typeof(data) == TYPE_TEXTURERECT


func drop_data(pos, data):
	print("from Inventory")
	print(data)
	#add_item(data.name, data.tex.texture)
	pass

func _process(delta):
	#print(get_focus_owner())
	if has_focus():
		get_node("ItemList").grab_focus()
	if disappearing:
		#if x < screen wide:
			#x += 1 * delta
		#else:
			#disappearing = false
			#disappeared = true
		pass
	elif appearing:
		#if x < ???? position.x + width
			#height += 1 * delta
		#else:
			#appearing = false
			#appeared = true
		pass
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

