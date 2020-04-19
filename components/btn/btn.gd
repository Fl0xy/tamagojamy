extends TextureButton

var toggle = false;
export(String) var InputEventCode

func _ready():
	pass # Replace with function body.

func _process(delta):
	if toggle:
		toggle_btn(InputEventCode, false)


func _on_btn_pressed():
	toggle_btn(InputEventCode, true)


func toggle_btn(action, state):
	print(InputEventCode, state)
	var ev = InputEventAction.new()
	ev.action = action
	ev.pressed = state
	Input.parse_input_event(ev)
	toggle = state;


func _on_btnSpace_pressed():
	pass # Replace with function body.
