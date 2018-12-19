extends AnimatedSprite
#
#func _ready():
#	#_assign_clothes()
#	#start_run()
#	play("stand")
#
#func _check_next_anim():
#	print("check anim")
#	var anim = animation
#	if anim == "remove" or anim == "removePanties":
#		throw()
#	elif anim == "throw":
#		stand()
#	else:
#		stand()
##
#func run():
##	#print("run")
##	disconnect("animation_finished", self, "_check_next_anim")
##	var animatedSprites = _get_children_anim_sprites()
##	print(animatedSprites)
##	for animSprite in animatedSprites:
##		animSprite.play("run")
#	play("run")
#
##func remove(node=null):
##	#print("remove")
##	var nd = node
##	connect("animation_finished", self, "_check_next_anim")
##	var animatedSprites = _get_children_anim_sprites()
##	print(animatedSprites)
##	for animSprite in animatedSprites:
##		animSprite.play("remove")
##	play("remove")
##	remove_child(nd)
##	return nd
#
##func throw():
##	#print("throw")
##	var animatedSprites = _get_children_anim_sprites()
##	print(animatedSprites)
##	for animSprite in animatedSprites:
##		animSprite.play("throw")
##	play("throw")
#
##func stand():
##	#print("stand")
##	var animatedSprites = _get_children_anim_sprites()
##	print(animatedSprites)
##	for animSprite in animatedSprites:
##		animSprite.play("stand")
##	play("stand")
#
##func removePanties():
##	#print("removePanties")
##	connect("animation_finished", self, "_check_next_anim")
##	var animatedSprites = _get_children_anim_sprites()
##	print(animatedSprites)
##	for animSprite in animatedSprites:
##		animSprite.play("removePanties")
##	play("removePanties")
#
