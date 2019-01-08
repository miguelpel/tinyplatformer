# Enemy1
extends Node2D

const base_clothes = {
	hat = preload("res://game/objects/scenes/GreenBeret/main/GreenBeret.tscn"),
	shirt = preload("res://game/objects/scenes/GreenShirt/main/GreenShirt.tscn"),
	pants = preload("res://game/objects/scenes/GreenPants/main/GreenPants.tscn"),
	undershirt = preload("res://game/objects/scenes/Undershirt/main/Undershirt.tscn"),
	panties = preload("res://game/objects/scenes/Slip/main/Slip.tscn")
}


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
	$Character.instanciate_base_clothes(base_clothes)
#	_instanciate_base_clothes()
#	_dress_character()
	$Character.set_direction("left")

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
	var decision = $AI.get_ai_decision(enemyCards, playerOpenCards, playerHandSize, potValue, amountToCall)
	match decision:
		"call":
			$Character.call()
		"raise":
			$Character.raise()
		"fold":
			$Character.fold()
			get_parent().get_node("Fight").fold(self)
	
	pass

func _process(delta):
	pass



func _on_fightTrigger_area_entered(area):
	if area.get_parent().get_parent().name == "Player":
		_start_fight()
	pass # replace with function body
