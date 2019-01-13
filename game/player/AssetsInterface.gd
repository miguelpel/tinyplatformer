extends Control

var testInventory = []
const base_clothes = {
	hat = preload("res://game/objects/scenes/Crown/main/Crown.tscn"),
	shirt = preload("res://game/objects/scenes/RoyalShirt/main/RoyalShirt.tscn"),
	pants = preload("res://game/objects/scenes/RoyalPants/main/RoyalPants.tscn"),
	undershirt = preload("res://game/objects/scenes/Undershirt/main/Undershirt.tscn"),
	panties = preload("res://game/objects/scenes/Slip/main/Slip.tscn")
}

var clothes_dictionnary = {
	hat = [],
	shirt = [],
	pants = [],
	undershirt = [],
	panties = []
}


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	for cat in base_clothes:
		testInventory.append(base_clothes[cat].instance())
	for cloth in testInventory:
		cloth.current_owner = "player"
#		print(cloth.name)
	add_to_inventory(testInventory)
	pass

func add_to_inventory(objOrArray):
	if typeof(objOrArray) == TYPE_ARRAY:
#		print("array")
		for obj in objOrArray:
			clothes_dictionnary[obj.CATEGORY].append(obj.name)
			$Inventory.add_item(obj)
			pass
		pass
	elif typeof(objOrArray) == TYPE_OBJECT:
		$Inventory.add_item(objOrArray)
		pass
	else:
		print("cant' add ", objOrArray, " to inventory")
	pass

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
##	if Input.is_action_just_pressed("ui_down"):
###		$Silhouette.nullate_free_clothes()
##		print($Silhouette.cat_rect)
##		get_dictionnary_verbose()
#	pass

func remove(objRef):
	$Silhouette.remove(objRef.CATEGORY)
	pass

#func _on_Silhouette_slotFilled():
#	get_node("Inventory/ItemList").remove_item($Silhouette.itemIndex)
#	pass # replace with function body


func _on_Silhouette_dress(clothName):
	print("dress: ", clothName)
	pass # replace with function body


func _on_Silhouette_undress(clothName):
	print("undress: ", clothName)
	pass # replace with function body
