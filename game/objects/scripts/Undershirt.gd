# UnderShirt
extends Node

const TYPE = "undershirt"
const THROW_FORCE = 100

var timer

func _ready():
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

#func spawn(pos):
#	position = pos
#	mode = RigidBody2D.MODE_RIGID
#	timer = Timer.new()
#	timer.connect("timeout",self,"throw")
#	add_child(timer)
#	timer.wait_time = 0.2
#	timer.start()
#	pass

#func throw():
#	timer.stop()
#	apply_impulse(Vector2(1,-1),Vector2(THROW_X,THROW_Y))
#	$CollisionShape2D.show()
#	pass

func _process(delta):
	pass
