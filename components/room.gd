extends Node2D

var active = false
onready var main = get_node("/root/Main")

func _ready():
	main.connect("change_Room", self, "change_Room")
	main.addRoom(self, main.PLACE.HOME)
	init_action_arrows()
	init_minigame()

func change_Room(room):
	if self == room:
		activate()
	else:
		deactivate()
	
func activate():
	active = true
	main.getPet().move_to_pos($pet_spos.global_position)

func deactivate():
	active = false

############### action arrow shit ###############
var action_arrows = {}
var action_arrow_index = 0
func init_action_arrows():
	find_action_arrows()
	if action_arrows.size() > 0:
		action_arrows[action_arrow_index].visible = true

func change_arrow_p():
	if action_arrows.size() == 1:
		return
	action_arrows[action_arrow_index].visible = false
	if action_arrow_index + 1 < action_arrows.size():
		action_arrow_index += 1
	else:
		action_arrow_index = 0
	action_arrows[action_arrow_index].visible = true
	
func change_arrow_m():
	if action_arrows.size() == 1:
		return
	action_arrows[action_arrow_index].visible = false
	if action_arrow_index - 1 >= 0:
		action_arrow_index -= 1
	else:
		action_arrow_index = action_arrows.size() -1
	action_arrows[action_arrow_index].visible = true

func find_action_arrows():
	for i in range(5):
		if has_node("a" + String(i)):
			action_arrows[i] = get_node("a" + String(i))
			action_arrows[i].visible = false
		else:
			break
	

################ input shit ##############
func _input(event):
	if !active || action_arrows.size() == 0:
		return
	if minigame.visible:
		return ### deactivate controls if minigame is active
	if event.is_action_pressed("ui_space"):
		if is_pet_on_screen():
			minigame.activate()
		return
	if event.is_action_pressed("ui_up"):
		change_arrow_p()
		return
	if event.is_action_pressed("ui_down"):
		change_arrow_m()
		return

############### minigame shit ##############
var minigame

func init_minigame():
	if !has_node("minigame"):
		return
	minigame = get_node("minigame")
	minigame.connect("game_finished", self, "minigame_finshed")

func minigame_finshed(state):
	if state:
		print("minigame gewonnen: ", minigame.key)
	else:
		print("minigame verloren")


############### helper shit ###############
func is_pet_on_screen():
	return floor(main.pet.position.x/51) == floor(position.x/51)
