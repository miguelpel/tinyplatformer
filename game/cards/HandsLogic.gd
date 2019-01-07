extends Node

func _ready():
	pass

func calculate_hand_value(cardsArray):
#	print(cardsArray)
	if typeof(cardsArray) != TYPE_ARRAY or cardsArray.size() < 5:
		print("can't get value of: ", cardsArray)
		return false
	var cdArrOfArr = create_cards_array(cardsArray)
	var handType
	var straight_flush = check_for_straight_flush(cdArrOfArr)
	var quads = check_for_quads(cdArrOfArr)
	var full = check_for_full(cdArrOfArr)
	var flush = check_for_flush(cdArrOfArr)
	var straight = check_for_straight(cdArrOfArr)
	var trips = check_for_trips(cdArrOfArr)
	var pairs = check_for_pair(cdArrOfArr)
	if straight_flush:
#		print("straight flush")
		return convert_array_in_number(straight_flush)
	elif quads:
#		print("quads")
		return convert_array_in_number(quads)
	elif full:
#		print("full")
#		print(full)
		return convert_array_in_number(full)
	elif flush:
#		print("flush")
#		print(flush, cdArrOfArr)
		var convertedArray = convert_cards_array(cdArrOfArr, flush)
		return convert_array_in_number(convertedArray)
	elif straight:
#		print("straight")
#		print(straight)
		var convertedArray = convert_cards_array(cdArrOfArr, straight)
		return convert_array_in_number(convertedArray)
	elif trips:
#		print("trips")
#		print(trips)
		var convertedArray = convert_cards_array(cdArrOfArr, trips)
		return convert_array_in_number(convertedArray)
	elif pairs:
#		print("pair(s)")
#		print(testCardArray)
		var convertedArray = convert_cards_array(cdArrOfArr, pairs)
		return convert_array_in_number(convertedArray)
	else:
#		print("nothing")
		var convertedArray = convert_cards_array(cdArrOfArr)
		return convert_array_in_number(convertedArray)
	return false


class MyCustomSorter:
	static func sort(a, b):
		if a[0] > b[0]:
			return true
		return false

func create_cards_array(arr):
	var cards_array = []
	for card in arr:
		var cardValue = (card%13) + 2
		var suitNbr = card/13
		cards_array.append([cardValue, suitNbr])
	cards_array.sort_custom(MyCustomSorter, "sort")
	return cards_array
	pass

#DOESN'T WORK! Remove double !
func check_for_straight_flush(cardArray):
	var straight_flush = []
	var straight = check_for_straight(cardArray)
	var flush = check_for_flush(cardArray)
#	print("straight...")
#	print(straight)
#	print("flush...")
#	print(flush)
	if straight and flush:
		straight_flush.append(8)
		straight_flush.append(straight[1])
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
			quads.append(refHand)
			break
	if quads.size() > 1:
		return quads
	return false
	pass

#WORKS!
func check_for_full(cardArray):
	var testArr = cardArray.duplicate()
	var full = []
#	print(testArr)
	for i in range(testArr.size() - 2):
		var refHand = testArr[i]
#		print(refHand)
		if refHand[0] == testArr[i+1][0] and refHand[0] == testArr[i+2][0]:
			full.append(5)
			full.append(refHand)
			testArr.remove(i)
			testArr.remove(i)
			testArr.remove(i)
			break
	for i in range(testArr.size()-1):
		var cardA = testArr[i]
		var cardB = testArr[i+1]
		if cardA[0] == cardB[0]:
			full.append(cardA)
			break
	if full.size() > 2:
		return full
		# [6, tripsIdx, pairIdx] 
	return false
	pass

#DOESN'T WORK! Remove double !
func check_for_flush(cardArray):
	var flush = []
	var clubs = []
	var diamonds = []
	var hearts = []
	var spades = []
	for i in range(cardArray.size()):
		if cardArray[i][1] == 0:
			clubs.append(cardArray[i])
		elif cardArray[i][1] == 1:
			diamonds.append(cardArray[i])
		elif cardArray[i][1] == 2:
			hearts.append(cardArray[i])
		elif cardArray[i][1] == 3:
			spades.append(cardArray[i])
	if clubs.size() >= 5:
		flush.append(5)
		flush.append(clubs[0])
	if diamonds.size() >= 5:
		flush.append(5)
		flush.append(diamonds[0])
	if hearts.size() >= 5:
		flush.append(5)
		flush.append(hearts[0])
	if spades.size() >= 5:
		flush.append(5)
		flush.append(spades[0])
	if flush.size() > 1:
		return flush
	return false
	pass

#DOESN'T WORK! Remove double !
func check_for_straight(cardArray):
	var straight = []
	var arr = remove_double(cardArray)
	for i in range(arr.size() - 4):
		var refHand = arr[i]
		if (refHand[0] == arr[i+1][0]+1) and (refHand[0] == arr[i+2][0]+2) and (refHand[0] == arr[i+3][0]+3) and (refHand[0] == arr[i+4][0]+4):
			straight.append(4)
			straight.append(refHand)
			break
	if straight.size() > 1:
		return straight
	return false
	pass

#WORKS!
func check_for_trips(cardArray):
#	print(cardArray)
	var trips = []
	for i in range(cardArray.size() - 2):
		var refHand = cardArray[i]
		if refHand[0] == cardArray[i+1][0] and refHand[0] == cardArray[i+2][0]:
			trips.append(3)
			trips.append(refHand)
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
			pairs.append(cardA)
	if pairs.size() > 0:
		if pairs.size() > 1:
			pairs.push_front(2)
		else:
			pairs.push_front(1)
		return pairs
	return false
	pass

func convert_cards_array(cardArray, typeArray = false):
#	print(cardArray)
#	print(typeArray)
	var retArray = []
	var type = 0
	if typeArray:
		type = typeArray[0]
		typeArray.remove(0)
		if typeArray.size() >= 1:
			# find index of card in type
			for card in typeArray:
				#find index of card in cardArray
				var indx = cardArray.find(card)
				retArray.append(card[0])
				cardArray.remove(indx)
	for card in cardArray:
		retArray.append(card[0])
	retArray.push_front(type)
	while retArray.size() < 7:
		retArray.append(0)
	return retArray
	pass

func convert_array_in_number(numberArray):
#	print("array_to_number:")
#	print(numberArray)
	var multiplier_array = [
	0x1000000,
	0x0100000,
	0x0010000,
	0x0001000,
	0x0000100,
	0x0000010,
	0x0000001
	]
	var returnNbr = 0
	for elmIdx in numberArray.size():
		if typeof(numberArray[elmIdx]) == TYPE_ARRAY:
			returnNbr += numberArray[elmIdx][0] * multiplier_array[elmIdx]
		else:
			returnNbr += numberArray[elmIdx] * multiplier_array[elmIdx]
	return returnNbr
	pass

func remove_double(cardArr):
	var retArr = cardArr.duplicate()
	var doubleIdx = false
	for i in range(retArr.size()-1):
		if retArr[i][0] == retArr[i+1][0]:
			doubleIdx = i+1
	if doubleIdx:
		retArr.remove(doubleIdx)
	return retArr

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
