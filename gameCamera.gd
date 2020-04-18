extends Camera2D


var Max = 3;
var Min = 0;
var cur = 0;
var step = 51;

func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		if cur < Max:
			cur = cur+1
			placeCamera()
			return
		cur = Min
		placeCamera()
		return
		
	if Input.is_action_just_pressed("ui_left"):
		if cur > Min:
			cur = cur-1
			placeCamera()
			return
		cur = Max
		placeCamera()
		return

func placeCamera():
	print("placing", step*cur)
	position = Vector2(step*cur, 0) 
