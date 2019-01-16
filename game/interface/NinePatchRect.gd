extends Control

#var icons = [preload("res://CrownIcon.tscn"),
#preload("res://PantiesIcon.gd"),
#preload("res://UndershirtIcon.tscn"),
#preload("res://RoyalPantsIcon.tscn"),
#preload("res://RoyalShirtIcon.tscn")]

#const
#var card = preload("res://InventoryCard.tscn")

#const max_height

var appearing = false
var disappearing = false
var disappeared = true
var appeared = false

signal undress(clothName)

#is it better to handle the thing without the ScrollContainer?

func _ready():
	#rect_min_size = Vector2(180, 0)
	# get viewport
	# check the appeare / disappeare vars, and act accordingly.
	pass


func add_item(item):
	$ItemList.add_item(item.name,item.create_tex_icon().get_texture(),true)
	#create the card
	#add the card.(animation?)
#	pass

func remove_item(itemIndex):
	$ItemList.remove_item(itemIndex)
	pass

func make_disappear():
	#out from right
	pass

func make_appear():
	#in from right
	pass

func clear():
	$ItemList.clear()
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



func _on_ItemList_undress(clothName):
	emit_signal("undress", clothName)
	pass # replace with function body
