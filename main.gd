extends Node2D

func _ready():
	$CustomerSpawner.counterPositions = [
		$Counters/Counter1,
		$Counters/Counter2,
		$Counters/Counter3
	]
	
	$CustomerSpawner.spawnPosition = $SpawnPoint.global_position
	
	# just for debuggin
	$CustomerSpawner.customerArrived.connect(
		func(customer, counterIdx): print("customer arrived at counter %d" % (counterIdx + 1))
	)
	$CustomerSpawner.customerleft.connect(
		func(customer, happy): print("customer left, happy: %s" % happy)
	)
