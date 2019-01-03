# Pot
extends Node

const UP = Vector2(0, -1)
const GRAVITY = Vector2(0, 20)
#const ACCELERATION = 50
#const THROW = Vector2(300, -400)
const ACCELERATION = 50
const MAX_SPEED = 200
const PANTS_OFFSET = Vector2(0, -40)
const SHIRT_OFFSET = Vector2(0, -40)

#if needed
var obj_refs = [] # keep track of the objects refs in pot

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func throw_in(objRef, pos, dir):
	print(objRef)
	print(pos)
#	objRef.get_parent().remove_child(objRef)
	if objRef:
		var throw
		if dir == "right":
			throw = Vector2(300, -400)
		else:
			throw = Vector2(-300, -400)
		add_child(objRef)
		var obj = objRef.create_kin_body()
		obj.up = UP
		obj.gravity = GRAVITY
		#obj.throw = THROW
		obj.acceleration = ACCELERATION
		obj.max_speed = MAX_SPEED
		if objRef.CATEGORY == "pants" or objRef.CATEGORY == "panties":
			obj.set_throwing_position(pos + PANTS_OFFSET, throw)
		elif objRef.CATEGORY == "shirt" or objRef.CATEGORY == "undershirt":
			obj.set_throwing_position(pos + SHIRT_OFFSET, throw)
		else:
			obj.set_throwing_position(pos, throw)
		add_child(obj)
	pass

func get_pot_to(characterDir, curr_owner):
	for anim in get_children():
		if anim.get_class() == "KinematicBody2D":
			if characterDir == "left":
				anim.is_dragged_right = true
			elif characterDir == "right":
				anim.is_dragged_left = true
			anim.object_ref.current_owner = curr_owner
	#print(character)
	pass

func get_pot_value():
	return obj_refs.size()

func is_pot_levelled():
	var opponent1
	var opponent1Objs = 0
	var opponent2Objs = 0
	opponent1 = obj_refs[0].current_owner
	for i in obj_refs.size():
		if obj_refs[i].current_owner == opponent1:
			opponent1Objs += 1
		else:
			opponent2Objs += 1
	if opponent1Objs == opponent2Objs:
		return true
	return false

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
