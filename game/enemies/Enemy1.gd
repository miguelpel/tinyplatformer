# Enemy1
extends Node2D

const base_clothes = {
	hat = preload("res://game/objects/scenes/GreenBeret/main/GreenBeret.tscn"),
	shirt = preload("res://game/objects/scenes/GreenShirt/main/GreenShirt.tscn"),
	pants = preload("res://game/objects/scenes/GreenPants/main/GreenPants.tscn"),
	undershirt = preload("res://game/objects/scenes/Undershirt/main/Undershirt.tscn"),
	panties = preload("res://game/objects/scenes/Slip/main/Slip.tscn")
}

var clothes = {
	hat = null,
	undershirt = null,
	panties = null,
	shirt = null,
	pants = null
}

var cloth_to_throw
var removes = 0
var time_to_throw = 0.8
var timer
var doing_action

var cloth_remove_order = ["shirt", "pants", "undershirt", "panties", "hat"]
var current_cloth_to_remove = 0

var all_actions_done = false # only if ALL actions are done. Allow to throw 2 clothes one after the other (raise)

# $Character API
# $Character.remove_and_throw(objRef) => returns objectRef
# $Character.dress(objRef or objRefArray)
# $Character.remove(objRef) => without animation
# $Character.run()
# $Character.set_direction("left" or "right")
# $Character.stand()

# Pot API???

func _ready():
	_instanciate_base_clothes()
	_dress_character()
	doing_action = false
	all_actions_done = true
	$Character.direction = "left"

func _instanciate_base_clothes():
	for cat in clothes:
		clothes[cat] = base_clothes[cat].instance()
		clothes[cat].current_owner = self

func _dress_character():
	for cat in clothes:
		$Character.dress(clothes[cat])
	pass

func remove_next_cloth():
	removes -= 1
	if !doing_action:
		doing_action = true
		var clth = null
		var counter = 0
		while clth == null and counter < 5:
	#		print(clth)
	#		print(counter)
			clth = clothes[cloth_remove_order[counter]]
			counter += 1
		if counter > 5:
			return
		if clth != null:
			bet(clth)
		else:
			check_next_action()
			return false
	else:
		return false

# pick_up => add it to clothes,
# OR Check for double and add to inventory
func pick_up(obj):
	var objRef = obj.object_ref
	var cat = obj.CATEGORY
	obj.queue_free()
	#print(clothes[cat])
	if clothes[cat] == null:
#		print(cat)
#		print("null")
		clothes[cat] = objRef
		$Character.dress(objRef)
	#else:
		#Inventory.check_and_append(objRef)
	pass

func bet(cloth):
	cloth_to_throw = $Character.remove_and_throw(cloth)
	if cloth_to_throw:
		timer = Timer.new()
		timer.connect("timeout",self,"throw_in_pot")
		add_child(timer)
		timer.wait_time = time_to_throw
		timer.start()
 
func get_pot():
	var pot = get_parent().get_node("Pot")
	pot.get_pot_to($Character.direction, self)

func throw_in_pot():
	timer.stop()
	print("throw in pot")
	var pot = get_parent().get_node("Pot")
	if cloth_to_throw != null:
		print(cloth_to_throw.name)
		pot.throw_in(cloth_to_throw, position, $Character.direction)
		clothes[cloth_to_throw.CATEGORY] = null
	else:
		print("no cloth_to_throw")
	check_next_action()
	pass

func remove_clothes(nbr = 1):
	removes = nbr
	remove_next_cloth()

func get_decision(hands, pot, amountToCall):
	print("enemy get decision")
	print(hands)
	print(pot)
	var enemyCards = hands.get_enemy_cards()
	print("enemy cards")
	print(enemyCards)
	var playerOpenCards = hands.get_player_open_cards()
	print("player open cards")
	print(playerOpenCards)
	var playerHandSize = hands.get_player_hand_size()
	print("player hand size")
	print(playerHandSize)
	print(amountToCall)
	var decision = $AI.get_ai_decision(enemyCards, playerOpenCards, playerHandSize, pot, amountToCall)
	return decision
	pass

func call():
	print("call")
	var pot = get_parent().get_node("Pot")
	var diff = pot.get_amount_to_call()
	print(diff)
	if diff > 0:
		remove_clothes(diff)
		all_actions_done = false
	else:
		all_actions_done = true
	pass

func fold():
	all_actions_done = false
	pass

func raise():
	all_actions_done = false
	print("raise")
	var pot = get_parent().get_node("Pot")
	var diff = pot.get_amount_to_call()
	print(diff+1)
	remove_clothes(diff+1)
	pass

func check_next_action():
	print("check next action")
	print(removes)
	if removes < 0:
		removes = 0
	if removes > 0:
#		removes -= 1
		doing_action = false
		remove_next_cloth()
	else:
		doing_action = false
		all_actions_done = true
		print("all_actions_done")
		var pot = get_parent().get_node("Pot")
		print(pot.get_pot_value())

func _process(delta):
#	if Input.is_action_just_pressed("ui_left"):
#		print("left")
#		remove_clothes()
#		# remove one cloth
#		pass
#	if Input.is_action_just_pressed("ui_right"):
#		print("right")
#		remove_clothes(2)
#		# go away right
#		# remove two clothes
#		pass
#	if Input.is_action_just_pressed("ui_up"):
#		print("up")
#		remove_clothes(3)
#		# remove three clothes
#		pass
#	if Input.is_action_just_pressed("ui_down"):
#		print("down")
#		pass
	pass

