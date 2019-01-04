# Fight

extends Node

var enemy

var player

var turn

var turn_done = true

var distribution = 0

var distribution_done = false

var fight_is_on = false

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

func get_player():
	print("get player")
	var ply = get_parent().get_parent().player
	if ply:
		print(ply.name)
		player = ply
		return true
	else:
		return false
	pass

func start():
	if get_player():
		fight_is_on = true
	else:
		print("error getting player")
	pass

func distribute_first_round():
	print("first round!")
	print(turn)
	distribution += 1
	$Hands.distribute_first_round()
	pass

func distribute_second_round():
	print("second round!")
	print(turn)
	distribution += 1
	$Hands.distribute_another_round()
	pass

func distribute_last_round():
	print("last round!")
	print(turn)
	distribution += 1
	$Hands.distribute_another_round()
	pass

func do_distribution():
	if distribution == 0:
		distribute_first_round()
	elif distribution == 1:
		distribute_second_round()
	elif distribution == 2:
		distribute_last_round()
	elif distribution == 3:
		reveal_hands()
	turn_done = false
	distribute_actions()
	pass

func reveal_hands():
	$Hands.reveal_all()
	pass

func check_if_all_actions_done():
#	print(player.all_actions_done, enemy.all_actions_done)
	if player.all_actions_done and enemy.all_actions_done:
		return true
	return false
	pass

func change_turn():
	if turn == "enemy":
		turn = "player"
	else:
		turn = "enemy"

func distribute_actions():
	player.all_actions_done = false
	enemy.all_actions_done = false
	pass

func check_state_machine():
	if check_if_all_actions_done() and $Pot.is_pot_levelled() == 0:
		do_distribution()
	else:
		if turn == "enemy" and $Hands.distribution_done:
			var decision = enemy.get_decision($Hands, $Pot.get_pot_value(), $Pot.get_amount_to_call())
			match decision:
				"fold":
					print("enemy folds")
					enemy.fold()
				"call":
					print("enemy calls")
					enemy.call()
				"raise":
					print("enemy raise")
					enemy.raise()
			change_turn()
		pass
	pass

func _process(delta):
	if fight_is_on:
		check_state_machine()
	pass

# signals: on_player_action_done():
	# check_end_bet_turn()
# on_enemy_action_done():
	#check_end_bet_turn()