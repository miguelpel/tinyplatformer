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

var inventory = []

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
	instanciate_base_clothes(data.base_clothes)
#	Character.attribute_clothes_owner()
	Character.dress_character(inventory)
	Character.set_direction("left")
	is_materialized = true
	distance = 0
	pass

func instanciate_base_clothes(base_clothes):
	for cloth in base_clothes:
		inventory.append(cloth.instance())
	_attribute_clothes_owner()
	pass

func _attribute_clothes_owner():
	for cloth in inventory:
		cloth.current_owner = self
	pass

func _start_fight():
	var fight = get_parent().get_node("World").get_node("Fight")
	fight.get_node("Pot").connect("pot_empty", self, "on_pot_empty")
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

func get_inventory_verbose():
	var inv = []
	for cloth in inventory:
		inv.append(cloth.name)
	print("Enemy inventory: ", inv)
	pass

func is_naked():
	return Character.is_naked()
	pass

func undress_all():
	print("undress all")
	get_inventory_verbose()
	for cat in Character.clothes:
		var cloth = Character.undress(cat)
		if cloth:
			inventory.append(cloth)
#	print(inventory)
	get_inventory_verbose()
#	_sort_inventory()
	pass

func disappear():
	# record inventory
	undress_all()
	get_parent().enemiesData[get_parent().current_enemy].inventory = inventory
	inventory = []
	# queue_free ?  or just hide()???
	#	hide()
	#	print("disappeare!")
	Character.queue_free()
	is_materialized = false
	emit_signal("disappeared")
#	$Character.is_running = false
#	print($Character.is_running)
#	emit_signal("disappeared")
	pass

func _sort_inventory():
	# sort: have the other's owned clothes pushed to beginning,
	# the underweare / upperware will be done with z-index.
	inventory.sort_custom(ClothesCustomSorter, "sort")
#	_attribute_clothes_owner()
	pass

class ClothesCustomSorter:
	static func sort(a, b):
		if a.VALUE > b.VALUE:
			return true
		return false

#func _attribute_clothes_owner():
#	for cloth in inventory:
#		cloth.current_owner = self

func _dispatch_inventory():
	# dress the clothes until 5 are set
	# add other clothes to Inventory.
	print("dispatching inventory")
	_sort_inventory()
	var tempdress = []
	for objRef in inventory:
		tempdress.append(objRef)
	# the temp dress now has a number of clothes.
#	print(tempdress)
	for i in range(tempdress.size()):
		var cat = tempdress[i].CATEGORY
		if Character.clothes[cat] == null:
#			tempdress.append(objRef)
			Character.dress(tempdress[i], true)
	pass

func remove_from_inventory(cloth):
	inventory.erase(cloth)
	pass

func get_total_inventory_verbose():
	var inv = []
	for cloth in inventory:
		inv.append(cloth.name)
	for cat in Character.clothes:
		if Character.clothes[cat] != null:
			inv.append(Character.clothes[cat].name)
	return inv
	pass

func add_to_inventory(cloth):
	# check for double
	# here there's a change of name!!!
#	print("add to inventory ", cloth.name)
	cloth.current_owner = self
	inventory.append(cloth)
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
				_start_fight()
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

func on_pot_empty():
	# for debug
	var inv = []
	for cloth in inventory:
		inv.append(cloth.name)
	print("pot empty, dispatching clothes : ", inv)
	_dispatch_inventory()
	pass