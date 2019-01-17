# Enemy
extends Node

var disappearing_distance = 200
var distance = 0
#signal disappeared
const CharacterScene = preload("res://game/animations/character/Character.tscn")
const ManantScene = preload("res://game/animations/manant/Manant.tscn")
#const fightTriggerScene = preload("res://game/enemies/fightTrigger.tscn")

var Character
var Manant

var inventory

#var fightTrigger
var AI
var is_materialized = false
var fight_distance = 300
var flight_distance = 500

signal disappeared

# $Character API
# $Character.remove_and_throw(objRef) => returns objectRef
# $Character.dress(objRef or objRefArray)
# $Character.remove(objRef) => without animation
# $Character.run()
# $Character.set_direction("left" or "right")
# $Character.stand()

func _ready():
	AI = get_parent().AI
	pass

func spawn(world, data):
#	print(get_children())
	Character = CharacterScene.instance()
	Manant = ManantScene.instance()
	Character.add_child(Manant)
	Character.set_owner(self)
	Character.set_position(Vector2(data.pos, 160))
	world.add_child(Character)
	
	# instanciate inventory in here!!!
	Character.instanciate_base_clothes(data.base_clothes)
	Character.attribute_clothes_owner()
	Character.dress_character()
	
	
	Character.set_direction("left")
	is_materialized = true
	distance = 0
	pass

func _start_fight():
	var fight = get_parent().get_node("Fight")
	fight.start(self)

func get_decision(hands, pot): # NOT DOUBLE
	var enemyCards = hands.get_enemy_cards()
	var playerOpenCards = hands.get_player_open_cards()
	var playerHandSize = hands.get_player_hand_size()
	var potValue = pot.get_pot_value()
	var amountToCall = pot.get_amount_to_call()
	if amountToCall < 0:
		amountToCall = amountToCall * -1
	print("enemy get decision")
	print(amountToCall)
	var decision = get_parent().AI.get_ai_decision(enemyCards, playerOpenCards, playerHandSize, potValue, amountToCall)
	match decision:
		"call":
			Character.call()
		"raise":
			Character.raise()
		"fold":
			Character.fold()
			get_parent().current_fight.fold(self)
	pass

func disappear():
	# record inventory
	# queue_free ?  or just hide()???
	#	hide()
	print("disappeare!")
	Character.queue_free()
	is_materialized = false
	emit_signal("disappeared")
#	$Character.is_running = false
#	print($Character.is_running)
#	emit_signal("disappeared")
	pass

func sort_picked_up_clothes():
	# sort: have the other's owned clothes pushed to beginning,
	# the underweare / upperware will be done with z-index.
	for objRef in inventory:
		inventory.sort_custom(ClothesCustomSorter, "sort")
	attribute_clothes_owner()
	if get_parent().name == "Player":
		# display inventory in the UI
		get_parent().PlayerAssetsUI.add_to_inventory(inventory)
	else:
		_dispatch_inventory()
	pass

class ClothesCustomSorter:
	static func sort(a, b):
		if a.current_owner == "player":
			return true
		return false

func _dispatch_inventory():
	# dress the clothes until 5 are set
	# add other clothes to Inventory.
	for objRef in inventory:
		var cat = objRef.CATEGORY
		if Character.clothes[cat] == null:
#			clothes[cat] = objRef
			dress(objRef)
#			_file_for_inventory_erase(objRef)
		else:
			print("leave ", objRef.name, " in inventory")
	_erase_filed_inventory()
	get_inventory_verbose()
	pass

func remove_from_inventory(cloth):
	pass

func add_to_inventory(cloth):
	pass

func _process(delta):
#	print(get_parent().current_fight.state)
#	print(get_parent().get_node("World").position)
	if is_materialized:
		var distance = Character.position.x + get_parent().get_node("World").position.x
#		print(distance)
	# here get the distance between character and player's character.
		if get_parent().current_fight.state == "sleeping":
			if distance <= fight_distance:
				get_parent().current_fight.start(Character)
			pass
		if get_parent().current_fight.state == "finished":
			if distance >= flight_distance:
				disappear()
#		if distance
	# if current_fight.state == "sleeping", and distance <= ??? => start fight
	# if current_fight.state == "finished", and distance >= ??? => disappeare.
	
		if Character.is_running:
			Character.position.x += 2
#		if get_parent().current_fight.state == "finished":
#			if distance >= disappearing_distance:
#				disappear()
	pass