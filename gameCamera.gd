extends Camera2D

func _ready():
	var main = get_node("/root/Main")
	main.connect("change_Camera", self, "placeCamera")

func placeCamera(pos):
	print("placing Camera", pos)
	position = pos
