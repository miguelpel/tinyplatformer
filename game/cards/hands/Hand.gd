# Hand Player
extends VBoxContainer

var Hidden_Cards_nodes

var Open_Cards_nodes

var cards = []
var openCards = []
var hiddenCards = []

var hand_value = 0

func _ready():
	Hidden_Cards_nodes = [$HiddenCards.get_node("Card"),
	$HiddenCards.get_node("Card2"),
	$HiddenCards.get_node("Card3")]
	
	Open_Cards_nodes = [$OpenCards.get_node("Card"),
	$OpenCards.get_node("Card2"),
	$OpenCards.get_node("Card3")]
	pass

func get_hand_value():
	print("player hand:")
	print(cards.size())
	var hand_value = get_parent().get_node("HandsLogic").calculate_hand_value(cards)
	print(hand_value)
	pass

func add_hidden_card(cardNbr):
	#check if the first card isn't dealt
	cards.append(cardNbr)
	hiddenCards.append(cardNbr)
	var i = 0
	while i<3:
		var card = Hidden_Cards_nodes[i]
		if card:
			if card.dealt:
				i += 1
			else:
				card.set_card(cardNbr, "mid")
				break
	pass

func add_open_card(cardNbr):
	cards.append(cardNbr)
	openCards.append(cardNbr)
	var i = 0
	while i<3:
		var card = Open_Cards_nodes[i]
		if card:
			if card.dealt:
				i += 1
			else:
				card.set_card(cardNbr)
				break
	pass

func reveal_all():
	for card in Hidden_Cards_nodes:
		if card.dealt:
			card.reveal()

func remove_all():
	for card in Hidden_Cards_nodes:
		if card.dealt:
			card.erase()
	for card in Open_Cards_nodes:
		if card.dealt:
			card.erase()
	cards = []
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
