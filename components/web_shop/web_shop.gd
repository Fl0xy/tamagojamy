extends Node2D

onready var main = get_node("/root/Main")
var active = false

func _ready():
	main.connect("change_Room", self, "change_Room")
	main.addRoom(self, main.PLACE.WEB)
	
func change_Room(room):
	if self == room:
		active = true
	else:
		active = false
		
func _input(event):
	if active:
		if event.is_action_pressed("ui_space"):
			main.exitWeb()
