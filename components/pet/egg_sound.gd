extends Node

onready var parent = get_parent()

func _ready():
	parent.connect("frame_changed", self, "frame_changed")

func frame_changed():
	if parent.frame == 0 && parent.visible:
		$player.play()
