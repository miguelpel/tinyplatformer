# Pot
extends Node

const UP = Vector2(0, -1)
const GRAVITY = Vector2(0, 20)
const ACCELERATION = 50
const MAX_SPEED = 200
const PANTS_OFFSET = Vector2(0, -40)
const SHIRT_OFFSET = Vector2(0, -40)

#if needed
var obj_refs = [] # keep track of the objects refs in pot

signal animations_done # Fired when pot animation is done.

func throw_in(objRef, pos, dir):
#	print(objRef)
#	print(pos)
#	objRef.get_parent().remove_child(objRef)
	if objRef:
		var throwDirection
		if dir == "right":
			throwDirection = Vector2(300, -400)
		else:
			throwDirection = Vector2(-300, -400)
		add_child(objRef)
		var obj = objRef.create_kin_body()
		obj.up = UP
		obj.gravity = GRAVITY
		#obj.throw = THROW
		obj.acceleration = ACCELERATION
		obj.max_speed = MAX_SPEED
		if objRef.CATEGORY == "pants" or objRef.CATEGORY == "panties":
			obj.set_throwing_position(pos + PANTS_OFFSET, throwDirection)
		elif objRef.CATEGORY == "shirt" or objRef.CATEGORY == "undershirt":
			obj.set_throwing_position(pos + SHIRT_OFFSET, throwDirection)
		else:
			obj.set_throwing_position(pos, throwDirection)
		add_child(obj)
		obj_refs.append(objRef)
	pass

func get_pot_to(characterDir):
	for anim in get_children():
		if anim.get_class() == "KinematicBody2D":
			if characterDir == "left":
				anim.is_dragged_right = true
			elif characterDir == "right":
				anim.is_dragged_left = true
#			anim.object_ref.current_owner = curr_owner
	#print(character)
	obj_refs = []
	pass

func give_back_pot():
	for anim in get_children():
		if anim.get_class() == "KinematicBody2D":
			var owner = anim.object_ref.current_owner
			var ownerDir = owner.direction
			if ownerDir == "left":
				anim.is_dragged_right = true
			elif ownerDir == "right":
				anim.is_dragged_left = true
			# object_ref
			pass

func get_pot_value():
	return obj_refs.size()

func get_amount_to_call():
	if obj_refs.size() == 0:
		return 0
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
		return 0
	var diff = opponent2Objs - opponent1Objs
	if diff < 0:
		diff = diff * -1
	return diff

func get_vebose_pot():
	# give content object name and current owner.
	print("pot_verbose:")
	for objRef in obj_refs:
		print(objRef.name, " ", objRef.current_owner.get_parent().name)
	pass

func _process(delta):
	pass
