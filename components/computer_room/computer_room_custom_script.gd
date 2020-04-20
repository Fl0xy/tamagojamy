extends Node

onready var cr = get_parent()
onready var main = get_node("/root/Main")

var active = false

func _ready():
	main.connect("change_Room", self, "change_Room")
	$pc_start.connect("finished", self, "enter_web")
	
func change_Room(room):
	active = cr == room

func _input(event):
	if active:
		if event.is_action_pressed("ui_space"):
			play_sound()
	
func play_sound():
	$pc_start.play()

func enter_web():
	main.enterWeb()
