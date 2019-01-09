# Level1
extends Node

# is character running?
var is_running = false

# keep track of the player and the current fight
var player
var current_fight = null
# used to spawn enemies one after the other
var current_enemy = 0
var AI

# Enemy scene
const enemy = preload("res://game/enemies/Enemy.tscn")

# list of all the enemies
var enemiesData = [
{
	base_clothes = {
	hat = preload("res://game/objects/scenes/GreenBeret/main/GreenBeret.tscn"),
	shirt = preload("res://game/objects/scenes/GreenShirt/main/GreenShirt.tscn"),
	pants = preload("res://game/objects/scenes/GreenPants/main/GreenPants.tscn"),
	undershirt = preload("res://game/objects/scenes/Undershirt/main/Undershirt.tscn"),
	panties = preload("res://game/objects/scenes/Slip/main/Slip.tscn")},
	inventory = [],
	pos = 512
},
{
	base_clothes = {
	hat = preload("res://game/objects/scenes/RedBeret/main/RedBeret.tscn"),
	shirt = preload("res://game/objects/scenes/RedShirt/main/RedShirt.tscn"),
	pants = preload("res://game/objects/scenes/RedPants/main/RedPants.tscn"),
	undershirt = preload("res://game/objects/scenes/Undershirt/main/Undershirt.tscn"),
	panties = preload("res://game/objects/scenes/Slip/main/Slip.tscn")},
	inventory = [],
	pos = 1024
}
]

func _ready():
#	print(get_parent().get_node("Player").name)
	player = get_parent().get_node("Player")
	player.spawn_character(self)
	spawnEnemy()
	player.get_node("Character").run()
	player.get_node("Character").is_running = true
	current_fight = $World.get_node("Fight")
	AI = $World.get_node("AI")
#	current_fight.start()
	pass

func spawnEnemy():
	var enemyData = enemiesData[current_enemy]
	var enm = enemy.instance()
	enm.set_position(Vector2(enemyData.pos, 160))
	$World.add_child(enm)
	enm.spawn(enemyData)
	enm.connect("disappeared", self, "on_enemy_disappear")
	pass

func _process(delta):
#	if fight == null:
#		run()
	if player.get_node("Character").is_running:
		if player.get_node("Character").direction == "right":
			$World.position.x -= 2
		else:
			$World.position.x += 2
	pass

func on_enemy_disappear():
	print("on enemy disappear")
	current_enemy += 1
	spawnEnemy()
	$World.get_node("Fight").set_state("sleeping")
	if player.get_node("Character").direction == "left":
		player.get_node("Character").change_direction()
	else:
		player.get_node("Character").run()
	pass
