# Hand Player
extends VBoxContainer

var Hidden_Cards_nodes

var Open_Cards_nodes

var cards = []

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
	var value = calculate_hand_value(cards)
	#print(value)
	pass

func add_hidden_card(cardNbr):
	#check if the first card isn't dealt
	cards.append(cardNbr)
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

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func calculate_hand_value(cardsArray):
	var cdArrOfArr = []
	for card in cardsArray:
		var cardValue = (card%13) + 2
		var suitNbr = card/13
		cdArrOfArr.append([cardValue, suitNbr])
		
	var testCardArray = [[7,0],[5,1],[8,1],[9,3],[8,2],[6,4]]
	testCardArray.sort_custom(MyCustomSorter, "sort")
	
	cdArrOfArr.sort_custom(MyCustomSorter, "sort")
	# check for the handtype.
	var handType
	
	print(testCardArray)
	var straight_flush = check_for_straight_flush(testCardArray)
	var quads = check_for_quads(testCardArray)
	var full = check_for_full(testCardArray)
	var flush = check_for_flush(testCardArray)
	var straight = check_for_straight(testCardArray)
	var trips = check_for_trips(testCardArray)
	var pairs = check_for_pair(testCardArray)
	if straight_flush:
		print("straight flush")
		print(straight_flush)
		print(convert_array_in_number(straight_flush))
		print(0x8800000)
	elif quads:
		print("quads")
		print(quads)
		print(convert_array_in_number(quads))
		print(0x7500000)
	elif full:
		print("full")
		print(full)
		print(convert_array_in_number(full))
		print(0x5260000)
	elif flush:
		print("flush")
		print(flush)
		print(testCardArray)
		var convertedArray = convert_cards_array(testCardArray, flush)
		print(convertedArray)
		print(convert_array_in_number(convertedArray))
		print(0x5ba9620)
	elif straight:
		print("straight")
		print(straight)
		print(testCardArray)
		var convertedArray = convert_cards_array(testCardArray, straight)
		print(convertedArray)
		print(convert_array_in_number(convertedArray))
		print(0x4543210)
	elif trips:
		print("trips")
		print(trips)
		print(testCardArray)
		var convertedArray = convert_cards_array(testCardArray, trips)
		print(convertedArray)
		print(convert_array_in_number(convertedArray))
		print(0x3266220)
	elif pairs:
		print("double pair")
		print(testCardArray)
		var convertedArray = convert_cards_array(testCardArray, pairs)
		print(convertedArray)
		print(convert_array_in_number(convertedArray))
		print(0x2929420)
	else:
		print("nothing")
#	if check_for_straight_flush(cdArrOfArr):
#		handType = 8
#	elif check_for_quads(cdArrOfArr):
#		handType = 7
#	elif check_for_full_house(cdArrOfArr):
#		handType = 6
#	elif check_for_flush(cdArrOfArr):
#		handType = 5
#	elif check_for_straight(cdArrOfArr):
#		handType = 4
#	elif check_for_trips(cdArrOfArr):
#		handType = 3
#	elif check_for_two_pairs(cdArrOfArr):
#		handType = 2
#	elif check_for_pair(cdArrOfArr):
#		handType = 1
#	else:
#		handType = 0
	return cdArrOfArr


class MyCustomSorter:
	static func sort(a, b):
		if a[0] > b[0]:
			return true
		return false

#DOESN'T WORK! Remove double !
func check_for_straight_flush(cardArray):
	var straight_flush = []
	for i in range(cardArray.size() - 4):
		var refHand = cardArray[i]
		var straight = (refHand[0] == cardArray[i+1][0]+1 and refHand[0] == cardArray[i+2][0]+2 and refHand[0] == cardArray[i+3][0]+3 and refHand[0] == cardArray[i+4][0]+4)
		var flush = (refHand[1] == cardArray[i+1][1] and refHand[1] == cardArray[i+2][1] and refHand[1] == cardArray[i+3][1] and refHand[1] == cardArray[i+4][1])
		print(straight)
		print(flush)
		if straight and flush:
			straight_flush.append(8)
			straight_flush.append(refHand[0])
			break
	if straight_flush.size() > 1:
		return straight_flush
	return false
	pass

func check_for_quads(cardArray):
	var quads = []
	for i in range(cardArray.size() - 3):
		var refHand = cardArray[i]
		if refHand[0] == cardArray[i+1][0] and refHand[0] == cardArray[i+2][0] and refHand[0] == cardArray[i+3][0]:
			quads.append(7)
			quads.append(refHand[0])
			break
	if quads.size() > 1:
		return quads
	return false
	pass

#WORKS!
func check_for_full(cardArray):
	var testArr = cardArray
	var full = []
	print(testArr)
	for i in range(testArr.size() - 2):
		var refHand = testArr[i]
		print(refHand)
		if refHand[0] == testArr[i+1][0] and refHand[0] == testArr[i+2][0]:
			full.append(5)
			full.append(refHand[0])
			testArr.remove(i)
			testArr.remove(i)
			testArr.remove(i)
			break
	for i in range(testArr.size()-1):
		var cardA = testArr[i]
		var cardB = testArr[i+1]
		if cardA[0] == cardB[0]:
			full.append(cardA[0])
			break
	if full.size() > 2:
		return full
		# [6, tripsIdx, pairIdx] 
	return false
	pass

#DOESN'T WORK! Remove double !
func check_for_flush(cardArray):
	var flush = []
	for i in range(cardArray.size() - 4):
		var refHand = cardArray[i]
		if refHand[1] == cardArray[i+1][1] and refHand[1] == cardArray[i+2][1] and refHand[1] == cardArray[i+3][1] and refHand[1] == cardArray[i+4][1]:
			flush.append(5)
			flush.append(i)
			break
	if flush.size() > 1:
		return flush
	return false
	pass

#DOESN'T WORK! Remove double !
func check_for_straight(cardArray):
	var straight = []
	for i in range(cardArray.size() - 4):
		var refHand = cardArray[i]
		if (refHand[0] == cardArray[i+1][0]+1) and (refHand[0] == cardArray[i+2][0]+2) and (refHand[0] == cardArray[i+3][0]+3) and (refHand[0] == cardArray[i+4][0]+4):
			straight.append(4)
			straight.append(i)
			break
	if straight.size() > 1:
		return straight
	return false
	pass

#WORKS!
func check_for_trips(cardArray):
	print(cardArray)
	var trips = []
	for i in range(cardArray.size() - 2):
		var refHand = cardArray[i]
		if refHand[0] == cardArray[i+1][0] and refHand[0] == cardArray[i+2][0]:
			trips.append(3)
			trips.append(i)
			break
	if trips.size() > 1:
		return trips
	return false
	pass

#WORKS!
func check_for_pair(ArrOfArr):
	var cardA
	var cardB
	var pairs = []
	for i in range(ArrOfArr.size()-1):
		cardA = ArrOfArr[i]
		cardB = ArrOfArr[i+1]
		if cardA[0] == cardB[0]:
			pairs.append(i)
	if pairs.size() > 0:
		if pairs.size() > 1:
			pairs.push_front(2)
		else:
			pairs.push_front(1)
		return pairs
	return false
	pass

func convert_cards_array(cardArray, typeArray = false):
	var retArray = []
	var type = 0
	if typeArray:
		type = typeArray[0]
		typeArray.remove(0)
		if typeArray.size() >= 1:
			for idx in typeArray:
				retArray.append(cardArray[idx][0])
				cardArray.remove(idx)
	#print(cardArray)
	for card in cardArray:
		retArray.append(card[0])
	retArray.push_front(type)
	if retArray.size() < 7:
		retArray.append(0)
	return retArray
	pass

func convert_array_in_number(numberArray):
	var type = 0x1000000
	var card1 = 0x0100000
	var card2 = 0x0010000
	var card3 = 0x0001000
	var card4 = 0x0000100
	var card5 = 0x0000010
	var card6 = 0x0000001
	var returnNbr = 0
	returnNbr += numberArray[0] * type
	returnNbr += numberArray[1] * card1
	if numberArray.size() > 2:
		returnNbr += numberArray[2] * card2
	if numberArray.size() > 3:
		returnNbr += numberArray[3] * card3
	if numberArray.size() > 4:
		returnNbr += numberArray[4] * card4
	if numberArray.size() > 5:
		returnNbr += numberArray[5] * card5
	if numberArray.size() > 6:
		returnNbr += numberArray[6] * card6
	return returnNbr
	pass

#func check_for_straight_flush(ArrOfArr):
#	var counter = 0
#	var refMax = ArrOfArr[0]
#	var refMin = ArrOfArr[ArrOfArr.size() -1]
##	 for i in range(1, 4):
##		if ArrOfArr[i][i]
#
#	# return true or false
#	pass
