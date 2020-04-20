extends Node2D

export(int, "YES", "NO" ) var Back
export(int, "YES", "NO") var Ceiling
export(int, "YES", "NO") var Floor
export(int, "YES", "NO") var Left
export(int, "YES", "NO") var Right
export(int, "HOME", "WEB", "WORK") var place


func _ready():
	back_visibility(Back == 0)
	ceiling_visibility(Ceiling == 0)
	floor_visibility(Floor == 0)
	left_visibility(Left == 0)
	right_visibility(Right == 0)
	
	
func back_visibility(value):
	$back.visible = value
	
func ceiling_visibility(value):
	$ceiling.visible = value
	
func floor_visibility(value):
	$floor.visible = value
	
func left_visibility(value):
	$left.visible = value

func right_visibility(value):
	$right.visible = value
