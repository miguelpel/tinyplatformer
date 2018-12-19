# Level1
extends Node

var is_running = false
var player
var current_fight = null

func _ready():
	print(get_parent().get_node("Player").name)
	player = get_parent().get_node("Player")
	player.spawn_character(self)
	current_fight = $World.get_node("Fight")
	pass

func _process(delta):
#	if fight == null:
#		run()
	if Input.is_action_pressed("ui_left"):
		is_running = false
	if is_running:
		$World.position.x -= 2
	pass
