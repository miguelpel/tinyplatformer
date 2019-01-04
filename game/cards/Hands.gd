extends Control

var deck = []

# {0: 42}
# 0 : player hidden
# 1 : player open
# 2 : enemy hidden
# 3 : enemy open
var card_temp = []

var turn = 0

var distribution_done = false

var timer

func _ready():
	#hands = get_children()
	for nbr in range(52):
		deck.append(nbr)
	#print(randi()%(deck.size()))
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

func set_distribution_done_timer():
	if !distribution_done:
		timer = Timer.new()
		timer.connect("timeout",self,"set_distribution_done")
		add_child(timer)
		timer.wait_time = 0.5
		timer.start()

func set_distribution_done():
	timer.stop()
	distribution_done = true

func distribute_first_round():
	distribution_done = false
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
	distribution_done = false
	if turn > 2:
		return false
	turn += 1
	var player_card = {1: pick_card()}	
	var enemy_card = {3: pick_card()}
	card_temp = [player_card, enemy_card]
	pass

func reveal_all():
	$PlayerHand.reveal_all()
	$HandEnemy.reveal_all()
	pass

func pick_card():
	var i = deck.size() - 1
	var nbr = randi()%(i+1)
	var card_nbr = deck[nbr]
	deck.remove(nbr)
	return card_nbr

func get_hands_values():
	$PlayerHand.get_hand_value()
	$HandEnemy.get_hand_value()
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
	pass

func deal_plus_card_to_player():
	var player_card = {0: pick_card()}
	card_temp = [player_card]
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
		set_distribution_done_timer()
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func _on_Button_pressed():
	distribute_first_round()
	pass # replace with function body

func _on_Button2_pressed():
	distribute_another_round()
	pass # replace with function body

func _on_Button4_pressed():
	reveal_all()
	pass # replace with function body

func _on_Button5_pressed():
	get_hands_values()
	pass # replace with function body

func _on_Button6_pressed():
	remove_all_hands()
	pass # replace with function body

func _on_Button7_pressed():
	deal_plus_card_to_player()
	pass # replace with function body

func _on_Button3_pressed():
	#get hand strength
	get_enemy_hand_strength()
	pass # replace with function body
