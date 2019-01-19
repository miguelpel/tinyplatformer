extends Control

#var testInventory = []
#const base_clothes = [
#	preload("res://game/objects/scenes/RoyalShirt/main/RoyalShirt.tscn"),
#	preload("res://game/objects/scenes/RoyalPants/main/RoyalPants.tscn"),
#	preload("res://game/objects/scenes/Undershirt/main/Undershirt.tscn"),
#	preload("res://game/objects/scenes/Slip/main/Slip.tscn")
#]

var clothes_dictionnary = {
	hat = [],
	shirt = [],
	pants = [],
	undershirt = [],
	panties = []
}

signal dress(clothName)
signal undress(clothName)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
#	for clt in base_clothes:
#		testInventory.append(clt.instance())
#	for cloth in testInventory:
#		cloth.current_owner = "player"
###		print(cloth.name)
###	print(testInventory.size())
#	add_to_inventory(testInventory)
#	$Inventory.add_meta_and_tooltip()
	pass

func add_to_inventory(objOrArray):
#	reset_clothes_dictionnary()
#	reset_inventory()
	if typeof(objOrArray) == TYPE_ARRAY:
#		print("array")
		for obj in objOrArray:
#			print(obj.name)
			clothes_dictionnary[obj.CATEGORY].append(obj.name)
			$Inventory.add_item(obj)
			pass
		pass
	elif typeof(objOrArray) == TYPE_OBJECT:
#		print(objOrArray.name)
		$Inventory.add_item(objOrArray)
		pass
	else:
		print("cant' add ", objOrArray, " to inventory")
	pass

func refresh_inventory(newInventory):
	newInventory.sort_custom(ClothesCustomSorter, "sort")
	reset_inventory_ui()
	add_to_inventory(newInventory)
	pass

class ClothesCustomSorter:
	static func sort(a, b):
		if a.VALUE > b.VALUE:
			return true
		return false

func reset_inventory_ui():
	$Inventory.clear()
	pass

func remove_from_inventory(objOrArray):
#	print("remove from inventory")
	if typeof(objOrArray) == TYPE_ARRAY:
#		print("array")
		for obj in objOrArray:
#			print(obj.name)
			clothes_dictionnary[obj.CATEGORY].erase(obj.name)
			$Inventory.remove_item(obj)
			pass
		pass
	elif typeof(objOrArray) == TYPE_OBJECT:
#		print(objOrArray.name)
		clothes_dictionnary[objOrArray.CATEGORY].erase(objOrArray)
		$Inventory.remove_item(objOrArray)
		pass
	else:
		print("cant' remove ", objOrArray, " to inventory")
	pass

#func reset_clothes_dictionnary():
#	clothes_dictionnary = {
#	hat = [],
#	shirt = [],
#	pants = [],
#	undershirt = [],
#	panties = []
#}

func reset_inventory():
	$Inventory.clear()

func get_dictionnary_verbose():
	for cat in clothes_dictionnary:
		print("cloth: ", clothes_dictionnary[cat], " category: ", cat)
	pass
	

func check_clothes_dictionnary(itemName):
	for cat in clothes_dictionnary:
		if clothes_dictionnary[cat].has(itemName):
			return cat
	return false
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	if Input.is_action_just_pressed("ui_up"):
#		add_to_inventory(testInventory[4])
#		# add a slip.
#		pass
#	if Input.is_action_just_pressed("ui_down"):
#		remove_from_inventory(testInventory[4])
#		# remove a slip
#		pass
#	if Input.is_action_just_pressed("ui_right"):
#		add_to_inventory(testInventory[3])
#		# add a Undershirt.
#		pass
#	if Input.is_action_just_pressed("ui_left"):
#		remove_from_inventory(testInventory[3])
#		# remove a Undershirt
#		pass
#	pass

func remove_from_silhouette(objRef):
	$Silhouette.remove(objRef.CATEGORY)
	pass

#func _on_Silhouette_slotFilled():
#	get_node("Inventory/ItemList").remove_item($Silhouette.itemIndex)
#	pass # replace with function body


func _on_Silhouette_dress(clothName):
#	print("on silhouette dress ", clothName)
	emit_signal("dress", clothName)
	pass # replace with function body

func _on_Inventory_undress(clothName):
	var cat = check_clothes_dictionnary(clothName)
#	print("on silhouette undress ", cat)
	emit_signal("undress", cat)
	pass # replace with function body
