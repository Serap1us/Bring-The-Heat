extends Node
class_name CustomerSpawner

@export var customerScene: PackedScene = preload("res://Customer/Customer.tscn")

# Spawner Settings
@export var spawnInterval: float = 10
@export var maxCustomers: int = 10 # max customers we can have in restaurant
@export var difficulty: float = 1.0 # increases over time

# counter positions
@export var counterPositions := [] : set = _set_counter_positions

# spawn position
@export var spawnPosition: Vector2 = Vector2(20, 300)

# tracking
var activeCustomers: Array[customerNPC] = []
@onready var spawnTimer: Timer = $SpawnTimer
#var nextCounterIdx: int = 0
var counterOccupancy: Dictionary = {}

# signals
signal customerArrived(customer: customerNPC, counterNode: Node)
signal customerleft(customer: customerNPC)

func _ready():
	spawnTimer.wait_time = spawnInterval
	spawnTimer.timeout.connect(_on_spawnTimer_timeout)
	spawnTimer.start(spawnInterval)


func _set_counter_positions(new_positions: Array):
	counterPositions = new_positions
	for counter in counterPositions:
		counterOccupancy[counter] = null

func _on_spawnTimer_timeout():
	if activeCustomers.size() < maxCustomers:
		spawnCustomer()

func hasAvailableCounter() -> bool:
	for customer in counterOccupancy.values():
		if customer == null:
			return true
	return false
	
func getAvailableCounter() -> Node:
	var availableCounters = []
	for counter in counterOccupancy:
		if counterOccupancy[counter] == null:
			availableCounters.append(counter)
	if availableCounters.size() > 0:
		return availableCounters[randi() % availableCounters.size()]
	return null
	
func spawnCustomer():
	var customer = customerScene.instantiate() as customerNPC
	
	#var counterNode = counterPositions[nextCounterIdx]
	#nextCounterIdx = (nextCounterIdx + 1) % counterPositions.size()
	
	var counterNode = getAvailableCounter()
	if counterNode == null:
		customer.queue_free()
		return
	
	# mark counter as occupied
	counterOccupancy[counterNode] = customer
	
	# setup the customer
	customer.position = spawnPosition
	customer.targetPosition = counterNode.global_position
	
	# adjust the patience based on difficulty
	customer.maxPatience = randf_range(
		max(5, (30 / difficulty)),
		max(7.5, (35 / difficulty))
	)
	
	# connect the signals
	customer.arrivedAtCounter.connect(
		_on_customerArrived.bind(customer, counterNode)
	)
	customer.order_completed.connect(
		_on_customerLeft.bind(customer, counterNode)
		)
	
	call_deferred("add_child", customer)
	activeCustomers.append(customer)
	spawnTimer.start(spawnInterval)


func _on_customerArrived(customer: customerNPC, counterNode: Node):
	customerArrived.emit(customer, counterNode)
	
	var orderTypes = ["patty", "chicken", "kebab", "pizza", "bread"]
	var orders = []
	
	var numOrders = randi_range(1, roundi(difficulty))
	
	# add random orders
	for i in range(numOrders):
		var randomOrder = orderTypes[randi() % orderTypes.size()]
		orders.append(randomOrder)
	customer.orderType = orders
	
func _on_customerLeft(customer: customerNPC, counterNode: Node, points: int):
	# free up the counter
	counterOccupancy[counterNode] = null
	activeCustomers.erase(customer)
	customerleft.emit(customer)


func changeDifficulty(amount: float):
	difficulty = amount
	maxCustomers = roundi(maxCustomers * amount)
	spawnInterval /= difficulty
