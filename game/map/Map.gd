extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const OFFSET = Vector2(0, -10)

var positions_stack = []

var dest_position = null

var king_state = "idle"

func _ready():
	# set the event listeners each position
	# links to the same event listener on_position_clicked
	$Position.get_node("Area2D").connect("position_clicked", self, "_on_position_clicked")
	$Position2.get_node("Area2D").connect("position_clicked", self, "_on_position_clicked")
	$Position3.get_node("Area2D").connect("position_clicked", self, "_on_position_clicked")
	$King.set_position($Position.position + OFFSET)
	pass

func set_king_animation(animationString):
	$King.play(animationString)
	for child in $King.get_children():
		child.play(animationString)
	pass

func start_run():
#	print("start run")
	# set the state to "run"
	king_state = "running"
	# set the animation to "run"
	set_king_animation("run")
	
	pass

func stop_run():
#	print("stop run")
	# set the state to "stand"
	king_state = "stand"
	# set the animation to "idle"
	set_king_animation("stand")
	# set the position's level in preload
	pass

func flip_to_left():
	if $King.flip_h == false:
		$King.flip_h = true
		for child in $King.get_children():
			child.flip_h = true
	pass

func flip_back_to_right():
	if $King.flip_h == true:
		$King.flip_h = false
		for child in $King.get_children():
			child.flip_h = false

func add_position_to_stack(pos):
#	print("add position: ", pos, " to stack")
	# check for double
	if positions_stack.has(pos):
		print("has ", pos)
		return false
	else:
		print("add: ", pos)
		positions_stack.append(pos)
#	print(positions_stack)
	# if no double, append position to stack
	pass

func check_next_position():
#	print("check next position")
	# check i there's any position in the stack
	if positions_stack.size() > 0:
		dest_position = positions_stack[0] + OFFSET
		positions_stack.pop_front()
		if king_state == "stand":
			start_run()
			if ($King.position.x - dest_position.x) > 0:
				flip_to_left()
	else:
		dest_position = null
		stop_run()
		flip_back_to_right()
	# if there is, set the dest_position and deletee it from the stack
	pass

func _process(delta):
	# check if the king is running
	# if king is running
	if king_state == "running":
		var vector_to_next_position = $King.position - dest_position
		if vector_to_next_position != Vector2():
			if vector_to_next_position.x > 0:
				$King.position.x -= 1
#				return
			elif vector_to_next_position.x < 0:
				$King.position.x += 1
#				return
			elif vector_to_next_position.y > 0:
				$King.position.y -= 1
#				return
			elif vector_to_next_position.y < 0:
				$King.position.y += 1
#				return
		else:
			check_next_position()
	else:
		check_next_position()
		# king is running. Get his 
	
	
func _on_position_clicked(pos):
	if king_state == "stand":
		add_position_to_stack(pos)
#	dest_position = pos
