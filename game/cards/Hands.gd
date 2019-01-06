extends Control

var deck = []

# {0: 42}
# 0 : player hidden
# 1 : player open
# 2 : enemy hidden
# 3 : enemy open
var card_temp = []

var turn = 0

signal completed

var timer

func _ready():
	#hands = get_children()
	for nbr in range(52):
		deck.append(nbr)
	#print(randi()%(deck.size()))
	shuffle_deck()
	pass

func reset_deck():
	deck = []
	for nbr in range(52):
		deck.append(nbr)
	shuffle_deck()
	pass

func shuffle_deck():
	randomize()
	var ret_deck = deck
	var i = ret_deck.size() - 1
	var j
	var x
	while i>0:
		j = randi()%(i+1)# => 0 to i+1???
		x = ret_deck[i];
		ret_deck[i] = ret_deck[j]
		ret_deck[j] = x;
		i -= 1
	deck = ret_deck

func set_completion_timer():
	timer = Timer.new()
	timer.connect("timeout",self,"emit_completed")
	add_child(timer)
	timer.wait_time = 0.5
	timer.start()

func emit_completed():
	timer.stop()
	emit_signal("completed")

func distribute_first_round():
	if turn > 0:
		return false
	turn += 1
	# pick 6 cards + number where they go
	# 0 : player hidden
	# 1 : player open
	# 2 : enemy hidden
	# 3 : enemy open
	# pack those 6 cards in the card_temp
	# start Timer 
	var player_first_card = {0: pick_card()}
	var player_second_card = {0: pick_card()}
	var player_third_card = {1: pick_card()}
	
	var enemy_first_card = {2: pick_card()}
	var enemy_second_card = {2: pick_card()}
	var enemy_third_card = {3: pick_card()}
	
	card_temp = [player_first_card,
	player_second_card,
	player_third_card,
	enemy_first_card,
	enemy_second_card,
	enemy_third_card]
	pass

func distribute_another_round():
	if turn > 2:
		return false
	turn += 1
	var player_card = {1: pick_card()}	
	var enemy_card = {3: pick_card()}
	card_temp = [player_card, enemy_card]
	set_completion_timer()
	pass

func distribute_remaining_cards():
	# for remaining card in openCards of each hand.
	var playerRemainingCards = 3 - $PlayerHand.openCards.size()
	var enemyRemainingCards = 3 - $HandEnemy.openCards.size()
	for i in range(playerRemainingCards):
		var player_card = {1: pick_card()}
		card_temp.append(player_card)
	for j in range(enemyRemainingCards):
		var enemy_card = {3: pick_card()}
		card_temp.append(enemy_card)
	set_completion_timer()
	pass

func reveal_all():
	$PlayerHand.reveal_all()
	$HandEnemy.reveal_all()
	set_completion_timer()
	pass

func pick_card():
	var i = deck.size() - 1
	var nbr = randi()%(i+1)
	var card_nbr = deck[nbr]
	deck.remove(nbr)
	return card_nbr

func get_hands_values():
	var playerHandValue = $PlayerHand.get_hand_value()
	var enemyHandValue = $HandEnemy.get_hand_value()
	var retobj = {"player": playerHandValue, "enemy": enemyHandValue}
	return retobj
	pass

func deal(cardObj):
	if cardObj.has(0):
		$PlayerHand.add_hidden_card(cardObj[0])
	elif cardObj.has(1):
		$PlayerHand.add_open_card(cardObj[1])
	elif cardObj.has(2):
		$HandEnemy.add_hidden_card(cardObj[2])
	elif cardObj.has(3):
		$HandEnemy.add_open_card(cardObj[3])
	card_temp.erase(cardObj)
#	print("card_temp size:")
#	print(card_temp.size())
	#erase this cardObj
	pass

func remove_all_hands():
	$PlayerHand.remove_all()
	$HandEnemy.remove_all()
	turn = 0
	reset_deck()
	set_completion_timer()
	pass

func deal_plus_card_to_player():
	var player_card = {0: pick_card()}
	card_temp = [player_card]
	set_completion_timer()
	pass

func get_enemy_cards():
	return $HandEnemy.cards
	pass

func get_player_open_cards():
	return $PlayerHand.openCards
	pass

func get_player_hand_size():
	return $PlayerHand.cards.size()

#func get_enemy_hand_strength():
#	print("getting enemy hand strength")
#	var enmHand = $HandEnemy.cards
#	var opPlayerHand = $PlayerHand.openCards
#	var playerHandSize = $PlayerHand.cards.size()
#	var enmdecision = $AI.get_ai_decision(enmHand, opPlayerHand, playerHandSize)
#	print("Enemy hand decision:")
#	print(enmdecision)
#	pass

func _process(delta):
	if card_temp.size() > 0:
#		print("deal")
#		print(card_temp[0])
		deal(card_temp[0])
		pass
	else:
		set_completion_timer()
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
