extends Control

var deck = []

# {0: 42}
# 0 : player hidden
# 1 : player open
# 2 : enemy hidden
# 3 : enemy open
var card_temp = []

var hands

func _ready():
	#hands = get_children()
	for nbr in range(52):
		deck.append(nbr)
	#print(randi()%(deck.size()))
	shuffle_deck()
	pass

func shuffle_deck():
	var passes = randi()%11+1
	while passes >0:
		shuffle_shuffle()
		passes -= 1
	print(deck)
	pass

func shuffle_shuffle():
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

func distribute_first_round():
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
	print("card_temp size:")
	print(card_temp.size())
	#erase this cardObj
	pass

func _process(delta):
	if card_temp.size() > 0:
		print("deal")
		print(card_temp[0])
		deal(card_temp[0])
		pass
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
