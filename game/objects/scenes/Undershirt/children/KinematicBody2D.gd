# Undershirt KinematicBody2D
extends KinematicBody2D

const CATEGORY = "undershirt"
var object_ref

var up
var gravity
var thrown = false
var max_speed
var acceleration
var is_dragged_left = false
var is_dragged_right = false
var is_pickable = false

var motion = Vector2()

func _ready():
	pass

func set_throwing_position(pos, throw):
	motion = throw
	position = pos
	thrown = true
	pass

func _physics_process(delta):
	if thrown:
		motion.y += gravity.y
		if is_dragged_left:
			motion.x = max(motion.x-acceleration, -max_speed)
		if is_dragged_right:
			motion.x = min(motion.x+acceleration, max_speed)
		if is_on_floor():
			#is_pickable = true
			motion.x = lerp(motion.x, 0, 0.2)
		else:
			#is_pickable = false
			motion.x = lerp(motion.x, 0, 0.05)
		motion = move_and_slide(motion, up)
		if motion == Vector2():
			is_pickable = true
	pass