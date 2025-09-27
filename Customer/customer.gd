extends Area2D
class_name customerNPC

# Scenes
@export var patienceBarScene: PackedScene = preload("res://Customer/Patience/patiencebar.tscn")

######
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
var patienceBarInstance: PatienceBar

# Signals
signal order_completed(success: bool)
signal arrivedAtCounter

func ready():
	currentPatience = maxPatience
	
	# create patience bar
	patienceBarInstance = patienceBarScene.instantiate()
	add_child(patienceBarInstance)
	
	patienceBarInstance.position = Vector2(-20, -40)
	patienceBarInstance.updatePatience(currentPatience, maxPatience)

func _process(delta):
	if !atCounter:
		_moveTowardTarget(delta)
	else:
		if currentPatience > 0 and !orderTaken:
			currentPatience -= delta
			patienceBarInstance.updatePatience(currentPatience, maxPatience)
			
			if currentPatience <= 0:
				_leaveAngry()

func _moveTowardTarget(delta):
	var direction = (targetPosition - global_position).normalized()
	var velocity = direction * maxMovespeed
	
	# move toward the target
	global_position += velocity * delta
	
	# check are we at counter?
	if global_position.distance_to(targetPosition) < 5.0:
		atCounter = true
		arrivedAtCounter.emit()
		
func takeOrder(type: String):
	# customers order has been taken
	orderType = type
	orderTaken = true
	
	# do we want to stop patience drain or slow it down while they wait for food

func orderCompleted(success: bool):
	# order fullfilled (or failed)
	order_completed.emit(success)
	
	if success:
		print("customer sastified")
	else:
		_leaveAngry()

func _leaveAngry():
	pass
