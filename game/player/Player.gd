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

#var Inventory = []
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
	Character.instanciate_base_clothes(base_clothes)
#	_instanciate_base_clothes() # DOUBLE
#	_dress_character() # DOUBLE
	Character.set_direction("right")

func remove_from_inventory(cloth):
	pass

func add_to_inventory(cloth):
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
	PlayerAssetsUI.add_to_inventory(Character.inventory)
	current_level.add_child(PlayerUIFight)
	current_level.add_child(PlayerAssetsUI)
	pass

func _process(delta):
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
#	print("on assetsUi dress ", clothName)
	Character.dress(clothName, true)
	pass

func _on_assetsUi_undress(clothCat):
#	print("on assetsUi undress ", clothCat)
	Character.undress(clothCat)
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