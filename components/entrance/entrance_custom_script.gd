extends Node

onready var e = get_parent()
onready var main = get_node("/root/Main")

var active = false

func _ready():
	main.connect("change_Room", self, "change_Room")
	$goto_work.connect("finished", self, "enter_web")
	
func change_Room(room):
	active = e == room

func _input(event):
	if active:
		if event.is_action_pressed("ui_space"):
			play_sound()
	
func play_sound():
	$goto_work.play()

func enter_web():
	main.enterWork()
