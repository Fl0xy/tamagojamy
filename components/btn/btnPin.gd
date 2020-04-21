extends TextureButton

func _ready():
	if OS.get_name() == "HTML5":
		visible = false
	else:
		connect("toggled", self, "_on_btnPin_toggled")


func _on_btnPin_toggled(v):
	OS.set_window_always_on_top(v)
