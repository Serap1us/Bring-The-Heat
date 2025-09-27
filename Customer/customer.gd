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
@export var patienceBar: PatienceBar

# Signals
signal order_completed(success: bool)
signal arrivedAtCounter
signal order_taken(order_type: String)

func _ready():
	currentPatience = maxPatience
	patienceBar.maxValue = maxPatience
	patienceBar.updatePatience(currentPatience)

func _process(delta):
	if !atCounter:
		_moveTowardTarget(delta)
	else:
		if currentPatience > 0 and !orderTaken:
			currentPatience -= delta
			patienceBar.updatePatience(currentPatience)
			
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
		
## PLAYER CALLS THIS FUNCTION WHEN INTERACTING WITH CUSTOMER
func takeOrder() -> String:
	# customers order has been taken
	if !orderTaken and atCounter and orderType != "":
		orderTaken = true
		order_taken.emit(orderType)
		return orderType
	return ""
	

func receiveFood(foodType: String) -> bool:
	if foodType == orderType and orderTaken:
		orderCompleted(true)
		return true
	else: 
		# giving the wrong food
		currentPatience -= 2.5
		patienceBar.updatePatience(currentPatience)
		return false

	# do we want to stop patience drain or slow it down while they wait for food

func orderCompleted(success: bool):
	# order fullfilled (or failed)
	order_completed.emit(self, success)
	
	if success:
		print("customer sastified" + orderType)
	else:
		_leaveAngry()

func _leaveAngry():
	print("customer left")
	queue_free()
