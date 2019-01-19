# Character
extends Node2D

# the card that displays the decision
var card = preload("res://game/fight/card.tscn")

# Character owner: player or enemy
var character_owner

# Character sprite and direction
#const THROW_FORCE = 100
var CharacterSprite
var direction
var is_running = false
var current_fight = null

# Clothes the character is wearing
var clothes = {
	hat = null,
	undershirt = null,
	panties = null,
	shirt = null,
	pants = null
}

var erase_from_inventory_array = []

# vaiables allowing the throwing logic
var obj_to_throw
var obj_to_throw_ref
var cloth_to_throw
var removes = 0
var time_to_throw = 0.8
var timer
var cloth_remove_order = ["shirt", "pants", "undershirt", "panties", "hat"]
var current_cloth_to_remove = 0
var picked_up_objects = []

# signals that all actions are done.
signal all_actions_done
signal player_in_distance

func _ready():
	_set_character_sprite()
	if CharacterSprite == null:
		print("no character sprite")
	pass

# Set Up functions
func _set_character_sprite():
	for child in get_children():
		if child.get_class() == "AnimatedSprite":
			CharacterSprite = child
	pass

func set_owner(ownr):
	character_owner = ownr

#func instanciate_base_clothes(baseClothes):
#	for cloth in baseClothes:
#		inventory.append(cloth.instance())

#func attribute_clothes_owner():
#	for cloth in inventory:
#		if get_parent().name == "Player":
#			cloth.current_owner = "player"
#		else:
#			cloth.current_owner = "enemy"
#		pass
	

# Direction change
func set_direction(dir="right"):
	direction = dir
	_apply_direction()

func _apply_direction():
	if direction == "left":
		for animSprite in _get_anim_sprites():
			animSprite.flip_h = true
	else:
		for animSprite in _get_anim_sprites():
			animSprite.flip_h = false
	pass

# DRESSING
# DRESS ALL
func dress_character(clothArray):
	for cloth in clothArray:
		if clothes[cloth.CATEGORY] == null:
			dress(cloth)
	_erase_filed_inventory()
	pass

func _erase_filed_inventory():
	for cloth in erase_from_inventory_array:
		character_owner.remove_from_inventory(cloth)
	erase_from_inventory_array = []
	pass

# $Character.dress(objRef or objRefArray)
# DRESS A SPECIFIC OBJECT OR ARR OF OBJECT
func dress(objRef, erase=false):
	var cloth
	var cat
	print("dress ", objRef)
	#print("Type object")
	cloth = objRef
	cat = cloth.CATEGORY
	_add_anim_sprite(cloth)
	clothes[cat] = cloth
	if erase:
		character_owner.remove_from_inventory(cloth)
	else:
		erase_from_inventory_array.append(cloth)
	_apply_direction()

func get_clothes_verbose():
	var inv = []
	for cat in clothes:
		if clothes[cat] != null:
			inv.append(clothes[cat].name)
	return inv
	pass

func _add_anim_sprite(cloth):
	var AnimSprite = cloth.create_animation()
	if cloth.CATEGORY == "panties" or cloth.CATEGORY == "undershirt":
		AnimSprite.z_index == 1
	else:
		AnimSprite.z_index == 2
	AnimSprite.show()
	AnimSprite.play("stand")
	CharacterSprite.add_child(AnimSprite)
	pass

func undress(objOrCat): # only for Player ???
	print("undress ", objOrCat)
	# suppress the cloth animation from character
	# suppress the cloth from clothes
	# return the cloth
	var animSprite
	var cat
	var clothObj
	if typeof(objOrCat) == TYPE_STRING:
		cat = objOrCat
	elif typeof(objOrCat) == TYPE_OBJECT:
		cat = objOrCat.CATEGORY
	clothObj = clothes[cat]
	for sprite in CharacterSprite.get_children():
		if sprite.CATEGORY == cat:
			animSprite = sprite
	animSprite.queue_free()
	clothes[cat] = null
	return clothObj


# !!!!!!
#func get_from_inventory(objName):
#	for obj in inventory:
#		if obj.name == objName:
#			return obj
#	get_inventory_verbose()
#	print("can't find cloth named ", objName, " in inventory")
#	return false
#	pass

func _get_pot():
	var pot
	var parent = get_parent()
	if parent.name == "Player":
		pot = parent.current_level.current_fight.get_node("Pot")
	else:
		pot = parent.get_node("Fight").get_node("Pot")
	if pot:
		return pot
	else:
		print("can't get pot")
	return false

# the CALL/RAISE/FOLD API
func call():
	current_fight.change_opponent()
	if get_parent().name == "Player":
		get_parent().PlayerUIFight.disable()
		print("player calls")
	else:
		print("enemy calls")
	var cd = card.instance()
	add_child(cd)
	cd.create("call")
	var pot = _get_pot()
	var diff = pot.get_amount_to_call()
	if diff < 0:
		diff = diff * -1
	if pot.get_parent().betTurn < 1 and pot.get_parent().distribution == 1:
		print("first call")
		diff += 1
	if diff > 0:
		_remove_clothes(diff)
	else:
		emit_signal("all_actions_done")
	pass

func fold():
	if current_fight.distribution > 1:
		current_fight.change_opponent()
	if get_parent().name == "Player":
		get_parent().PlayerUIFight.disable()
	print(get_parent().name, " folds")
	var cd = card.instance()
	add_child(cd)
	cd.create("folds")
	pass

func raise():
	current_fight.change_opponent()
	var cd = card.instance()
	add_child(cd)
	cd.create("raises")
	var pot = _get_pot()
	var diff = pot.get_amount_to_call()
	if diff < 0:
		diff = diff * -1
	if get_parent().name == "Player":
		get_parent().PlayerUIFight.disable()
		print("player raises")
	else:
		print("enemy raises")
	print(diff+1)
	_remove_clothes(diff+1)
	pass

func _remove_next_cloth():
	removes -= 1
	var clth = null
	var counter = 0
	while clth == null and counter < 5:
		clth = clothes[cloth_remove_order[counter]]
		counter += 1
	if counter > 5:
		return
	if clth != null:
		_bet(clth)
	else:
		_check_next_action()
		return false

func is_naked():
	var count = 0
	for cat in clothes:
		if clothes[cat] == null:
			count += 1
	if count == 5:
		print(character_owner.name, " is naked")
		return true
	else:
		return false

# pick_up => add it to clothes,
# OR Check for double and add to inventory
func _pick_up(obj):
	# get the REFS of the objects.
	# the ref takes no place and can be manipulated easely.
	# add those refs to an array pickedUpObject
	var pot = _get_pot()
	var objRef = obj.object_ref
	pot.obj_refs.erase(objRef)
	character_owner.add_to_inventory(objRef)
	# and erase the instance of object.
	obj.queue_free()
	pass

#func _file_for_inventory_erase(objRef):
#	erase_from_inventory_array.append(objRef)
#	pass

#func get_inventory_verbose():
#	# ask for the inventory of character_owner, and display it
#	if get_parent().name == "Player":
#		print("Player inventory:")
#	else:
#		print("Enemy inventory:")
#	for objRef in inventory:
#		print(objRef.name)
#	pass

func remove_from_inventory(objRef):
	# each opponent have different handling of that event
	character_owner.remove_from_inventory(objRef)
	pass

func get_cloth_by_name(name):
	var cloth = null
	for cat in clothes:
		if clothes[cat].name == name:
			cloth = clothes[cat]
	return cloth
	pass

func _bet(cloth):
	cloth_to_throw = _remove_and_throw(cloth)
	if cloth_to_throw:
		timer = Timer.new()
		timer.connect("timeout",self,"_throw_in_pot")
		add_child(timer)
		timer.wait_time = time_to_throw
		timer.start()

func _throw_in_pot():
	timer.stop()
	var pot = _get_pot()
	if !pot:
		print("no pot to throw in!")
		return
	if cloth_to_throw != null:
#		pot.throw_in(cloth_to_throw, position, direction)
		if character_owner.name == "Player":
			pot.throw_in(cloth_to_throw, position, direction)
			character_owner.remove_from_silhouette(cloth_to_throw)
		else:
			print("throw in pot from: ", (position + get_parent().position))
			pot.throw_in(cloth_to_throw, position + get_parent().position, direction)
		clothes[cloth_to_throw.CATEGORY] = null
		cloth_to_throw = null
	else:
		print("no cloth_to_throw")
	_check_next_action()
	pass

func give_blind():
	_remove_clothes(1)

func _remove_clothes(nbr = 1):
	removes = nbr
	_remove_next_cloth()

func _check_next_action():
	if removes < 0:
		removes = 0
	if removes > 0:
		_remove_next_cloth()
	else:
		emit_delayed_completed_signal()

func emit_delayed_completed_signal():
	timer = Timer.new()
	timer.connect("timeout",self,"emit_completed_signal")
	add_child(timer)
	timer.wait_time = 1
	timer.start()
	pass

func emit_completed_signal():
	timer.stop()
	emit_signal("all_actions_done")
	pass

func _get_anim_sprites():
	var animSprites = []
	if CharacterSprite:
		animSprites.append(CharacterSprite)
	for child in _get_all_children():
		if child.get_class() == "AnimatedSprite":
			animSprites.append(child)
	return animSprites
	pass

func _get_all_children():
	var chdren = []
	for chld in get_children():
		if chld.get_children().size() > 0:
			for grandchld in chld.get_children():
				chdren.append(grandchld)
		else:
			chdren.append(chld)
		pass
	return chdren

# $Character.remove_and_throw(objRef)
# returns Object ref, to allow for transfer or deletion
func _remove_and_throw(objRef):
	if objRef:
	# the object ref is the Object scene, not the animation
		var category = objRef.CATEGORY
	#	# find in children the according sprite
		var obj = null
		for cloth in CharacterSprite.get_children():
			if cloth.CATEGORY == category:
				obj = cloth
		if obj == null:
			return
		if !CharacterSprite.is_connected("animation_finished", self, "_check_next_anim"):
			CharacterSprite.connect("animation_finished", self, "_check_next_anim")
		if category == "pants" or category == "panties":
			for animSprite in _get_anim_sprites():
				animSprite.play("removePanties")
		else:
			for animSprite in _get_anim_sprites():
				animSprite.play("remove")
		obj_to_throw = obj
		obj_to_throw_ref = objRef
		return objRef
	else:
		return null

# $Character.remove(objRef) => without animation
func _remove(objRef):
	var animation = objRef.animation
	animation.queue_free()
	return objRef

func run():
	is_running = true
	if CharacterSprite.is_connected("animation_finished", self, "_check_next_anim"):
		CharacterSprite.disconnect("animation_finished", self, "_check_next_anim")
	var animSprites = _get_anim_sprites()
	if animSprites.size() > 0:
		for animSprite in _get_anim_sprites():
			animSprite.play("run")
	pass

func stand():
	is_running = false
	# is_connected ( String signal, Object target, String method ) 
	if CharacterSprite.is_connected("animation_finished", self, "_check_next_anim"):
		CharacterSprite.disconnect("animation_finished", self, "_check_next_anim")
	for animSprite in _get_anim_sprites():
		animSprite.play("stand")
	pass

func throw():
	for animSprite in _get_anim_sprites():
		animSprite.play("throw")
	pass

func change_direction():
	if direction == "right":
		direction = "left"
	else:
		direction = "right"
	set_direction(direction)
	pass

func flee():
	change_direction()
	run()
	pass

func _check_next_anim():
	var anim = CharacterSprite.animation
	if anim == "remove" or anim == "removePanties":
		_discard_anim_object()
		throw()
	else:
		stand()
		# emit signal throw_done. Maybe with timer.

func _discard_anim_object():
#	print("discard obj")
	var obj = obj_to_throw
	obj_to_throw = null
	if obj != null:
		if get_children().has(obj):
			remove_child(obj)
		obj.queue_free()
	pass

#func _process(delta):
#	pass

func _on_CharacterArea2D_body_entered(body):
	if body.get_class() == "KinematicBody2D" and body.is_pickable:
		_pick_up(body)
	pass # replace with function body
