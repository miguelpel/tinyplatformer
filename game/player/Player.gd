# Player
extends Node

const base_clothes = [
	preload("res://game/objects/scenes/Crown/main/Crown.tscn"),
	preload("res://game/objects/scenes/RoyalShirt/main/RoyalShirt.tscn"),
	preload("res://game/objects/scenes/RoyalPants/main/RoyalPants.tscn"),
	preload("res://game/objects/scenes/Undershirt/main/Undershirt.tscn"),
	preload("res://game/objects/scenes/Slip/main/Slip.tscn")
]

const AssetsUI = preload("res://game/player/AssetsInterface.tscn") # rect_position.y
const fightUI = preload("res://game/fight/PlayerUiFight.tscn")

var PlayerUIFight
var PlayerAssetsUI

var inventory = []
var current_level
var Character
#var fight

var timer

# only if ALL actions are done. Allow to throw 2 clothes one after the other (raise)


# $Character API
# $Character.remove_and_throw(objRef) => returns objectRef
# $Character.dress(objRef or objRefArray)
# $Character.remove(objRef) => without animation
# $Character.run()
# $Character.set_direction("left" or "right")
# $Character.stand()

# Pot API???

func _ready():
#	if current_level:
#		fight = current_level.current_fight
	Character = $Character
	Character.set_owner(self)
	# get saved inventory()
	# if inventory is set (there was a save):
		# instanciate inventory???
	# else:
		#instanciate_base_clothes()
	instanciate_base_clothes()
#	_instanciate_base_clothes() # DOUBLE
#	_dress_character() # DOUBLE
	Character.set_direction("right")

func instanciate_base_clothes():
	for cloth in base_clothes:
		inventory.append(cloth.instance())
	for clothInstance in inventory:
		clothInstance.current_owner = self
	pass

func remove_from_inventory(cloth):
	inventory.erase(cloth)
	PlayerAssetsUI.refresh_inventory(inventory)
	pass

func pick_from_inventory(clothName):
	for cloth in inventory:
		if cloth.name == clothName:
#			inventory.erase(cloth)
			return cloth
	pass

func add_to_inventory(cloth):
	# check for double
	inventory.append(cloth)
	cloth.current_owner = self
	PlayerAssetsUI.refresh_inventory(inventory)
#	actualize_inventory_UI()
	pass

func cheat():
	for cloth in base_clothes:
		var inst = cloth.instance()
		inventory.append(inst)
		inst.current_owner = self
		PlayerAssetsUI.refresh_inventory(inventory)
	pass

#func actualize_inventory_UI():
#	PlayerAssetsUI.
#	PlayerAssetsUI.add_to_inventory(inventory)
#	pass

func remove_from_silhouette(cloth):
	PlayerAssetsUI.get_node("Silhouette").remove(cloth.CATEGORY)
	pass

func get_inventory_verbose():
	var inv = []
	for cloth in inventory:
		inv.append(cloth.name)
	print("Player inventory: ", inv)
	pass

func is_naked():
	return Character.is_naked()
	pass

func spawn_character(level):
	current_level = level
	var world = level.get_node("World")
	$Character.position = Vector2(64, 64)
	$Character.show()
	# raise error in debusgger
	# world.add_child($Character)
	PlayerUIFight = fightUI.instance()
	PlayerUIFight.connect("call", self, "_on_PlayerUIFight_call")
	PlayerUIFight.connect("fold", self, "_on_PlayerUIFight_fold")
	PlayerUIFight.connect("raise", self, "_on_PlayerUIFight_raise")
	PlayerUIFight.hide()
	PlayerAssetsUI = AssetsUI.instance()
	PlayerAssetsUI.rect_position.y = 218
	PlayerAssetsUI.margin_left = 5
	PlayerAssetsUI.margin_right = -5
	PlayerAssetsUI.connect("dress", self, "_on_assetsUi_dress")
	PlayerAssetsUI.connect("undress", self, "_on_assetsUi_undress")
	PlayerAssetsUI.add_to_inventory(inventory)
	current_level.add_child(PlayerUIFight)
	current_level.add_child(PlayerAssetsUI)
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		cheat()
	pass

# signals for connect the UI with the character VIA the Player
func _on_PlayerUIFight_call(): # NOT DOUBLE
	$Character.call()
	pass # replace with function body

func _on_PlayerUIFight_fold(): # NOT DOUBLE
	$Character.fold() # optionnel
	current_level.current_fight.fold(self)
	pass # replace with function body

func _on_PlayerUIFight_raise(): # NOT DOUBLE
	$Character.raise()
	pass # replace with function body

func _on_assetsUi_dress(clothName):
	print("on assetsUi dress ", clothName)
	# find the cloth from the inventory
	var cloth = pick_from_inventory(clothName)
	Character.dress(cloth, true)
	pass

func _on_assetsUi_undress(clothCat):
	print("on assetsUi undress ", clothCat)
	var cloth = Character.undress(clothCat)
	add_to_inventory(cloth)
	pass


# signals for when the player put clothe in the sky
func _on_sky_received_cloth(clothName):
	print("bet: ", clothName)
	# checks ???
	var cloth = $Character.get_cloth_by_name(clothName)
	if cloth:
		$Character._bet(cloth)
		timer = Timer.new()
		timer.connect("timeout",self,"on_turn_timer_out")
		add_child(timer)
		timer.wait_time = 2
		timer.start()
	# bet the cloth and start a timer turn
	# if timer turn finished, check the pot, and then tell what the character did
	pass

func on_turn_timer_out():
	# check the pot, and then tell what the character did
	var potBalance = current_level.current_fight.get_node("Pot").get_amount_to_call()
	if potBalance == 0:
		# character call
		print("Player Calls!")
		pass
	elif potBalance > 0:
		# character Raise
		print("Player Raises!")
		pass
	else:
		# wait for next move
		return
	pass