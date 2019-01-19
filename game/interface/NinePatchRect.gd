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

var count = 4

signal undress(clothName)

#is it better to handle the thing without the ScrollContainer?

func _ready():
	#rect_min_size = Vector2(180, 0)
	# get viewport
	# check the appeare / disappeare vars, and act accordingly.
	pass


func add_item(itemOrData):
	# item is the object
	# check if item is in double.
	# if item is in double, add metadata count += 1
	# metdata = {name = "Crown", count = 1}
	
	var itemTexture
	var itemName
	var itemCount = 1
	
	if typeof(itemOrData) == TYPE_DICTIONARY:
		itemTexture = itemOrData.tex
		itemName = itemOrData.name
		pass
	elif typeof(itemOrData) == TYPE_OBJECT:
		itemTexture = itemOrData.create_tex_icon().get_texture()
		itemName = itemOrData.name
		pass
	
	var idx = $ItemList.get_item_count()
#	print("0: ",idx)
	# if double => get the index of the double.
	# else:
	# idx =  $ItemList.get_item_count()
	
	var metadata = {
		name = itemName,
		count = itemCount
	}
	
	if $ItemList.get_item_count() > 0:
		for index in range($ItemList.get_item_count()):
#			print("1: ", index)
#			print("2: ",$ItemList.get_item_metadata(index))
			# get_item_metadata(idx)
			var checkName = $ItemList.get_item_metadata(index).name
			if itemName.match("*" + checkName + "*"):
				# there's a double
#				print("there's a double at index : ", index)
				idx = index
				itemCount = $ItemList.get_item_metadata(index).count + 1
				metadata = {
					name = checkName,
					count = itemCount
					}
				$ItemList.set_item_metadata(idx,metadata)
				$ItemList.set_item_text(idx, checkName + " (" + String(itemCount) + ")")
				return
	
	# if double, get the current item, and add 1 to the count
	# the name to get in the data will be in the metadata.
	if itemCount > 1:
		$ItemList.add_item(itemName + " (" + String(itemCount) + ")",itemTexture,true)
	else:
		$ItemList.add_item(itemName,itemTexture,true)
	$ItemList.set_item_metadata(idx,metadata)
	

func remove_item(obj):
#	print("remove item")
	var index = -1
	
	for idx in range($ItemList.get_item_count()):
		var checkName = $ItemList.get_item_metadata(idx).name
		if obj.name == checkName:
			index = idx
			break
		pass
	
	if index < 0:
#		print("can't remove item: cant' find index")
		return false
		
	if $ItemList.get_item_metadata(index).count - 1 > 0:
		var metadata = {
			name = $ItemList.get_item_metadata(index).name,
			count = $ItemList.get_item_metadata(index).count - 1
			}
		$ItemList.set_item_metadata(index,metadata)
		var name = metadata.name
		var count = metadata.count
		if metadata.count > 1:
			$ItemList.set_item_text(index, name + " (" + String(count) + ")")
		else:
			$ItemList.set_item_text(index, name)
	# if item metadata.count > 0 item metadata.count -= 1
	else:
		$ItemList.remove_item(index)
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
