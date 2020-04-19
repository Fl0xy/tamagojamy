extends Node2D

enum STATES {NONE, START, RUNNIG_RIGHT, RUNNIG_LEFT, FINISHED} 

const minPos = 8
const maxPos = 36
const finished_timer = 2
const start_timer = 1

var speed
var timer
var state
var curPos

onready var arrow = $arrow
onready var target = $target

signal game_finished(state)
signal game_visibilty_changed(state)

func _ready():
	visible = false
	state = STATES.NONE
	
func _process(delta):
	if state == STATES.NONE:
		return
	
	if Input.is_action_just_pressed("ui_space") && (state == STATES.RUNNIG_LEFT || state == STATES.RUNNIG_RIGHT):
		state = STATES.FINISHED
		timer = finished_timer
		if arrow.position.x >= target.position.x && arrow.position.x < (target.position.x + 7):
			emit_signal("game_finished", true)
		else:
			emit_signal("game_finished", false)
		
	
	match state:
		STATES.START:
			if timer < 0:
				state = STATES.RUNNIG_RIGHT
			else:
				timer = timer - delta
		STATES.RUNNIG_RIGHT:
			if (curPos + speed) > maxPos:
				state = STATES.RUNNIG_LEFT
			else:
				curPos = curPos + speed
				arrow.position.x = floor(curPos)
		STATES.RUNNIG_LEFT:
			if (curPos - speed) < minPos:
				state = STATES.RUNNIG_RIGHT
			else:
				curPos = curPos - speed
				arrow.position.x = ceil(curPos)
		STATES.FINISHED:
			if timer < 0:
				deactivate()
			else:
				timer = timer - delta

func deactivate():
	state = STATES.NONE
	visible = false
	emit_signal("game_visibilty_changed", false)
	arrow.position.x = minPos
	

func activate():
	timer = start_timer
	curPos = arrow.position.x
	visible = true
	speed = randf()
	emit_signal("game_visibilty_changed", true)
	state = STATES.START
