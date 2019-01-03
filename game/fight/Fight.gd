# Fight

extends Node

var enemy

var turn

var turn_done = true

var distribution = 0

func _ready():
	# 
#	randomize()
	enemy = $Enemy1
	var who_turn = randi()%2
	if who_turn == 0:
		turn = "player"
	else:
		turn = "enemy"
	pass

func start_fight():
	# set the things and
	# make appear the player's ui.
	pass

func distribute_first_round():
	print("first round!")
	print(turn)
	distribution += 1
	pass

func distribute_second_round():
	print("second round!")
	print(turn)
	distribution += 1
	pass

func distribute_last_round():
	print("last round!")
	print(turn)
	distribution += 1
	pass

func do_distribution():
	if distribution == 0:
		distribute_first_round()
	elif distribution == 1:
		distribute_second_round()
	elif distribution == 2:
		distribute_last_round()
	turn_done = false
	pass

func check_end_bet_turn():
	print("checking end bet turn")
	if $Pot.is_pot_levelled():
		turn_done = true
	pass

func _process(delta):
	if turn_done:
		do_distribution()
	else:
		if turn == "enemy":
			# ask for enemy decision.
			# check the pot to see if it's levelled.
			# !!! the decision takes time.
			enemy.get_decision($Hands, $Pot)
			pass
		#else, do nothing (wait)
	pass

# signals: on_player_action_done():
	# check_end_bet_turn()
# on_enemy_action_done():
	#check_end_bet_turn()