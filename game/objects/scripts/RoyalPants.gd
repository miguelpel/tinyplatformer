extends RigidBody2D

const TYPE = "pants"
const THROW_FORCE = 50
#var worn = false
var worn = true
var thrown = false
var timer
var throwPos = null

func _ready():
	$AnimatedSprite.play("stand")
	$Icon.hide()
	print("ready")
	pass
	
func throw_from(charPos):
	worn = false
	$AnimatedSprite.hide()
	$Icon.show()
	throwPos = charPos
	position = throwPos
	mode = RigidBody2D.MODE_RIGID
	timer = Timer.new()
	timer.connect("timeout",self,"throw")
	add_child(timer)
	timer.wait_time = 0.5
	timer.start()
	pass

func throw():
	timer.stop()
	if position.distance_to(throwPos) > 30:
		thrown = true
	else:
		print("trow!")
		apply_impulse(Vector2(0,-1),Vector2(THROW_FORCE,-THROW_FORCE))
	pass

func _process(delta):
	if !thrown and !worn:
		if throwPos != null:
			#print(position.distance_to(characterPos))
			if position.distance_to(throwPos) < 30:
				throw()
	pass