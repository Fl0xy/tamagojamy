extends Node2D

var active = false
onready var main = get_node("/root/Main")

func _ready():
	main.connect("change_Room", self, "change_Room")
	main.addRoom(self, main.PLACE.WORK)
	
func _input(event):
	if active:
		if event.is_action_pressed("ui_space"):
			main.exitWork()
	
func change_Room(room):
	if self == room:
		activate()
	else:
		deactivate()
	
func activate():
	active = true
	$key1.play()
	$key2.play()
	$bg.play()

func deactivate():
	active = false
	$key1.stop()
	$key2.stop()
	$bg.stop()
