extends Node2D

var active = false
onready var main = get_node("/root/Main")

func _ready():
	main.connect("change_Room", self, "change_Room")
	
func change_Room(roombase):
	var test = $RoomBase
	if test == roombase:
		activate()
	else:
		deactivate()
	
func activate():
	active = true
	main.getPet().move_to_pos($pet_spos.global_position)

func deactivate():
	active = false
