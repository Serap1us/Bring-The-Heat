
func get_available_counter() -> Node:
	# Get all available counters
	var available_counters = []
	for counter in counterOccupancy:
		if counterOccupancy[counter] == null:
			available_counters.append(counter)
	
	# Return a random available counter
	if available_counters.size() > 0:
		return available_counters[randi() % available_counters.size()]
	
	return null
	
func spawnCustomer():
	var customer = customerScene.instantiate() as customerNPC
	
	var counter = get_available_counter()
	if counter == null:
		customer.queue_free()
		return
	
	# Mark counter as occupied
	counterOccupancy[counter] = customer
	
	# setup the customer
	customer.position = spawnPosition
	customer.targetPosition = counter.global_position
	
	# adjust the patience based on difficulty?
	customer.maxPatience = randf_range(15 - (difficulty * 0.2), 15 + (difficulty * 0.2))
	
	# connect the signals
	customer.arrivedAtCounter.connect(
		_on_customerArrived.bind(customer, counter)
	)
	customer.order_completed.connect(_on_customerLeft.bind(counter))
	
	call_deferred("add_child", customer)
	activeCustomers.append(customer)
	
func _on_customerArrived(customer: customerNPC, counter: Node):
	customerArrived.emit(customer, counter)
	
	var orderTypes = ["burger", "fries", "soda", "chicken"]
	var randomOrder = orderTypes[randi() % orderTypes.size()]
	customer.orderType = randomOrder

func _on_customerLeft(happy: bool, customer: customerNPC, counter: Node):
	# Free up the counter
	counterOccupancy[counter] = null
	
	# Remove from active customers
	activeCustomers.erase(customer)
	
	# Emit the signal
	customerleft.emit(customer, happy)
