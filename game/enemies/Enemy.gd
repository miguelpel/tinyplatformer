# Enemy
extends Node2D

var disappearing_distance = 200
var distance = 0
#signal disappeared
const CharacterScene = preload("res://game/animations/character/Character.tscn")
const ManantScene = preload("res://game/animations/manant/Manant.tscn")
const fightTriggerScene = preload("res://game/enemies/fightTrigger.tscn")

var Character
var Manant
var fightTrigger
var AI
var is_materialized

signal disappeared
# $Character API
# $Character.remove_and_throw(objRef) => returns objectRef
# $Character.dress(objRef or objRefArray)
# $Character.remove(objRef) => without animation
# $Character.run()
# $Character.set_direction("left" or "right")
# $Character.stand()

# Pot API???

func _ready():
#	fight = get_parent().get_parent().current_fight
#	$Character.instanciate_base_clothes(base_clothes)
#	_instanciate_base_clothes()
#	_dress_character()
#	$Character.set_direction("left")
	AI = get_parent().get_node("AI")
	pass

func spawn(data):
	print(get_children())
	Character = CharacterScene.instance()
	Manant = ManantScene.instance()
	Character.add_child(Manant)
	add_child(Character)
	fightTrigger = fightTriggerScene.instance()
	add_child(fightTrigger)
	fightTrigger.connect("area_entered", self, "_on_fightTrigger_area_entered")
	Character.set_position(Vector2(200, 0))
	Character.instanciate_base_clothes(data.base_clothes)
	Character.set_direction("left")
	is_materialized = true
	distance = 0
#	$Character.instanciate_base_clothes(base_clothes)
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
#	print("enemy get decision")
#	print(amountToCall)
	var decision = AI.get_ai_decision(enemyCards, playerOpenCards, playerHandSize, potValue, amountToCall)
	match decision:
		"call":
			$Character.call()
		"raise":
			$Character.raise()
		"fold":
			$Character.fold()
			get_parent().get_node("Fight").fold(self)
	pass

func disappear():
	# record inventory
	# queue_free ?  or just hide()???
	#	hide()
	print("disappeare!")
	for child in get_children():
		child.queue_free()
	is_materialized = false
	emit_signal("disappeared")
#	$Character.is_running = false
#	print($Character.is_running)
#	emit_signal("disappeared")
	pass

func _process(delta):
	if is_materialized:
		if $Character.is_running:
			position.x += 2
		if get_parent().get_parent().current_fight.state == "finished":
			distance += 2
#			print(distance)
			if distance >= disappearing_distance:
				disappear()
	pass

func _on_fightTrigger_area_entered(area):
	if area.get_parent().get_parent().name == "Player":
		_start_fight()
	pass # replace with function body
