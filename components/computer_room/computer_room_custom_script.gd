extends Node

onready var cr = get_parent()
onready var main = get_node("/root/Main")

var active = false

func _ready():
	main.connect("change_Room", self, "change_Room")
	$pc_start.connect("finished", self, "enter_web")
	main.connect("pet_added", self, "sw_action_button_visibility_init")
	
func change_Room(room):
	active = cr == room

func _input(event):
	if (active
	and event.is_action_pressed("ui_space")
	and is_pet_on_screen()
	and (main.pet.age == main.pet.AGE.CHILD
		or main.pet.age == main.pet.AGE.ADULT)):
		play_sound()
	
func play_sound():
	$pc_start.play()

func enter_web():
	main.enterWeb()

############### helper shit ###############
func is_pet_on_screen():
	return floor(main.pet.position.x/51) == floor(cr.position.x/51)

func sw_action_button_visibility_init(pet):
	pet.connect("age_changed", self, "sw_action_button_visibility")
	sw_action_button_visibility(pet.age)
	
func sw_action_button_visibility(age):
	var AGE = main.getPet().AGE
	match age:
		AGE.EGG:
			cr.get_node("arrow_down").visible = false
		AGE.CHILD:
			cr.get_node("arrow_down").visible = true
		AGE.ADULT:
			cr.get_node("arrow_down").visible = true
