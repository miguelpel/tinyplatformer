# Fight

extends Node

# Enemy, Player, and pot, to be assigned:
var enemy
var player
var pot = [] # POT Follows the ObjRefs inside
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
#	start()
	pass

func start(enmcharacter): # set the player, the enemy, set the opponent, connect signals if needed
	print("starting")
	enemy = get_parent().get_parent().enemy
	if _get_player():
		player.get_node("Character").stand()
		player.PlayerUIFight.show()
		player.PlayerUIFight.disable()
		get_parent().get_parent().is_running = false
		player.get_node("Character").connect("all_actions_done", self, "on_opponent_actions_done")
		enmcharacter.connect("all_actions_done", self, "on_opponent_actions_done")
		player.get_node("Character").connect("disappeared", self, "on_enemy_disappeared")
		enmcharacter.connect("disappeared", self, "on_enemy_disappeared")
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
	if opponent == enemy:
		opponent = player
	else:
		opponent = enemy
	print("change opponent to: ", opponent.name)

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

#func _get_enemy():
#	var enmy = get_node("Enemy")
#	if enmy:
#		enemy = enmy
#		return true
#	else:
#		return false

func _get_player():
	var ply = get_parent().get_parent().player
	if ply:
		player = ply
		return true
	else:
		return false

# DISTRIBUTION FUNCTIONS
func distribute_first_round():
	print("distribute first round")
	distribution = 1
	$Hands.distribute_first_round()
	pass

func distribute_second_round():
	print("distribute second round")
	distribution = 2
	$Hands.distribute_another_round()
	pass

func distribute_last_round():
	print("distribute last round")
	distribution = 3
	$Hands.distribute_another_round()
	pass

func distribute():
	print("distribute")
#	change_opponent()
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

# BLINDS
#func set_blinds():
#	print("set blinds")
#	player.get_node("Character").give_blind()
#	enemy.get_node("Character").give_blind()
#	set_state("distributing blinds")

# BETTING FUNCTIONS
func start_bets():
	print("start bets, opponent: ", opponent.name, " bet turn: ", betTurn, " distribution: ", distribution)
#	print("opponent:")
#	print(opponent.name)
#	betTurn = 0
	set_state("waiting for opponent action")
	if opponent == player:
		player.PlayerUIFight.able()
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
	set_state("waiting for opponent action")
	if opponent == player:
		player.PlayerUIFight.able()
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

# POT LOGIC
func check_pot():
	print("check pot. Bet turn: ", betTurn)
	var potDiff = $Pot.get_amount_to_call()
	if potDiff == 0 and betTurn >= 1:
		distribute()
	else:
		continue_bets()
	pass

func get_pot_to_winner(winner):
	print("get pot to: ", winner.name)
	if winner != null:
		var winnerDir = winner.get_node("Character").direction
		$Pot.get_pot_to(winnerDir)
	else:
		$Pot.give_back_pot()
	winner = null
	pass


# ???
func fold(from):
	var winner
	if from == player:
		winner = enemy
	else:
		winner = player
	get_pot_to_winner(winner)
	set_delayed_reset()

# SHOW OFF AND WINNER
func set_showing_off():
	print("set showing off ", distribution)
	if $Hands.get_player_cards().size() < 5 or $Hands.get_enemy_cards().size() < 5:
		$Hands.distribute_remaining_cards()
		set_state("pre showing off")
	else:
		show_off()

func show_off():
	print("show off")
	reveal_cards()
	var winner = get_winner()
	get_pot_to_winner(winner)
	set_delayed_reset()
	pass

func reveal_cards():
	print("reveal cards")
	$Hands.reveal_all()
	pass

func get_winner():
	print("get winner")
	var results = $Hands.get_hands_values()
	if !results.player:
		print("No winner: can't get player hand value.")
		return
	if !results.enemy:
		print("no winner: can't get enemy hand value.")
		return
	if results.player > results.enemy:
		return player
	elif results.player < results.enemy:
		return enemy
	elif results.player == results.enemy:
		return null
	pass

# RESET

func set_delayed_reset():
	print("set delayed reset")
	timer = Timer.new()
	timer.set_wait_time(stateChangeDelay * 10)
	timer.connect("timeout",self,"reset")
	add_child(timer) #to process
	timer.start() #to start
	set_state("showing off")
	pass

func reset():
	print("reset")
	set_state("resetting")
	if timer:
		timer.stop()
	$Hands.remove_all_hands()
	distribution = 0
	betTurn = 0
	winner = null
	folded = false
	change_opponent()
	pass

func finish_fight(loser):
	print("fight finished!")
	player.PlayerUIFight.hide()
	reset()
	loser.Character.flee()
#	player.get_node("Character").run()
	set_state("finished")

func _process(delta):
#	if Input.is_action_just_pressed("ui_up"):
#		print(enemy.get_position())
	if Input.is_action_just_pressed("ui_left"):
		finish_fight(player)
	if Input.is_action_just_pressed("ui_right"):
		finish_fight(enemy)
#		player.get_node("Character").flee()
#		print(player.get_node("Character").direction)
#		enemy.get_node("Character").flee()
#		print(player.get_node("Character").direction)
#	if Input.is_action_just_pressed("ui_down"):
#		print("infos:")
#		print("opponent")
#		print(opponent.name)
#		print("current state:")
#		print(state)
#		$Pot.get_vebose_pot()
#		print($Pot.get_amount_to_call())
#		print("player naked?")
#		print(player.get_node("Character").is_naked())
#		print("enemy naked")
#		print(enemy.get_node("Character").is_naked())
		# plus check if characters are naked
	pass

# SIGNALS
func _on_Hands_completed():
	print("hands completed")
	if state == "distributing":
		start_bets()
	elif state == "pre showing off":
		show_off()
	elif state == "resetting":
		if enemy.get_node("Character").is_naked() or player.get_node("Character").is_naked():
#			print("someone is naked")
			if enemy.get_node("Character").is_naked():
				finish_fight(enemy)
			else:
				finish_fight(player)
		else:
			distribute()
	pass

func on_opponent_actions_done():
	print("opponent actions done")
	if enemy.Character.is_naked() or player.get_node("Character").is_naked():
#		print("someone is naked")
		set_showing_off()
#	elif state == "distributing blinds":
#		start_bets()
	elif state == "waiting for opponent action":
		check_pot()
	else:
		print("error in on opponent action done. state: ", state)
		return
	pass

func on_enemy_disappeared():
	print("enemy disappeared")
	enemy.get_node("Character").hide()
	if player.get_node("Character").is_running:
		player.get_node("Character").change_direction()
		pass
	# and everything
	pass