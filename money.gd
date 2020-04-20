extends Label

var money = 0
onready var main = get_node("/root/Main")

func _ready():
	main.moneyobj = self

func set_money(new_money):
	money = new_money
	text = String(new_money)+"M"

func get_money():
	return money
