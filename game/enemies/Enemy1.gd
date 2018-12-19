# Enemy1
extends Node2D

const base_clothes = {
	hat = preload("res://game/objects/scenes/GreenBeret/main/GreenBeret.tscn"),
	shirt = preload("res://game/objects/scenes/GreenShirt/main/GreenShirt.tscn"),
	pants = preload("res://game/objects/scenes/GreenPants/main/GreenPants.tscn"),
	undershirt = preload("res://game/objects/scenes/Undershirt/main/Undershirt.tscn"),
	panties = preload("res://game/objects/scenes/Slip/main/Slip.tscn")
}

var clothes = {
	hat = null,
	undershirt = null,
	panties = null,
	shirt = null,
	pants = null
}

var cloth_to_throw
var time_to_throw = 0.8
var timer

var cloth_remove_order = ["shirt", "pants", "undershirt", "panties", "hat"]
var current_cloth_to_remove = 0

# $Character API
# $Character.remove_and_throw(objRef) => returns objectRef
# $Character.dress(objRef or objRefArray)
# $Character.remove(objRef) => without animation
# $Character.run()
# $Character.set_direction("left" or "right")
# $Character.stand()

# Pot API???

func _ready():
	_instanciate_base_clothes()
	_dress_character()
	$Character.direction = "left"

func _instanciate_base_clothes():
	for cat in clothes:
		clothes[cat] = base_clothes[cat].instance()
		clothes[cat].current_owner = self

func _dress_character():
	for cat in clothes:
		$Character.dress(clothes[cat])
	pass

func remove_next_cloth():
	var clth = null
	var counter = 0
	while clth == null and counter < 5:
#		print(clth)
		print(counter)
		clth = clothes[cloth_remove_order[counter]]
		counter += 1
	if counter > 5:
		return
	if clth != null:
		bet(clth)
	else:
		return false

# pick_up => add it to clothes,
# OR Check for double and add to inventory
func pick_up(obj):
	var objRef = obj.object_ref
	var cat = obj.CATEGORY
	obj.queue_free()
	#print(clothes[cat])
	if clothes[cat] == null:
		print(cat)
		print("null")
		clothes[cat] = objRef
		$Character.dress(objRef)
	#else:
		#Inventory.check_and_append(objRef)
	pass

func bet(cloth):
	cloth_to_throw = $Character.remove_and_throw(cloth)
	if cloth_to_throw:
		timer = Timer.new()
		timer.connect("timeout",self,"throw_in_pot")
		add_child(timer)
		timer.wait_time = time_to_throw
		timer.start()
 
func get_pot():
	var pot = get_parent().get_node("Fight").get_node("Pot")
	pot.get_pot_to($Character.direction, self)

func throw_in_pot():
	timer.stop()
	var pot = get_parent().get_node("Fight").get_node("Pot")
	pot.throw_in(cloth_to_throw, position, $Character.direction)
	clothes[cloth_to_throw.CATEGORY] = null
	print(position)
	pass

#func _process(delta):
#	if Input.is_action_just_pressed("ui_right"):
#		$Character.run()
#	if Input.is_action_just_pressed("ui_down"):
#		$Character.stand()
#	if Input.is_action_just_pressed("ui_left"):
#		get_pot()
#	if Input.is_action_just_pressed("ui_up"):
#		remove_next_cloth()
#	pass
