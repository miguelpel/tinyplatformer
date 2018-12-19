extends Node

const level0 = preload("res://game/levels/Level0.tscn")
const base_player = preload("res://game/player/Player.tscn")

var player
var current_level
var mode = "running"

func _ready():
	#_load_level()
	current_level = level0.instance()
	add_child(current_level)
	player = base_player.instance()
	
	#FOR INTRO, THE ANIMS ARE PART OF THE LEVEL.
#	current_level.add_child(player)
#	player.set_king_position(current_level.player_anim_position)
#	player.dress(["Crown", "slip"])
#	player.run()
	# Called every time the node is added to the scene.
	pass

func set_level(LevelScene):
	remove_child(current_level)
	current_level = LevelScene.instance()
	add_child(current_level)
	pass

#func _load_level():
#	level.instance()
#	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	if Input.is_action_just_pressed("ui_right"):
#		_run()
#	if Input.is_action_just_pressed("ui_left"):
#		_stand()
#	pass
