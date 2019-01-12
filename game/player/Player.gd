# Player
extends Node

const base_clothes = {
	hat = preload("res://game/objects/scenes/Crown/main/Crown.tscn"),
	shirt = preload("res://game/objects/scenes/RoyalShirt/main/RoyalShirt.tscn"),
	pants = preload("res://game/objects/scenes/RoyalPants/main/RoyalPants.tscn"),
	undershirt = preload("res://game/objects/scenes/Undershirt/main/Undershirt.tscn"),
	panties = preload("res://game/objects/scenes/Slip/main/Slip.tscn")
}

const fightUI = preload("res://game/fight/PlayerUiFight.tscn")

var PlayerUIFight

var Inventory = []
var current_level
var Character
#var fight


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
	Character.instanciate_base_clothes(base_clothes)
#	_instanciate_base_clothes() # DOUBLE
#	_dress_character() # DOUBLE
	Character.set_direction("right")


func _process(delta):
#	if Input.is_action_just_pressed("ui_right"):
#		$Character.run()
#	if Input.is_action_just_pressed("ui_down"):
#		$Character.stand()
#	if Input.is_action_just_pressed("ui_left"):
#		get_pot()
#	if Input.is_action_just_pressed("ui_up"):
#		remove_next_cloth()
	pass

func spawn_character(level):  # NOT DOUBLE
#	print("spawn character")
#	print($Character)
	current_level = level
	var world = level.get_node("World")
	$Character.position = Vector2(64, 128)
	$Character.show()
	world.add_child($Character)
	PlayerUIFight = fightUI.instance()
	PlayerUIFight.connect("call", self, "_on_PlayerUIFight_call")
	PlayerUIFight.connect("fold", self, "_on_PlayerUIFight_fold")
	PlayerUIFight.connect("raise", self, "_on_PlayerUIFight_raise")
	PlayerUIFight.hide()
#	print(PlayerUIFight.name)
	current_level.add_child(PlayerUIFight)
	pass

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
