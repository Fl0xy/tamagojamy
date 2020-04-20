extends Node2D

const speed = 1;

var target_x;
var moving = false;

func _ready():	
	var main = get_node("/root/Main")
	main.setPet(self)

func move_to_pos(pos):
	target_x = pos.x
	print("Pet moving to ", target_x)
	moving = true

func up_needs(key):
	pass
	
func _physics_process(delta):
	if moving:
		if target_x - position.x < speed:
			position.x = floor(target_x)
			moving = false
			return
		
		var new_x = floor(position.x + speed)
		print("Pet step to ", new_x)
		position.x = new_x
