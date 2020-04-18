extends Node2D

const roomSize = 51
const speed = 1;

var target_x;
var moving = false;

func _ready():	
	var main = get_node("/root/Main")
	main.connect("position_changed", self, "move_to_room")

func move_to_room(pos):
	target_x = pos.x + roomSize/2
	#var distance = abs(position - target_x)
	
	#step = (position.x + target_x / speed)
	print("Pet moving to ", target_x)
	moving = true
	
func _physics_process(delta):
	if moving:
		if target_x - position.x < speed:
			position.x = floor(target_x)
			moving = false
			return
		
		var new_x = floor(position.x + speed)
		print("Pet step to ", new_x)
		position.x = new_x
