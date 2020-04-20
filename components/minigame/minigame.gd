extends Node2D

enum STATES {NONE, START, RUNNIG_RIGHT, RUNNIG_LEFT, FINISHED} 

const minPos = 10
const maxPos = 38
const finished_timer = 2
const start_timer = 1

var speed
var timer
var state
var curPos

onready var arrow = $arrow
onready var target = $target

signal game_finished(state)
signal game_show()

export(bool) var playWin = true
export(bool) var playLose = true

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
			if (playWin):
				$win.play()
			emit_signal("game_finished", true)
		else:
			if (playLose):
				$lose.play()
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
	arrow.position.x = minPos
	

func activate():
	timer = start_timer
	curPos = arrow.position.x
	visible = true
	speed = randf()
	state = STATES.START
	emit_signal("game_show")
