extends Node

onready var e = get_parent()
onready var main = get_node("/root/Main")

var active = false

func _ready():
	main.connect("change_Room", self, "change_Room")
	$goto_work.connect("finished", self, "enter_web")
	call_deferred("arrow_down_hack")

func change_Room(room):
	active = e == room

func _input(event):
	if active:
		if event.is_action_pressed("ui_space"):
			if is_pet_on_screen() && main.pet.age == main.pet.AGE.ADULT:
				play_sound()
	
func play_sound():
	$goto_work.play()

func enter_web():
	main.enterWork()


############### helper shit ###############
func is_pet_on_screen():
	return floor(main.pet.position.x/51) == floor(e.position.x/51)

func arrow_down_hack():
	e.get_node("arrow_down").visible = false
