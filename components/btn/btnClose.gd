extends TextureButton

func _ready():
	if OS.get_name() == "HTML5" || OS.get_name() == "Android":
		visible = false
	else:
		connect("pressed", self, "_on_btnClose_pressed")


func _on_btnClose_pressed():
	get_tree().quit()
