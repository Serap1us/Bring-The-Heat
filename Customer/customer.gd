#extends Area2D
extends Interactable
class_name customerNPC

# Scenes
@export var patienceBarScene: PackedScene = preload("res://Customer/Patience/patiencebar.tscn")
@export var orderBubbleScene: PackedScene = preload("res://Customer/Ordering/OrderBubble.tscn")
######
# npc attributes
@export var maxMovespeed: float = 150.00
@export var maxPatience: float = 30.00 # 30 seconds patience
@export var basePoints: int = 200

## Is he at the counter?
var atCounter: bool = false
var targetPosition: Vector2

## What am I ordering?
var orderTaken: bool = false
#var orderType: String = ""  # "burger"
var orderType: Array = []  # ["burger", "fries"]

## Patience System:
var currentPatience: float 
@export var patienceBar: PatienceBar
@export var order_bubble: OrderBubble

# Signals
signal order_completed(points: int)
signal arrivedAtCounter
signal order_taken(order_type: String)

func _ready():
	super._ready()
	
	interact_label = "Take Order"
	interact_type = "customer"
	
	currentPatience = maxPatience
	patienceBar.maxValue = maxPatience
	patienceBar.updatePatience(currentPatience)

func _process(delta):
	if !atCounter:
		_moveTowardTarget(delta)
	else:
		if currentPatience > 0:
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
		if targetPosition == Vector2(632,818):
			queue_free()
		atCounter = true
		patienceBar.visible = true
		arrivedAtCounter.emit()
	

#func execute(player: Player):
	#if atCounter and !orderTaken and orderType != "":
		#var order = takeOrder()
		#if order != "":
			#order_bubble.showOrder(orderType)
			#interact_label = "Waiting for " + orderType

func execute(player: Player):
	if atCounter and !orderTaken and !orderType.is_empty():
		var order = takeOrder()
		if !order.is_empty():
			order_bubble.showOrder(orderType)
			#interact_label = "Waiting for " + orderType
			# make readable string
			var orderString = ""
			for i in range(orderType.size()):
				if i > 0:
					orderString += " and "
				orderString += orderType[i]
			interact_label = "waiting for " + orderString
	
	## Actually giving them the food
	elif orderTaken and player.hasFood():
		var foodType = player.getCurrentFood()           # remember to amke a getter for the currentFood we are holding
		
		if receiveFood(foodType):
			player.removeFood()
			
			# are there orders left?
			if !orderType.is_empty():
				var orderString = ""
				for i in range(orderType.size()):
					if i > 0:
						orderString += " and "
					orderString += orderType[i]
				interact_label = "waiting for " + orderString
			else:
				interact_label = "order complete"

	
## PLAYER CALLS THIS FUNCTION WHEN INTERACTING WITH CUSTOMER
func takeOrder() -> Array:
	# customers order has been taken
	if !orderTaken and atCounter and !orderType.is_empty():
		orderTaken = true
		order_taken.emit(orderType)
		return orderType
	return []
	

func receiveFood(foodType: Ingredient) -> bool:
	print(foodType.interact_label.to_lower())
	if foodType.interact_label.to_lower() in orderType and orderTaken and foodType.is_cooked:
		orderType.erase(foodType.interact_label.to_lower()) # remove the received food from the order array
		
		# all orders completed?
		if orderType.is_empty():
			orderCompleted(true)
		return true
	else: 
		# giving the wrong food
		currentPatience -= maxPatience * 0.25
		patienceBar.updatePatience(currentPatience)
		if currentPatience <= 0:
			_leaveAngry()
		return false

	# do we want to stop patience drain or slow it down while they wait for food

func orderCompleted(points: int):
		print("customer sastified")
		order_completed.emit(calculatePoints())
		get_parent().get_parent().curr_score = calculatePoints()
		targetPosition = Vector2(632,818)
		atCounter = false

func calculatePoints():
	var points = basePoints
	
	# scaling down the points
	if currentPatience < maxPatience * 0.5:
		var ratio = (currentPatience / maxPatience) * 2
		points = roundi(basePoints * ratio)
	return points


func _leaveAngry(): 
	print("customer left")
	LivesCounter.lives -= 1
	print(LivesCounter.lives)
	atCounter = false
	patienceBar.visible = false
	order_bubble.visible = false
	targetPosition = Vector2(632,818)
	
