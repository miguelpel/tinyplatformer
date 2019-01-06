# Fight

extends Node

# Enemy, Player, and pot, to be assigned:
var enemy
var player
var pot
var winner = null

# The opponent who's turn to bet is on !!! get the ref to the object
var opponent

# The distribution turn (0, 1, 2, 3), actually on
var distribution = 0
var betTurn = 0
var folded = false # to follow if one of the opponents is folded

var state = "sleeping"
var stateChangeDelay = 1 # 1 second, to delay the change of state
var nextState # to apply the delay
var timer

func _ready():
#	randomize()
	pot = $Pot
	start()
	pass

func start(): # set the player, the enemy, set the opponent, connect signals if needed
	if get_player() and get_enemy():
		player.connect("all_actions_done", self, "on_opponent_actions_done")
		enemy.connect("all_actions_done", self, "on_opponent_actions_done")
		set_opponent()
		set_state("ready")
		distribute()
		pass
	else:
		print("error getting opponents")
	pass

func set_opponent():
	var nbr = randi()%2
	if nbr == 0:
		opponent = player
	else:
		opponent = enemy
	pass

func change_opponent():
	print("change opponent")
	if opponent == enemy:
		opponent = player
	else:
		opponent = enemy
	print(opponent.name)

func set_state(st): # change state imediately
	state = st
	nextState = null

func set_delayed_state(st): # change state after waiting time stateChangeDelay
	nextState = st
	timer = Timer.new()
	timer.set_wait_time(stateChangeDelay)
	timer.connect("timeout",self,"_on_timer_timeout")
	add_child(timer) #to process
	timer.start() #to start
	pass

func _on_timer_timeout(): # timeout for set_delayed_state()
	timer.stop()
	state = nextState
	nextState = null

func get_enemy():
	var enmy = get_parent().get_parent().enemy
	if enmy:
		enemy = enmy
		return true
	else:
		return false

func get_player():
	var ply = get_parent().get_parent().player
	if ply:
		player = ply
		return true
	else:
		return false

func distribute_first_round():
	distribution = 1
	$Hands.distribute_first_round()
	pass

func distribute_second_round():
	distribution = 2
	$Hands.distribute_another_round()
	pass

func distribute_last_round():
	distribution = 3
	$Hands.distribute_another_round()
	pass

func distribute():
	change_opponent()
	betTurn = 0
	if distribution == 0:
		distribute_first_round()
		set_state("distributing")
	elif distribution == 1:
		distribute_second_round()
		set_state("distributing")
	elif distribution == 2:
		distribute_last_round()
		set_state("distributing")
	elif distribution == 3:
		show_off()
	pass

func set_blinds():
	player.remove_next_cloth()
	enemy.remove_next_cloth()
	set_state("distributing blinds")

func start_bets():
	print("start bets")
	print("opponent:")
	print(opponent.name)
	betTurn = 1
	set_state("waiting for opponent action")
	if opponent == player:
		return
	elif opponent == enemy:
		timer = Timer.new()
		timer.set_wait_time(stateChangeDelay)
		timer.connect("timeout",self,"get_enemy_decision")
		add_child(timer) #to process
		set_state("waiting for enemy timout finished")
		timer.start()
	pass

func continue_bets():
	print("continue bets")
	change_opponent()
	betTurn += 1
	if opponent == player:
		return
	elif opponent == enemy:
		timer = Timer.new()
		timer.set_wait_time(stateChangeDelay)
		timer.connect("timeout",self,"get_enemy_decision")
		add_child(timer) #to process
		set_state("waiting for enemy timout finished")
		timer.start()
	pass

func get_enemy_decision():
	print("getting enemy decision")
	timer.stop()
	set_state("waiting for opponent action")
	enemy.get_decision($Hands, $Pot)

func check_pot():
	print("check pot")
	print("turn:")
	print(betTurn)
	var potDiff = $Pot.get_amount_to_call()
	if potDiff == 0 and betTurn > 2:
		distribute()
	else:
		continue_bets()
	pass

func fold(from):
	if from == player:
		winner = enemy
	else:
		winner = player
	set_showing_off()

func set_showing_off():
	if distribution < 3:
		$Hands.distribute_remaining_cards()
		set_state("pre showing off")
	else:
		show_off()

func show_off():
	reveal_cards()
	if winner == null:
		winner = get_winner()
	get_pot_to_winner(winner)
	timer = Timer.new()
	timer.set_wait_time(stateChangeDelay * 5)
	timer.connect("timeout",self,"reset")
	add_child(timer) #to process
	timer.start() #to start
	set_state("showing off")
	pass

func reveal_cards():
	$Hands.reveal_all()
	pass

func get_winner():
	var results = $Hands.get_hands_values()
	if results.player > results.enemy:
		return player
	elif results.player < results.enemy:
		return enemy
	elif results.player == results.enemy:
		return null
	pass

func get_pot_to_winner(winner):
	if winner != null:
		var winnerDir = winner.get_node("Character").direction
		$Pot.get_pot_to(winnerDir)
	else:
		$Pot.give_back_pot()
	winner = null
	pass

func reset():
	timer.stop()
	$Hands.remove_all_hands()
	distribution = 0
	betTurn = 0
	winner = null
	distribute()
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		print("infos:")
		print("opponent")
		print(opponent.name)
		print("current state:")
		print(state)
		print("pot value")
		print($Pot.get_amount_to_call())
		print("player naked?")
		print(player.is_naked())
		print("enemy naked")
		print(enemy.is_naked())
		# plus check if characters are naked
	if enemy.is_naked() or player.is_naked():
		print("someone is naked")
		set_showing_off()
	pass

# signals: on_player_action_done():
	# check_end_bet_turn()
# on_enemy_action_done():
	#check_end_bet_turn()

func _on_Hands_completed():
	if state == "distributing":
		if distribution == 1:
			set_blinds()
		elif distribution == 2 or distribution == 3:
			start_bets()
	elif state == "pre showing off":
		show_off()
	pass

func on_opponent_actions_done():
	if state == "distributing blinds":
		start_bets()
	elif state == "waiting for opponent action":
		check_pot()
	else:
		return
	pass