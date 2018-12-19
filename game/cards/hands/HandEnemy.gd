# Hand Enemy
extends VBoxContainer

var Hidden_Cards_Nodes

var Open_Cards_Nodes

var cards = []

func _ready():
	Hidden_Cards_Nodes = [$HiddenCards.get_node("Card3"),
	$HiddenCards.get_node("Card2"),
	$HiddenCards.get_node("Card")]
	
	Open_Cards_Nodes = [$OpenCards.get_node("Card3"),
	$OpenCards.get_node("Card2"),
	$OpenCards.get_node("Card")]
	pass

func get_hand_value():
	print("enemy hand:")
	for card in cards:
		var cardValue = (card%13) + 2
		var suitNbr = card/13
		var suit
		match suitNbr:
			0: suit = "C"
			1: suit = "D"
			2: suit = "H"
			3: suit = "S"
		print([cardValue, suit])
	pass

func add_hidden_card(cardNbr):
	#check if the first card isn't dealt
	cards.append(cardNbr)
	var i = 0
	while i<3:
		var card = Hidden_Cards_Nodes[i]
		if card:
			if card.dealt:
				i += 1
			else:
				card.set_card(cardNbr, "hidden")
				break
	pass

func add_open_card(cardNbr):
	cards.append(cardNbr)
	var i = 0
	while i<3:
		var card = Open_Cards_Nodes[i]
		if card:
			if card.dealt:
				i += 1
			else:
				card.set_card(cardNbr)
				break
	pass

func reveal_all():
	for card in Hidden_Cards_Nodes:
		if card.dealt:
			card.reveal()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
