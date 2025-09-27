extends Area2D
class_name  customerNPC

######
# npc spawns in and goes to dedicated location

# npc attributes
@export var maxMovespeed: float = 150.00
@export var maxPatience: float = 30.00 # 30 seconds patience

## Is he at the counter?
var atCounter: bool = false
var targetPosition: Vector2

## What am I ordering?
var orderTaken: bool = false
var orderType: String = ""  # "burger"

## Patience System:
var currentPatience: float 
var patienceTimer: Timer
var patienceBar: ProgressBar

# Signals
signal orderCompleted(success: bool)
signal arrivedAtCounter

func ready():
	currentPatience = maxPatience
	
	# create the patience bar
	patienceTimer = Timer.new()
	patienceTimer.wait_time = 1.0
	patienceTimer.timeout.connect(_decreasePatience)
	add_child(patienceTimer)
	
func _decresePatience():
	currentPatience -= 1
	_updatePatienceBar()
	
	if currentPatience <= 0:
		_leaveAngry()
		
func _updatePatienceBar():
	pass

func _decreasePatience():
	pass

func _leaveAngry():
	pass
