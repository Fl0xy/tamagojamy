extends Node2D

var mouse_entered = false
var following
var dragging_start_position

func _ready():
	if OS.get_name() == "HTML5" || OS.get_name() == "Android":
		return
	$rightEar.connect("mouse_entered", self, "mouse_entered")
	$rightEar.connect("mouse_exited", self, "mouse_exited")
	$leftEar.connect("mouse_entered", self, "mouse_entered")
	$leftEar.connect("mouse_exited", self, "mouse_exited")
	$Timer.connect("timeout", self, "window_hack_stuff")

func mouse_entered():
	mouse_entered = true
	$Timer.stop()
	
func mouse_exited():
	mouse_entered = false
	$Timer.wait_time = 1
	$Timer.start()
	
func window_hack_stuff():
	following = false

func _input(event):
	if not mouse_entered:
		return
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			following = !following
			dragging_start_position = get_local_mouse_position()

func _process(_delta):
	if following:
		OS.set_window_position(OS.window_position + get_global_mouse_position() - dragging_start_position)
