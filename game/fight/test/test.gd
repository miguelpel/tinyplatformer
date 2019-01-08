extends Node

const card = preload("res://game/fight/card.tscn") # for test

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
		# for test
	if Input.is_action_just_pressed("ui_up"):
#		print(enemy.get_position())
		var cd = card.instance()
		add_child(cd)
		cd.create("call", Vector2(50, 50))
	pass
