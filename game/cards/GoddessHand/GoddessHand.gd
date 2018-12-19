extends Node2D

signal almost_done
var anims = []
var running = false
var timer

func _ready():
	anims = [$WCard, $SwooshG, $SwooshD]
	timer = Timer.new()
	timer.connect("timeout",self,"finish")
	add_child(timer)
	timer.wait_time = 0.1
	running = true
	pass

func play():
	for anim in anims:
		anim.show()
		anim.play("swoosh")
	pass

func _on_WCard_animation_finished():
	emit_signal("almost_done")
	timer.start()

func finish():
	hide()
	queue_free()

#func _process(delta):
#	if Input.is_action_just_pressed("ui_down"):
#		_play()
##	if anims[0].frame == 3:
##		if !anims[0].is_playing():
##			hide()
#	pass
