# Character
extends Node2D

#const THROW_FORCE = 100
var CharacterSprite
var direction
var obj_to_throw
var obj_to_throw_ref
var time_to_throw = 2
var timer



# $Character.run()
# $Character.set_direction("left" or "right")
# $Character.stand()

func _ready():
	_set_character_sprite()
	if CharacterSprite == null:
		print("no character sprite")
	pass

func _set_character_sprite():
	for child in get_children():
		if child.get_class() == "AnimatedSprite":
			CharacterSprite = child
	pass

func set_direction(dir="right"):
	direction = dir

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

# $Character.dress(objRef or objRefArray)
# make appear the cloth on the character
func dress(objsRef):
	CharacterSprite.play("stand")
	if typeof(objsRef) == TYPE_ARRAY:
		#print("type Array")
		for objRef in objsRef:
			var AnimSprite = objRef.create_animation()
			AnimSprite.show()
			AnimSprite.play("stand")
			CharacterSprite.add_child(AnimSprite)
		#dress all
	elif typeof(objsRef) == TYPE_OBJECT:
		#print("Type object")
		var AnimSprite = objsRef.create_animation()
		AnimSprite.show()
		AnimSprite.play("stand")
		CharacterSprite.add_child(AnimSprite)

# $Character.remove_and_throw(objRef)
# returns Object ref, to allow for transfer or deletion
func remove_and_throw(objRef):
	#print("throw")
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
func remove(objRef):
	var animation = objRef.animation
	animation.queue_free()
	return objRef

func run():
	#print("run")
	CharacterSprite.disconnect("animation_finished", self, "_check_next_anim")
	var animSprites = _get_anim_sprites()
	if animSprites.size() > 0:
		for animSprite in _get_anim_sprites():
			animSprite.play("run")
	print(animSprites)
	pass

func stand():
	print("stand")
	CharacterSprite.disconnect("animation_finished", self, "_check_next_anim")
	for animSprite in _get_anim_sprites():
		animSprite.play("stand")
	pass

func throw():
	for animSprite in _get_anim_sprites():
		animSprite.play("throw")
	pass

func _check_next_anim():
	print("check next anim")
	var anim = CharacterSprite.animation
	if anim == "remove" or anim == "removePanties":
		_discard_anim_object()
		throw()
	else:
		stand()
		# emit signal thrown_done. Maybe with timer.

func _discard_anim_object():
	print("discard obj")
	var obj = obj_to_throw
	obj_to_throw = null
	if obj != null:
		remove_child(obj)
		obj.queue_free()
	pass

func throw_from(pos):
#	$AnimatedSprite.hide()
#	$Icon.show()
#	position = pos
#	mode = RigidBody2D.MODE_RIGID
#	timer = Timer.new()
#	timer.connect("timeout",self,"throw")
#	add_child(timer)
#	timer.wait_time = 0.5
#	timer.start()
	pass

#func throw():
#	timer.stop()
#	apply_impulse(Vector2(1,-1),Vector2(THROW_X,THROW_Y))
#	$CollisionShape2D.show()
#	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if direction == "left":
		for animSprite in _get_anim_sprites():
			animSprite.flip_h = true
	pass

func _on_CharacterArea2D_body_entered(body):
	if body.get_class() == "KinematicBody2D" and body.is_pickable:
		get_parent().pick_up(body)
	pass # replace with function body
