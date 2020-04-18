extends Camera2D

func _ready():
	var main = get_node("/root/Main")
	main.connect("position_changed", self, "placeCamera")

func placeCamera(pos):
	print("placing", pos)
	position = pos
