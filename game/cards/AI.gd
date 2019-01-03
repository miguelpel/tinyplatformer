extends Node

var level = 0
var deck = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_level(nbr):
	# to set the level of the AI
	pass

func get_ai_decision(enemyHand, openPlayerHand, playerHandSize, potValue = 1, amountToCall = 0):
	var handStrength = get_hand_strength(enemyHand, openPlayerHand, playerHandSize)
#	print(handStrength)
	var potOdds = get_pot_odds(potValue)
#	print(potOdds)
	var rateOfReturn = get_rate_of_return(handStrength, potOdds)
#	print(rateOfReturn)
	var decision = get_FCR(rateOfReturn, amountToCall)
	# return fold / call / raise
	return decision
	pass

func get_hand_strength(EnemyHand, OpenPlayerHand, PlayerHandSize):
	# create a pack of cards
	var handSize = 5
#	print("step1")
#	print(EnemyHand)
#	print(OpenPlayerHand)
	if PlayerHandSize < 5:
		PlayerHandSize = 5
#	print(EnemyHand.size())
#	print(PlayerHandSize)
#	var enemyHandValue = get_parent().get_node("HandsLogic").calculate_hand_value(EnemyHand)
	var deck = []
	for nbr in range(52):
		deck.append(nbr)
	# set Score = 0
	var score = 0
	# remove known cards EnemyHand, OpenPlayerHand
#	print("step2")
	for card in EnemyHand:
		deck.erase(card)
	for card in OpenPlayerHand:
		deck.erase(card)
	
	#repeat 1000 times:
#	print("step3")
	var loops = 1000
	var i = 0
	while i < loops:
		# Shuffle the remaining pack
		var shuffledDeck = shuffle_deck(deck)
		# deal opponent hole cards,
		var playerHand = OpenPlayerHand.duplicate()
		var enemyHand = EnemyHand.duplicate()
		for j in range(PlayerHandSize - playerHand.size()):
			playerHand.append(shuffledDeck[j])
			shuffledDeck.remove(j)
		for k in range(handSize - enemyHand.size()):
			enemyHand.append(shuffledDeck[k])
			shuffledDeck.remove(k)
		var playerHandValue = get_parent().get_node("HandsLogic").calculate_hand_value(playerHand)
		var enemyHandValue = get_parent().get_node("HandsLogic").calculate_hand_value(enemyHand)
#
#		# evaluate all hands,
#		# if you have the best hand, add 1 to Score.
#		# if par, add 1/2
#
		if enemyHandValue > playerHandValue:
			score += 1
		elif enemyHandValue == playerHandValue:
			score += 0.5
		else:
			score += 0
		i += 1
	# hand strength = Score/1000
#	print("step4")
#	print(score)
#	print(score / 1000)
#	var strength = score / 1000
#	print(strength)
	return score
	pass

func get_pot_odds(pot):
	var p_o = 1000 / (1+pot)
	return p_o
	pass

func get_rate_of_return(handStength, potOdds):
	var hS = float(handStength)
	var pO = float(potOdds)
	var r_o_r = float(hS / pO)
	return r_o_r
	pass

func get_FCR(r_o_r, am_to_call):
	var fold = 0
	var call = 0
	var raise = 0
	var rdmNbr = randi()%101+1 #returns an int from 1 to 100 ???
	var decision
	if r_o_r < 0.8:
		fold = 95
		call = 0
		raise = 5
	elif r_o_r < 1.0:
		fold = 80
		call = 5
		raise = 15
	elif r_o_r < 1.3:
		fold = 0
		call = 60
		raise = 40
	else:
		fold = 0
		call = 30
		raise = 70
	
#	print("fold:")
#	print(fold)
#	print("call:")
#	print(call)
#	print("raise:")
#	print(raise)
#	print(rdmNbr)
#	print("decision:")
	
	if rdmNbr < fold:
		decision = "fold"
	elif rdmNbr < (fold + call):
		decision = "call"
	else:
		decision = "raise"
	
	if decision == "fold" and am_to_call == 0:
		decision = "call"
	
	return decision
	pass

func shuffle_deck(dk):
	randomize()
	var ret_deck = dk.duplicate()
	var i = ret_deck.size() - 1
	var j
	var x
	while i>0:
		j = randi()%(i+1)# => 0 to i+1???
		x = ret_deck[i];
		ret_deck[i] = ret_deck[j]
		ret_deck[j] = x;
		i -= 1
	return ret_deck

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
