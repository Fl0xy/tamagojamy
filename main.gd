extends Node

enum place {HOME, WEB, WORK}

var homePositions = [Vector2(0,0), Vector2(51,0), Vector2(102,0), Vector2(153,0)]
var webPositions = [Vector2(0,51), Vector2(51,51), Vector2(102,51), Vector2(153,51)]
var workPositions = [Vector2(0,102), Vector2(51,102), Vector2(102,102), Vector2(153,102)]

var curPlace = place.HOME;
var curIndex = 0

signal position_changed(new_pos)
signal place_changed(new_place)
signal homePosition_changed(new_pos)

#################### position shit ####################
func curPosition():
	match curPlace:
		place.HOME:
			return homePositions[curIndex]
		place.WORK:
			return workPositions[curIndex]
		place.WEB:
			return webPositions[curIndex]
	

#################### web shit ####################
var webEntryPlace
var webEntryIndex
func enterWeb():
	webEntryIndex = curIndex;
	webEntryPlace = curPlace;
	curPlace = place.WEB
	curIndex = 0
	emitSingals()
	
func exitWeb():
	curPlace = webEntryPlace
	curIndex = webEntryIndex
	emitSingals()

#################### work shit ####################
var workEntryPlace
var workEntryIndex
func enterWork():
	workEntryPlace = curPlace
	workEntryIndex = curIndex
	curPlace = place.WORK
	curIndex = 0
	emitSingals()
	
func exitWork():
	curPlace = workEntryPlace
	curIndex = workEntryIndex
	emitSingals()

#################### logic shit ####################
func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		if curIndex < curPlaceMax():
			curIndex = curIndex+1
		else:
			curIndex = 0
		emitSingals()
		return
		
	if Input.is_action_just_pressed("ui_left"):
		if curIndex > 0:
			curIndex = curIndex-1
		else:
			curIndex = curPlaceMax()
		emitSingals()

#################### Helper shit ####################
func emitSingals():
	emit_signal("place_changed", curPlace)
	var test = curPosition()
	emit_signal("position_changed", curPosition())
	if curPlace == place.HOME:
		emit_signal("homePosition_changed", curPosition())
	

func curPlaceMax():
	match curPlace:
		place.HOME:
			return homePositions.size()-1
		place.WEB:
			return webPositions.size()-1
		place.WORK:
			return workPositions.size()-1
		
