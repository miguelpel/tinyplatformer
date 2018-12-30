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

func get_hand_strength(EnemyHand, OpenPlayerHand, PlayerHandSize):
	# create a pack of cards
	print("step1")
	var enemyHandValue = get_parent().get_node("HandsLogic").calculate_hand_value(EnemyHand)
	var deck = []
	for nbr in range(52):
		deck.append(nbr)
	# set Score = 0
	var score = 0
	# remove known cards EnemyHand, OpenPlayerHand
	print("step2")
	for card in EnemyHand:
		deck.remove(card)
	for card in OpenPlayerHand:
		deck.remove(card)
	print(deck)
	
	#repeat 1000 times:
	print("step3")
	var i = 0
	while i <= 1000:
		# Shuffle the remaining pack
		var shuffledDeck = shuffle_deck(deck)
		# deal opponent hole cards,
		var playerHand = OpenPlayerHand.duplicate()
		for j in range(PlayerHandSize - playerHand.size()):
			playerHand.append(shuffledDeck[j])
		var playerHandValue = get_parent().get_node("HandsLogic").calculate_hand_value(playerHand)
		# evaluate all hands,
		# if you have the best hand, add 1 to Score.
		# if par, add 1/2
		if enemyHandValue > playerHandValue:
			score += 1
		elif enemyHandValue == playerHandValue:
			score += 0.5
		else:
			score += 0
		i += 1
	# hand strength = Score/1000
	print("step4")
#	print(score)
#	print(score / 1000)
#	var strength = score / 1000
#	print(strength)
	return score
	pass

func get_pot_dds():
	
	pass

func get_rate_of_return():
	pass

func get_decision():
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
