extends Node2D

signal arrow_pressed(key)

export(String) var key

func _ready():
	pass

func _on_TextureButton_pressed():
	if visible:
		emit_signal("arrow_pressed", key)

