extends Node2D

enum AGE {EGG, CHILD, ADULT}
signal age_changed(age)


export var EGG_DURATION = 30
export var CHILD_DURATION = 180
export var ADULT_DURATION = -INF

var age = AGE.EGG setget set_age
onready var time_until_aging = EGG_DURATION

func set_age(v):
	if not AGE.has(v):
		push_error("age set to a non AGE value")
	age = v
	match age:
		AGE.EGG:
			time_until_aging = EGG_DURATION
			show_egg_graphics()
		AGE.CHILD:
			time_until_aging = CHILD_DURATION
			show_child_graphics()
		AGE.ADULT:
			self.hunger_rate = 1
			self.energy_burn_rate = 1
			self.dirty_rate = 1
			self.food_conversion_rate = 1
			self.fun_rate = 1
			time_until_aging = ADULT_DURATION
			show_adult_graphics()


func age(delta):
	if time_until_aging < 0:
		return
		
	time_until_aging = clamp(time_until_aging - delta, 0, INF)
	if time_until_aging == 0:
		match age:
			AGE.CHILD:
				self.age = AGE.ADULT
			AGE.EGG:
				self.age = AGE.CHILD
		emit_signal("age_changed", self.age)
		$Audio/Age.play()

var alive = true
var health = 100 setget set_health
func set_health(v): health = clamp(v, 0, 100)

func die():
	alive = false
	hide_all_emotions()
	show_dead_graphics()
	$Audio/Death.play()

##### needs #####
export var fullness = 80 setget set_fullness
export var energy = 100 setget set_energy
export var cleanliness = 0 setget set_cleanliness
export var guts = 50 setget set_guts
export var fun = 100 setget set_fun

func set_fullness(v): fullness = clamp(v, 0, 100)
func set_energy(v): energy = clamp(v, 0, 100)
func set_cleanliness(v): cleanliness = clamp(v, 0, 100)
func set_guts(v): guts = clamp(v, 0, 100)
func set_fun(v): fun = clamp(v, 0, 100)

export var hunger_rate = 2
export var energy_burn_rate = 2
export var dirty_rate = 2
export var food_conversion_rate = 2
export var fun_rate = 2

export var fullness_limit = 30
export var energy_limit = 30
export var cleanliness_limit = 30
export var guts_limit = 50
export var fun_limit = 10

export var fullness_health_weight = 1.0
export var energy_health_weight = 1.0
export var cleanliness_health_weight = 1.0
export var guts_health_weight = 1.0
export var fun_health_weight = 1.0


func is_hungry():
	return fullness < fullness_limit

func is_sleepy():
	return energy < energy_limit
	
func is_dirty():
	return cleanliness < cleanliness_limit
	
func is_toiletty():
	return guts > guts_limit

func is_bored():
	return fun < fun_limit

func hide_all_emotions():
	for node in $Emotions.get_children():
		node.hide()

func show_emotions():
	hide_all_emotions()
	if is_dirty():
		$Emotions/Dirty.show()
	if is_bored():
		$Emotions/BoredSporty.show()
	if is_sleepy():
		$Emotions/Sleepy.show()
	if is_hungry():
		$Emotions/Hunger.show()
		
	if is_toiletty():
		$Emotions/Toilett.show()


func hide_all_graphics():
	for node in $Graphics.get_children():
		node.visible = false


func show_egg_graphics():
	hide_all_graphics()
	$Graphics/Egg.visible = true


func show_child_graphics():
	hide_all_graphics()
	$Graphics/Child.visible = true


func show_adult_graphics():
	hide_all_graphics()
	$Graphics/Adult.visible = true


func show_dead_graphics():
	hide_all_graphics()
	$Graphics/Dead.visible = true


export var speed = 1;

var target_x;
var moving = false;

func _ready():	
	var main = get_node("/root/Main")
	main.setPet(self)

func move_to_pos(pos):
	target_x = pos.x
	print("Pet moving to ", target_x)
	moving = true

### communcation with level #####
func can_do(key):
	match key:
		"shit":
			return is_toiletty()
		"eat":
			return is_hungry() and not is_toiletty()
		"sleep":
			return is_sleepy() and not is_hungry() and not is_toiletty()
		"train":
			return is_bored() and not is_sleepy() and not is_hungry() and not is_toiletty()
		"clean":
			return is_dirty() and not is_bored() and not is_sleepy() and not is_hungry() and not is_toiletty()

func action(key, state):
	self.energy -= 5 #action cost
	if not state: return
	match key:
		"shit":
			self.guts = 0
		"eat":
			self.fullness = 100
		"sleep":
			self.energy = 100
		"train":
			self.fun = 100
		"clean":
			self.cleanliness = 100
	
#################################



func _physics_process(delta):
	if not alive: return
	if age != AGE.EGG: 
		#### movement ####
		if moving:
			var dif_pos = target_x - position.x
			if abs(dif_pos) < speed:
				position.x = floor(target_x)
				moving = false
				return
			
			var new_x = floor(position.x + sign(dif_pos) * speed)
			print("Pet step to ", new_x)
			position.x = new_x
		
		##### update_needs #####
		self.fullness -= hunger_rate * delta
		self.energy -= energy_burn_rate * delta 
		self.cleanliness -= dirty_rate * delta #context
		self.guts += food_conversion_rate * fullness/100 * delta
		self.fun -= fun_rate * delta
		##### update health ####
		var a = sign(fullness - fullness_limit) * fullness_health_weight
		var b = sign(energy - energy_limit) * energy_health_weight
		var c = sign(cleanliness - cleanliness_limit) * cleanliness_health_weight
		var d = -sign(guts - guts_limit) * guts_health_weight
		var e = sign(fun - fun_limit) * fun_health_weight
		self.health += (a + b + c + d + e) * delta
		if health == 0:
			die()
		else:
			show_emotions()
		
	##### aging ####
	age(delta)
	#print(time_until_aging, " ", age)
	#print("hp: ", int(health), " full: ", int(fullness), " ener: ", int(energy), " clean: ", int(cleanliness), " guts: ", int(guts), " fun: ", int(fun))
