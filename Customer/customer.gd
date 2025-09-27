extends Area2D
class_name  customerNPC

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
signal leaveAngry

func ready():
	currentPatience = maxPatience
	
	# create the patience bar
	patienceTimer = Timer.new()
	patienceTimer.wait_time = 1.0
	patienceTimer.timeout.connect(_leaveAngry)
	add_child(patienceTimer)

func _physics_process(delta: float) -> void:
	currentPatience = $PatienceTimer.time_left

func _updatePatienceBar():
	pass

func _leaveAngry():
	leaveAngry.emit()
