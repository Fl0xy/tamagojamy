extends Node2D

var active = false
var action_arrow
onready var main = get_node("/root/Main")

func _ready():
	main.connect("change_Room", self, "change_Room")
	main.addRoom(self, main.PLACE.HOME)
	init_minigame()
	if has_node("a0"): 
		action_arrow = $a0
		main.connect("pet_added", self, "sw_action_button_visibility_init")

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

################ input shit ##############
func _input(event):
	if not active || action_arrow == null || minigame.visible:
		return
	if event.is_action_pressed("ui_space"):
		if is_pet_on_screen():
			minigame.activate()
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
	
func sw_action_button_visibility_init(pet):
	pet.connect("age_changed", self, "sw_action_button_visibility")
	sw_action_button_visibility(pet.age)
	
func sw_action_button_visibility(age):
	var AGE = main.getPet().AGE
	match age:
		AGE.EGG:
			action_arrow.visible = false
		AGE.CHILD:
			continue
		AGE.ADULT:
			action_arrow.visible = true
