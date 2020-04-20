extends Node2D

const money_per_Timer_tick = 1
const timer_tick_time = 1

var active = false
onready var main = get_node("/root/Main")

var pet_old_position
var pet

func _ready():
	main.connect("change_Room", self, "change_Room")
	main.addRoom(self, main.PLACE.WORK)
	$Timer.set_wait_time(timer_tick_time)
	$Timer.connect("timeout", self, "_on_Timer_timeout")
	
func _input(event):
	if active:
		if event.is_action_pressed("ui_space"):
			main.exitWork()
	
func change_Room(room):
	if self == room:
		activate()
	else:
		deactivate()
	
func activate():
	active = true
	$key1.play()
	$key2.play()
	$bg.play()
	$Timer.start()
	#### hacki teleporting ####
	pet = main.getPet()
	pet_old_position = pet.position
	var new_pos = Vector2()
	new_pos.y = position.y + 51 - 11
	new_pos.x = floor((position.x + 51)/2 - (9/2))
	pet.position = new_pos

func deactivate():
	active = false
	$key1.stop()
	$key2.stop()
	$bg.stop()
	$Timer.stop()
	#### hacki teleporting ####
	if pet != null && pet_old_position != null:
		pet.position = pet_old_position
		pet = null


func _on_Timer_timeout():
	main.moneyobj.set_money(main.moneyobj.get_money() + money_per_Timer_tick)
