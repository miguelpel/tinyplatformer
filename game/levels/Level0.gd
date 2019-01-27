#Level0
extends Node

# infinite ground animation
# rectangle
# buttons: play and quit.

# viewport / 2 !!!!
const player_anim_position = Vector2(170, 128)

func _ready():
	# run animation,
	# make_appear the buttons. (with timer.)
	$King.play("run")
	$King.get_node("AnimatedSprite").play("run")
	$King.get_node("AnimatedSprite2").play("run")
	#$player.set_king_position(player_anim_position)
	#$player.run()
	pass

# the level has a create_player func

#func get_player_anim_position():
#	return player_anim_position

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass


func _on_PlayButton_pressed():
	var Level1 = preload("res://game/levels/Level1.tscn")
	get_parent().set_level(Level1)
	pass # replace with function body



func _on_ExitButton_pressed():
	get_tree().quit()
	pass # replace with function body
