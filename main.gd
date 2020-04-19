extends Node

enum PLACE {HOME, WEB, WORK}
var rooms = {}

var curPlace = PLACE.HOME;
var curIndex = 0

signal change_Camera(new_pos)
signal change_Room(new_pos)

#################### room shit ####################
func addRoom(room, place):
	if !rooms.has(place):
		rooms[place] = []
	rooms[place].append(room)
	rooms[place].sort_custom(self, "sort_Room")

func curRoom():
	return rooms[curPlace][curIndex]
	
#################### pet shit ####################
var pet
func setPet(_pet):
	pet = _pet

func getPet():
	return pet

#################### web shit ####################
var webEntryPlace
var webEntryIndex
func enterWeb():
	webEntryIndex = curIndex;
	webEntryPlace = curPlace;
	curPlace = PLACE.WEB
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
	curPlace = PLACE.WORK
	curIndex = 0
	emitSingals()
	
func exitWork():
	curPlace = workEntryPlace
	curIndex = workEntryIndex
	emitSingals()

#################### logic shit ####################
func _ready():
	get_tree().get_root().set_transparent_background(true)
	call_deferred("emitSingals")

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
	emit_signal("change_Camera", curRoom().global_position)
	emit_signal("change_Room", curRoom())

func curPlaceMax():
	return rooms[curPlace].size()-1
		
static func sort_Room(a, b):
	return a.position.x < b.position.x
