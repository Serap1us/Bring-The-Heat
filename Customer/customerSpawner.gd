extends Node
class_name CustomerSpawner

@export var customerScene: PackedScene = preload("res://Customer/Customer.tscn")

# Spawner Settings
@export var spawnInterval: float = 5.0
@export var maxCustomers: int = 5 # max custoemrs we have in restaurant
@export_range(0, 100) var difficulty: float = 0.0 # increases over time

# counter positions
@export var counterPositions := [] : set = _set_counter_positions

# spawn position
@export var spawnPosition: Vector2 = Vector2(20, 300)

# tracking
var activeCustomers: Array[customerNPC] = []
@onready var spawnTimer: Timer = $SpawnTimer
#var nextCounterIdx: int = 0
var counterOccupancy: Dictionary = {}

# maybe add stats for happy/angry customers

# signals
signal customerArrived(customer: customerNPC, counterNode: Node)
signal customerleft(customer: customerNPC, happy: bool)

func _ready():
	spawnTimer.wait_time = spawnInterval
	spawnTimer.timeout.connect(_on_spawnTimer_timeout)
	spawnTimer.start()


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
	
	# adjust the patience based on difficulty?
	customer.maxPatience = randf_range(15 - (difficulty * 0.2), 15 + (difficulty * 0.2))
	
	# connect the signals
	customer.arrivedAtCounter.connect(
		_on_customerArrived.bind(customer, counterNode)
	)
	customer.order_completed.connect(_on_customerLeft.bind(counterNode))
	
	call_deferred("add_child", customer)
	activeCustomers.append(customer)
	
func _on_customerArrived(customer: customerNPC, counterNode: Node):
	customerArrived.emit(customer, counterNode)
	
	var orderTypes = ["burger", "fries", "soda", "chicken"]
	var randomOrder = orderTypes[randi() % orderTypes.size()]
	customer.orderType = randomOrder
	
func _on_customerLeft(customer: customerNPC, happy: bool, counterNode: Node):
	# free up the counter
	counterOccupancy[counterNode] = null

	activeCustomers.erase(customer)
	customerleft.emit(customer, happy)
	
## maybe a difficulty increase
func increaseDifficulty(amount: float):
	difficulty += amount
	spawnTimer.wait_time = max(1.0, spawnInterval - (difficulty * 0.05))
	
